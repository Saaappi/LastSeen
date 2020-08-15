-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local L = tbl.L;

tbl.OnTooltipSetItem = function(tooltip)
	if tbl.mode == GM_SURVEY_NOT_APPLICABLE then return end;
	local isIgnored = false;
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end;

	local itemID = (GetItemInfoInstant(itemLink)); if not itemID then return end; -- To handle reagents in the tradeskill window.
	local _, _, itemRarity = GetItemInfo(itemLink); -- We don't want the ignored message on items below the addon's default rarity setting.

	if LastSeenItemsDB[itemID] then -- Item exists in the database; therefore, show its data.
		local frame, text;
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end;
			if text and string.find(text, "LastSeen") then return end;
		end
		if tbl.DataIsValid(itemID) then
			tooltip:AppendText(" (|cffadd8e6" .. LastSeenItemsDB[itemID].source .. "|r)");
			tooltip:AddLine(string.format(L["ADDON_NAME"] .. "|cffadd8e6%s | %s|r", LastSeenItemsDB[itemID].location, LastSeenItemsDB[itemID].lootDate));
			tooltip:Show();
		end
	end
	
	if tbl.Contains(tbl.whitelistedItems, itemID, nil, nil) then
		-- Continue
	elseif tbl.Contains(tbl.ignoredItemCategories, nil, "itemType", select(6, GetItemInfo(itemID))) then isIgnored = true;
	elseif not isIgnored then if tbl.Contains(tbl.ignoredItemCategories, nil, "itemType", select(7, GetItemInfo(itemID))) then isIgnored = true end;
	elseif not isIgnored then if tbl.Contains(tbl.ignoredItemCategories, nil, "itemType", select(9, GetItemInfo(itemID))) then isIgnored = true end end;
	
	if isIgnored and itemRarity >= tbl.rarity then
		tooltip:AddLine("\n" .. L["ADDON_NAME"] .. "|cffffffff" .. L["INFO_MSG_IGNORED_ITEM"] .. "|r");
		tooltip:Show();
	end
	
	local maxSourcesInTooltip = 4;
	if tbl.showSources then
		for k, v in pairs(LastSeenLootTemplate) do
			if k == itemID then
				if tbl.GetCount(LastSeenLootTemplate[k]) >= 2 then
					tooltip:AddLine(string.format(L["ITEM_SEEN_FROM"], tbl.GetCount(LastSeenLootTemplate[k])));
					for i, _ in pairs(v) do
						if maxSourcesInTooltip > 0 then
							tooltip:AddLine("|cffffffff" .. i .. "|r");
						end
						maxSourcesInTooltip = maxSourcesInTooltip - 1;
					end
					tooltip:Show();
				end
			end
		end
	end
end
-- Synopsis: Adds text to the tooltip regarding the source of an item, the location in which the player was when the item was looted, and the date it was looted.