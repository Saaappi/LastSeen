--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all item-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

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
	if select(6, GetItemInfoInstant(query)) == nil then
		return 0;
	else
		return select(6, GetItemInfoInstant(query));
	end
end

lastSeenNS.GetLootSourceInfo = function()
	for i = GetNumLootItems(), 1, -1 do
		local guid = GetLootSourceInfo(i);
		local _, _, _, _, _, creatureID, _ = strsplit("-", guid);
		lastSeenNS.lootedCreatureID = tonumber(creatureID);
	end
end

lastSeenNS.Loot = function(msg, today, currentMap)
	if lastSeenNS.isQuestItemReward then return end;
	
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

	if rarity <= itemRarity and lastSeenNS.ignoredItemTypes[itemType] == nil then
		if not lastSeenNS.LastSeenIgnoredItems[itemID] or not lastSeenNS.ignoredItems[itemID] then
			if lastSeenNS.LastSeenItems[itemID] then -- Item exists in the looted database.
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
					if lastSeenNS.LastSeenItems[itemID].lootDate ~= today then -- The item has been seen for the first time today.
						lastSeenNS.LastSeenItems[itemID].lootDate = today;
						lastSeenNS.wasUpdated = true;
					end
					if lastSeenNS.LastSeenItems[itemID].location ~= currentMap then -- The item has now been "last seen" on a new map.
						lastSeenNS.LastSeenItems[itemID].location = currentMap;
						lastSeenNS.wasUpdated = true;
					end
					if lastSeenNS.LastSeenItems[itemID].source == "" then -- An item added to the database prior to the existence of source tracking.
						-- do something here
					end
				end
				if lastSeenNS.wasUpdated and lastSeenNS.mode ~= L["QUIET_MODE"] then
					print(L["ADDON_NAME"] .. L["UPDATED_ITEM"] .. itemLink .. ".");
				end
			else
				if lastSeenNS.isMailboxOpen then
					lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["MAIL"], location = currentMap};
				elseif lastSeenNS.isTradeOpen then
					lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["TRADE"], location = currentMap};
				elseif lastSeenNS.isCraftedItem then
					lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_CRAFTED_ITEM"], location = currentMap};
				else
					if lastSeenNS.LastSeenCreatures[lastSeenNS.lootedCreatureID] and not lastSeenNS.isAutoLootPlusLoaded then
						lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = lastSeenNS.LastSeenCreatures[lastSeenNS.lootedCreatureID].unitName, location = currentMap};
					else
						lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = "", location = currentMap};
					end
				end
				if lastSeenNS.mode ~= L["QUIET_MODE"] then
					print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. itemLink .. ".");
				end
			end
		end
	end
end