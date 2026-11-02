local _, LastSeen = ...

local MAX_ATTEMPTS = 5
local RETRY_DELAY = 1
local pending = {}
local patchQueued

-- Reads the name from a creature hyperlink; no live unit, so no secret unit name.
local function LookupName(npcID)
  local data = C_TooltipInfo.GetHyperlink(format("unit:Creature-0-0-0-0-%d-0000000000", npcID))
  local line = data and data.lines and data.lines[1]
  local name = line and line.leftText
  if name and not issecretvalue(name) and name ~= "" and name ~= UNKNOWN then
    return name
  end
end

-- One pass per batch, however many names resolved.
local function PatchItems()
  patchQueued = false
  for _, item in pairs(LastSeenDB.Items) do
    if item.sourceType == "Creature" and item.source == "Unknown" then
      item.source = LastSeenDB.Creatures[item.sourceID] or item.source
    end
  end
end

-- The client may not have the creature cached yet, so retry a few times.
local function Resolve(npcID, attempt)
  local name = LookupName(npcID)
  if name then
    pending[npcID] = nil
    LastSeenDB.Creatures[npcID] = name
    if not patchQueued then
      patchQueued = true
      C_Timer.After(0, PatchItems)
    end
  elseif attempt < MAX_ATTEMPTS then
    C_Timer.After(RETRY_DELAY, function()
      Resolve(npcID, attempt + 1)
    end)
  else
    pending[npcID] = nil
  end
end

LastSeen.GetCreatureName = function(npcID)
  local name = LastSeenDB.Creatures[npcID]
  if (not name or name == "Unknown") and npcID ~= 0 and not pending[npcID] then
    pending[npcID] = true
    Resolve(npcID, 1)
    name = LastSeenDB.Creatures[npcID]
  end
  return name or "Unknown"
end

-- Names can't be read inside instances, so items looted there are resolved afterwards.
local function ResolveUnknown()
  for _, item in pairs(LastSeenDB.Items) do
    local npcID = item.sourceID
    if item.sourceType == "Creature" and item.source == "Unknown" and npcID and npcID ~= 0 and not pending[npcID] then
      pending[npcID] = true
      Resolve(npcID, 1)
    end
  end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function()
  if not IsInInstance() then
    C_Timer.After(5, ResolveUnknown)
  end
end)
