--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all item-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

local function New(itemID, itemName, itemLink, itemRarity, itemType, today, source, currentMap)
	LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = source, location = currentMap};
	if lastSeenNS.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ".");
	end
end

local function UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, lootDate, source, currentMap)
	if LastSeenItemsDB[itemID].manualEntry == true then -- A manually entered item has been seen!
		LastSeenItemsDB[itemID].itemName = itemName;
		LastSeenItemsDB[itemID].itemLink = itemLink;
		LastSeenItemsDB[itemID].itemType = itemType;
		LastSeenItemsDB[itemID].itemRarity = rarity;
		LastSeenItemsDB[itemID].lootDate = today;
		LastSeenItemsDB[itemID].source = lastSeenNS.lootedCreatureID;
		LastSeenItemsDB[itemID].location = currentMap;
		LastSeenItemsDB[itemID].manualEntry = nil; -- Remove the manual entry flag.
		lastSeenNS.wasUpdated = true;
	else
		if LastSeenItemsDB[itemID].lootDate ~= lootDate then -- The item has been seen for the first time today.
			LastSeenItemsDB[itemID].lootDate = lootDate;
			lastSeenNS.wasUpdated = true;
			lastSeenNS.updateReason = L["NEW_LOOT_DATE"];
		end
		if LastSeenItemsDB[itemID].location ~= currentMap then -- The item has now been "last seen" on a new map.
			LastSeenItemsDB[itemID].location = currentMap;
			lastSeenNS.wasUpdated = true;
			lastSeenNS.updateReason = L["NEW_LOCATION"];
		end
		if LastSeenItemsDB[itemID].source ~= source then
			LastSeenItemsDB[itemID].source = source;
			lastSeenNS.wasUpdated = true;
			lastSeenNS.updateReason = L["NEW_SOURCE"];
		end
	end
	if lastSeenNS.wasUpdated and lastSeenNS.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["UPDATED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ". " .. L["REASON"] .. lastSeenNS.updateReason);
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

lastSeenNS.GetItemTypeID = function(query)
	if select(12, GetItemInfo(query)) == nil then
		return 0;
	else
		return select(12, GetItemInfo(query));
	end
end

lastSeenNS.GetItemSubTypeID = function(query)
	if select(13, GetItemInfo(query)) == nil then
		return 0;
	else
		return select(13, GetItemInfo(query));
	end
end

lastSeenNS.Loot = function(msg, today, currentMap)
	if lastSeenNS.isQuestItemReward then 
		lastSeenNS.isQuestItemReward = false;
	return end;
	
	if not msg then return end;
	
	if string.find(msg, L["LOOT_ITEM_PUSHED_SELF"]) then
		lastSeenNS.itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_PUSHED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.find(msg, L["LOOT_ITEM_SELF"]) then
		lastSeenNS.itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif string.find(msg, L["LOOT_ITEM_CREATED_SELF"]) then
		lastSeenNS.itemLooted = select(3, string.find(msg, string.gsub(string.gsub(LOOT_ITEM_CREATED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
		lastSeenNS.isCraftedItem = true;
	else
		lastSeenNS.itemLooted = string.find(msg, "[%+%p%s](.*)[%s%p%+]");
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
	local itemSourceCreatureID = lastSeenNS.itemsToSource[itemID];

	if rarity <= itemRarity then
		lastSeenNS.IfExists(lastSeenNS.ignoredItemTypes, itemType);
		lastSeenNS.IfExists(LastSeenIgnoredItemsDB, itemID);
		lastSeenNS.IfExists(lastSeenNS.ignoredItems, itemID);
		if lastSeenNS.exists == false then
			if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
				if lastSeenNS.isAuctionItem then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, L["MAIL"], currentMap);
					lastSeenNS.isAuctionItem = false;
				elseif lastSeenNS.isTradeOpen then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, L["TRADE"], currentMap);
				elseif lastSeenNS.isCraftedItem then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, L["IS_CRAFTED_ITEM"], currentMap);
				elseif lastSeenNS.isMerchantWindowOpen then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, lastSeenNS.merchantName .. " (" .. L["IS_MERCHANT"] .. ")", currentMap);
				elseif itemSourceCreatureID ~= nil then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap);
				elseif lastSeenNS.lootedItem ~= "" then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, lastSeenNS.lootedItem, currentMap);
				elseif lastSeenNS.isMailboxOpen then -- DO NOTHING
				else
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, today, lastSeenNS.lootedObject, currentMap);
				end
			else -- An item seen for the first time.
				if lastSeenNS.isAuctionItem then
					New(itemID, itemName, itemLink, itemRarity, itemType, today, L["MAIL"], currentMap);
				elseif lastSeenNS.isTradeOpen then
					New(itemID, itemName, itemLink, itemRarity, itemType, today, L["TRADE"], currentMap);
				elseif lastSeenNS.isCraftedItem then
					lastSeenNS.isCraftedItem = false;
					New(itemID, itemName, itemLink, itemRarity, itemType, today, L["IS_CRAFTED_ITEM"], currentMap);
				elseif lastSeenNS.isMerchantWindowOpen then
					New(itemID, itemName, itemLink, itemRarity, itemType, today, lastSeenNS.merchantName .. " (" .. L["IS_MERCHANT"] .. ")", currentMap);
				elseif itemSourceCreatureID ~= nil then
					if LastSeenCreaturesDB[itemSourceCreatureID] and not lastSeenNS.isMailboxOpen then
						if not lastSeenNS.isAutoLootPlusLoaded then
							New(itemID, itemName, itemLink, itemRarity, itemType, today, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap);
						end
					elseif lastSeenNS.isMailboxOpen then -- DO NOTHING
					else
						print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. L["DISCORD_REPORT"]);
						New(itemID, itemName, itemLink, itemRarity, itemType, today, "N/A", currentMap);
					end
				elseif lastSeenNS.lootedItem ~= "" then
					New(itemID, itemName, itemLink, itemRarity, itemType, today, lastSeenNS.lootedItem, currentMap);
				else
					New(itemID, itemName, itemLink, itemRarity, itemType, today, lastSeenNS.lootedObject, currentMap);
				end
			end
		else
			lastSeenNS.exists = false;
		end
	end
end