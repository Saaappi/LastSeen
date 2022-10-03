local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local e = CreateFrame("Frame")

e:RegisterEvent("QUEST_LOOT_RECEIVED")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "QUEST_LOOT_RECEIVED" then
		local _, itemLink = ...
		if itemLink then
			-- Let's get some information about the item we looted.
			local itemName, _, itemRarity = GetItemInfo(itemLink)
			local itemId, itemType, _, _, itemIcon = GetItemInfoInstant(itemLink)
			
			if itemId then
				local action = ""
				if LastSeenItemDB[itemId] then
					-- This item has been seen before.
					action = "Update"
				else
					-- This is a new item.
					action = "New"
				end
				
				LastSeen:Item(itemId, itemLink, itemName, itemRarity, itemType, itemIcon, date(LastSeenDB.DateFormat), addonTable.map, L_GLOBALSTRINGS["Source.Text.QuestReward"], (UnitClass("player")), (UnitLevel("player")), action)
			end
		end
	end
end)