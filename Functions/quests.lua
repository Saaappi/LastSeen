--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all quest-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

lastSeenNS.QuestChoices = function(questID, today, currentMap)
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	if lastSeenNS.LastSeenQuests[questID] then
		lastSeenNS.hasSeenQuest = true;
		if lastSeenNS.LastSeenQuests[questID].completed ~= today then
			lastSeenNS.LastSeenQuests[questID].completed = today;
		end 
	else
		lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, location = currentMap};
	end
	local numQuestChoices = GetNumQuestChoices();
	local numQuestRewards = GetNumQuestRewards();
	
	if numQuestChoices > 0 then
		for i = 1, numQuestChoices do
			lastSeenNS.questItemType = "choice"; lastSeenNS.chosenItemLink = GetQuestItemLink(lastSeenNS.questItemType, i);
			lastSeenNS.itemName, _, _, lastSeenNS.itemRarity, _ = GetQuestItemInfo(lastSeenNS.questItemType, i);
			lastSeenNS.itemID = (({ GetItemInfoInstant(lastSeenNS.chosenItemLink) })[1] );
			lastSeenNS.itemType = (({ GetItemInfoInstant(lastSeenNS.chosenItemLink) })[2] );
			if not lastSeenNS.LastSeenItems[lastSeenNS.itemID] then
				lastSeenNS.LastSeenItems[lastSeenNS.itemID] = {itemName = lastSeenNS.itemName, itemLink = lastSeenNS.chosenItemLink, itemRarity = lastSeenNS.itemRarity, itemType = lastSeenNS.itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
			end
		end
	end
	if numQuestRewards > 0 then
		for i = 1, numQuestRewards do
			lastSeenNS.questItemType = "reward"; lastSeenNS.rewardItemLink = GetQuestItemLink(lastSeenNS.questItemType, i);
			lastSeenNS.itemName, _, _, lastSeenNS.itemRarity, _ = GetQuestItemInfo(lastSeenNS.questItemType, i);
			lastSeenNS.itemID = (({ GetItemInfoInstant(lastSeenNS.rewardItemLink) })[1] );
			lastSeenNS.itemType = (({ GetItemInfoInstant(lastSeenNS.rewardItemLink) })[2] );
			if not lastSeenNS.LastSeenItems[lastSeenNS.itemID] then
				lastSeenNS.LastSeenItems[lastSeenNS.itemID] = {itemName = lastSeenNS.itemName, itemLink = lastSeenNS.rewardItemLink, itemRarity = lastSeenNS.itemRarity, itemType = lastSeenNS.itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
			end
		end
	end
	lastSeenNS.isQuestItemReward = false;
end