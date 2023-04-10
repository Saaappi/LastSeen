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
				enable = {
					name = "Enable",
					order = 1,
					desc = "Toggle addon functionality.",
					type = "toggle",
					get = function(info) return LastSeenDB.Enabled end,
					set = function(info, val) LastSeenDB.Enabled = val end,
				},
				minimapIcon = {
					name = "Minimap Icon",
					order = 2,
					desc = "Toggle the minimap icon.",
					type = "toggle",
					get = function(info) return LastSeenDB.MinimapIconEnabled end,
					set = function(info, val) LastSeen:MinimapIcon(val) end,
				},
				modeDropdown = {
					name = "Mode",
					order = 3,
					desc = "",
					type = "select",
					style = "dropdown",
					values = {
						[0] = "Silent",
						[1] = "Normal",
						[2] = "Only New",
					},
					sorting = {
						[1] = 0, 	-- Silent
						[2] = 1, 	-- Normal
						[3] = 2, 	-- Only New
					},
					get = function()
						if not LastSeenDB.modeID then
							LastSeenDB.modeID = 1
						end
						return LastSeenDB.modeID
					end,
					set = function(_, modeID) LastSeenDB.modeID = modeID end,
				},
				dateFormatDropdown = {
					name = "Date Format",
					order = 4,
					desc = "",
					type = "select",
					style = "dropdown",
					values = {
						["%m/%d/%Y"] = "m/d/y",
						["%d/%m/%Y"] = "d/m/y",
					},
					sorting = {
						[1] = "%m/%d/%Y",
						[2] = "%d/%m/%Y",
					},
					get = function()
						if not LastSeenDB.DateFormat then
							LastSeenDB.DateFormat = "%m/%d/%Y"
						end
						return LastSeenDB.DateFormat
					end,
					set = function(_, dateFormat) LastSeenDB.DateFormat = dateFormat end,
				},
            },
        },
		Filters_Tab = {
            name = "Filters",
			desc = "Toggle item filters to personalize the items you want to track.",
            type = "group",
            order = 2,
            args = {
				rarityDropdown = {
					name = "Rarity",
					order = 1,
					desc = "",
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
						if not LastSeenDB.RarityId then
							LastSeenDB.RarityId = 0
						end
						return LastSeenDB.RarityId
					end,
					set = function(_, rarityId) LastSeenDB.RarityId = rarityId end,
				},
            },
        },
		Changelog_Tab = {
            name = "Changelog",
			desc = "Review the changelog for the currently installed release.",
            type = "group",
            order = 9,
			args = {
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
            order = 10,
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
			order = 11,
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