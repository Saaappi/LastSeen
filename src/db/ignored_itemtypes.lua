local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

local ignoredItemTypes = {
	[L["IS_GEM"]] = "Gem",
	[L["IS_QUEST_ITEM"]] = "Quest",
	[L["IS_TRADESKILL_ITEM"]] = "Tradeskill",
};

-- Additions to the namespace
addonTbl.ignoredItemTypes = ignoredItemTypes;