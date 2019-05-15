--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Main file of the addon.
]]--

-- Namespace Variables
local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

-- Module-Local Variables
local frame = CreateFrame("Frame");
local isLastSeenLoaded = IsAddOnLoaded("LastSeen");
local object = "";
local today = date("%m/%d/%y");

-- Module-Local Functions
local function InitializeTable(tbl)
	tbl = {};
	return tbl;
end

local function GetCurrentMap()
	local currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player"));
	if not currentMap.mapID then return end;
	if not LastSeenMapsDB[currentMap.mapID] then
		LastSeenMapsDB[currentMap.mapID] = currentMap.name;
	end
	
	lastSeenNS.currentMap = currentMap.name;
end

frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("LOOT_CLOSED");
frame:RegisterEvent("LOOT_OPENED");
frame:RegisterEvent("MAIL_CLOSED");
frame:RegisterEvent("MAIL_INBOX_UPDATE");
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
	if event == "PLAYER_LOGIN" and isLastSeenLoaded then
		-- Nil SavedVar checks
		if LastSeenMapsDB == nil then LastSeenMapsDB = InitializeTable(LastSeenMapsDB) end;
		if LastSeenCreaturesDB == nil then LastSeenCreaturesDB = InitializeTable(LastSeenCreaturesDB) end;
		if LastSeenItemsDB == nil then LastSeenItemsDB = InitializeTable(LastSeenItemsDB) end;
		if LastSeenIgnoredItemsDB == nil then LastSeenIgnoredItemsDB = InitializeTable(LastSeenIgnoredItemsDB) end;
		if LastSeenQuestsDB == nil then LastSeenQuestsDB = InitializeTable(LastSeenQuestsDB) end;
		if LastSeenSettingsCacheDB == nil then LastSeenSettingsCacheDB = InitializeTable(LastSeenSettingsCacheDB) end;
		
		-- Other
		lastSeenNS.LoadSettings(true);
		GetCurrentMap();
	end
	if event == "ZONE_CHANGED_NEW_AREA" then
		if UnitAffectingCombat(L["IS_PLAYER"]) then -- Apparently maps can't update in combat without tossing an exception.
			local playerInCombat = true;
			while playerInCombat do
				playerInCombat = C_Timer.After(3, UnitAffectingCombat(L["IS_PLAYER"]));
			end
		end
		C_Timer.After(3, GetCurrentMap);
	end
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...;
		if unit == L["IS_PLAYER"] then 
			if lastSeenNS.spells[spellID] then
				lastSeenNS.lootedObject = "|cff3377FF" .. target .. "|r";
			end
		end
	end
	if event == "LOOT_OPENED" and not lastSeenNS.isAutoLootPlusLoaded then -- AutoLootPlus causes errors due to the EXTREMELY quick loot speed.
		local lootSlots = GetNumLootItems();
		if lootSlots < 1 then return end;
	
		for i = 1, lootSlots do
			local itemLink = GetLootSlotLink(i);
			local lootSources = { GetLootSourceInfo(i) };
			
			if itemLink then
				for j = 1, #lootSources, 2 do
					local itemID = lastSeenNS.GetItemID(itemLink);
					local type, _, _, _, _, creatureID = strsplit("-", lootSources[j]);
					if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
						lastSeenNS.itemsToSource[itemID] = tonumber(creatureID);
					end
				end
			end
		end
	end
	if event == "LOOT_CLOSED" then
		-- Empty all used values.
		lastSeenNS.lootedItem = "";
	end
	if event == "QUEST_LOOT_RECEIVED" then
		local questID, itemLink = ...;
		lastSeenNS.QuestChoices(questID, itemLink, today, lastSeenNS.currentMap);
	end
	if event == "MERCHANT_SHOW" then
		lastSeenNS.isMerchantWindowOpen = true;
		lastSeenNS.merchantName = "|cff5AF893" .. GetUnitName("target", false) .. "|r";
	end
	if event == "MERCHANT_CLOSED" then
		lastSeenNS.isMerchantWindowOpen = false;
		lastSeenNS.merchantName = "";
	end
	if event == "MAIL_INBOX_UPDATE" then
		lastSeenNS.isMailboxOpen = true;
		local numMailItems = GetInboxNumItems();
		if numMailItems > 0 then
			for i = 1, numMailItems do
				local _, _, sender, subject = GetInboxHeaderInfo(i);
				if not sender then -- Sender can sometimes be nil, I guess...
				else
					if string.find(sender, L["AUCTION"]) then
						if string.find(subject, L["WON"]) then
							lastSeenNS.isAuctionItem = true;
							TakeInboxItem(i, 1);
						end
					end
				end
			end
		end
	end
	if event == "MAIL_CLOSED" then
		lastSeenNS.isMailboxOpen = false;
	end
	if event == "TRADE_SHOW" then
		lastSeenNS.isTradeOpen = true;
	end
	if event == "TRADE_CLOSED" then
		lastSeenNS.isTradeOpen = false;
	end
	if event == "CHAT_MSG_LOOT" then
		local msg, _, _, _, unitName = ...;
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
		lastSeenNS.itemsToSource = {}; -- When the player no longer needs the loot table, empty it.
	end
end);

GameTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);