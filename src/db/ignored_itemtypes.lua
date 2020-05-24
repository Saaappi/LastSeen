local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

local ignoredItemTypes = {
	[L["IS_GEM"]] = "Gem",
	[L["IS_QUEST_ITEM"]] = "Quest",
	[L["IS_TRADESKILL_ITEM"]] = "Tradeskill",
	[L["IS_TRINKET"]] = "INVTYPE_TRINKET",
};
-- Synopsis: There are certain item types the addon shouldn't care about. For example, an item that starts a quest, and happens to be Uncommon quality or higher, should be ignored.

addonTbl.ignoredItemTypes = ignoredItemTypes;