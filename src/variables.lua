local addon, addonTbl = ...;
local L = addonTbl.L;

-- ARRAYS (TABLES)
local itemsToSource = {}; -- The data here is temporary intentionally.
local removedItems = {};
addonTbl.itemsToSource = itemsToSource;
addonTbl.removedItems = removedItems;

-- BOOLEANS
local doNotIgnore = false;
local doNotLoot;
local doNotUpdate = false;
local isAutoLootPlusLoaded = IsAddOnLoaded("AutoLootPlus");
local isFasterLootLoaded = IsAddOnLoaded("FasterLoot");
local isInInstance = false;
local isLastSeenLoaded = IsAddOnLoaded("LastSeen");
local wasUpdated = false;
addonTbl.doNotIgnore = doNotIgnore;
addonTbl.doNotLoot = doNotLoot;
addonTbl.doNotUpdate = doNotUpdate;
addonTbl.isAutoLootPlusLoaded = isAutoLootPlusLoaded;
addonTbl.isFasterLootLoaded = isFasterLootLoaded;
addonTbl.isInInstance = isInInstance;
addonTbl.isLastSeenLoaded = isLastSeenLoaded;
addonTbl.wasUpdated = wasUpdated;

-- INTEGERS
local itemSourceCreatureID;
addonTbl.itemSourceCreatureID = itemSourceCreatureID;

-- STRINGS
local currentMap = "";
local query = "";
addonTbl.currentMap = currentMap;
addonTbl.query = query;