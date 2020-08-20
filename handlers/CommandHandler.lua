local addon, tbl = ...;

tbl.Remove = function(arg)
	if tonumber(arg) then -- The passed argument is a number or item ID.
		arg = tonumber(arg);
		if tbl.Items[arg] then
			if tbl.Items[arg].itemLink ~= nil then
				print(tbl.L["ADDON_NAME"] .. tbl.L["REMOVED"] .. tbl.Items[arg].itemLink .. ".")
			else
				print(tbl.L["ADDON_NAME"] .. tbl.L["REMOVED"] .. arg .. ".")
			end
			tbl.Items[arg] = nil
		end
	elseif not tonumber(arg) then -- The passed argument isn't a number, and is likely an item's link.
		arg = (GetItemInfoInstant(arg)); -- Converts the supposed item link into an item ID.
		if tonumber(arg) then
			arg = tonumber(arg);
			if tbl.Items[arg] then
				if tbl.Items[arg].itemLink ~= nil then
					print(tbl.L["ADDON_NAME"] .. tbl.L["REMOVED"] .. tbl.Items[arg].itemLink .. ".")
				else
					print(tbl.L["ADDON_NAME"] .. tbl.L["REMOVED"] .. arg .. ".")
				end
				tbl.Items[arg] = nil
			end
		end
	else
		print(tbl.L["ADDON_NAME"] .. tbl.L["BAD_REQUEST"]);
	end
	
	if (tbl.LootTemplate[arg]) then tbl.LootTemplate[arg] = nil end -- Remove all associated entries that the player looted the item from.
end
-- Synopsis: Allows the player to remove undesired items from the items table using its ID or link.

tbl.Search = function(query)
	if tonumber(query) ~= nil then
		query = tonumber(query)
		tbl.Search_ID(query)
	else
		tbl.Search_Text(query)
	end
end
--[[
	Synopsis: Allows the player to search the items table by an item's ID or its partial/full name, a creature's name, or a zone's name.
	Use Case(s):
		- Item: The most common search is by an item's ID or partial/full name to provide another player with proof an item still drops.
		- Creature: A search to see what items a particular creature has dropped. This is made possible by keeping track of the items a creature has dropped (call a "loot table").
		- Zone: An entire zone search, doesn't matter which creature in the zone dropped the item. Provides the player with every item that dropped in the provided zone. Partial/full names supported.
]]

tbl.CheckProgress = function()
	print(tbl.L["ADDON_NAME"] .. tbl.GetCount(tbl.Items) .. " " .. tbl.L["OF"] .. " " .. tbl.L["APPROXIMATELY"] .. " " .. 154000 .. " (" .. tbl.Round(tbl.GetCount(tbl.Items)/154000) .. "%)")
end