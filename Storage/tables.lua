--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used to declare and initialize all of the addon's tables.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

-- Creatures
local LastSeenCreatures = {};

-- Items
local LastSeenItems = {};

-- Ignored Stuff
local LastSeenIgnoredItems = {};
local ignoredItems = {
	[49294] = "Ashen Sack of Gems", -- (Onyxia)
	[34846] = "Black Sack of Gems", -- (Mag's Lair)
	[17964] = "Gray Sack of Gems", -- (BWL)
	[17969] = "Red Sack of Gems", -- (BWL)
	[17963] = "Green Sack of Gems", -- (BWL)
	[17965] = "Yellow Sack of Gems", -- (World Dragons)
	[49644] = "Head of Onyxia", -- Alliance Only
	[49643] = "Head of Onyxia", -- Horde Only
	[19002] = "Head of Nefarian", -- Horde Only (BWL)
	[19003] = "Head of Nefarian", -- Alliance Only (BWL)
	[32897] = "Mark of the Illidari",
};
local ignoredItemTypes = {
	["itemTypes"] = {
		["itemType"] = L["IS_QUEST_ITEM"], -- Quest
		["itemType"] = L["IS_TRADESKILL_ITEM"], -- Tradeskill
	};
};

-- Players
local LastSeenPlayers = {}; -- Unused

-- Quests
local LastSeenQuests = {};

-- Additions to the namespace
lastSeenNS.LastSeenCreatures = LastSeenCreatures;
lastSeenNS.LastSeenItems = LastSeenItems;
lastSeenNS.LastSeenIgnoredItems = LastSeenIgnoredItems;
lastSeenNS.ignoredItems = ignoredItems;
lastSeenNS.ignoredItemTypes = ignoredItemTypes;
lastSeenNS.LastSeenPlayers = LastSeenPlayers;
lastSeenNS.LastSeenQuests = LastSeenQuests;