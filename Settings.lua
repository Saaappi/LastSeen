local addon, addonTbl = ...;

local function CountItemsSeen(tbl)
	local count = 0;
	for k, v in pairs(tbl) do
		count = count + 1;
	end
	return count;
end

local settingsFrame = CreateFrame("Frame", "LastSeenSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local L = addonTbl.L;
local SETTINGS = {};
local modeList;
local areOptionsOpen = false;

local function GetOptions(arg)
	if LastSeenSettingsCacheDB[arg] ~= nil then
		addonTbl[arg] = LastSeenSettingsCacheDB[arg];
		return addonTbl[arg];
	else
		if arg == "mode" then
			LastSeenSettingsCacheDB[arg] = L["NORMAL_MODE"]; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "rarity" then
			LastSeenSettingsCacheDB[arg] = 2; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "lootFast" then
			LastSeenSettingsCacheDB[arg] = true; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "showSources" then
			LastSeenSettingsCacheDB[arg] = false; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "locale" then
			LastSeenSettingsCacheDB[arg] = "enUS"; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
	end
end
-- Synopsis: When the addon is loaded into memory after login, the addon will ask the cache for the last known
-- value of the mode, rarity, and lootFast variables.

addonTbl.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenSettingsCacheDB = {mode = GetOptions("mode"), rarity = GetOptions("rarity"), lootFast = GetOptions("lootFast"), showSources = GetOptions("showSources"), locale = GetOptions("locale")};
	else
		addonTbl.CreateFrame("LastSeenSettingsFrame", 200, 125);
		--[[if areOptionsOpen then
			SettingsMenu_OnClose();
		else
			SettingsMenu_OnShow();
		end]]
	end
end
--[[
	Synopsis: Loads either the settings from the cache or loads the settings frame.
	Use Case(s):
		true: If 'doNotOpen' is true, then the addon made the call so it can load the settings from the cache.
		false: If 'doNotOpen' is false, then the player made the call so the settings menu should be shown (or closed if already open.)
]]