local lastSeen, LastSeenTbl = ...;
local L = LastSeenTbl.L;

-- OPTIONS
local doNotIgnore = false;
local doNotPlayRareSound = false;
local tab1, tab2 = {};

-- ADDONS
local isAutoLootPlusLoaded = IsAddOnLoaded("AutoLootPlus");
local isFasterLootLoaded = IsAddOnLoaded("FasterLoot");

-- BOOLEANS
local doNotUpdate = false;
local isAuctionItem = false;
local isInInstance = false;
local isMailboxOpen = false;
local isQuestReward = false;
local playerLootedObject = false;
local wasLootedFromItem = false;
local wasUpdated = false;

-- ICONS
local badDataIcon = "\124T133730:12\124t "; -- Death Touch
local questionMarkIcon = "\124T134400:12\124t "; -- Answer the Question!
local poorIcon = "\124T237283:12\124t "; -- Alonsus Faol's Copper Coin
local commonIcon = "\124T133787:12\124t "; -- Stolen Silver
local uncommonIcon = "\124T237281:12\124t "; -- Solid Gold Coin
local rareIcon = "\124T134563:12\124t "; -- Rare Metal
local epicIcon = "\124T135028:12\124t "; -- Epic Purple Shirt
local legendaryIcon = "\124T133066:12\124t "; -- Sulfuras, Hand of Ragnaros
local artifactIcon = "\124T1029580:12\124t "; -- Power Realized (Achievement)

-- INTEGERS
local itemID = 0;
local itemRarity = 0;
local lootedCreatureID = 0;
local mapID = 0;
local rank_poor = 4999;
local rank_common = 9999;
local rank_uncommon = 14999;
local rank_rare = 19999;
local rank_epic = 29999;
local rank_legendary = 49999;
local rank_artifact = 50000;

-- MULTI-VARIABLES
local query = "";

-- STRINGS
local currentMap = "";
local itemLooted = "";
local itemName = "";
local itemType = "";
local lootedItem = "";
local lootedObject = "";

-- MISCELLANEOUS
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
	[124125] = "Obliterum",									-- Crafting
	[136342] = "Obliterum Ash",								-- Crafting
	[93724] = "Darkmoon Game Prize", 						-- Darkmoon Faire
	[71083] = "Darkmoon Game Token", 						-- Darkmoon Faire
	[158923] = "Mythic Keystone",							-- Dungeons (BFA)
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

local events = {
	"BAG_UPDATE",
	"BOSS_KILL",
	"CHAT_MSG_LOOT",
	"ENCOUNTER_LOOT_RECEIVED",
	"INSTANCE_GROUP_SIZE_CHANGED",
	"ITEM_LOCKED",
	"LOOT_CLOSED",
	"LOOT_OPENED",
	"MAIL_CLOSED",
	"MAIL_INBOX_UPDATE",
	"NAME_PLATE_UNIT_ADDED",
	"PLAYER_ENTERING_WORLD",
	"PLAYER_LOGIN",
	"PLAYER_LOGOUT",
	"QUEST_ACCEPTED",
	"QUEST_LOOT_RECEIVED",
	"SHOW_LOOT_TOAST",
	"UPDATE_MOUSEOVER_UNIT",
	"UNIT_SPELLCAST_SENT",
	"UNIT_SPELLCAST_START",
	"ZONE_CHANGED_NEW_AREA"
};

local spellLocaleNames = {
	-- "Collecting"
	"Collecting",
	"Collecte",
	"Aufsammeln",
	-- "Fishing"
	"Fishing",
	"Pêche",
	"Angeln",
	-- "Frisking Toga"
	"Frisking Toga",
	"Tâter la toge",
	"Toga durchsuchen",
	-- "Herb Gathering"
	"Herb Gathering",
	"Cueillette",
	"Kräutersammeln",
	-- "Looting"
	"Looting",
	"Fouille et butin",
	"Plündert",
	-- "Mining"
	"Mining",
	"Minage",
	"Bergbau",
	-- "Opening"
	"Opening",
	"Ouverture",
	"Öffnen",
	-- "Skinning"
	"Skinning",
	"Dépeçage",
	"Kürschnerei",
	-- "Survey"
	"Survey",
	"Levé",
	"Untersuchen",
	-- "Teleport to Dark Portal, Blasted Lands"
	"Teleport to Dark Portal, Blasted Lands",
	"Téléportation vers la Porte des ténèbres, Terres foudroyées",
	"Teleport zum Dunklen Portal, Verwüstete Lande.",
};

local removedItems = {};

-- Additions to the namespace
LastSeenTbl.events = events;
LastSeenTbl.itemsToSource = itemsToSource;
LastSeenTbl.ignoredItems = ignoredItems;
LastSeenTbl.ignoredItemTypes = ignoredItemTypes;
LastSeenTbl.spellLocaleNames = spellLocaleNames;
LastSeenTbl.removedItems = removedItems;

-- OPTIONS
LastSeenTbl.doNotIgnore = doNotIgnore;
LastSeenTbl.doNotPlayRareSound = doNotPlayRareSound;
LastSeenTbl.tab1 = tab1;
LastSeenTbl.tab2 = tab2;

-- ADDONS
LastSeenTbl.isAutoLootPlusLoaded = isAutoLootPlusLoaded;
LastSeenTbl.isFasterLootLoaded = isFasterLootLoaded;
LastSeenTbl.isLastSeenLoaded = isLastSeenLoaded;
	
-- ICONS
LastSeenTbl.badDataIcon = badDataIcon;
LastSeenTbl.questionMarkIcon = questionMarkIcon;
LastSeenTbl.poorIcon = poorIcon;
LastSeenTbl.commonIcon = commonIcon;
LastSeenTbl.uncommonIcon = uncommonIcon;
LastSeenTbl.rareIcon = rareIcon;
LastSeenTbl.epicIcon = epicIcon;
LastSeenTbl.legendaryIcon = legendaryIcon;
LastSeenTbl.artifactIcon = artifactIcon;
	
-- INTEGERS
LastSeenTbl.itemID = itemID;
LastSeenTbl.itemRarity = itemRarity;
LastSeenTbl.lootedCreatureID = lootedCreatureID;
LastSeenTbl.mapID = mapID;
LastSeenTbl.rank_poor = rank_poor;
LastSeenTbl.rank_common = rank_common;
LastSeenTbl.rank_uncommon = rank_uncommon;
LastSeenTbl.rank_rare = rank_rare;
LastSeenTbl.rank_epic = rank_epic;
LastSeenTbl.rank_legendary = rank_legendary;
LastSeenTbl.rank_artifact = rank_artifact;

-- MISCELLANEOUS
LastSeenTbl.doNotUpdate = doNotUpdate;
LastSeenTbl.isAuctionItem = isAuctionItem;
LastSeenTbl.isCraftedItem = isCraftedItem;
LastSeenTbl.isInInstance = isInInstance;
LastSeenTbl.isMailboxOpen = isMailboxOpen;
LastSeenTbl.isQuestReward = isQuestReward;
LastSeenTbl.playerLootedObject = playerLootedObject;
LastSeenTbl.wasLootedFromItem = wasLootedFromItem;
LastSeenTbl.wasUpdated = wasUpdated;
LastSeenTbl.query = query;
LastSeenTbl.currentMap = currentMap;
LastSeenTbl.itemLooted = itemLooted;
LastSeenTbl.itemName = itemName;
LastSeenTbl.itemType = itemType;
LastSeenTbl.lootedItem = lootedItem;
LastSeenTbl.lootedObject = lootedObject;