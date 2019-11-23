--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all quest-related functions.
]]--

local lastSeen, LastSeenTbl = ...;
local L = LastSeenTbl.L;
local select = select;

local itemName;
local itemRarity;
local itemID;
local itemType;
local itemIcon;

LastSeenTbl.QuestChoices = function(questID, itemLink, currentDate)
	local questLink = GetQuestLink(questID);
	if LastSeenQuestsDB[questID] then
		if not LastSeenQuestsDB[questID]["title"] then
			LastSeenQuestsDB[questID]["title"] = questTitle;
		end
		if LastSeenQuestsDB[questID]["completed"] ~= currentDate then
			LastSeenQuestsDB[questID]["completed"] = currentDate;
		end
	else
		LastSeenQuestsDB[questID] = {completed = currentDate, questLink = questLink};
	end
	if itemLink then
		itemID, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink);
		itemName, _, itemRarity = GetItemInfo(itemLink);

		if not itemID then return; -- DO NOTHING
		else
			if LastSeenTbl.ignoredItemTypes[itemType] ~= nil then
				return;
			elseif LastSeenTbl.ignoredItems[itemID] then
				return;
			elseif LastSeenIgnoredItemsDB[itemID] then
				return;
			end

			if itemRarity >= LastSeenSettingsCacheDB.rarity then -- Quest rewards should adhere to the same rarity standards as conventional loot.
				itemLink = select(2, GetItemInfo(itemID));
				local questLocation = LastSeenQuestsDB[questID]["location"]; -- This provides a local reference to the quest's pickup location, should one exist.
				if questTitle then
					if questLocation then
						LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = currentDate, source = L["QUEST"] .. questTitle, location = questLocation, key = LastSeenTbl.GenerateItemKey(itemID)};
					else                                                                                                                              
						LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = currentDate, source = L["QUEST"] .. questTitle, location = LastSeenTbl.GetCurrentMap(), key = LastSeenTbl.GenerateItemKey(itemID)};
					end                                                                                                                               
				else                                                                                                                                  
					if questLocation then                                                                                                             
						LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = currentDate, source = L["QUEST"], location = questLocation, key = LastSeenTbl.GenerateItemKey(itemID)};
					else                                                                                                                              
						LastSeenItemsDB[itemID] = {itemName = itemName, itemLink = itemLink, itemRarity = itemRarity, itemType = itemType, lootDate = currentDate, source = L["QUEST"], location = LastSeenTbl.GetCurrentMap(), key = LastSeenTbl.GenerateItemKey(itemID)};
					end
				end
				
				if LastSeenTbl.mode ~= L["QUIET_MODE"] then
					if LastSeenQuestsDB[questID]["questLink"] then
						print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. " <- " .. LastSeenQuestsDB[questID]["questLink"] .. ".");
					elseif questLink then
						print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. " <- " .. questLink .. ".");
					elseif questTitle then
						print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. " <- " .. L["QUEST"] .. questTitle);
					else
						print(L["ADDON_NAME"] .. L["ADDED_ITEM"] .. "|T"..select(5, GetItemInfoInstant(itemID))..":0|t" .. itemLink .. ". " .. L["NO_QUEST_LINK"]);
					end
				end
			end
		end
	end
	LastSeenTbl.isQuestReward = false;
end
