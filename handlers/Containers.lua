local _, LastSeen = ...

-- Approach:
--  1) Hook C_Container.UseContainerItem() and UseItemByName to remember the
--     last item the player attempted to use.
--  2) When LOOT_OPENED fires shortly afterward, treat the remembered item
--     as the active container source for the loot window.
--  3) In Core.lua, when GetLootSourceInfo() provides no usable source, fall
--     back to this active container source.

local C_Container = C_Container
local C_Item = C_Item
local GetTime = GetTime

LastSeen.ContainerLoot = LastSeen.ContainerLoot or {
  lastUsed = nil, -- { time, itemLink?, itemID? }
  active = nil,   -- { time, itemLink?, itemID? }
}

local function CaptureLastUsed(itemLink, itemID)
  if not itemLink and not itemID then
    return
  end

  LastSeen.ContainerLoot.lastUsed = {
    time = GetTime(),
    itemLink = itemLink,
    itemID = itemID
  }
end

-- Containers (right-click to open)
if C_Container and C_Container.UseContainerItem then
  hooksecurefunc(C_Container, "UseContainerItem", function(bagID, slotIndex)
    local itemLink = C_Container.GetContainerItemLink(bagID, slotIndex)
    local itemID = itemLink and C_Item and C_Item.GetItemInfoInstant(itemLink) or nil
    CaptureLastUsed(itemLink, itemID)
  end)
end

-- Macros may not trigger UseContainerItem. (e.g. /use Loot-Filled Pumpkin)
-- These hooks are *permissive*; we only use the captured item if LOOT_OPENED
-- happens immediately afterward, and only as a fallback when normal loot source(s)
-- fail.
if type(C_Item.UseItemByName) == "function" then
  hooksecurefunc(C_Item, "UseItemByName", function(item)
    if type(item) ~= "string" then
      return
    end

    local itemID = C_Item and C_Item.GetItemInfoInstant(item) or nil
    local itemLink = (itemID and item:find("item:", 1, true)) and item or nil
    CaptureLastUsed(itemLink, itemID)
  end)
end

-- Called from Core.lua on LOOT_OPENED.
function LastSeen.ContainerLootOnLootOpened()
  local lastUsed = LastSeen.ContainerLoot.lastUsed
  if not lastUsed then
    LastSeen.ContainerLoot.active = nil
    return
  end

  -- 1.5-second window for conservation and avoids mis-attribution on slower clients.
  if (GetTime() - (lastUsed.time or 0)) <= 1.5 then
    LastSeen.ContainerLoot.active = lastUsed
  else
    LastSeen.ContainerLoot.active = nil
  end
end

-- Called from Core.lua on LOOT_CLOSED
function LastSeen.ContainerLootOnLootClosed()
  LastSeen.ContainerLoot.active = nil
end

-- Asynchronous helper that resolves the active container item into a source triplet.
-- callback(sourceType, sourceID, sourceName)
function LastSeen.WithActiveContainerLootSource(callback)
  if type(callback) ~= "function" then
    return
  end

  local active = LastSeen.ContainerLoot.active
  if not active or (not active.itemLink and not active.itemID) then
    callback(nil, nil, nil)
    return
  end

  local sourceItem
  if active.itemLink then
    sourceItem = Item:CreateFromItemLink(active.itemLink)
  else
    sourceItem = Item:CreateFromItemID(active.itemID)
  end

  sourceItem:ContinueOnItemLoad(function()
    callback("Item", sourceItem:GetItemID(), sourceItem:GetItemName())
  end)
end