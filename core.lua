--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used for event handling. This is the traffic cop of the addon.
]]--

local lastSeen, lastSeenNS = ...;

-- Highest-level Variables
local today = date("%m/%d/%y");
local tip = GameTooltip;

-- AddOn Variables
local frame = CreateFrame("Frame");

frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_LOGOUT");
frame:RegisterEvent("LOOT_OPENED");
frame:RegisterEvent("QUEST_TURNED_IN");
frame:RegisterEvent("MAIL_SHOW");
frame:RegisterEvent("MAIL_CLOSED");
frame:RegisterEvent("TRADE_SHOW");
frame:RegisterEvent("TRADE_CLOSED");
frame:RegisterEvent("UNIT_SPELLCAST_SENT");

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and lastSeenNS.isLastSeenLoaded then
		lastSeenNS.currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name;
		lastSeenNS.LastSeenCreatures = LastSeenCreaturesDB; if lastSeenNS.LastSeenCreatures == nil then lastSeenNS.LastSeenCreatures = lastSeenNS.NilTable(lastSeenNS.LastSeenCreatures) end;
		lastSeenNS.LastSeenItems = LastSeenItemsDB; if lastSeenNS.LastSeenItems == nil then lastSeenNS.LastSeenItems = lastSeenNS.NilTable(lastSeenNS.LastSeenItems) else lastSeenNS.LastSeenItems = lastSeenNS.ValidateTable(lastSeenNS.LastSeenItems); end;
		lastSeenNS.LastSeenIgnoredItems = LastSeenIgnoredItemsDB; if lastSeenNS.LastSeenIgnoredItems == nil then lastSeenNS.LastSeenIgnoredItems = lastSeenNS.NilTable(lastSeenNS.LastSeenIgnoredItems) end;
		lastSeenNS.LastSeenQuests = LastSeenQuestsDB; if lastSeenNS.LastSeenQuests == nil then lastSeenNS.LastSeenQuests = lastSeenNS.NilTable(lastSeenNS.LastSeenQuests) end;
		lastSeenNS.LoadSettings(true);
		frame:UnregisterEvent("PLAYER_LOGIN");
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		lastSeenNS.currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name;
	elseif event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...;
		if unit == "player" then 
			if spellID == 6478 then -- "Opening"
				lastSeenNS.lootedSource = target;
			end
		end
	elseif event == "LOOT_OPENED" and not lastSeenNS.isAutoLootPlusLoaded then -- AutoLootPlus causes errors due to the EXTREMELY quick loot speed.
		lastSeenNS.GetLootSourceInfo();
	elseif event == "QUEST_TURNED_IN" then
		local questID, _, _ = ...;
		lastSeenNS.isQuestItemReward = true;
		lastSeenNS.QuestChoices(questID, today, lastSeenNS.currentMap);
	elseif event == "CHAT_MSG_LOOT" then
		local msg, _, _, _, unitName, _, _, _, _, _, _, _, _ = ...;
		if string.match(unitName, "(.*)-") == UnitName("player") then
			lastSeenNS.Loot(msg, today, lastSeenNS.currentMap);
		end
	elseif event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		lastSeenNS.AddCreatureByNameplate(unit);
	elseif event == "UPDATE_MOUSEOVER_UNIT" then
		lastSeenNS.AddCreatureByMouseover("mouseover");
	elseif event == "MAIL_SHOW" then
		lastSeenNS.isMailboxOpen = true;
	elseif event == "MAIL_CLOSED" then
		lastSeenNS.isMailboxOpen = false;
	elseif event == "TRADE_SHOW" then
		lastSeenNS.isTradeOpen = true;
	elseif event == "TRADE_CLOSED" then
		lastSeenNS.isTradeOpen = false;
	elseif event == "PLAYER_LOGOUT" then
		lastSeenNS.itemsToSource = {}; -- When the player's no longer needs the loot table, empty it.
		LastSeenCreaturesDB = lastSeenNS.LastSeenCreatures;
		LastSeenItemsDB = lastSeenNS.LastSeenItems;
		LastSeenIgnoredItemsDB = lastSeenNS.LastSeenIgnoredItems;
		LastSeenQuestsDB = lastSeenNS.LastSeenQuests;
	end
end);

GameTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);