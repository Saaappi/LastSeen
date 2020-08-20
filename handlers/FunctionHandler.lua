local addon, tbl = ...;

local L = tbl.L -- Create a local reference to the global localization table.
local itemDBRef

tbl.GetCount = function(tbl, itemID)
	local count = 0
	if not itemID then itemID = 0 end -- The itemID parameter is optional. If not passed, assign it a 0.
	if itemID == 0 then -- Counting the number of records within an entire table.
		for _ in pairs(tbl) do count = count + 1 end
		return count
	else -- Counting the number of times an individual item has been seen.
		if tbl[itemID] then
			for creature in pairs(tbl[itemID]) do
				count = count + tbl[itemID][creature];
			end
		end
		return count 
	end
end
-- Synopsis: Used to count records in a table or how many times an item has been seen by the player.

tbl.DataIsValid = function(itemID)
	if itemID == nil then
		return false
	end

	itemDBRef = tbl.Items[itemID]
	if itemDBRef == nil then
		return false
	end

	if itemDBRef["location"] and itemDBRef["lootDate"] and itemDBRef["source"] then
		return true
	else
		return false
	end
end
--[[
	Synopsis: Checks the location, lootDate, and source for a non-nil value.
	Written by: Arcanemagus
]]

tbl.ExtractItemLink = function(constant)
	local extractedLink, itemID, itemLink
	
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
	
	if itemLink then return itemLink end
end
-- Synopsis: Whenever an item is looted, its link is at the end of a constant like "You received loot". This function
-- extracts the link and discards the fluff.

tbl.GetTableKeyFromValue = function(tbl, query)
	for k, v in pairs(tbl) do
		if v == query then
			return k
		end
	end
	return false
end
-- Synopsis: Gets a key in a table from the value, a reverse lookup.

tbl.Contains = function(tab, key, sub_key, value)
	for index, sub_tab in pairs(tab) do
		if key then -- The passed table doesn't use numeric indices.
			if sub_key ~= nil then
				if value then
					if tab[key][sub_key] == value then return true end
				else
					return tab[key][sub_key] ~= nil
				end
			else
				return tab[key] ~= nil
			end
		else -- This table uses numeric indices.
			if tab[index][sub_key] == value then return true end
		end
	end
	return false
end
--[[
	Synopsis: Allows the caller to look for a key or a sub key for any passed table.
	Arguments:
		tab: 		This is the table we want to look in.
		key: 		This is the main element in the table.
		sub_key:	This is the element within the main element. It can be a table on its own.
		value:		When a table uses numeric indices, it's likely the user wants to lookup a value associated to a sub_key.
]]

tbl.IsItemOrItemTypeIgnored = function(itemID, itemType, itemSubType, itemEquipLoc)
	for k, v in pairs(tbl.IgnoredItems) do
		if type(v) == "table" then
			for _, j in pairs(v) do
				if itemType == j or itemSubType == j or itemEquipLoc == j then return true end
			end
		else
			if itemID == k then return true end
		end
	end
	
	if itemEquipLoc == "INVTYPE_NECK" or itemEquipLoc == "INVTYPE_FINGER" or itemEquipLoc == "INVTYPE_TRINKET" then
		if not tbl.Settings["isNeckFilterEnabled"] then return true end
		if not tbl.Settings["isRingFilterEnabled"] then return true end
		if not tbl.Settings["isTrinketFilterEnabled"] then return true end
	end
	
	if itemType == L["QUEST"] then
		if not tbl.Settings["isQuestFilterEnabled"] then return true end
	end
	
	return false
end

tbl.Round = function(number)
	return floor(number * (10) + 0.5) / (10);
end
-- Synopsis: Rounds a number to the provided number of places pass the decimal point.

tbl.GetTable = function(tbl)
	if tbl == tbl.History then
		for i = #tbl, 1, -1 do
			print("|T" .. tbl[i].itemIcon .. ":0|t " .. tbl[i].itemLink .. " | " .. tbl[i].source .. " | " .. tbl[i].location .. " | " .. tbl[i].lootDate);
		end
	end
end
-- Synopsis: Used to iterate over a table to get its content.

tbl.RollHistory = function()
	local historyEntries = tbl.GetCount(tbl.History);
	if historyEntries > tbl.maxHistoryEntries then
		for i = #tbl.History, 1, -1 do
			if i > tbl.maxHistoryEntries then
				table.remove(tbl.History, i);
			end
		end
	end
end
-- Synopsis: Maintains the history table, to always keep it at the maximum number of entries, which is currently 20.

tbl.DateFormat = function(format)
	for k, v in pairs(tbl.Items) do
		if tonumber(format) then -- The player passed in a number so set the format to DAY/MONTH/YEAR.
			local month, day, year = string.match(tbl.Items[k]["lootDate"], "^(%d%d)/(%d%d)/(%d%d%d%d)$");
			tbl.Items[k]["lootDate"] = string.format("%s/%s/%s", day, month, year);
		else
			local day, month, year = string.match(tbl.Items[k]["lootDate"], "^(%d%d)/(%d%d)/(%d%d%d%d)$");
			tbl.Items[k]["lootDate"] = string.format("%s/%s/%s", month, day, year);
		end
	end
end
-- Synopsis: Changes the date format for existing items from MONTH/DAY/YEAR to DAY/MONTH/YEAR or vice versa.

tbl.GetItemInfo = function(itemLink, slot)
	lootSources = { GetLootSourceInfo(slot) }
	local itemID, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon

	if itemLink then
		if tbl.Settings["scanOnLoot"] then -- Do NOT modify the item link to remove their variants.
		else
			itemLink = tbl.ExtractItemLink(L["LOOT_ITEM_SELF"] .. itemLink)
		end
		for j = 1, #lootSources, 2 do
			if itemLink then
				itemName = (GetItemInfo(itemLink))
				itemRarity = select(3, GetItemInfo(itemLink))
				itemID, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(itemLink)
				local type, _, _, _, _, creatureID = strsplit("-", lootSources[j])
				
				if itemID then -- To catch items without an item ID.
					tbl.itemsToSource[itemID] = tonumber(creatureID)
					tbl.itemSourceCreatureID = tbl.itemsToSource[itemID]
					
					if itemRarity < tbl.Settings["rarity"] then return end
					if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then -- The item is whitelisted so don't check the blacklists.
					else
						local isItemOrItemTypeIgnored = tbl.IsItemOrItemTypeIgnored(itemID, itemType, itemSubType, itemEquipLoc)
						if isItemOrItemTypeIgnored then return end
					end
					
					if tbl.Items[itemID] then -- Item seen again.
						if tbl.Creatures[tbl.itemSourceCreatureID] then
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Creature", tbl.Creatures[tbl.itemSourceCreatureID].unitName, "Update")
						elseif tbl.encounterID then
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Encounter", tbl.Encounters[tbl.encounterID], "Update")
						elseif tbl.target ~= "" then
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Object", tbl.target, "Update")
						elseif tbl.container ~= "" then
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Container", tbl.container, "Update")
						else
							if tbl.Settings["mode"] ~= L["SILENT"] then print(L["ADDON_NAME"] .. itemLink .. L["ERROR_MSG_UNKNOWN_SOURCE"]) end
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Miscellaneous", L["INFO_MSG_MISCELLANEOUS"], "Update")
						end
					else -- Item seen for first time.
						if tbl.Creatures[tbl.itemSourceCreatureID] then
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Creature", tbl.Creatures[tbl.itemSourceCreatureID].unitName, "New")
						elseif tbl.encounterID then
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Encounter", tbl.Encounters[tbl.encounterID], "New")
						elseif tbl.target ~= "" then
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Object", tbl.target, "New")
						elseif tbl.container ~= "" then
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Container", tbl.container, "New")
						else
							if tbl.Settings["mode"] ~= L["SILENT"] then print(L["ADDON_NAME"] .. itemLink .. L["ERROR_MSG_UNKNOWN_SOURCE"]) end
							tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], tbl.currentMap, "Miscellaneous", L["INFO_MSG_MISCELLANEOUS"], "New")
						end
					end
				end
			end
		end
	end
end
-- Synopsis: Fetches an item's information just before it's looted from the window, and then sends it down the pipeline to tbl.AddItem.