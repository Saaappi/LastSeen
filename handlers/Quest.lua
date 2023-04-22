local addonName, addonTable = ...
local frame = CreateFrame("Frame")
local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"

local function Check(var, name, reason)
	-- Determine if the data in the variable is legitimate or
	-- not. If not legitimate, then return an empty string so
	-- nil isn't stored in the Items table.
	if var then
		return var
	else
		print(coloredAddOnName .. ": " .. name .. " is unavailable." .. " " .. reason)
		return ""
	end
end

local function QuestItem(type, index, questID)
	local itemName, itemIcon, _, _, _, itemID = GetQuestItemInfo(type, index); itemID = tonumber(itemID)
	local _, itemLink, itemRarity, _, _, itemType = GetItemInfo(itemID)
	
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
			
			LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), LastSeenDB.Quests[questID].map, LastSeenDB.Quests[questID].questLink)
		else
			-- If the player loots an item that has a type that LastSeen doesn't have a filter for,
			-- then inform the player of the situation.
			if LastSeenDB.Filters[itemType] == nil then
				print(string.format("%s has an item type that is unsupported: |cffFFD100%s|r", itemLink, itemType))
			end
		end
	end
end

frame:RegisterEvent("QUEST_ACCEPTED")
frame:RegisterEvent("QUEST_COMPLETE")
frame:RegisterEvent("QUEST_LOOT_RECEIVED")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_ACCEPTED" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		-- Get the quest's ID from the payload.
		local questID = ...
		
		if questID then
			-- Get the quest's name using its ID.
			local title = C_QuestLog.GetTitleForQuestID(questID)
			
			-- Get the quest's link using its ID.
			local questLink = GetQuestLink(questID)
			
			local vars = {}
			vars["title"] = Check(title, "title", "You'll need to abandon the quest and accept it again.")
			vars["questLink"] = Check(questLink, "questLink", "You'll need to abandon the quest and accept it again.")
			vars["map"] = Check(addonTable.map, "map", "You'll need to abandon the quest, reload, and accept the quest again.")
			
			-- Add the quest to the
			LastSeenDB.Quests[questID] = { title = vars["title"], map = vars["map"], questLink = vars["questLink"], date = date(LastSeenDB.DateFormat) }
		else
			print(string.format("%s: A quest was accepted without providing its ID. It's recommended you abandon the quest and accept it again.", coloredAddOnName))
		end
	end
	if event == "QUEST_COMPLETE" then
		-- Don't do anything if the addon functionality is disabled.
		-- If Scan Quest Rewards is disabled, then this shouldn't execute.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		if LastSeenDB.ScanQuestRewardsEnabled == false or LastSeenDB.ScanQuestRewardsEnabled == nil then return false end
		
		-- Get the quest's ID.
		local questID = GetQuestID()
		
		-- Get the number of conditional rewards. These are the options a player has
		-- to pick from. Also, get the number of unconditional rewards, which are those
		-- that are given to the player for completing the quest; no picking necessary.
		local numChoiceRewards = GetNumQuestChoices()
		local numRewards = GetNumQuestRewards()
		
		-- Let's iterate over each of these rewards using a couple loops.
		if (numRewards > 0) then
			for i = 1, numRewards do
				QuestItem("reward", i, questID)
			end
		end
		
		if (numChoiceRewards > 0) then
			for i = 1, numChoiceRewards do
				QuestItem("choice", i, questID)
			end
		end
	end
	if event == "QUEST_LOOT_RECEIVED" then
		-- Don't do anything if the addon functionality is disabled.
		-- If Scan Quest Rewards is enabled, then this shouldn't execute.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		if LastSeenDB.ScanQuestRewardsEnabled then return false end
		
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
					
					LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), LastSeenDB.Quests[questID].map, LastSeenDB.Quests[questID].questLink)
				else
					-- If the player loots an item that has a type that LastSeen doesn't have a filter for,
					-- then inform the player of the situation.
					if LastSeenDB.Filters[itemType] == nil then
						print(string.format("%s has an item type that is unsupported: |cffFFD100%s|r", itemLink, itemType))
					end
				end
			end
		end
	end
end)