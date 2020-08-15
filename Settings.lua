local addon, tbl = ...;

local L = tbl.L;
local areOptionsOpen = false;

local function GetOptions(arg)
	if LastSeenSettingsCacheDB[arg] ~= nil then
		tbl[arg] = LastSeenSettingsCacheDB[arg];
		return tbl[arg];
	else
		if arg == "mode" then
			LastSeenSettingsCacheDB[arg] = L["NORMAL_MODE"]; tbl[arg] = LastSeenSettingsCacheDB[arg];
			return tbl[arg];
		end
		if arg == "rarity" then
			LastSeenSettingsCacheDB[arg] = 2; tbl[arg] = LastSeenSettingsCacheDB[arg];
			return tbl[arg];
		end
		if arg == "lootFast" then
			LastSeenSettingsCacheDB[arg] = true; tbl[arg] = LastSeenSettingsCacheDB[arg];
			return tbl[arg];
		end
		if arg == "showSources" then
			LastSeenSettingsCacheDB[arg] = false; tbl[arg] = LastSeenSettingsCacheDB[arg];
			return tbl[arg];
		end
		if arg == "locale" then
			LastSeenSettingsCacheDB[arg] = "enUS"; tbl[arg] = LastSeenSettingsCacheDB[arg];
			return tbl[arg];
		end
	end
end
-- Synopsis: When the addon is loaded into memory after login, the addon will ask the cache for the last known
-- value of the mode, rarity, and lootFast variables.

tbl.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenSettingsCacheDB = {mode = GetOptions("mode"), rarity = GetOptions("rarity"), lootFast = GetOptions("lootFast"), showSources = GetOptions("showSources"), locale = GetOptions("locale")};
	else
		tbl.CreateFrame("LastSeenSettingsFrame", 200, 125);
	end
end
--[[
	Synopsis: Loads either the settings from the cache or loads the settings frame.
	Use Case(s):
		true: If 'doNotOpen' is true, then the addon made the call so it can load the settings from the cache.
		false: If 'doNotOpen' is false, then the player made the call so the settings menu should be shown (or closed if already open.)
]]