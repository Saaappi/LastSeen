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
		lastseendb.itemstgdb[itemid] = {itemName = "", itemLink = "", itemRarity = "", itemType = "", lootDate = "", source = "", location = "", manualEntry = true};
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
				if v.itemLink == "" then
					print(k .. ": " .. v.itemName .. " - " .. v.lootDate .. " - " .. v.source .. " (" .. v.location .. ")");
				else
					print(k .. ": " .. v.itemLink .. " - " .. v.lootDate .. " - " .. v.source .. " (" .. v.location .. ")");
				end
				itemsFound = itemsFound + 1;
			end
		end
		if itemsFound == 0 then
			print(L["ADDON_NAME"] .. L["NO_ITEMS_FOUND"]);
		end
	else
		local query = tonumber(query);
		if lastseendb.itemstgdb[query] then
			print(query .. ": " .. lastseendb.itemstgdb[query].itemLink .. " - " .. lastseendb.itemstgdb[query].lootDate .. " - " .. lastseendb.itemstgdb[query].source .. " (" .. lastseendb.itemstgdb[query].location .. ")");
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

function lastseendb:GetItemType(itemID)
	if select(2, GetItemInfoInstant(itemID)) == nil then
		return 0;
	else
		return select(2, GetItemInfoInstant(itemID));
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

function lastseendb:addcreaturebymouseover(unit)
	if lastseendb.creaturedb == nil then
		lastseendb.creaturedb = lastseendb:niltable(lastseendb.creaturedb);
	end
	if UnitGUID(unit) ~= nil then
		local guid = UnitGUID(unit);
		local type, _, _, _, _, npcid, _ = strsplit("-", guid);
		if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
			local unitname = UnitName(unit);
			if not lastseendb.creaturedb[npcid] and not UnitIsFriend(unit, "player") then
				npcid = tonumber(npcid);
				lastseendb.creaturedb[npcid] = {unitName = unitname};
			end
		end
	end
end

function lastseendb:addcreaturebynameplate(unit)
	if lastseendb.creaturedb == nil then
		lastseendb.creaturedb = lastseendb:niltable(lastseendb.creaturedb);
	end
	local nameplate = C_NamePlate.GetNamePlateForUnit(unit);
	local unitframe = nameplate.UnitFrame;
	local guid = UnitGUID(unitframe:GetAttribute("unit"));
	local unitname = UnitName(unitframe:GetAttribute("unit"));
	local type, _, _, _, _, npcid, _ = strsplit("-", guid);
	if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
		if not lastseendb.creaturedb[npcid] and not UnitIsFriend(unit, "player") then
			npcid = tonumber(npcid);
			lastseendb.creaturedb[npcid] = {unitName = unitname};
		end
	end
end

function lastseendb:lootsourceinfo()
	for i = GetNumLootItems(), 1, -1 do
		local guid1 = GetLootSourceInfo(i);
		local _, _, _, _, _, npcid, _ = strsplit("-", guid1);
		lastseendb.lootedcreatureid = tonumber(npcid);
	end
end

function lastseendb:questChoices(questID, today, currentMap)
	local hasSeenQuest = false;
	if lastseendb.questdb[questID] then
		hasSeenQuest = true;
	end
	local numQuestChoices = GetNumQuestChoices();
	local i = 1;
	
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	if numQuestChoices > 0 then
		repeat
			local chosenItemName, _, _, _, _ = GetQuestItemInfo("choice", i); -- The player chooses this item
			print("CHOSEN " .. chosenItemName);
			local rewardItemName, _, _, _, _ = GetQuestItemInfo("reward", i); -- An item that is given to the player as a reward (they do not choose it)
			print("REWARDED " .. rewardItemName);
			--[[if not lastseendb:search(itemName) then
				lastseendb.itemstgdb[itemID] = {itemName = itemName, itemLink = lastseendb:GetItemLink(itemID), itemRarity = itemRarity, itemType = lastseendb:GetItemType(itemID), lootDate = today, source = questTitle, location = currentMap};
			end]]--
			--print(questTitle .. " has been completed. Here's some info:" .. "\n" .. itemID .. ": " .. itemName .. " (" .. itemRarity .. ")");
			if hasSeenQuest then
				if lastseendb.questdb[questID].completed ~= today then
					lastseendb.questdb[questID].completed = today;
				end
			else
				if chosenItemName ~= nil then
					lastseendb.questdb[questID] = {title = questTitle, completed = today, rewards = {reward = chosenItemName}, location = currentMap};
				else
					lastseendb.questdb[questID] = {title = questTitle, completed = today, rewards = {reward = rewardItemName}, location = currentMap};
				end
			end
			i = i + 1;
		until i > GetNumQuestChoices();
	else
		if lastseendb.questdb[questID] then
			if lastseendb.questdb[questID].completed ~= today then
				lastseendb.questdb[questID].completed = today;
			end
		else
			lastseendb.questdb[questID] = {title = questTitle, completed = today, rewards = 0, location = currentMap};
		end
	end
end

function lastseendb:checkloot(msg, today, currentMap)
	--[[if lastseendb.isQuestItemReward then
		lastseendb.isQuestItemReward = false;
		return 0;
	end]]--
	if not msg then return end;
	
	local itemLooted = "";
	local wasUpdated = false;
	
	if string.match(msg, L["LOOT_ITEM_PUSHED_SELF"]) then
		itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.match(msg, L["LOOT_ITEM_SELF"]) then
		itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.match(msg, L["LOOT_ITEM_CREATED_SELF"]) then
		itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_CREATED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
		lastseendb.isCraftedItem = true;
	else
		itemLooted = string.match(msg, "[%+%p%s](.*)[%s%p%+]");
	end
	
	if not itemLooted then return end;
	
	if lastseendb:GetItemID(itemLooted) == 0 then return end;
	
	local mode = lastseendb.mode;
	local rarity = lastseendb.rarity;
	local itemid = lastseendb:GetItemID(itemLooted);
	local itemlink = lastseendb:GetItemLink(itemid);
	local itemName = select(1, GetItemInfo(itemid));
	local itemRarity = select(3, GetItemInfo(itemid));
	local itemType = select(6, GetItemInfo(itemid));

	if itemRarity >= rarity and not lastseendb.ignoredItemTypes[itemType] and (not lastseendb.itemignrdb[itemid] or not lastseendb.ignoredItems[itemid]) then
		if lastseendb.itemstgdb[itemid] then -- Item exists in the looted database.
			if lastseendb.itemstgdb[itemid].manualEntry == true then -- A manually entered item has been seen!
				lastseendb.itemstgdb[itemid].itemName = itemName;
				lastseendb.itemstgdb[itemid].itemLink = itemlink;
				lastseendb.itemstgdb[itemid].itemType = itemType;
				lastseendb.itemstgdb[itemid].itemRarity = rarity;
				lastseendb.itemstgdb[itemid].lootDate = today;
				lastseendb.itemstgdb[itemid].source = lastseendb.lootedcreatureid;
				lastseendb.itemstgdb[itemid].location = currentMap;
				lastseendb.itemstgdb[itemid].manualEntry = nil; -- Remove the manual entry flag.
				wasUpdated = true;
			else
				if lastseendb.itemstgdb[itemid].lootDate ~= today then -- The item has been seen for the first time today.
					lastseendb.itemstgdb[itemid].lootDate = today;
					wasUpdated = true;
				end
				if lastseendb.itemstgdb[itemid].location ~= currentMap then -- The item has now been "last seen" on a new map.
					lastseendb.itemstgdb[itemid].location = currentMap;
					wasUpdated = true;
				end
				if lastseendb.itemstgdb[itemid].source == "" then -- An item added to the database prior to the existence of source tracking.
					-- do something here
				end
			end
			if wasUpdated and mode ~= L["QUIET_MODE"] then
				print(L["ADDON_NAME"] .. L["UPDATED_ITEM"] .. itemlink .. ".");
			end
		else
			if lastseendb.isMailboxOpen then
				lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["MAIL"], location = currentMap};
			elseif lastseendb.isTradeOpen then
				lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["TRADE"], location = currentMap};
			elseif lastseendb.isCraftedItem then
				lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_CRAFTED_ITEM"], location = currentMap};
			else
				if lastseendb.creaturedb[lastseendb.lootedcreatureid] and not lastseendb.autolootplus then
					lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = lastseendb.creaturedb[lastseendb.lootedcreatureid].unitName, location = currentMap};
				else
					lastseendb.itemstgdb[itemid] = {itemName = itemName, itemLink = itemlink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = "", location = currentMap};
				end
			end
			if mode ~= L["QUIET_MODE"] then
				print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. itemlink .. ".");
			end
		end
	end
end

function lastseendb:niltable(t)
	t = {};
	return t;
end

function lastseendb:validatetable(t)
	for k,v in pairs(t) do
		if v.source == nil then
			v.source = "";
			v.itemLink = "";
			v.itemType = "";
			v.itemRarity = 0;
		end
	end
	return t;
end

if lastseendb.itemstgdb == nil then
	lastseendb.itemstgdb = lastseendb:niltable(lastseendb.itemstgdb);
end

if lastseendb.itemignrdb == nil then
	lastseendb.itemignrdb = lastseendb:niltable(lastseendb.itemignrdb);
end

if lastseendb.questdb == nil then 
	lastseendb.questdb = lastseendb:niltable(lastseendb.questdb);
end