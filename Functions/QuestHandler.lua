--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all quest-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;
local select = select;

local itemName;
local itemRarity;
local itemID;
local itemType;
local itemIcon;

lastSeenNS.QuestChoices = function(questID, itemLink, today, currentMap)
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	if LastSeenQuestsDB[questID] then
		if LastSeenQuestsDB[questID].completed ~= today then
			LastSeenQuestsDB[questID].completed = today;
		end 
	else
		LastSeenQuestsDB[questID] = {title = questTitle, completed = today, location = currentMap};
	end
	if itemLink then
		itemID, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink);
		itemName, _, itemRarity = GetItemInfo(itemLink);
		
		if not itemID then return; -- DO NOTHING
		else
			lastSeenNS.IfExists(lastSeenNS.ignoredItemTypes, itemType);
			lastSeenNS.IfExists(LastSeenIgnoredItemsDB, itemID);
			lastSeenNS.IfExists(lastSeenNS.ignoredItems, itemID);
			
			if lastSeenNS.exists == false then -- This item isn't ignored by the player or by LastSeen.
				if itemRarity >= LastSeenSettingsCacheDB.rarity then -- Quest rewards should adhere to the same rarity standards as conventional loot.
					itemLink = select(2, GetItemInfo(itemID));
					LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = questTitle, location = currentMap};
				end
			else
				lastSeenNS.exists = false;
			end
		end
	end
end