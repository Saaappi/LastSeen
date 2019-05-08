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
local icon;
local itemLink;

lastSeenNS.QuestChoices = function(questID, today, currentMap)
	lastSeenNS.isQuestItemReward = true;
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
			questItemType = "choice"; local chosenItemLink = GetQuestItemLink(questItemType, i);
			itemName, _, _, itemRarity, _ = GetQuestItemInfo(questItemType, i);
			itemID = (({ GetItemInfoInstant(chosenItemLink) })[1] );
			itemType = (({ GetItemInfoInstant(chosenItemLink) })[2] );
			if not lastSeenNS.LastSeenItems[itemID] then
				lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = chosenItemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
			else -- Update logic
				lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = chosenItemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
			end
		end
	end
	if numQuestRewards > 0 then
		for i = 1, numQuestRewards do
			questItemType = "reward"; local rewardItemLink = GetQuestItemLink(questItemType, i);
			itemName, _, _, itemRarity, _ = GetQuestItemInfo(questItemType, i);
			itemID = (({ GetItemInfoInstant(rewardItemLink) })[1] );
			itemType = (({ GetItemInfoInstant(rewardItemLink) })[2] );
			if not lastSeenNS.LastSeenItems[itemID] then
				lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = rewardItemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
			else -- Update logic
				lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = rewardItemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
			end
		end
	end
	if GetNumQuestLogRewards(questID) > 0 then
		itemName, icon, _, itemRarity, _, itemID = GetQuestLogRewardInfo(1, questID);
		if not itemID then return end;
		
		itemType = lastSeenNS.GetItemType(itemID);
		
		lastSeenNS.IfExists(lastSeenNS.ignoredItemTypes, itemType);
		lastSeenNS.IfExists(lastSeenNS.LastSeenIgnoredItems, itemID);
		lastSeenNS.IfExists(lastSeenNS.ignoredItems, itemID);
		
		if lastSeenNS.exists == false then
			itemLink = lastSeenNS.GetItemLink(itemID);
			if not lastSeenNS.LastSeenItems[itemID] then
				lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
			else -- Update logic
				lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["IS_QUEST_ITEM"] .. "(" .. questTitle .. ")", location = currentMap};
			end
		else
			lastSeenNS.exists = false;
		end
	end
end