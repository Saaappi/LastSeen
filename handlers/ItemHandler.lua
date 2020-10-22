-- Namespace Variables
local addon, tbl = ...;
local sourceIsKnown

--[[
	Note 1: A source ID is a unique identifier for an individual appearance. It's possible for an item to have 2 or more source IDs, and not every
	ID may be seen. This could be due to it not being in the game as an option OR that it's no longer dropping... only time can tell.
]]

--[[
	Note 2: The 'known' and 'unknown' assets are from Can I Mog It? A special thanks to the author for the icons.
]]

tbl.New = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, playerClass, playerLevel)

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
end
-- Synopsis: Responsible for adding a NEW (not seen before this moment) item to the items table.

tbl.Update = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, playerClass, playerLevel)
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
end
-- Synopsis: Responsible for updating attributes about items (such as the date they were seen) already in the items table.

tbl.AddItem = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, playerClass, playerLevel, action)
	if itemRarity < tbl.Settings["rarity"] then return end
	if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then -- The item is whitelisted so don't check the blacklists.
	else
		-- The item or item type is ignored.
		if tbl.Contains(tbl.IgnoredItems, itemID, nil, nil) then return end;
		if tbl.Contains(tbl.IgnoredItemTypes, nil, itemType, nil) then return end;
		if tbl.Contains(tbl.IgnoredItemTypes, nil, itemSubType, nil) then return end;
		if tbl.Contains(LastSeenIgnoredItemsDB, itemID, nil, nil) then return end;
		if itemEquipLoc == "INVTYPE_NECK" or itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
			if not tbl.Settings["isNeckFilterEnabled"] then return end
			if not tbl.Settings["isRingFilterEnabled"] then return end
			if not tbl.Settings["isTrinketFilterEnabled"] then return end
		end
		if itemType == "Quest" or itemType == "Gem" then
			if not tbl.Settings["isQuestFilterEnabled"] then return end
			if not tbl.Settings["isGemFilterEnabled"] then return end
		end
	end
	
	local itemSourceCreatureID = tbl.itemsToSource[itemID]
	
	if action == "Update" then
		tbl.Update(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, playerClass, playerLevel)
	else
		tbl.New(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, playerClass, playerLevel)
	end
end
-- Synopsis: A staging ground for items before they're passed on to the functions responsible for adding them or updating them. Helps weed out the unwanteds.