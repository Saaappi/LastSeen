local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

LastSeen = LibStub("AceAddon-3.0"):NewAddon("LastSeen", "AceConsole-3.0")

function LastSeen:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_Main", addonTable.mainOptions)
	self.mainOptions = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_Main", addonName); addonTable.mainOptions = self.mainOptions
	self:RegisterChatCommand(L_GLOBALSTRINGS["Command.Slash1"], "SlashCommandHandler")
	self:RegisterChatCommand(L_GLOBALSTRINGS["Command.Slash2"], "SlashCommandHandler")
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("LastSeen_GeneralOptions", addonTable.generalOptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LastSeen_GeneralOptions", L_GLOBALSTRINGS["Tabs.General"], addonName)
	
	--[[LibStub("AceConfig-3.0"):RegisterOptionsTable("HelpMePlay_FeaturesOptions", addonTable.featuresOptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelpMePlay_FeaturesOptions", L_GLOBALSTRINGS["Tabs.Features"], addonName)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("HelpMePlay_QuestOptions", addonTable.questOptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelpMePlay_QuestOptions", L_GLOBALSTRINGS["Tabs.Quests"], addonName)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("HelpMePlay_ExpansionFeatures", addonTable.expansionFeatures)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelpMePlay_ExpansionFeatures", L_GLOBALSTRINGS["Tabs.ExpansionFeatures"], addonName)
	
	LibStub("AceConfig-3.0"):RegisterOptionsTable("HelpMePlay_Junker", addonTable.junkerOptions)
	LibStub("AceConfigDialog-3.0"):AddToBlizOptions("HelpMePlay_Junker", L_GLOBALSTRINGS["Tabs.Junker"], addonName)]]
	
	-- Default Options
	if LastSeenDB == nil then
		LastSeenDB = {}
		LastSeenDB.Enabled = true
	else
		-- The options aren't nil, so let's run
		-- some code to ensure we get the state
		-- of the options we expect.
		--LastSeen:MinimapIcon(LastSeenDB.MinimapIconEnabled)
	end
end

function LastSeen:OnEnable()
end

function LastSeen:OnDisable()
end