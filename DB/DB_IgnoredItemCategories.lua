local addon, tbl = ...;
local L = tbl.L

local ignoredItemTypes = {
	{
		["itemType"] = "Consumable",
	},
	{
		["itemType"] = "Gem",
	},
	{
		["itemType"] = "INVTYPE_BAG",
	},
	{
		["itemType"] = "Item Enhancement",
	},
	{
		["itemType"] = "Junk",
	},
	{
		["itemType"] = "Key",
	},
	{
		["itemType"] = "Reagent",
	},
	{
		["itemType"] = "Tradeskill",
	},
};
-- Synopsis: There are certain item types the addon shouldn't care about. For example, an item that starts a quest, and happens to be Uncommon quality or higher, should be ignored.

tbl.ignoredItemCategories = ignoredItemTypes