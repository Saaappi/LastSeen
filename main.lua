--[[
	NOTE: Synopses pertain to the code directly above them!
	© 2020 Oxlotus/Lightsky/Smallbuttons
]]

-- Namespace Variables
local addon, addonTbl = ...;
local L = addonTbl.L;

-- Module-Local Variables
local badDataItemCount = 0;
local currentDate;
local currentMap;
local delay = 0.3;
local epoch = 0;
local executeCodeBlock = true;
local frame = CreateFrame("Frame");
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
local playerName;

for _, event in ipairs(addonTbl.events) do
	frame:RegisterEvent(event);
end
-- Synopsis: Registers all events that the addon cares about using the events table in the corresponding table file.

local function InitializeTable(tbl)
	tbl = {};
	return tbl;
end
-- Synopsis: Used to create EMPTY tables, instead of leaving them nil.

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
	-- Empties the existing value of a variable after a timer's duration.
	C_Timer.After(0, function()
		C_Timer.After(3, function()
			addonTbl.encounterID = nil;
			addonTbl.itemSourceCreatureID = nil;
			addonTbl.target = "";
			executeCodeBlock = true;
		end);
	end);
end
-- Synopsis: When executed, after 4 seconds, clear or reset all involved variables.

frame:SetScript("OnEvent", function(self, event, ...)
	
	if event == "PLAYER_LOGIN" and addonTbl.isLastSeenLoaded then
		if LastSeenMapsDB == nil then LastSeenMapsDB = InitializeTable(LastSeenMapsDB) end;
		if LastSeenCreaturesDB == nil then LastSeenCreaturesDB = InitializeTable(LastSeenCreaturesDB) end;
		if LastSeenEncountersDB == nil then LastSeenEncountersDB = InitializeTable(LastSeenEncountersDB) end;
		if LastSeenItemsDB == nil then LastSeenItemsDB = InitializeTable(LastSeenItemsDB) end;
		if LastSeenQuestsDB == nil then LastSeenQuestsDB = InitializeTable(LastSeenQuestsDB) end;
		if LastSeenSettingsCacheDB == nil then LastSeenSettingsCacheDB = InitializeTable(LastSeenSettingsCacheDB) end;
		if LastSeenLootTemplate == nil then LastSeenLootTemplate = InitializeTable(LastSeenLootTemplate) end;
		if LastSeenHistoryDB == nil then LastSeenHistoryDB = InitializeTable(LastSeenHistoryDB) end;
		-- Synopsis: Initialize the tables if they're nil. This is usually only for players that first install the addon.
		
		LastSeenIgnoredItemsDB = {};
		-- Synopsis: Empty tables that will no longer be used. These tables will eventually be removed from the addon altogether.
		
		addonTbl.LoadSettings(true);
		addonTbl.GetCurrentMap();
		playerName = UnitName("player");
		print(L["ADDON_NAME"] .. L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"]);
		-- Synopsis: Stuff that needs to be checked or loaded into memory at logon or reload.

		for k, v in pairs(LastSeenItemsDB) do -- If there are any items with bad data found or are in the ignored database, then simply remove them.
			if not addonTbl.DataIsValid(k) then
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			-- Synopsis: Check to see if any fields for the item return nil, if so, then remove the item from the items table.
			if addonTbl.ignoredItems[k] then
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			-- Synopsis: If the item is found on the addon-controlled ignores table, then remove it from the items table. Sometimes stuff slipped through the cracks.
			if type(v.itemRarity) == "string" then
				local temporaryRarity = v.itemRarity;
				v.itemRarity = v.itemType;
				v.itemType = temporaryRarity;
			end
			-- Synopsis: For a short period of time, itemRarity and itemType were flipped in a function call. This works to correct them and flip them back.
			if v.itemRarity < 2 then
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			-- Synopsis: If someone used LastSeen2 for a short period of time, then they will have Common (white) quality quest rewards that need to be removed.
		end

		if badDataItemCount > 0 and addonTbl.mode ~= L["QUIET_MODE"] then
			print(L["ADDON_NAME"] .. badDataItemCount .. L["ERROR_MSG_BAD_DATA"]);
			badDataItemCount = 0;
		end
	end
	if event == "ZONE_CHANGED_NEW_AREA" or "INSTANCE_GROUP_SIZE_CHANGED" then
		local realZoneText = GetRealZoneText();
		
		if IsPlayerInCombat() then
			while isPlayerInCombat do
				C_Timer.After(0, function() C_Timer.After(3, function() IsPlayerInCombat() end); end);
			end
		end
		
		if realZoneText then
			if addonTbl.currentMap ~= realZoneText then
				addonTbl.GetCurrentMap();
			end
		else
			C_Timer.After(0, function() C_Timer.After(3, function() addonTbl.GetCurrentMap() end); end);
		end
		
		if not (realZoneText == addonTbl.currentMap) then
			addonTbl.currentMap = realZoneText;
		end
	end
	-- Synopsis: Get the player's map when they change zones or enter instances.
	
	if event == "MODIFIER_STATE_CHANGED" then
		local key, down = ...;
		if down == 1 then
			if key == "LSHIFT" or key == "RSHIFT" then
				addonTbl.doNotLoot = true;
			end
		else
			addonTbl.doNotLoot = false;
		end
	end
	-- Synopsis: Allows players to prevent the game from looting items like lockboxes.
	
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...; local spellName = GetSpellInfo(spellID);
		if unit == string.lower(L["IS_PLAYER"]) then
			if addonTbl.Contains(L["SPELL_NAMES"], nil, "spellName", spellName) then
				addonTbl.target = target;
			end
		end
	end
	-- Synopsis: Used to capture the name of an object that the player loots.
	
	if event == "ENCOUNTER_START" then
		local _, encounterName = ...;
		addonTbl.encounterID = addonTbl.ReverseLookup(LastSeenEncountersDB, encounterName);
	end
	-- Synopsis: Used to capture the encounter ID for the current instance encounter.
	
	if event == "LOOT_OPENED" then
		local lootSlots = GetNumLootItems(); addonTbl.lootSlots = lootSlots;
		if lootSlots < 1 then return end;
		
		if addonTbl.lootFast then
			if (GetTime() - epoch) >= delay then
				for slot = lootSlots, 1, -1 do
					addonTbl.GetItemInfo(GetLootSlotLink(slot), slot);
					if addonTbl.doNotLoot == false then
						LootSlot(slot);
					end
				end
			end
			epoch = GetTime();
		else
			for slot = lootSlots, 1, -1 do
				addonTbl.GetItemInfo(GetLootSlotLink(slot), slot);
			end
		end
	end
	--[[
		Synopsis: Fires when the loot window is opened in MOST situations.
		Use Case(s):
			- Creatures
			- Objects
	]]
	
	if event == "LOOT_CLOSED" then
		EmptyVariables();
	end
	-- Synopsis: When the loot window is closed, call the EmptyVariables function.
	
	if event == "CHAT_MSG_LOOT" then
		if addonTbl.encounterID then return end;
		if addonTbl.target then return end;
		
		local text, name = ...;
		if name == playerName then
			text = addonTbl.ExtractItemLink(L["LOOT_ITEM_SELF"] .. text);
			if text then
				itemID = (GetItemInfoInstant(itemLink));
				itemName = (GetItemInfo(itemLink));
				itemRarity = select(3, GetItemInfo(itemLink));
				itemType = select(6, GetItemInfo(itemLink));
				itemIcon = select(5, GetItemInfoInstant(itemLink));
				
				--[[if LastSeenItemsDB[itemID] then
					addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Object", object, "Update");
				else
					addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Object", object, "New");
				end]]
				print("CHAT_MSG_LOOT");
			end
		end
	end
	-- Synopsis: When the player is rewarded an item, usually when the player didn't loot anything by action, track it using the source of said item. Typically, we would see this occur in many cases,
	-- but we really only care about acquisition via creatures like unlootable world bosses.
	
	if event == "QUEST_ACCEPTED" then
		local questIndex = ...; addonTbl.GetQuestInfo(questIndex);
	end
	-- Synopsis: Captures the quest ID so a lookup can be done for its name.
	
	if event == "QUEST_LOOT_RECEIVED" then
		addonTbl.questID, itemLink = ...; addonTbl.AddQuest(addonTbl.questID, addonTbl.currentDate);
		itemID = (GetItemInfoInstant(itemLink));
		itemName = (GetItemInfo(itemLink));
		itemRarity = select(3, GetItemInfo(itemLink));
		itemType = select(6, GetItemInfo(itemLink));
		itemSubType = select(7, GetItemInfo(itemLink));
		itemEquipLoc = select(9, GetItemInfo(itemLink));
		itemIcon = select(5, GetItemInfoInstant(itemLink));
		
		if not LastSeenQuestsDB[addonTbl.questID] then return end;
		
		if itemRarity >= addonTbl.rarity then
			for k, v in pairs(addonTbl.ignoredItemTypes) do
				if itemType == v and not addonTbl.doNotIgnore then
					return;
				end
			end
			for k, v in pairs(addonTbl.ignoredItems) do
				if itemID == k and not addonTbl.doNotIgnore then
					return;
				end
			end
		
			if LastSeenItemsDB[itemID] then
				addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Quest", LastSeenQuestsDB[addonTbl.questID]["questTitle"], "Update");
			else
				addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Quest", LastSeenQuestsDB[addonTbl.questID]["questTitle"], "New");
			end
		end
	end
	-- Synopsis: Fires whenever a player completes a quest and receives a quest reward. This tracks the reward by the name of the quest.
	
	if event == "MAIL_INBOX_UPDATE" then
		local mailItems = GetInboxNumItems();
		if mailItems > 0 then
			for i = 1, mailItems do
				local _, _, sender, subject = GetInboxHeaderInfo(i);
				if sender == "Auction House" then
					if strfind(subject, "Auction won") then
						for j = 1, ATTACHMENTS_MAX_RECEIVE do -- A player can have, at most, 16 attachments in a single mail.
							itemLink = GetInboxItemLink(i, j);
							if itemLink then
								itemID = (GetItemInfoInstant(itemLink));
								itemName = (GetItemInfo(itemLink));
								itemRarity = select(3, GetItemInfo(itemLink));
								itemType = select(6, GetItemInfo(itemLink));
								itemSubType = select(7, GetItemInfo(itemLink));
								itemEquipLoc = select(9, GetItemInfo(itemLink));
								itemIcon = select(5, GetItemInfoInstant(itemLink));
								if itemRarity >= addonTbl.rarity then
									for k, v in pairs(addonTbl.ignoredItemTypes) do
										if itemType == v and not addonTbl.doNotIgnore then
											return;
										end
									end
									for k, v in pairs(addonTbl.ignoredItems) do
										if itemID == k and not addonTbl.doNotIgnore then
											return;
										end
									end
									if LastSeenItemsDB[itemID] then
										addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Auction", "Auction House", "Update");
									else
										addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Auction", "Auction House", "New");
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

	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		addonTbl.AddCreatureByNameplate(unit, L["DATE"]);
	end
	-- Synopsis: When a nameplate appears on the screen, pass the GUID down the pipeline so it can be scanned for the creature's name.
	
	if event == "UPDATE_MOUSEOVER_UNIT" then
		addonTbl.AddCreatureByMouseover("mouseover", L["DATE"]);
	end
	-- Synopsis: When the player hovers over a target without a nameplate, or the player doesn't use nameplates, send the GUID down the pipeline so it can be scanned for the creature's name.
	
	if event == "PLAYER_LOGOUT" then
		addonTbl.itemsToSource = {}; -- Items looted from creatures are stored here and compared against the creature table to find where they dropped from, they are stored here until the below scenario occurs.
		addonTbl.removedItems = {}; -- When items with 'bad' data are removed, they are stored here until the below scenario occurs.
	end
	-- Synopsis: Clear out data that's no longer needed when the player logs off or reloads their user interface.
end);

GameTooltip:HookScript("OnTooltipSetItem", addonTbl.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", addonTbl.OnTooltipSetItem);
