local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

LastSeen = LibStub("AceAddon-3.0"):NewAddon("LastSeen", "AceConsole-3.0")

function LastSeen:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_Main", addonTable.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_Main", addonName); addonTable.mainOptions = self.mainOptions
	self:RegisterChatCommand(L_GLOBALSTRINGS["Command.Slash1"], "SlashCommandHandler")
	self:RegisterChatCommand(L_GLOBALSTRINGS["Command.Slash2"], "SlashCommandHandler")
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_GeneralOptions", addonTable.generalOptions)
	self.generalOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_GeneralOptions", L_GLOBALSTRINGS["Tabs.General"], addonName); addonTable.generalOptions = self.generalOptions
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_FeaturesOptions", addonTable.featuresOptions)
	self.featuresOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_FeaturesOptions", L_GLOBALSTRINGS["Tabs.Features"], addonName); addonTable.featuresOptions = self.featuresOptions
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_Filters", addonTable.filtersOptions)
	self.filtersOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_Filters", L_GLOBALSTRINGS["Tabs.Filters"], addonName); addonTable.filtersOptions = self.filtersOptions
	
	-- Default Options
	if LastSeenDB == nil then
		LastSeenDB = {}
		LastSeenDB.Filters = {}
		LastSeenDB.Enabled = true
	else
		-- The options aren't nil, so let's run
		-- some code to ensure we get the state
		-- of the options we expect.
		--LastSeen:MinimapIcon(LastSeenDB.MinimapIconEnabled)
	end
	
	-- Some saved variable tables may be nil. If they are,
	-- then initialize them.
	if LastSeenCreatureDB == nil then
		LastSeenCreatureDB = {}
	end
	
	if LastSeenItemDB == nil then
		LastSeenItemDB = {}
	end
	
	if LastSeenLootTemplateDB == nil then
		LastSeenLootTemplateDB = {}
	end
	
	if LastSeenMapDB == nil then
		LastSeenMapDB = {}
	end
end

function LastSeen:OnEnable()
end

function LastSeen:OnDisable()
end