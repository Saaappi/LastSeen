--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used to declare and initialize all of the addon's variables.
]]--

local lastSeen, LastSeenTbl = ...;

-- OPTIONS
local doNotIgnore = false;
local doNotPlayRareSound = false;
local tab1, tab2 = {};

-- AddOns
local isAutoLootPlusLoaded = IsAddOnLoaded("AutoLootPlus");

-- Booleans
local doNotUpdate = false;
local isAuctionItem = false;
local isInInstance = false;
local isMailboxOpen = false;
local isQuestReward = false;
local playerLootedObject = false;
local wasLootedFromItem = false;
local wasUpdated = false;

-- Icons
local badDataIcon = "\124T133730:12\124t "; -- Death Touch
local questionMarkIcon = "\124T134400:12\124t "; -- Answer the Question!
local poorIcon = "\124T237283:12\124t "; -- Alonsus Faol's Copper Coin
local commonIcon = "\124T133787:12\124t "; -- Stolen Silver
local uncommonIcon = "\124T237281:12\124t "; -- Solid Gold Coin
local rareIcon = "\124T134563:12\124t "; -- Rare Metal
local epicIcon = "\124T135028:12\124t "; -- Epic Purple Shirt
local legendaryIcon = "\124T133066:12\124t "; -- Sulfuras, Hand of Ragnaros
local artifactIcon = "\124T1029580:12\124t "; -- Power Realized (Achievement)

-- Integers
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

-- Multi-variables
local query = "";

-- Strings
local currentMap = "";
local itemLooted = "";
local itemName = "";
local itemType = "";
local lootedItem = "";
local lootedObject = "";
local target = "";

-- Additions to addon namespace

-- OPTIONS
	LastSeenTbl.doNotIgnore = doNotIgnore;
	LastSeenTbl.doNotPlayRareSound = doNotPlayRareSound;
	LastSeenTbl.tab1 = tab1;
	LastSeenTbl.tab2 = tab2;

-- AddOns
	LastSeenTbl.isAutoLootPlusLoaded = isAutoLootPlusLoaded;
	LastSeenTbl.isLastSeenLoaded = isLastSeenLoaded;
	
-- Icons
	LastSeenTbl.badDataIcon = badDataIcon;
	LastSeenTbl.questionMarkIcon = questionMarkIcon;
	LastSeenTbl.poorIcon = poorIcon;
	LastSeenTbl.commonIcon = commonIcon;
	LastSeenTbl.uncommonIcon = uncommonIcon;
	LastSeenTbl.rareIcon = rareIcon;
	LastSeenTbl.epicIcon = epicIcon;
	LastSeenTbl.legendaryIcon = legendaryIcon;
	LastSeenTbl.artifactIcon = artifactIcon;
	
-- Integers
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

-- Other
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
	LastSeenTbl.target = target;
