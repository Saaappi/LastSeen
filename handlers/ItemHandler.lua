-- Namespace Variables
local addon, tbl = ...;
local L = tbl.L
local sourceIsKnown

--[[
	Note 1: A source ID is a unique identifier for an individual appearance. It's possible for an item to have 2 or more source IDs, and not every
	ID may be seen. This could be due to it not being in the game as an option OR that it's no longer dropping... only time can tell.
]]

--[[
	Note 2: The 'known' and 'unknown' assets are from Can I Mog It? A special thanks to the author for the icons.
]]

tbl.New = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)

	if not source or not itemID then return end if tbl.Items[itemID] then return end

	tbl.Items[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, itemSubType = itemSubType, itemEquipLoc = itemEquipLoc, itemIcon = itemIcon, lootDate = currentDate, source = source, 
	location = currentMap, sourceIDs = {}};
	
	if tbl.Contains(tbl.History, nil, "itemLink", itemLink) ~= true then
		table.insert(tbl.History, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	tbl.LootTemplate[itemID] = {[source] = 1};
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	if sourceID then
		tbl.Items[itemID]["sourceIDs"][sourceID] = L["DATE"];
	end
	
	if sourceID and tbl.Settings["mode"] ~= L["SILENT"] then
		if itemType == "Armor" or itemType == "Weapon" then
			local isAppearanceKnown = C_TransmogCollection.GetSourceInfo(sourceID).isCollected
			if isAppearanceKnown then
				print(string.format(L["INFO_MSG_ITEM_ADDED_SRC_KNOWN"], itemIcon, itemLink, source));
			else
				print(string.format(L["INFO_MSG_ITEM_ADDED_SRC_UNKNOWN"], itemIcon, itemLink, source));
			end
		end
	elseif tbl.Settings["mode"] ~= L["SILENT"] then
		print(string.format(L["INFO_MSG_ITEM_ADDED_NO_SRC"], itemIcon, itemLink, source));
	end
	
	tbl.RollHistory();
	
	if tbl.Settings["mode"] == L["DEBUG"] and source ~= L["AUCTION_HOUSE"] then
		if tbl.Creatures[tbl.itemSourceCreatureID] then print(tbl.Creatures[tbl.itemSourceCreatureID].unitName) else print(nil) end
		if tbl.encounterID then print(tbl.Encounters[tbl.encounterID]) else print(nil) end
		if tbl.Quests[tbl.questID] then print(tbl.Quests[tbl.questID].questTitle) else print(nil) end
		if tbl.target then print(tbl.target) else print(nil) end
	end
end
-- Synopsis: Responsible for adding a NEW (not seen before this moment) item to the items table.

tbl.Update = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)
	if not source or not itemID then return end -- For some reason auctions are calling this...
	
	local isSourceKnown

	for v in pairs(tbl.Items[itemID]) do
		if v == "lootDate" then if tbl.Items[itemID][v] ~= currentDate then tbl.Items[itemID][v] = currentDate tbl.wasUpdated = true end end
		if v == "location" then if tbl.Items[itemID][v] ~= currentMap then tbl.Items[itemID][v] = currentMap tbl.wasUpdated = true end end
		if v == "source" then if tbl.Items[itemID][v] ~= source then tbl.Items[itemID][v] = source tbl.wasUpdated = true end end
	end
	
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
	
	if tbl.wasUpdated and tbl.Settings["mode"] ~= L["SILENT"] then
		if sourceID then
			if itemType == "Armor" or itemType == "Weapon" then
				local isAppearanceKnown = C_TransmogCollection.GetSourceInfo(sourceID).isCollected
				if isAppearanceKnown then
					print(string.format(L["INFO_MSG_ITEM_UPDATED_SRC_KNOWN"], itemIcon, itemLink, source));
				else
					print(string.format(L["INFO_MSG_ITEM_UPDATED_SRC_UNKNOWN"], itemIcon, itemLink, source));
				end
			end
		elseif tbl.Settings["mode"] ~= L["SILENT"] then
			print(string.format(L["INFO_MSG_ITEM_UPDATED_NO_SRC"], itemIcon, itemLink, source));
		end
		tbl.wasUpdated = false
	end
	
	tbl.RollHistory();
	
	if tbl.Settings["mode"] == L["DEBUG"] and source ~= L["AUCTION_HOUSE"] then
		if tbl.Creatures[tbl.itemSourceCreatureID] then print(tbl.Creatures[tbl.itemSourceCreatureID].unitName) else print(nil) end
		if tbl.encounterID then print(tbl.Encounters[tbl.encounterID]) else print(nil) end
		if tbl.Quests[tbl.questID] then print(tbl.Quests[tbl.questID].questTitle) else print(nil) end
		if tbl.target then print(tbl.target) else print(nil) end
	end
end
-- Synopsis: Responsible for updating attributes about items (such as the date they were seen) already in the items table.

tbl.AddItem = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, action)
	if itemRarity < tbl.Settings["rarity"] then return end
	if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then -- The item is whitelisted so don't check the blacklists.
	else
		local isItemOrItemTypeIgnored = tbl.IsItemOrItemTypeIgnored(itemID, itemType, itemSubType, itemEquipLoc)
		if isItemOrItemTypeIgnored then return end
	end
	
	local itemSourceCreatureID = tbl.itemsToSource[itemID]
	
	if action == "Update" then
		tbl.Update(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)
	else
		tbl.New(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)
	end
end
-- Synopsis: A staging ground for items before they're passed on to the functions responsible for adding them or updating them. Helps weed out the unwanteds.