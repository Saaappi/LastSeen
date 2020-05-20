local addon, addonTbl = ...;
local L = addonTbl.L;

-- ARRAYS (TABLES)
local itemsToSource = {}; -- The data here is temporary intentionally.
local removedItems = {};
addonTbl.itemsToSource = itemsToSource;
addonTbl.removedItems = removedItems;

-- BOOLEANS
local doNotIgnore = false;
local doNotUpdate = false;
local isAutoLootPlusLoaded = IsAddOnLoaded("AutoLootPlus");
local isFasterLootLoaded = IsAddOnLoaded("FasterLoot");
local isInInstance = false;
local wasUpdated = false;
addonTbl.doNotIgnore = doNotIgnore;
addonTbl.doNotUpdate = doNotUpdate;
addonTbl.isAutoLootPlusLoaded = isAutoLootPlusLoaded;
addonTbl.isFasterLootLoaded = isFasterLootLoaded;
addonTbl.isInInstance = isInInstance;
addonTbl.wasUpdated = wasUpdated;

-- STRINGS
local currentMap = "";
local query = "";
addonTbl.currentMap = currentMap;
addonTbl.query = query;