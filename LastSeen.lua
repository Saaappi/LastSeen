local addonName, addon = ...
local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"

LastSeen = LibStub("AceAddon-3.0"):NewAddon("LastSeen", "AceConsole-3.0")

function LastSeen:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_Main", addon.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_Main", addonName); addon.mainOptions = self.mainOptions
	self:RegisterChatCommand("lastseen", "SlashCommandHandler")
	
	if LastSeenDB == nil then
		LastSeenDB = {}
		LastSeenDB.Enabled = true
		LastSeenDB.Filters = {}
		LastSeenDB.Creatures = {}
		LastSeenDB.Items = {}
		LastSeenDB.IgnoredItems = {}
		LastSeenDB.Quests = {}
		LastSeenDB.Maps = {}
		LastSeenDB.Encounters = {}
	else
		if LastSeenDB.Filters == nil then LastSeenDB.Filters = {} end
		if LastSeenDB.Creatures == nil then LastSeenDB.Creatures = {} end
		if LastSeenDB.Items == nil then LastSeenDB.Items = {} end
		if LastSeenDB.IgnoredItems == nil then LastSeenDB.IgnoredItems = {} end
		if LastSeenDB.Quests == nil then LastSeenDB.Quests = {} end
		if LastSeenDB.Maps == nil then LastSeenDB.Maps = {} end
		if LastSeenDB.Encounters == nil then LastSeenDB.Encounters = {} end
	end
	
	if LastSeenDB then
		LastSeen:MinimapIcon(LastSeenDB.MinimapIconEnabled)
	end
	
	if LastSeenCreaturesDB then
		for npcID, npc in pairs(LastSeenCreaturesDB) do
			LastSeenDB.Creatures[npcID] = npc.unitName
		end
		LastSeenCreaturesDB = nil
	end
	if LastSeenItemsDB then
		local cID = 0
		for itemID,item in pairs(LastSeenItemsDB) do
			for classID=1,GetNumClasses() do
				local className, _, retClassID = GetClassInfo(classID)
				if (className == item.lootedBy.playerClass) then
					cID = retClassID
					break
				end
			end
			LastSeenDB.Items[itemID] = { itemLink = item.itemLink, itemName = item.itemName, itemRarity = item.itemRarity, itemType = item.itemType, itemIcon = item.itemIcon, lootDate = item.lootDate, map = item.location, source = item.source, sourceInfo = item.sourceIDs, lootedBy = { factionID = 2, classID = cID, level = item.lootedBy.playerLevel or 1 } }
		end
		LastSeenItemsDB = nil
	end
	if LastSeenQuestsDB then
		for questID, quest in pairs(LastSeenQuestsDB) do
			LastSeenDB.Quests[questID] = { title = quest.questTitle, map = "", questLink = "", date = "" }
		end
		LastSeenQuestsDB = nil
	end
	if LastSeenMapsDB then
		LastSeenMapsDB = nil
	end
	if LastSeenSettingsCacheDB then
		LastSeenSettingsCacheDB = nil
	end
	if LastSeenLootTemplate then
		LastSeenLootTemplate = nil
	end
	if LastSeenHistoryDB then
		LastSeenHistoryDB = nil
	end
	
	local incompleteItems = {}
	local faction = UnitFactionGroup("player")
	for _,item in pairs(LastSeenDB.Items) do
		if (not item.map) or (not item.source) then
			table.insert(incompleteItems, item.itemLink)
		end
		
		if (not item.map) then
			if (faction == "Alliance") then
				item.map = (C_Map.GetMapInfo(84).name)
			elseif (faction == "Horde") then
				item.map = (C_Map.GetMapInfo(85).name)
			else
				item.map = ""
			end
		end
		
		if (not item.source) then
			item.source = ""
		end
		
		--[[if (not item.location) then
			if (faction == "Alliance") then
				item.location = { mapID = 84, x = 73.009449243546, y = 89.972448348999 }
			elseif (faction == "Horde") then
				item.location = { mapID = 85, x = 52.411937713623, y = 86.637425422668 }
			else
				item.location = { mapID = 50, x = 48.130857944489, y = 19.209229946136 }
			end
		end]]
	end
	
	if (#incompleteItems > 0) then
		print("\n" .. coloredAddOnName .. ":")
		for _, itemLink in ipairs(incompleteItems) do
			print(itemLink)
		end
		print("The above item(s) were incomplete. The map or source (or both) properties were nil. These properties have been populated automatically.\n")
	end
	
	addon.isOnEncounter = false
	
	for setting, _ in pairs(addon.oldSettings) do
		if LastSeenDB[setting] then
			LastSeenDB[setting] = nil
		end
	end
end