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
			get = function(info) return LastSeenDB.ConsumableFilterEnabled end,
			set = function(info, val) LastSeenDB.ConsumableFilterEnabled = val end,
		},
		weapon = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Weapon"],
			order = 2,
			desc = L_GLOBALSTRINGS["Filters.Toggle.WeaponDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.WeaponFilterEnabled end,
			set = function(info, val) LastSeenDB.WeaponFilterEnabled = val end,
		},
		gem = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Gem"],
			order = 3,
			desc = L_GLOBALSTRINGS["Filters.Toggle.GemDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.GemFilterEnabled end,
			set = function(info, val) LastSeenDB.GemFilterEnabled = val end,
		},
		armor = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Armor"],
			order = 4,
			desc = L_GLOBALSTRINGS["Filters.Toggle.ArmorDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.ArmorFilterEnabled end,
			set = function(info, val) LastSeenDB.ArmorFilterEnabled = val end,
		},
		tradegoods = {
			name = L_GLOBALSTRINGS["Filters.Toggle.TradeGoods"],
			order = 5,
			desc = L_GLOBALSTRINGS["Filters.Toggle.TradeGoodsDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.TradeGoodsFilterEnabled end,
			set = function(info, val) LastSeenDB.TradeGoodsFilterEnabled = val end,
		},
		recipe = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Recipe"],
			order = 6,
			desc = L_GLOBALSTRINGS["Filters.Toggle.RecipeDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.RecipeFilterEnabled end,
			set = function(info, val) LastSeenDB.RecipeFilterEnabled = val end,
		},
		quest = {
			name = L_GLOBALSTRINGS["Filters.Toggle.Quest"],
			order = 7,
			desc = L_GLOBALSTRINGS["Filters.Toggle.QuestDesc"],
			type = "toggle",
			get = function(info) return LastSeenDB.QuestFilterEnabled end,
			set = function(info, val) LastSeenDB.QuestFilterEnabled = val end,
		},
	},
}
addonTable.filtersOptions = filtersOptions