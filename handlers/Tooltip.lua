local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

local function OnTooltipSetItem(tooltip)
	if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
	
	local _, itemLink = tooltip:GetItem()
	if not itemLink then return end

	local itemId = (GetItemInfoInstant(itemLink))
	if itemId then
		local _, _, itemRarity = GetItemInfo(itemId)
		if itemRarity then
			if LastSeenItemDB[itemId] then
				local frame, text
				
				for i = 1, 30 do
					frame = _G[tooltip:GetName() .. "TextLeft" .. i]
					if frame then text = frame:GetText() end
					if text and string.find(text, addonName) then return end
				end
				
				-- If Show # of Sources is enabled, then let's
				-- count the number of sources and display that
				-- information in the tooltip.
				if LastSeenDB.ShowNumSourcesEnabled then
					local numSources = 0
					if LastSeenLootTemplateDB[itemId] then
						for _ in pairs(LastSeenLootTemplateDB[itemId]) do numSources = numSources + 1 end
					end
					tooltip:AddLine(L_GLOBALSTRINGS["UI.Tooltip.Text.Sources"] .. ": " .. numSources)
				end

				-- Add the source, map, and loot date to the
				-- tooltip of the item being looked at by the player.
				tooltip:AddLine(LastSeenItemDB[itemId].source .. " | " .. LastSeenItemDB[itemId].map .. " | " .. LastSeenItemDB[itemId].lootDate)
				tooltip:Show()
			end
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)