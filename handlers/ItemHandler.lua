-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local itemString
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

	if not source or not itemID then return end if LastSeenItemsDB[itemID] then return end

	LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, itemSubType = itemSubType, itemEquipLoc = itemEquipLoc, itemIcon = itemIcon, lootDate = currentDate, source = source, 
	location = currentMap, sourceIDs = {}};
	
	if tbl.Contains(LastSeenHistoryDB, nil, "itemLink", itemLink) ~= true then
		table.insert(LastSeenHistoryDB, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	LastSeenLootTemplate[itemID] = {[source] = 1};
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemString);
	if sourceID then
		LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = L["DATE"];
	end
	
	if sourceID and tbl.Settings["mode"] ~= GM_SURVEY_NOT_APPLICABLE then
		if itemType == "Armor" or itemType == "Weapon" then
			local isAppearanceKnown = C_TransmogCollection.GetSourceInfo(sourceID).isCollected
			if isAppearanceKnown then
				print(string.format(L["INFO_MSG_ITEM_ADDED_SRC_KNOWN"], itemIcon, itemLink, source));
			else
				print(string.format(L["INFO_MSG_ITEM_ADDED_SRC_UNKNOWN"], itemIcon, itemLink, source));
			end
		end
	elseif tbl.Settings["mode"] ~= GM_SURVEY_NOT_APPLICABLE then
		print(string.format(L["INFO_MSG_ITEM_ADDED_NO_SRC"], itemIcon, itemLink, source));
	end
	
	tbl.RollHistory();
	
	if tbl.Settings["mode"] == BINDING_HEADER_DEBUG and source ~= L["AUCTION_HOUSE"] then
		if LastSeenCreaturesDB[tbl.itemSourceCreatureID] then print(LastSeenCreaturesDB[tbl.itemSourceCreatureID].unitName) else print(nil) end
		if tbl.encounterID then print(LastSeenEncountersDB[tbl.encounterID]) else print(nil) end
		if LastSeenQuestsDB[tbl.questID] then print(LastSeenQuestsDB[tbl.questID].questTitle) else print(nil) end
		if tbl.target then print(tbl.target) else print(nil) end
	end
end
-- Synopsis: Responsible for adding a NEW (not seen before this moment) item to the items table.

tbl.Update = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)
	if not source or not itemID then return end -- For some reason auctions are calling this...
	
	local isSourceKnown

	for v in pairs(LastSeenItemsDB[itemID]) do
		if v == "lootDate" then if LastSeenItemsDB[itemID][v] ~= currentDate then LastSeenItemsDB[itemID][v] = currentDate tbl.wasUpdated = true end end
		if v == "location" then if LastSeenItemsDB[itemID][v] ~= currentMap then LastSeenItemsDB[itemID][v] = currentMap tbl.wasUpdated = true end end
		if v == "source" then if LastSeenItemsDB[itemID][v] ~= source then LastSeenItemsDB[itemID][v] = source tbl.wasUpdated = true end end
	end
	
	if LastSeenItemsDB[itemID]["itemIcon"] == nil then LastSeenItemsDB[itemID]["itemIcon"] = itemIcon end
	if LastSeenItemsDB[itemID]["itemSubType"] == nil then LastSeenItemsDB[itemID]["itemSubType"] = itemSubType end
	if LastSeenItemsDB[itemID]["itemEquipLoc"] == nil then LastSeenItemsDB[itemID]["itemEquipLoc"] = itemEquipLoc end
	
	if tbl.Contains(LastSeenHistoryDB, nil, "itemLink", itemLink) ~= true then
		table.insert(LastSeenHistoryDB, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	if LastSeenLootTemplate[itemID] then -- The item has been added to the loot template database at some point in the past.
		for k, v in next, LastSeenLootTemplate[itemID] do
			if (k == source) then -- An existing source was discovered therefore we should increment that source.
				v = v + 1 LastSeenLootTemplate[itemID][k] = v
				sourceIsKnown = true
			else
				sourceIsKnown = false
			end
		end
		
		if not sourceIsKnown then
			LastSeenLootTemplate[itemID][source] = 1
			sourceIsKnown = ""; -- Set this boolean equal to a blank string. 
		end
	else -- The item exists in the item template database, but hasn't been inserted into the loot template database yet.
		LastSeenLootTemplate[itemID] = {[source] = 1};
	end
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemString);
	local sourceTblSize = table.getn(LastSeenItemsDB[itemID]["sourceIDs"]);
	if sourceID then
		if (sourceTblSize < 1) then
			LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = currentDate
		else
			for k, v in pairs(LastSeenItemsDB[itemID]["sourceIDs"]) do
				if (k == sourceID) then
					if (v ~= currentDate) then
						v = currentDate
					end
				end
			end
		end
	end
	
	if tbl.wasUpdated and tbl.Settings["mode"] ~= GM_SURVEY_NOT_APPLICABLE then
		if sourceID then
			if itemType == "Armor" or itemType == "Weapon" then
				local isAppearanceKnown = C_TransmogCollection.GetSourceInfo(sourceID).isCollected
				if isAppearanceKnown then
					print(string.format(L["INFO_MSG_ITEM_UPDATED_SRC_KNOWN"], itemIcon, itemLink, source));
				else
					print(string.format(L["INFO_MSG_ITEM_UPDATED_SRC_UNKNOWN"], itemIcon, itemLink, source));
				end
			end
		elseif tbl.Settings["mode"] ~= GM_SURVEY_NOT_APPLICABLE then
			print(string.format(L["INFO_MSG_ITEM_UPDATED_NO_SRC"], itemIcon, itemLink, source));
		end
		tbl.wasUpdated = false
	end
	
	tbl.RollHistory();
	
	if tbl.Settings["mode"] == BINDING_HEADER_DEBUG and source ~= L["AUCTION_HOUSE"] then
		if LastSeenCreaturesDB[tbl.itemSourceCreatureID] then print(LastSeenCreaturesDB[tbl.itemSourceCreatureID].unitName) else print(nil) end
		if tbl.encounterID then print(LastSeenEncountersDB[tbl.encounterID]) else print(nil) end
		if LastSeenQuestsDB[tbl.questID] then print(LastSeenQuestsDB[tbl.questID].questTitle) else print(nil) end
		if tbl.target then print(tbl.target) else print(nil) end
	end
end
-- Synopsis: Responsible for updating attributes about items (such as the date they were seen) already in the items table.

tbl.AddItem = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, action)
	if itemRarity < tbl.Settings["rarity"] then return end
	if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then -- The item is whitelisted so don't check the blacklists.
	else
		isItemOrItemTypeIgnored = tbl.IsItemOrItemTypeIgnored(itemID, itemType, itemSubType, itemEquipLoc);
		if isItemOrItemTypeIgnored then return end;
	end
	
	local itemSourceCreatureID = tbl.itemsToSource[itemID];
	itemString = string.match(itemLink, "item[%-?%d:]+");
	
	if action == "Update" then
		tbl.Update(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source);
	else
		tbl.New(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source);
	end
end
-- Synopsis: A staging ground for items before they're passed on to the functions responsible for adding them or updating them. Helps weed out the unwanteds.