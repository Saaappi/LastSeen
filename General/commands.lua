--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Controls the output and construction of the addon's commands.
]]--

local lastSeen, LastSeenTbl = ...;

local L = LastSeenTbl.L;

SLASH_lastSeen1 = "/lastseen";
SLASH_lastSeen2 = "/last";
SlashCmdList["lastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");

	if not cmd or cmd == "" then
		LastSeenTbl.LoadSettings(false);
	elseif cmd == L["ADD_CMD"] and args ~= "" then
		LastSeenTbl.Add(args);
	elseif cmd == L["IGNORE_CMD"] then
		LastSeenTbl.Ignore(args);
	elseif cmd == L["REMOVE_CMD"] then
		LastSeenTbl.Remove(args);
	elseif cmd == L["SEARCH_CMD"] and args ~= "" then
		LastSeenTbl.Search(args);
	elseif cmd == L["LOCATION_CMD"] then
		print(L["ADDON_NAME"] .. LastSeenTbl.currentMap);
	elseif cmd == L["LOOT_CMD"] then
		print(L["ADDON_NAME"] .. L["COMING_SOON_TEXT"]);
	elseif cmd == L["REMOVED_CMD"] then
		if next(LastSeenTbl.removedItems) ~= nil then
			print(L["ADDON_NAME"] .. L["REMOVED_ITEMS_ANNOUNCEMENT_TEXT"]);
			for k, v in pairs(LastSeenTbl.removedItems) do
				print(k .. ": " .. v);
			end
		else
			print(L["ADDON_NAME"] .. L["GENERAL_FAILURE"]);
		end
	end
end
