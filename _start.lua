--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: The entry point of the addon; responsible for onboarding all data.
]]--

local lastseen, lastseendb = ...;

-- Validate the saved variables and their data:
-- If nil, then create a new, empty table to store related data.
for savedvariable = 1, table.getn(lastseendb.savedvariables) do
	for primarytable = 1, table.getn(lastseendb.primarytables) do
		if lastseendb.savedvariables[savedvariable] == nil then
			lastseendb.savedvariables[savedvariable] = {};
		else
			primarytable = lastseendb.savedvariables[savedvariable];
		end
	end
end
