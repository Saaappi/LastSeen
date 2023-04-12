local addonName, addonTable = ...

LastSeen = LibStub("AceAddon-3.0"):NewAddon("LastSeen", "AceConsole-3.0")

function LastSeen:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_Main", addonTable.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_Main", addonName); addonTable.mainOptions = self.mainOptions
	self:RegisterChatCommand("ls", "SlashCommandHandler")
	self:RegisterChatCommand("lastseen", "SlashCommandHandler")
	
	-- Default Options
	if LastSeenDB == nil then
		LastSeenDB = {}
		LastSeenDB.Enabled = true
		LastSeenDB.Filters = {}
		LastSeenDB.Creatures = {}
		LastSeenDB.Items = {}
		LastSeenDB.IgnoredItems = {}
		LastSeenDB.Quests = {}
		LastSeenDB.Maps = {}
	else
		if LastSeenDB.Filters == nil then LastSeenDB.Filters = {} end
		if LastSeenDB.Creatures == nil then LastSeenDB.Creatures = {} end
		if LastSeenDB.Items == nil then LastSeenDB.Items = {} end
		if LastSeenDB.IgnoredItems == nil then LastSeenDB.IgnoredItems = {} end
		if LastSeenDB.Quests == nil then LastSeenDB.Quests = {} end
		if LastSeenDB.Maps == nil then LastSeenDB.Maps = {} end
	end
	
	-- Show the minimap icon if it should be shown.
	if LastSeenDB then
		LastSeen:MinimapIcon(LastSeenDB.MinimapIconEnabled)
	end
	
	-- If the tables are already created and populated, then
	-- set the revamped table to those tables.
	if LastSeenCreaturesDB then
		for npcID, npc in pairs(LastSeenCreaturesDB) do
			LastSeenDB.Creatures[npcID] = npc.unitName
		end
		LastSeenCreaturesDB = nil
	end
	if LastSeenItemsDB then
		local cID = 0
		for itemID, item in pairs(LastSeenItemsDB) do
			for classID = 1, GetNumClasses() do
				local className, _, retClassID = GetClassInfo(classID)
				if className == item.lootedBy.playerClass then
					cID = retClassID
					break
				end
			end
			LastSeenDB.Items[itemID] = { itemLink = item.itemLink, itemName = item.itemName, itemRarity = item.itemRarity, itemType = item.itemType, itemIcon = item.itemIcon, lootDate = item.lootDate, map = item.location, source = item.source, sourceInfo = item.sourceIDs, lootedBy = { classID = cID, level = item.lootedBy.playerLevel } }
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
	
	-- Cleanup old variables from ages past.
	for setting, _ in pairs(addonTable.oldSettings) do
		if LastSeenDB[setting] then
			LastSeenDB[setting] = nil
		end
	end
end