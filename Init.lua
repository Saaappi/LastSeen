--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Main file of the addon.
]]--

-- Namespace Variables
local lastSeen, LastSeenTbl = ...;
local L = LastSeenTbl.L;

-- Module-Local Variables
local badDataItemCount = 0;
local containerItem;
local currentDate;
local currentMap;
local executeCodeBlock = true;
local frame = CreateFrame("Frame");
local isLastSeenLoaded = IsAddOnLoaded("LastSeen");
local isPlayerInCombat;
local itemID;
local itemLink;
local itemName;
local itemRarity;
local itemSource;
local itemSourceCreatureID;
local itemType;
local questID;

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

local function IterateLootWindow(lootSlots, itemSource)
	for i = 1, lootSlots do
		local itemLink = GetLootSlotLink(i);
		if itemLink then
			LastSeenTbl.LootDetected(L["LOOT_ITEM_PUSHED_SELF"] .. itemLink, L["DATE"], LastSeenTbl.currentMap, itemSource);
		end
	end
end

local function SetBooleanToFalse()
	-- Let's the rest of the addon know that the player is no longer actively looting an object.
	LastSeenTbl.playerLootedObject = false;
	executeCodeBlock = true;
end

local function EmptyVariables()
	-- Empties the existing value of a variable after a timer's duration.
	LastSeenTbl.creatureID = "";
	LastSeenTbl.encounterName = "";
	containerItem = "";
	LastSeenTbl.lootedObject = "";
	LastSeenTbl.target = "";
end

frame:RegisterEvent("BAG_UPDATE");
frame:RegisterEvent("ENCOUNTER_START");
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
	if (event == "BAG_UPDATE") then
		EmptyVariables();
	end
	----
	-- The purpose of this check is for people who macro the "bag sort" function call.
	-- Whenever a macro calls this function it makes the addon misbehave.
	----
	if event == "PLAYER_LOGIN" and isLastSeenLoaded then
		-- Nil SavedVar checks
		if LastSeenAccountKey == nil then LastSeenAccountKey = GenerateNewKey(LastSeenAccountKey) end;
		if LastSeenMapsDB == nil then LastSeenMapsDB = InitializeTable(LastSeenMapsDB) end;
		if LastSeenCreaturesDB == nil then LastSeenCreaturesDB = InitializeTable(LastSeenCreaturesDB) end;
		if LastSeenItemsDB == nil then LastSeenItemsDB = InitializeTable(LastSeenItemsDB) end;
		if LastSeenIgnoredItemsDB == nil then LastSeenIgnoredItemsDB = InitializeTable(LastSeenIgnoredItemsDB) end;
		if LastSeenQuestsDB == nil then LastSeenQuestsDB = InitializeTable(LastSeenQuestsDB) end;
		if LastSeenSettingsCacheDB == nil then LastSeenSettingsCacheDB = InitializeTable(LastSeenSettingsCacheDB) end;
		if LastSeenLootTemplate == nil then LastSeenLootTemplate = InitializeTable(LastSeenLootTemplate) end;

		-- Other
		LastSeenTbl.LoadSettings(true);
		LastSeenTbl.GetCurrentMap();

		for k, v in pairs(LastSeenItemsDB) do -- Sets a "suspicious" tag on all existing items when the player upgrades to 8.1.5.10.
			if not v["key"] then
				v["key"] = "";
			end
			
			if not v["sourceIDs"] then -- Create an empty table for an item's source ID values.
				v["sourceIDs"] = {};
			end
			
			if not v["loot_template"] then
				v["loot_template"] = k;
			end
		end

		for k, v in pairs(LastSeenItemsDB) do -- If there are any items with bad data found or are in the ignored database, then simply remove them.
			if not LastSeenTbl.DataIsValid(k) then
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			if LastSeenTbl.ignoredItems[k] then
				table.insert(LastSeenTbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
		end

		if badDataItemCount > 0 and LastSeenTbl.mode ~= L["QUIET_MODE"] then
			print(L["ADDON_NAME"] .. L["BAD_DATA_ITEM_COUNT_TEXT1"] .. badDataItemCount .. L["BAD_DATA_ITEM_COUNT_TEXT2"]);
			badDataItemCount = 0;
		end
	end
	if event == "ENCOUNTER_START" then
		local _, encounterName = ...;
		if encounterName then
			LastSeenTbl.encounterName = encounterName;
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
			if LastSeenTbl.currentMap ~= realZoneText then
				LastSeenTbl.GetCurrentMap();
			end
		else
			C_Timer.After(3, LastSeenTbl.GetCurrentMap);
		end
		
		if not (realZoneText == LastSeenTbl.currentMap) then
			LastSeenTbl.currentMap = realZoneText;
		end
	end
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...;
		local spellName = (GetSpellInfo(spellID));
		if unit == string.lower(L["IS_PLAYER"]) then
			if LastSeenTbl.Contains(LastSeenTbl.spellLocaleNames, spellName) then
				if target then
					LastSeenTbl.target = target;
					LastSeenTbl.playerLootedObject = true;
				end
			end
		elseif unit == L["IS_NPC"] then
			if LastSeenTbl.spells[spellID] then
				C_Timer.After(5, LastSeenTbl.GetCurrentMap);
			end
		end
	end
	if event == "LOOT_OPENED" then
		EmptyVariables();
		
		local lootSlots = GetNumLootItems();
		if lootSlots < 1 then return end;

		for i = lootSlots, 1, -1 do
			local itemLink = GetLootSlotLink(i);
			local lootSources = { GetLootSourceInfo(i) };

			if itemLink then
				for j = 1, #lootSources, 2 do
					local itemID = (GetItemInfoInstant(itemLink));
					local type, _, _, _, _, creatureID = strsplit("-", lootSources[j]);
					if itemID then -- To catch items without an item ID.
						LastSeenTbl.itemsToSource[itemID] = tonumber(creatureID);
						local itemSourceCreatureID = LastSeenTbl.itemsToSource[itemID];
						local itemName = select(1, GetItemInfo(itemID));
						itemLink = LastSeenTbl.ExtractItemLink(L["LOOT_ITEM_SELF"] .. itemLink); -- The item link isn't formatted correctly from the GetLootSlotLink() function.
						local itemRarity = select(3, GetItemInfo(itemID));
						local itemType = select(6, GetItemInfo(itemID));
						
						if itemRarity >= LastSeenSettingsCacheDB.rarity then
							for k, v in pairs(LastSeenTbl.ignoredItemTypes) do
								if itemType == v and not LastSeenTbl.doNotIgnore then
									return;
								end
							end
							for k, v in pairs(LastSeenTbl.ignoredItems) do
								if itemID == k and not LastSeenTbl.doNotIgnore then
									return;
								end
							end
							if LastSeenIgnoredItemsDB[itemID] and LastSeenTbl.doNotIgnore then
								return;
							end
							
							if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
								if LastSeenCreaturesDB[itemSourceCreatureID] ~= nil then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif containerItem ~= "" then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif LastSeenTbl.encounterName ~= "" then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenTbl.encounterName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif LastSeenTbl.target ~= "" then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenTbl.target, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								else
									print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"] .. " (" .. L["RELEASE"] .. ")");
								end
							else -- An item seen for the first time.
								if LastSeenCreaturesDB[itemSourceCreatureID] ~= nil then
									LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif containerItem ~= "" then
									LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif LastSeenTbl.encounterName ~= "" then
									LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenTbl.encounterName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif LastSeenTbl.target ~= "" then
									LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenTbl.target, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								else
									print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"] .. " (" .. L["RELEASE"] .. ")");
								end
							end
						elseif LastSeenTbl.TableHasField(LastSeenItemsDB, itemID, "manualEntry") then
							if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
								if LastSeenCreaturesDB[itemSourceCreatureID] ~= nil then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif containerItem ~= "" then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif LastSeenTbl.encounterName ~= "" then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenTbl.encounterName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif LastSeenTbl.target ~= "" then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenTbl.target, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								else
									print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"] .. " (" .. L["RELEASE"] .. ")");
								end
							else -- An item seen for the first time.
								if LastSeenCreaturesDB[itemSourceCreatureID] ~= nil then
									LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif containerItem ~= "" then
									LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif LastSeenTbl.encounterName ~= "" then
									LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenTbl.encounterName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								elseif LastSeenTbl.target ~= "" then
									LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenTbl.target, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								else
									print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"] .. " (" .. L["RELEASE"] .. ")");
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
		C_Timer.After(3, EmptyVariables);
		C_Timer.After(3, SetBooleanToFalse);
	end
	if event == "QUEST_ACCEPTED" then
		local _, questID = ...;
		LastSeenTbl.LogQuestLocation(questID, LastSeenTbl.currentMap);
	end
	if event == "QUEST_LOOT_RECEIVED" then
		questID, itemLink = ...; itemID = (GetItemInfoInstant(itemLink));
		itemName = (GetItemInfo(itemID));
		itemRarity = select(3, GetItemInfo(itemID));
		itemType = select(6, GetItemInfo(itemID));
		
		if LastSeenItemsDB[itemID] then
			if LastSeenQuestsDB[questID] ~= nil then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], L["QUEST"] .. LastSeenQuestsDB[questID]["title"], LastSeenQuestsDB[questID]["location"], LastSeenTbl.GenerateItemKey(itemID));
			else
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], C_QuestLog.GetQuestInfo(questID), LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			end
		else
			if LastSeenQuestsDB[questID] ~= nil then
				LastSeenTbl.New(itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], L["QUEST"] .. LastSeenQuestsDB[questID]["title"], LastSeenQuestsDB[questID]["location"], LastSeenTbl.GenerateItemKey(itemID));
			else
				LastSeenTbl.New(itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], C_QuestLog.GetQuestInfo(questID), LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			end
		end
	end
	if event == "MAIL_INBOX_UPDATE" then
		local numMailItems = GetInboxNumItems();
		local itemLink;
		if numMailItems > 0 then
			for i = 1, numMailItems do
				local _, _, sender, subject = GetInboxHeaderInfo(i);
				if sender == L["AUCTION_HOUSE"] then
					if strfind(subject, L["AUCTION_WON_SUBJECT"]) then
						LastSeenTbl.isAuctionItem = true;
						for j = 1, ATTACHMENTS_MAX_RECEIVE do
							itemLink = GetInboxItemLink(i, j);
							if itemLink then
								itemID = (GetItemInfoInstant(itemLink));
								itemName = (GetItemInfo(itemID));
								itemRarity = select(3, GetItemInfo(itemID));
								itemType = select(6, GetItemInfo(itemID));
								if currentMap == nil then
									currentMap = LastSeenTbl.GetCurrentMap();
								end
								if LastSeenItemsDB[itemID] then
									LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], L["AUCTION_HOUSE"], LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								else
									LastSeenTbl.New(itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], L["AUCTION_HOUSE"], LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
								end
							end
						end
					end
				end
			end
		end
	end
	if event == "MAIL_CLOSED" then
		LastSeenTbl.isMailboxOpen = false;
		LastSeenTbl.isAuctionItem = false;
		LastSeenTbl.doNotUpdate = false;
	end
	if event == "ITEM_LOCKED" then
		local bagID, slotID = ...;
		if not slotID then return end; -- Using the sort button doesn't return a slotID. >.>

		local _, _, _, _, _, _, itemLink = GetContainerItemInfo(bagID, slotID);

		if itemLink then
			itemType = select(6, GetItemInfo(itemLink));
			if itemType == L["IS_MISCELLANEOUS"] or itemType == L["IS_CONSUMABLE"] then
				containerItem = (GetItemInfo(itemLink));
			end
		end
	end
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		LastSeenTbl.AddCreatureByNameplate(unit, L["DATE"]);
	end
	if event == "UPDATE_MOUSEOVER_UNIT" then
		LastSeenTbl.AddCreatureByMouseover("mouseover", L["DATE"]);
	end
	if event == "PLAYER_LOGOUT" then
		LastSeenTbl.itemsToSource = {}; -- When the player no longer needs the loot table, empty it.
		LastSeenTbl.removedItems = {}; -- This is a temporary table that should be emptied on every logout or reload.
	end
end);

GameTooltip:HookScript("OnTooltipSetItem", LastSeenTbl.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", LastSeenTbl.OnTooltipSetItem);
