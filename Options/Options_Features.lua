local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

local featuresOptions = {
	name = L_GLOBALSTRINGS["Tabs.Features"],
	handler = LastSeen,
	type = "group",
	args = {
		toggle_header = {
			name = L_GLOBALSTRINGS["Header.Toggles"],
			order = 0,
			type = "header",
		},
		scanOnLoot = {
			name = L_GLOBALSTRINGS["Features.Toggle.ScanOnLootOpened"],
			order = 1,
			desc = L_GLOBALSTRINGS["Features.Toggle.ScanOnLootOpenedDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.ScanOnLootOpenedEnabled end,
			set = function(info, val) LastSeenDB.ScanOnLootOpenedEnabled = val end,
		},
		scanTooltipOnHover = {
			name = L_GLOBALSTRINGS["Features.Toggle.ScanTooltipsOnHover"],
			order = 2,
			desc = L_GLOBALSTRINGS["Features.Toggle.ScanTooltipsOnHoverDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.ScanTooltipsOnHoverEnabled end,
			set = function(info, val) LastSeenDB.ScanTooltipsOnHoverEnabled = val end,
		},
		showExtraSources = {
			name = L_GLOBALSTRINGS["Features.Toggle.ShowExtraSources"],
			order = 3,
			desc = L_GLOBALSTRINGS["Features.Toggle.ShowExtraSourcesDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.ShowExtraSourcesEnabled end,
			set = function(info, val) LastSeenDB.ShowExtraSourcesEnabled = val end,
		},
	},
}
addonTable.featuresOptions = featuresOptions