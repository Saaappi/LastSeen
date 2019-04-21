--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Houses the skeleton of the system that holds loot data.
]]--

local lastseen, lastseendb = ...;

local L = lastseendb.L; 

local ignoredItems = {
	[49294] = "Ashen Sack of Gems",
	[34846] = "Black Sack of Gems",
	[17964] = "Gray Sack of Gems",
	[17969] = "Red Sack of Gems",
	[17965] = "Yellow Sack of Gems",
	[49644] = "Head of Onyxia", -- Alliance Only
	[49643] = "Head of Onyxia", -- Horde Only
	[19002] = "Head of Nefarian", -- Horde Only
	[19003] = "Head of Nefarian", -- Alliance Only
};

local ignoredItemTypes = {
	L["TRADESKILL"],
};

local isCraftedItem = false;

lastseendb.itemstgdb = LastSeenItemsDB;
lastseendb.itemignrdb = LastSeenIgnoresDB;
lastseendb.ignoredItems = ignoredItems;
lastseendb.ignoredItemTypes = ignoredItemTypes;
lastseendb.isCraftedItem = isCraftedItem;