-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local L = tbl.L

tbl.OnTooltipSetItem = function(tooltip)
	if tbl.Settings["mode"] == GM_SURVEY_NOT_APPLICABLE then return end
	local isIgnored = false
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end

	local itemID = (GetItemInfoInstant(itemLink)); if not itemID then return end -- To handle reagents in the tradeskill window.
	local _, _, itemRarity = GetItemInfo(itemLink); -- We don't want the ignored message on items below the addon's default rarity setting.

	if tbl.Items[itemID] then -- Item exists in the database therefore, show its data.
		local frame, text
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end
			if text and string.find(text, "LastSeen") then return end
		end
		if tbl.DataIsValid(itemID) then
			tooltip:AppendText(" (|cffadd8e6" .. tbl.Items[itemID].source .. "|r)");
			tooltip:AddLine(string.format(L["ADDON_NAME"] .. "|cffadd8e6%s | %s|r", tbl.Items[itemID].location, tbl.Items[itemID].lootDate));
			tooltip:Show();
		end
	end
	
	if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then -- The item is whitelisted so don't check the blacklists.
	else
		isItemOrItemTypeIgnored = tbl.IsItemOrItemTypeIgnored(itemID, select(6, GetItemInfo(itemID)), select(7, GetItemInfo(itemID)), select(9, GetItemInfo(itemID)))
		if isItemOrItemTypeIgnored then isIgnored = true end
	end
	
	if isIgnored and itemRarity >= tbl.Settings["rarity"] then
		tooltip:AddLine("\n" .. L["ADDON_NAME"] .. "|cffffffff" .. L["INFO_MSG_IGNORED_ITEM"] .. "|r");
		tooltip:Show();
	end
	
	local maxSourcesInTooltip = 4
	if tbl.Settings["showSources"] then
		for k, v in pairs(tbl.LootTemplate) do
			if k == itemID then
				if tbl.GetCount(tbl.LootTemplate[k]) >= 2 then
					tooltip:AddLine(string.format(L["ITEM_SEEN_FROM"], tbl.GetCount(tbl.LootTemplate[k])));
					for i, _ in pairs(v) do
						if maxSourcesInTooltip > 0 then
							tooltip:AddLine("|cffffffff" .. i .. "|r");
						end
						maxSourcesInTooltip = maxSourcesInTooltip - 1
					end
					tooltip:Show();
				end
			end
		end
	end
end
-- Synopsis: Adds text to the tooltip regarding the source of an item, the location in which the player was when the item was looted, and the date it was looted.