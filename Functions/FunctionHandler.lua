--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Leverages onboarded data to dictate flow of function control.
]]--

local lastSeen, LastSeenTbl = ...;

-- Common API call variables
local GetBestMapForUnit = C_Map.GetBestMapForUnit;
local GetMapInfo = C_Map.GetMapInfo;

local L = LastSeenTbl.L; -- Create a local reference to the global localization table.
local select = select;
local itemDBRef;

local function Report(resultType, query)
	local i = 1;
	local NO_RESULTS_FOUND = "";
	for word in string.gmatch(L[resultType], "%w+") do
		NO_RESULTS_FOUND = NO_RESULTS_FOUND .. " " .. word;
		if i == 2 then
			NO_RESULTS_FOUND = string.format(NO_RESULTS_FOUND .. " " .. "%s" .. "%s", L["MATCHED_TERM"], "'" .. query .. "'");
		end
		i = i + 1;
	end
	NO_RESULTS_FOUND = string.gsub(L["ADDON_NAME"] .. " " .. NO_RESULTS_FOUND .. "!", "%s+", " "); print(NO_RESULTS_FOUND);
end

LastSeenTbl.Add = function(itemID)
	local itemID = tonumber(itemID);
	local itemType = select(2, GetItemInfoInstant(itemID));

	if LastSeenTbl.ignoredItems[itemID] or LastSeenTbl.ignoredItemTypes[itemType] or LastSeenIgnoredItemsDB[itemID] then
		if LastSeenTbl.doNotIgnore ~= true then
			print(L["ADDON_NAME"] .. L["GENERAL_FAILURE"]);
			return;
		end
	end

	if LastSeenItemsDB[itemID] then
		print(L["ADDON_NAME"] .. L["ITEM_EXISTS"]);
	else
		LastSeenItemsDB[itemID] = {itemName = "", itemLink = "", itemRarity = "", itemType = "", lootDate = "", source = "", location = "", manualEntry = true, key = "+++"};
		print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. itemID .. ".");
	end
end

LastSeenTbl.Ignore = function(itemID)
	if tonumber(itemID) then
		local itemID = tonumber(itemID);
		if LastSeenIgnoredItemsDB[itemID] then
			LastSeenIgnoredItemsDB[itemID].ignored = not LastSeenIgnoredItemsDB[itemID].ignored;
			if LastSeenIgnoredItemsDB[itemID].ignored then
				print(L["ADDON_NAME"] .. L["IGNORE_ITEM"] .. itemID .. ".");
			else
				print(L["ADDON_NAME"] .. L["!IGNORE_ITEM"] .. itemID .. ".");
			end
		else
			LastSeenIgnoredItemsDB[itemID] = {ignored = true};
			print(L["ADDON_NAME"] .. L["IGNORE_ITEM"] .. itemID .. ".");
		end
	else
		print(L["ADDON_NAME"] .. L["UNABLE_TO_COMPLETE_ACTION"] .. "(" .. L["IGNORE"] .. ")");
	end
end

LastSeenTbl.Remove = function(itemID)
	local itemID = tonumber(itemID);
	if LastSeenItemsDB[itemID] then
		if LastSeenItemsDB[itemID]["itemName"] ~= nil and LastSeenItemsDB[itemID]["itemName"] ~= "" then
			print(L["ADDON_NAME"] .. L["REMOVE_ITEM"] .. LastSeenItemsDB[itemID]["itemName"] .. ".");
		else
			print(L["ADDON_NAME"] .. L["REMOVE_ITEM"] .. itemID .. ".");
		end
		LastSeenItemsDB[itemID] = nil;
	else
		print(L["ADDON_NAME"] .. L["NO_ITEMS_FOUND"]);
	end
	
	if (LastSeenLootTemplate[itemID]) then
		LastSeenLootTemplate[itemID] = nil;
	end
end

LastSeenTbl.Search = function(query)
	local itemsFound = 0;
	local questsFound = 0;
	local queryType = string.sub(query, 1, 1);
	local query = string.match(query, queryType .. "%s" .. "(.*)");
	if queryType == L["SEARCH_OPTION_I"] then -- Item search
		if tonumber(query) ~= nil then
			query = tonumber(query);
			if LastSeenItemsDB[query] then
				print(query .. ": " .. LastSeenItemsDB[query].itemLink .. " | " .. LastSeenItemsDB[query].lootDate .. " | " .. LastSeenItemsDB[query].source .. " | " ..
				LastSeenItemsDB[query].location .. " | " .. LastSeenTbl.GetItemStatus(query));
				itemsFound = itemsFound + 1;
			end
		else
			for k, v in pairs(LastSeenItemsDB) do
				if v.itemName ~= nil then
					if string.find(string.lower(v.itemName), string.lower(query)) then
						if v.itemLink == "" then
							print(k .. ": " .. v.itemName .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. LastSeenTbl.GetItemStatus(k));
						else
							print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. LastSeenTbl.GetItemStatus(k));
						end
						itemsFound = itemsFound + 1;
					end
				end
			end
		end
		if itemsFound == 0 then
			Report("NO_ITEMS_FOUND", query);
		else
			print(L["ADDON_NAME"] .. itemsFound .. L["RECORDS_FOUND"]);
		end
	elseif queryType == L["SEARCH_OPTION_C"] then -- Creature search
		for k, v in pairs(LastSeenItemsDB) do
			if v.source ~= nil then
				if string.find(string.lower(v.source), string.lower(query)) then
					if v.itemLink == "" then
							print(k .. ": " .. v.itemName .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. LastSeenTbl.GetItemStatus(k));
						else
							print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. LastSeenTbl.GetItemStatus(k));
						end
						itemsFound = itemsFound + 1;
				end
			end
		end
		if itemsFound == 0 then
			Report("NO_ITEMS_FOUND", query);
		else
			print(L["ADDON_NAME"] .. itemsFound .. L["RECORDS_FOUND"]);
		end
	elseif queryType == L["SEARCH_OPTION_Q"] then -- Quest search
		if tonumber(query) ~= nil then
			query = tonumber(query);
			if LastSeenQuestsDB[query] then
				for i in pairs(LastSeenQuestsDB[query]) do
					print(LastSeenQuestsDB[query][i]);
					questsFound = questsFound + 1;
				end
			end
		else
			if next(LastSeenQuestsDB) ~= nil then -- Table not empty.
				for k, v in pairs(LastSeenQuestsDB) do
					if v.title ~= nil then
						if string.find(string.lower(v.title), string.lower(query)) then
							print(k .. ": " .. v.title .. " | " .. v.completed .. " | " .. v.location);
							questsFound = questsFound + 1;
						end
					end
				end
				if questsFound > 1 then
					print(L["ADDON_NAME"] .. questsFound .. L["RECORDS_FOUND"]);
				end
			else
				print(L["ADDON_NAME"] .. L["NO_QUESTS_COMPLETED"]);
				return;
			end
		end
		if questsFound == 0 then
			Report("NO_QUESTS_FOUND", query);
		end
	elseif queryType == L["SEARCH_OPTION_Z"] then -- Zone search
		for k, v in pairs(LastSeenItemsDB) do
			if v.location ~= nil then
				if string.find(string.lower(v.location), string.lower(query)) then
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
					else
						if v.lootDate == nil then
							--
						else
							print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. LastSeenTbl.GetItemStatus(k));
						end
					end
					itemsFound = itemsFound + 1;
				end
			end
		end
		if itemsFound == 0 then
			Report("NO_ITEMS_FOUND", query);
		else
			print(L["ADDON_NAME"] .. itemsFound .. L["RECORDS_FOUND"]);
		end
	end
end

LastSeenTbl.GetCurrentMap = function()
	local uiMapID = GetBestMapForUnit("player");
	local isInInstance;
	
	if uiMapID then -- A map ID was found and is usable.
		local uiMap = GetMapInfo(uiMapID);
		if not uiMap.mapID then return end;
		if not LastSeenMapsDB[uiMap.mapID] then
			LastSeenMapsDB[uiMap.mapID] = uiMap.name;
		end

		LastSeenTbl.currentMap = uiMap.name;
	else
		C_Timer.After(3, LastSeenTbl.GetCurrentMap); -- Recursively call the function every 3 seconds until a map ID is found.
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
	
	return LastSeenTbl.currentMap;
end

LastSeenTbl.GetItemStatus = function(itemID)
	if LastSeenItemsDB[itemID].key == itemID .. LastSeenAccountKey .. string.byte(itemID) then
		return "|cff32cd32" .. L["TRUSTED"] .. "|r";
	elseif LastSeenItemsDB[itemID].key == "" then
		return "|cffff7f50" .. L["SUSPICIOUS"] .. "|r";
	elseif LastSeenItemsDB[itemID].key == "+++" then
		return "|cff00ffff" .. "+++" .. "|r";
	elseif not LastSeenItemsDB[itemID].key or LastSeenItemsDB[itemID].key ~= itemID .. LastSeenAccountKey .. string.byte(itemID) then
		return "|cffff0000" .. L["UNTRUSTED"] .. "|r";
	end
end

-- Checks whether the data for the given itemID appears to be valid or not
-- Written by: Arcanemagus
-- Updated by: Oxlotus
LastSeenTbl.DataIsValid = function(itemID)
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

LastSeenTbl.OnTooltipSetItem = function(tooltip)
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end;

	local itemID = select(1, GetItemInfoInstant(itemLink));

	if not itemID then return end; -- To handle reagents in the tradeskill window.

	local itemTypeID = select(12, GetItemInfo(itemID));
	local itemSubTypeID = select(13, GetItemInfo(itemID));

	for i = 0, NUM_BAG_SLOTS do
		for j = 1, GetContainerNumSlots(i) do
			if GetContainerItemLink(i, j) == itemLink then
				if select(6, GetContainerItemInfo(i, j)) == true then -- The item is lootable.
					LastSeenTbl.lootedItem = GetItemInfo(itemID);
					break;
				else
					LastSeenTbl.lootedItem = "";
				end
			end
		end
		if i and j then
			LastSeenTbl.lootedItem = "";
			break;
		end
	end
	
	local itemSeenCount = 0;
	if (LastSeenLootTemplate[itemID]) then
		for creature in pairs(LastSeenLootTemplate[itemID]) do
			itemSeenCount = itemSeenCount + LastSeenLootTemplate[itemID][creature];
		end
	end

	if LastSeenItemsDB[itemID] then -- Item exists in the database; therefore, show its data.
		status = LastSeenTbl.GetItemStatus(itemID);
		local frame, text;
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end;
			if text and string.find(text, lastSeen) then return end;
		end
		if LastSeenTbl.DataIsValid(itemID) then
			tooltip:AddLine("|cff00ccff" .. lastSeen .. "|r: (|cffffffff" .. itemSeenCount .. "|r) - " .. LastSeenItemsDB[itemID].lootDate .. " - |cffffffff" ..
			LastSeenItemsDB[itemID].source .. "|r - " .. LastSeenItemsDB[itemID].location .. " (" .. status .. ")");
			tooltip:Show();
		else
			tooltip:AddLine("|cff00ccff" .. lastSeen .. "|r: " .. LastSeenTbl.questionMarkIcon);
			tooltip:Show();
		end
	end
end

LastSeenTbl.ExtractItemLink = function(constant)
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

LastSeenTbl.ReverseLookup = function(t, q)
	for key, value in pairs(t) do
		if value == q then
			return key;
		end
	end
	return false;
end

LastSeenTbl.Contains = function(tab, query)
	for index, value in ipairs(tab) do
		if value == query then
			return true;
		end
	end
	
	return false;
end

LastSeenTbl.Round = function(unit, places)
	local inInstance = IsInInstance();
	if not inInstance then
		local multiplier = 10^(places or 0)
		unit = math.floor(unit * multiplier + 0.5) / multiplier;
		return unit * 100;
	else
		return "---";
	end
end

LastSeenTbl.TableHasField = function(tbl, key, field)
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

LastSeenTbl.GetItemsSeen = function(tbl)
	local itemsSeen = 0;
	for _ in pairs(tbl) do itemsSeen = itemsSeen + 1 end;

	return itemsSeen;
end

LastSeenTbl.GetPlayerRank = function()
	local rank = "";
	local itemsSeen = LastSeenTbl.GetItemsSeen(LastSeenItemsDB);
	
	if (itemsSeen < LastSeenTbl.rank_poor) then
		rank = L["POOR"] .. " " .. LastSeenTbl.poorIcon;
	elseif (itemsSeen > LastSeenTbl.rank_poor) and (itemsSeen < LastSeenTbl.rank_common) then
		rank = L["COMMON"] .. " " .. LastSeenTbl.commonIcon;
	elseif (itemsSeen > LastSeenTbl.rank_common) and (itemsSeen < LastSeenTbl.rank_uncommon) then
		rank = L["UNCOMMON"] .. " " .. LastSeenTbl.uncommonIcon;
	elseif (itemsSeen > LastSeenTbl.rank_uncommon) and (itemsSeen < LastSeenTbl.rank_rare) then
		rank = L["RARE"] .. " " .. LastSeenTbl.rareIcon;
	elseif (itemsSeen > LastSeenTbl.rank_rare) and (itemsSeen < LastSeenTbl.rank_epic) then
		rank = L["EPIC"] .. " " .. LastSeenTbl.epicIcon;
	elseif (itemsSeen > LastSeenTbl.rank_epic) and (itemsSeen < LastSeenTbl.rank_legendary) then
		rank = L["LEGENDARY"] .. " " .. LastSeenTbl.legendaryIcon;
	else
		rank = L["ARTIFACT"] .. " " .. LastSeenTbl.artifactIcon;
	end
	
	return L["RANK"] .. rank;
end

LastSeenTbl.ShouldItemBeIgnored = function(itemType, itemID)
	for k, v in pairs(LastSeenTbl.ignoredItemTypes) do
		if itemType == v and not LastSeenTbl.doNotIgnore then
			return true;
		end
	end
	for k, v in pairs(LastSeenTbl.ignoredItems) do
		if itemID == k and not LastSeenTbl.doNotIgnore then
			return true;
		end
	end
	if LastSeenIgnoredItemsDB[itemID] and LastSeenTbl.doNotIgnore then
		return true;
	end
end

-- DO NOT TOUCH --
--[[function LastSeenPopulateMaps()
	for i, j in ipairs(C_Map.GetMapChildrenInfo(C_Map.GetBestMapForUnit("player"))) do
		LastSeenMapsDB[j.mapID] = j.name;
	end
end]]--
