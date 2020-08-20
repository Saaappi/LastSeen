local addon, tbl = ...
local L = tbl.L

tbl.Search_ID = function(query)
	local itemsFound = 0
	if tbl.Items[query] then
		if tbl.Items[query]["lootedBy"]["playerClass"] ~= nil and (tbl.Items[query]["itemLink"] ~= "" or tbl.Items[query]["itemLink"] ~= nil) then
			print(query .. ": " .. 
				tbl.Items[query].itemLink .. ", " .. 
				tbl.GetCount(tbl.LootTemplate, query) .. ", " .. 
				tbl.Items[query].source .. ", " .. 
				tbl.Items[query].location .. ", " ..
				tbl.Items[query].lootDate .. ", [" .. 
				tbl.Items[query]["lootedBy"]["playerClass"] .. ", " .. tbl.Items[query]["lootedBy"]["playerLevel"] .. "]"
			)
		else
			print(query .. ": " .. 
				tbl.Items[query].itemName .. ", " .. 
				tbl.GetCount(tbl.LootTemplate, query) .. ", " .. 
				tbl.Items[query].source .. ", " .. 
				tbl.Items[query].location .. ", " ..
				tbl.Items[query].lootDate
			)
		end
		itemsFound = itemsFound + 1
	else
		for k, v in pairs(tbl.Items) do
			if v.source ~= L["INFO_MSG_MISCELLANEOUS"] or v.source or v.location or v.itemLink or v.lootDate then
				if string.find(v.lootDate, query) then
					local itemID = (GetItemInfoInstant(k))
					if v.lootedBy["playerClass"] ~= nil and (v.itemLink ~= "" or v.itemLink ~= nil) then
						print(k .. ": " .. 
							v.itemLink .. ", " .. 
							tbl.GetCount(tbl.LootTemplate, itemID) .. ", " .. 
							v.source .. ", " .. 
							v.location .. ", " .. 
							v.lootDate .. ", [" .. 
							v.lootedBy["playerClass"] .. ", " .. v.lootedBy["playerLevel"] .. "]"
						)
					else
						print(k .. ": " .. 
							v.itemName .. ", " .. 
							tbl.GetCount(tbl.LootTemplate, itemID) .. ", " .. 
							v.source .. ", " .. 
							v.location .. ", " .. 
							v.lootDate
						)
					end
					itemsFound = itemsFound + 1
				end
			end
		end
	end
	if itemsFound == 0 then
		print(L["ADDON_NAME"] .. L["ERROR_MSG_NO_ITEMS_FOUND"] .. " (" .. query .. ")")
	else
		print(L["ADDON_NAME"] .. itemsFound .. L["INFO_MSG_RESULTS"])
	end
end
--[[
Author's Note
	The else clause is here to support partial dates like 07, which are ultimately treated like numbers until you format it like 07/.
]]