local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
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
            },
        },
		Filters_Tab = {
            name = "Filters",
            type = "group",
            order = 2,
            args = {
            },
        },
		Changelog_Tab = {
            name = "Changelog",
            type = "group",
            order = 9,
			args = {
				codenameText = {
					name = "Codename: Milky Way\n\n" ..
					"This is the codename for " .. addonName .. "'s Dragonflight releases.",
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
				--[[updatedHeader = {
					name = "Changed / Updated",
					order = 20,
					type = "header",
				},
				updatedText = {
					name = "",
					order = 21,
					type = "description",
					fontSize = "medium",
				},]]
				fixedHeader = {
					name = "Fixed",
					order = 30,
					type = "header",
				},
				fixedText = {
					name = coloredDash .. "test",
					order = 31,
					type = "description",
					fontSize = "medium",
				},
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