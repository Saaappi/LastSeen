------------------------------------------------------------------
-- LastSeen (SETTINGS) | Oxlotus - Area 52 (US) | Copyright © 2019
------------------------------------------------------------------

local addonName, addonTable = ...;

-- High-level Variables
local eventFrame = CreateFrame("Frame");
local L = addonTable.L;
local gui = LibStub("AceGUI-3.0");
local modeList = {L["verbose"], L["standard"], L["quiet"]};

local function SetAddOnMode(value)
	-- 1: Verbose, 2: Standard (Default), 3: Quiet
	SETTINGS = {mode = value};
end

-- Settings Frame
local settingsFrame = gui:Create("Frame");
settingsFrame:SetCallback("OnClose",function(widget) gui:Release(widget) end)
settingsFrame:SetTitle(addonName .. "-" .. L["release"]);
settingsFrame:SetLayout("Flow");

-- Widgets
local modes = gui:Create("Dropdown");
modes:SetLabel(L["mode"]);
modes:SetWidth(150);
modes:SetList(modeList);
modes:SetValue(SETTINGS.mode);
modes:SetCallback("OnValueChanged", function(widget, event, value) SetAddOnMode(value) end);

settingsFrame:AddChild(modes);

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and addonTable.LastSeen then
		SETTINGS = LastSeenSettingsCacheDB;
		if SETTINGS == nil then
			SETTINGS = {};
		end
		eventFrame:UnregisterEvent("PLAYER_LOGIN");
	elseif event == "PLAYER_LOGOUT" then
		LastSeenSettingsCacheDB = SETTINGS;
	end
end)