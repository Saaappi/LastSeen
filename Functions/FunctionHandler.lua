--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Leverages onboarded data to dictate flow of function control.
]]--

local lastSeen, lastSeenNS = ...;

local L = lastSeenNS.L; -- Create a local reference to the global localization table.
local eyeIcon = select(3, GetSpellInfo(191933));
local badDataIcon = select(3, GetSpellInfo(5));
local select = select;

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

lastSeenNS.Add = function(itemID)
	local itemID = tonumber(itemID);
	local itemType = select(2, GetItemInfoInstant(itemID));

	if lastSeenNS.ignoredItems[itemID] or lastSeenNS.ignoredItemTypes[itemType] or LastSeenIgnoredItemsDB[itemID] then
		if lastSeenNS.doNotIgnore ~= true then
			print(L["ADDON_NAME"] .. L["ITEM_IGNORED_BY_SYSTEM_OR_PLAYER"]);
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

lastSeenNS.Ignore = function(itemID)
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

lastSeenNS.Remove = function(itemID)
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
end

lastSeenNS.Search = function(query)
	local itemsFound = 0;
	local questsFound = 0;
	local queryType = string.sub(query, 1, 1);
	local query = string.match(query, queryType .. "%s" .. "(.*)");
	if queryType == L["SEARCH_OPTION_I"] then -- Item search
		if tonumber(query) ~= nil then
			query = tonumber(query);
			if LastSeenItemsDB[query] then
				print(query .. ": " .. LastSeenItemsDB[query].itemLink .. " | " .. LastSeenItemsDB[query].lootDate .. " | " .. LastSeenItemsDB[query].source .. " | " ..
				LastSeenItemsDB[query].location .. " | " .. lastSeenNS.GetItemStatus(query));
				itemsFound = itemsFound + 1;
			end
		else
			for k, v in pairs(LastSeenItemsDB) do
				if v.itemName ~= nil then
					if string.find(string.lower(v.itemName), string.lower(query)) then
						if v.itemLink == "" then
							print(k .. ": " .. v.itemName .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. lastSeenNS.GetItemStatus(k));
						else
							print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. lastSeenNS.GetItemStatus(k));
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
							print(k .. ": " .. v.itemName .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. lastSeenNS.GetItemStatus(k));
						else
							print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. lastSeenNS.GetItemStatus(k));
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
							print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location .. " | " .. lastSeenNS.GetItemStatus(k));
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

lastSeenNS.GetItemStatus = function(itemID)
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

-- Checks whether a string actually contains something
local hasValue = function(string)
	if string == nil or string == '' then
		return false;
	end
	return true;
end

-- Checks whether the data for the given itemID appears to be valid or not
lastSeenNS.DataIsValid = function(itemID)
	if itemID == nil then
		return false;
	end

	item = LastSeenItemsDB[itemID]
	if item == nil then
		return false;
	end

	if hasValue(item.location) and hasValue(item.lootDate) and hasValue(item.source) then
		return true;
	else
		return false;
	end
end

lastSeenNS.OnTooltipSetItem = function(tooltip)
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
					lastSeenNS.lootedItem = GetItemInfo(itemID);
					break;
				else
					lastSeenNS.lootedItem = "";
				end
			end
		end
		if i and j then
			lastSeenNS.lootedItem = "";
			break;
		end
	end

	if LastSeenItemsDB[itemID] then -- Item exists in the database; therefore, show its data.
		status = lastSeenNS.GetItemStatus(itemID);
		local frame, text;
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end;
			if text and string.find(text, lastSeen) then return end;
		end
		if lastSeenNS.DataIsValid(itemID) then
			tooltip:AddLine("|T"..eyeIcon..":0|t |cff00ccff" .. lastSeen .. "|r - " .. LastSeenItemsDB[itemID].lootDate .. " - |cffffffff" ..
			LastSeenItemsDB[itemID].source .. "|r - " .. LastSeenItemsDB[itemID].location .. " (" .. status .. ")");
			tooltip:Show();
		else
			tooltip:AddLine("|T"..eyeIcon..":0|t |cff00ccff" .. lastSeen .. "|r |T"..badDataIcon..":0|t " .. L["BAD_DATA_FOUND"]);
			tooltip:Show();
		end
	end
end

lastSeenNS.ExtractItemLink = function(constant)
	local extractedItemLink;
	if string.find(constant, L["LOOT_ITEM_PUSHED_SELF"]) then
		extractedItemLink = select(3, string.find(constant, string.gsub(string.gsub(LOOT_ITEM_PUSHED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.find(constant, L["LOOT_ITEM_SELF"]) then
		extractedItemLink = select(3, string.find(constant, string.gsub(string.gsub(LOOT_ITEM_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.find(constant, L["LOOT_ITEM_CREATED_SELF"]) then
		extractedItemLink = select(3, string.find(constant, string.gsub(string.gsub(LOOT_ITEM_CREATED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
		lastSeenNS.isCraftedItem = true;
	else -- This else is here because people think it's cool to override WoW constants...
		local testLink = select(2, GetItemInfo(select(3, string.find(constant, "(.*%])"))));
		if testLink then
			extractedItemLink = testLink;
		else
			extractedItemLink = string.find(constant, "[%+%p%s](.*)[%s%p%+]");
		end
	end

	return extractedItemLink;
end

lastSeenNS.IfExists = function(...)
	local tbl = select(1, ...);
	local query = select(2, ...);
	for k in pairs(tbl) do
		if k == query then
			lastSeenNS.exists = true;
		end
	end
end

lastSeenNS.Round = function(coords, places)
	local inInstance = IsInInstance();
	if not inInstance then
		local multiplier = 10^(places or 0)
		local x = math.floor(coords.x * multiplier + 0.5) / multiplier;
		local y = math.floor(coords.y * multiplier + 0.5) / multiplier;
		return x * 100 .. ", " .. y * 100;
	else
		return "---";
	end
end

lastSeenNS.GetItemsSeen = function(tbl)
	local itemsSeen = 0;
	for _ in pairs(tbl) do itemsSeen = itemsSeen + 1 end;

	return itemsSeen;
end

-- DO NOT TOUCH --
--[[function LastSeenPopulateMaps()
	for i, j in ipairs(C_Map.GetMapChildrenInfo(C_Map.GetBestMapForUnit("player"))) do
		LastSeenMapsDB[j.mapID] = j.name;
	end
end]]--
