local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local e = CreateFrame("Frame")

local known = "|TInterface\\Addons\\LastSeen\\Assets\\known:0|t"
local unknown = "|TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t"

local isLooting = false -- A boolean to determine if the player is currently looting.

-- The select(1, ...) is a variable number of arguments. The arguments passed here are
-- as follows:
--
-- 1: collectedIcon - A checkmark if the item's source is collected. An X if the item's
-- source is NOT collected.
function LastSeen:New(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, lootDate, map, source, playerClass, playerLevel, ...)
	-- This is a new item, which is an item that we haven't
	-- seen before on the current account.
	if select(2, ...) then
		LastSeenItemDB[itemId] = { link = itemLink, name = itemName, rarity = itemRarity, type = itemType, icon = itemIcon, lootDate = lootDate, map = map, source = source, playerClass = playerClass, playerLevel = playerLevel, sourceInfo = { [select(2, ...)] = lootDate } }
	else
		LastSeenItemDB[itemId] = { link = itemLink, name = itemName, rarity = itemRarity, type = itemType, icon = itemIcon, lootDate = lootDate, map = map, source = source, playerClass = playerClass, playerLevel = playerLevel }
	end
	LastSeen:Print("add", itemIcon, select(1, ...), itemLink, source, lootDate, map)
end

function LastSeen:Update(itemId, itemLink, itemIcon, lootDate, map, source, playerClass, playerLevel, properties, ...)
	-- The item has been seen before and we need to update
	-- its source information.
	for _, property in pairs(properties) do
		if property.name == "sourceInfo" then
			LastSeenItemDB[itemId][property.name][select(2, ...)] = property.value
		else
			LastSeenItemDB[itemId][property.name] = property.value
		end
	end
	LastSeen:Print("update", itemIcon, select(1, ...), itemLink, source, lootDate, map)
end

function LastSeen:Item(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, sourceId, lootDate, map, source, playerClass, playerLevel, creatureId, action)
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
		if LastSeenItemDB[itemId]["sourceInfo"] then
			if LastSeenItemDB[itemId]["sourceInfo"][sourceId] ~= lootDate then
				properties[6] = { name = "sourceInfo", value = lootDate }; continue = true
			end
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
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceId)
		if sourceInfo then
			if sourceInfo.isCollected then
				collectedIcon = known
			else
				collectedIcon = unknown
			end
		end
	end
	
	if continue then
		-- If the item is meant to be added to the table,
		-- then let's add or update the item in the loot
		-- template database.
		if LastSeenLootTemplateDB[itemId] then
			if not LastSeenLootTemplateDB[itemId][creatureId] then
				LastSeenLootTemplateDB[itemId][creatureId] = source
			end
		else
			LastSeenLootTemplateDB[itemId] = { [creatureId] = source }
		end
		
		-- The map is nil so don't add it to the table.
		if map == nil then print(string.format(L_GLOBALSTRINGS["Text.Output.Error.MapUnavailable"], itemLink)); return end
		
		if action == "Update" then
			LastSeen:Update(itemId, itemLink, itemIcon, lootDate, map, source, playerClass, playerLevel, properties, collectedIcon, sourceId)
		else
			LastSeen:New(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, lootDate, map, source, playerClass, playerLevel, collectedIcon, sourceId)
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
		if LastSeenDB.ScanOnLootOpenedEnabled == false or LastSeenDB.ScanOnLootOpenedEnabled == nil then
			-- We only want to do this if Scan on Loot is NOT enabled.
			local itemLink = LastSeen:ExtractItemLink(L_GLOBALSTRINGS["Constant.LOOT_ITEM_SELF"] .. itemLink)
		end
		
		for i = 1, #lootSources, 2 do
			-- We skip every other entry in the table because
			-- every other entry in the table is a loot source
			-- GUID. Odd entries are GUIDs and even entries are
			-- the count for what dropped.
			-- Let's get some information about the item we looted.
			local itemName, _, itemRarity = GetItemInfo(itemLink)
			local itemId, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
			
			-- Let's get some information about the source we acquired
			-- the item from.
			local type, _, _, _, _, creatureId = string.split("-", lootSources[i]); creatureId = tonumber(creatureId)
			
			if itemId then
				itemsToSource[itemId] = creatureId
				local itemSourceCreatureId = itemsToSource[itemId]
				
				local action = ""
				if LastSeenItemDB[itemId] then
					-- This item has been seen before.
					action = "Update"
				else
					-- This is a new item.
					action = "New"
				end
				
				local _, sourceId = C_TransmogCollection.GetItemInfo(itemLink)
				if LastSeenCreatureDB[itemSourceCreatureId] then
					-- The item was acquired from a creature logged by
					-- the addon.
					LastSeen:Item(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, sourceId, date(LastSeenDB.DateFormat), addonTable.map, LastSeenCreatureDB[itemSourceCreatureId], (UnitClass("player")), (UnitLevel("player")), creatureId, action)
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
		
		if LastSeenDB.ScanOnLootOpenedEnabled then
			for slot = numLootSlots, 1, -1 do
				LastSeen:GetItemInfo(GetLootSlotLink(slot), slot)
			end
		else
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
	end
	if event == "LOOT_CLOSED" then
		isLooting = false
	end
end)