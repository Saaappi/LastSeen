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

addonTbl.Remove = function(itemID)
	local itemID = tonumber(itemID);
	if LastSeenItemsDB[itemID] then
		if LastSeenItemsDB[itemID]["itemName"] ~= nil and LastSeenItemsDB[itemID]["itemName"] ~= "" then
			print(L["ADDON_NAME"] .. LastSeenItemsDB[itemID]["itemName"] .. L["INFO_MSG_ITEM_REMOVED"]);
		else
			print(L["ADDON_NAME"] .. itemID .. L["INFO_MSG_ITEM_REMOVED"]);
		end
		LastSeenItemsDB[itemID] = nil;
	else
		print(L["ADDON_NAME"] .. L["ERROR_MSG_NO_ITEMS_FOUND"]);
	end
	
	if (LastSeenLootTemplate[itemID]) then
		LastSeenLootTemplate[itemID] = nil;
	end
end

addonTbl.Search = function(query)
	local itemsFound = 0;
	local questsFound = 0;
	local queryType = string.sub(query, 1, 1);
	local query = string.match(query, queryType .. "%s" .. "(.*)");
	if queryType == L["SEARCH_OPTION_I"] then -- Item search
		if tonumber(query) ~= nil then
			query = tonumber(query);
			if LastSeenItemsDB[query] then
				print(query .. ": " .. LastSeenItemsDB[query].itemLink .. " (" .. GetItemSeenCount(query) .. ") | " .. LastSeenItemsDB[query].lootDate .. " | " .. LastSeenItemsDB[query].source .. " | " ..
				LastSeenItemsDB[query].location);
				itemsFound = itemsFound + 1;
			end
		else
			for k, v in pairs(LastSeenItemsDB) do
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
		if itemsFound == 0 then
			Report("ERROR_MSG_NO_ITEMS_FOUND", query);
		else
			print(addon .. ": " .. itemsFound .. " record(s) found.");
		end
	elseif queryType == L["SEARCH_OPTION_C"] then -- Creature search
		for k, v in pairs(LastSeenItemsDB) do
			if v.source ~= nil then
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
		if itemsFound == 0 then
			Report("ERROR_MSG_NO_ITEMS_FOUND", query);
		else
			print(L["ADDON_NAME"] .. itemsFound .. L["INFO_MSG_ITEMS_FOUND"]);
		end
	elseif queryType == L["SEARCH_OPTION_Z"] then -- Zone search
		for k, v in pairs(LastSeenItemsDB) do
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
	
	if IsInInstance() then
		if select(2, IsInInstance()) == "party" or select(2, IsInInstance()) == "raid" then
			local i = 1;
			while EJ_GetMapEncounter(uiMapID, i, true) do
				local _, _, _, encounterName, _, encounterID = EJ_GetMapEncounter(uiMapID, i, true);
				if not LastSeenEncountersDB[encounterID] then
					LastSeenEncountersDB[encounterID] = encounterName;
				end
				i = i + 1;
			end
		end
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
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end;

	local itemID = (GetItemInfoInstant(itemLink));

	if not itemID then return end; -- To handle reagents in the tradeskill window.

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
			tooltip:AddLine(addon .. ": |cffadd8e6" .. LastSeenItemsDB[itemID].location .. "|r | |cffadd8e6" .. LastSeenItemsDB[itemID].lootDate .. "|r");
			tooltip:Show();
		end
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

addonTbl.Contains = function(tab, property, query)
	for index, _ in ipairs(tab) do
		if property ~= "" then
			if tab[index].property == query then
				return true;
			end
		else
			if tab[index] == query then
				return true;
			end
		end
	end
	return false;
end

addonTbl.Round = function(unit, places)
	local inInstance = IsInInstance();
	if not inInstance then
		local multiplier = 10^(places or 0)
		unit = math.floor(unit * multiplier + 0.5) / multiplier;
		return unit * 100;
	else
		return "---";
	end
end

addonTbl.TableHasField = function(tbl, key, field)
	if tbl[key] then
		for _, v in pairs(tbl) do
			if v[field] ~= nil then
				return true;
			else
				return false;
			end
		end
	end
end

addonTbl.GetItemsSeen = function(tbl)
	local itemsSeen = 0;
	for _ in pairs(tbl) do itemsSeen = itemsSeen + 1 end;

	return itemsSeen;
end

addonTbl.GetHistory = function()
	for i = #LastSeenHistoryDB, 1, -1 do
		print("|T" .. LastSeenHistoryDB[i].itemIcon .. ":0|t " .. LastSeenHistoryDB[i].itemLink .. " | " .. LastSeenHistoryDB[i].source .. " | " .. LastSeenHistoryDB[i].location .. " | " .. LastSeenHistoryDB[i].lootDate);
	end
end

-- The function will clean the history table by inverting it and 'popping' off the top elements.
-- This is the most efficient method of maintaining this table.
addonTbl.RollHistory = function()
	local historyEntries = addonTbl.GetItemsSeen(LastSeenHistoryDB);
	if historyEntries > 20 then
		for i = #LastSeenHistoryDB, 1, -1 do
			if i > 20 then
				table.remove(LastSeenHistoryDB, i);
			end
		end
	end
end

addonTbl.ShouldItemBeIgnored = function(itemID, itemType)
	for k, v in pairs(addonTbl.ignoredItemTypes) do
		if itemType == v and not addonTbl.doNotIgnore then
			return true;
		end
	end
	for k, v in pairs(addonTbl.ignoredItems) do
		if itemID == k and not addonTbl.doNotIgnore then
			return true;
		end
	end
end

addonTbl.GetItemInfo = function(itemLink, slot)
	local lootSources = { GetLootSourceInfo(slot) };

	if itemLink then
		for j = 1, #lootSources, 2 do
			local itemID = (GetItemInfoInstant(itemLink));
			local type, _, _, _, _, creatureID = strsplit("-", lootSources[j]);
			if itemID then -- To catch items without an item ID.
				addonTbl.itemsToSource[itemID] = tonumber(creatureID);
				local itemSourceCreatureID = addonTbl.itemsToSource[itemID];
				local itemName = (GetItemInfo(itemID));
				itemLink = addonTbl.ExtractItemLink(L["LOOT_ITEM_SELF"] .. itemLink); -- The item link isn't formatted correctly from the GetLootSlotLink() function.
				local itemRarity = select(3, GetItemInfo(itemLink));
				local itemType = select(6, GetItemInfo(itemLink));
				local itemIcon = select(5, GetItemInfoInstant(itemLink));
				
				if itemRarity >= addonTbl.rarity then
					for k, v in pairs(addonTbl.ignoredItemTypes) do
						if itemType == v and not addonTbl.doNotIgnore then
							return;
						end
					end
					for k, v in pairs(addonTbl.ignoredItems) do
						if itemID == k and not addonTbl.doNotIgnore then
							return;
						end
					end
					
					if LastSeenItemsDB[itemID] then -- Item seen again.
						if LastSeenCreaturesDB[itemSourceCreatureID] then
							addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Creature", LastSeenCreaturesDB[itemSourceCreatureID].unitName, "Update");
						elseif encounterID then
							addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Encounter", LastSeenEncountersDB[addonTbl.encounterID], "Update");
						elseif addonTbl.target then
							addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Object", addonTbl.target, "New");
						else
							print(L["ADDON_NAME"] .. L["ERROR_MSG_UNKNOWN_SOURCE"] .. itemLink .. "!");
							if addonTbl.mode == L["DEBUG_MODE"] then
								print(LastSeenCreaturesDB[itemSourceCreatureID].unitName);
								print(LastSeenEncountersDB[addonTbl.encounterID]);
								print(addonTbl.target);
							end
						end
					else -- Item seen for first time.
						if LastSeenCreaturesDB[itemSourceCreatureID] then
							addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Creature", LastSeenCreaturesDB[itemSourceCreatureID].unitName, "New");
						elseif encounterID then
							addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Encounter", LastSeenEncountersDB[addonTbl.encounterID], "New");
						elseif addonTbl.target then
							addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, L["DATE"], addonTbl.currentMap, "Object", addonTbl.target, "New");
						else
							print(L["ADDON_NAME"] .. L["ERROR_MSG_UNKNOWN_SOURCE"] .. itemLink .. "!");
							if addonTbl.mode == L["DEBUG_MODE"] then
								print(LastSeenCreaturesDB[itemSourceCreatureID].unitName);
								print(LastSeenEncountersDB[addonTbl.encounterID]);
								print(addonTbl.target);
							end
						end
					end
				end
			end
		end
	end
end

-- DO NOT TOUCH --
--[[function addonPopulateMaps()
	for i, j in ipairs(C_Map.GetMapChildrenInfo(C_Map.GetBestMapForUnit("player"))) do
		LastSeenMapsDB[j.mapID] = j.name;
	end
end]]--
