-- Namespace Variables
local addon, tbl = ...;

tbl.OnTooltipSetItem = function(tooltip)
	if tbl.Settings["mode"] == tbl.L["SILENT"] then return end
	local isIgnored = false
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end

	local itemID = (GetItemInfoInstant(itemLink)); if not itemID then return end -- To handle reagents in the tradeskill window.
	local _, _, itemRarity = GetItemInfo(itemLink); -- We don't want the ignored message on items below the addon's default rarity setting.
	if not itemRarity then return end -- Sometimes itemRarity can be nil, I guess...

	if tbl.Items[itemID] then -- Item exists in the database therefore, show its data.
		local frame, text
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end
			if text and string.find(text, "LastSeen") then return end
		end
		if tbl.DataIsValid(itemID) then
			tooltip:AppendText(" (|cffadd8e6" .. tbl.Items[itemID].source .. "|r)")
			tooltip:AddLine(tbl.L["ADDON_NAME"] .. "|cffadd8e6" .. tbl.Items[itemID].location .. " | " .. tbl.Items[itemID].lootDate .. "|r")
			tooltip:Show()
		end
	end
	
	if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then -- The item is whitelisted so don't check the blacklists.
	else
		if tbl.Contains(tbl.IgnoredItems, itemID, nil, nil) then isIgnored = true end
		if tbl.Contains(tbl.IgnoredItemTypes, nil, select(6, GetItemInfo(itemID)), nil) then isIgnored = true end
		if tbl.Contains(LastSeenIgnoredItemsDB, itemID, nil, nil) then isIgnored = true end
	end

	if isIgnored and itemRarity >= tbl.Settings["rarity"] then
		tooltip:AddLine("\n" .. tbl.L["ADDON_NAME"] .. "|cffffffff" .. tbl.L["THIS_ITEM_IS_IGNORED"] .. "|r");
		tooltip:Show();
	end
	
	local maxSourcesInTooltip = 4
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
	end
end
-- Synopsis: Adds text to the tooltip regarding the source of an item, the location in which the player was when the item was looted, and the date it was looted.

tbl.GetQuestRewardFrameItemLinksOnHover = function(tooltip)
	if tooltip then
		if tbl.allowQuestFrameTooltipScans then
			local itemID, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon
			local _, itemLink = tooltip:GetItem()
			if itemLink then
				itemID = (GetItemInfoInstant(itemLink))
				itemName = (GetItemInfo(itemLink))
				itemRarity = select(3, GetItemInfo(itemLink))
				itemType = select(6, GetItemInfo(itemLink))
				itemSubType = select(7, GetItemInfo(itemLink))
				itemEquipLoc = select(9, GetItemInfo(itemLink))
				itemIcon = select(5, GetItemInfoInstant(itemLink))
				
				if tbl.Items[itemID] then
					tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, tbl.L["DATE"], tbl.currentMap, "Quest", tbl.questTitle, tbl.playerClass, tbl.playerLevel, "Update")
				else
					tbl.AddItem(itemID, itemLink, itemName, itemRarity, itemType, itemSubType, itemEquipLoc, itemIcon, tbl.L["DATE"], tbl.currentMap, "Quest", tbl.questTitle, tbl.playerClass, tbl.playerLevel, "New")
				end
			end
		end
	end
end