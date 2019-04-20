--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Controls the output and construction of the addon's commands.
]]--

local lastseen, lastseendb = ...;

local L = lastseendb.L;

SLASH_LastSeen1 = "/lastseen";
SLASH_LastSeen2 = "/last";
SlashCmdList["LastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");
	
	if not cmd or cmd == "" then
		LoadLastSeenSettings(false);
	elseif cmd == L["ADD"] and args ~= "" then
		lastseendb:add(args);
	elseif cmd == L["IGNORE"] then
		lastseendb:ignore(args);
	elseif cmd == L["REMOVE"] then
		lastseendb:remove(args);
	elseif cmd == L["SEARCH"] and args ~= "" then
		lastseendb:search(args);
	end
end