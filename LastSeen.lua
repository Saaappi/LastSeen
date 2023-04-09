local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

LastSeen = LibStub("AceAddon-3.0"):NewAddon("LastSeen", "AceConsole-3.0")

function LastSeen:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_Main", addonTable.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_Main", addonName); addonTable.mainOptions = self.mainOptions
	self:RegisterChatCommand("ls", "SlashCommandHandler")
	self:RegisterChatCommand("lastseen", "SlashCommandHandler")
	
	--[[LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_GeneralOptions", addonTable.generalOptions)
	self.generalOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_GeneralOptions", L_GLOBALSTRINGS["Tabs.General"], addonName); addonTable.generalOptions = self.generalOptions
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_FeaturesOptions", addonTable.featuresOptions)
	self.featuresOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_FeaturesOptions", L_GLOBALSTRINGS["Tabs.Features"], addonName); addonTable.featuresOptions = self.featuresOptions
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_Filters", addonTable.filtersOptions)
	self.filtersOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_Filters", L_GLOBALSTRINGS["Tabs.Filters"], addonName); addonTable.filtersOptions = self.filtersOptions]]
	
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