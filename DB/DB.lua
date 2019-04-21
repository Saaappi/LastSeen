--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: The primary database file that holds global module data tables.
]]--

local lastseen, lastseendb = ...;

local LastSeenItems = {};
local LastSeenIgnore = {};

lastseendb.lastseen = IsAddOnLoaded("LastSeen");
lastseendb.autolootplus = IsAddOnLoaded("AutoLootPlus");