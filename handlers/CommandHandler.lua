-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local L = addonTbl.L;

addonTbl.Remove = function(arg)
	if tonumber(arg) then -- The passed argument is a number or item ID.
		arg = tonumber(arg);
		if LastSeenItemsDB[arg] then
			if LastSeenItemsDB[arg].itemLink ~= nil then
				print(L["ADDON_NAME"] .. LastSeenItemsDB[arg].itemLink .. L["INFO_MSG_ITEM_REMOVED"]);
			else
				print(L["ADDON_NAME"] .. arg .. L["INFO_MSG_ITEM_REMOVED"]);
			end
			LastSeenItemsDB[arg] = nil;
		end
	elseif not tonumber(arg) then -- The passed argument isn't a number, and is likely an item's link.
		arg = (GetItemInfoInstant(arg)); -- Converts the supposed item link into an item ID.
		if tonumber(arg) then
			arg = tonumber(arg);
			if LastSeenItemsDB[arg] then
				if LastSeenItemsDB[arg].itemLink ~= nil then
					print(L["ADDON_NAME"] .. LastSeenItemsDB[arg].itemLink .. L["INFO_MSG_ITEM_REMOVED"]);
				else
					print(L["ADDON_NAME"] .. arg .. L["INFO_MSG_ITEM_REMOVED"]);
				end
				LastSeenItemsDB[arg] = nil;
			end
		end
	else
		print(L["ADDON_NAME"] .. L["ERROR_MSG_BAD_REQUEST"]);
	end
	
	if (LastSeenLootTemplate[arg]) then LastSeenLootTemplate[arg] = nil end; -- Remove all associated entries that the player looted the item from.
end
-- Synopsis: Allows the player to remove undesired items from the items table using its ID or link.

addonTbl.Search = function(query)
	local itemsFound = 0;
	local questsFound = 0;
	local queryType = string.sub(query, 1, 1);
	--local query = string.match(query, queryType .. "%s" .. "(.*)");
	if tonumber(query) ~= nil then -- It's an ID
		query = tonumber(query);
		if LastSeenItemsDB[query] then
			print(query .. ": " .. LastSeenItemsDB[query].itemLink .. " (" .. addonTbl.GetCount(LastSeenLootTemplate, query) .. ") | " .. LastSeenItemsDB[query].lootDate .. " | " .. LastSeenItemsDB[query].source .. " | " ..
			LastSeenItemsDB[query].location);
			itemsFound = itemsFound + 1;
		end
	else
		for k, v in pairs(LastSeenItemsDB) do
			if v.source ~= L["INFO_MSG_MISCELLANEOUS"] or v.source or v.location or v.itemLink then
				if string.find(string.lower(v.itemLink), string.lower(query)) then
					local itemID = (GetItemInfoInstant(k));
					print(k .. ": " .. v.itemLink .. " (" .. addonTbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
					itemsFound = itemsFound + 1;
				end
				if string.find(string.lower(v.source), string.lower(query)) then
					local itemID = (GetItemInfoInstant(k));
					print(k .. ": " .. v.itemLink .. " (" .. addonTbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
					itemsFound = itemsFound + 1;
				end
				if string.find(string.lower(v.location), string.lower(query)) then
					local itemID = (GetItemInfoInstant(k));
					if v.itemLink == "" then
						print(k .. ": " .. v.itemName .. " (" .. addonTbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
					else
						if v.lootDate == nil then
							--
						else
							print(k .. ": " .. v.itemLink .. " (" .. addonTbl.GetCount(LastSeenLootTemplate, itemID) .. ") | " .. v.lootDate .. " | " .. v.source .. " | " .. v.location);
						end
					end
					itemsFound = itemsFound + 1;
				end
			end
		end
		if itemsFound == 0 then
			print(L["ADDON_NAME"] .. L["ERROR_MSG_NO_ITEMS_FOUND"] .. " (" .. query .. ")");
		else
			print(L["ADDON_NAME"] .. itemsFound .. L["INFO_MSG_RESULTS"]);
		end
	end
end
--[[
	Synopsis: Allows the player to search the items table by an item's ID or its partial/full name, a creature's name, or a zone's name.
	Use Case(s):
		- Item: The most common search is by an item's ID or partial/full name to provide another player with proof an item still drops.
		- Creature: A search to see what items a particular creature has dropped. This is made possible by keeping track of the items a creature has dropped (call a "loot table").
		- Zone: An entire zone search, doesn't matter which creature in the zone dropped the item. Provides the player with every item that dropped in the provided zone. Partial/full names supported.
]]

addonTbl.Manual = function(args)
	if args == "" then
		print(L["ADDON_NAME"]);
		print("Commands: " .. L["CMD_DISCORD"] .. ", " .. L["CMD_HISTORY"] .. ", " .. L["CMD_IMPORT"] .. ", " .. L["CMD_LOOT"] .. ", " .. L["CMD_MAN"] .. ", " .. L["CMD_REMOVE"] .. ", " .. L["CMD_SEARCH"] .. ", " .. L["CMD_VIEW"]);
	elseif args == L["CMD_DISCORD"] then
		print(L["ADDON_NAME"]);
		print("Command: " .. L["CMD_DISCORD"]);
		print("Description: Provides a link in the chat frame to the Discord server used by the addon. It's the server that belongs to the infamous ALL THE THINGS addon.");
	elseif args == L["CMD_HISTORY"] then
		print(L["ADDON_NAME"]);
		print("Command: " .. L["CMD_HISTORY"]);
		print("Description: Addon output to the chat is ephemeral, and is unavailable should the player disconnect or log off. As such, the history command can be used to review the last 20 items seen by the player's characters. This is account wide and applies to all sources.");
	elseif args == L["CMD_IMPORT"] then
		print(L["ADDON_NAME"]);
		print("Command: " .. L["CMD_IMPORT"]);
		print("Description: This will be a widely unused command, as it was implemented for users that beta tested LastSeen2, which never saw the light of day.");
	elseif args == L["CMD_LOOT"] then
		print(L["ADDON_NAME"]);
		print("Command: " .. L["CMD_LOOT"]);
		print("Description: Enables and disables a faster loot setting. If you experience performance problems, try disabling this setting, as it's enabled by default. Ill-advised to use this setting in conjunction with addons like LootLite and AutoLootPlus.");
	elseif args == L["CMD_MAN"] then
		print(L["ADDON_NAME"]);
		print("Command: " .. L["CMD_MAN"]);
		print("Description: A manual used to learn about commands.");
	elseif args == L["CMD_REMOVE"] then
		print(L["ADDON_NAME"]);
		print("Command: " .. L["CMD_REMOVE"]);
		print("Description: This will remove items from the items table. Both item ID and item links are supported.");
		print("Aliases: " .. L["CMD_REMOVE_SHORT"]);
	elseif args == L["CMD_SEARCH"] then
		print(L["ADDON_NAME"]);
		print("Command: " .. L["CMD_SEARCH"]);
		print("Description: Allows the player to search the items table by an item ID, name, or link. Search queries will query items, creatures, and zones automatically. Be as specific or ambiguous as you want.");
	elseif args == L["CMD_VIEW"] then
		print(L["ADDON_NAME"]);
		print("Command: " .. L["CMD_VIEW"]);
		print("Description: When corrupted items are discovered, they're automatically removed when the addon is loaded. This command allows the player to see a list of that which was removed.");
	end
end
-- Synopsis: The player can toss commands to this function to learn more about them.