--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used to declare and initialize all of the addon's variables.
]]--

local lastSeen, lastSeenNS = ...;

-- OPTIONS
local doNotIgnore = false;
local doNotPlayRareSound = false;

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
	lastSeenNS.doNotIgnore = doNotIgnore;
	lastSeenNS.doNotPlayRareSound = doNotPlayRareSound;

	-- AddOns
	lastSeenNS.isAutoLootPlusLoaded = isAutoLootPlusLoaded;
	lastSeenNS.isLastSeenLoaded = isLastSeenLoaded;

	-- OTHER
	lastSeenNS.doNotUpdate = doNotUpdate;
	lastSeenNS.isAuctionItem = isAuctionItem;
	lastSeenNS.isCraftedItem = isCraftedItem;
	lastSeenNS.isInInstance = isInInstance;
	lastSeenNS.isMailboxOpen = isMailboxOpen;
	lastSeenNS.isQuestReward = isQuestReward;
	lastSeenNS.playerLootedObject = playerLootedObject;
	lastSeenNS.wasLootedFromItem = wasLootedFromItem;
	lastSeenNS.wasUpdated = wasUpdated;

	lastSeenNS.itemID = itemID;
	lastSeenNS.itemRarity = itemRarity;
	lastSeenNS.lootedCreatureID = lootedCreatureID;
	lastSeenNS.mapID = mapID;

	lastSeenNS.query = query;

	lastSeenNS.currentMap = currentMap;
	lastSeenNS.lootedItem = lootedItem;
	lastSeenNS.itemLooted = itemLooted;
	lastSeenNS.lootedObject = lootedObject;
	lastSeenNS.target = target;
	lastSeenNS.itemName = itemName;
	lastSeenNS.itemType = itemType;
