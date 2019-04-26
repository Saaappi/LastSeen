--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Leverages onboarded data to dictate flow of function control.
]]--

local lastSeen, lastSeenNS = ...;

local L = lastSeenNS.L; -- Create a local reference to the global localization table.

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
	local itemID = tonumber(itemID);
	
	if lastSeenNS.LastSeenIgnore[itemID] then
		lastSeenNS.LastSeenIgnore[itemID].ignore = not lastSeenNS.LastSeenIgnore[itemID].ignore;
		if lastSeenNS.LastSeenIgnore[itemID].ignore then
			print(L["ADDON_NAME"] .. L["IGNORE_ITEM"] .. itemID .. ".");
		else
			print(L["ADDON_NAME"] .. L["!IGNORE_ITEM"] .. itemID .. ".");
		end
	else
		lastSeenNS.LastSeenIgnore[itemID] = {ignore = true};
		print(L["ADDON_NAME"] .. L["IGNORE_ITEM"] .. itemID .. ".");
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
	if tonumber(query) ~= nil then
		local query = tonumber(query);
		if lastSeenNS.LastSeenItems[query] then
			print(query .. ": " .. lastSeenNS.LastSeenItems[query].itemLink .. " - " .. lastSeenNS.LastSeenItems[query].lootDate .. " - " .. lastSeenNS.LastSeenItems[query].source .. " - (" .. lastSeenNS.LastSeenItems[query].location .. ")");
		end
	else
		for k, v in pairs(lastSeenNS.LastSeenItems) do
			if v.itemName ~= nil then
				if string.find(string.lower(v.itemName), string.lower(query)) then
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " - " .. v.lootDate .. " - " .. v.source .. " - (" .. v.location .. ")");
					else
						print(k .. ": " .. v.itemLink .. " - " .. v.lootDate .. " - " .. v.source .. " - (" .. v.location .. ")");
					end
					itemsFound = itemsFound + 1;
				end
			end
		end
	end
	if itemsFound == 0 then
		local i = 1;
		local NO_ITEMS_FOUND = "";
		for word in string.gmatch(L["NO_ITEMS_FOUND"], "%w+") do
			NO_ITEMS_FOUND = NO_ITEMS_FOUND .. " " .. word;
			if i == 2 then
				NO_ITEMS_FOUND = string.format(NO_ITEMS_FOUND .. " " .. "%s" .. "%s", L["MATCHED_ITEM"], "'" .. query .. "'");
			end
			i = i + 1;
		end
		NO_ITEMS_FOUND = string.gsub(L["ADDON_NAME"] .. " " .. NO_ITEMS_FOUND .. "!", "%s+", " "); print(NO_ITEMS_FOUND);
	end
end

local function Iter(tbl)
	local index = 0;
	return function() index = index + 1; return tbl[index] end;
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