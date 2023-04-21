local addonName, addonTable = ...
local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"

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
	
	-- When the addon is loaded, check to see if any map or sources
	-- are nil. If so, add them to the incompleteItems table.
	local incompleteItems = {}
	local faction = UnitFactionGroup("player")
	for _, item in pairs(LastSeenDB.Items) do
		-- If the map or source is nil, then add the item to the
		-- incompleteItems table.
		if not item.map or not item.source then
			table.insert(incompleteItems, item.itemLink)
		end
		
		-- The map should be Stormwind if the player is Alliance,
		-- Orgrimmar if they're Horde, or empty if they're neutral.
		if not item.map then
			if faction == "Alliance" then
				item.map = (C_Map.GetMapInfo(84).name)
			elseif faction == "Horde" then
				item.map = (C_Map.GetMapInfo(85).name)
			else
				item.map = ""
			end
		end
		
		-- The source should be an empty string instead of nil.
		if not item.source then
			item.source = ""
		end
	end
	
	-- Check to see if there are incomplete items. If so, report these
	-- to the player and let them know that a placeholder of Orgrimmar
	-- or Stormwind City, depending on their faction, has been input.
	if (#incompleteItems > 0) then
		print("\n" .. coloredAddOnName .. ":")
		for _, itemLink in ipairs(incompleteItems) do
			print(itemLink)
		end
		print("The above item(s) were incomplete. The map or source (or both) properties were nil. These properties have been populated automatically.\n")
	end
	
	
	-- Cleanup old variables from ages past.
	for setting, _ in pairs(addonTable.oldSettings) do
		if LastSeenDB[setting] then
			LastSeenDB[setting] = nil
		end
	end
end