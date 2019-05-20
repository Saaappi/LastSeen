--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used to declare and initialize all of the addon's variables.
]]--

local lastSeen, lastSeenNS = ...;

-- AddOns
local isAutoLootPlusLoaded = IsAddOnLoaded("AutoLootPlus");

-- Booleans
local exists = false;
local isAuctionItem = false;
local isCraftedItem = false;
local isInInstance = false;
local isMailboxOpen = false;
local isMerchantWindowOpen = false;
local isTradeOpen = false;
local isQuestItemReward = false;
local otherSource = false;
local wasLootedFromItem = false;
local wasUpdated = false;

-- Integers
local itemID = 0;
local itemRarity = 0;
local lootedCreatureID = 0;
local mapID = 0;
local questID = 0;

-- Multi-variables
local query = "";

-- Strings
local currentMap = "";
local itemLink = "";
local itemLooted = "";
local itemName = "";
local itemType = "";
local lootedItem = ""; -- Item
local lootedObject = ""; -- Gameobject
local merchantName = "";

-- Additions to addon namespace
lastSeenNS.isAutoLootPlusLoaded = isAutoLootPlusLoaded;
lastSeenNS.isLastSeenLoaded = isLastSeenLoaded;
lastSeenNS.exists = exists;
lastSeenNS.isAuctionItem = isAuctionItem;
lastSeenNS.isCraftedItem = isCraftedItem;
lastSeenNS.isInInstance = isInInstance;
lastSeenNS.isMailboxOpen = isMailboxOpen;
lastSeenNS.isMerchantWindowOpen = isMerchantWindowOpen;
lastSeenNS.isTradeOpen = isTradeOpen;
lastSeenNS.isQuestItemReward = isQuestItemReward;
lastSeenNS.otherSource = otherSource;
lastSeenNS.wasLootedFromItem = wasLootedFromItem;
lastSeenNS.wasUpdated = wasUpdated;

lastSeenNS.itemID = itemID;
lastSeenNS.itemRarity = itemRarity;
lastSeenNS.lootedCreatureID = lootedCreatureID;
lastSeenNS.mapID = mapID;
lastSeenNS.questID = questID;

lastSeenNS.query = query;

lastSeenNS.currentMap = currentMap;
lastSeenNS.lootedItem = lootedItem;
lastSeenNS.lootedObject = lootedObject;
lastSeenNS.merchantName = merchantName;
lastSeenNS.currentMap = currentMap;
lastSeenNS.itemLink = itemLink;
lastSeenNS.itemLooted = itemLooted;
lastSeenNS.itemName = itemName;
lastSeenNS.itemType = itemType;