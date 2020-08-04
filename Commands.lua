local addon, addonTbl = ...;

local L = addonTbl.L;

SLASH_LastSeen1 = L["SLASH_CMD_1"];
SLASH_LastSeen2 = L["SLASH_CMD_2"];
SlashCmdList["LastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");

	if not cmd or cmd == "" then
		addonTbl.LoadSettings(false);
	elseif cmd == L["CMD_DISCORD"] then -- Gives the player the link to the Discord server.
		print(L["ADDON_NAME"] .. "https://discord.gg/7Ve8JQv");
	elseif cmd == L["CMD_FORMAT"] then -- Allows the player to change their date format for existing items.
		addonTbl.DateFormat(args);
	elseif cmd == L["CMD_HELP"] then -- Provides the available commands to the player in the chat frame.
		addonTbl.Help();
	elseif cmd == L["CMD_HISTORY"] then -- Allows the player to view the last 20 items they've acquired. This is persistent between sessions and characters.
		addonTbl.GetTable(LastSeenHistoryDB);
	elseif cmd == L["CMD_IMPORT"] then -- If the player used LastSeen2 for a short period, this command allows them to import the items from that table into the present table.
		if IsAddOnLoaded("LastSeen2") then
			local doImport = false;
			for k, v in pairs(LastSeen2ItemsDB) do
				for i, j in pairs(LastSeenItemsDB) do
					if i == k then
						doImport = false; break;
					else
						doImport = true;
					end
				end
				if doImport then table.insert(LastSeenItemsDB, k) end;
			end
		end
	elseif cmd == L["CMD_LOCALE"] and args ~= "" then -- Allows the player to change the current locale for the addon, despite the game client's current language.
		addonTbl.SetLocale(args);
		LastSeenSettingsCacheDB["locale"] = addonTbl["locale"];
	elseif cmd == L["CMD_LOOT"] then -- Enables or disables a faster loot speed.
		if addonTbl.lootFast then
			addonTbl.lootFast = not addonTbl.lootFast; LastSeenSettingsCacheDB.lootFast = addonTbl.lootFast;
			print(L["ADDON_NAME"] .. L["INFO_MSG_LOOT_DISABLED"]);
		else
			addonTbl.lootFast = true; LastSeenSettingsCacheDB.lootFast = addonTbl.lootFast;
			print(L["ADDON_NAME"] .. L["INFO_MSG_LOOT_ENABLED"]);
		end
	elseif cmd == L["CMD_MAN"] and args ~= "" then -- Allows the player to ask the addon for command usage.
		addonTbl.Manual(args);
	elseif cmd == L["CMD_REMOVE"] or cmd == L["CMD_REMOVE_SHORT"] then -- Removes an item from the items table. Accepts an ID or link.
		addonTbl.Remove(args);
	elseif cmd == L["CMD_SEARCH"] and args ~= "" then -- Searches the items table for matches to the query. Accepts creatures, items, quests, and zones.
		addonTbl.Search(args);
	elseif cmd == L["CMD_VIEW"] then -- When items with bad data are removed, this command allows the player to view them before they are removed, or report them.
		if next(addonTbl.removedItems) ~= nil then
			for k, v in pairs(addonTbl.removedItems) do
				print(k .. ": " .. v);
			end
		end
	end
end
