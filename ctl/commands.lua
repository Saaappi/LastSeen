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
	elseif cmd == L["REMOVED_CMD"] then
		if next(addonTbl.removedItems) ~= nil then
			for k, v in pairs(addonTbl.removedItems) do
				print(k .. ": " .. v);
			end
		else
			print(L["ADDON_NAME"] .. L["GENERAL_FAILURE"]);
		end
	elseif cmd == L["HISTORY"] then
		addonTbl.GetHistory();
	elseif cmd == L["LOOT_CMD"] then
		if addonTbl.lootFast then
			addonTbl.lootFast = not addonTbl.lootFast; LastSeenSettingsCacheDB.lootFast = addonTbl.lootFast;
			print(L["ADDON_NAME"] .. L["INFO_MSG_LOOT_DISABLED"]);
		else
			addonTbl.lootFast = true; LastSeenSettingsCacheDB.lootFast = addonTbl.lootFast;
			print(L["ADDON_NAME"] .. L["INFO_MSG_LOOT_ENABLED"]);
		end
	elseif cmd == "wipe" then
		--[[for k, v in pairs(LastSeenHistoryDB) do
			LastSeenHistoryDB[k] = nil;
		end]]
		
		for k, v in pairs(LastSeenSettingsCacheDB) do
			LastSeenSettingsCacheDB[k] = nil;
		end
	end
end
