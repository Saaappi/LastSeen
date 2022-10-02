local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

local filtersOptions = {
	name = L_GLOBALSTRINGS["Tabs.Filters"],
	handler = LastSeen,
	type = "group",
	args = {
		toggle_header = {
			name = L_GLOBALSTRINGS["Header.Toggles"],
			order = 0,
			type = "header",
		},
		consumable = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Consumable"],
			order = 1,
			desc = L_GLOBALSTRINGS["Filters.Toggle.ConsumableDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.Filters.Consumable end,
			set = function(info, val) LastSeenDB.Filters.Consumable = val end,
		},
		weapon = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Weapon"],
			order = 2,
			desc = L_GLOBALSTRINGS["Filters.Toggle.WeaponDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.Filters.Weapon end,
			set = function(info, val) LastSeenDB.Filters.Weapon = val end,
		},
		gem = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Gem"],
			order = 3,
			desc = L_GLOBALSTRINGS["Filters.Toggle.GemDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.Filters.Gem end,
			set = function(info, val) LastSeenDB.Filters.Gem = val end,
		},
		armor = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Armor"],
			order = 4,
			desc = L_GLOBALSTRINGS["Filters.Toggle.ArmorDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.Filters.Armor end,
			set = function(info, val) LastSeenDB.Filters.Armor = val end,
		},
		tradegoods = {
			name = L_GLOBALSTRINGS["Filters.Toggle.TradeGoods"],
			order = 5,
			desc = L_GLOBALSTRINGS["Filters.Toggle.TradeGoodsDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.Filters.Tradeskill end,
			set = function(info, val) LastSeenDB.Filters.Tradeskill = val end,
		},
		recipe = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Recipe"],
			order = 6,
			desc = L_GLOBALSTRINGS["Filters.Toggle.RecipeDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.Filters.Recipe end,
			set = function(info, val) LastSeenDB.Filters.Recipe = val end,
		},
		quest = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Quest"],
			order = 7,
			desc = L_GLOBALSTRINGS["Filters.Toggle.QuestDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.Filters.Quest end,
			set = function(info, val) LastSeenDB.Filters.Quest = val end,
		},
		miscellaneous = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Miscellaneous"],
			order = 8,
			desc = L_GLOBALSTRINGS["Filters.Toggle.MiscellaneousDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.Filters.Miscellaneous end,
			set = function(info, val) LastSeenDB.Filters.Miscellaneous = val end,
		},
	},
}
addonTable.filtersOptions = filtersOptions