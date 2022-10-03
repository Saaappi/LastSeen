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

				tooltip:AddLine("|cffFFFFFF" .. addonName .. "|r: " .. LastSeenItemDB[itemId].source .. " | " .. LastSeenItemDB[itemId].map .. " | " .. LastSeenItemDB[itemId].lootDate)
				tooltip:Show()
			end
		end
	end
	
	--[[if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then -- The item is whitelisted so don't check the blacklists.
	else
		if tbl.Contains(tbl.IgnoredItems, itemID, nil, nil) then isIgnored = true end
		if tbl.Contains(tbl.IgnoredItemTypes, nil, select(6, GetItemInfo(itemID)), nil) then isIgnored = true end
		if tbl.Contains(LastSeenIgnoredItemsDB, itemID, nil, nil) then isIgnored = true end
	end

	if isIgnored and itemRarity >= tbl.Settings["rarity"] then
		tooltip:AddLine("\n" .. tbl.L["ADDON_NAME"] .. "|cffffffff" .. tbl.L["THIS_ITEM_IS_IGNORED"] .. "|r");
		tooltip:Show();
	end]]
	
	--[[local maxSourcesInTooltip = 4
	if tbl.Settings["showSources"] then
		for k, v in pairs(tbl.LootTemplate) do
			if k == itemID then
				if tbl.GetCount(tbl.LootTemplate[k]) > 1 then
					tooltip:AddLine(tbl.L["ADDON_NAME"] .. tbl.L["SEEN_FROM"] .. tbl.GetCount(tbl.LootTemplate[k]) .. " " .. tbl.L["SOURCES"] .. ": ")
					for i, _ in pairs(v) do
						if maxSourcesInTooltip > 0 then
							tooltip:AddLine("|cffffffff" .. i .. "|r")
						end
						maxSourcesInTooltip = maxSourcesInTooltip - 1
					end
					tooltip:Show()
				end
			end
		end
	end]]
end

GameTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)
ItemRefTooltip:HookScript("OnTooltipSetItem", OnTooltipSetItem)