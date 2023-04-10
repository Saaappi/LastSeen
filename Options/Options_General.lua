local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local icon = ""

local generalOptions = {
	name = L_GLOBALSTRINGS["Tabs.General"],
	handler = LastSeen,
	type = "group",
	args = {
		toggle_header = {
			name = L_GLOBALSTRINGS["Header.Toggles"],
			order = 0,
			type = "header",
		},
		dropdown_header = {
			name = L_GLOBALSTRINGS["Header.DropDowns"],
			order = 10,
			type = "header",
		},
		mode_dropdown = {
			name = L_GLOBALSTRINGS["DropDowns.General.Mode.Title"],
			order = 11,
			desc = L_GLOBALSTRINGS["DropDowns.General.Mode.Desc"],
			type = "select",
			style = "dropdown",
			values = {
				[0] = L_GLOBALSTRINGS["DropDowns.Disabled"],
				[1] = L_GLOBALSTRINGS["DropDowns.General.Mode.Debug"],
				[2] = L_GLOBALSTRINGS["DropDowns.General.Mode.Normal"],
			},
			sorting = {
				[1] = 0, 	-- Disabled
				[2] = 1, 	-- Debug
				[3] = 2, 	-- Normal
			},
			get = function()
				if not LastSeenDB.ModeId then
					LastSeenDB.ModeId = 0
				end
				return LastSeenDB.ModeId
			end,
			set = function(_, modeId) LastSeenDB.ModeId = modeId end,
		},
		rarity_dropdown = {
			name = L_GLOBALSTRINGS["DropDowns.General.Rarity.Title"],
			order = 12,
			desc = L_GLOBALSTRINGS["DropDowns.General.Rarity.Desc"],
			type = "select",
			style = "dropdown",
			values = {
				[0] = L_GLOBALSTRINGS["DropDowns.General.Rarity.Poor"],
				[1] = L_GLOBALSTRINGS["DropDowns.General.Rarity.Common"],
				[2] = L_GLOBALSTRINGS["DropDowns.General.Rarity.Uncommon"],
				[3] = L_GLOBALSTRINGS["DropDowns.General.Rarity.Rare"],
				[4] = L_GLOBALSTRINGS["DropDowns.General.Rarity.Epic"],
			},
			get = function()
				if not LastSeenDB.RarityId then
					LastSeenDB.RarityId = 0
				end
				return LastSeenDB.RarityId
			end,
			set = function(_, rarityId) LastSeenDB.RarityId = rarityId end,
		},
		dateFormat_dropdown = {
			name = L_GLOBALSTRINGS["DropDowns.General.DateFormat.Title"],
			order = 13,
			desc = L_GLOBALSTRINGS["DropDowns.General.DateFormat.Desc"],
			type = "select",
			style = "dropdown",
			values = {
				["%m/%d/%Y"] = L_GLOBALSTRINGS["DropDowns.General.DateFormat.US"],
				["%d/%m/%Y"] = L_GLOBALSTRINGS["DropDowns.General.DateFormat.EU"],
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
}
addonTable.generalOptions = generalOptions