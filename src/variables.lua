local addon, addonTbl = ...;
local L = addonTbl.L;

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

local removedItems = {};

-- Additions to the namespace
addonTbl.itemsToSource = itemsToSource;
addonTbl.removedItems = removedItems;

-- OPTIONS
addonTbl.doNotIgnore = doNotIgnore;

-- ADDONS
addonTbl.isAutoLootPlusLoaded = isAutoLootPlusLoaded;
addonTbl.isFasterLootLoaded = isFasterLootLoaded;
addonTbl.isaddonLoaded = isaddonLoaded;
	
-- ICONS
addonTbl.badDataIcon = badDataIcon;
addonTbl.questionMarkIcon = questionMarkIcon;
addonTbl.poorIcon = poorIcon;
addonTbl.commonIcon = commonIcon;
addonTbl.uncommonIcon = uncommonIcon;
addonTbl.rareIcon = rareIcon;
addonTbl.epicIcon = epicIcon;
addonTbl.legendaryIcon = legendaryIcon;
addonTbl.artifactIcon = artifactIcon;
	
-- INTEGERS
addonTbl.itemID = itemID;
addonTbl.itemRarity = itemRarity;
addonTbl.lootedCreatureID = lootedCreatureID;
addonTbl.mapID = mapID;
addonTbl.rank_poor = rank_poor;
addonTbl.rank_common = rank_common;
addonTbl.rank_uncommon = rank_uncommon;
addonTbl.rank_rare = rank_rare;
addonTbl.rank_epic = rank_epic;
addonTbl.rank_legendary = rank_legendary;
addonTbl.rank_artifact = rank_artifact;

-- MISCELLANEOUS
addonTbl.doNotUpdate = doNotUpdate;
addonTbl.isAuctionItem = isAuctionItem;
addonTbl.isInInstance = isInInstance;
addonTbl.isMailboxOpen = isMailboxOpen;
addonTbl.isQuestReward = isQuestReward;
addonTbl.playerLootedObject = playerLootedObject;
addonTbl.wasLootedFromItem = wasLootedFromItem;
addonTbl.wasUpdated = wasUpdated;
addonTbl.query = query;
addonTbl.currentMap = currentMap;
addonTbl.itemLooted = itemLooted;
addonTbl.itemName = itemName;
addonTbl.itemType = itemType;
addonTbl.lootedItem = lootedItem;
addonTbl.lootedObject = lootedObject;