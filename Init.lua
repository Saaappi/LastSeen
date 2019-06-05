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
local isPlayerInCombat;
local isQuestItemReward;
local frame = CreateFrame("Frame");
local isLastSeenLoaded = IsAddOnLoaded("LastSeen");
local object = "";
local today = date("%m/%d/%y");

-- Module-Local Functions
local function InitializeTable(tbl)
	tbl = {};
	return tbl;
end

local function IsPlayerInCombat()
	-- Maps can't be updated while the player is in combat.
	if UnitAffectingCombat(L["IS_PLAYER"]) then
		isPlayerInCombat = true;
	else
		isPlayerInCombat = false;
	end
end

local function GetCurrentMap()
	if C_Map.GetBestMapForUnit(L["IS_PLAYER"]) then -- A map ID was found and is usable.
		local currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit(L["IS_PLAYER"]));
		if not currentMap.mapID then return end;
		if not LastSeenMapsDB[currentMap.mapID] then
			LastSeenMapsDB[currentMap.mapID] = currentMap.name;
		end
		
		lastSeenNS.currentMap = currentMap.name;
	else
		C_Timer.After(3, GetCurrentMap); -- Recursively call the function every 3 seconds until a map ID is found.
	end
end

local function SetBooleanToFalse()
	-- Let's the rest of the addon know that the player is no longer actively looting an object.
	lastSeenNS.playerLootedObject = false;
end

local function EmptyVariables()
	-- Empties the existing value of a variable after a timer's duration.
	lastSeenNS.lootedItem = "";
	lastSeenNS.lootedObject = "";
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
frame:RegisterEvent("QUEST_ACCEPTED");
frame:RegisterEvent("QUEST_LOOT_RECEIVED");
frame:RegisterEvent("TRADE_CLOSED");
frame:RegisterEvent("TRADE_SHOW");
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
frame:RegisterEvent("UNIT_SPELLCAST_SENT");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED");
frame:RegisterEvent("ITEM_LOCKED");

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
	if event == "ZONE_CHANGED_NEW_AREA" or "INSTANCE_GROUP_SIZE_CHANGED" then
		if IsPlayerInCombat() then -- Apparently maps can't update in combat without tossing an exception.
			while isPlayerInCombat do
				C_Timer.After(3, IsPlayerInCombat);
			end
		end
		C_Timer.After(3, GetCurrentMap);
	end
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...;
		if unit == L["IS_PLAYER"] then 
			if lastSeenNS.spells[spellID] then
				lastSeenNS.target = target;
				lastSeenNS.playerLootedObject = true;
			end
		end
	end
	if event == "LOOT_OPENED" and not lastSeenNS.isAutoLootPlusLoaded then -- AutoLootPlus causes errors due to the EXTREMELY quick loot speed.
		local lootSlots = GetNumLootItems();
		if lootSlots < 1 then return end;
		
		if lastSeenNS.lootedItem ~= "" then -- An item container was looted.
			for i = 1, lootSlots do
				local itemLink = GetLootSlotLink(i);
				if itemLink then
					lastSeenNS.LootDetected(L["LOOT_ITEM_PUSHED_SELF"] .. itemLink, today, lastSeenNS.currentMap, L["IS_MISCELLANEOUS"]);
				end
			end
		else
			for i = 1, lootSlots do
				local itemLink = GetLootSlotLink(i);
				local lootSources = { GetLootSourceInfo(i) };
				
				if itemLink then
					for j = 1, #lootSources, 2 do
						local itemID = select(1, GetItemInfoInstant(itemLink));
						local type, _, _, _, _, creatureID = strsplit("-", lootSources[j]);
						if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
							if itemID then -- To catch items without an item ID.
								lastSeenNS.itemsToSource[itemID] = tonumber(creatureID);
							end
						end
					end
				end
			end
		end
	end
	if event == "LOOT_CLOSED" then
		-- Empty all used values.
		C_Timer.After(3, EmptyVariables);
		C_Timer.After(3, SetBooleanToFalse);
	end
	if event == "QUEST_ACCEPTED" then
		local _, questID = ...;
		lastSeenNS.LogQuestLocation(questID, lastSeenNS.currentMap);
	end
	if event == "QUEST_LOOT_RECEIVED" then
		isQuestItemReward = true;
		lastSeenNS.questID, lastSeenNS.itemLink = ...;
		lastSeenNS.LootDetected(L["LOOT_ITEM_PUSHED_SELF"], today, lastSeenNS.currentMap, L["IS_QUEST_ITEM"]);
	end
	if event == "MERCHANT_SHOW" then
		lastSeenNS.isMerchantWindowOpen = true;
		lastSeenNS.merchantName = GetUnitName("target", false);
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
							local _, itemID = GetInboxItem(i, 1);
							if itemID then
								local _, itemLink = GetItemInfo(itemID);
								lastSeenNS.otherSource = true;
								lastSeenNS.LootDetected(L["LOOT_ITEM_PUSHED_SELF"] .. itemLink, today, lastSeenNS.currentMap, L["MAIL"]);
							end
						end
					else
						lastSeenNS.doNotUpdate = true;
					end
				end
			end
		end
	end
	if event == "MAIL_CLOSED" then
		lastSeenNS.isMailboxOpen = false;
		lastSeenNS.doNotUpdate = false;
	end
	if event == "TRADE_SHOW" then
		lastSeenNS.isTradeOpen = true;
	end
	if event == "TRADE_CLOSED" then
		lastSeenNS.isTradeOpen = false;
	end
	if event == "CHAT_MSG_LOOT" then
		if isQuestItemReward then
			isQuestItemReward = false;
		else
			local constant, _, _, _, unitName = ...;
			if string.match(unitName, "(.*)-") == UnitName("player") then
				lastSeenNS.LootDetected(constant, today, lastSeenNS.currentMap, ""); -- Regular loot scenarios don't require a specific source.
			end
		end
	end
	if event == "ITEM_LOCKED" then
		local bagID, slotID = ...;
		if not slotID then return end; -- Using the sort button doesn't return a slotID. >.>
		
		local _, _, _, _, _, _, itemLink = GetContainerItemInfo(bagID, slotID);
		
		if itemLink then
			local itemType = select(6, GetItemInfo(itemLink));
			if itemType == L["IS_MISCELLANEOUS"] then
				lastSeenNS.lootedItem = select(1, GetItemInfo(itemLink));
			end
		end
	end
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		lastSeenNS.AddCreatureByNameplate(unit, today);
	end
	if event == "UPDATE_MOUSEOVER_UNIT" then
		lastSeenNS.AddCreatureByMouseover("mouseover", today);
	end
	if event == "PLAYER_LOGOUT" then
		lastSeenNS.itemsToSource = {}; -- When the player no longer needs the loot table, empty it.
	end
end);

GameTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);