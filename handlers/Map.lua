local addonName, addonTable = ...
local e = CreateFrame("Frame")

local function GetParentMap(mapID)
	local map = C_Map.GetMapInfo(mapID)
	if map.mapType == 3 or map.mapType == 4 then
		return map
	else
		GetParentMap(map.mapID)
	end
end

local function GetBestMapForUnit(unit)
	if UnitAffectingCombat(unit) then
		C_Timer.After(1, GetBestMapForUnit(unit))
	end
	
	return C_Map.GetMapInfo(C_Map.GetBestMapForUnit(unit))
end

e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" or event == "ZONE_CHANGED_NEW_AREA" then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local map = GetBestMapForUnit("player")
		if map then
			if map.mapType == 5 or map.mapType == 6 then
				-- The map is a micro or orphan zone, so we need to get the
				-- parent map.
				map = GetParentMap(map.mapID)
			end
			
			-- Log the map to the map table if it's a zone or dungeon map.
			if not LastSeenDB.Maps[map.mapID] and (map.mapType == 3 or map.mapType == 4) then
				LastSeenDB.Maps[map.mapID] = map.name
			end
			
			addonTable.map = map.name
		end
	end
end)