local addon, addonTbl = ...;
local L = addonTbl.L;
local select = select;
local sourceIsKnown;

-- Common API calls
local GetPlayerMapPosition = C_Map.GetPlayerMapPosition;
local GetBestMapForUnit = C_Map.GetBestMapForUnit;

addonTbl.New = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)

	if not source or not itemID then return end; if LastSeenItemsDB[itemID] then return end;

	LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, itemSubType = itemSubType, itemEquipLoc = itemEquipLoc, itemIcon = itemIcon, lootDate = currentDate, source = source, 
	location = currentMap, sourceIDs = {}};
	
	if addonTbl.Contains(LastSeenHistoryDB, nil, "itemLink", itemLink) ~= true then
		table.insert(LastSeenHistoryDB, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	LastSeenLootTemplate[itemID] = {[source] = 1};
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	if sourceID then
		LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = L["DATE"];
	end
	
	if sourceID then
		if itemType == "Armor" or itemType == "Weapon" then
			local isAppearanceKnown = C_TransmogCollection.GetSourceInfo(sourceID).isCollected;
			if isAppearanceKnown then
				print(L["ADDON_NAME"] .. "Added " .. "|TInterface\\Addons\\LastSeen\\assets\\known:0|t |T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source);
			else
				print(L["ADDON_NAME"] .. "Added " .. "|TInterface\\Addons\\LastSeen\\assets\\unknown:0|t |T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source);
			end
		end
	else
		print(L["ADDON_NAME"] .. "Added " .. "|T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source);
	end
	
	addonTbl.RollHistory();
	
	if addonTbl.mode == L["DEBUG_MODE"] and source ~= L["AUCTION_HOUSE"] then
		if LastSeenCreaturesDB[addonTbl.itemSourceCreatureID] then print(LastSeenCreaturesDB[addonTbl.itemSourceCreatureID].unitName) else print(nil) end;
		if addonTbl.encounterID then print(LastSeenEncountersDB[addonTbl.encounterID]) else print(nil) end;
		if LastSeenQuestsDB[addonTbl.questID] then print(LastSeenQuestsDB[addonTbl.questID].questTitle) else print(nil) end;
		if addonTbl.target then print(addonTbl.target) else print(nil) end;
	end
end

addonTbl.Update = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source)
	if not source or not itemID then return end; -- For some reason auctions are calling this...
	
	local isSourceKnown;

	for v in pairs(LastSeenItemsDB[itemID]) do
		if v == "lootDate" then if LastSeenItemsDB[itemID][v] ~= currentDate then LastSeenItemsDB[itemID][v] = currentDate; addonTbl.wasUpdated = true; end; end
		if v == "location" then if LastSeenItemsDB[itemID][v] ~= currentMap then LastSeenItemsDB[itemID][v] = currentMap; addonTbl.wasUpdated = true; end; end
		if v == "source" then if LastSeenItemsDB[itemID][v] ~= source then LastSeenItemsDB[itemID][v] = source; addonTbl.wasUpdated = true; end; end
	end
	
	if LastSeenItemsDB[itemID]["itemIcon"] == nil then LastSeenItemsDB[itemID]["itemIcon"] = itemIcon end;
	if LastSeenItemsDB[itemID]["itemSubType"] == nil then LastSeenItemsDB[itemID]["itemSubType"] = itemSubType end;
	if LastSeenItemsDB[itemID]["itemEquipLoc"] == nil then LastSeenItemsDB[itemID]["itemEquipLoc"] = itemEquipLoc end;
	
	if addonTbl.Contains(LastSeenHistoryDB, nil, "itemLink", itemLink) ~= true then
		table.insert(LastSeenHistoryDB, 1, {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap});
	end
	
	if LastSeenLootTemplate[itemID] then -- The item has been added to the loot template database at some point in the past.
		for k, v in next, LastSeenLootTemplate[itemID] do
			if (k == source) then -- An existing source was discovered; therefore we should increment that source.
				v = v + 1; LastSeenLootTemplate[itemID][k] = v;
				sourceIsKnown = true;
			else
				sourceIsKnown = false;
			end
		end
		
		if not sourceIsKnown then
			LastSeenLootTemplate[itemID][source] = 1;
			sourceIsKnown = ""; -- Set this boolean equal to a blank string. 
		end
	else -- The item exists in the item template database, but hasn't been inserted into the loot template database yet.
		LastSeenLootTemplate[itemID] = {[source] = 1};
	end
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	local sourceTblSize = table.getn(LastSeenItemsDB[itemID]["sourceIDs"]);
	if sourceID then
		if (sourceTblSize < 1) then
			LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = currentDate;
		else
			for k, v in pairs(LastSeenItemsDB[itemID]["sourceIDs"]) do
				if (k == sourceID) then
					if (v ~= currentDate) then
						v = currentDate;
					end
				end
			end
		end
	end
	
	if addonTbl.wasUpdated then
		if sourceID then
			if itemType == "Armor" or itemType == "Weapon" then
				local isAppearanceKnown = C_TransmogCollection.GetSourceInfo(sourceID).isCollected;
				if isAppearanceKnown then
					print(L["ADDON_NAME"] .. "Updated " .. "|TInterface\\Addons\\LastSeen\\assets\\known:0|t |T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source);
				else
					print(L["ADDON_NAME"] .. "Updated " .. "|TInterface\\Addons\\LastSeen\\assets\\unknown:0|t |T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source);
				end
			end
		else
			print(L["ADDON_NAME"] .. "Updated " .. "|T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source);
		end
		addonTbl.wasUpdated = false;
	end
	
	addonTbl.RollHistory();
	
	if addonTbl.mode == L["DEBUG_MODE"] and source ~= L["AUCTION_HOUSE"] then
		if LastSeenCreaturesDB[addonTbl.itemSourceCreatureID] then print(LastSeenCreaturesDB[addonTbl.itemSourceCreatureID].unitName) else print(nil) end;
		if addonTbl.encounterID then print(LastSeenEncountersDB[addonTbl.encounterID]) else print(nil) end;
		if LastSeenQuestsDB[addonTbl.questID] then print(LastSeenQuestsDB[addonTbl.questID].questTitle) else print(nil) end;
		if addonTbl.target then print(addonTbl.target) else print(nil) end;
	end
end

local function GetItemIDFromItemLink(itemLink)
	local itemID = select(1, GetItemInfoInstant(itemLink));

	return itemID;
end

local function GetItemNameFromItemID(itemID)
	local itemName = select(1, GetItemInfo(itemID));

	return itemName;
end

local function GetItemRarityFromItemID(itemID)
	local itemRarity = select(3, GetItemInfo(itemID));

	return itemRarity;
end

local function GetItemTypeFromItemID(itemID)
	local itemType = select(6, GetItemInfo(itemID));

	return itemType;
end

addonTbl.AddItem = function(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source, action)

	if addonTbl.Contains(addonTbl.ignoredItemTypes, nil, "itemType", itemType) then return end;
	if addonTbl.Contains(addonTbl.ignoredItemTypes, nil, "itemType", itemSubType) then return end;
	if addonTbl.Contains(addonTbl.ignoredItemTypes, nil, "itemType", itemEquipLoc) then return end;
	
	local itemSourceCreatureID = addonTbl.itemsToSource[itemID];
	
	if action == "Update" then
		addonTbl.Update(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source);
	else
		addonTbl.New(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, currentDate, currentMap, sourceType, source);
	end
end