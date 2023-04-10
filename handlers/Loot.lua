local addonName, addonTable = ...
local frame = CreateFrame("Frame")
local known = "|TInterface\\Addons\\LastSeen\\Assets\\known:0|t"
local unknown = "|TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t"

local function CheckData(tab)
	for _, arg in ipairs(tab) do
		if arg == nil then
			return false
		end
	end
	return true
end

local function ItemExists(itemID)
	if LastSeenDB.Items[itemID] then
		return true
	end
	return false
end

function LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, lootDate, map, source)
	-- This is a staging ground for items. We need to weed
	-- out the unwanted items (items that aren't new or in
	-- need of an update.)
	if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
	
	-- Check if the item is in the Items table.
	if ItemExists(itemID) then
		local updated = false
		local item = LastSeenDB.Items[itemID]
		
		-- Check if the loot date property needs an update.
		if item.lootDate ~= lootDate and lootDate ~= nil then
			item.lootDate = lootDate
			updated = true
		end
		
		-- Check if the map property needs an update.
		if item.map ~= map and map ~= nil then
			item.map = map
			updated = true
		end
		
		-- Check if the source property needs an update.
		if item.source ~= source and source ~= nil then
			item.source = source
			updated = true
		end
		
		-- Check to see if the sourceID needs to be updated.
		-- Some items have multiple sourceIDs, and some of them
		-- can stop dropping. We would like to keep record of them.
		if item.sourceInfo then
			if sourceID ~= 0 and sourceID ~= nil then
				if item.sourceInfo.sourceID ~= lootDate then
					item.sourceInfo.sourceID = lootDate
					updated = true
				end
			end
		end
		
		if LastSeenDB.modeID == 1 then
			if updated then
				-- The item was updated, so let's print out the information!
				print(string.format("Updated: %s %s", itemIcon, link))
			end
		end
	else
		-- This is a new item.
		local collectedIcon = ""
		if sourceID ~= 0 then
			local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
			if sourceInfo then
				if sourceInfo.isCollected then
					collectedIcon = known
				else
					collectedIcon = unknown
				end
			end
		end
		-- Create a temporary table to hold the item's information. We'll use it to check for
		-- nil data.
		local temp = {}
		temp["link"] = link
		temp["itemName"] = itemName
		temp["rarity"] = rarity
		temp["itemType"] = itemType
		temp["itemIcon"] = itemIcon
		temp["lootDate"] = lootDate
		temp["map"] = map
		temp["source"] = source
		
		local continue = CheckData(temp)
		if continue then
			-- All the item's information is valid (no nils).
			LastSeenDB.Items[itemID] = { link = link, name = itemName, rarity = rarity, type = itemType, icon = itemIcon, lootDate = lootDate, map = map, source = source, sourceInfo = { sourceID = lootDate } }
			
			-- The item was added, so let's print out the information!
			if LastSeenDB.modeID == 1 or LastSeenDB.modeID == 2 then
				if sourceID ~= 0 then
					print(string.format("Added: %s %s %s", itemIcon, link, collectedIcon))
				else
					print(string.format("Added: %s %s", itemIcon, link))
				end
			end
		end
	end
end

-- Events to register with the frame.
frame:RegisterEvent("LOOT_READY")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "LOOT_READY" then
		for i = 1, GetNumLootItems() do
			local link = GetLootSlotLink(i)
			if link then
				-- Not every item has a link. A great example is currency,
				-- so let's make sure the link is valid.
				local lootSources = { GetLootSourceInfo(i) }
				for i = 1, #lootSources, 2 do
					-- We skip every other entry in the table because
					-- every other entry in the table is a loot source
					-- GUID. Odd entries are GUIDs and even entries are
					-- the count for what dropped.
					-- Let's get some information about the item we looted.
					local itemName, _, rarity = GetItemInfo(link)
					local itemID, itemType, _, _, itemIcon = GetItemInfoInstant(link)
					
					-- Make sure the item's rarity is at or above the desired
					-- rarity filter.
					if rarity >= LastSeenDB.rarityID then
						-- Make sure the item's type is supposed to be tracked.
						if LastSeenDB.Filters[itemType] then
							-- We're dealing with a supported item, so let's proceed.
							local _, _, _, _, _, npcID = string.split("-", lootSources[i]); npcID = tonumber(npcID)
							
							-- Let's get the source ID (it's like an ID associated to an appearance)
							-- of the item.
							local _, sourceID = C_TransmogCollection.GetItemInfo(link)
							
							-- If the sourceID is nil, then it's likely an item without one. Let's
							-- set it to 0 in those cases.
							if sourceID == nil then
								sourceID = 0
							end
							
							LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), "Valley of the Four Winds", LastSeenDB.Creatures[npcID])
						else
							-- If the mode is set to Normal or Only New then print a statement
							-- to the player.
							if LastSeenDB.modeID == 1 or LastSeenDB.modeID == 2 then
								print(string.format("%s has an item type that isn't enabled or is unsupported: |cffFFD100%s|r", link, itemType))
							end
						end
					end
				end
			end
		end
	end
end)


--[[ OLD CODE

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
]]