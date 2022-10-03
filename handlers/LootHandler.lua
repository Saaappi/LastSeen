local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local e = CreateFrame("Frame")

local known = "|TInterface\\Addons\\LastSeen\\Assets\\known:0|t"
local unknown = "|TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t"

local isLooting = false -- A boolean to determine if the player is currently looting.

function LastSeen:New(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, lootDate, map, source, playerClass, playerLevel, ...)
	-- This is a new item, which is an item that we haven't
	-- seen before on the current account.
	LastSeenItemDB[itemId] = { link = itemLink, name = itemName, rarity = itemRarity, type = itemType, icon = itemIcon, lootDate = lootDate, map = map, source = source, playerClass = playerClass, playerLevel = playerLevel }
	LastSeen:Print("add", itemIcon, select(1, ...), itemLink, source, lootDate, map)
end

function LastSeen:Update(itemId, itemLink, itemIcon, lootDate, map, source, playerClass, playerLevel, properties, ...)
	-- The item has been seen before and we need to update
	-- its source information.
	for _, property in pairs(properties) do
		LastSeenItemDB[itemId][property.name] = property.value
	end
	LastSeen:Print("update", itemIcon, select(1, ...), itemLink, source, lootDate, map)
end

function LastSeen:Item(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, lootDate, map, source, playerClass, playerLevel, action)
	-- This is a staging ground for items. We need to weed
	-- out the unwanted items (items that aren't new or in
	-- need of an update.)
	if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
	
	-- Determines whether or not the item should be processed.
	local continue = false
	
	-- Let's see if the item isn't new. If not, then
	-- let's check to see if any properties are different.
	local properties = {}
	if LastSeenItemDB[itemId] then
		if LastSeenItemDB[itemId].lootDate ~= lootDate then
			properties[1] = { name = "lootDate", value = lootDate }; continue = true
		end
		if LastSeenItemDB[itemId].map ~= map then
			properties[2] = { name = "map", value = map }; continue = true
		end
		if LastSeenItemDB[itemId].source ~= source then
			properties[3] = { name = "source", value = source }; continue = true
		end
		if LastSeenItemDB[itemId].playerClass ~= playerClass then
			properties[4] = { name = "playerClass", value = playerClass }; continue = true
		end
		if LastSeenItemDB[itemId].playerLevel ~= playerLevel then
			properties[5] = { name = "playerLevel", value = playerLevel }; continue = true
		end
	else
		-- The item doesn't exist.
		--
		-- Let's check if the item rarity is equal to or
		-- higher than the player-controlled setting.
		if itemRarity < LastSeenDB.RarityId then return end
		
		-- Let's check if the item's type is enabled in the
		-- settings.
		if LastSeenDB.Filters[itemType] then
			continue = true
		end
	end
	
	local collectedIcon = nil
	if itemType == "Armor" or itemType == "Weapon" then
		local _, sourceId = C_TransmogCollection.GetItemInfo(itemLink)
		if sourceId then
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceId)
			if sourceInfo.isCollected then
				collectedIcon = known
			else
				collectedIcon = unknown
			end
		end
	end
	
	if continue then
		if action == "Update" then
			LastSeen:Update(itemId, itemLink, itemIcon, lootDate, map, source, playerClass, playerLevel, properties, collectedIcon)
		else
			LastSeen:New(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, lootDate, map, source, playerClass, playerLevel, collectedIcon)
		end
	end
end

function LastSeen:ExtractItemLink(itemLinkString)
	-- Extracts the item link from the provided string.
	-- Example: You receive item: [Invincible's Reins]
	-- (The Invincible's Reins item link would be extracted
	-- and returned.)
	
	if string.find(itemLinkString, L_GLOBALSTRINGS["Constant.LOOT_ITEM_PUSHED_SELF"]) then
		local extractedLink = string.match(itemLinkString, L_GLOBALSTRINGS["Constant.LOOT_ITEM_PUSHED_SELF"] .. "(.*).");
		local itemId = GetItemInfoInstant(extractedLink);
	elseif string.find(itemLinkString, L_GLOBALSTRINGS["Constant.LOOT_ITEM_SELF"]) then
		local extractedLink = string.match(itemLinkString, L_GLOBALSTRINGS["Constant.LOOT_ITEM_SELF"] .. "(.*).");
		local itemId = GetItemInfoInstant(extractedLink);
	end
	
	if itemId then
		local itemLink = select(2, GetItemInfo(itemId))
	end
	
	if itemLink then return itemLink end
end

function LastSeen:GetItemInfo(itemLink, lootSlot)
	local itemsToSource = {}
	local lootSources = { GetLootSourceInfo(lootSlot) }

	if itemLink then
		if LastSeenDB.ScanOnLootEnabled then
			-- If Scan On Loot is enabled, then the variants in the item name
			-- isn't removed. For example, "of the Fireflash" wouldn't be
			-- removed from the name.
		else
			local itemLink = LastSeen:ExtractItemLink(L_GLOBALSTRINGS["Constant.LOOT_ITEM_SELF"] .. itemLink)
		end
		
		for i = 1, #lootSources, 2 do
			-- We skip every other entry in the table because
			-- every other entry in the table is a loot source
			-- GUID. Odd entries are GUIDs and even entries are
			-- the count for what dropped.
			
			if itemLink then
				-- Let's get some information about the item we looted.
				local itemName, _, itemRarity = GetItemInfo(itemLink)
				local itemId, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
				
				-- Let's get some information about the source we acquired
				-- the item from.
				local type, _, _, _, _, creatureId = string.split("-", lootSources[i])
				
				if itemId then
					itemsToSource[itemId] = tonumber(creatureId)
					local itemSourceCreatureId = itemsToSource[itemId]
					
					local action = ""
					if LastSeenItemDB[itemId] then
						-- This item has been seen before.
						action = "Update"
					else
						-- This is a new item.
						action = "New"
					end
					
					if LastSeenCreatureDB[itemSourceCreatureId] then
						-- The item was acquired from a creature logged by
						-- the addon.
						LastSeen:Item(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, date(LastSeenDB.DateFormat), addonTable.map, LastSeenCreatureDB[itemSourceCreatureId], (UnitClass("player")), (UnitLevel("player")), action)
					end
				end
			end
		end
	end
end

e:RegisterEvent("LOOT_CLOSED")
e:RegisterEvent("LOOT_OPENED")
e:RegisterEvent("LOOT_READY")
e:SetScript("OnEvent", function(self, event, ...)
	if (event == "LOOT_OPENED" or event == "LOOT_READY") and not isLooting then
		isLooting = true
		
		-- Get the number of loot slots. If that number is less than 1, then
		-- return (do nothing).
		local numLootSlots = GetNumLootItems(); if numLootSlots < 1 then return end
		
		-- Iterate through the loot window (but do it backward).
		for slot = numLootSlots, 1, -1 do
			LastSeen:GetItemInfo(GetLootSlotLink(slot), slot)
			if C_CVar.GetCVar("autoLootDefault") == 1 then
				if not IsModifiedClick("AUTOLOOTTOGGLE") then
					LootSlot(slot)
				end
			end
		end
	end
	if event == "LOOT_CLOSED" then
		isLooting = false
	end
end)

--[[
	Note 1: A source ID is a unique identifier for an individual appearance. It's possible for an item to have 2 or more source IDs, and not every
	ID may be seen. This could be due to it not being in the game as an option OR that it's no longer dropping... only time can tell.
]]

--[[
	Note 2: The 'known' and 'unknown' assets are from Can I Mog It? A special thanks to the author for the icons.
]]

--[[tbl.New = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, playerClass, playerLevel)

	if not source or not itemID then return end if tbl.Items[itemID] then return end

	tbl.Items[itemID] = { itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, itemSubType = itemSubType, itemEquipLoc = itemEquipLoc, itemIcon = itemIcon, lootDate = currentDate, source = source, 
	location = currentMap, sourceIDs = {}, lootedBy = {} };
	
	if tbl.Contains(tbl.History, nil, "itemLink", itemLink) ~= true then
		table.insert(tbl.History, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	tbl.LootTemplate[itemID] = {[source] = 1};
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	if sourceID then
		tbl.Items[itemID]["sourceIDs"][sourceID] = tbl.L["DATE"];
	end
	
	if sourceID and tbl.Settings["mode"] ~= tbl.L["SILENT"] then
		if itemType == "Armor" or itemType == "Weapon" then
			local isAppearanceKnown = C_TransmogCollection.GetSourceInfo(sourceID).isCollected
			if isAppearanceKnown then
				print(tbl.L["ADDON_NAME"] .. tbl.L["ADDED"] .. " |TInterface\\Addons\\LastSeen\\Assets\\known:0|t" .. " |T" .. itemIcon .. ":0|t " .. itemLink .. ", " .. source)
			elseif isAppearanceKnown ~= true and (tbl.classDefaults[tbl.playerClass]["Armor"] == itemSubType or tbl.classDefaults[tbl.playerClass]["Weapons"][itemSubType] == 1) then
				print(tbl.L["ADDON_NAME"] .. tbl.L["ADDED"] .. " |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t" .. " |T" .. itemIcon .. ":0|t " .. itemLink .. "*" .. " - " .. source)
			else
				print(tbl.L["ADDON_NAME"] .. tbl.L["ADDED"] .. " |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t" .. " |T" .. itemIcon .. ":0|t " .. itemLink .. ", " .. source)
			end
		end
	elseif tbl.Settings["mode"] ~= tbl.L["SILENT"] then
		print(tbl.L["ADDON_NAME"] .. tbl.L["ADDED"] .. " |T" .. itemIcon .. ":0|t " .. itemLink .. ", " .. source)
	end
	
	if playerClass and playerLevel then
		tbl.Items[itemID]["lootedBy"]["playerClass"] = playerClass
		tbl.Items[itemID]["lootedBy"]["playerLevel"] = playerLevel
	end
	
	tbl.RollHistory();
	
	if tbl.Settings["mode"] == tbl.L["DEBUG"] and source ~= tbl.L["AUCTION_HOUSE"] then
		if tbl.Creatures[tbl.itemSourceCreatureID] then print(tbl.Creatures[tbl.itemSourceCreatureID].unitName) else print(nil) end
		if tbl.encounterID then print(tbl.Encounters[tbl.encounterID]) else print(nil) end
		if tbl.Quests[tbl.questID] then print(tbl.Quests[tbl.questID].questTitle) else print(nil) end
		if tbl.target then print(tbl.target) else print(nil) end
	end
end]]
-- Synopsis: Responsible for adding a NEW (not seen before this moment) item to the items table.

--[[tbl.Update = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, playerClass, playerLevel)
	if not source or not itemID then return end -- For some reason auctions are calling this...
	
	local isSourceKnown
	
	if tbl.Items[itemID]["itemRarity"] ~= itemRarity then tbl.Items[itemID]["itemRarity"] = itemRarity; tbl.wasUpdated = true end
	if tbl.Items[itemID]["itemIcon"] ~= itemIcon then tbl.Items[itemID]["itemIcon"] = itemIcon; tbl.wasUpdated = true end
	if tbl.Items[itemID]["lootDate"] ~= currentDate then tbl.Items[itemID]["lootDate"] = currentDate; tbl.wasUpdated = true end
	if tbl.Items[itemID]["location"] ~= currentMap then tbl.Items[itemID]["location"] = currentMap; tbl.wasUpdated = true end
	if tbl.Items[itemID]["source"] ~= source then tbl.Items[itemID]["source"] = source; tbl.wasUpdated = true end
	if tbl.Items[itemID]["lootedBy"]["playerClass"] ~= playerClass then tbl.Items[itemID]["lootedBy"]["playerClass"] = playerClass; tbl.wasUpdated = true end
	if tbl.Items[itemID]["lootedBy"]["playerLevel"] ~= playerLevel then tbl.Items[itemID]["lootedBy"]["playerLevel"] = playerLevel; tbl.wasUpdated = true end
	
	if tbl.Items[itemID]["itemIcon"] == nil then tbl.Items[itemID]["itemIcon"] = itemIcon end
	if tbl.Items[itemID]["itemSubType"] == nil then tbl.Items[itemID]["itemSubType"] = itemSubType end
	if tbl.Items[itemID]["itemEquipLoc"] == nil then tbl.Items[itemID]["itemEquipLoc"] = itemEquipLoc end
	
	if tbl.Contains(tbl.History, nil, "itemLink", itemLink) ~= true then
		table.insert(tbl.History, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	if tbl.LootTemplate[itemID] then -- The item has been added to the loot template database at some point in the past.
		for k, v in next, tbl.LootTemplate[itemID] do
			if (k == source) then -- An existing source was discovered therefore we should increment that source.
				v = v + 1 tbl.LootTemplate[itemID][k] = v
				sourceIsKnown = true
			else
				sourceIsKnown = false
			end
		end
		
		if not sourceIsKnown then
			tbl.LootTemplate[itemID][source] = 1
			sourceIsKnown = ""; -- Set this boolean equal to a blank string. 
		end
	else -- The item exists in the item template database, but hasn't been inserted into the loot template database yet.
		tbl.LootTemplate[itemID] = {[source] = 1};
	end
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	local sourceTblSize = table.getn(tbl.Items[itemID]["sourceIDs"]);
	if sourceID then
		if (sourceTblSize < 1) then
			tbl.Items[itemID]["sourceIDs"][sourceID] = currentDate
		else
			for k, v in pairs(tbl.Items[itemID]["sourceIDs"]) do
				if (k == sourceID) then
					if (v ~= currentDate) then
						v = currentDate
					end
				end
			end
		end
	end
	if tbl.Settings["mode"] == tbl.L["SILENT"] or tbl.Settings["mode"] == tbl.L["NO_UPDATES"] then
		-- If the player uses Silent or No Updates mode, then simply mark the wasUpdated boolean as false so it's not reported to them.
		tbl.wasUpdated = false;
	end
	if tbl.wasUpdated then
		if sourceID then
			if itemType == "Armor" or itemType == "Weapon" then
				local isAppearanceKnown = C_TransmogCollection.GetSourceInfo(sourceID).isCollected
				if isAppearanceKnown then
					print(tbl.L["ADDON_NAME"] .. tbl.L["UPDATED"] .. " |TInterface\\Addons\\LastSeen\\Assets\\known:0|t" .. " |T" .. itemIcon .. ":0|t " .. itemLink .. ", " .. source)
				elseif isAppearanceKnown ~= true and (tbl.classDefaults[tbl.playerClass]["Armor"] == itemSubType or tbl.classDefaults[tbl.playerClass]["Weapons"][itemSubType] == 1) then
					print(tbl.L["ADDON_NAME"] .. tbl.L["UPDATED"] .. " |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t" .. " |T" .. itemIcon .. ":0|t " .. itemLink .. "*" .. " - " .. source)
				else
					print(tbl.L["ADDON_NAME"] .. tbl.L["UPDATED"] .. " |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t" .. " |T" .. itemIcon .. ":0|t " .. itemLink .. ", " .. source)
				end
			end
		elseif (tbl.Settings["mode"] ~= tbl.L["SILENT"] or tbl.Settings["mode"] ~= tbl.L["NO_UPDATES"]) then
			print(tbl.L["ADDON_NAME"] .. tbl.L["UPDATED"] .. " |T" .. itemIcon .. ":0|t " .. itemLink .. ", " .. source)
		end
		tbl.wasUpdated = false;
	end
	
	tbl.RollHistory();
	
	if tbl.Settings["mode"] == tbl.L["DEBUG"] and source ~= tbl.L["AUCTION_HOUSE"] then
		if tbl.Creatures[tbl.itemSourceCreatureID] then print(tbl.Creatures[tbl.itemSourceCreatureID].unitName) else print(nil) end
		if tbl.encounterID then print(tbl.Encounters[tbl.encounterID]) else print(nil) end
		if tbl.Quests[tbl.questID] then print(tbl.Quests[tbl.questID].questTitle) else print(nil) end
		if tbl.target then print(tbl.target) else print(nil) end
	end
end]]
-- Synopsis: Responsible for updating attributes about items (such as the date they were seen) already in the items table.