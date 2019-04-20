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
	
	if lastseendb.itemstgdb[itemid] then
		print(L["ADDON_NAME"] .. L["ITEM_EXISTS"]);
	else
		lastseendb.itemstgdb[itemid] = {itemName = "", lootDate = "", location = "", source = ""};
		print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. itemid .. ".");
	end
end

function lastseendb:ignore(itemid)
	local itemid = tonumber(itemid);
	
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
			if string.find(string.lower(v.itemName), string.lower(query)) then
				print(k .. ": " .. v.itemLink .. " - " .. v.lootDate .. " - " .. v.source .. " - " .. v.location);
				itemsFound = itemsFound + 1;
			end
		end
		if itemsFound == 0 then
			print(L["ADDON_NAME"] .. L["NO_ITEMS_FOUND"]);
		end
	else
		local query = tonumber(query);
		if lastseendb.itemstgdb[query] then
			print(query .. ": " .. lastseendb.itemstgdb[query].itemLink .. " - " .. lastseendb.itemstgdb[query].lootDate .. " - " .. lastseendb.itemstgdb[query].source .. " - " .. lastseendb.itemstgdb[query].location);
		else
			print(L["ADDON_NAME"] .. L["NO_ITEMS_FOUND"]);
		end
	end
end

function lastseendb:GetItemID(itemLink)
	if select(1, GetItemInfoInstant(itemLink)) == nil then
		return 0;
	else
		return select(1, GetItemInfoInstant(itemLink));
	end
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

function lastseendb:addnameplate(unit)
	if lastseendb.creaturedb == nil then
		lastseendb.creaturedb = lastseendb:niltable(lastseendb.creaturedb);
	end
	local nameplate = C_NamePlate.GetNamePlateForUnit(unit);
	local unitframe = nameplate.UnitFrame;
	local guid = UnitGUID(unitframe:GetAttribute("unit"));
	local unitname = UnitName(unitframe:GetAttribute("unit"));
	local type, _, _, _, _, npcid, _ = strsplit("-", guid);
	if type == L["IS_CREATURE"] then
		if not lastseendb.creaturedb[npcid] then
			npcid = tonumber(npcid);
			lastseendb.creaturedb[npcid] = {unitName = unitname};
		end
	end
end

function lastseendb:lootsourceinfo()
	for i = GetNumLootItems(), 1, -1 do
		local guid = GetLootSourceInfo(i);
		local _, _, _, _, _, npcid, _ = strsplit("-", guid);
		lastseendb.lootedcreatureid = tonumber(npcid);
	end
end

function lastseendb:checkloot(msg, today, currentMap)
	if not msg then return end;
	
	local itemLooted = "";
	local wasUpdated = false;
	
	if string.match(msg, L["LOOT_ITEM_PUSHED_SELF"]) then
		itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.match(msg, L["LOOT_ITEM_SELF"]) then
		itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	else
		itemLooted = string.match(msg, "[%+%p%s](.*)[%s%p%+]");
	end
	
	if not itemLooted then return end;
	
	local mode = lastseendb.mode;
	local rarity = lastseendb.rarity;
	local itemid = lastseendb:GetItemID(itemLooted);
	local itemlink = lastseendb:GetItemLink(itemid);
	local itemName = select(1, GetItemInfo(itemid));
	local itemRarity = select(3, GetItemInfo(itemid));
	local itemType = select(6, GetItemInfo(itemid));
	
	if itemRarity >= rarity and itemType ~= L["TRADESKILL"] and not lastseendb.itemignrdb[itemid] then
		if lastseendb.itemstgdb[itemid] then
			if lastseendb.itemstgdb[itemid].itemName == nil then -- Item added using the 'add' command.
				lastseendb.itemstgdb[itemid].itemName = itemName;
				lastseendb.itemstgdb[itemid].lootDate = today;
				lastseendb.itemstgdb[itemid].source = lastseendb.lootedcreatureid;
				lastseendb.itemstgdb[itemid].location = currentMap;
				wasUpdated = true;
			elseif lastseendb.itemstgdb[itemid].lootDate ~= today then
				lastseendb.itemstgdb[itemid].lootDate = today;
				if lastseendb.itemstgdb[itemid].location ~= currentMap then
					lastseendb.itemstgdb[itemid].location = currentMap;
				end
				wasUpdated = true;
			elseif lastseendb.itemstgdb[itemid].source == "" then
				lastseendb.itemstgdb[itemid].source = lastseendb.creaturedb[lastseendb.lootedcreatureid].unitName;
				wasUpdated = true;
			elseif lastseendb.itemstgdb[itemid].location ~= currentMap and not lastseendb.isMailboxOpen then
				lastseendb.itemstgdb[itemid].location = currentMap;
				wasUpdated = true;
			end
			if wasUpdated and mode ~= 2 then
				print(lastseendb.lootedcreatureid);
				print(lastseendb.creaturedb[lastseendb.lootedcreatureid].unitName);
				print(L["ADDON_NAME"] .. L["UPDATED_ITEM"] .. itemlink .. ".");
			end
		else
			if lastseendb.isMailboxOpen then
				lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["MAIL"], location = currentMap};
			elseif lastseendb.isTradeOpen then
				lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["TRADE"], location = currentMap};
			else
				if lastseendb.creaturedb[lastseendb.lootedcreatureid] then
					lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = lastseendb.creaturedb[lastseendb.lootedcreatureid].unitName, location = currentMap};
				else
					lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = "", location = currentMap};
				end
			end
			if mode ~= 2 then
				print(lastseendb.lootedcreatureid);
				print(lastseendb.creaturedb[lastseendb.lootedcreatureid].unitName);
				print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. itemlink .. ".");
			end
		end
	end
end

if lastseendb.itemstgdb == nil then
	lastseendb.itemstgdb = lastseendb:niltable(lastseendb.itemstgdb);
end

if lastseendb.itemignrdb == nil then
	lastseendb.itemignrdb = lastseendb:niltable(lastseendb.itemignrdb);
end