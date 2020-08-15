--[[
	NOTE: Synopses pertain to the code directly above them!
	© 2020 Oxlotus/Lightsky/Smallbuttons
]]

-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local badDataItemCount = 0;
local container;
local currentDate;
local currentMap;
local delay = 0.3;
local epoch = 0;
local executeCodeBlock = true;
local frame = CreateFrame("Frame");
local isLooting;
local isMerchantFrameOpen;
local isOnIsland;
local isPlayerInCombat;
local itemID;
local itemLink;
local itemName;
local itemRarity;
local itemSource;
local itemType;
local itemSubType;
local itemEquipLoc;
local itemIcon;
local L = tbl.L;
local playerName;
local plsEmptyVariables;

for _, event in ipairs(tbl.events) do
	frame:RegisterEvent(event);
end
-- Synopsis: Registers all events that the addon cares about using the events table in the corresponding table file.

local function IsPlayerInCombat()
	-- Maps can't be updated while the player is in combat.
	if UnitAffectingCombat(L["IS_PLAYER"]) then
		isPlayerInCombat = true;
	else
		isPlayerInCombat = false;
	end
end
--[[
	Synopsis: Checks to see if the player is in combat.
	Use Cases:
		- Maps can't be updated while the player is in combat.
]]

local function EmptyVariables()
	if plsEmptyVariables then
		C_Timer.After(0, function()
			C_Timer.After(1, function()
				tbl.encounterID = nil;
				tbl.itemSourceCreatureID = nil;
				tbl.questID = nil;
				tbl.target = "";
				container = "";
				executeCodeBlock = true;
				plsEmptyVariables = false;
			end);
		end);
	end
end
-- Synopsis: When executed, after 4 seconds, clear or reset the variables.

frame:SetScript("OnEvent", function(self, event, ...)

	if event == "CHAT_MSG_LOOT" then
		if LastSeenQuestsDB[tbl.questID] then return end;
		
		local text, name = ...; name = string.match(name, "(.*)-");
		if name == playerName then
			text = string.match(text, L["LOOT_ITEM_PUSHED_SELF"] .. "(.*).");
			if text then
				if container ~= "" then
					local itemID, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(text);
					itemName = (GetItemInfo(text));
					itemRarity = select(3, GetItemInfo(text));	

					if itemRarity < tbl.rarity then return end;
					if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then
						-- Continue
					elseif tbl.Contains(tbl.ignoredItemCategories, nil, "itemType", itemType) then return;
					elseif tbl.Contains(tbl.ignoredItemCategories, nil, "itemType", itemSubType) then return;
					elseif tbl.Contains(tbl.ignoredItemCategories, nil, "itemType", itemEquipLoc) then return;
					elseif tbl.Contains(tbl.ignoredItems, itemID, nil, nil) then return end;
					
					if LastSeenItemsDB[itemID] then
						tbl.AddItem(itemID, text, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Container", container, "Update");
					else
						tbl.AddItem(itemID, text, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Container", container, "New");
					end
				end
			end
		end
	end
	-- Synopsis: When the player is rewarded an item, usually when the player didn't loot anything by action, track it using the source of said item. Typically, we would see this occur in many cases,
	-- but we really only care about acquisition via creatures like unlootable world bosses.
	
	if event == "ENCOUNTER_START" then
		local _, encounterName = ...;
		tbl.encounterID = tbl.GetTableKeyFromValue(LastSeenEncountersDB, encounterName);
	end
	-- Synopsis: Used to capture the encounter ID for the current instance encounter.
	
	if event == "INSTANCE_GROUP_SIZE_CHANGED" or "ZONE_CHANGED_NEW_AREA" then
		if IsPlayerInCombat() then -- Maps can't be updated in combat.
			while isPlayerInCombat do
				C_Timer.After(0, function() C_Timer.After(3, function() IsPlayerInCombat() end); end);
			end
		end
		
		C_Timer.After(0, function() C_Timer.After(3, function() tbl.GetCurrentMapInfo("name") end); end); -- Wait 3 seconds before asking the game for the new map.
	end
	-- Synopsis: Get the player's map when they change zones or enter instances.
	
	if event == "ISLAND_COMPLETED" then
		C_Timer.After(0, function() C_Timer.After(5, function() isOnIsland = false end); end);
	end
	-- Synopsis: Lets the addon know that the player has left the island expedition.
	
	if event == "ITEM_DATA_LOAD_RESULT" then
		local itemID, wasItemLoaded = ...;
		
		if tbl.Contains(tbl.ignoredItems, itemID, nil, nil) then return end;
		
		if isOnIsland then
			if wasItemLoaded then
				if itemID then
					itemID = itemID; -- Set the local instance of itemID equal to the file-wide itemID variable.
					local _, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(itemID);
					local itemName, itemLink, itemRarity = GetItemInfo(itemID);
					if LastSeenItemsDB[itemID] then
						tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Island Expeditions", L["ISLAND_EXPEDITIONS"], "Update");
					else
						tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Island Expeditions", L["ISLAND_EXPEDITIONS"], "New");
					end
				end
			end
		end
	end
	-- Synopsis: Used to capture loot obtained from Island Expeditions.
	
	if event == "ITEM_LOCK_CHANGED" then
		local bagID, slotID = ...;
		if tonumber(bagID) and tonumber(slotID) then
			local _, _, _, _, _, isLootable, _, _, _, id = GetContainerItemInfo(bagID, slotID)
			if isLootable then container = GetItemInfo(id) end;
		end
	end
	
	if event == "LOOT_CLOSED" then
		isLooting = false;
		EmptyVariables();
	end
	-- Synopsis: When the loot window is closed, call the EmptyVariables function.
	
	if (event == "LOOT_OPENED" or event == "LOOT_READY") and not isLooting then
		isLooting = true;
		plsEmptyVariables = true;
		local lootSlots = GetNumLootItems(); tbl.lootSlots = lootSlots;
		if lootSlots < 1 then return end;
		
		if tbl.lootFast then
			if (GetTime() - epoch) >= delay then
				for slot = lootSlots, 1, -1 do
					tbl.GetItemInfo(GetLootSlotLink(slot), slot);
					if tbl.doNotLoot == false then
						LootSlot(slot);
					end
				end
			end
			epoch = GetTime();
		else
			for slot = lootSlots, 1, -1 do
				tbl.GetItemInfo(GetLootSlotLink(slot), slot);
			end
		end
	end
	--[[
		Synopsis: Fires when the loot window is opened in MOST situations.
		Use Case(s):
			- Creatures
			- Objects
	]]
	
	if event == "MAIL_INBOX_UPDATE" then
		local mailItems = GetInboxNumItems();
		if mailItems > 0 then
			for i = 1, mailItems do
				local _, _, sender, subject = GetInboxHeaderInfo(i);
				if sender == L["AUCTION_HOUSE"] then
					if strfind(subject, L["AUCTION_WON_SUBJECT"]) then
						for j = 1, ATTACHMENTS_MAX_RECEIVE do 
							itemLink = GetInboxItemLink(i, j);
							if itemLink then
								itemID, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(itemLink);
								itemName = (GetItemInfo(itemLink));
								itemRarity = select(3, GetItemInfo(itemLink));
								if not itemRarity then -- It's possible for the itemLink to be malformed, causing the rarity to return nil.
									print(L["ADDON_NAME"] .. L["ERROR_MSG_CANT_ADD"]); return;
								end
								if itemRarity >= tbl.rarity then
									if tbl.Contains(tbl.ignoredItems, itemID, nil, nil) then return end;
									if LastSeenItemsDB[itemID] then
										tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Auction", L["AUCTION_HOUSE"], "Update");
									else
										tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Auction", L["AUCTION_HOUSE"], "New");
									end
								end
							end
						end
					end
				end
			end
		end
	end
	-- Synopsis: Used to capture items bought from the Auction House.
	-- ATTACHMENTS_MAX_RECEIVE: 16
	
	if event == "MERCHANT_CLOSED" then isMerchantFrameOpen = false end;
	
	if event == "MERCHANT_SHOW" then isMerchantFrameOpen = true end;
	-- Synopsis: The merchant events prevent items bought from vendors from adding to the items table.
	
	if event == "MODIFIER_STATE_CHANGED" then
		local key, down = ...;
		if down == 1 then
			if key == "LSHIFT" or key == "RSHIFT" then
				tbl.doNotLoot = true;
			end
		else
			tbl.doNotLoot = false;
		end
	end
	-- Synopsis: Allows players to prevent the game from looting items like lockboxes.
	
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		tbl.AddCreatureByNameplate(unit, L["DATE"]);
	end
	-- Synopsis: When a nameplate appears on the screen, pass the GUID down the pipeline so it can be scanned for the creature's name.
	
	if event == "PLAYER_LOGIN" and tbl.isLastSeenLoaded then
		tbl.InitializeSavedVars(); -- Initialize the tables if they're nil. This is usually only for players that first install the addon.
		EmptyVariables();
		
		tbl.LoadSettings(true);
		tbl.SetLocale(LastSeenSettingsCacheDB["locale"]); LastSeenSettingsCacheDB["locale"] = tbl["locale"];
		tbl.GetCurrentMapInfo("name");
		playerName = UnitName("player");
		if tbl.isLastSeenLoaded then print(L["ADDON_NAME"] .. L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"]) end;
		-- Synopsis: Stuff that needs to be checked or loaded into memory at logon or reload.

		for k, v in pairs(LastSeenItemsDB) do -- If there are any items with bad data found or are in the ignored database, then simply remove them.
			if not tbl.DataIsValid(k) then
				table.insert(tbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			-- Synopsis: Check to see if any fields for the item return nil, if so, then remove the item from the items table.
			if tbl.ignoredItems[k] then
				table.insert(tbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			-- Synopsis: If the item is found on the addon-controlled ignores table, then remove it from the items table. Sometimes stuff slipped through the cracks.
		end

		if badDataItemCount > 0 and tbl.mode ~= GM_SURVEY_NOT_APPLICABLE then
			print(L["ADDON_NAME"] .. badDataItemCount .. L["ERROR_MSG_BAD_DATA"]);
			badDataItemCount = 0;
		end
	end
	
	if event == "PLAYER_LOGOUT" then
		tbl.itemsToSource = {}; -- Items looted from creatures are stored here and compared against the creature table to find where they dropped from, they are stored here until the below scenario occurs.
		tbl.removedItems = {}; -- When items with 'bad' data are removed, they are stored here until the below scenario occurs.
	end
	-- Synopsis: Clear out data that's no longer needed when the player logs off or reloads their user interface.
	
	if event == "QUEST_ACCEPTED" then
		local questID = ...;
		local provider = UnitName("target"); local providerFaction = UnitFactionGroup("target");
		local playerLevel = UnitLevel("player");
		local x, y = UnitPosition("player");
		if x == nil and y == nil and IsInInstance() then
			x = 0; y = 0;
		else
			x = tbl.Round(x); y = tbl.Round(y);
		end
		
		-- Nil checks
		if providerFaction == nil then
			local guid = UnitGUID("target");
			local _, _, _, _, _, creatureID, _ = strsplit("-", guid); creatureID = tonumber(creatureID);
			if tbl.Contains(tbl.unitFactionGroups, creatureID, nil, nil) then
				providerFaction = tbl.unitFactionGroups[creatureID];
			else
				providerFaction = L["UNKNOWN"];
			end
		end
		if playerLevel == nil then playerLevel = UnitLevel("player") end;
		
		tbl.GetQuestInfo(questID, provider, providerFaction, playerLevel, x, y);
	end
	-- Synopsis: Captures the quest ID so a lookup can be done for its name.
	
	if event == "QUEST_LOOT_RECEIVED" then
		tbl.questID, itemLink = ...; tbl.AddQuest(tbl.questID, tbl.currentDate);
		itemID = (GetItemInfoInstant(itemLink));
		itemName = (GetItemInfo(itemLink));
		itemRarity = select(3, GetItemInfo(itemLink));
		itemType = select(6, GetItemInfo(itemLink));
		itemSubType = select(7, GetItemInfo(itemLink));
		itemEquipLoc = select(9, GetItemInfo(itemLink));
		itemIcon = select(5, GetItemInfoInstant(itemLink));
		
		if not LastSeenQuestsDB[tbl.questID] then return end;
		
		if itemRarity >= tbl.rarity then
			for k, v in pairs(tbl.ignoredItemCategories) do
				if itemType == v and not tbl.doNotIgnore then
					return;
				end
			end
			for k, v in pairs(tbl.ignoredItems) do
				if itemID == k and not tbl.doNotIgnore then
					return;
				end
			end
		
			if LastSeenItemsDB[itemID] then
				tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Quest", LastSeenQuestsDB[tbl.questID]["questTitle"], "Update");
			else
				tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Quest", LastSeenQuestsDB[tbl.questID]["questTitle"], "New");
			end
		end
	end
	-- Synopsis: Fires whenever a player completes a quest and receives a quest reward. This tracks the reward by the name of the quest.
	
	if event == "UI_INFO_MESSAGE" then
		local _, message = ...;
		if message == L["ERR_JOIN_SINGLE_SCENARIO_S"] then
			isOnIsland = true;
		elseif message == L["NO_QUEUE"] then
			isOnIsland = false;
		end
	end
	-- Synopsis: Lets the addon know when a player joins/leaves the queue for island expeditions.
	
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...; local spellName = GetSpellInfo(spellID);
		if unit == string.lower(L["IS_PLAYER"]) then
			if tbl.Contains(L["SPELL_NAMES"], nil, "spellName", spellName) then
				if spellName == L["SPELL_NAMES"][2]["spellName"] then -- Fishing
					tbl.target = L["SPELL_NAMES"][2]["spellName"];
				else
					tbl.target = target;
				end
			end
		end
	end
	-- Synopsis: Used to capture the name of an object that the player loots.
	
	if event == "UPDATE_MOUSEOVER_UNIT" then
		tbl.AddCreatureByMouseover("mouseover", L["DATE"]);
	end
	-- Synopsis: When the player hovers over a target without a nameplate, or the player doesn't use nameplates, send the GUID down the pipeline so it can be scanned for the creature's name.
end);

GameTooltip:HookScript("OnTooltipSetItem", tbl.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", tbl.OnTooltipSetItem);