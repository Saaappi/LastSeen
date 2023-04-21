local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local coloredDash = "|cffFFD100-|r "
local icon = ""

function LastSeen:MinimapIcon(bool)
	LastSeenDB.MinimapIconEnabled = bool
	if bool then
		if icon ~= "" then
			icon:Show(addonName)
		else
			icon = LibStub("LibDBIcon-1.0")
			-- Create a Lib DB first to hold all the
			-- information for the minimap icon.
			local iconLDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(addonName, {
				type = "launcher",
				icon = "1394950", -- Cache of the Amathet (Item)
				OnTooltipShow = function(tooltip)
					tooltip:SetText(addonName .. " |cffFFFFFF" .. GetAddOnMetadata(addonName, "Version") .. "|r")
					tooltip:AddLine("|cffFFFFFFClick to open the Settings for " .. addonName .. ".|r")
					tooltip:Show()
				end,
				OnClick = function() LastSeen:SlashCommandHandler("") end,
			})
			
			-- Register the minimap button with the
			-- LDB.
			icon:Register(addonName, iconLDB, LastSeenDB)
			icon:Show(addonName)
		end
	else
		if icon ~= "" then
			icon:Hide(addonName)
		end
	end
end

local mainOptions = {
	name = addonName,
	handler = LastSeen,
	type = "group",
	args = {
		General_Tab = {
            name = "General",
			desc = "Modify general settings for the addon like toggling functionality and the minimap icon.",
            type = "group",
            order = 1,
            args = {
				Enable = {
					name = "Enable",
					order = 1,
					desc = "Toggle addon functionality.",
					type = "toggle",
					get = function(info) return LastSeenDB.Enabled end,
					set = function(info, val) LastSeenDB.Enabled = val end,
				},
				MinimapIcon = {
					name = "Minimap Icon",
					order = 2,
					desc = "Toggle the minimap icon.",
					type = "toggle",
					get = function(info) return LastSeenDB.MinimapIconEnabled end,
					set = function(info, val) LastSeen:MinimapIcon(val) end,
				},
				Mode_Dropdown = {
					name = "Mode",
					order = 3,
					desc = "Select the output mode for " .. addonName .. ".\n\n" ..
					"|cffFFD100Silent|r: No output is sent to the chat window.\n" ..
					"|cffFFD100Normal|r: All output for both NEW and UPDATED items is sent to the chat window.\n" ..
					"|cffFFD100Only New|r: Only output related to NEW items is sent to the chat window.\n" ..
					"|cffFFD100Updates (Once Per Day)|r: New items and items that haven't updated for the current day are sent to the chat window.",
					type = "select",
					style = "dropdown",
					values = {
						[0] = "Silent",
						[1] = "Normal",
						[2] = "Only New",
						[3] = "Updates (Once Per Day)",
					},
					sorting = {
						[1] = 0, 	-- Silent
						[2] = 1, 	-- Normal
						[3] = 2, 	-- Only New
						[4] = 3, 	-- Updates (Once Per Day)
					},
					get = function()
						if not LastSeenDB.modeID then
							LastSeenDB.modeID = 1
						end
						return LastSeenDB.modeID
					end,
					set = function(_, modeID) LastSeenDB.modeID = modeID end,
				},
				DateFormat_Dropdown = {
					name = "Date Format",
					order = 4,
					desc = "Select the date format for the loot date. Selecting a new date format will automatically convert the existing dates to the new format.\n\n" ..
					"m/d/y - 12/25/2023\n" ..
					"d/m/y - 25/12/2023\n" ..
					"y/m/d - 2023/12/25",
					type = "select",
					style = "dropdown",
					values = {
						["%m/%d/%Y"] = "m/d/y",
						["%d/%m/%Y"] = "d/m/y",
						["%Y/%m/%d"] = "y/m/d",
					},
					sorting = {
						[1] = "%m/%d/%Y",
						[2] = "%d/%m/%Y",
						[3] = "%Y/%m/%d",
					},
					get = function()
						if not LastSeenDB.DateFormat then
							LastSeenDB.DateFormat = "%m/%d/%Y"
						end
						return LastSeenDB.DateFormat
					end,
					set = function(_, dateFormat)
						-- Setup a few variables for later use.
						local currentDate, currentTime, newDate
						
						-- Iterate over the item table and get the existing loot date.
						-- Get the current date format, which is what the loot dates will be
						-- formatted in, then convert it to the new format.
						for _, item in pairs(LastSeenDB.Items) do
							currentDate = item.lootDate
							if LastSeenDB.DateFormat == "%Y/%m/%d" then
								currentTime = time{ year = tonumber(currentDate:sub(1,4)), month = tonumber(currentDate:sub(6,7)), day = tonumber(currentDate:sub(9,10)) }
							elseif LastSeenDB.DateFormat == "%d/%m/%Y" then
								currentTime = time{ day = tonumber(currentDate:sub(1,2)), month = tonumber(currentDate:sub(4,5)), year = tonumber(currentDate:sub(7,10)) }
							else
								currentTime = time{ month = tonumber(currentDate:sub(1,2)), day = tonumber(currentDate:sub(4,5)), year = tonumber(currentDate:sub(7,10)) }
							end
							newDate = date(dateFormat, currentTime)
							item.lootDate = newDate
						end
						
						-- Set the date format to the new format.
						LastSeenDB.DateFormat = dateFormat
					end,
				},
            },
        },
		Filters_Tab = {
            name = "Filters",
			desc = "Toggle item filters to personalize the items you want to track.",
            type = "group",
            order = 2,
            args = {
				Rarity_Dropdown = {
					name = "Rarity",
					order = 1,
					desc = "Select the lowest rarity of an item that " .. addonName .. " should process.\n\n" ..
					"For example, selecting " .. ITEM_QUALITY_COLORS[0].hex .. "Poor" .. "|r means every item will be considered, while selecting " .. ITEM_QUALITY_COLORS[3].hex .. "Rare" .. "|r will ignore " .. ITEM_QUALITY_COLORS[0].hex .. "Poor|r, Common, and " .. ITEM_QUALITY_COLORS[2].hex .. "Uncommon|r items.",
					type = "select",
					style = "dropdown",
					values = {
						[0] = ITEM_QUALITY_COLORS[0].hex .. "Poor" .. "|r",
						[1] = ITEM_QUALITY_COLORS[1].hex .. "Common" .. "|r",
						[2] = ITEM_QUALITY_COLORS[2].hex .. "Uncommon" .. "|r",
						[3] = ITEM_QUALITY_COLORS[3].hex .. "Rare" .. "|r",
						[4] = ITEM_QUALITY_COLORS[4].hex .. "Epic" .. "|r",
					},
					sorting = {
						[1] = 0, 	-- Poor
						[2] = 1, 	-- Common
						[3] = 2, 	-- Uncommon
						[4] = 3, 	-- Rare
						[5] = 4, 	-- Epic
					},
					get = function()
						if not LastSeenDB.rarityID then
							LastSeenDB.rarityID = 0
						end
						return LastSeenDB.rarityID
					end,
					set = function(_, rarityID) LastSeenDB.rarityID = rarityID end,
				},
				Separator1 = {
					name = "",
					order = 10,
					type = "header",
				},
				Toggle_All_Filters = {
					name = "Toggle All",
					order = 11,
					desc = "Toggle all the filters on or off.",
					type = "execute",
					func = function(_, _)
						if LastSeenDB.Filters.Armor then
							LastSeenDB.Filters.Armor = false
							LastSeenDB.Filters.Weapon = false
							LastSeenDB.Filters.Recipe = false
							LastSeenDB.Filters.Quest = false
							LastSeenDB.Filters.Tradeskill = false
							LastSeenDB.Filters.Gem = false
							LastSeenDB.Filters.Consumable = false
							LastSeenDB.Filters.Profession = false
							LastSeenDB.Filters.Key = false
							LastSeenDB.Filters.Miscellaneous = false
							LastSeenDB.Filters.Container = false
						else
							LastSeenDB.Filters.Armor = true
							LastSeenDB.Filters.Weapon = true
							LastSeenDB.Filters.Recipe = true
							LastSeenDB.Filters.Quest = true
							LastSeenDB.Filters.Tradeskill = true
							LastSeenDB.Filters.Gem = true
							LastSeenDB.Filters.Consumable = true
							LastSeenDB.Filters.Profession = true
							LastSeenDB.Filters.Key = true
							LastSeenDB.Filters.Miscellaneous = true
							LastSeenDB.Filters.Container = true
						end
					end,
				},
				Armor_Toggle = {
					name = "Armor",
					order = 12,
					desc = "Toggle the Armor filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Armor then
							LastSeenDB.Filters.Armor = false
						end
						return LastSeenDB.Filters.Armor
					end,
					set = function(_, val) LastSeenDB.Filters.Armor = val end,
				},
				Weapon_Toggle = {
					name = "Weapon",
					order = 13,
					desc = "Toggle the Weapon filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Weapon then
							LastSeenDB.Filters.Weapon = false
						end
						return LastSeenDB.Filters.Weapon
					end,
					set = function(_, val) LastSeenDB.Filters.Weapon = val end,
				},
				Recipe_Toggle = {
					name = "Recipe",
					order = 14,
					desc = "Toggle the Recipe filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Recipe then
							LastSeenDB.Filters.Recipe = false
						end
						return LastSeenDB.Filters.Recipe
					end,
					set = function(_, val) LastSeenDB.Filters.Recipe = val end,
				},
				Quest_Toggle = {
					name = "Quest",
					order = 15,
					desc = "Toggle the Quest filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Quest then
							LastSeenDB.Filters.Quest = false
						end
						return LastSeenDB.Filters.Quest
					end,
					set = function(_, val) LastSeenDB.Filters.Quest = val end,
				},
				Tradeskill_Toggle = {
					name = "Tradeskill",
					order = 16,
					desc = "Toggle the Tradeskill filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Tradeskill then
							LastSeenDB.Filters.Tradeskill = false
						end
						return LastSeenDB.Filters.Tradeskill
					end,
					set = function(_, val) LastSeenDB.Filters.Tradeskill = val end,
				},
				Gem_Toggle = {
					name = "Gem",
					order = 17,
					desc = "Toggle the Gem filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Gem then
							LastSeenDB.Filters.Gem = false
						end
						return LastSeenDB.Filters.Gem
					end,
					set = function(_, val) LastSeenDB.Filters.Gem = val end,
				},
				Consumable_Toggle = {
					name = "Consumable",
					order = 18,
					desc = "Toggle the Consumable filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Consumable then
							LastSeenDB.Filters.Consumable = false
						end
						return LastSeenDB.Filters.Consumable
					end,
					set = function(_, val) LastSeenDB.Filters.Consumable = val end,
				},
				Profession_Toggle = {
					name = "Profession",
					order = 19,
					desc = "Toggle the Profession filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Profession then
							LastSeenDB.Filters.Profession = false
						end
						return LastSeenDB.Filters.Profession
					end,
					set = function(_, val) LastSeenDB.Filters.Profession = val end,
				},
				Key_Toggle = {
					name = "Keys",
					order = 19,
					desc = "Toggle the Keys filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Key then
							LastSeenDB.Filters.Key = false
						end
						return LastSeenDB.Filters.Key
					end,
					set = function(_, val) LastSeenDB.Filters.Key = val end,
				},
				Miscellaneous_Toggle = {
					name = "Miscellaneous",
					order = 20,
					desc = "Toggle the Miscellaneous filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Miscellaneous then
							LastSeenDB.Filters.Miscellaneous = false
						end
						return LastSeenDB.Filters.Miscellaneous
					end,
					set = function(_, val) LastSeenDB.Filters.Miscellaneous = val end,
				},
				Container_Toggle = {
					name = "Container",
					order = 21,
					desc = "Toggle the Container filter.",
					type = "toggle",
					get = function(_)
						if not LastSeenDB.Filters.Container then
							LastSeenDB.Filters.Container = false
						end
						return LastSeenDB.Filters.Container
					end,
					set = function(_, val) LastSeenDB.Filters.Container = val end,
				},
            },
        },
		Features_Tab = {
            name = "Features",
			desc = "Toggle extra features for the addon.",
            type = "group",
            order = 3,
            args = {
				ScanOnLoot = {
					name = "Scan on Loot",
					order = 1,
					desc = "Toggle for " .. addonName .. " to scan when the loot window is opened, as opposed to when items are looted into your inventory.\n\n" ..
					"This is only useful for boss loot from dungeons and raids. I recommend you leave this unchecked.",
					type = "toggle",
					get = function(info) return LastSeenDB.ScanOnLootOpenedEnabled end,
					set = function(_, val)
						if ( C_CVar.GetCVar("autoLootDefault") == "1" ) then
							print("|cffFF0000ERROR|r: Auto Loot must be disabled before enabling |cffFFD100Scan on Loot|r.")
							return
						end
						if not val then
							print("|cff00FF00TIP|r: |cffFFD100Scan on Loot|r was disabled. Remember to re-enable Auto Loot!")
						end
						LastSeenDB.ScanOnLootOpenedEnabled = val
					end,
				},
            },
        },
		Changelog_Tab = {
            name = "Changelog",
			desc = "Review the changelog for the currently installed release.",
            type = "group",
            order = 4,
			args = {
				text = {
					name = coloredDash .. "Completely rewrote the addon from the ground up.",
					order = 1,
					type = "description",
					fontSize = "medium",
				},
				--[[addedHeader = {
					name = "Added",
					order = 10,
					type = "header",
				},
				addedText = {
					name = "",
					order = 11,
					type = "description",
					fontSize = "medium",
				},]]
				--[[changedHeader = {
					name = "Changed",
					order = 20,
					type = "header",
				},
				changedText = {
					name = "",
					order = 21,
					type = "description",
					fontSize = "medium",
				},]]
				--[[fixedHeader = {
					name = "Fixed",
					order = 30,
					type = "header",
				},
				fixedText = {
					name = coloredDash .. "",
					order = 31,
					type = "description",
					fontSize = "medium",
				},]]
				--[[removedHeader = {
					name = "Removed",
					order = 40,
					type = "header",
				},
				removedText = {
					name = "",
					order = 41,
					type = "description",
					fontSize = "medium",
				},]]
            },
		},
		About_Tab = {
            name = "About",
			desc = "Learn about the addon and its author.",
            type = "group",
            order = 5,
            args = {
                versionText = {
					name = "|cffFFD100Version|r: " .. GetAddOnMetadata(addonName, "Version"),
					order = 1,
					type = "description",
				},
				authorText = {
					name = "|cffFFD100Author|r: " .. "Lightsky",
					order = 2,
					type = "description",
				},
				contactText = {
					name = "|cffFFD100Contact|r: Lightsky#0658 (Discord)",
					order = 3,
					type = "description",
				},
            },
        },
		issueBtn = {
			name = "Open Issue",
			order = 6,
			type = "execute",
			func = function(_, _)
				StaticPopupDialogs["LASTSEEN_GITHUB_POPUP"] = {
					text = "|T236688:36|t\n\n" ..
					"Copy the link below, and thank you for opening an issue!",
					button1 = "OK",
					OnShow = function(self, data)
						self.editBox:SetText("https://github.com/Saaappi/LastSeen/issues/new")
						self.editBox:HighlightText()
					end,
					timeout = 30,
					showAlert = true,
					whileDead = false,
					hideOnEscape = true,
					enterClicksFirstButton = true,
					hasEditBox = true,
					preferredIndex = 3,
				}
				StaticPopup_Show("LASTSEEN_GITHUB_POPUP")
			end,
		},
	},
}
addonTable.mainOptions = mainOptions