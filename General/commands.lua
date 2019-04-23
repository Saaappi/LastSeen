--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Controls the output and construction of the addon's commands.
]]--

local lastSeen, lastSeenNS = ...;

local L = lastSeenNS.L;

SLASH_lastSeen1 = "/lastSeen";
SLASH_lastSeen2 = "/last";
SlashCmdList["lastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");
	
	if not cmd or cmd == "" then
		lastSeenNS.LoadSettings(false);
	elseif cmd == L["ADD"] and args ~= "" then
		lastSeenNS.Add(args);
	elseif cmd == L["IGNORE"] then
		lastSeenNS.Ignore(args);
	elseif cmd == L["REMOVE"] then
		lastSeenNS.Remove(args);
	elseif cmd == L["SEARCH"] and args ~= "" then
		lastSeenNS.Search(args);
	end
end