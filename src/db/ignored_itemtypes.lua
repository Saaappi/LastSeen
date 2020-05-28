local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

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
		["itemType"] = "INVTYPE_FINGER",
	},
	{
		["itemType"] = "INVTYPE_NECK",
	},
	{
		["itemType"] = "INVTYPE_TRINKET",
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
		["itemType"] = "Quest",
	},
	{
		["itemType"] = "Reagent",
	},
	{
		["itemType"] = "Tradeskill",
	},
};
-- Synopsis: There are certain item types the addon shouldn't care about. For example, an item that starts a quest, and happens to be Uncommon quality or higher, should be ignored.

addonTbl.ignoredItemTypes = ignoredItemTypes;