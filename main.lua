local addon, tbl = ...
local badDataItemCount = 0
local creatureID
local currentDate
local currentMap
local delay = 0.3
local epoch = 0
local executeCodeBlock = true
local frame = CreateFrame("Frame")
local isItemOrItemTypeIgnored
local isLooting
local isMerchantFrameOpen
local isOnIsland
local isPlayerInCombat
local itemID
local itemLink
local itemName
local itemRarity
local itemSource
local itemType
local itemSubType
local itemEquipLoc
local itemIcon
local plsEmptyVariables
local scannedItemInfo

for _, event in ipairs(tbl.events) do
	frame:RegisterEvent(event)
end
-- Synopsis: Registers all events that the addon cares about using the events table in the corresponding table file.

local function IsPlayerInCombat()
	-- Maps can't be updated while the player is in combat.
	if UnitAffectingCombat(tbl.L["PLAYER"]) then
		isPlayerInCombat = true
	else
		isPlayerInCombat = false
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
				tbl.encounterID = nil
				tbl.itemSourceCreatureID = nil
				tbl.possibleQuestProvider = nil
				tbl.questID = nil
				tbl.target = ""
				executeCodeBlock = true
				plsEmptyVariables = false
			end);
		end);
	end
end
-- Synopsis: When executed, after 4 seconds, clear or reset the variables.

frame:SetScript("OnEvent", function(self, event, ...)
	
	if event == "ADDON_LOADED" then
		local name = ...;
		if name == addon then
			tbl.SetDefaults()
			tbl.SetLocale(tbl.Settings["locale"])
			tbl.GetCurrentMapInfo("name")
			
			for k, v in pairs(tbl.Items) do -- If there are any items with bad data found or are in the ignored database, then simply remove them.
				for i, _ in pairs(tbl.IgnoredItems) do
					if i == k then
						table.insert(tbl.removedItems, v.itemLink);
						tbl.Items[k] = nil
						badDataItemCount = badDataItemCount + 1
					end
				end
				if not tbl.DataIsValid(k) then
					table.insert(tbl.removedItems, v.itemLink);
					tbl.Items[k] = nil
					badDataItemCount = badDataItemCount + 1
				end
				
				if badDataItemCount == 1 and tbl.Settings["mode"] ~= tbl.L["SILENT"] then
					print(tbl.L["ADDON_NAME"] .. badDataItemCount .. tbl.L["BAD_DATA_SINGLE"])
				elseif badDataItemCount > 1 and tbl.Settings["mode"] ~= tbl.L["SILENT"] then
					print(tbl.L["ADDON_NAME"] .. badDataItemCount .. tbl.L["BAD_DATA_MULTIPLE"])
				end
				badDataItemCount = 0
				
				tbl.AddNewFieldToTable(tbl.Items[k], "lootedBy", {})
			end
		end
	end
	
	if event == "ENCOUNTER_START" then
		local _, encounterName = ...;
		tbl.encounterID = tbl.GetTableKeyFromValue(tbl.Encounters, encounterName);
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
		
		if tbl.Contains(tbl.IgnoredItems, itemID, nil, nil) then return end
		
		if isOnIsland then
			if wasItemLoaded then
				if itemID then
					itemID = itemID -- Set the local instance of itemID equal to the file-wide itemID variable.
					local _, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(itemID);
					local itemName, itemLink, itemRarity = GetItemInfo(itemID);
					if tbl.Items[itemID] then
						tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, tbl.L["DATE"], tbl.currentMap, "Island Expeditions", tbl.L["ISLAND_EXPEDITIONS"], tbl.playerClass, tbl.playerLevel, "Update");
					else
						tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, tbl.L["DATE"], tbl.currentMap, "Island Expeditions", tbl.L["ISLAND_EXPEDITIONS"], tbl.playerClass, tbl.playerLevel, "New");
					end
				end
			end
		end
	end
	-- Synopsis: Used to capture loot obtained from Island Expeditions.
	
	if event == "LOOT_CLOSED" then
		isLooting = false
		EmptyVariables()
	end
	-- Synopsis: When the loot window is closed, call the EmptyVariables function.
	
	if (event == "LOOT_OPENED" or event == "LOOT_READY") and not isLooting then
		isLooting = true
		plsEmptyVariables = true
		local lootSlots = GetNumLootItems(); tbl.lootSlots = lootSlots
		if lootSlots < 1 then return end
		
		if tbl.Settings["lootFast"] then
			if (GetTime() - epoch) >= delay then
				for slot = lootSlots, 1, -1 do
					tbl.GetItemInfo(GetLootSlotLink(slot), slot)
					if C_CVar.GetCVar("autoLootDefault") == 1 then
						if not IsModifiedClick("AUTOLOOTTOGGLE") then
							LootSlot(slot)
						end
					end
				end
			end
			epoch = GetTime()
		else
			for slot = lootSlots, 1, -1 do
				tbl.GetItemInfo(GetLootSlotLink(slot), slot)
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
				if sender == tbl.L["AUCTION_HOUSE"] then
					if strfind(subject, tbl.L["AUCTION_WON_SUBJECT"]) then
						for j = 1, ATTACHMENTS_MAX_RECEIVE do 
							itemLink = GetInboxItemLink(i, j);
							if itemLink then
								itemID, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(itemLink);
								itemName = (GetItemInfo(itemLink));
								itemRarity = select(3, GetItemInfo(itemLink));
								if not itemRarity then -- It's possible for the itemLink to be malformed, causing the rarity to return nil.
									print(tbl.L["ADDON_NAME"] .. tbl.L["MALFORMED_ITEM_LINK"]); return
								end
								if itemRarity >= tbl.Settings["rarity"] then
									if tbl.Items[itemID] then
										tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, tbl.L["DATE"], tbl.currentMap, "Auction", tbl.L["AUCTION_HOUSE"], tbl.playerClass, tbl.playerLevel, "Update");
									else
										tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, tbl.L["DATE"], tbl.currentMap, "Auction", tbl.L["AUCTION_HOUSE"], tbl.playerClass, tbl.playerLevel, "New");
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
	
	if event == "MERCHANT_CLOSED" then isMerchantFrameOpen = false end
	
	if event == "MERCHANT_SHOW" then isMerchantFrameOpen = true end
	-- Synopsis: The merchant events prevent items bought from vendors from adding to the items table.
	
	if event == "NAME_PLATE_UNIT_ADDED" then
		local unit = ...
		tbl.AddCreatureByNameplate(unit, tbl.L["DATE"])
	end
	-- Synopsis: When a nameplate appears on the screen, pass the GUID down the pipeline so it can be scanned for the creature's name.
	
	if event == "PLAYER_LEVEL_CHANGED" then
		local _, newLevel = ...
		if newLevel then
			tbl.playerLevel = newLevel
		end
	end
	
	if event == "PLAYER_LOGIN" and tbl.isLastSeenLoaded then
		EmptyVariables();
		
		if tbl.isLastSeenLoaded then print(tbl.L["ADDON_NAME"] .. tbl.L["ADDON_LOADED_SUCCESSFULLY"]) end
		-- Synopsis: Stuff that needs to be checked or loaded into memory at logon or reload.
		
		local playerClass = UnitClass("player"); tbl.playerClass = playerClass
		local playerLevel = UnitLevel("player"); tbl.playerLevel = playerLevel
	end
	
	if event == "PLAYER_LOGOUT" then
		tbl.itemsToSource = {}; -- Items looted from creatures are stored here and compared against the creature table to find where they dropped from, they are stored here until the below scenario occurs.
		tbl.removedItems = {}; -- When items with 'bad' data are removed, they are stored here until the below scenario occurs.
		LastSeenCreaturesDB = tbl.Creatures
		LastSeenEncountersDB = tbl.Encounters
		LastSeenHistoryDB = tbl.History
		LastSeenIgnoredItemsDB = tbl.IgnoredItems
		LastSeenItemsDB = tbl.Items
		LastSeenLootTemplate = tbl.LootTemplate
		LastSeenMapsDB = tbl.Maps
		LastSeenQuestsDB = tbl.Quests
		LastSeenSettingsCacheDB = tbl.Settings
	end
	-- Synopsis: Clear out data that's no longer needed when the player logs off or reloads their user interface.
	
	if event == "QUEST_ACCEPTED" then
		local questID = ...;
		tbl.GetQuestInfo(questID, tbl.currentDate);
	end
	-- Synopsis: Captures the quest ID so a lookup can be done for its name.
	
	if event == "QUEST_LOOT_RECEIVED" then
		tbl.questID, itemLink = ...
		itemID = (GetItemInfoInstant(itemLink))
		itemName = (GetItemInfo(itemLink))
		itemRarity = select(3, GetItemInfo(itemLink))
		itemType = select(6, GetItemInfo(itemLink))
		itemSubType = select(7, GetItemInfo(itemLink))
		itemEquipLoc = select(9, GetItemInfo(itemLink))
		itemIcon = select(5, GetItemInfoInstant(itemLink))
		
		if not tbl.Quests[tbl.questID] then return end
		if tbl.Items[itemID] then
			tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, tbl.L["DATE"], tbl.currentMap, "Quest", tbl.Quests[tbl.questID]["questTitle"], tbl.playerClass, tbl.playerLevel, "Update")
		else
			tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, tbl.L["DATE"], tbl.currentMap, "Quest", tbl.Quests[tbl.questID]["questTitle"], tbl.playerClass, tbl.playerLevel, "New")
		end
	end
	-- Synopsis: Fires whenever a player completes a quest and receives a quest reward. This tracks the reward by the name of the quest.
	
	if event == "UI_INFO_MESSAGE" then
		local _, message = ...;
		if message == tbl.L["ERR_JOIN_SINGLE_SCENARIO_S"] then
			isOnIsland = true
		elseif message == tbl.L["NO_QUEUE"] then
			isOnIsland = false
		end
	end
	-- Synopsis: Lets the addon know when a player joins/leaves the queue for island expeditions.
	
	if event == "UNIT_SPELLCAST_SENT" then
		local unit, target, _, spellID = ...; local spellName = GetSpellInfo(spellID);
		if unit == string.lower(tbl.L["PLAYER"]) then
			if tbl.Contains(tbl.L["Z_SPELL_NAMES"], nil, "spellName", spellName) then
				if spellName == tbl.L["Z_SPELL_NAMES"][2]["spellName"] then -- Fishing
					tbl.target = tbl.L["Z_SPELL_NAMES"][2]["spellName"];
				else
					tbl.target = target;
				end
			end
		end
	end
	-- Synopsis: Used to capture the name of an object that the player loots.
	
	if event == "UPDATE_MOUSEOVER_UNIT" then
		tbl.AddCreatureByMouseover("mouseover", tbl.L["DATE"]);
	end
	-- Synopsis: When the player hovers over a target without a nameplate, or the player doesn't use nameplates, send the GUID down the pipeline so it can be scanned for the creature's name.
end);

GameTooltip:HookScript("OnTooltipSetItem", tbl.OnTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", tbl.OnTooltipSetItem);