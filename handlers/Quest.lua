local addonName, addonTable = ...
local frame = CreateFrame("Frame")

frame:RegisterEvent("QUEST_ACCEPTED")
frame:RegisterEvent("QUEST_LOOT_RECEIVED")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_ACCEPTED" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		-- Get the quest's ID from the payload.
		local questID = ...
		
		-- Get the player's current map to log with the quest's data.
		-- We'll use the quest's pickup map as the source map.
		local map = LastSeen:GetBestMapForUnit("player")
		if map.mapType ~= 3 or map.mapType ~= 4 then
			map = LastSeen:GetParentMap(map.mapID)
		end
		
		-- Get the quest's name using its ID.
		local title = C_QuestLog.GetTitleForQuestID(questID)
		
		-- Check if the player has seen the quest before.
		if LastSeenDB.Quests[questID] then
			-- The player has seen the quest before.
			-- Check if the last time the player saw the quest
			-- matches the current date. Also, check the quest's
			-- map to make sure it didn't...move?
			if LastSeenDB.Quests[questID].date ~= date(LastSeenDB.DateFormat) then
				LastSeenDB.Quests[questID].date = date(LastSeenDB.DateFormat)
			end
			if LastSeenDB.Quests[questID].map ~= map.name then
				LastSeenDB.Quests[questID].map = map.name
			end
		else
			-- This is a new quest.
			LastSeenDB.Quests[questID] = { title = title, map = map.name, date = date(LastSeenDB.DateFormat) }
		end
	end
	if event == "QUEST_LOOT_RECEIVED" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		-- Get the quest's ID and the item link from the payload.
		local questID, itemLink = ...
		
		-- If the item link is valid, then let's continue.
		if itemLink then
			-- Let's get some information about the item we looted.
			local itemName, _, itemRarity = GetItemInfo(itemLink)
			local itemID, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
			
			-- Make sure the item's rarity is at or above the desired
			-- rarity filter.
			if itemRarity >= LastSeenDB.rarityID then
				-- Make sure the item's type is supposed to be tracked.
				if LastSeenDB.Filters[itemType] then
					-- Let's get the source ID (it's like an ID associated to an appearance)
					-- of the item.
					local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
					
					-- If the sourceID is nil, then it's likely an item without one. Let's
					-- set it to 0 in those cases.
					if sourceID == nil then
						sourceID = 0
					end
					
					LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), LastSeenDB.Quests[questID].map, LastSeenDB.Quests[questID].title)
				else
					-- If the mode is set to Normal or Only New then print a statement
					-- to the player.
					if LastSeenDB.modeID == 1 or LastSeenDB.modeID == 2 then
						print(string.format("%s has an item type that isn't enabled or is unsupported: |cffFFD100%s|r", itemLink, itemType))
					end
				end
			end
		end
	end
end)