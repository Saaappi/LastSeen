--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Houses the skeleton of the system that holds loot data.
]]--

local lastseen, lastseendb = ...;

local itemstgdb = {}; -- Holds player loot data
local itemprddb = {}; -- Holds addon loot data
local itemignrdb = {}; -- Holds player item ignore data

lastseendb.itemstgdb = itemstgdb;
lastseendb.itemprddb = itemprddb;
lastseendb.itemignrdb = itemignrdb;