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

local function IterateLootWindow(lootSlots, itemSource)
	for i = 1, lootSlots do
		local itemLink = GetLootSlotLink(i);
		if itemLink then
			LastSeenTbl.LootDetected(L["LOOT_ITEM_PUSHED_SELF"] .. itemLink, today, LastSeenTbl.currentMap, itemSource);
		end
	end
end

local function SetBooleanToFalse()
	-- Let's the rest of the addon know that the player is no longer actively looting an object.
	LastSeenTbl.playerLootedObject = false;
end

local function EmptyVariables()
	-- Empties the existing value of a variable after a timer's duration.
	LastSeenTbl.lootedItem = "";
	LastSeenTbl.lootedObject = "";
	LastSeenTbl.target = "";
	LastSeenTbl.encounterName = "";
end

frame:RegisterEvent("BAG_UPDATE");
frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("CVAR_UPDATE");
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
	if event == "CHAT_MSG_LOOT" then
		local constant, _, _, _, unitName = ...;
		if string.match(unitName, "(.*)-") == UnitName("player") then
			if LastSeenTbl.playerLootedObject then
				LastSeenTbl.LootDetected(constant, today, LastSeenTbl.currentMap, L["IS_OBJECT"]);
			elseif LastSeenTbl.isAuctionItem then
				LastSeenTbl.LootDetected(constant, today, LastSeenTbl.currentMap, L["AUCTION_HOUSE_SOURCE"]);
			elseif LastSeenTbl.isQuestReward then
				LastSeenTbl.LootDetected(L["LOOT_ITEM_PUSHED_SELF"] .. itemLink, today, LastSeenTbl.currentMap, L["IS_QUEST_ITEM"], questID);
			elseif itemID ~= nil or itemID ~= 0 then
				LastSeenTbl.LootDetected(constant, today, LastSeenTbl.GetCurrentMap(), ""); -- Regular loot scenarios don't require a specific source.
			end
		end
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
	if event == "CVAR_UPDATE" then
		local cvar, value = ...;
		if (cvar == "AUTO_LOOT_DEFAULT_TEXT") then
			if (value == "0") then
				if LastSeenTbl.tab1.lootControlButton then
					LastSeenTbl.tab1.lootControlButton:Enable();
					LastSeenTbl.tab1.lootControlButton.text:SetText(L["OPTIONS_LOOT_CONTROL"]);
				end
			else
				LastSeenTbl.lootControl = false;
				if LastSeenTbl.tab1.lootControlButton then
					LastSeenTbl.tab1.lootControlButton:Disable();
					LastSeenTbl.tab1.lootControlButton:SetChecked(false);
					LastSeenTbl.tab1.lootControlButton.text:SetText("|cff9d9d9d" .. L["OPTIONS_LOOT_CONTROL"] .. "|r");
				end
			end
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
		if unit == string.lower(L["IS_PLAYER"]) then
			if LastSeenTbl.spells[spellID] then
				LastSeenTbl.target = target;
				LastSeenTbl.playerLootedObject = true;
				C_Timer.After(8, EmptyVariables); -- Regardless of what happens, clear these variables after 8 seconds.
				C_Timer.After(8, SetBooleanToFalse);
			end
		elseif unit == L["IS_NPC"] then
			if LastSeenTbl.spells[spellID] then
				C_Timer.After(5, LastSeenTbl.GetCurrentMap);
			end
		end
	end
	if event == "LOOT_OPENED" and not LastSeenTbl.isAutoLootPlusLoaded then -- AutoLootPlus causes errors due to the EXTREMELY quick loot speed.
		local lootSlots = GetNumLootItems();
		if lootSlots < 1 then return end;

		if LastSeenTbl.lootedItem ~= "" then -- An item container was looted.
			IterateLootWindow(lootSlots, L["IS_MISCELLANEOUS"]); return;
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
								LastSeenTbl.itemsToSource[itemID] = tonumber(creatureID);
								local itemSourceCreatureID = LastSeenTbl.itemsToSource[itemID];
								local itemName = select(1, GetItemInfo(itemID));
								local itemRarity = select(3, GetItemInfo(itemID));
								local itemType = select(6, GetItemInfo(itemID));
								local itemSourceCreatureID = LastSeenTbl.itemsToSource[itemID];
								if LastSeenTbl.lootControl then -- Track items when the loot window is open.
									if itemRarity >= LastSeenSettingsCacheDB.rarity then
										local shouldItemBeIgnored = LastSeenTbl.ShouldItemBeIgnored(itemType, itemID);
										if shouldItemBeIgnored then
											return;
										else
											if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
												if itemSourceCreatureID ~= nil then
													LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
												end
											else -- An item seen for the first time.
												if itemSourceCreatureID ~= nil then
													if LastSeenCreaturesDB[itemSourceCreatureID] and not LastSeenTbl.isMailboxOpen then
														if not LastSeenTbl.isAutoLootPlusLoaded then
															LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
														end
													else
														print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"]);
													end
												end
											end
										end
									elseif LastSeenTbl.TableHasField(LastSeenItemsDB, itemID, "manualEntry") then
										if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
											if itemSourceCreatureID ~= nil then
												LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
											end
										else -- An item seen for the first time.
											if itemSourceCreatureID ~= nil then
												if LastSeenCreaturesDB[itemSourceCreatureID] and not LastSeenTbl.isMailboxOpen then
													if not LastSeenTbl.isAutoLootPlusLoaded then
														LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
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
		LastSeenTbl.LogQuestLocation(questID, LastSeenTbl.currentMap);
	end
	if event == "QUEST_LOOT_RECEIVED" then
		LastSeenTbl.isQuestReward = true;
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
							LastSeenTbl.isAuctionItem = true;
						end
					else
						LastSeenTbl.doNotUpdate = true;
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
			local itemType = select(6, GetItemInfo(itemLink));
			if itemType == L["IS_MISCELLANEOUS"] or itemType == L["IS_CONSUMABLE"] then
				LastSeenTbl.lootedItem = (GetItemInfo(itemLink));
			end
		end
	end
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		LastSeenTbl.AddCreatureByNameplate(unit, today);
	end
	if event == "UPDATE_MOUSEOVER_UNIT" then
		LastSeenTbl.AddCreatureByMouseover("mouseover", today);
	end
	if event == "PLAYER_LOGOUT" then
		--LastSeenTbl.itemsToSource = {}; -- When the player no longer needs the loot table, empty it.
		LastSeenTbl.removedItems = {}; -- This is a temporary table that should be emptied on every logout or reload.
	end
end);

GameTooltip:HookScript("OnTooltipSetItem", LastSeenTbl.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", LastSeenTbl.OnTooltipSetItem);
