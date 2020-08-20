local addon, tbl = ...

tbl.Search_Text = function(query)
	local itemsFound = 0
	for k, v in pairs(tbl.Items) do
		if v.source ~= tbl.L["INFO_MSG_MISCELLANEOUS"] or v.source or v.location or v.itemLink or v.lootDate then
			if string.find(string.lower(v.itemLink), string.lower(query)) or string.find(string.lower(v.itemName), string.lower(query)) then
				local itemID = (GetItemInfoInstant(k))
				if v.lootedBy["playerClass"] ~= nil then
					tbl.Print(k, v.itemLink, tbl.GetCount(tbl.LootTemplate, itemID), v.source, v.location, v.lootDate, v.lootedBy["playerClass"], v.lootedBy["playerLevel"])
				else
					tbl.Print(k, v.itemLink, tbl.GetCount(tbl.LootTemplate, itemID), v.source, v.location, v.lootDate)
				end
				itemsFound = itemsFound + 1
			end
			if string.find(string.lower(v.source), string.lower(query)) then
				local itemID = (GetItemInfoInstant(k));
				if v.lootedBy["playerClass"] ~= nil then
					tbl.Print(k, v.itemLink, tbl.GetCount(tbl.LootTemplate, itemID), v.source, v.location, v.lootDate, v.lootedBy["playerClass"], v.lootedBy["playerLevel"])
				else
					tbl.Print(k, v.itemLink, tbl.GetCount(tbl.LootTemplate, itemID), v.source, v.location, v.lootDate)
				end
				itemsFound = itemsFound + 1
			end
			if string.find(string.lower(v.location), string.lower(query)) then
				local itemID = (GetItemInfoInstant(k));
				if v.lootedBy["playerClass"] ~= nil then
					tbl.Print(k, v.itemLink, tbl.GetCount(tbl.LootTemplate, itemID), v.source, v.location, v.lootDate, v.lootedBy["playerClass"], v.lootedBy["playerLevel"])
				else
					tbl.Print(k, v.itemLink, tbl.GetCount(tbl.LootTemplate, itemID), v.source, v.location, v.lootDate)
				end
				itemsFound = itemsFound + 1
			end
			if string.find(v.lootDate, query) then
				local itemID = (GetItemInfoInstant(k));
				if v.lootedBy["playerClass"] ~= nil then
					tbl.Print(k, v.itemLink, tbl.GetCount(tbl.LootTemplate, itemID), v.source, v.location, v.lootDate, v.lootedBy["playerClass"], v.lootedBy["playerLevel"])
				else
					tbl.Print(k, v.itemLink, tbl.GetCount(tbl.LootTemplate, itemID), v.source, v.location, v.lootDate)
				end
				itemsFound = itemsFound + 1
			end
		end
	end
	if itemsFound == 0 then
		print(tbl.L["ADDON_NAME"] .. tbl.L["NO_ITEMS_FOUND"] .. " (" .. query .. ")")
	else
		print(tbl.L["ADDON_NAME"] .. itemsFound .. tbl.L["RESULTS"])
	end
end