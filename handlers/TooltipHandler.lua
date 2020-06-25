-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local L = addonTbl.L;

addonTbl.OnTooltipSetItem = function(tooltip)
	local isIgnored = false;
	local _, itemLink = tooltip:GetItem();
	if not itemLink then return end;

	local itemID = (GetItemInfoInstant(itemLink)); if not itemID then return end; -- To handle reagents in the tradeskill window.

	if LastSeenItemsDB[itemID] then -- Item exists in the database; therefore, show its data.
		local frame, text;
		for i = 1, 30 do
			frame = _G[tooltip:GetName() .. "TextLeft" .. i]
			if frame then text = frame:GetText() end;
			if text and string.find(text, "LastSeen") then return end;
		end
		if addonTbl.DataIsValid(itemID) then
			tooltip:AppendText(" (|cffadd8e6" .. LastSeenItemsDB[itemID].source .. "|r)");
			tooltip:AddLine(string.format(L["ADDON_NAME"] .. "|cffadd8e6%s | %s|r", LastSeenItemsDB[itemID].location, LastSeenItemsDB[itemID].lootDate));
			tooltip:Show();
		end
	end
	
	if addonTbl.Contains(addonTbl.whitelistedItems, itemID, nil, nil) then
		-- Continue
	elseif addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(6, GetItemInfo(itemID))) then isIgnored = true;
	elseif not isIgnored then if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(7, GetItemInfo(itemID))) then isIgnored = true end;
	elseif not isIgnored then if addonTbl.Contains(addonTbl.ignoredItemCategories, nil, "itemType", select(9, GetItemInfo(itemID))) then isIgnored = true end end;
	
	if isIgnored then
		tooltip:AddLine("\n" .. L["ADDON_NAME"] .. "|cffffffff" .. L["INFO_MSG_IGNORED_ITEM"] .. "|r");
		tooltip:Show();
	end
	
	local maxSourcesInTooltip = 4;
	if addonTbl.showSources then
		for k, v in pairs(LastSeenLootTemplate) do
			if k == itemID then
				if addonTbl.GetCount(LastSeenLootTemplate[k]) >= 2 then
					tooltip:AddLine(string.format(L["ITEM_SEEN_FROM"], addonTbl.GetCount(LastSeenLootTemplate[k])));
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