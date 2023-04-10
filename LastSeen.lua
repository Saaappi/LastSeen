local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

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
		LastSeenDB.Creatures = {}
		LastSeenDB.Items = {}
		LastSeenDB.Quests = {}
		LastSeenDB.Maps = {}
	else
		if LastSeenDB.Creatures == nil then LastSeenDB.Creatures = {} end
		if LastSeenDB.Items == nil then LastSeenDB.Items = {} end
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
		LastSeenDB.Creatures = LastSeenCreaturesDB
	end
	if LastSeenItemsDB then
		LastSeenDB.Items = LastSeenItemsDB
	end
	if LastSeenQuestsDB then
		LastSeenDB.Quests = LastSeenQuestsDB
	end
	if LastSeenMapsDB then
		LastSeenDB.Maps = LastSeenMapsDB
	end
end