--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all item-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;
local select = select;

local function New(itemID, itemName, itemLink, itemRarity, itemType, today, source, currentMap)
	LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = source, location = currentMap};
	if lastSeenNS.mode ~= L["QUIET_MODE"] then
		print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ".");
	end
end

local function UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, lootDate, source, location)
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

local function ExtractItemLink(constant)
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

lastSeenNS.LootDetected = function(constant, currentDate, currentMap, itemSource)
	if not constant then return end; -- If the passed constant is nil, then simply return to avoid error.
	
	local link;
	-- The item passed isn't a looted item, but a received item from something else.
	-- Let's figure out what that source is.
	if itemSource == L["IS_QUEST_ITEM"] then -- Quest Item
		-- The item received was a quest reward and shouldn't be handled by the ItemHandler.
		lastSeenNS.QuestChoices(lastSeenNS.questID, lastSeenNS.itemLink, currentDate, currentMap);
		return;
	elseif itemSource == L["IS_OBJECT"] then -- Object Item
		link = ExtractItemLink(constant);
		local isObjectItem = true;
	elseif itemSource == L["MAIL"] then -- Mailbox Item
		link = ExtractItemLink(constant);
		local isAuctionItem = true;
	else
		link = ExtractItemLink(constant); -- Just an item looted from a creature. Simple; classic.
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
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, L["MAIL"], currentMap);
				elseif lastSeenNS.isTradeOpen then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, L["TRADE"], currentMap);
				elseif lastSeenNS.isCraftedItem then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, L["IS_CRAFTED_ITEM"], currentMap);
				elseif lastSeenNS.isMerchantWindowOpen then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, lastSeenNS.merchantName, currentMap);
				elseif itemSourceCreatureID ~= nil then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap);
				elseif lastSeenNS.lootedItem ~= "" then
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, lastSeenNS.lootedItem, currentMap);
				elseif lastSeenNS.isMailboxOpen then -- DO NOTHING
				else
					local coords = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit(L["IS_PLAYER"]), L["IS_PLAYER"]);
					UpdateItem(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, lastSeenNS.lootedObject, currentMap .. " (" .. lastSeenNS.Round(coords, 4) .. ")");
				end
			else -- An item seen for the first time.
				if isAuctionItem then
					New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, L["MAIL"], currentMap);
				elseif lastSeenNS.isTradeOpen then
					New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, L["TRADE"], currentMap);
				elseif lastSeenNS.isCraftedItem then
					lastSeenNS.isCraftedItem = false;
					New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, L["IS_CRAFTED_ITEM"], currentMap);
				elseif lastSeenNS.isMerchantWindowOpen then
					New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, lastSeenNS.merchantName, currentMap);
				elseif itemSourceCreatureID ~= nil then
					if LastSeenCreaturesDB[itemSourceCreatureID] and not lastSeenNS.isMailboxOpen then
						if not lastSeenNS.isAutoLootPlusLoaded then
							New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, LastSeenCreaturesDB[itemSourceCreatureID].unitName, currentMap);
						end
					elseif lastSeenNS.isMailboxOpen then -- DO NOTHING
					else
						print(L["ADDON_NAME"] .. L["UNABLE_TO_DETERMINE_SOURCE"] .. L["DISCORD_REPORT"]);
						New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, "N/A", currentMap);
					end
				elseif lastSeenNS.lootedItem ~= "" then
					New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, lastSeenNS.lootedItem, currentMap);
				elseif isObjectItem then
					local coords = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit(L["IS_PLAYER"]), L["IS_PLAYER"]);
					New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, lastSeenNS.lootedObject, currentMap .. " (" .. lastSeenNS.Round(coords, 4) .. ")");
				end
			end
		else
			lastSeenNS.exists = false;
		end
	end
	isAuctionItem = false;
	isObjectItem = false;
	lastSeenNS.isCraftedItem = false;
end