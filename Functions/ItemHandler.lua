--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all item-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;
local select = select;

lastSeenNS.New = function(itemID, itemName, itemLink, itemRarity, itemType, today, source, currentMap)
	LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = source, location = currentMap};
	if lastSeenNS.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ".");
	end
end

lastSeenNS.Update = function(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, lootDate, source, location)
	if LastSeenItemsDB[itemID].manualEntry == true then -- A manually entered item has been seen!
		LastSeenItemsDB[itemID].itemName = itemName;
		LastSeenItemsDB[itemID].itemLink = itemLink;
		LastSeenItemsDB[itemID].itemType = itemType;
		LastSeenItemsDB[itemID].itemRarity = itemRarity;
		LastSeenItemsDB[itemID].lootDate = lootDate;
		LastSeenItemsDB[itemID].source = source;
		LastSeenItemsDB[itemID].location = location;
		LastSeenItemsDB[itemID].manualEntry = nil; -- Remove the manual entry flag.
		lastSeenNS.wasUpdated = true;
	else
		for v in pairs(LastSeenItemsDB[itemID]) do
			if v == "lootDate" then if LastSeenItemsDB[itemID][v] ~= lootDate then LastSeenItemsDB[itemID][v] = lootDate; lastSeenNS.wasUpdated = true; end; end
			if v == "location" then if LastSeenItemsDB[itemID][v] ~= location then LastSeenItemsDB[itemID][v] = location; lastSeenNS.wasUpdated = true; end; end
			if v == "source" then if LastSeenItemsDB[itemID][v] ~= source then LastSeenItemsDB[itemID][v] = source; lastSeenNS.wasUpdated = true; end; end
		end
	end
	if lastSeenNS.wasUpdated and lastSeenNS.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["UPDATED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ".");
		lastSeenNS.wasUpdated = false;
	end
end

lastSeenNS.LootDetected = function(constant, currentDate, currentMap, itemSource)
	if not constant then return end; -- If the passed constant is nil, then simply return to avoid error.
	
	local link;
	-- The item passed isn't a looted item, but a received item from something else.
	-- Let's figure out what that source is.
	if itemSource == L["IS_QUEST_ITEM"] then -- Quest Item
		-- The item received was a quest reward and shouldn't be handled by the ItemHandler.
		lastSeenNS.QuestChoices(lastSeenNS.questID, lastSeenNS.itemLink, currentDate, currentMap);
		return;
	elseif itemSource == L["MAIL"] then -- Mailbox Item
		link = lastSeenNS.ExtractItemLink(constant);
		local isAuctionItem = true;
	else
		link = lastSeenNS.ExtractItemLink(constant); -- Just an item looted from a creature. Simple; classic.
	end
	
	if not link then return end; -- To handle edge cases. $%&! these things.
	if select(1, GetItemInfoInstant(link)) == 0 then return end; -- This is here for items like pet cages.
	
	local itemID = select(1, GetItemInfoInstant(link));
	local itemLink = select(2, GetItemInfo(itemID));
	local itemName = select(1, GetItemInfo(itemID));
	local itemRarity = select(3, GetItemInfo(itemID));
	local itemType = select(6, GetItemInfo(itemID));
	local itemSourceCreatureID = lastSeenNS.itemsToSource[itemID];
	
	if itemRarity >= LastSeenSettingsCacheDB.rarity then
		lastSeenNS.IfExists(lastSeenNS.ignoredItemTypes, itemType);
		lastSeenNS.IfExists(LastSeenIgnoredItemsDB, itemID);
		lastSeenNS.IfExists(lastSeenNS.ignoredItems, itemID);
		if lastSeenNS.exists == false then
			if LastSeenItemsDB[itemID] then -- This is an update situation because the item has been looted before.
				if isAuctionItem then
					lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, L["AUCTION"], currentMap);
				elseif lastSeenNS.isTradeOpen then
					lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, L["TRADE"], currentMap);
				elseif lastSeenNS.isCraftedItem then
					lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, L["IS_CRAFTED_ITEM"], currentMap);
				elseif lastSeenNS.isMerchantWindowOpen then
					lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, lastSeenNS.merchantName, currentMap);
				elseif itemSourceCreatureID ~= nil then
					lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap);
				elseif lastSeenNS.lootedItem ~= "" then
					lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, lastSeenNS.lootedItem, currentMap);
				elseif lastSeenNS.isMailboxOpen then
					lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, LastSeenItemsDB[itemID].lootDate, lastSeenNS.lootedItem, LastSeenItemsDB[itemID].location);
				end
			else -- An item seen for the first time.
				if isAuctionItem then
					lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, L["AUCTION"], currentMap);
				elseif lastSeenNS.isTradeOpen then
					lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, L["TRADE"], currentMap);
				elseif lastSeenNS.isCraftedItem then
					lastSeenNS.isCraftedItem = false;
					lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, L["IS_CRAFTED_ITEM"], currentMap);
				elseif lastSeenNS.isMerchantWindowOpen then
					lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, lastSeenNS.merchantName, currentMap);
				elseif itemSourceCreatureID ~= nil then
					if LastSeenCreaturesDB[itemSourceCreatureID] and not lastSeenNS.isMailboxOpen then
						if not lastSeenNS.isAutoLootPlusLoaded then
							lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap);
						end
					elseif lastSeenNS.isMailboxOpen then -- DO NOTHING
					else
						print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. L["DISCORD_REPORT"]);
						lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, "N/A", currentMap);
					end
				elseif lastSeenNS.lootedItem ~= "" then
					lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, lastSeenNS.lootedItem, currentMap);
				end
			end
		else
			lastSeenNS.exists = false;
		end
	end
	isAuctionItem = false;
	lastSeenNS.isCraftedItem = false;
	lastSeenNS.lootedItem = "";
end