local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

-- TODO: Reconsider the approach to ignoring specific items.
local whitelistedItems = {
};

addonTbl.whitelistedItems = whitelistedItems;