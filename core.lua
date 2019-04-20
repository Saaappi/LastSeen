--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used for event handling. This is the traffic cop of the addon.
]]--

local lastseen, lastseendb = ...;

-- Highest-level Variables
local today = date("%m/%d/%y");
local itemLooted = "";
local currentMap = "";
lastseendb.isMailboxOpen = false;
lastseendb.isTradeOpen = false;

-- AddOn Variables
local eventFrame = CreateFrame("Frame");

eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
eventFrame:RegisterEvent("CHAT_MSG_LOOT");
eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
eventFrame:RegisterEvent("PLAYER_LOGIN");
eventFrame:RegisterEvent("PLAYER_LOGOUT");
eventFrame:RegisterEvent("LOOT_OPENED");
eventFrame:RegisterEvent("MAIL_SHOW");
eventFrame:RegisterEvent("MAIL_CLOSED");
eventFrame:RegisterEvent("TRADE_SHOW");
eventFrame:RegisterEvent("TRADE_CLOSED");

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and lastseendb.lastseen then
		currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name;
		lastseendb.creaturedb = LastSeenCreatureDB;
		lastseendb.itemstgdb = LastSeenItemsDB;
		lastseendb.itemignrdb = LastSeenIgnoresDB;
		LoadLastSeenSettings(true);
		eventFrame:UnregisterEvent("PLAYER_LOGIN");
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name;
	elseif event == "LOOT_OPENED" then
		lastseendb:lootsourceinfo();
	elseif event == "CHAT_MSG_LOOT" then
		local msg, _, _, _, unitName, _, _, _, _, _, _, _, _ = ...;
		if string.match(unitName, "(.*)-") == UnitName("player") then
			lastseendb:checkloot(msg, today, currentMap);
		end
	elseif event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		lastseendb:addcreaturebynameplate(unit);
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		lastseendb:addcreaturebymouseover("mouseover");
	elseif event == "MAIL_SHOW" then
		lastseendb.isMailboxOpen = true;
	elseif event == "MAIL_CLOSED" then
		lastseendb.isMailboxOpen = false;
	elseif event == "TRADE_SHOW" then
		lastseendb.isTradeOpen = true;
	elseif event == "TRADE_CLOSED" then
		lastseendb.isTradeOpen = false;
	elseif event == "PLAYER_LOGOUT" then
		LastSeenCreatureDB = lastseendb.creaturedb;
		LastSeenItemsDB = lastseendb.itemstgdb;
		LastSeenIgnoresDB = lastseendb.itemignrdb;
	end
end)