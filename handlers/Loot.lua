local addonName, addonTable = ...
local frame = CreateFrame("Frame")
local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"
local known = "|TInterface\\Addons\\LastSeen\\Assets\\known:0|t"
local unknown = "|TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t"
local unknown_by_character = "|TInterface\\Addons\\LastSeen\\Assets\\unknown_by_character:0|t"
local unknown_soulbound = "|TInterface\\Addons\\LastSeen\\Assets\\unknown_soulbound:0|t"
local otherSource = ""

local function Check(var, name, reason)
	-- Determine if the data in the variable is legitimate or
	-- not. If not legitimate, then return an empty string so
	-- nil isn't stored in the Items table.
	if var then
		return var
	else
		print(coloredAddOnName .. ": " .. name .. " is nil." .. " " .. reason)
		return ""
	end
end

function LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, lootDate, map, source)
	-- If the item even has an ID...
	if not itemID then return end
	
	-- Determine if the item is being ignored.
	if LastSeenDB.IgnoredItems[itemID] then return end

	if (otherSource ~= "") then
		-- Another source (some sort of gameobject or spell interaction) changed the
		-- source, so let's make sure that gets set.
		source = otherSource
	elseif (source == nil) and (otherSource ~= "") then
		-- The source is nil, but we have a value in the otherSource
		-- variable. This means the item was looted from a profession,
		-- chest, etc.
		source = otherSource
	elseif LastSeenDB.Items[itemID] then
		-- The item is already in the table. Let's see if it has a source.
		local item = LastSeenDB.Items[itemID]
		if item.source then
			-- We want to return because the source is nil, but the item already
			-- has a source. We don't want to replace a source with a bad one.
			if (source == nil) then return end
		end
	elseif addonTable.unknownItems[itemID] then
		-- The item is in the unknowns table, which means we're manually specifying
		-- a localized source.
		source = addonTable.unknownItems[itemID]
	elseif source == nil then
		-- The source is nil and we don't have another source to use, so make it an
		-- empty string. The source will be interpreted as "Unknown" in tooltips and
		-- "-" in search output.
		source = ""
	end
	
	-- Get the player's faction, class, and level.
	-- The faction defaults to Neutral, unless proven
	-- otherwise.
	local factionID = 2
	local faction = UnitFactionGroup("player")
	if faction == "Alliance" then
		factionID = 0
	elseif faction == "Horde" then
		factionID = 1
	else -- Neutral
		factionID = 2
	end
	local _, _, classID = UnitClass("player")
	local level = UnitLevel("player")
	
	-- Let's setup a collection icon to use for items
	-- with a source ID.
	local collectedIcon = ""
	if sourceID ~= 0 then
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		if sourceInfo then
			local _, canPlayerCollectSource = C_TransmogCollection.PlayerCanCollectSource(sourceID)
			if sourceInfo.isCollected then
				collectedIcon = known
			elseif sourceInfo.isCollected == false and canPlayerCollectSource then
				collectedIcon = unknown
			else
				local bindType = select(14, GetItemInfo(itemLink))
				if bindType == 2 then
					collectedIcon = unknown_by_character
				else
					collectedIcon = unknown_soulbound
				end
			end
		end
	end
	
	-- Check if the item is in the Items table.
	if LastSeenDB.Items[itemID] then
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
		
		-- Check if the class/level properties need an update.
		if item.lootedBy.class ~= classID and item.lootedBy.level ~= level then
			item.lootedBy.classID = classID
			item.lootedBy.level = level
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
		
		if (LastSeenDB.modeID == 1) or (LastSeenDB.modeID == 3) then
			if updated then
				if LastSeenDB.modeID == 3 then
					-- If the mode is set to "Updates (Once Per Day)" then check to
					-- see if the item was updated today. If so, then return.
					if item.lootDate == lootDate then
						return
					end
				end
				
				-- The item was updated, so let's print out the information!
				if sourceID ~= 0 then
					print(string.format("%s: Updated: |T%s:0|t %s %s", coloredAddOnName, itemIcon, itemLink, collectedIcon))
				else
					print(string.format("%s: Updated: |T%s:0|t %s", coloredAddOnName, itemIcon, itemLink))
				end
			end
		end
	else -- New Item
		-- Create an empty table called vars. This table will hold either
		-- legitimate data or nil.
		--
		-- The data is passed to the Check function to determine if it's
		-- legitimate.
		local vars = {}
		vars["itemLink"] = Check(itemLink, "itemLink", "You'll need to acquire the item again. It's a low chance the link will be nil twice.")
		vars["itemName"] = Check(itemName, "itemName", "You'll need to acquire the item again. It's a low chance the name will be nil twice.")
		vars["itemRarity"] = Check(itemRarity, "itemRarity", "You'll need to acquire the item again. It's a low chance the rarity will be nil twice.")
		vars["itemType"] = Check(itemType, "itemType", "You'll need to acquire the item again. It's a low chance the type will be nil twice.")
		vars["itemIcon"] = Check(itemIcon, "itemIcon", "You'll need to acquire the item again. It's a low chance the icon will be nil twice.")
		vars["lootDate"] = Check(lootDate, "lootDate", "You'll need to acquire the item again. If possible, you should reload before you get the item again.")
		vars["map"] = Check(map, "map", "You'll need to acquire the item again. If possible, you should reload before you get the item again.")
		vars["source"] = Check(source, "source", "You'll need to acquire the item again. If possible, you should reload before you get the item again.")
		
		-- Insert the item into the Items table.
		LastSeenDB.Items[itemID] = { itemLink = vars["itemLink"], itemName = vars["itemName"], itemRarity = vars["itemRarity"], itemType = vars["itemType"], itemIcon = vars["itemIcon"], lootDate = vars["lootDate"], map = vars["map"], source = vars["source"], sourceInfo = { [sourceID] = lootDate }, lootedBy = { factionID = factionID, classID = classID, level = level } }
		
		-- A new item was added to the Items table, so let's report it
		-- to the player.
		--
		-- This should only happen if the player is using Normal or
		-- New Only output modes.
		if (LastSeenDB.modeID == 1) or (LastSeenDB.modeID == 2) or (LastSeenDB.modeID == 3) then
			if sourceID ~= 0 then
				print(string.format("%s: Added: |T%s:0|t %s %s", coloredAddOnName, itemIcon, itemLink, collectedIcon))
			else
				print(string.format("%s: Added: |T%s:0|t %s", coloredAddOnName, itemIcon, itemLink))
			end
		end
	end
end

-- Events to register with the frame.
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("LOOT_CLOSED")
frame:RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED")
frame:RegisterEvent("UNIT_SPELLCAST_SENT")
frame:RegisterEvent("UNIT_SPELLCAST_START")
frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
frame:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "ENCOUNTER_LOOT_RECEIVED" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		-- Get the encounter ID, item ID, item link, and the player that looted the item.
		local encounterID, itemID, itemLink, _, looterName = ...
		if itemLink then
			-- If the item link is valid and the player that looted the item is our
			-- current player, then continue.
			local playerName = UnitName("player")
			if playerName == looterName then
				local itemName, _, itemRarity = GetItemInfo(itemLink)
				local _, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
				
				-- Make sure the item's rarity is at or above the desired
				-- rarity filter.
				if itemRarity then
					-- An item's rarity can be nil, seems to apply to currencies (e.g. charms).
					if itemRarity >= LastSeenDB.rarityID then
						-- Make sure the item's type is supposed to be tracked.
						if LastSeenDB.Filters[itemType] then
							-- Let's get the source ID (it's like an ID associated to an appearance)
							-- of the item.
							local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
							
							-- If the sourceID is nil, then it's likely an item without one. Let's
							-- set it to 0 in those cases.
							if sourceID == nil then
								sourceID = 0
							end
							
							LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), (GetInstanceInfo(LastSeenDB.Encounters[encounterID].instanceID)), LastSeenDB.Encounters[encounterID].encounterName)
						else
							-- If the player loots an item that has a type that LastSeen doesn't have a filter for,
							-- then inform the player of the situation.
							if LastSeenDB.Filters[itemType] == nil then
								print(string.format("%s has an item type that is unsupported: |cffFFD100%s|r", itemLink, itemType))
							end
						end
					end
				end
			end
		end
	end
	if event == "LOOT_READY" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		-- If the player is on an encounter, then don't process further loot until after the
		-- LOOT_CLOSED event is fired.
		if addonTable.isOnEncounter then return false end
		
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
								-- If the player loots an item that has a type that LastSeen doesn't have a filter for,
								-- then inform the player of the situation.
								if LastSeenDB.Filters[itemType] == nil then
									print(string.format("%s has an item type that is unsupported: |cffFFD100%s|r", itemLink, itemType))
								end
							end
						end
					end
				end
			end
		end
	end
	if event == "LOOT_CLOSED" then
		otherSource = ""
		addonTable.isOnEncounter = false
	end
	if event == "UNIT_SPELLCAST_SENT" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local _, target, GUID = ...
		if GUID then
			local _, _, _, _, _, spellID = string.split("-", GUID); spellID = tonumber(spellID)
			if addonTable.targetSpells[spellID] then
				otherSource = target
			end
		end
	end
	if event == "UNIT_SPELLCAST_START" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local _, GUID = ...
		if GUID then
			local _, _, _, _, _, spellID = string.split("-", GUID); spellID = tonumber(spellID)
			if addonTable.noTargetSpells[spellID] then
				otherSource = addonTable.noTargetSpells[spellID]
			end
			if addonTable.skinningSpells[spellID] then
				otherSource = addonTable.skinningSpells[spellID]
			end
		end
	end
	if event == "UNIT_SPELLCAST_FAILED" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local unit, _, spellID = ...
		if unit then
			if unit == "player" then
				if (addonTable.noTargetSpells[spellID]) or (addonTable.skinningSpells[spellID]) then
					otherSource = ""
				end
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