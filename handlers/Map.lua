local addonName, addonTable = ...
local e = CreateFrame("Frame")

function LastSeen:GetParentMap(mapID)
	local map = C_Map.GetMapInfo(mapID)
	if map.mapType == 3 or map.mapType == 4 then
		return map
	else
		C_Timer.After(0.5, function()
			LastSeen:GetParentMap(map.mapID)
		end)
	end
end

function LastSeen:GetBestMapForUnit(unit)
	if UnitAffectingCombat(unit) then
		C_Timer.After(1, LastSeen:GetBestMapForUnit(unit))
	end
	
	local map = C_Map.GetMapInfo(C_Map.GetBestMapForUnit(unit))
	if map then
		if map.mapType == 5 or map.mapType == 6 then
			-- The map is a micro or orphan zone, so we need to get the
			-- parent map.
			map = LastSeen:GetParentMap(map.mapID)
		end
		return map
	else
		C_Timer.After(1, function()
			LastSeen:GetBestMapForUnit(unit)
		end)
	end
end

e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" or event == "ZONE_CHANGED_NEW_AREA" then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local map = LastSeen:GetBestMapForUnit("player")
		if map then
			-- Log the map to the map table if it's a zone or dungeon map.
			if not LastSeenDB.Maps[map.mapID] and (map.mapType == 3 or map.mapType == 4) then
				LastSeenDB.Maps[map.mapID] = map.name
			end
			
			addonTable.map = map.name
		end
	end
end)