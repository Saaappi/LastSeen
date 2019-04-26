--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used to declare and initialize all of the addon's variables.
]]--

local lastSeen, lastSeenNS = ...;

-- AddOns
local isAutoLootPlusLoaded = IsAddOnLoaded("AutoLootPlus");
local isLastSeenLoaded = IsAddOnLoaded("LastSeen");

-- Booleans
local hasSeenQuest = false;
local isCraftedItem = false;
local isMailboxOpen = false;
local isTradeOpen = false;
local isQuestItemReward = false;
local wasUpdated = false;

-- Integers
local itemID = 0;
local itemRarity = 0;
local lootedCreatureID = 0;

-- Multi-variables
local query = "";

-- Strings
local currentMap = "";
local itemLooted = "";
local itemName = "";
local itemType = "";

-- Additions to addon namespace
lastSeenNS.isAutoLootPlusLoaded = isAutoLootPlusLoaded;
lastSeenNS.isLastSeenLoaded = isLastSeenLoaded;
lastSeenNS.hasSeenQuest = hasSeenQuest;
lastSeenNS.isCraftedItem = isCraftedItem;
lastSeenNS.isMailboxOpen = isMailboxOpen;
lastSeenNS.isTradeOpen = isTradeOpen;
lastSeenNS.isQuestItemReward = isQuestItemReward;
lastSeenNS.wasUpdated = wasUpdated;
lastSeenNS.itemID = itemID;
lastSeenNS.itemRarity = itemRarity;
lastSeenNS.lootedCreatureID = lootedCreatureID;
lastSeenNS.query = query;
lastSeenNS.currentMap = currentMap;
lastSeenNS.itemLooted = itemLooted;
lastSeenNS.itemName = itemName;
lastSeenNS.itemType = itemType;