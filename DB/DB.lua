------------------------------------------------------------
-- LastSeen (DB) | Oxlotus - Area 52 (US) | Copyright © 2019
------------------------------------------------------------
-- This file stores all of the addon's foundational data.

local addonName, addonTable = ...;

local LastSeenItems = {};
local LastSeenIgnore = {};
local ItemIDCache = {};

addonTable.LastSeen = IsAddOnLoaded(addonName);
addonTable.LastSeenItems = LastSeenItems;
addonTable.LastSeenIgnore = LastSeenIgnore;
addonTable.LastSeenItemIDCache = ItemIDCache;