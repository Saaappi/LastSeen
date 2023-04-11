local addonName, addonTable = ...

local function AddTextToTooltip(tooltip, tooltipText)
	local frame, text
	for i = 1, 30 do
		frame = _G[tooltip:GetName() .. "TextLeft" .. i]
		if frame then text = frame:GetText() end
		if text and string.find(text, addonName) then return end
	end
	
	-- Check if the source is anything other than an empty string.
	local source = LastSeenDB.Items[itemID].source
	if source == "" then
		source = "Unknown"
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
	
	local _, itemLink = tooltip:GetItem()
	if not itemLink then return end

	local itemID = (GetItemInfoInstant(itemLink))
	if itemID then
		local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"
		if LastSeenDB.Items[itemID] then
			AddTextToTooltip(tooltip, string.format("%s: |cffFFFFFF%s|r | |cffFFFFFF%s|r | |cffFFFFFF%s|r", coloredAddOnName, source, LastSeenDB.Items[itemID].map, LastSeenDB.Items[itemID].lootDate))
		elseif LastSeenDB.IgnoredItems[itemID] then
			AddTextToTooltip(tooltip,string.format("%s: |cffFFFFFFIGNORED|r", coloredAddOnName))
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)