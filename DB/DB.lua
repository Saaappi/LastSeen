--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: The primary database file that holds global module data tables.
]]--

local lastseen, lastseendb = ...;

local LastSeenItems = {};
local LastSeenIgnore = {};
local ItemIDCache = {};

lastseendb.lastseen = IsAddOnLoaded("LastSeen");
--lastseendb.LastSeenItems = LastSeenItems;
--lastseendb.LastSeenIgnore = LastSeenIgnore;
--lastseendb.LastSeenItemIDCache = ItemIDCache;