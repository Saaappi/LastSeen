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
local eyeIcon = "\124T1100023:12\124t "; -- Eye Beam (Gul'dan)
local badDataIcon = "\124T133730:12\124t "; -- Death Touch

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
	LastSeenTbl.eyeIcon = eyeIcon;
	LastSeenTbl.badDataIcon = badDataIcon;

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
