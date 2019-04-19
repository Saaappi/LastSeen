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

local savedvariables = { -- A simple list of the addon's savedvariables tables.
	"LastSeenItemsDB", 
	"LastSeenIgnoresDB",
	"LastSeenItemIDCacheDB", 
	"LastSeenSettingsCacheDB"
};
local primarytables = { -- A simple list of the addon's main in-mem tables.
	"lastseendb.itemstgdb",
	"lastseendb.itemignrdb",
	"lastseendb.itemprddb",
	"lastseendb.settingsdb"
};

lastseendb.LastSeen = IsAddOnLoaded(lastseen);
--lastseendb.LastSeenItems = LastSeenItems;
--lastseendb.LastSeenIgnore = LastSeenIgnore;
--lastseendb.LastSeenItemIDCache = ItemIDCache;

lastseendb.savedvariables = savedvariables;
lastseendb.primarytables = primarytables;