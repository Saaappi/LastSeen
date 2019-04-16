------------------------------------------------------------------
-- LastSeen (SETTINGS) | Oxlotus - Area 52 (US) | Copyright © 2019
------------------------------------------------------------------
-- 1: Verbose, 2: Normal (Default), 3: Quiet

local addonName, addonTable = ...;

-- High-level Variables
local L = addonTable.L;
local SETTINGS = {};
local gui = LibStub("AceGUI-3.0");
local modeList = {L["verbose"], L["normal"], L["quiet"]};

local function setMode(value)
	SETTINGS["mode"] = value;
	LastSeenSettingsCacheDB = SETTINGS;
	addonTable.mode = value;
end

local function getMode()
	if SETTINGS.mode then
		return (SETTINGS.mode);
	else
		SETTINGS.mode = 2;
		return (SETTINGS.mode);
	end
end

function LoadLastSeenSettings()
	SETTINGS = LastSeenSettingsCacheDB;
	
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
	modes:SetValue(getMode());
	modes:SetCallback("OnValueChanged", function(widget, event, value) setMode(value) end);

	settingsFrame:AddChild(modes);
end