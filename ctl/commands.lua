local addon, addonTbl = ...;

local L = addonTbl.L;

SLASH_LastSeen1 = "/ls";
SLASH_LastSeen2 = "/lastseen";
SlashCmdList["LastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");

	if not cmd or cmd == "" then
		addonTbl.LoadSettings(false);
	elseif cmd == "remove" then
		addonTbl.Remove(args);
	elseif cmd == L["IGNORE_CMD"] then
		addonTbl.Ignore(args);
	elseif cmd == L["SEARCH_CMD"] and args ~= "" then
		addonTbl.Search(args);
	elseif cmd == L["LOCATION_CMD"] then
		print(L["ADDON_NAME"] .. addonTbl.GetCurrentMap());
	elseif cmd == L["LOOT_CMD"] then
		print(L["ADDON_NAME"] .. L["COMING_SOON_TEXT"]);
	elseif cmd == L["REMOVED_CMD"] then
		if next(addonTbl.removedItems) ~= nil then
			print(L["ADDON_NAME"] .. L["REMOVED_ITEMS_ANNOUNCEMENT_TEXT"]);
			for k, v in pairs(addonTbl.removedItems) do
				print(k .. ": " .. v);
			end
		else
			print(L["ADDON_NAME"] .. L["GENERAL_FAILURE"]);
		end
	elseif cmd == L["HISTORY"] then
		addonTbl.GetHistory();
	elseif cmd == L["LOOT_FAST_CMD"] then
		if LastSeenSettingsCacheDB.lootFast then
			LastSeenSettingsCacheDB.lootFast = not LastSeenSettingsCacheDB.lootFast;
			print(L["ADDON_NAME"] .. L["LOOT_FAST_DISABLED"]);
		else
			LastSeenSettingsCacheDB.lootFast = true;
			print(L["ADDON_NAME"] .. L["LOOT_FAST_ENABLED"]);
		end
		addonTbl.lootFast = LastSeenSettingsCacheDB.lootFast;
	elseif cmd == "wipe" then
		for k, v in pairs(LastSeenHistoryDB) do
			LastSeenHistoryDB[k] = nil;
		end
	end
end
