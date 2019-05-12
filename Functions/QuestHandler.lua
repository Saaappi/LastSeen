--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all quest-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

local questItemType;
local itemName;
local itemRarity;
local itemID;
local itemType;
local itemIcon;
local itemLink;

lastSeenNS.QuestChoices = function(questID, today, currentMap)
	lastSeenNS.isQuestItemReward = true;
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	if LastSeenQuestsDB[questID] then
		if LastSeenQuestsDB[questID].completed ~= today then
			LastSeenQuestsDB[questID].completed = today;
		end 
	else
		LastSeenQuestsDB[questID] = {title = questTitle, completed = today, location = currentMap};
	end
	if GetNumQuestLogRewards(questID) > 0 then
		local numQuestLogRewards = GetNumQuestLogRewards(questID);
		for i = 1, numQuestLogRewards do
			itemName, itemIcon, _, itemRarity, _, itemID = GetQuestLogRewardInfo(i, questID);
			
			if not itemID then
				-- DO NOTHING
			else
				itemType = lastSeenNS.GetItemType(itemID);
			
				lastSeenNS.IfExists(lastSeenNS.ignoredItemTypes, itemType);
				lastSeenNS.IfExists(LastSeenIgnoredItemsDB, itemID);
				lastSeenNS.IfExists(lastSeenNS.ignoredItems, itemID);
				
				if lastSeenNS.exists == false then -- This item isn't ignored by the player or by LastSeen.
					itemLink = lastSeenNS.GetItemLink(itemID);
					LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
				else
					lastSeenNS.exists = false;
				end
			end
		end
	end
end