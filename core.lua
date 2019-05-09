--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used for event handling. This is the traffic cop of the addon.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

-- Highest-level Variables
local today = date("%m/%d/%y");
local hasEventBeenSeen = false;
local spellName = "";

-- AddOn Variables
local frame = CreateFrame("Frame");

frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("ITEM_UNLOCKED");
frame:RegisterEvent("LOOT_OPENED");
frame:RegisterEvent("MAIL_CLOSED");
frame:RegisterEvent("MAIL_SHOW");
frame:RegisterEvent("MERCHANT_CLOSED");
frame:RegisterEvent("MERCHANT_SHOW");
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_LOGOUT");
frame:RegisterEvent("QUEST_LOOT_RECEIVED");
frame:RegisterEvent("TRADE_CLOSED");
frame:RegisterEvent("TRADE_SHOW");
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
frame:RegisterEvent("UNIT_SPELLCAST_SENT");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and lastSeenNS.isLastSeenLoaded then
		lastSeenNS.maps = LastSeenMapsDB; if lastSeenNS.maps == nil then lastSeenNS.maps = lastSeenNS.NilTable(lastSeenNS.maps) end;
		lastSeenNS.currentMap = lastSeenNS.GetCurrentMap();
		lastSeenNS.LastSeenCreatures = LastSeenCreaturesDB; if lastSeenNS.LastSeenCreatures == nil then lastSeenNS.LastSeenCreatures = lastSeenNS.NilTable(lastSeenNS.LastSeenCreatures) end;
		lastSeenNS.LastSeenItems = LastSeenItemsDB; if lastSeenNS.LastSeenItems == nil then lastSeenNS.LastSeenItems = lastSeenNS.NilTable(lastSeenNS.LastSeenItems) else lastSeenNS.LastSeenItems = lastSeenNS.ValidateTable(lastSeenNS.LastSeenItems); end;
		lastSeenNS.LastSeenIgnoredItems = LastSeenIgnoredItemsDB; if lastSeenNS.LastSeenIgnoredItems == nil then lastSeenNS.LastSeenIgnoredItems = lastSeenNS.NilTable(lastSeenNS.LastSeenIgnoredItems) end;
		lastSeenNS.LastSeenQuests = LastSeenQuestsDB; if lastSeenNS.LastSeenQuests == nil then lastSeenNS.LastSeenQuests = lastSeenNS.NilTable(lastSeenNS.LastSeenQuests) end;
		lastSeenNS.LoadSettings(true);
		frame:UnregisterEvent("PLAYER_LOGIN");
	end
	if event == "ITEM_UNLOCKED" then
		lastSeenNS.wasLootedFromItem = true;
	end
	if event == "ZONE_CHANGED_NEW_AREA" then
		lastSeenNS.currentMap = lastSeenNS.GetCurrentMap();
	end
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...;
		spellName = GetSpellInfo(spellID);
		if unit == "player" then 
			if spellName == L["SPELL_NAME_OPENING"] then
				lastSeenNS.lootedSource = target;
			end
		end
	end
	if event == "LOOT_OPENED" and not lastSeenNS.isAutoLootPlusLoaded then -- AutoLootPlus causes errors due to the EXTREMELY quick loot speed.
		lastSeenNS.GetLootSourceInfo();
	end
	if event == "QUEST_LOOT_RECEIVED" then
		local questID, reward, _ = ...;
		lastSeenNS.QuestChoices(questID, today, lastSeenNS.currentMap);
	end
	if event == "MERCHANT_SHOW" then
		lastSeenNS.isMerchantWindowOpen = true;
		lastSeenNS.merchantName = GetUnitName("target", false);
	end
	if event == "MERCHANT_CLOSED" then
		lastSeenNS.isMerchantWindowOpen = false;
		lastSeenNS.merchantName = "";
	end
	if event == "MAIL_SHOW" then
		lastSeenNS.isMailboxOpen = true;
	elseif event == "MAIL_CLOSED" then
		lastSeenNS.isMailboxOpen = false;
	end
	if event == "TRADE_SHOW" then
		lastSeenNS.isTradeOpen = true;
	elseif event == "TRADE_CLOSED" then
		lastSeenNS.isTradeOpen = false;
	end
	if event == "CHAT_MSG_LOOT" then
		local msg, _, _, _, unitName, _, _, _, _, _, _, _, _ = ...;
		if string.match(unitName, "(.*)-") == UnitName("player") then
			lastSeenNS.Loot(msg, today, lastSeenNS.currentMap);
		end
	end
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		lastSeenNS.AddCreatureByNameplate(unit);
	end
	if event == "UPDATE_MOUSEOVER_UNIT" then
		lastSeenNS.AddCreatureByMouseover("mouseover");
	end
	if event == "PLAYER_LOGOUT" then
		lastSeenNS.itemsToSource = {}; -- When the player's no longer needs the loot table, empty it.
		LastSeenCreaturesDB = lastSeenNS.LastSeenCreatures;
		LastSeenItemsDB = lastSeenNS.LastSeenItems;
		LastSeenIgnoredItemsDB = lastSeenNS.LastSeenIgnoredItems;
		LastSeenMapsDB = lastSeenNS.maps;
		LastSeenQuestsDB = lastSeenNS.LastSeenQuests;
	end
end);

GameTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);