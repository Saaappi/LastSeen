--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all item-related functions.
]]--

local lastSeen, LastSeenTbl = ...;
local L = LastSeenTbl.L;
local select = select;

-- Common API calls
local GetPlayerMapPosition = C_Map.GetPlayerMapPosition;
local GetBestMapForUnit = C_Map.GetBestMapForUnit;

LastSeenTbl.New = function(itemID, itemName, itemLink, itemRarity, itemType, today, source, currentMap, key)
	local isInInstance = IsInInstance();

	if isInInstance then
		local _, _, _, difficultyName = GetInstanceInfo();
		currentMap = currentMap .. " (" .. difficultyName .. ")";
	end
	
	if LastSeenTbl.encounterName ~= nil then
		if LastSeenTbl.encounterName ~= "" then
			source = LastSeenTbl.encounterName;
		end
	end

	LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = source, 
	location = currentMap, key = key, sourceIDs = {}};
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	if sourceID then
		local sourceTblSize = (#LastSeenItemsDB[itemID]["sourceIDs"]);
		LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = lootDate;
		--table.insert(LastSeenItemsDB[itemID]["sourceIDs"], sourceID, lootDate);
	end
	
	if LastSeenTbl.mode ~= L["QUIET_MODE"] then
		if LastSeenTbl.mode == L["VERBOSE_MODE"] then
			print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ". (" .. LastSeenTbl.GetItemsSeen(LastSeenItemsDB) .. ")");
		else
			print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ".");
		end
	end
	return;
end

LastSeenTbl.Update = function(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, lootDate, source, location, key)
	local isInInstance = IsInInstance();
	local isSourceKnown;

	if isInInstance then
		local _, _, _, difficultyName = GetInstanceInfo();
		location = location .. " (" .. difficultyName .. ")";
	end
	
	if LastSeenTbl.encounterName ~= nil then
		if LastSeenTbl.encounterName ~= "" then
			source = LastSeenTbl.encounterName;
		end
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
	
	local _, sourceID = C_TransmogCollection.GetItemInfo(itemID);
	local sourceTblSize = table.getn(LastSeenItemsDB[itemID]["sourceIDs"]);
	if sourceID then
		if (sourceTblSize < 1) then
			table.insert(LastSeenItemsDB[itemID]["sourceIDs"], sourceID, lootDate);
		else
			for k, v in pairs(LastSeenItemsDB[itemID]["sourceIDs"]) do
				if (k == sourceID) then
					if (v ~= lootDate) then
						LastSeenItemsDB[itemID]["sourceIDs"][sourceID] = lootDate;
					end
				end
			end
		end
	end
	
	if LastSeenTbl.wasUpdated and LastSeenTbl.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["UPDATED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ".");
		LastSeenTbl.wasUpdated = false;
	end
	return;
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

local function PlayerLootedContainer(itemLink, currentDate, currentMap, sourceID)
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

local function PlayerLootedObject(itemLink, currentDate, currentMap, sourceID)
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
			LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, L["OBJECT"] .. LastSeenTbl.target, currentMap .. GetCoords(), LastSeenTbl.GenerateItemKey(itemID));
		else
			LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, L["OBJECT"] .. LastSeenTbl.target, currentMap .. GetCoords(), LastSeenTbl.GenerateItemKey(itemID));
		end
	end
end

local function PlayerBoughtAuction(itemLink, currentDate, currentMap, sourceID)
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

LastSeenTbl.LootDetected = function(constant, currentDate, currentMap, itemSource, questID)
	if not constant then return end; -- If the passed constant is nil, then simply return to avoid error.
	
	if LastSeenTbl.doNotUpdate then 
		LastSeenTbl.doNotUpdate = false;
	end

	questID = questID or 0; -- The questID argument is an optional argument.

	local link = LastSeenTbl.ExtractItemLink(constant); if not link then return end;
	
	if select(1, GetItemInfoInstant(link)) == 0 then return end; -- This is here for items like pet cages.
	
	-- The item passed isn't a looted item, but a received item from something else.
	-- Let's figure out what that source is.
	if itemSource == L["IS_QUEST_ITEM"] and questID ~= 0 then -- Quest Item
		-- The item received was a quest reward and shouldn't be handled by the ItemHandler.
		LastSeenTbl.QuestChoices(questID, link, currentDate);
		return;
	elseif itemSource == L["IS_MISCELLANEOUS"] or itemSource == L["IS_CONSUMABLE"] then -- An item looted from a container like the [Oozing Bag].
		PlayerLootedContainer(link, currentDate, currentMap, sourceID);
	elseif itemSource == L["IS_OBJECT"] then
		PlayerLootedObject(link, currentDate, currentMap, sourceID);
	elseif itemSource == L["AUCTION_HOUSE_SOURCE"] then
		PlayerBoughtAuction(link, currentDate, currentMap, sourceID);
	else
		link = LastSeenTbl.ExtractItemLink(constant); -- Just an item looted from a creature. Simple; classic.
	end

	if not LastSeenTbl.lootControl then -- Track items when they're looted.
		local itemID = select(1, GetItemInfoInstant(link)); if not itemID then return end;
		local itemLink = select(2, GetItemInfo(itemID));
		local itemName = select(1, GetItemInfo(itemID));
		local itemRarity = select(3, GetItemInfo(itemID));
		local itemType = select(6, GetItemInfo(itemID));
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
				if itemSourceCreatureID ~= nil then
					LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap, LastSeenTbl.GenerateItemKey(itemID));
				elseif LastSeenTbl.encounterName ~= "" then
					LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, LastSeenTbl.encounterName, currentMap, LastSeenTbl.GenerateItemKey(itemID));
				end
			else -- An item seen for the first time.
				if itemSourceCreatureID ~= nil then
					if LastSeenCreaturesDB[itemSourceCreatureID] and not LastSeenTbl.isMailboxOpen then
						if not LastSeenTbl.isAutoLootPlusLoaded then
							LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap, LastSeenTbl.GenerateItemKey(itemID));
						end
					else
						print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"]);
					end
				elseif LastSeenTbl.encounterName ~= "" then
					LastSeenTbl.New(itemID, itemName, itemLink, itemType, itemRarity, currentDate, LastSeenTbl.encounterName, currentMap, LastSeenTbl.GenerateItemKey(itemID));
				end
			end
		elseif LastSeenTbl.TableHasField(LastSeenItemsDB, itemID, "manualEntry") then
			if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
				if itemSourceCreatureID ~= nil then
					LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap, LastSeenTbl.GenerateItemKey(itemID));
				elseif LastSeenTbl.encounterName ~= "" then
					LastSeenTbl.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, LastSeenTbl.encounterName, currentMap, LastSeenTbl.GenerateItemKey(itemID));
				end
			else -- An item seen for the first time.
				if itemSourceCreatureID ~= nil then
					if LastSeenCreaturesDB[itemSourceCreatureID] and not LastSeenTbl.isMailboxOpen then
						if not LastSeenTbl.isAutoLootPlusLoaded then
							LastSeenTbl.New(itemID, itemName, itemLink, itemRarity, itemType, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap, LastSeenTbl.GenerateItemKey(itemID));
						end
					elseif LastSeenTbl.encounterName ~= "" then
						LastSeenTbl.New(itemID, itemName, itemLink, itemType, itemRarity, currentDate, LastSeenTbl.encounterName, currentMap, LastSeenTbl.GenerateItemKey(itemID));
					else
						print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. itemLink .. ". " .. L["DISCORD_REPORT"]);
					end
				end
			end
		end
	end
end
