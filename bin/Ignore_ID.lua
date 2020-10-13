local addon, tbl = ...

-- When an item is ignored, if it exists in the primary items table, then it's removed.

tbl.Ignore_ID = function(query)
	local itemID = query
	if itemID then
		if tbl.IgnoredItems[itemID] then
			tbl.IgnoredItems[itemID] = nil
		else
			tbl.IgnoredItems[itemID] = tbl.L["MANUALLY_IGNORED_ITEM"]
			tbl.Items[itemID] = nil
			print(tbl.L["ADDON_NAME"] .. tbl.L["IGNORING"] .. " " .. itemID .. ".")
		end
	end
end