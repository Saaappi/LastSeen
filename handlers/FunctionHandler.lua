local addon, addonTbl = ...;

local L = addonTbl.L; -- Create a local reference to the global localization table.
local itemDBRef;

addonTbl.GetCount = function(tbl, itemID)
	local count = 0;
	if not itemID then itemID = 0 end; -- The itemID parameter is optional. If not passed, assign it a 0.
	if itemID == 0 then -- Counting the number of records within an entire table.
		for _ in pairs(tbl) do count = count + 1 end;
		return count;
	else -- Counting the number of times an individual item has been seen.
		if tbl[itemID] then
			for creature in pairs(tbl[itemID]) do
				count = count + tbl[itemID][creature];
			end
		end
		return count; 
	end
end
-- Synopsis: Used to count records in a table or how many times an item has been seen by the player.

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

addonTbl.GetCurrentMap = function()
	local uiMapID = C_Map.GetBestMapForUnit("player");
	local isInInstance;
	
	if uiMapID then -- A map ID was found and is usable.
		local uiMap = C_Map.GetMapInfo(uiMapID);
		if not uiMap.mapID then return end;
		if not LastSeenMapsDB[uiMap.mapID] then
			LastSeenMapsDB[uiMap.mapID] = uiMap.name;
		end

		addonTbl.currentMap = uiMap.name;
	else
		C_Timer.After(3, addonTbl.GetCurrentMap); -- Recursively call the function every 3 seconds until a map ID is found.
	end
	
	return addonTbl.currentMap;
end
-- Synopsis: Gets the player's current map so an item can be accurately recorded.

addonTbl.DataIsValid = function(itemID)
	if itemID == nil then
		return false;
	end

	itemDBRef = LastSeenItemsDB[itemID]
	if itemDBRef == nil then
		return false;
	end

	if itemDBRef["location"] and itemDBRef["lootDate"] and itemDBRef["source"] then
		return true;
	else
		return false;
	end
end
--[[
	Synopsis: Checks the location, lootDate, and source for a non-nil value.
	Written by: Arcanemagus
]]

addonTbl.OnTooltipSetItem = function(tooltip)
	local isIgnored = false;
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end;

	local itemID = (GetItemInfoInstant(itemLink)); if not itemID then return end; -- To handle reagents in the tradeskill window.

	local itemTypeID = select(12, GetItemInfo(itemID));

	if LastSeenItemsDB[itemID] then -- Item exists in the database; therefore, show its data.
		local frame, text;
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end;
			if text and string.find(text, "LastSeen") then return end;
		end
		if addonTbl.DataIsValid(itemID) then
			tooltip:AppendText(" (|cffadd8e6" .. LastSeenItemsDB[itemID].source .. "|r)");
			tooltip:AddLine(L["ADDON_NAME"] .. "|cffadd8e6" .. LastSeenItemsDB[itemID].location .. "|r | |cffadd8e6" .. LastSeenItemsDB[itemID].lootDate .. "|r");
			tooltip:Show();
		end
	end
	
	if addonTbl.Contains(addonTbl.whitelistedItems, itemID, nil, nil) then
		-- Continue
	elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(6, GetItemInfo(itemID))) then isIgnored = true;
	elseif not isIgnored then if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(7, GetItemInfo(itemID))) then isIgnored = true end;
	elseif not isIgnored then if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(9, GetItemInfo(itemID))) then isIgnored = true end end;
	
	if isIgnored then
		tooltip:AddLine("\n" .. L["ADDON_NAME"] .. "|cffffffff" .. L["INFO_MSG_IGNORED_ITEM"] .. "|r");
		tooltip:Show();
	end
end
-- Synopsis: Adds text to the tooltip regarding the source of an item, the location in which the player was when the item was looted, and the date it was looted.

addonTbl.ExtractItemLink = function(constant)
	local extractedLink, itemID, itemLink;
	
	if string.find(constant, L["LOOT_ITEM_PUSHED_SELF"]) then
		extractedLink = string.match(constant, L["LOOT_ITEM_PUSHED_SELF"] .. "(.*).");
		itemID = GetItemInfoInstant(extractedLink);
	elseif string.find(constant, L["LOOT_ITEM_SELF"]) then
		extractedLink = string.match(constant, L["LOOT_ITEM_SELF"] .. "(.*).");
		itemID = GetItemInfoInstant(extractedLink);
	end
	
	if itemID then
		itemLink = select(2, GetItemInfo(itemID));
	end
	
	if itemLink then return itemLink end;
end
-- Synopsis: Whenever an item is looted, its link is at the end of a constant like "You received loot". This function
-- extracts the link and discards the fluff.

addonTbl.GetTableKeyFromValue = function(tbl, query)
	for k, v in pairs(tbl) do
		if v == query then
			return k;
		end
	end
	return false;
end
-- Synopsis: Gets a key in a table from the value, a reverse lookup.

addonTbl.Contains = function(tab, key, sub_key, value)
	for index, sub_tab in pairs(tab) do
		if key then -- The passed table doesn't use numeric indices.
			if sub_key ~= nil then
				if value then
					if tab[key][sub_key] == value then return true end;
				else
					return tab[key][sub_key] ~= nil;
				end
			else
				return tab[key] ~= nil;
			end
		else -- This table uses numeric indices.
			if tab[index][sub_key] == value then return true end;
		end
	end
	return false;
end
--[[
	Synopsis: Allows the caller to look for a key or a sub key for any passed table.
	Arguments:
		tab: 		This is the table we want to look in.
		key: 		This is the main element in the table.
		sub_key:	This is the element within the main element. It can be a table on its own.
		value:		When a table uses numeric indices, it's likely the user wants to lookup a value associated to a sub_key.
]]

addonTbl.GetTable = function(tbl)
	if tbl == LastSeenHistoryDB then
		for i = #tbl, 1, -1 do
			print("|T" .. tbl[i].itemIcon .. ":0|t " .. tbl[i].itemLink .. " | " .. tbl[i].source .. " | " .. tbl[i].location .. " | " .. tbl[i].lootDate);
		end
	end
end
-- Synopsis: Used to iterate over a table to get its content.

addonTbl.RollHistory = function()
	local historyEntries = addonTbl.GetCount(LastSeenHistoryDB);
	if historyEntries > addonTbl.maxHistoryEntries then
		for i = #LastSeenHistoryDB, 1, -1 do
			if i > addonTbl.maxHistoryEntries then
				table.remove(LastSeenHistoryDB, i);
			end
		end
	end
end
-- Synopsis: Maintains the history table, to always keep it at the maximum number of entries, which is currently 20.

addonTbl.GetItemInfo = function(itemLink, slot)
	local lootSources = { GetLootSourceInfo(slot) };

	if itemLink then
		itemLink = addonTbl.ExtractItemLink(L["LOOT_ITEM_SELF"] .. itemLink); -- The item link isn't formatted correctly from the GetLootSlotLink() function.
		local itemID, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon;
		for j = 1, #lootSources, 2 do
			if itemLink then
				itemName = GetItemInfo(itemLink);
				itemRarity = select(3, GetItemInfo(itemLink));
				itemID, itemType, itemSubType, itemEquipLoc, itemIcon = GetItemInfoInstant(itemLink);
				local type, _, _, _, _, creatureID = strsplit("-", lootSources[j]);
				if itemID then -- To catch items without an item ID.
					addonTbl.itemsToSource[itemID] = tonumber(creatureID);
					addonTbl.itemSourceCreatureID = addonTbl.itemsToSource[itemID];
					
					if itemRarity >= addonTbl.rarity then
						if addonTbl.Contains(addonTbl.whitelistedItems, itemID, nil, nil) then
							-- Continue
						elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemType) then return;
						elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemSubType) then return;
						elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", itemEquipLoc) then return;
						elseif addonTbl.Contains(addonTbl.ignoredItems, itemID, nil, nil) then return end;
						
						if LastSeenItemsDB[itemID] then -- Item seen again.
							if LastSeenCreaturesDB[addonTbl.itemSourceCreatureID] then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Creature", LastSeenCreaturesDB[addonTbl.itemSourceCreatureID].unitName, "Update");
							elseif addonTbl.encounterID then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Encounter", LastSeenEncountersDB[addonTbl.encounterID], "Update");
							elseif addonTbl.target ~= "" then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Object", addonTbl.target, "Update");
							else
								if addonTbl.mode ~= L["QUIET_MODE"] then print(L["ADDON_NAME"] .. itemLink .. L["ERROR_MSG_UNKNOWN_SOURCE"]) end;
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Miscellaneous", L["INFO_MSG_MISCELLANEOUS"], "Update");
							end
						else -- Item seen for first time.
							if LastSeenCreaturesDB[addonTbl.itemSourceCreatureID] then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Creature", LastSeenCreaturesDB[addonTbl.itemSourceCreatureID].unitName, "New");
							elseif addonTbl.encounterID then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Encounter", LastSeenEncountersDB[addonTbl.encounterID], "New");
							elseif addonTbl.target ~= "" then
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Object", addonTbl.target, "New");
							else
								if addonTbl.mode ~= L["QUIET_MODE"] then print(L["ADDON_NAME"] .. itemLink .. L["ERROR_MSG_UNKNOWN_SOURCE"]) end;
								addonTbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, L["DATE"], addonTbl.currentMap, "Miscellaneous", L["INFO_MSG_MISCELLANEOUS"], "New");
							end
						end
					end
				end
			end
		end
	end
end
-- Synopsis: Fetches an item's information just before it's looted from the window, and then sends it down the pipeline to addonTbl.AddItem.