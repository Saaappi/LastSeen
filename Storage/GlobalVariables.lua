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
local poorIcon = "\124T133053:12\124t "; -- Poorly Balanced Warhammer
local commonIcon = "\124T135030:12\124t "; -- Common White Shirt
local rareIcon = "\124T135023:12\124t "; -- Cerulean Filigreed Doublet
local epicIcon = "\124T135028:12\124t "; -- Epic Purple Shirt
local legendaryIcon = "\124T236215:12\124t "; -- The Ultimate Collection (Achievement)
local artifactIcon = "\124T1869493:12\124t "; -- Heart of Azeroth

-- Integers
local itemID = 0;
local itemRarity = 0;
local lootedCreatureID = 0;
local mapID = 0;

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
	LastSeenTbl.rareIcon = rareIcon;
	LastSeenTbl.epicIcon = epicIcon;
	LastSeenTbl.legendaryIcon = legendaryIcon;
	LastSeenTbl.artifactIcon = artifactIcon;

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

	LastSeenTbl.itemID = itemID;
	LastSeenTbl.itemRarity = itemRarity;
	LastSeenTbl.lootedCreatureID = lootedCreatureID;
	LastSeenTbl.mapID = mapID;

	LastSeenTbl.query = query;

	LastSeenTbl.currentMap = currentMap;
	LastSeenTbl.itemLooted = itemLooted;
	LastSeenTbl.itemName = itemName;
	LastSeenTbl.itemType = itemType;
	LastSeenTbl.lootedItem = lootedItem;
	LastSeenTbl.lootedObject = lootedObject;
	LastSeenTbl.target = target;
