local addon, tbl = ...

tbl.Ignore_Text = function(query)
	local itemLink = query
	if itemLink then
		if string.find(string.lower(itemLink), "hitem") then -- This is an item link, and not an item's name.
			local itemID = tonumber(string.match(itemLink, "Hitem:(.-):"))
			if tbl.IgnoredItemsOrItemTypes[itemID] then -- The item was already ignored, so let's remove it instead.
				tbl.IgnoredItemsOrItemTypes[itemID] = nil
			else
				tbl.IgnoredItemsOrItemTypes[itemID] = itemLink
				tbl.Items[itemID] = nil
				print(tbl.L["ADDON_NAME"] .. tbl.L["IGNORING"] .. " " .. itemLink .. ".")
			end
		end
	end
end