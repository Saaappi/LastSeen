--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all quest-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;
local itemName = "";
local itemRarity = 0;
local itemID = 0;

lastSeenNS.QuestChoices = function(questID, today, currentMap)
	if lastSeenNS.LastSeenQuests[questID] then
		lastSeenNS.hasSeenQuest = true;
	end
	local numQuestChoices = GetNumQuestChoices();
	local numQuestRewards = GetNumQuestRewards();
	local i = 1;
	
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	if (numQuestChoices > 0 and numQuestRewards > 0) or (numQuestChoices > 0 or numQuestRewards > 0) then
		repeat
			if chosenItemName ~= "" then
				lastSeenNS.questItemType = "choice"; lastSeenNS.chosenItemLink = GetQuestItemLink(lastSeenNS.questItemType, i);
				itemName, _, _, itemRarity, _, itemID = GetQuestLogRewardInfo(i, questID);
				if not lastSeenNS.LastSeenItems[itemID] then
					lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = lastSeenNS.chosenItemLink, itemRarity = itemRarity, itemType = "", lootDate = today, source = L["IS_QUEST_ITEM"] .. " (" .. questTitle .. ")", location = currentMap};
				end
			elseif rewardItemName ~= "" then
				lastSeenNS.questItemType = "reward"; lastSeenNS.rewardItemLink = GetQuestItemLink(lastSeenNS.questItemType, i);
				itemName, _, _, itemRarity, _, itemID = GetQuestItemInfo(lastSeenNS.questItemType, i);
				if not lastSeenNS.LastSeenItems[itemID] then
					lastSeenNS.LastSeenItems[itemID] = {itemName = itemName, itemLink = lastSeenNS.rewardItemLink, itemRarity = itemRarity, itemType = "", lootDate = today, source = L["IS_QUEST_ITEM"] .. " (" .. questTitle .. ")", location = currentMap};
				end
			end
			if lastSeenNS.hasSeenQuest then -- Rewards are assumed to remain the same. If a quest redesign is rumored, I will change this.
				if lastSeenNS.LastSeenQuests[questID].completed ~= today then
					lastSeenNS.LastSeenQuests[questID].completed = today;
				end
			else
				if chosenItemName ~= "" then
					lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, location = currentMap};
				end
				if rewardItemName ~= "" then
					lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, location = currentMap};
				end
			end
			i = i + 1;
		until (i > numQuestChoices and i > numQuestRewards);
	else
		if lastSeenNS.LastSeenQuests[questID] then
			if lastSeenNS.LastSeenQuests[questID].completed ~= today then
				lastSeenNS.LastSeenQuests[questID].completed = today;
			end
		else
			lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, location = currentMap};
		end
	end
	lastSeenNS.isQuestItemReward = false;
end