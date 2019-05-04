--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all item-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

local function New(itemID, itemName, itemLink, itemRarity, itemType, today, source, currentMap)
	lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = source, location = currentMap};
	if lastSeenNS.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. itemLink .. ".");
	end
end

local function UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, lootDate, source, currentMap)
	if lastSeenNS.LastSeenItems[itemID].manualEntry == true then -- A manually entered item has been seen!
		lastSeenNS.LastSeenItems[itemID].itemName = itemName;
		lastSeenNS.LastSeenItems[itemID].itemLink = itemLink;
		lastSeenNS.LastSeenItems[itemID].itemType = itemType;
		lastSeenNS.LastSeenItems[itemID].itemRarity = rarity;
		lastSeenNS.LastSeenItems[itemID].lootDate = today;
		lastSeenNS.LastSeenItems[itemID].source = lastSeenNS.lootedCreatureID;
		lastSeenNS.LastSeenItems[itemID].location = currentMap;
		lastSeenNS.LastSeenItems[itemID].manualEntry = nil; -- Remove the manual entry flag.
		lastSeenNS.wasUpdated = true;
	else
		if lastSeenNS.LastSeenItems[itemID].lootDate ~= lootDate then -- The item has been seen for the first time today.
			lastSeenNS.LastSeenItems[itemID].lootDate = lootDate;
			lastSeenNS.wasUpdated = true;
			lastSeenNS.updateReason = L["NEW_LOOT_DATE"];
		end
		if lastSeenNS.LastSeenItems[itemID].location ~= currentMap then -- The item has now been "last seen" on a new map.
			lastSeenNS.LastSeenItems[itemID].location = currentMap;
			lastSeenNS.wasUpdated = true;
			lastSeenNS.updateReason = L["NEW_LOCATION"];
		end
		if itemSourceID ~= nil then
			if lastSeenNS.LastSeenItems[itemID].source ~= lastSeenNS.LastSeenCreatures[itemSourceID].unitName then
				lastSeenNS.LastSeenItems[itemID].source = lastSeenNS.LastSeenCreatures[itemSourceID].unitName;
				lastSeenNS.wasUpdated = true;
				lastSeenNS.updateReason = L["NEW_SOURCE"];
			end
		end
	end
	if lastSeenNS.wasUpdated and lastSeenNS.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["UPDATED_ITEM"] .. itemLink .. ". " .. L["REASON"] .. lastSeenNS.updateReason);
		lastSeenNS.wasUpdated = false;
		lastSeenNS.updateReason = "";
	end
end

lastSeenNS.GetItemID = function(query)
	if select(1, GetItemInfoInstant(query)) == nil then
		return 0;
	else
		return select(1, GetItemInfoInstant(query));
	end
end

lastSeenNS.GetItemLink = function(query)
	if select(2, GetItemInfo(query)) == nil then
		return "";
	else
		return select(2, GetItemInfo(query));
	end
end

lastSeenNS.GetItemType = function(query)
	if select(2, GetItemInfoInstant(query)) == nil then
		return 0;
	else
		return select(2, GetItemInfoInstant(query));
	end
end

lastSeenNS.GetLootSourceInfo = function()
	local lootSlots = GetNumLootItems();
	if lootSlots < 1 then return end;
	
	for i = 1, lootSlots do
		local itemLink = GetLootSlotLink(i);
		local lootSources = { GetLootSourceInfo(i) };
		
		if itemLink then
			for j = 1, #lootSources, 2 do
				local itemID = lastSeenNS.GetItemID(itemLink);
				local _, _, _, _, _, creatureID, _ = strsplit("-", lootSources[j]);
				lastSeenNS.itemsToSource[itemID] = tonumber(creatureID);
			end
		end
	end
end

lastSeenNS.Loot = function(msg, today, currentMap)
	if lastSeenNS.isQuestItemReward then 
		lastSeenNS.isQuestItemReward = false;
		return;
	end
	
	if not msg then return end;
	
	if string.match(msg, L["LOOT_ITEM_PUSHED_SELF"]) then
		lastSeenNS.itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.match(msg, L["LOOT_ITEM_SELF"]) then
		lastSeenNS.itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.match(msg, L["LOOT_ITEM_CREATED_SELF"]) then
		lastSeenNS.itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_CREATED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
		lastSeenNS.isCraftedItem = true;
	else
		lastSeenNS.itemLooted = string.match(msg, "[%+%p%s](.*)[%s%p%+]");
	end
	
	if not lastSeenNS.itemLooted then return end;
	
	if lastSeenNS.GetItemID(lastSeenNS.itemLooted) == 0 then return end;
	
	local mode = lastSeenNS.mode;
	local rarity = lastSeenNS.rarity;
	local itemID = lastSeenNS.GetItemID(lastSeenNS.itemLooted);
	local itemLink = lastSeenNS.GetItemLink(itemID);
	local itemName = select(1, GetItemInfo(itemID));
	local itemRarity = select(3, GetItemInfo(itemID));
	local itemType = lastSeenNS.GetItemType(itemID);
	local itemSourceID = lastSeenNS.itemsToSource[itemID];

	if rarity <= itemRarity then
		lastSeenNS.IfExists(lastSeenNS.ignoredItemTypes, itemType);
		lastSeenNS.IfExists(lastSeenNS.LastSeenIgnoredItems, itemID);
		lastSeenNS.IfExists(lastSeenNS.ignoredItems, itemID);
		if lastSeenNS.exists == false then
			if lastSeenNS.LastSeenItems[itemID] then -- This is an update situation because the item has been looted before.
				if lastSeenNS.isMailboxOpen then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, L["MAIL"], currentMap);
				elseif lastSeenNS.isTradeOpen then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, L["TRADE"], currentMap);
				elseif lastSeenNS.isCraftedItem then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, L["IS_CRAFTED_ITEM"], currentMap);
				else
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, lastSeenNS.LastSeenCreatures[itemSourceID].unitName, currentMap);
				end
			else -- This is a new item that was seen for the first time.
				if lastSeenNS.isMailboxOpen then
					New(itemID, itemName, itemLink, itemRarity, itemType, today, L["MAIL"], currentMap);
				elseif lastSeenNS.isTradeOpen then
					New(itemID, itemName, itemLink, itemRarity, itemType, today, L["TRADE"], currentMap);
				elseif lastSeenNS.isCraftedItem then
					New(itemID, itemName, itemLink, itemRarity, itemType, today, L["IS_CRAFTED_ITEM"], currentMap);
				else
					if lastSeenNS.LastSeenCreatures[itemSourceID] and not lastSeenNS.isAutoLootPlusLoaded then
						New(itemID, itemName, itemLink, itemRarity, itemType, today, lastSeenNS.LastSeenCreatures[itemSourceID].unitName, currentMap);
					else
						New(itemID, itemName, itemLink, itemRarity, itemType, today, "N/A", currentMap);
					end
				end
			end
		else
			lastSeenNS.exists = false;
		end
	end
end