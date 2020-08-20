local addon, tbl = ...

SLASH_LastSeen1 = tbl.L["COMMAND_SLASH1"]
SLASH_LastSeen2 = tbl.L["COMMAND_SLASH2"]
SlashCmdList["LastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)")

	if not cmd or cmd == "" then
		tbl.LoadSettings()
	elseif cmd == tbl.L["COMMAND_FORMAT"] then -- Allows the player to change their date format for existing items.
		tbl.DateFormat(args)
	elseif cmd == tbl.L["COMMAND_HISTORY"] then -- Allows the player to view the last 20 items they've acquired. This is persistent between sessions and characters.
		tbl.GetTable(tbl.History)
	elseif cmd == tbl.L["COMMAND_LOCALE"] and args ~= "" then -- Allows the player to change the current locale for the addon, despite the game client's current language.
		tbl.SetLocale(args)
	elseif cmd == tbl.L["COMMAND_LOOT"] then -- Enables or disables a faster loot speed.
		if tbl.Settings["lootFast"] then
			tbl.Settings["lootFast"] = not tbl.Settings["lootFast"]; tbl.Settings.lootFast = tbl.Settings["lootFast"]
			print(tbl.L["ADDON_NAME"] .. tbl.L["LOOT_FAST_DISABLED"])
		else
			tbl.Settings["lootFast"] = true tbl.Settings.lootFast = tbl.Settings["lootFast"];
			print(tbl.L["ADDON_NAME"] .. tbl.L["LOOT_FAST_ENABLED"])
		end
	elseif cmd == tbl.L["COMMAND_PROGRESS"] then -- Allows the player to view their tracking progress.
		tbl.CheckProgress()
	elseif cmd == tbl.L["COMMAND_REMOVE"] or cmd == tbl.L["COMMAND_REMOVE_SHORT"] then -- Removes an item from the items table. Accepts an ID or link.
		tbl.Remove(args)
	elseif cmd == tbl.L["COMMAND_SEARCH"] and args ~= "" then -- Searches the items table for matches to the query. Accepts creatures, items, quests, and zones.
		tbl.Search(args)
	elseif cmd == tbl.L["COMMAND_VIEW"] then -- When items with bad data are removed, this command allows the player to view them before they are removed, or report them.
		if next(tbl.removedItems) ~= nil then
			for k, v in pairs(tbl.removedItems) do
				print(k .. ": " .. v)
			end
		end
	end
end
