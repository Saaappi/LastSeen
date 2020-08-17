local addon, tbl = ...;
local L = tbl.L;

tbl.SetDefaultOptions = function()
	if LastSeenSettingsCacheDB then
		if LastSeenSettingsCacheDB.rarity ~= 1 then
			LastSeenSettingsCacheDB.rarity = 1;
		end
		if LastSeenSettingsCacheDB.scanOnLoot == nil then
			LastSeenSettingsCacheDB.scanOnLoot = false;
		end
		tbl.Settings = LastSeenSettingsCacheDB;
	else
		LastSeenSettingsCacheDB = {
			["mode"] = L["NORMAL_MODE"],
			["rarity"] = 1,
			["locale"] = "enUS",
			["lootFast"] = true,
			["scanOnLoot"] = false,
			["showSources"] = false,
			["isNeckFilterEnabled"] = false,
			["isRingFilterEnabled"] = false,
			["isTrinketFilterEnabled"] = false,
			["isQuestFilterEnabled"] = false,
		};
		tbl.Settings = LastSeenSettingsCacheDB;
	end
end

tbl.LoadSettings = function()
	tbl.CreateFrame("LastSeenSettingsFrame", 400, 150);
end
--[[
	Synopsis: Loads either the settings from the cache or loads the settings frame.
	Use Case(s):
		true: If 'doNotOpen' is true, then the addon made the call so it can load the settings from the cache.
		false: If 'doNotOpen' is false, then the player made the call so the settings menu should be shown (or closed if already open.)
]]