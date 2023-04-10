local addonName, addonTable = ...

local function OnTooltipSetItem(tooltip)
	-- Don't do anything if the addon functionality is disabled.
	if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
	
	local _, itemLink = tooltip:GetItem()
	if not itemLink then return end

	local itemID = (GetItemInfoInstant(itemLink))
	if itemID then
		if LastSeenDB.Items[itemID] then
			local frame, text
			
			for i = 1, 30 do
				frame = _G[tooltip:GetName() .. "TextLeft" .. i]
				if frame then text = frame:GetText() end
				if text and string.find(text, addonName) then return end
			end

			-- Add the source, map, and loot date to the
			-- tooltip of the item being looked at by the player.
			local coloredAddOnName = "|cff009AE4" .. addonName .. "|r"
			tooltip:AddLine("\n")
			tooltip:AddLine(string.format("%s: |cffFFFFFF%s|r | |cffFFFFFF%s|r | |cffFFFFFF%s|r", coloredAddOnName, LastSeenDB.Items[itemID].source, LastSeenDB.Items[itemID].map, LastSeenDB.Items[itemID].lootDate))
			tooltip:Show()
		end
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
--GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
--ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)