local addonName, addonTable = ...
local frame = CreateFrame("Frame")
local known = "|TInterface\\Addons\\LastSeen\\Assets\\known:0|t"
local unknown = "|TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t"
local otherSource = ""

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
	-- Try to determine if another source is available.
	-- If not, then simply provide a blank source.
	if source == nil and otherSource ~= "" then
		source = otherSource
	elseif source == nil and LastSeenDB.Items[itemID].source ~= "" then
		return -- We return so that we don't update an item with a bad source.
	elseif source == nil then
		source = ""
	end
	
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
				print(string.format("Updated: |T%s:0|t %s", itemIcon, itemLink))
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
		temp["link"] = itemLink
		temp["itemName"] = itemName
		temp["rarity"] = itemRarity
		temp["itemType"] = itemType
		temp["itemIcon"] = itemIcon
		temp["lootDate"] = lootDate
		temp["map"] = map
		temp["source"] = source
		
		local continue = CheckData(temp)
		if continue then
			-- All the item's information is valid (no nils).
			LastSeenDB.Items[itemID] = { itemLink = itemLink, itemName = itemName, itemRarity = itemRarity, itemType = itemType, itemIcon = itemIcon, lootDate = lootDate, map = map, source = source, sourceInfo = { [sourceID] = lootDate } }
			
			-- The item was added, so let's print out the information!
			if LastSeenDB.modeID == 1 or LastSeenDB.modeID == 2 then
				if sourceID ~= 0 then
					print(string.format("Added: |T%s:0|t %s %s", itemIcon, itemLink, collectedIcon))
				else
					print(string.format("Added: |T%s:0|t %s", itemIcon, itemLink))
				end
			end
		end
	end
end

-- Events to register with the frame.
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "LOOT_READY" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		for i = 1, GetNumLootItems() do
			local itemLink = GetLootSlotLink(i)
			if itemLink then
				-- Not every item has a link. A great example is currency,
				-- so let's make sure the link is valid.
				local lootSources = { GetLootSourceInfo(i) }
				for i = 1, #lootSources, 2 do
					-- We skip every other entry in the table because
					-- every other entry in the table is a loot source
					-- GUID. Odd entries are GUIDs and even entries are
					-- the count for what dropped.
					-- Let's get some information about the item we looted.
					local itemName, _, itemRarity = GetItemInfo(itemLink)
					local itemID, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
					
					-- Make sure the item's rarity is at or above the desired
					-- rarity filter.
					if itemRarity then
						-- An item's rarity can be nil, seems to apply to currencies (e.g. charms).
						if itemRarity >= LastSeenDB.rarityID then
							-- Make sure the item's type is supposed to be tracked.
							if LastSeenDB.Filters[itemType] then
								-- We're dealing with a supported item, so let's proceed.
								local _, _, _, _, _, npcID = string.split("-", lootSources[i]); npcID = tonumber(npcID)
								
								-- Let's get the source ID (it's like an ID associated to an appearance)
								-- of the item.
								local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
								
								-- If the sourceID is nil, then it's likely an item without one. Let's
								-- set it to 0 in those cases.
								if sourceID == nil then
									sourceID = 0
								end
								
								LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), addonTable.map, LastSeenDB.Creatures[npcID])
							else
								-- If the mode is set to Normal or Only New then print a statement
								-- to the player.
								if LastSeenDB.modeID == 1 or LastSeenDB.modeID == 2 then
									print(string.format("%s has an item type that isn't enabled or is unsupported: |cffFFD100%s|r", itemLink, itemType))
								end
							end
						end
					end
				end
			end
		end
	end
	if event == "UNIT_SPELLCAST_SUCCEEDED" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local _, GUID = ...
		if GUID then
			local _, _, _, _, _, spellID = string.split("-", GUID); spellID = tonumber(spellID)
			if addonTable.spells[spellID] then
				otherSource = addonTable.spells[spellID]
			end
		end
	end
	if event == "PLAYER_SOFT_INTERACT_CHANGED" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local GUID = ...
		if GUID then
			local type, _, _, _, _, ID = string.split("-", GUID); ID = tonumber(ID)
			if type == "GameObject" then
				if addonTable.objects[ID] then
					otherSource = addonTable.objects[ID]
				end
			end
		end
	end
end)