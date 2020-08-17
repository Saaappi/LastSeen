local addon, tbl = ...;
local L = tbl.L

-- ARRAYS (TABLES)
local itemsToSource 										= {}; -- The data here is temporary intentionally.
local removedItems 											= {};
tbl.itemsToSource 											= itemsToSource
tbl.removedItems 											= removedItems

-- BOOLEANS
local doNotIgnore 											= false
local doNotLoot
local doNotUpdate 											= false
local isAutoLootPlusLoaded 									= IsAddOnLoaded("AutoLootPlus");
local isFasterLootLoaded 									= IsAddOnLoaded("FasterLoot");
local isInInstance 											= false
local isLastSeenLoaded 										= IsAddOnLoaded("LastSeen");
local wasUpdated 											= false
tbl.doNotIgnore 											= doNotIgnore
tbl.doNotLoot 												= doNotLoot
tbl.doNotUpdate 											= doNotUpdate
tbl.isAutoLootPlusLoaded 									= isAutoLootPlusLoaded
tbl.isFasterLootLoaded 										= isFasterLootLoaded
tbl.isInInstance 											= isInInstance
tbl.isLastSeenLoaded 										= isLastSeenLoaded
tbl.wasUpdated 												= wasUpdated

-- INTEGERS
local itemSourceCreatureID 									= 0
local maxHistoryEntries										= 20
local questID												= 0
tbl.itemSourceCreatureID 									= itemSourceCreatureID
tbl.maxHistoryEntries										= maxHistoryEntries
tbl.questID													= 0

-- STRINGS
local currentMap 											= "";
local query 												= "";
tbl.currentMap 												= currentMap
tbl.query 													= query