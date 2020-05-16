local addon, addonTbl = ...;
local L = addonTbl.L;
local select = select;
local sourceIsKnown;

-- Common API calls
local GetPlayerMapPosition = C_Map.GetPlayerMapPosition;
local GetBestMapForUnit = C_Map.GetBestMapForUnit;

addonTbl.New = function(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, currentDate, currentMap, sourceType, source)

	if not source or not itemID then return end;

	LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, itemIcon = itemIcon, lootDate = currentDate, source = source, 
	location = currentMap, sourceIDs = {}};
	
	LastSeenHistoryDB[#LastSeenHistoryDB + 1] = {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap};
	
	LastSeenLootTemplate[itemID] = {[source] = 1};
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	if sourceID then
		LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = L["DATE"];
	end
	
	print(L["ADDON_NAME"] .. "Added " .. "|T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source .. ".");
end

addonTbl.Update = function(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, currentDate, currentMap, sourceType, source)
	if not source or not itemID then return end; -- For some reason auctions are calling this...
	
	local isSourceKnown;

	for v in pairs(LastSeenItemsDB[itemID]) do
		if v == "lootDate" then if LastSeenItemsDB[itemID][v] ~= currentDate then LastSeenItemsDB[itemID][v] = currentDate; addonTbl.wasUpdated = true; end; end
		if v == "location" then if LastSeenItemsDB[itemID][v] ~= currentMap then LastSeenItemsDB[itemID][v] = currentMap; addonTbl.wasUpdated = true; end; end
		if v == "source" then if LastSeenItemsDB[itemID][v] ~= source then LastSeenItemsDB[itemID][v] = source; addonTbl.wasUpdated = true; end; end
	end
	
	if not LastSeenItemsDB[itemID]["itemIcon"] then
		LastSeenItemsDB[itemID]["itemIcon"] = itemIcon;
	end
	
	LastSeenHistoryDB[#LastSeenHistoryDB + 1] = {itemLink = itemLink, itemIcon = itemIcon, lootDate = currentDate, source = source, location = currentMap};
	
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
		print(L["ADDON_NAME"] .. "Updated " .. "|T" .. itemIcon .. ":0|t " .. itemLink .. " - " .. source .. ".");
		addonTbl.wasUpdated = false;
	end
end

local function GetCoords()
	if not (IsInInstance()) then
		local uiMapID = GetBestMapForUnit("player");
		local position = GetPlayerMapPosition(uiMapID, "player");
		local x, y = position:GetXY(); x = addonTbl.Round(x, 2); y = addonTbl.Round(y, 2);
		local coords = x .. ", " .. y;
		
		return " (" .. coords .. ")";
	else
		return "";
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

addonTbl.AddItem = function(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, currentDate, currentMap, sourceType, source, action)
	
	if sourceType == "" then
		print(L["ADDON_NAME"] .. itemLink .. " was looted from an unknown source."); return;
	end
	
	-- REVIEW --
	if addonTbl.doNotUpdate then 
		addonTbl.doNotUpdate = false;
	end
	
	if addonTbl.doNotUpdate then
		return;
	end
	-- END REVIEW --
	
	local itemSourceCreatureID = addonTbl.itemsToSource[itemID];
	
	if action == "Update" then
		addonTbl.Update(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, currentDate, currentMap, sourceType, source);
	else
		addonTbl.New(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, currentDate, currentMap, sourceType, source);
	end
end