local addon, addonTbl = ...;

-- Common API call variables
local GetBestMapForUnit = C_Map.GetBestMapForUnit;
local GetMapInfo = C_Map.GetMapInfo;

local L = addonTbl.L; -- Create a local reference to the global localization table.
local select = select;
local itemDBRef;

local function Report(resultType, query)
	local i = 1;
	local NO_RESULTS_FOUND = "";
	for word in string.gmatch(L[resultType], "%w+") do
		NO_RESULTS_FOUND = NO_RESULTS_FOUND .. " " .. word;
		if i == 2 then
			NO_RESULTS_FOUND = string.format(NO_RESULTS_FOUND .. " " .. "%s" .. "%s", L["INFO_MSG_MATCHING"], "'" .. query .. "'");
		end
		i = i + 1;
	end
	NO_RESULTS_FOUND = string.gsub(L["ADDON_NAME"] .. NO_RESULTS_FOUND .. "!", "%s+", " "); print(NO_RESULTS_FOUND);
end

local function GetItemSeenCount(itemID)
	local itemSeenCount = 0;
	if LastSeenLootTemplate[itemID] then
		for creature in pairs(LastSeenLootTemplate[itemID]) do
			itemSeenCount = itemSeenCount + LastSeenLootTemplate[itemID][creature];
		end
	end
	return itemSeenCount;
end

addonTbl.Remove = function(arg)
	if tonumber(arg) then -- The passed argument is a number or item ID.
		arg = tonumber(arg);
		if LastSeenItemsDB[arg] then
			if LastSeenItemsDB[arg].itemLink ~= nil then
				print(L["ADDON_NAME"] .. LastSeenItemsDB[arg].itemLink .. L["INFO_MSG_ITEM_REMOVED"]);
			else
				print(L["ADDON_NAME"] .. arg .. L["INFO_MSG_ITEM_REMOVED"]);
			end
			LastSeenItemsDB[arg] = nil;
		end
	elseif not tonumber(arg) then -- The passed argument isn't a number, and is likely an item's link.
		arg = (GetItemInfoInstant(arg)); -- Converts the supposed item link into an item ID.
		if tonumber(arg) then
			arg = tonumber(arg);
			if LastSeenItemsDB[arg] then
				if LastSeenItemsDB[arg].itemLink ~= nil then
					print(L["ADDON_NAME"] .. LastSeenItemsDB[arg].itemLink .. L["INFO_MSG_ITEM_REMOVED"]);
				else
					print(L["ADDON_NAME"] .. arg .. L["INFO_MSG_ITEM_REMOVED"]);
				end
				LastSeenItemsDB[arg] = nil;
			end
		end
	else
		print(L["ADDON_NAME"] .. L["ERROR_MSG_BAD_REQUEST"]);
	end
	
	if (LastSeenLootTemplate[arg]) then LastSeenLootTemplate[arg] = nil end; -- Remove all associated entries that the player looted the item from.
end
-- Synopsis: Allows the player to remove undesired items from the items table using its ID or link.

addonTbl.Search = function(query)
	local itemsFound = 0;
	local questsFound = 0;
	local queryType = string.sub(query, 1, 1);
	local query = string.match(query, queryType .. "%s" .. "(.*)");
	if queryType == L["SEARCH_OPTION_I"] then -- Item search
		if tonumber(query) ~= nil then
			query = tonumber(query);
			if LastSeenItemsDB[query] then
				if LastSeenItemsDB[query].source ~= L["INFO_MSG_MISCELLANEOUS"] then
					print(query .. ": " .. LastSeenItemsDB[query].itemLink .. " (" .. GetItemSeenCount(query) .. ") | " .. LastSeenItemsDB[query].lootDate .. " | " .. LastSeenItemsDB[query].source .. " | " ..
					LastSeenItemsDB[query].location);
					itemsFound = itemsFound + 1;
				end
			end
		else
			for k, v in pairs(LastSeenItemsDB) do
				if v.source ~= L["INFO_MSG_MISCELLANEOUS"] then
					if v.itemName ~= nil then
						if string.find(string.lower(v.itemName), string.lower(query)) then
							local itemID = (GetItemInfoInstant(k));
							if v.itemLink == "" then
								print(k .. ": " .. v.itemName .. " (" .. GetItemSeenCount(itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
							else
								print(k .. ": " .. v.itemLink .. " (" .. GetItemSeenCount(itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
							end
							itemsFound = itemsFound + 1;
						end
					end
				end
			end
		end
		if itemsFound == 0 then
			Report("ERROR_MSG_NO_ITEMS_FOUND", query);
		else
			print(addon .. ": " .. itemsFound .. " record(s) found.");
		end
	elseif queryType == L["SEARCH_OPTION_C"] then -- Creature search
		for k, v in pairs(LastSeenItemsDB) do
			if v.source ~= nil then
				if v.source ~= L["INFO_MSG_MISCELLANEOUS"] then
					if string.find(string.lower(v.source), string.lower(query)) then
						local itemID = (GetItemInfoInstant(k));
						if v.itemLink == "" then
							print(k .. ": " .. v.itemName .. " (" .. GetItemSeenCount(itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
						else
							print(k .. ": " .. v.itemLink .. " (" .. GetItemSeenCount(itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
						end
						itemsFound = itemsFound + 1;
					end
				end
			end
		end
		if itemsFound == 0 then
			Report("ERROR_MSG_NO_ITEMS_FOUND", query);
		else
			print(L["ADDON_NAME"] .. itemsFound .. L["INFO_MSG_ITEMS_FOUND"]);
		end
	elseif queryType == L["SEARCH_OPTION_Z"] then -- Zone search
		for k, v in pairs(LastSeenItemsDB) do
			if v.source ~= L["INFO_MSG_MISCELLANEOUS"] then
				if v.location ~= nil then
					if string.find(string.lower(v.location), string.lower(query)) then
						local itemID = (GetItemInfoInstant(k));
						if v.itemLink == "" then
							print(k .. ": " .. v.itemName .. " (" .. GetItemSeenCount(itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
						else
							if v.lootDate == nil then
								--
							else
								print(k .. ": " .. v.itemLink .. " (" .. GetItemSeenCount(itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
							end
						end
						itemsFound = itemsFound + 1;
					end
				end
			end
		end
		if itemsFound == 0 then
			Report("ERROR_MSG_NO_ITEMS_FOUND", query);
		else
			print(L["ADDON_NAME"] .. itemsFound .. L["RECORDS_FOUND"]);
		end
	end
end

addonTbl.GetCurrentMap = function()
	local uiMapID = GetBestMapForUnit("player");
	local isInInstance;
	
	if uiMapID then -- A map ID was found and is usable.
		local uiMap = GetMapInfo(uiMapID);
		if not uiMap.mapID then return end;
		if not LastSeenMapsDB[uiMap.mapID] then
			LastSeenMapsDB[uiMap.mapID] = uiMap.name;
		end

		addonTbl.currentMap = uiMap.name;
	else
		C_Timer.After(3, addonTbl.GetCurrentMap); -- Recursively call the function every 3 seconds until a map ID is found.
	end
	
	return addonTbl.currentMap;
end

-- Checks whether the data for the given itemID appears to be valid or not
-- Written by: Arcanemagus
-- Updated by: Lightsky (Oxlotus)
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

addonTbl.OnTooltipSetItem = function(tooltip)
	local isIgnored = false;
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end;

	local itemID = (GetItemInfoInstant(itemLink)); if not itemID then return end; -- To handle reagents in the tradeskill window.

	local itemTypeID = select(12, GetItemInfo(itemID));

	if LastSeenItemsDB[itemID] then -- Item exists in the database; therefore, show its data.
		local frame, text;
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end;
			if text and string.find(text, "LastSeen") then return end;
		end
		if addonTbl.DataIsValid(itemID) then
			tooltip:AppendText(" (|cffadd8e6" .. LastSeenItemsDB[itemID].source .. "|r)");
			tooltip:AddLine(L["ADDON_NAME"] .. "|cffadd8e6" .. LastSeenItemsDB[itemID].location .. "|r | |cffadd8e6" .. LastSeenItemsDB[itemID].lootDate .. "|r");
			tooltip:Show();
		end
	end
	
	if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(6, GetItemInfo(itemID))) then isIgnored = true end;
	if not isIgnored then if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(7, GetItemInfo(itemID))) then isIgnored = true end end;
	if not isIgnored then if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(9, GetItemInfo(itemID))) then isIgnored = true end end;
	
	if isIgnored then
		tooltip:AddLine("\n" .. L["ADDON_NAME"] .. "|cffffffff" .. L["INFO_MSG_IGNORED_ITEM"] .. "|r");
		tooltip:Show();
	end
end

addonTbl.ExtractItemLink = function(constant)
	local extractedLink, itemID, _, returnLink;
	
	if string.find(constant, L["LOOT_ITEM_PUSHED_SELF"]) then
		extractedLink = string.match(constant, L["LOOT_ITEM_PUSHED_SELF"] .. "(.*).");
		itemID = GetItemInfoInstant(extractedLink);
	elseif string.find(constant, L["LOOT_ITEM_SELF"]) then
		extractedLink = string.match(constant, L["LOOT_ITEM_SELF"] .. "(.*).");
		itemID = GetItemInfoInstant(extractedLink);
	end
	
	if itemID then
		_, returnLink = GetItemInfo(itemID);
	end
	
	if returnLink then return returnLink end;
end

addonTbl.ReverseLookup = function(t, q)
	for key, value in pairs(t) do
		if value == q then
			return key;
		end
	end
	return false;
end

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

addonTbl.GetItemsSeen = function(tbl)
	local itemsSeen = 0;
	for _ in pairs(tbl) do itemsSeen = itemsSeen + 1 end;

	return itemsSeen;
end

-- TODO: This function should be rewritten to support any table!
addonTbl.GetHistory = function()
	for i = #LastSeenHistoryDB, 1, -1 do
		print("|T" .. LastSeenHistoryDB[i].itemIcon .. ":0|t " .. LastSeenHistoryDB[i].itemLink .. " | " .. LastSeenHistoryDB[i].source .. " | " .. LastSeenHistoryDB[i].location .. " | " .. LastSeenHistoryDB[i].lootDate);
	end
end

addonTbl.RollHistory = function()
	local historyEntries = addonTbl.GetItemsSeen(LastSeenHistoryDB);
	if historyEntries > addonTbl.maxHistoryEntries then
		for i = #LastSeenHistoryDB, 1, -1 do
			if i > addonTbl.maxHistoryEntries then
				table.remove(LastSeenHistoryDB, i);
			end
		end
	end
end
-- Synopsis: Maintains the history table, to always keep it at the maximum number of entries, which is currently 20.

addonTbl.GetItemProperty = function(itemLink)
	if itemLink then
		local itemIcon = select(5, GetItemInfoInstant(itemLink));
		if itemIcon then return itemIcon else addonTbl.GetItemProperty(itemLink) end;
	end
end

addonTbl.GetItemInfo = function(itemLink, slot)
	local lootSources = { GetLootSourceInfo(slot) };

	if itemLink then
		itemLink = addonTbl.ExtractItemLink(L["LOOT_ITEM_SELF"] .. itemLink); -- The item link isn't formatted correctly from the GetLootSlotLink() function.
		local itemName;
		local itemRarity;
		for j = 1, #lootSources, 2 do
			if itemLink then
				local itemID, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(itemLink);
				local type, _, _, _, _, creatureID = strsplit("-", lootSources[j]);
				if itemID then -- To catch items without an item ID.
					if LastSeenItemsDB[itemID] then
						itemName = LastSeenItemsDB[itemID]["itemName"];
						itemRarity = LastSeenItemsDB[itemID]["itemRarity"];
					else
						itemRarity = select(3, GetItemInfo(itemLink));
					end
					addonTbl.itemsToSource[itemID] = tonumber(creatureID);
					addonTbl.itemSourceCreatureID = addonTbl.itemsToSource[itemID];
					
					if itemRarity >= addonTbl.rarity then
						if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemType) then return end;
						if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemSubType) then return end;
						if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemEquipLoc) then return end;
						if addonTbl.Contains(addonTbl.ignoredItems, itemID, nil, nil) then return end;
						
						if LastSeenItemsDB[itemID] then -- Item seen again.
							if LastSeenCreaturesDB[addonTbl.itemSourceCreatureID] then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Creature", LastSeenCreaturesDB[addonTbl.itemSourceCreatureID].unitName, "Update");
							elseif addonTbl.encounterID then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Encounter", LastSeenEncountersDB[addonTbl.encounterID], "Update");
							elseif addonTbl.target then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Object", addonTbl.target, "Update");
							else
								if addonTbl.mode ~= L["QUIET_MODE"] then print(L["ADDON_NAME"] .. itemLink .. L["ERROR_MSG_UNKNOWN_SOURCE"] .. ".") end;
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Miscellaneous", L["INFO_MSG_MISCELLANEOUS"], "Update");
							end
						else -- Item seen for first time.
							if LastSeenCreaturesDB[addonTbl.itemSourceCreatureID] then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Creature", LastSeenCreaturesDB[addonTbl.itemSourceCreatureID].unitName, "New");
							elseif addonTbl.encounterID then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Encounter", LastSeenEncountersDB[addonTbl.encounterID], "New");
							elseif addonTbl.target then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Object", addonTbl.target, "New");
							else
								if addonTbl.mode ~= L["QUIET_MODE"] then print(L["ADDON_NAME"] .. itemLink .. L["ERROR_MSG_UNKNOWN_SOURCE"] .. ".") end;
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

-- DO NOT TOUCH --
--[[function addonPopulateMaps()
	for i, j in ipairs(C_Map.GetMapChildrenInfo(C_Map.GetBestMapForUnit("player"))) do
		LastSeenMapsDB[j.mapID] = j.name;
	end
end]]--
