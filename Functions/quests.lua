--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all quest-related functions.
]]--

local lastSeen, lastSeenNS = ...;

lastSeenNS.QuestChoices = function(questID, today, currentMap)
	if lastSeenNS.LastSeenQuests[questID] then
		lastSeenNS.hasSeenQuest = true;
	end
	local numQuestChoices = GetNumQuestChoices();
	local numQuestRewards = GetNumQuestRewards();
	local i = 1;
	
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	if numQuestChoices > 0 or numQuestRewards > 0 then
		repeat
			local chosenItemName, _, _, itemRarity, _ = GetQuestItemInfo("choice", i); -- The player chooses this item
			local rewardItemName, _, _, itemRarity, _ = GetQuestItemInfo("reward", i); -- An item that is given to the player as a reward (they do not choose it)
			if not lastSeenNS.LastSeenItems[chosenItemName].itemName or not lastSeenNS.LastSeenItems[rewardItemName] then
				lastSeenNS.LastSeenItems[itemID] = {itemName = chosenItemName, itemLink = lastSeenNS.GetItemLink(chosenItemName), itemRarity = itemRarity, itemType = lastSeenNS.GetItemType(chosenItemName), lootDate = today, source = questTitle, location = lastSeenNS.currentMap};
			end
			if lastSeenNS.hasSeenQuest then
				if lastSeenNS.LastSeenQuests[questID].completed ~= today then
					lastSeenNS.LastSeenQuests[questID].completed = today;
				end
			else
				if chosenItemName ~= nil then
					lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = {reward = chosenItemName}, location = lastSeenNS.currentMap};
				else
					lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = {reward = rewardItemName}, location = lastSeenNS.currentMap};
				end
			end
			i = i + 1;
		until i > GetNumQuestChoices();
	else
		if lastSeenNS.LastSeenQuests[questID] then
			if lastSeenNS.LastSeenQuests[questID].completed ~= today then
				lastSeenNS.LastSeenQuests[questID].completed = today;
			end
		else
			lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = 0, location = lastSeenNS.currentMap};
		end
	end
end