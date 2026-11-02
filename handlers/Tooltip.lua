local addonName, LastSeen = ...

local function AddTextToTooltip(tooltip, source, map, lootDate)
  -- Tooltips can be rebuilt several times, so skip if our line is already there.
  local name = tooltip:GetName()
  for i = 1, 30 do
    local frame = _G[name .. "TextLeft" .. i]
    local text = frame and frame:GetText()
    if text and not issecretvalue(text) and text:find(addonName, 1, true) then
      return
    end
  end

  tooltip:AddLine("\n")
  tooltip:AddLine(format("%s: |cff52D66C%s|r | |cff52D66C%s|r | |cff52D66C%s|r", LastSeen.ColoredAddOnName(), source or "UNK", map or "UNK", lootDate or date(LastSeen.dateFormat)))
  tooltip:Show()
end

local function OnTooltipSetItem(tooltip)
  if tooltip then
    local _, _, itemID = TooltipUtil.GetDisplayedItem(tooltip)
    if not itemID or issecretvalue(itemID) then return end

    local item = LastSeenDB.Items[itemID]
    if item then
      AddTextToTooltip(tooltip, item.source, item.map, item.lootDate)
    end
  end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
