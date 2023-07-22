local addonName, addon = ...
local frame = CreateFrame("Frame")
local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"
local known = "|TInterface\\Addons\\LastSeen\\Assets\\known:0|t"
local unknown = "|TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t"
local unknown_by_character = "|TInterface\\Addons\\LastSeen\\Assets\\unknown_by_character:0|t"
local unknown_soulbound = "|TInterface\\Addons\\LastSeen\\Assets\\unknown_soulbound:0|t"

local isFishingLoot = false
local fishingSource = ""

local isGatheringLoot = false
local gatheringSource = ""

local isUnknownLoot = false
local unknownSource = ""

local isChestLoot = false
local chestSource = ""

local processed = {} -- Used to mitigate the frequency that items are updated in Normal mode

local function Check(var, name, reason)
	if var then
		return var
	else
		print(coloredAddOnName .. ": " .. name .. " is nil." .. " " .. reason)
		return ""
	end
end

function LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, lootDate, map, location, source)
	if not itemID then return end
	
	if LastSeenDB.IgnoredItems[itemID] then return end

	if (source ~= nil) and (source ~= "") then
		source = source
	elseif (isFishingLoot) then
		source = fishingSource
	elseif (isGatheringLoot) then
		source = gatheringSource
	elseif (isUnknownLoot) then
		source = unknownSource
	elseif (isChestLoot) then
		source = chestSource
	elseif (addon.unknownItems[itemID]) then
		source = addon.unknownItems[itemID]
	elseif (source == nil) then
		source = ""
	end
	
	local factionID = 2
	local faction = UnitFactionGroup("player")
	if (faction == "Alliance") then
		factionID = 0
	elseif (faction == "Horde") then
		factionID = 1
	else
		factionID = 2
	end
	local _, _, classID = UnitClass("player")
	local level = UnitLevel("player")
	
	local collectedIcon = ""
	if (sourceID ~= 0) then
		local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
		if (sourceInfo) then
			local _, canPlayerCollectSource = C_TransmogCollection.PlayerCanCollectSource(sourceID)
			if (sourceInfo.isCollected) then
				collectedIcon = known
			elseif (sourceInfo.isCollected == false and canPlayerCollectSource) then
				collectedIcon = unknown
			else
				local bindType = select(14, GetItemInfo(itemLink))
				if (bindType == 2) then
					collectedIcon = unknown_by_character
				else
					collectedIcon = unknown_soulbound
				end
			end
		end
	end

	if (LastSeenDB.Items[itemID]) then
		local updated = false
		local item = LastSeenDB.Items[itemID]
		
		if (item.lootDate ~= lootDate and lootDate ~= nil) then
			item.lootDate = lootDate
			updated = true
		end
		
		if (item.map ~= map and map ~= nil) then
			item.map = map
			updated = true
		end
		
		if (item.source ~= source and source ~= nil) then
			item.source = source
			updated = true
		end
		
		if (item.lootedBy.class ~= classID and item.lootedBy.level ~= level) then
			item.lootedBy.classID = classID
			item.lootedBy.level = level
			updated = true
		end
		
		if (item.sourceInfo) then
			if (sourceID ~= 0 and sourceID ~= nil) then
				if (item.sourceInfo.sourceID ~= lootDate) then
					item.sourceInfo.sourceID = lootDate
					updated = true
				end
			end
		end
		
		if ( not IsInInstance("player") ) then
			if ( type(item.location) ~= "string" ) then
				if (location.mapID ~= item.location.mapID) then
					item.location.mapID = location.mapID
					item.location.x = location.x
					item.location.y = location.y
				end
				if (location.x ~= item.location.x) then
					item.location.x = location.x
				end
				if (location.y ~= item.location.y) then
					item.location.y = location.y
				end
			end
		end
		
		if (LastSeenDB.modeID == 1) or (LastSeenDB.modeID == 3) then
			if (updated and processed[itemID] ~= true) then
				if (LastSeenDB.modeID == 3) then
					if (item.lootDate == lootDate) then
						return
					end
				end
				
				if (sourceID ~= 0) then
					print(string.format("%s: Updated: |T%s:0|t %s %s", coloredAddOnName, itemIcon, itemLink, collectedIcon))
				else
					print(string.format("%s: Updated: |T%s:0|t %s", coloredAddOnName, itemIcon, itemLink))
				end
				
				processed[itemID] = true
			end
		end
	else
		local vars = {}
		vars["itemLink"] = Check(itemLink, "itemLink", "You'll need to acquire the item again. It's a low chance the link will be nil twice.")
		vars["itemName"] = Check(itemName, "itemName", "You'll need to acquire the item again. It's a low chance the name will be nil twice.")
		vars["itemRarity"] = Check(itemRarity, "itemRarity", "You'll need to acquire the item again. It's a low chance the rarity will be nil twice.")
		vars["itemType"] = Check(itemType, "itemType", "You'll need to acquire the item again. It's a low chance the type will be nil twice.")
		vars["itemIcon"] = Check(itemIcon, "itemIcon", "You'll need to acquire the item again. It's a low chance the icon will be nil twice.")
		vars["lootDate"] = Check(lootDate, "lootDate", "You'll need to acquire the item again. If possible, you should reload before you get the item again.")
		vars["map"] = Check(map, "map", "You'll need to acquire the item again. If possible, you should reload before you get the item again.")
		if ( not IsInInstance("player") ) then
			vars["location"] = Check(location, "location", "Not much can be done. Try to loot the item again.")
		end
		vars["source"] = Check(source, "source", "You'll need to acquire the item again. If possible, you should reload before you get the item again.")
		
		if ( not IsInInstance("player") ) then
			LastSeenDB.Items[itemID] = { itemLink = vars["itemLink"], itemName = vars["itemName"], itemRarity = vars["itemRarity"], itemType = vars["itemType"], itemIcon = vars["itemIcon"], lootDate = vars["lootDate"], map = vars["map"], location = vars["location"], source = vars["source"], sourceInfo = { [sourceID] = lootDate }, lootedBy = { factionID = factionID, classID = classID, level = level } }
		else
			LastSeenDB.Items[itemID] = { itemLink = vars["itemLink"], itemName = vars["itemName"], itemRarity = vars["itemRarity"], itemType = vars["itemType"], itemIcon = vars["itemIcon"], lootDate = vars["lootDate"], map = vars["map"], location = vars["location"], source = vars["source"], sourceInfo = { [sourceID] = lootDate }, lootedBy = { factionID = factionID, classID = classID, level = level } }
		end
		
		if (LastSeenDB.modeID == 1) or (LastSeenDB.modeID == 2) or (LastSeenDB.modeID == 3) then
			if (sourceID ~= 0) then
				print(string.format("%s: Added: |T%s:0|t %s %s", coloredAddOnName, itemIcon, itemLink, collectedIcon))
			else
				print(string.format("%s: Added: |T%s:0|t %s", coloredAddOnName, itemIcon, itemLink))
			end
		end
	end
end

frame:RegisterEvent("ENCOUNTER_START")
frame:RegisterEvent("LOOT_READY")
frame:RegisterEvent("LOOT_OPENED")
frame:RegisterEvent("LOOT_CLOSED")
frame:RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED")
frame:RegisterEvent("UNIT_SPELLCAST_SENT")
frame:RegisterEvent("UNIT_SPELLCAST_START")
frame:RegisterEvent("UNIT_SPELLCAST_FAILED")
frame:RegisterEvent("UNIT_SPELLCAST_FAILED_QUIET")
frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
frame:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
frame:SetScript("OnEvent", function(self, event, ...)
	if ( event == "ENCOUNTER_START" ) then
		addon.isOnEncounter = true
	end
	if ( event == "ENCOUNTER_LOOT_RECEIVED" ) then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local playerName = UnitName("player")
		local encounterID, itemID, itemLink, _, looterName = ...
		
		if ( LastSeenDB.Encounters[encounterID] ) then
			local encounter = LastSeenDB.Encounters[encounterID]
			if ( itemLink ) then
				if ( playerName == looterName ) then
					local itemName, _, itemRarity = GetItemInfo(itemLink)
					local _, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
					if ( itemRarity ) then
						if ( itemRarity >= LastSeenDB.rarityID ) then
							if ( LastSeenDB.Filters[itemType] ) then
								local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
								if ( sourceID == nil ) then
									sourceID = 0
								end
								LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), (GetInstanceInfo(encounter.instanceID)) .. " (" .. select(4, GetInstanceInfo(encounter.instanceID)) .. ")", { mapID = addon.mapID, x = 0, y = 0 }, encounter.encounterName)
							else
								if ( LastSeenDB.Filters[itemType] == nil ) then
									print(string.format("%s has an item type that is unsupported: |cffFFD100%s|r", itemLink, itemType))
								end
							end
						end
					end
				end
			end
		end
	end
	if (event == "LOOT_OPENED") then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		if ( addon.isOnEncounter ) then return false end
		
		local x, y = LastSeen:GetMapPosition(addon.mapID)
		local location = { mapID = addon.mapID, x = x, y = y }
		for i = 1, GetNumLootItems() do
			local itemLink = GetLootSlotLink(i)
			if (itemLink) then
				local lootSources = { GetLootSourceInfo(i) }
				for i = 1, #lootSources, 2 do
					local itemName, _, itemRarity = GetItemInfo(itemLink)
					local itemID, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
					if (itemRarity) then
						if (itemRarity >= LastSeenDB.rarityID) then
							if (LastSeenDB.Filters[itemType]) then
								local _, _, _, _, _, npcID = string.split("-", lootSources[i]); npcID = tonumber(npcID)
								local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
								if (sourceID == nil) then
									sourceID = 0
								end
								LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), addon.map, location, LastSeenDB.Creatures[npcID])
							else
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
	if (event == "LOOT_CLOSED") then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		isFishingLoot = false
		fishingSource = ""
		
		isGatheringLoot = false
		gatheringSource = ""
		
		isUnknownLoot = false
		unknownSource = ""
		
		isChestLoot = false
		chestSource = ""
		
		processed = {}
		
		addon.isOnEncounter = false
	end
	if (event == "UNIT_SPELLCAST_SENT") then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local _, target, GUID = ...
		if (GUID) then
			local _, _, _, _, _, spellID = string.split("-", GUID); spellID = tonumber(spellID)
			if (addon.targetSpells[spellID]) then
				isChestLoot = true
				chestSource = target
			end
		end
	end
	if (event == "UNIT_SPELLCAST_START") then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local _, GUID = ...
		if (GUID) then
			local _, _, _, _, _, spellID = string.split("-", GUID); spellID = tonumber(spellID)
			if (addon.noTargetSpells[spellID]) then
				isGatheringLoot = true
				gatheringSource = addon.noTargetSpells[spellID]
			end
			if (addon.skinningSpells[spellID]) then
				isGatheringLoot = true
				gatheringSource = addon.noTargetSpells[spellID]
			end
		end
	end
	if (event == "UNIT_SPELLCAST_FAILED") or (event == "UNIT_SPELLCAST_FAILED_QUIET") or (event == "UNIT_SPELLCAST_INTERRUPTED") then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local unit, _, spellID = ...
		if (unit) then
			if (unit == "player") then
				if (addon.targetSpells[spellID]) or (addon.noTargetSpells[spellID]) or (addon.skinningSpells[spellID]) then
					isFishingLoot = false
					fishingSource = ""
					
					isGatheringLoot = false
					gatheringSource = ""
					
					isUnknownLoot = false
					unknownSource = ""
					
					isChestLoot = false
					chestSource = ""
				end
			end
		end
	end
	if (event == "PLAYER_SOFT_INTERACT_CHANGED") then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local GUID = ...
		if (GUID) then
			local type, _, _, _, _, ID = string.split("-", GUID); ID = tonumber(ID)
			if (type == "GameObject") then
				if addon.objects[ID] then
					isFishingLoot = true
					fishingSource = addon.objects[ID]
				end
			end
		end
	end
end)