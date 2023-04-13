local addonName, addonTable = ...

local function AddTextToTooltip(tooltip, tooltipText)
	local frame, text
	for i = 1, 30 do
		frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		if frame then text = frame:GetText() end
		if text and string.find(text, addonName) then return end
	end

	-- Add the source, map, and loot date to the
	-- tooltip of the item being looked at by the player.
	tooltip:AddLine("\n")
	tooltip:AddLine(tooltipText)
	tooltip:Show()
end

local function OnTooltipSetItem(tooltip)
	-- Don't do anything if the addon functionality is disabled.
	if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
	
	if tooltip then
		local _, _, itemID = tooltip:GetItem()
		if not itemID then return end

		local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"
		if LastSeenDB.Items[itemID] then
			-- Check if the source and map are anything other than an empty string.
			local item = LastSeenDB.Items[itemID]
			local map, source
			if item.source == nil or item.source == "" then
				source = "Unknown"
			else
				source = item.source
			end
			if item.map == nil or item.map == "" then
				map = "Unknown"
			else
				map = item.map
			end
			AddTextToTooltip(tooltip, string.format("%s: |cffFFFFFF%s|r | |cffFFFFFF%s|r | |cffFFFFFF%s|r", coloredAddOnName, source, map, LastSeenDB.Items[itemID].lootDate))
		elseif LastSeenDB.IgnoredItems[itemID] then
			AddTextToTooltip(tooltip,string.format("%s: |cffFFFFFFIGNORED|r", coloredAddOnName))
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)