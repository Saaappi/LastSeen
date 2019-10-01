--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used to declare and initialize all of the addon's tables.
]]--

local lastSeen, LastSeenTbl = ...;
local L = LastSeenTbl.L;

-- Bundles
local itemsToSource = {}; -- The data here is temporary intentionally.

-- Ignored Stuff
local ignoredItems = {
	-- Dungeon Satchels
	[156683] = "Satchel of Helpful Goods",					-- Classic
	[156682] = "Otherwordly Satchel of Helpful Goods",		-- TBC
	[156688] = "Icy Satchel of Helpful Goods",				-- Wrath
	[156689] = "Scorched Satchel of Helpful Goods",			-- Cata
	[156698] = "Tranquil Satchel of Helpful Goods",			-- MoP
	[128803] = "Savage Satchel of Helpful Goods",			-- WoD
	-- Everything Else
	[20873] = "Alabaster Idol",								-- Ahn'Qiraj
	[20869] = "Amber Idol",									-- Ahn'Qiraj
    [20866] = "Azure Idol", 								-- Ahn'Qiraj
    [20870] = "Jasper Idol", 								-- Ahn'Qiraj
	[20867] = "Onyx Idol", 									-- Ahn'Qiraj
    [20872] = "Vermillion Idol", 							-- Ahn'Qiraj
	[20868] = "Lambent Idol", 								-- Ahn'Qiraj
	[20871] = "Obsidian Idol", 								-- Ahn'Qiraj
	[76401] = "Scarab Coffer Key", 							-- Ahn'Qiraj
	[76402] = "Greater Scarab Coffer Key", 					-- Ahn'Qiraj
	[20864] = "Bone Scarab", 								-- Ahn'Qiraj
	[20861] = "Bronze Scarab", 								-- Ahn'Qiraj
	[20863] = "Clay Scarab", 								-- Ahn'Qiraj
	[20862] = "Crystal Scarab", 							-- Ahn'Qiraj
	[20859] = "Gold Scarab", 								-- Ahn'Qiraj
	[20865] = "Ivory Scarab", 								-- Ahn'Qiraj
	[20860] = "Silver Scarab", 								-- Ahn'Qiraj
	[20858] = "Stone Scarab", 								-- Ahn'Qiraj
	[20876] = "Idol of Death", 								-- Ahn'Qiraj
	[20879] = "Idol of Life", 								-- Ahn'Qiraj
	[20875] = "Idol of Night", 								-- Ahn'Qiraj
	[20878] = "Idol of Rebirth", 							-- Ahn'Qiraj
	[20881] = "Idol of Strife", 							-- Ahn'Qiraj
	[20877] = "Idol of the Sage", 							-- Ahn'Qiraj
	[20874] = "Idol of the Sun", 							-- Ahn'Qiraj
	[20882] = "Idol of War", 								-- Ahn'Qiraj
	[21220] = "Head of Ossirian the Unscarred", 			-- Ahn'Qiraj
	[21221] = "Eye of C'Thun", 								-- Ahn'Qiraj
	[21218] = "Blue Qiraji Resonating Crystal", 			-- Ahn'Qiraj
    [21323] = "Green Qiraji Resonating Crystal", 			-- Ahn'Qiraj
    [21321] = "Red Qiraji Resonating Crystal", 				-- Ahn'Qiraj
    [21324] = "Yellow Qiraji Resonating Crystal", 			-- Ahn'Qiraj
	[11736] = "Libram of Resilience", 						-- Blackrock Depths
	[11742] = "Wayfarer's Knapsack", 						-- Blackrock Depths
	[19002] = "Head of Nefarian", 							-- Blackwing Lair
	[19003] = "Head of Nefarian", 							-- Blackwing Lair
	[17964] = "Gray Sack of Gems", 							-- Blackwing Lair
	[17969] = "Red Sack of Gems", 							-- Blackwing Lair
	[17963] = "Green Sack of Gems", 						-- Blackwing Lair
	[12607] = "Brilliant Chromatic Scale",					-- Blackwing Lair
	[93724] = "Darkmoon Game Prize", 						-- Darkmoon Faire
	[71083] = "Darkmoon Game Token", 						-- Darkmoon Faire
	[34846] = "Black Sack of Gems", 						-- Magtheridon's Lair
	[166971] = "Empty Energy Cell",							-- Mechagon Island
	[166970] = "Energy Cell",								-- Mechagon Island
	[166846] = "Spare Parts",								-- Mechagon Island
	[169610] = "S.P.A.R.E. Crate",							-- Mechagon Island
	[168327] = "Chain Ignitercoil",							-- Mechagon Island
	[168832] = "Galvanic Oscillator",						-- Mechagon Island
	[49294] = "Ashen Sack of Gems", 						-- Onyxia's Lair
	[49644] = "Head of Onyxia", 							-- Onyxia's Lair
	[49643] = "Head of Onyxia", 							-- Onyxia's Lair
	[49295] = "Enlarged Onyxia Hide Backpack", 				-- Onyxia's Lair
	[137642] = "Mark of Honor", 							-- PvP
	[141605] = "Flight Master's Whistle",					-- Quest
	[86143] = "Battle Pet Bandage",							-- Quest
	[86623] = "Blingtron 4000 Gift Package",				-- Quest
	[113258] = "Blingtron 5000 Gift Package",				-- Quest
	[132892] = "Blingtron 6000 Gift Package",				-- Quest
	[168740] = "Blingtron 7000 Gift Package",				-- Quest
	[12382] = "Key to the City", 							-- Stratholme
	[17965] = "Yellow Sack of Gems", 						-- World Boss
	[32897] = "Mark of the Illidari", 						-- World Drop
	[11754] = "Black Diamond", 								-- World Drop
	[33865] = "Amani Hex Stick",							-- Zul'Aman
	[69886] = "Bag of Coins",								-- Zul'Aman
	[69748] = "Tattered Hexcloth Bag",						-- Zul'Aman (Quest)
};

local ignoredItemTypes = {
	[L["IS_QUEST_ITEM"]] = "Quest",
	[L["IS_TRADESKILL_ITEM"]] = "Tradeskill",
	[L["IS_GEM"]] = "Gem",
};

-- Players
local LastSeenPlayers = {}; 								-- Unused

-- Spells
local spells = {
	[3365] = "Opening", 									-- Used by the [Chest of The Seven] in Blackrock Depths, [Cache of the Firelord] in Molten Core, and various open world chests.
	[6247] = "Opening", 									-- Used by the cache in Scholomance, as well as the doors/gates/lock(s) in Blackrock Depths and Uldaman.
	[6477] = "Opening", 									-- Used by the Dark Keeper Portrait/Relic Coffers in Blackrock Depths.
	[6478] = "Opening", 									-- Used by the [Ancient Treasure] in Uldaman.
	[131474] = "Fishing",									-- Used by the Classic version of Fishing.
	[131476] = "Fishing",									-- Used by the Classic version of Fishing.
	[156774] = "Teleport to Dark Portal, Blasted Lands",	-- Used to teleport players to the Blasted Lands by the mages in Stormwind City and Orgrimmar.
};

local removedItems = {};

-- Additions to the namespace
LastSeenTbl.itemsToSource = itemsToSource;
LastSeenTbl.ignoredItems = ignoredItems;
LastSeenTbl.ignoredItemTypes = ignoredItemTypes;
LastSeenTbl.LastSeenPlayers = LastSeenPlayers;
LastSeenTbl.spells = spells;
LastSeenTbl.removedItems = removedItems;
