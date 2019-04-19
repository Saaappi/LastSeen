--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Leverages onboarded data to dictate flow of function control.
]]--

local lastseen, lastseendb = ...;

local L = lastseendb.L; -- Create a local reference to the global localization table.

function lastseendb:add(itemid)
	local itemid = tonumber(itemid);
	print(itemid);
	--[[if T[itemid] then
		print(L["ITEM_EXISTS"]);
	else
		T[itemid] = {itemName = "", lootDate = "", location = ""};
		print(L["ADDED_ITEM"] .. itemid .. ".");
	end]]--
end