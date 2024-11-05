local addonName, LastSeen = ...

local function AddTextToTooltip(tooltip, source, map, lootDate, itemCount)
	local frame, text
	for i = 1, 30 do
		frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		if frame then text = frame:GetText() end
		if text and string.find(text, addonName) then return end
	end

	tooltip:AddLine("\n")
	tooltip:AddLine(format("%s: |cff52D66C%s|r | |cff52D66C%s|r | |cff52D66C%s|r", LastSeen.ColoredAddOnName(), source or "UNK", map or "UNK", lootDate or date(LastSeen.dateFormat)))
	tooltip:Show()
end

local function OnTooltipSetItem(tooltip)
	if tooltip then
		local _, _, itemID = TooltipUtil.GetDisplayedItem(tooltip)
		if not itemID then return end

		if LastSeenDB.Items[itemID] then
			local item = LastSeenDB.Items[itemID]
			AddTextToTooltip(tooltip, item.source, item.map, LastSeenDB.Items[itemID].lootDate)
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)