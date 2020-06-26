local addon, addonTbl = ...;

local L = addonTbl.L; -- Create a local reference to the global localization table.
local itemDBRef;

addonTbl.GetCount = function(tbl, itemID)
	local count = 0;
	if not itemID then itemID = 0 end; -- The itemID parameter is optional. If not passed, assign it a 0.
	if itemID == 0 then -- Counting the number of records within an entire table.
		for _ in pairs(tbl) do count = count + 1 end;
		return count;
	else -- Counting the number of times an individual item has been seen.
		if tbl[itemID] then
			for creature in pairs(tbl[itemID]) do
				count = count + tbl[itemID][creature];
			end
		end
		return count; 
	end
end
-- Synopsis: Used to count records in a table or how many times an item has been seen by the player.

addonTbl.DataIsValid = function(itemID)
	if itemID == nil then
		return false;
	end

	itemDBRef = LastSeenItemsDB[itemID]
	if itemDBRef == nil then
		return false;
	end

	if itemDBRef["location"] and itemDBRef["lootDate"] and itemDBRef["source"] then
		return true;
	else
		return false;
	end
end
--[[
	Synopsis: Checks the location, lootDate, and source for a non-nil value.
	Written by: Arcanemagus
]]

addonTbl.ExtractItemLink = function(constant)
	local extractedLink, itemID, itemLink;
	
	if string.find(constant, L["LOOT_ITEM_PUSHED_SELF"]) then
		extractedLink = string.match(constant, L["LOOT_ITEM_PUSHED_SELF"] .. "(.*).");
		itemID = GetItemInfoInstant(extractedLink);
	elseif string.find(constant, L["LOOT_ITEM_SELF"]) then
		extractedLink = string.match(constant, L["LOOT_ITEM_SELF"] .. "(.*).");
		itemID = GetItemInfoInstant(extractedLink);
	end
	
	if itemID then
		itemLink = select(2, GetItemInfo(itemID));
	end
	
	if itemLink then return itemLink end;
end
-- Synopsis: Whenever an item is looted, its link is at the end of a constant like "You received loot". This function
-- extracts the link and discards the fluff.

addonTbl.GetTableKeyFromValue = function(tbl, query)
	for k, v in pairs(tbl) do
		if v == query then
			return k;
		end
	end
	return false;
end
-- Synopsis: Gets a key in a table from the value, a reverse lookup.

addonTbl.Contains = function(tab, key, sub_key, value)
	for index, sub_tab in pairs(tab) do
		if key then -- The passed table doesn't use numeric indices.
			if sub_key ~= nil then
				if value then
					if tab[key][sub_key] == value then return true end;
				else
					return tab[key][sub_key] ~= nil;
				end
			else
				return tab[key] ~= nil;
			end
		else -- This table uses numeric indices.
			if tab[index][sub_key] == value then return true end;
		end
	end
	return false;
end
--[[
	Synopsis: Allows the caller to look for a key or a sub key for any passed table.
	Arguments:
		tab: 		This is the table we want to look in.
		key: 		This is the main element in the table.
		sub_key:	This is the element within the main element. It can be a table on its own.
		value:		When a table uses numeric indices, it's likely the user wants to lookup a value associated to a sub_key.
]]

addonTbl.GetTable = function(tbl)
	if tbl == LastSeenHistoryDB then
		for i = #tbl, 1, -1 do
			print("|T" .. tbl[i].itemIcon .. ":0|t " .. tbl[i].itemLink .. " | " .. tbl[i].source .. " | " .. tbl[i].location .. " | " .. tbl[i].lootDate);
		end
	end
end
-- Synopsis: Used to iterate over a table to get its content.

addonTbl.RollHistory = function()
	local historyEntries = addonTbl.GetCount(LastSeenHistoryDB);
	if historyEntries > addonTbl.maxHistoryEntries then
		for i = #LastSeenHistoryDB, 1, -1 do
			if i > addonTbl.maxHistoryEntries then
				table.remove(LastSeenHistoryDB, i);
			end
		end
	end
end
-- Synopsis: Maintains the history table, to always keep it at the maximum number of entries, which is currently 20.

addonTbl.GetItemInfo = function(itemLink, slot)
	local lootSources = { GetLootSourceInfo(slot) };

	if itemLink then
		itemLink = addonTbl.ExtractItemLink(L["LOOT_ITEM_SELF"] .. itemLink); -- The item link isn't formatted correctly from the GetLootSlotLink() function.
		local itemID, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon;
		for j = 1, #lootSources, 2 do
			if itemLink then
				itemName = GetItemInfo(itemLink);
				itemRarity = select(3, GetItemInfo(itemLink));
				itemID, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(itemLink);
				local type, _, _, _, _, creatureID = strsplit("-", lootSources[j]);
				if itemID then -- To catch items without an item ID.
					addonTbl.itemsToSource[itemID] = tonumber(creatureID);
					addonTbl.itemSourceCreatureID = addonTbl.itemsToSource[itemID];
					
					if itemRarity >= addonTbl.rarity then
						if addonTbl.Contains(addonTbl.whitelistedItems, itemID, nil, nil) then
							-- Continue
						elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemType) then return;
						elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemSubType) then return;
						elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemEquipLoc) then return;
						elseif addonTbl.Contains(addonTbl.ignoredItems, itemID, nil, nil) then return end;
						
						if LastSeenItemsDB[itemID] then -- Item seen again.
							if LastSeenCreaturesDB[addonTbl.itemSourceCreatureID] then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Creature", LastSeenCreaturesDB[addonTbl.itemSourceCreatureID].unitName, "Update");
							elseif addonTbl.encounterID then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Encounter", LastSeenEncountersDB[addonTbl.encounterID], "Update");
							elseif addonTbl.target ~= "" then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Object", addonTbl.target, "Update");
							else
								if addonTbl.mode ~= GM_SURVEY_NOT_APPLICABLE then print(L["ADDON_NAME"] .. itemLink .. L["ERROR_MSG_UNKNOWN_SOURCE"]) end;
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Miscellaneous", L["INFO_MSG_MISCELLANEOUS"], "Update");
							end
						else -- Item seen for first time.
							if LastSeenCreaturesDB[addonTbl.itemSourceCreatureID] then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Creature", LastSeenCreaturesDB[addonTbl.itemSourceCreatureID].unitName, "New");
							elseif addonTbl.encounterID then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Encounter", LastSeenEncountersDB[addonTbl.encounterID], "New");
							elseif addonTbl.target ~= "" then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Object", addonTbl.target, "New");
							else
								if addonTbl.mode ~= GM_SURVEY_NOT_APPLICABLE then print(L["ADDON_NAME"] .. itemLink .. L["ERROR_MSG_UNKNOWN_SOURCE"]) end;
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Miscellaneous", L["INFO_MSG_MISCELLANEOUS"], "New");
							end
						end
					end
				end
			end
		end
	end
end
-- Synopsis: Fetches an item's information just before it's looted from the window, and then sends it down the pipeline to addonTbl.AddItem.