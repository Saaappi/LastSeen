-- Namespace Variables
local addon, addonTbl = ...;
local L = addonTbl.L;

-- Module-Local Variables
local appearanceID;
local badDataItemCount = 0;
local containerItem;
local currentDate;
local currentMap;
local delay = 0.3;
local doNotLoot;
local encounterID;
local epoch = 0;
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
local itemSubType;
local itemType;
local itemIcon;
local playerName;
local questID;
local object;

for _, event in ipairs(addonTbl.events) do
	frame:RegisterEvent(event);
end

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

local function IterateLootWindow(lootSlots, itemSource)
	for i = 1, lootSlots do
		local itemLink = GetLootSlotLink(i);
		if itemLink then
			addonTbl.LootDetected(L["LOOT_ITEM_PUSHED_SELF"] .. itemLink, L["DATE"], addonTbl.currentMap, itemSource);
		end
	end
end

local function EmptyVariables()
	-- Empties the existing value of a variable after a timer's duration.
	C_Timer.After(0, function()
		C_Timer.After(5, function()
			addonTbl.creatureID = "";
			addonTbl.target = "";
			containerItem = "";
			encounterID = nil;
			executeCodeBlock = true;
			target = "";
		end);
	end);
end

frame:SetScript("OnEvent", function(self, event, ...)
	--[[ The purpose of this check is for people who macro the "bag sort" function call.
	Whenever a macro calls this function it makes the addon misbehave. ]]
	if event == "BAG_UPDATE" then
		EmptyVariables();
	end
	
	if event == "PLAYER_LOGIN" and isLastSeenLoaded then
		-- Nil SavedVar checks
		if LastSeenMapsDB == nil then LastSeenMapsDB = InitializeTable(LastSeenMapsDB) end;
		if LastSeenCreaturesDB == nil then LastSeenCreaturesDB = InitializeTable(LastSeenCreaturesDB) end;
		if LastSeenEncountersDB == nil then LastSeenEncountersDB = InitializeTable(LastSeenEncountersDB) end;
		if LastSeenItemsDB == nil then LastSeenItemsDB = InitializeTable(LastSeenItemsDB) end;
		if LastSeenIgnoredItemsDB == nil then LastSeenIgnoredItemsDB = InitializeTable(LastSeenIgnoredItemsDB) end;
		if LastSeenQuestsDB == nil then LastSeenQuestsDB = InitializeTable(LastSeenQuestsDB) end;
		if LastSeenSettingsCacheDB == nil then LastSeenSettingsCacheDB = InitializeTable(LastSeenSettingsCacheDB) end;
		if LastSeenLootTemplate == nil then LastSeenLootTemplate = InitializeTable(LastSeenLootTemplate) end;
		if LastSeenHistoryDB == nil then LastSeenHistoryDB = InitializeTable(LastSeenHistoryDB) end;
		
		-- Settings that must be loaded on login
		addonTbl.LoadSettings(true);
		print(L["ADDON_NAME"] .. L["LOAD_SUCCESSFUL"]);

		-- Other
		addonTbl.GetCurrentMap();
		playerName = UnitName("player");

		for k, v in pairs(LastSeenItemsDB) do -- If there are any items with bad data found or are in the ignored database, then simply remove them.
			if not addonTbl.DataIsValid(k) then
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			if addonTbl.ignoredItems[k] then
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
			if type(v.itemRarity) == "string" then -- A weird issue where the itemType and itemRarity were flipped, this corrects it.
				local temp = v.itemRarity;
				v.itemRarity = v.itemType;
				v.itemType = temp;
			end
			if v.itemRarity < 2 then -- To wipe out the common quest rewards.
				table.insert(addonTbl.removedItems, v.itemLink);
				LastSeenItemsDB[k] = nil;
				badDataItemCount = badDataItemCount + 1;
			end
		end

		if badDataItemCount > 0 and addonTbl.mode ~= L["QUIET_MODE"] then
			print(L["ADDON_NAME"] .. L["BAD_DATA_ITEM_COUNT_TEXT1"] .. badDataItemCount .. L["BAD_DATA_ITEM_COUNT_TEXT2"]);
			badDataItemCount = 0;
		end
	end
	if event == "ZONE_CHANGED_NEW_AREA" or "INSTANCE_GROUP_SIZE_CHANGED" then
		local realZoneText = GetRealZoneText(); -- Grabs the localized name of the zone the player is currently in.
		
		if IsPlayerInCombat() then -- Apparently maps can't update in combat without tossing an exception.
			while isPlayerInCombat do
				C_Timer.After(0, function() C_Timer.After(3, function() IsPlayerInCombat() end); end);
			end
		end
		
		if realZoneText then -- To make sure that it's not nil.
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
	
	-- Used to stop the addon from looting lockboxes and other containers.
	if event == "MODIFIER_STATE_CHANGED" then
		local key, down = ...;
		if down == 1 then
			if key == "LSHIFT" or "RSHIFT" then
				doNotLoot = true;
			end
		else
			doNotLoot = false;
		end
	end
	
	-- Used for loot obtained from chests or other objects.
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...; local spellName = GetSpellInfo(spellID);
		if unit == string.lower(L["IS_PLAYER"]) then
			if addonTbl.Contains(L["SPELL_NAMES"], "", spellName) then
				addonTbl.target = target;
			end
		end
	end
	
	-- Used for loot that drops from dungeon or raid encounters.
	if event == "ENCOUNTER_START" then
		local _, encounterName = ...;
		encounterID = addonTbl.ReverseLookup(LastSeenEncountersDB, encounterName); addonTbl.encounterID = encounterID;
	end

	-- Used for loot that drops from creatures, satchels, etc.
	if event == "LOOT_OPENED" then
		local lootSlots = GetNumLootItems(); addonTbl.lootSlots = lootSlots;
		if lootSlots < 1 then return end;
		
		if addonTbl.lootFast then
			if not doNotLoot then
				if (GetTime() - epoch) >= delay then
					for slot = lootSlots, 1, -1 do
						addonTbl.GetItemInfo(GetLootSlotLink(slot), slot);
						LootSlot(slot);
					end
				end
				epoch = GetTime();
			end
		else
			for slot = lootSlots, 1, -1 do
				addonTbl.GetItemInfo(GetLootSlotLink(slot), slot);
			end
		end
	end
	
	if event == "LOOT_CLOSED" then
		EmptyVariables();
	end
	
	if event == "QUEST_ACCEPTED" then
		local questIndex = ...; addonTbl.GetQuestInfo(questIndex);
	end
	if event == "QUEST_LOOT_RECEIVED" then
		questID, itemLink = ...; addonTbl.AddQuest(questID, addonTbl.currentDate);
		itemID = (GetItemInfoInstant(itemLink));
		itemName = (GetItemInfo(itemLink));
		itemRarity = select(3, GetItemInfo(itemLink));
		itemType = select(6, GetItemInfo(itemLink));
		itemIcon = select(5, GetItemInfoInstant(itemLink));
		
		if not LastSeenQuestsDB[questID] then return end;
		
		if addonTbl.ShouldItemBeIgnored(itemID, itemType) then return end;
		
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
			--[[if LastSeenIgnoredItemsDB[itemID] and addonTbl.doNotIgnore then
				return;
			end]]
		
			if LastSeenItemsDB[itemID] then
				addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Quest", LastSeenQuestsDB[questID]["questTitle"], "Update");
			else
				addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Quest", LastSeenQuestsDB[questID]["questTitle"], "New");
			end
		end
	end
	
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
										addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Auction", "Auction House", "Update");
									else
										addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Auction", "Auction House", "New");
									end
								end
							end
						end
					end
				end
			end
		end
	end

	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...;
		addonTbl.AddCreatureByNameplate(unit, L["DATE"]);
	end
	if event == "UPDATE_MOUSEOVER_UNIT" then
		addonTbl.AddCreatureByMouseover("mouseover", L["DATE"]);
	end
	if event == "PLAYER_LOGOUT" then
		addonTbl.itemsToSource = {}; -- When the player no longer needs the loot table, empty it.
		addonTbl.removedItems = {}; -- This is a temporary table that should be emptied on every logout or reload.
	end
end);

GameTooltip:HookScript("OnTooltipSetItem", addonTbl.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", addonTbl.OnTooltipSetItem);
