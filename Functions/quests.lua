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
	if (numQuestChoices > 0 and numQuestRewards > 0) or (numQuestChoices > 0 or numQuestRewards > 0) then
		print("A");
		repeat
			if numQuestChoices > 0 and numQuestRewards > 0 then
				print("B");
				local chosenItemName, _, _, itemRarity, _ = GetQuestItemInfo("choice", i); -- The player chooses this item
				local rewardItemName, _, _, itemRarity, _ = GetQuestItemInfo("reward", i); -- An item that is given to the player as a reward (they do not choose it)
			else
				print("C");
				if numQuestChoices > 0 then
					print("D");
					local chosenItemName, _, _, itemRarity, _ = GetQuestItemInfo("choice", i); -- The player chooses this item
					print(chosenItemName);
				else
					print("E");
					local rewardItemName, _, _, itemRarity, _ = GetQuestItemInfo("reward", i);
				end
			end
			if chosenItemName ~= "" then
				lastSeenNS.questItemType = "choice"; lastSeenNS.chosenItemLink = GetQuestItemLink(lastSeenNS.questItemType, i)
				lastSeenNS.chosenItemID = select(1, GetItemInfo(lastSeenNS.chosenItemLink));
				if not lastSeenNS.LastSeenItems[lastSeenNS.chosenItemID] then
					print("G");
					lastSeenNS.LastSeenItems[lastSeenNS.chosenItemID] = {itemName = chosenItemName, itemLink = lastSeenNS.chosenItemLink, itemRarity = itemRarity, itemType = select(6, GetItemInfo(lastSeenNS.chosenItemID)), lootDate = today, source = questTitle, location = currentMap};
				end
			elseif rewardItemName ~= "" then
				print("H");
				lastSeenNS.rewardItemID = select(1, GetItemInfo(rewardItemName));
				if not lastSeenNS.LastSeenItems[lastSeenNS.rewardItemID] then
					print("I");
					lastSeenNS.LastSeenItems[lastSeenNS.rewardItemID] = {itemName = rewardItemName, itemLink = GetQuestItemLink(lastSeenNS.questItemType, i), itemRarity = itemRarity,
					itemType = select(6, GetItemInfo(lastSeenNS.rewardItemID)), lootDate = today, source = questTitle, location = currentMap};
				end
			end
			if lastSeenNS.hasSeenQuest then -- Rewards are assumed to remain the same. If a quest redesign is rumored, I will change this.
				if lastSeenNS.LastSeenQuests[questID].completed ~= today then
					lastSeenNS.LastSeenQuests[questID].completed = today;
				end
			else
				if chosenItemName ~= "" then
					lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = {reward = chosenItemName}, location = currentMap};
				end
				if rewardItemName ~= "" then
					lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = {reward = rewardItemName}, location = currentMap};
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
			lastSeenNS.LastSeenQuests[questID] = {title = questTitle, completed = today, rewards = 0, location = currentMap};
		end
	end
	lastSeenNS.isQuestItemReward = false;
end