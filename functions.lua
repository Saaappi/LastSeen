--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Leverages onboarded data to dictate flow of function control.
]]--

local lastseen, lastseendb = ...;

local L = lastseendb.L; -- Create a local reference to the global localization table.

function lastseendb:add(itemid)
	local itemid = tonumber(itemid);
	if lastseendb.itemstgdb == nil then
		lastseendb.itemstgdb = lastseendb:niltable(lastseendb.itemstgdb);
	end
	
	if lastseendb.itemstgdb[itemid] then
		print(L["ADDON_NAME"] .. L["ITEM_EXISTS"]);
	else
		lastseendb.itemstgdb[itemid] = {name = "", lootDate = "", location = "", source = ""};
		print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. itemid .. ".");
	end
	LastSeenItemsDB = lastseendb.itemstgdb;
end

function lastseendb:ignore(itemid)
	local itemid = tonumber(itemid);
	if lastseendb.itemignrdb == nil then
		lastseendb.itemignrdb = lastseendb:niltable(lastseendb.itemignrdb);
	end
	
	if lastseendb.itemignrdb[itemid] then
		lastseendb.itemignrdb[itemid].ignore = not lastseendb.itemignrdb[itemid].ignore;
		if lastseendb.itemignrdb[itemid].ignore then
			print(L["ADDON_NAME"] .. L["IGNORE_ITEM"] .. itemid .. ".");
		else
			print(L["ADDON_NAME"] .. L["!IGNORE_ITEM"] .. itemid .. ".");
		end
	else
		lastseendb.itemignrdb[itemid] = {ignore = true};
		print(L["ADDON_NAME"] .. L["IGNORE_ITEM"] .. itemid .. ".");
	end
	LastSeenIgnoresDB = lastseendb.itemignrdb;
end

function lastseendb:niltable(t)
	t = {};
	return t;
end

function lastseendb:remove(itemid)
	local itemid = tonumber(itemid);
	if lastseendb.itemstgdb[itemid] then
		lastseendb.itemstgdb[itemid] = nil;
		print(L["ADDON_NAME"] .. L["REMOVE_ITEM"] .. itemid .. ".");
	else
		print(L["ADDON_NAME"] .. L["NO_ITEMS_FOUND"]);
	end
end

function lastseendb:search(query)
	if tonumber(query) == nil then -- Player is using an item name and not an ID.
		local itemsFound = 0;
		for k, v in pairs(lastseendb.itemstgdb) do
			if string.find(string.lower(v.name), string.lower(query)) then
				if select(2, GetItemInfo(k)) ~= nil then
					print(select(2, GetItemInfo(k)) .. " (" .. k .. ") - " .. v.lootDate .. " - " .. v.location);
					itemsFound = itemsFound + 1;
				end
			end
		end
		if itemsFound == 0 then
			print(L["ADDON_NAME"] .. L["NO_ITEMS_FOUND"]);
		end
	else
		local query = tonumber(query);
		if lastseendb.itemstgdb[query] then
			print(query .. ": " .. lastseendb:GetItemLink(query) .. " - " .. lastseendb.itemstgdb[query].lootDate .. " - " .. lastseendb.itemstgdb[query].source .. " - " .. lastseendb.itemstgdb[query].location);
		else
			print(L["ADDON_NAME"] .. L["NO_ITEMS_FOUND"]);
		end
	end
end

function lastseendb:GetBestMapForUnit(unit)
	return C_Map.GetMapInfo(C_Map.GetBestMapForUnit(unit)).name;
end

function lastseendb:GetItemLink(itemid)
	if select(2, GetItemInfo(itemid)) == nil then
		return "";
	else
		return select(2, GetItemInfo(itemid));
	end
end

function lastseendb:iter(t)
	local index = 0;
	return function() index = index + 1; return t[index] end;
end