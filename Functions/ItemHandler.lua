--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all item-related functions.
]]--

local lastSeen, LastSeenTbl = ...;
local L = LastSeenTbl.L;
local select = select;
local sourceIsKnown;

-- Common API calls
local GetPlayerMapPosition = C_Map.GetPlayerMapPosition;
local GetBestMapForUnit = C_Map.GetBestMapForUnit;

LastSeenTbl.New = function(itemID, itemName, itemLink, itemRarity, itemType, currentDate, source, currentMap, key)
	local isInInstance = IsInInstance();

	if isInInstance then
		local _, _, _, difficultyName = GetInstanceInfo();
		currentMap = currentMap .. " (" .. difficultyName .. ")";
		
		if LastSeenTbl.encounterName ~= nil then
			if LastSeenTbl.encounterName ~= "" then
				source = LastSeenTbl.encounterName;
			end
		end
	end

	LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = currentDate, source = source, 
	location = currentMap, key = key, sourceIDs = {}};
	
	LastSeenLootTemplate[itemID] = {[source] = 1};
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	if sourceID then
		LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = L["DATE"];
	end
	
	if LastSeenTbl["mode"] ~= L["QUIET_MODE"] then
		if LastSeenTbl.mode == L["VERBOSE_MODE"] then
			print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ". (" .. LastSeenTbl.GetItemsSeen(LastSeenItemsDB) .. ")");
		else
			print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ".");
		end
	end
end

LastSeenTbl.Update = function(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, lootDate, source, location, key)
	if not source then return end; -- For some reason auctions are calling this...
	
	local isInInstance = IsInInstance();
	local isSourceKnown;

	if isInInstance then
		local _, _, _, difficultyName = GetInstanceInfo();
		location = location .. " (" .. difficultyName .. ")";
	end

	if LastSeenItemsDB[itemID].manualEntry == true then -- A manually entered item has been seen!
		LastSeenItemsDB[itemID].itemName = itemName;
		LastSeenItemsDB[itemID].itemLink = itemLink;
		LastSeenItemsDB[itemID].itemType = itemType;
		LastSeenItemsDB[itemID].itemRarity = itemRarity;
		LastSeenItemsDB[itemID].lootDate = lootDate;
		LastSeenItemsDB[itemID].source = source;
		LastSeenItemsDB[itemID].location = location;
		LastSeenItemsDB[itemID].key = key;
		LastSeenItemsDB[itemID].manualEntry = nil; -- Remove the manual entry flag.
		LastSeenTbl.wasUpdated = true;
	else
		for v in pairs(LastSeenItemsDB[itemID]) do
			if v == "lootDate" then if LastSeenItemsDB[itemID][v] ~= lootDate then LastSeenItemsDB[itemID][v] = lootDate; LastSeenTbl.wasUpdated = true; end; end
			if v == "location" then if LastSeenItemsDB[itemID][v] ~= location then LastSeenItemsDB[itemID][v] = location; LastSeenTbl.wasUpdated = true; end; end
			if v == "source" then if LastSeenItemsDB[itemID][v] ~= source then LastSeenItemsDB[itemID][v] = source; LastSeenTbl.wasUpdated = true; end; end
			if v == "key" then if LastSeenItemsDB[itemID][v] ~= key then LastSeenItemsDB[itemID][v] = key; LastSeenTbl.wasUpdated = true; end; end
		end
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
			LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = lootDate;
		else
			for k, v in pairs(LastSeenItemsDB[itemID]["sourceIDs"]) do
				if (k == sourceID) then
					if (v ~= lootDate) then
						v = lootDate;
					end
				end
			end
		end
	end
	
	if LastSeenTbl.wasUpdated and LastSeenTbl.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["UPDATED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ".");
		LastSeenTbl.wasUpdated = false;
	end
end

local function GetCoords()
	if not (IsInInstance()) then
		local uiMapID = GetBestMapForUnit("player");
		local position = GetPlayerMapPosition(uiMapID, "player");
		local x, y = position:GetXY(); x = LastSeenTbl.Round(x, 2); y = LastSeenTbl.Round(y, 2);
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

local function PlayerLootedContainer(itemLink, currentDate, currentMap)
	local itemID = GetItemIDFromItemLink(itemLink);
	if not itemID then return end;

	local itemName = GetItemNameFromItemID(itemID); -- This is the name of the item container, not the loot.
	local itemRarity = GetItemRarityFromItemID(itemID);
	local itemType = GetItemTypeFromItemID(itemID);

	if itemRarity >= LastSeenSettingsCacheDB.rarity or LastSeenItemsDB[itemID] and LastSeenItemsDB[itemID]["manualEntry"] then
		for k, v in pairs(LastSeenTbl.ignoredItemTypes) do
			if itemType == v and not LastSeenTbl.doNotIgnore then
				return;
			end
		end
		for k, v in pairs(LastSeenTbl.ignoredItems) do
			if itemID == k and not LastSeenTbl.doNotIgnore then
				return;
			end
		end
		if LastSeenIgnoredItemsDB[itemID] and LastSeenTbl.doNotIgnore then
			return;
		end

		if LastSeenItemsDB[itemID] then
			LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, LastSeenTbl.lootedItem, currentMap, LastSeenTbl.GenerateItemKey(itemID));
		else
			LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, LastSeenTbl.lootedItem, currentMap, LastSeenTbl.GenerateItemKey(itemID));
		end
	end
end

local function PlayerBoughtAuction(itemLink, currentDate, currentMap)
	local itemID = GetItemIDFromItemLink(itemLink);
	if not itemID then return end;

	local itemName = GetItemNameFromItemID(itemID); -- This is the name of the item container, not the loot.
	local itemRarity = GetItemRarityFromItemID(itemID);
	local itemType = GetItemTypeFromItemID(itemID);

	if itemRarity >= LastSeenSettingsCacheDB.rarity or LastSeenItemsDB[itemID] and LastSeenItemsDB[itemID]["manualEntry"] then
		for k, v in pairs(LastSeenTbl.ignoredItemTypes) do
			if itemType == v and not LastSeenTbl.doNotIgnore then
				return;
			end
		end
		for k, v in pairs(LastSeenTbl.ignoredItems) do
			if itemID == k and not LastSeenTbl.doNotIgnore then
				return;
			end
		end
		if LastSeenIgnoredItemsDB[itemID] and LastSeenTbl.doNotIgnore then
			return;
		end

		if LastSeenItemsDB[itemID] then
			LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, L["AUCTION_HOUSE_SOURCE"], currentMap, LastSeenTbl.GenerateItemKey(itemID));
		else
			LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, L["AUCTION_HOUSE_SOURCE"], currentMap, LastSeenTbl.GenerateItemKey(itemID));
		end
	end
end

LastSeenTbl.GenerateItemKey = function(itemID)
	return itemID .. LastSeenAccountKey .. string.byte(itemID);
end

LastSeenTbl.AddItem = function(itemID, itemLink, itemName, itemRarity, itemType, currentDate, currentMap, source, key)
	
	if LastSeenTbl.doNotUpdate then 
		LastSeenTbl.doNotUpdate = false;
	end
	
	if LastSeenTbl.doNotUpdate then
		return;
	end
	
	local itemSourceCreatureID = LastSeenTbl.itemsToSource[itemID];
	
	if itemRarity >= LastSeenSettingsCacheDB.rarity then
		for k, v in pairs(LastSeenTbl.ignoredItemTypes) do
			if itemType == v and not LastSeenTbl.doNotIgnore then
				return;
			end
		end
		for k, v in pairs(LastSeenTbl.ignoredItems) do
			if itemID == k and not LastSeenTbl.doNotIgnore then
				return;
			end
		end
		if LastSeenIgnoredItemsDB[itemID] and LastSeenTbl.doNotIgnore then
			return;
		end
		
		if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
			LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, source, currentMap, key)
			--[[if LastSeenCreaturesDB[itemSourceCreatureID] ~= nil then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif containerItem ~= "" then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif LastSeenTbl.encounterName ~= "" then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenTbl.encounterName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif LastSeenTbl.target ~= "" then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenTbl.target, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif containerItem ~= "" then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			else
				print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"] .. " (" .. L["RELEASE"] .. ")");
			end]]--
		else -- An item seen for the first time.
			LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, source, currentMap, key)
			--[[if LastSeenCreaturesDB[itemSourceCreatureID] ~= nil then
				LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif containerItem ~= "" then
				LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif LastSeenTbl.encounterName ~= "" then
				LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenTbl.encounterName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif LastSeenTbl.target ~= "" then
				LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenTbl.target, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif containerItem ~= "" then
				LastSeenTbl.New(itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			else
				print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"] .. " (" .. L["RELEASE"] .. ")");
			end]]--
		end
	elseif LastSeenTbl.TableHasField(LastSeenItemsDB, itemID, "manualEntry") then
		if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
			if LastSeenCreaturesDB[itemSourceCreatureID] ~= nil then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif containerItem ~= "" then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif LastSeenTbl.encounterName ~= "" then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenTbl.encounterName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif LastSeenTbl.target ~= "" then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], LastSeenTbl.target, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif containerItem ~= "" then
				LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			else
				print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"] .. " (" .. L["RELEASE"] .. ")");
			end
		else -- An item seen for the first time.
			if LastSeenCreaturesDB[itemSourceCreatureID] ~= nil then
				LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenCreaturesDB[itemSourceCreatureID].unitName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif containerItem ~= "" then
				LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif LastSeenTbl.encounterName ~= "" then
				LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenTbl.encounterName, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif LastSeenTbl.target ~= "" then
				LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, L["DATE"], LastSeenTbl.target, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			elseif containerItem ~= "" then
				LastSeenTbl.New(itemID, itemName, itemLink, itemType, itemRarity, L["DATE"], containerItem, LastSeenTbl.currentMap, LastSeenTbl.GenerateItemKey(itemID));
			else
				print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"] .. " (" .. L["RELEASE"] .. ")");
			end
		end
	end
end