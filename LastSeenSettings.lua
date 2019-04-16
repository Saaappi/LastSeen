------------------------------------------------------------------
-- LastSeen (SETTINGS) | Oxlotus - Area 52 (US) | Copyright © 2019
------------------------------------------------------------------
-- 1: Normal, 2: Quiet
-- 1: Legendary, 2: Epic, 3: Rare, 4: Uncommon

local addonName, addonTable = ...;

-- High-level Variables
local L = addonTable.L;
local SETTINGS = {};
local gui = LibStub("AceGUI-3.0");
local modeList = {L["normal"], L["quiet"]};
local rarityList = {L["legendary"], L["epic"], L["rare"], L["uncommon"]};

local rarityConversions = {
	[4] = 2,
	[3] = 3,
	[2] = 4,
	[1] = 5,
};

local function getKey(tbl, value)
	for k, v in pairs(tbl) do
		if value == v then
			return k;
		end
	end
end

local function setMode(value)
	SETTINGS["mode"] = value;
	LastSeenSettingsCacheDB.mode = SETTINGS.mode;
	addonTable.mode = value;
end

local function getMode()
	if SETTINGS.mode then
		return (SETTINGS.mode);
	else
		SETTINGS.mode = 1;
		return (SETTINGS.mode);
	end
end

local function setRarity(value)
	SETTINGS["rarity"] = value;
	LastSeenSettingsCacheDB.rarity = rarityConversions[SETTINGS.rarity];
end

local function getRarity()
	if SETTINGS.rarity then
		return (getKey(rarityConversions, SETTINGS.rarity));
	else
		return (getKey(rarityConversions, 2));
	end
end

local function CountItemsSeen(tbl)
	local count = 0;
	for k, v in pairs(tbl) do
		count = count + 1;
	end
	return count;
end

function LoadLastSeenSettings()
	SETTINGS = LastSeenSettingsCacheDB;
	
	-- Settings Frame
	local settingsFrame = gui:Create("Frame");
	settingsFrame:SetCallback("OnClose",function(widget) gui:Release(widget) end)
	settingsFrame:SetTitle(addonName .. "-" .. L["release"]);
	settingsFrame:SetStatusText(L["itemsSeen"] .. ": " .. CountItemsSeen(LastSeenItemIDCacheDB));
	settingsFrame:SetLayout("Flow");
	settingsFrame:SetHeight(400);
	settingsFrame:SetWidth(400);

	-- Widgets
	local modeLabel = gui:Create("Label");
	modeLabel:SetPoint("TOPLEFT", 0, -8);
	modeLabel:SetText(L["mode"]);
	modeLabel:SetColor(255, 255, 255);
	modeLabel:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE")
	
	local modes = gui:Create("Dropdown");
	modes:SetPoint("TOPLEFT", 0, -16);
	modes:SetWidth(150);
	modes:SetList(modeList);
	modes:SetValue(getMode());
	modes:SetCallback("OnValueChanged", function(widget, event, value) setMode(value) end);
	
	local rarityLabel = gui:Create("Label");
	rarityLabel:SetPoint("TOPRIGHT", 0, -8);
	rarityLabel:SetText(L["rarity"]);
	rarityLabel:SetColor(255, 255, 255);
	rarityLabel:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE");
	
	local rarities = gui:Create("Dropdown");
	rarities:SetPoint("TOPRIGHT", 0, -16);
	rarities:SetWidth(150);
	rarities:SetList(rarityList);
	rarities:SetValue(getRarity());
	rarities:SetCallback("OnValueChanged", function(widget, event, value) setRarity(value) end);

	settingsFrame:AddChild(modeLabel);
	settingsFrame:AddChild(modes);
	settingsFrame:AddChild(rarityLabel);
	settingsFrame:AddChild(rarities);
end