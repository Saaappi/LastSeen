local _, LastSeen = ...

local MAX_ATTEMPTS = 5
local RETRY_DELAY = 1
local pending = {}

-- Reads the name from a creature hyperlink, so no live unit (and no secret) is involved.
local function LookupName(npcID)
  local data = C_TooltipInfo.GetHyperlink(format("unit:Creature-0-0-0-0-%d-0000000000", npcID))
  local line = data and data.lines and data.lines[1]
  local name = line and line.leftText
  if name and not issecretvalue(name) and name ~= "" and name ~= UNKNOWN then
    return name
  end
end

-- Items logged before the name was known are patched as soon as it arrives.
local function Apply(npcID, name)
  LastSeenDB.Creatures[npcID] = name
  for _, item in pairs(LastSeenDB.Items) do
    if item.sourceType == "Creature" and item.sourceID == npcID and item.source == "Unknown" then
      item.source = name
    end
  end
end

-- The client may not have the creature cached yet, so retry a few times.
local function Resolve(npcID, attempt)
  local name = LookupName(npcID)
  if name then
    pending[npcID] = nil
    Apply(npcID, name)
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

-- Resolves unknown creature names for items looted somewhere restricted (e.g. instances).
-- Returns how many lookups were started and how many items have no usable ID.
LastSeen.ResolveUnknownCreatures = function()
  local started, noID = 0, 0
  for _, item in pairs(LastSeenDB.Items) do
    if item.sourceType == "Creature" and item.source == "Unknown" then
      local npcID = item.sourceID
      if not npcID or npcID == 0 then
        noID = noID + 1
      elseif not pending[npcID] then
        pending[npcID] = true
        started = started + 1
        Resolve(npcID, 1)
      end
    end
  end
  return started, noID
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", function()
  if not IsInInstance() then
    C_Timer.After(5, LastSeen.ResolveUnknownCreatures)
  end
end)
