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
local frame = CreateFrame("Frame");
local isLastSeenLoaded = IsAddOnLoaded("LastSeen");
local today = date("%m/%d/%y");
local questID;
local itemID;
local itemLink;
local badDataItemCount = 0;

-- Module-Local Functions
local function InitializeTable(tbl)
	tbl = {};
	return tbl;
end

local function GenerateNewKey(key)
	key = "";
	local playerName = select(1, UnitName("player"));
	local guid = UnitGUID("player"); guid = guid:gsub(L["IS_PLAYER"], ""); guid = guid:gsub("-", "");

	for i = 1, #playerName do
		key = key .. string.byte(playerName:sub(i, i));
	end

	key = GetAccountExpansionLevel() .. GetBillingTimeRested() .. key .. guid;

	return key;
end

local function IsPlayerInCombat()
	-- Maps can't be updated while the player is in combat.
	if UnitAffectingCombat(L["IS_PLAYER"]) then
		isPlayerInCombat = true;
	else
		isPlayerInCombat = false;
	end
end

local function IterateLootTable(lootSlots, itemSource)
	for i = 1, lootSlots do
		local itemLink = GetLootSlotLink(i);
		if itemLink then
			lastSeenNS.LootDetected(L["LOOT_ITEM_PUSHED_SELF"] .. itemLink, today, lastSeenNS.currentMap, itemSource);
		end
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
	lastSeenNS.target = "";
end

frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED");
frame:RegisterEvent("ITEM_LOCKED");
frame:RegisterEvent("LOOT_CLOSED");
frame:RegisterEvent("LOOT_OPENED");
frame:RegisterEvent("MAIL_CLOSED");
frame:RegisterEvent("MAIL_INBOX_UPDATE");
frame:RegisterEvent("NAME_PLATE_UNIT_ADDED");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_LOGOUT");
frame:RegisterEvent("QUEST_ACCEPTED");
frame:RegisterEvent("QUEST_LOOT_RECEIVED");
frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
frame:RegisterEvent("UNIT_SPELLCAST_SENT");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and isLastSeenLoaded then
		-- Nil SavedVar checks
		if LastSeenAccountKey == nil then LastSeenAccountKey = GenerateNewKey(LastSeenAccountKey) end;
		if LastSeenMapsDB == nil then LastSeenMapsDB = InitializeTable(LastSeenMapsDB) end;
		if LastSeenCreaturesDB == nil then LastSeenCreaturesDB = InitializeTable(LastSeenCreaturesDB) end;
		if LastSeenItemsDB == nil then LastSeenItemsDB = InitializeTable(LastSeenItemsDB) end;
		if LastSeenIgnoredItemsDB == nil then LastSeenIgnoredItemsDB = InitializeTable(LastSeenIgnoredItemsDB) end;
		if LastSeenQuestsDB == nil then LastSeenQuestsDB = InitializeTable(LastSeenQuestsDB) end;
		if LastSeenSettingsCacheDB == nil then LastSeenSettingsCacheDB = InitializeTable(LastSeenSettingsCacheDB) end;

		-- Other
		lastSeenNS.LoadSettings(true);
		lastSeenNS.GetCurrentMap();

		for k, v in pairs(LastSeenItemsDB) do -- Sets a "suspicious" tag on all existing items when the player upgrades to 8.1.5.10.
			if not v["key"] then
				v["key"] = "";
			end
		end

		for k, v in pairs(LastSeenItemsDB) do -- If there are any items with bad data found or are in the ignored database, then simply remove them.
			if not lastSeenNS.DataIsValid(k) then
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			if lastSeenNS.ignoredItems[k] then
				table.insert(lastSeenNS.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
		end

		if badDataItemCount > 0 and lastSeenNS.mode ~= L["QUIET_MODE"] then
			print(L["ADDON_NAME"] .. L["BAD_DATA_ITEM_COUNT_TEXT1"] .. badDataItemCount .. L["BAD_DATA_ITEM_COUNT_TEXT2"]);
			badDataItemCount = 0;
		end
	end
	if event == "ZONE_CHANGED_NEW_AREA" or "INSTANCE_GROUP_SIZE_CHANGED" then
		local realZoneText = GetRealZoneText(); -- Grabs the localized name of the zone the player is currently in.
		
		if IsPlayerInCombat() then -- Apparently maps can't update in combat without tossing an exception.
			while isPlayerInCombat do
				C_Timer.After(3, IsPlayerInCombat);
			end
		end
		
		if realZoneText then -- We want to make sure that it's not nil.
			if lastSeenNS.currentMap ~= realZoneText then
				lastSeenNS.GetCurrentMap();
			end
		else
			C_Timer.After(3, lastSeenNS.GetCurrentMap);
		end
	end
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...;
		if unit == string.lower(L["IS_PLAYER"]) then
			if lastSeenNS.spells[spellID] then
				lastSeenNS.target = target;
				lastSeenNS.playerLootedObject = true;
				C_Timer.After(8, EmptyVariables); -- Regardless of what happens, clear these variables after 8 seconds.
				C_Timer.After(8, SetBooleanToFalse);
			end
		elseif unit == L["IS_NPC"] then
			if lastSeenNS.spells[spellID] then
				C_Timer.After(5, lastSeenNS.GetCurrentMap);
			end
		end
	end
	if event == "LOOT_OPENED" and not lastSeenNS.isAutoLootPlusLoaded then -- AutoLootPlus causes errors due to the EXTREMELY quick loot speed.
		local lootSlots = GetNumLootItems();
		if lootSlots < 1 then return end;

		if lastSeenNS.lootedItem ~= "" then -- An item container was looted.
			IterateLootTable(lootSlots, L["IS_MISCELLANEOUS"]); return;
		elseif lastSeenNS.playerLootedObject then -- A world object was looted.
			IterateLootTable(lootSlots, L["IS_OBJECT"]); return;
		else
			for i = 1, lootSlots do
				local itemLink = GetLootSlotLink(i);
				local lootSources = { GetLootSourceInfo(i) };

				if itemLink then
					for j = 1, #lootSources, 2 do
						itemID = select(1, GetItemInfoInstant(itemLink));
						local type, _, _, _, _, creatureID = strsplit("-", lootSources[j]);
						if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
							if itemID then -- To catch items without an item ID.
								lastSeenNS.itemsToSource[itemID] = tonumber(creatureID);
								if lastSeenNS.lootControl then -- Track items when the loot window is open.
									local itemSourceCreatureID = lastSeenNS.itemsToSource[itemID];
									local itemLink = select(2, GetItemInfo(itemID));
									local itemName = select(1, GetItemInfo(itemID));
									local itemRarity = select(3, GetItemInfo(itemID));
									local itemType = select(6, GetItemInfo(itemID));
									local itemSourceCreatureID = lastSeenNS.itemsToSource[itemID];
									
									if itemRarity >= LastSeenSettingsCacheDB.rarity then
										for k, v in pairs(lastSeenNS.ignoredItemTypes) do
											if itemType == v and not lastSeenNS.doNotIgnore then
												return;
											end
										end
										for k, v in pairs(lastSeenNS.ignoredItems) do
											if itemID == k and not lastSeenNS.doNotIgnore then
												return;
											end
										end
										if LastSeenIgnoredItemsDB[itemID] and lastSeenNS.doNotIgnore then
											return;
										end

										if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
											if itemSourceCreatureID ~= nil then
												lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, lastSeenNS.currentMap, lastSeenNS.GenerateItemKey(itemID));
											end
										else -- An item seen for the first time.
											if itemSourceCreatureID ~= nil then
												if LastSeenCreaturesDB[itemSourceCreatureID] and not lastSeenNS.isMailboxOpen then
													if not lastSeenNS.isAutoLootPlusLoaded then
														lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, lastSeenNS.currentMap, lastSeenNS.GenerateItemKey(itemID));
													end
												else
													print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"]);
												end
											end
										end
									elseif lastSeenNS.TableHasField(LastSeenItemsDB, itemID, "manualEntry") then
										if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
											if itemSourceCreatureID ~= nil then
												lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, lastSeenNS.currentMap, lastSeenNS.GenerateItemKey(itemID));
											end
										else -- An item seen for the first time.
											if itemSourceCreatureID ~= nil then
												if LastSeenCreaturesDB[itemSourceCreatureID] and not lastSeenNS.isMailboxOpen then
													if not lastSeenNS.isAutoLootPlusLoaded then
														lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, lastSeenNS.currentMap, lastSeenNS.GenerateItemKey(itemID));
													end
												else
													print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"]);
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	if event == "LOOT_CLOSED" then
		-- Empty all used values.
		C_Timer.After(1, EmptyVariables);
		C_Timer.After(1, SetBooleanToFalse);
	end
	if event == "QUEST_ACCEPTED" then
		local _, questID = ...;
		lastSeenNS.LogQuestLocation(questID, lastSeenNS.currentMap);
	end
	if event == "QUEST_LOOT_RECEIVED" then
		lastSeenNS.isQuestReward = true;
		questID, itemLink = ...;
	end
	if event == "MAIL_INBOX_UPDATE" then
		local numMailItems = GetInboxNumItems();
		if numMailItems > 0 then
			for i = 1, numMailItems do
				local _, _, sender, subject = GetInboxHeaderInfo(i);
				if not sender then -- Sender can sometimes be nil, I guess...
				else
					if sender == L["AUCTION_HOUSE"] then
						if strfind(subject, L["AUCTION_WON_SUBJECT"]) then
							lastSeenNS.isAuctionItem = true;
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
		lastSeenNS.isAuctionItem = false;
		lastSeenNS.doNotUpdate = false;
	end
	if event == "CHAT_MSG_LOOT" then
		local constant, _, _, _, unitName = ...;
		if string.match(unitName, "(.*)-") == UnitName("player") then
			if lastSeenNS.playerLootedObject then
				lastSeenNS.LootDetected(constant, today, lastSeenNS.currentMap, L["IS_OBJECT"]);
			elseif lastSeenNS.isAuctionItem then
				lastSeenNS.LootDetected(constant, today, lastSeenNS.currentMap, L["AUCTION_HOUSE_SOURCE"]);
			elseif lastSeenNS.isQuestReward then
				lastSeenNS.LootDetected(L["LOOT_ITEM_PUSHED_SELF"] .. itemLink, today, lastSeenNS.currentMap, L["IS_QUEST_ITEM"], questID);
			end
		end
	end
	if event == "ITEM_LOCKED" then
		local bagID, slotID = ...;
		if not slotID then return end; -- Using the sort button doesn't return a slotID. >.>

		local _, _, _, _, _, _, itemLink = GetContainerItemInfo(bagID, slotID);

		if itemLink then
			local itemType = select(6, GetItemInfo(itemLink));
			if itemType == L["IS_MISCELLANEOUS"] or itemType == L["IS_CONSUMABLE"] then
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
		--lastSeenNS.itemsToSource = {}; -- When the player no longer needs the loot table, empty it.
		lastSeenNS.removedItems = {}; -- This is a temporary table that should be emptied on every logout or reload.
	end
end);

GameTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", lastSeenNS.OnTooltipSetItem);
