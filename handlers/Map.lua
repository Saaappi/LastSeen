local addonName, addonTable = ...
local e = CreateFrame("Frame")

function LastSeen:GetCombatStatus(unit)
	C_Timer.After(0.5, function()
		if UnitAffectingCombat(unit) then
			LastSeen:GetCombatStatus(unit)
		end
		return false
	end)
end

function LastSeen:GetParentMap(mapID)
	local map = C_Map.GetMapInfo(mapID)
	if (map.mapType == 3) or (map.mapType == 4) or (map.mapType == 6 and (C_Map.GetMapInfo(map.parentMapID).mapType == 2)) then
		return map
	else
		C_Timer.After(0.5, function()
			LastSeen:GetParentMap(map.parentMapID)
		end)
	end
end

function LastSeen:GetBestMapForUnit(unit)
	local isInCombat = LastSeen:GetCombatStatus("player")
	if not isInCombat then
		local map = C_Map.GetMapInfo(C_Map.GetBestMapForUnit(unit))
		if map then
			-- If the parent map to the current map is going to be a continent,
			-- then just don't bother using recursion. Return the current map.
			if (not (C_Map.GetMapInfo(map.parentMapID)).mapType == 2) then
				if (map.mapType == 5 or map.mapType == 6) and (not IsInInstance("player")) then
					-- The map is a micro or orphan zone, so we need to get the
					-- parent map. This should only apply for open-world micro and
					-- orphan zones; not instances.
					map = LastSeen:GetParentMap(map.parentMapID)
				end
			end
			return map
		else
			LastSeen:GetBestMapForUnit(unit)
		end
	end
end

e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("ZONE_CHANGED")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") or (event == "ZONE_CHANGED") or (event == "ZONE_CHANGED_NEW_AREA") then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		C_Timer.After(1, function()
			local map = LastSeen:GetBestMapForUnit("player")
			if map then
				-- Log the map to the map table if it's a zone or dungeon map.
				if not LastSeenDB.Maps[map.mapID] and (map.mapType == 3 or map.mapType == 4) then
					LastSeenDB.Maps[map.mapID] = map.name
				end
				
				addonTable.map = map.name
			end
		end)
	end
end)