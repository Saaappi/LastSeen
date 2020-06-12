local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

-- TODO: Reconsider the approach to ignoring specific items.
local ignoredItems = {
	[21218] 		= "Blue Qiraji Resonating Crystal",
	[141605] 		= "Flight Master's Whistle",
    [21323] 		= "Green Qiraji Resonating Crystal",
	[11736] 		= "Libram of Resilience",
	[137642]		= "Mark of Honor",
    [21321] 		= "Red Qiraji Resonating Crystal",
	[163611]		= "Seafarer's Coin Pouch",
    [21324] 		= "Yellow Qiraji Resonating Crystal",
};

addonTbl.ignoredItems = ignoredItems;