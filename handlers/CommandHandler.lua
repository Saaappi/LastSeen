-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local L = tbl.L

tbl.Remove = function(arg)
	if tonumber(arg) then -- The passed argument is a number or item ID.
		arg = tonumber(arg);
		if LastSeenItemsDB[arg] then
			if LastSeenItemsDB[arg].itemLink ~= nil then
				print(L["ADDON_NAME"] .. LastSeenItemsDB[arg].itemLink .. L["INFO_MSG_ITEM_REMOVED"]);
			else
				print(L["ADDON_NAME"] .. arg .. L["INFO_MSG_ITEM_REMOVED"]);
			end
			LastSeenItemsDB[arg] = nil
		end
	elseif not tonumber(arg) then -- The passed argument isn't a number, and is likely an item's link.
		arg = (GetItemInfoInstant(arg)); -- Converts the supposed item link into an item ID.
		if tonumber(arg) then
			arg = tonumber(arg);
			if LastSeenItemsDB[arg] then
				if LastSeenItemsDB[arg].itemLink ~= nil then
					print(string.format(L["INFO_MSG_ITEM_REMOVED"], LastSeenItemsDB[arg].itemLink));
				else
					print(string.format(L["INFO_MSG_ITEM_REMOVED"], arg));
				end
				LastSeenItemsDB[arg] = nil
			end
		end
	else
		print(L["ADDON_NAME"] .. L["ERROR_MSG_BAD_REQUEST"]);
	end
	
	if (LastSeenLootTemplate[arg]) then LastSeenLootTemplate[arg] = nil end -- Remove all associated entries that the player looted the item from.
end
-- Synopsis: Allows the player to remove undesired items from the items table using its ID or link.

tbl.Search = function(query)
	local itemsFound = 0
	if tonumber(query) ~= nil then
		query = tonumber(query)
		if LastSeenItemsDB[query] then -- ID
			print(query .. ": " .. LastSeenItemsDB[query].itemLink .. " (" .. tbl.GetCount(LastSeenLootTemplate, query) .. ") | " .. LastSeenItemsDB[query].source .. " | " .. LastSeenItemsDB[query].location .. " | " ..
			LastSeenItemsDB[query].lootDate)
			itemsFound = itemsFound + 1
		else -- Partial Date
			for k, v in pairs(LastSeenItemsDB) do
				if v.source ~= L["INFO_MSG_MISCELLANEOUS"] or v.source or v.location or v.itemLink or v.lootDate then
					if string.find(v.lootDate, query) then
						local itemID = (GetItemInfoInstant(k));
						if v.itemLink == "" then
							print(k .. ": " .. v.itemName .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
						else
							print(k .. ": " .. v.itemLink .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
						end
						itemsFound = itemsFound + 1
					end
				end
			end
		end
	else
		for k, v in pairs(LastSeenItemsDB) do
			if v.source ~= L["INFO_MSG_MISCELLANEOUS"] or v.source or v.location or v.itemLink or v.lootDate then
				if string.find(string.lower(v.itemLink), string.lower(query)) then
					local itemID = (GetItemInfoInstant(k));
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
					else
						print(k .. ": " .. v.itemLink .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
					end
					itemsFound = itemsFound + 1
				end
				if string.find(string.lower(v.source), string.lower(query)) then
					local itemID = (GetItemInfoInstant(k));
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
					else
						print(k .. ": " .. v.itemLink .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
					end
					itemsFound = itemsFound + 1
				end
				if string.find(string.lower(v.location), string.lower(query)) then
					local itemID = (GetItemInfoInstant(k));
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
					else
						print(k .. ": " .. v.itemLink .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
					end
					itemsFound = itemsFound + 1
				end
				if string.find(v.lootDate, query) then
					local itemID = (GetItemInfoInstant(k));
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
					else
						print(k .. ": " .. v.itemLink .. " (" .. tbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.source .. " | " .. v.location .. " | " .. v.lootDate)
					end
					itemsFound = itemsFound + 1
				end
			end
		end
	end
	if itemsFound == 0 then
		print(L["ADDON_NAME"] .. L["ERROR_MSG_NO_ITEMS_FOUND"] .. " (" .. query .. ")");
	else
		print(L["ADDON_NAME"] .. itemsFound .. L["INFO_MSG_RESULTS"]);
	end
end
--[[
	Synopsis: Allows the player to search the items table by an item's ID or its partial/full name, a creature's name, or a zone's name.
	Use Case(s):
		- Item: The most common search is by an item's ID or partial/full name to provide another player with proof an item still drops.
		- Creature: A search to see what items a particular creature has dropped. This is made possible by keeping track of the items a creature has dropped (call a "loot table").
		- Zone: An entire zone search, doesn't matter which creature in the zone dropped the item. Provides the player with every item that dropped in the provided zone. Partial/full names supported.
]]

tbl.Help = function()
	print(string.format(L["ADDON_NAME"] .. "%s, %s, %s, %s, %s, %s, %s, %s, %s, %s", L["CMD_DISCORD"], L["CMD_FORMAT"], L["CMD_HISTORY"], L["CMD_IMPORT"], L["CMD_LOCALE"], L["CMD_LOOT"], L["CMD_MAN"], L["CMD_REMOVE"], L["CMD_SEARCH"], L["CMD_VIEW"]));
end
-- Synopsis: Prints out the available commands to the chat frame.

tbl.Manual = function(args)
	if args == L["CMD_DISCORD"] then
		print(L["ADDON_NAME"] .. L["CMD_DISCORD"]);
		print(L["INFO_MSG_CMD_DISCORD"]);
	elseif args == L["CMD_FORMAT"] then
		print(L["ADDON_NAME"] .. L["CMD_FORMAT"]);
		print(L["INFO_MSG_CMD_FORMAT"]);
	elseif args == L["CMD_HELP"] then
		print(L["ADDON_NAME"] .. L["CMD_HELP"]);
		print(L["INFO_MSG_CMD_HELP"]);
	elseif args == L["CMD_HISTORY"] then
		print(L["ADDON_NAME"] .. L["CMD_HISTORY"]);
		print(L["INFO_MSG_CMD_HISTORY"]);
	elseif args == L["CMD_IMPORT"] then
		print(L["ADDON_NAME"] .. L["CMD_IMPORT"]);
		print(L["INFO_MSG_CMD_IMPORT"]);
	elseif args == L["CMD_LOCALE"] then
		print(L["ADDON_NAME"] .. L["CMD_LOCALE"]);
		print(L["INFO_MSG_CMD_LOCALE"]);
	elseif args == L["CMD_LOOT"] then
		print(L["ADDON_NAME"] .. L["CMD_LOOT"]);
		print(L["INFO_MSG_CMD_LOOT"]);
	elseif args == L["CMD_MAN"] then
		print(L["ADDON_NAME"] .. L["CMD_MAN"]);
		print(L["INFO_MSG_CMD_MAN"]);
	elseif args == L["CMD_REMOVE"] then
		print(L["ADDON_NAME"] .. L["CMD_REMOVE"]);
		print(L["INFO_MSG_CMD_REMOVE"]);
	elseif args == L["CMD_SEARCH"] then
		print(L["ADDON_NAME"] .. L["CMD_SEARCH"]);
		print(L["INFO_MSG_CMD_SEARCH"]);
	elseif args == L["CMD_VIEW"] then
		print(L["ADDON_NAME"] .. L["CMD_VIEW"]);
		print(L["INFO_MSG_CMD_VIEW"]);
	end
end
-- Synopsis: The player can toss commands to this function to learn more about them.