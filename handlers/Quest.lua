local addonName, addon = ...
local frame = CreateFrame("Frame")
local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"
local questWasNotAccepted = false

local function Check(var, name, reason)
	if var then
		return var
	else
		print(coloredAddOnName .. ": " .. name .. " is unavailable." .. " " .. reason)
		return ""
	end
end

local function QuestItem(type, index, questID)
	local itemName, itemIcon, _, _, _, itemID = GetQuestItemInfo(type, index); itemID = tonumber(itemID)
	
	C_Item.RequestLoadItemDataByID(itemID)
	C_Timer.After(0.1, function()
		local _, itemLink, itemRarity, _, _, itemType = GetItemInfo(itemID)
		if (itemRarity >= LastSeenDB.rarityID) then
			if (LastSeenDB.Filters[itemType]) then
				local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
				
				if (sourceID == nil) then
					sourceID = 0
				end
				
				local x, y = addon.GetMapPosition(addon.mapID)
				local location = { mapID = addon.mapID, x = x, y = y }
				
				if (LastSeenDB.Quests[questID].questLink == "") then
					LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), LastSeenDB.Quests[questID].map, location, LastSeenDB.Quests[questID].title)
				else
					LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), LastSeenDB.Quests[questID].map, location, LastSeenDB.Quests[questID].questLink)
				end
			else
				if (LastSeenDB.Filters[itemType] == nil) then
					print(string.format("%s has an item type that is unsupported: |cffFFD100%s|r", itemLink, itemType))
				end
			end
		end
	end)
end

frame:RegisterEvent("QUEST_ACCEPTED")
frame:RegisterEvent("QUEST_COMPLETE")
frame:RegisterEvent("QUEST_LOOT_RECEIVED")
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_ACCEPTED" then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local questID = ...
		if (questID) then
			local title = C_QuestLog.GetTitleForQuestID(questID)
			local questLink = GetQuestLink(questID)
			
			local x, y = addon.GetMapPosition(addon.mapID)
			local location = { mapID = addon.mapID, x = x, y = y }
			if (not LastSeenDB.Quests[questID]) then
				local vars = {}
				vars["title"] = Check(title, "title", "You'll need to abandon the quest and accept it again.")
				vars["questLink"] = Check(questLink, "questLink", "You'll need to abandon the quest and accept it again.")
				vars["map"] = Check(addon.map, "map", "You'll need to abandon the quest, reload, and accept the quest again.")
				vars["location"] = Check(location, "location", "You'll need to abandon the quest, reload, and accept the quest again.")
				
				LastSeenDB.Quests[questID] = { title = vars["title"], map = vars["map"], location = vars["location"], questLink = vars["questLink"], date = date(LastSeenDB.DateFormat) }
			elseif (LastSeenDB.Quests[questID]) then
				local vars = {}
				vars["title"] = Check(title, "title", "You'll need to abandon the quest and accept it again.")
				vars["questLink"] = Check(questLink, "questLink", "You'll need to abandon the quest and accept it again.")
				vars["map"] = Check(addon.map, "map", "You'll need to abandon the quest, reload, and accept the quest again.")
				vars["location"] = Check(location, "location", "You'll need to abandon the quest, reload, and accept the quest again.")
				
				local questDetails = LastSeenDB.Quests[questID]
				if (questDetails.title == nil) or (questDetails.title == "") then
					if (vars["title"]) then
						questDetails.title = vars["title"]
					end
				end
				if (questDetails.questLink == nil) or (questDetails.questLink == "") then
					if (vars["questLink"]) then
						questDetails.questLink = vars["questLink"]
					end
				end
				if (questDetails.map == nil) or (questDetails.map == "") then
					if (vars["map"]) then
						questDetails.map = vars["map"]
					end
				end
				if (not questDetails.location) then
					if (vars["location"]) then
						questDetails.location = vars["location"]
					end
				end
			end
		else
			print(string.format("%s: A quest was accepted without providing its ID. It's recommended you abandon the quest and accept it again.", coloredAddOnName))
		end
	end
	if event == "QUEST_COMPLETE" then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local questID = GetQuestID()
		local numChoiceRewards = GetNumQuestChoices()
		local numRewards = GetNumQuestRewards()
		if (LastSeenDB.Quests[questID]) then
			if LastSeenDB.ScanQuestRewardsEnabled == false or LastSeenDB.ScanQuestRewardsEnabled == nil then return false end
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
		else
			questWasNotAccepted = true

			local title = C_QuestLog.GetTitleForQuestID(questID)
			
			local vars = {}
			vars["title"] = Check(title, "title", "You'll need to abandon the quest and accept it again.")
			vars["map"] = Check(addon.map, "map", "You'll need to abandon the quest, reload, and accept the quest again.")
			vars["location"] = Check(location, "location", "You'll need to abandon the quest, reload, and accept the quest again.")
			
			if (not LastSeenDB.Quests[questID]) then
				LastSeenDB.Quests[questID] = { title = vars["title"], map = vars["map"], location = vars["location"], questLink = "", date = date(LastSeenDB.DateFormat) }
			end
			
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
	end
	if event == "QUEST_LOOT_RECEIVED" then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		if LastSeenDB.ScanQuestRewardsEnabled then return false end
		
		if (questWasNotAccepted) then
			questWasNotAccepted = false
			return
		end
		
		local questID, itemLink = ...
		if (itemLink) then
			C_Item.RequestLoadItemDataByID(itemLink)
			C_Timer.After(0.25, function()
				local itemName, _, itemRarity = GetItemInfo(itemLink)
				local itemID, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
				
				if (itemRarity >= LastSeenDB.rarityID) then
					if (LastSeenDB.Filters[itemType]) then
						local _, sourceID = C_TransmogCollection.GetItemInfo(itemLink)
						
						if (sourceID == nil) then
							sourceID = 0
						end

						local location = LastSeenDB.Quests[questID].location
						
						LastSeen:Item(itemID, itemLink, itemName, itemRarity, itemType, itemIcon, sourceID, date(LastSeenDB.DateFormat), LastSeenDB.Quests[questID].map, location, LastSeenDB.Quests[questID].questLink)
					else
						if (LastSeenDB.Filters[itemType] == nil) then
							print(string.format("%s has an item type that is unsupported: |cffFFD100%s|r", itemLink, itemType))
						end
					end
				end
			end)
		end
	end
end)