local addon, addonTbl = ...;
local L = addonTbl.L;

-- TODO: Reconsider the approach to ignoring specific items.
local ignoredItems = {
	[11736] 		= "Libram of Resilience",
	[21218] 		= "Blue Qiraji Resonating Crystal",
    [21321] 		= "Red Qiraji Resonating Crystal",
    [21323] 		= "Green Qiraji Resonating Crystal",
    [21324] 		= "Yellow Qiraji Resonating Crystal",
	[137642]		= "Mark of Honor",
	[141605] 		= "Flight Master's Whistle",
	[143785]		= "Tome of the Tranquil Mind",
	[163611]		= "Seafarer's Coin Pouch",
	[163612]		= "Wayfinder's Satchel",
	[163613]		= "Sack of Plunder",
	[168416]		= "Anglers' Water Striders",
};

addonTbl.ignoredItems = ignoredItems;