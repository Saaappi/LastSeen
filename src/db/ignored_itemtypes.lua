local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

local ignoredItemTypes = {
	{
		["itemType"] = "Gem",
	},
	{
		["itemType"] = "Junk",
	},
	{
		["itemType"] = "Quest",
	},
	{
		["itemType"] = "Tradeskill",
	},
	{
		["itemType"] = "INVTYPE_TRINKET",
	},
};
-- Synopsis: There are certain item types the addon shouldn't care about. For example, an item that starts a quest, and happens to be Uncommon quality or higher, should be ignored.

addonTbl.ignoredItemTypes = ignoredItemTypes;