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

local function Iter(tbl)
	local index = 0;
	return function() index = index + 1; return tbl[index] end;
end

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
	
	if lastSeenNS.LastSeenItems[itemID] then
		print(L["ADDON_NAME"] .. L["ITEM_EXISTS"]);
	else
		lastSeenNS.LastSeenItems[itemID] = {itemName = "", itemLink = "", itemRarity = "", itemType = "", lootDate = "", source = "", location = "", manualEntry = true};
		print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. itemID .. ".");
	end
end

lastSeenNS.Ignore = function(itemID)
	if tonumber(itemID) then
		local itemID = tonumber(itemID);
		if lastSeenNS.LastSeenIgnoredItems[itemID] then
			lastSeenNS.LastSeenIgnoredItems[itemID].ignored = not lastSeenNS.LastSeenIgnoredItems[itemID].ignored;
			if lastSeenNS.LastSeenIgnoredItems[itemID].ignored then
				print(L["ADDON_NAME"] .. L["IGNORE_ITEM"] .. itemID .. ".");
			else
				print(L["ADDON_NAME"] .. L["!IGNORE_ITEM"] .. itemID .. ".");
			end
		else
			lastSeenNS.LastSeenIgnoredItems[itemID] = {ignored = true};
			print(L["ADDON_NAME"] .. L["IGNORE_ITEM"] .. itemID .. ".");
		end
	else
		print(L["ADDON_NAME"] .. L["UNABLE_TO_COMPLETE_ACTION"] .. "(" .. L["IGNORE"] .. ")");
	end
end

lastSeenNS.Remove = function(itemID)
	local itemID = tonumber(itemID);
	if lastSeenNS.LastSeenItems[itemID] then
		lastSeenNS.LastSeenItems[itemID] = nil;
		print(L["ADDON_NAME"] .. L["REMOVE_ITEM"] .. itemID .. ".");
	else
		print(L["ADDON_NAME"] .. L["NO_ITEMS_FOUND"]);
	end
end

lastSeenNS.Search = function(query)
	local itemsFound = 0;
	local questsFound = 0;
	local queryType, query = strsplit(" ", query);
	if queryType == L["SEARCH_OPTION_I"] then -- Item search
		if tonumber(query) ~= nil then
			query = tonumber(query);
			if lastSeenNS.LastSeenItems[query] then
				print(query .. ": " .. lastSeenNS.LastSeenItems[query].itemLink .. " | " .. lastSeenNS.LastSeenItems[query].lootDate .. " | " .. lastSeenNS.LastSeenItems[query].source .. " | " .. lastSeenNS.LastSeenItems[query].location);
				itemsFound = itemsFound + 1;
			end
		else
			for k, v in pairs(lastSeenNS.LastSeenItems) do
				if v.itemName ~= nil then
					if string.find(string.lower(v.itemName), string.lower(query)) then
						if v.itemLink == "" then
							print(k .. ": " .. v.itemName .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
						else
							print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
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
		for k, v in pairs(lastSeenNS.LastSeenItems) do
			if v.source ~= nil then
				if string.find(string.lower(v.source), string.lower(query)) then
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
					else
						print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
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
			if lastSeenNS.LastSeenQuests[query] then
				print(query .. ": " .. lastSeenNS.LastSeenQuests[query].title .. " | " .. lastSeenNS.LastSeenQuests[query].completed .. " | " .. lastSeenNS.LastSeenQuests[query].location);
				questsFound = questsFound + 1;
			end
		else
			if #lastSeenNS.LastSeenQuests >= 1 then
				for k, v in pairs(lastSeenNS.LastSeenQuests) do
					if string.find(string.lower(v.title), string.lower(query)) then
						print(k .. ": " .. v.title .. " | " .. v.completed .. " | " .. v.location);
						questsFound = questsFound + 1;
					end
					if questsFound > 1 then
						print(L["ADDON_NAME"] .. questsFound .. L["RECORDS_FOUND"]);
					end
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
		for k, v in pairs(lastSeenNS.LastSeenItems) do
			if v.location ~= nil then
				if string.find(string.lower(v.location), string.lower(query)) then
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
					else
						if v.lootDate == nil then
							--
						else
							print(k .. ": " .. v.itemLink .. " | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
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

lastSeenNS.GetCurrentMap = function()
	local args = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player"));
	if not args.mapID then return end;
	if not lastSeenNS.maps[args.mapID] then
		lastSeenNS.maps[args.mapID] = args.name;
	end
	return args.name;
end

lastSeenNS.OnTooltipSetItem = function(tooltip)
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end;
	
	local itemID = lastSeenNS.GetItemID(itemLink);
	
	if lastSeenNS.LastSeenItems[itemID] then -- Item exists in the database; therefore, show its data.
		local frame, text;
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end;
			if text and string.find(text, lastSeen) then return end;
		end
		if lastSeenNS.LastSeenItems[itemID].location ~= nil and lastSeenNS.LastSeenItems[itemID].lootDate ~= nil and lastSeenNS.LastSeenItems[itemID].source ~= nil then
			tooltip:AddDoubleLine("|T"..eyeIcon..":0|t " .. lastSeen, lastSeenNS.LastSeenItems[itemID].lootDate .. " | " .. lastSeenNS.LastSeenItems[itemID].source .. " | " .. lastSeenNS.LastSeenItems[itemID].location, 0.00, 0.8, 1.0, 1.00, 1.00, 1.00);
			tooltip:Show();
		else
			tooltip:AddDoubleLine("|T"..eyeIcon..":0|t " .. lastSeen, "|T"..badDataIcon..":0|t " .. L["BAD_DATA_FOUND"], 0.00, 0.8, 1.0, 1.00, 1.00, 1.00);
			tooltip:Show();
		end
	end
end

lastSeenNS.IfExists = function(...)
	local tbl = select(1, ...);
	local query = select(2, ...);
	if tonumber(query) ~= nil then
		for k, v in pairs(tbl) do
			if k == query then
				lastSeenNS.exists = true;
			end
		end
	else
		for k, v in pairs(tbl) do
			if v.itemType == query then
				lastSeenNS.exists = true;
			end
		end
	end
end

lastSeenNS.NilTable = function(tbl)
	tbl = {};
	return tbl;
end

lastSeenNS.ValidateTable = function(tbl)
	for k,v in pairs(tbl) do
		if v.source == nil then
			v.source = "";
			v.itemLink = "";
			v.itemType = "";
			v.itemRarity = 0;
		end
	end
	return tbl;
end

-- DO NOT TOUCH --
function LastSeenPopulateMaps()
	for i, j in ipairs(C_Map.GetMapChildrenInfo(C_Map.GetBestMapForUnit("player"))) do
		lastSeenNS.maps[j.mapID] = j.name;
	end
end