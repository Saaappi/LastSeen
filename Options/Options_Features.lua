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
			set = function(_, val)
				if ( C_CVar.GetCVar("autoLootDefault") == "1" ) then
					print(L_GLOBALSTRINGS["Text.Output.Error.AutoLootIsEnabled"])
					return
				end
				if not val then
					print(L_GLOBALSTRINGS["Text.Output.Tip.EnableAutoLoot"])
				end
				LastSeenDB.ScanOnLootOpenedEnabled = val
			end,
		},
		showNumSources = {
			name = L_GLOBALSTRINGS["Features.Toggle.ShowNumSources"],
			order = 2,
			desc = L_GLOBALSTRINGS["Features.Toggle.ShowNumSourcesDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.ShowNumSourcesEnabled end,
			set = function(_, val) LastSeenDB.ShowNumSourcesEnabled = val end,
		},
	},
}
addonTable.featuresOptions = featuresOptions