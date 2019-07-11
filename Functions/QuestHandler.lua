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

lastSeenNS.LogQuestLocation = function(questID, currentMap)
	local questLink = GetQuestLink(questID);
	if LastSeenQuestsDB[questID] then
		if LastSeenQuestsDB[questID]["location"] then
			if LastSeenQuestsDB[questID]["location"] ~= currentMap then
				LastSeenQuestsDB[questID]["location"] = currentMap;
			end
		else
			LastSeenQuestsDB[questID]["location"] = currentMap;
		end
	else
		LastSeenQuestsDB[questID] = {location = currentMap, questLink = questLink};
	end
end

lastSeenNS.QuestChoices = function(questID, itemLink, today)
	local questTitle = C_QuestLog.GetQuestInfo(questID);
	local questLink = GetQuestLink(questID);
	if LastSeenQuestsDB[questID] then
		if not LastSeenQuestsDB[questID]["title"] then
			LastSeenQuestsDB[questID]["title"] = questTitle;
		end
		if LastSeenQuestsDB[questID]["completed"] ~= today then
			LastSeenQuestsDB[questID]["completed"] = today;
		end
	else
		LastSeenQuestsDB[questID] = {title = questTitle, completed = today, questLink = questLink};
	end
	if itemLink then
		itemID, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink);
		itemName, _, itemRarity = GetItemInfo(itemLink);

		if not itemID then return; -- DO NOTHING
		else
			if lastSeenNS.ignoredItemTypes[itemType] ~= nil then
				return;
			elseif lastSeenNS.ignoredItems[itemID] then
				return;
			elseif LastSeenIgnoredItemsDB[itemID] then
				return;
			end

			if itemRarity >= LastSeenSettingsCacheDB.rarity then -- Quest rewards should adhere to the same rarity standards as conventional loot.
				itemLink = select(2, GetItemInfo(itemID));
				if questTitle then
					LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["QUEST"] .. questTitle, location = LastSeenQuestsDB[questID]["location"], key = lastSeenNS.GenerateItemKey(itemID)};
				else
					LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = today, source = L["QUEST"], location = LastSeenQuestsDB[questID]["location"], key = lastSeenNS.GenerateItemKey(itemID)};
				end
				
				if lastSeenNS.mode ~= L["QUIET_MODE"] then
					if LastSeenQuestsDB[questID]["questLink"] then
						print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. " <- " .. LastSeenQuestsDB[questID]["questLink"] .. ".");
					elseif questLink then
						print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. " <- " .. questLink .. ".");
					elseif questTitle then
						print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. " <- " .. L["NO_QUEST_LINK"] .. L["QUEST"] .. questTitle);
					else
						print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ". " .. L["NO_QUEST_LINK"]);
					end
				end
			end
		end
	end
	lastSeenNS.isQuestReward = false;
end
