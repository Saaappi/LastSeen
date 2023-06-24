local addonName, addon = ...
local e = CreateFrame("Frame")
local isOnLoadScreen = false

local function GetCombatStatus(unit)
	C_Timer.After(0.5, function()
		if UnitAffectingCombat(unit) then
			GetCombatStatus(unit)
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

function LastSeen:GetMapPosition(mapID)
	if (not IsInInstance("player")) then
		local position = C_Map.GetPlayerMapPosition(mapID, "player")
		if (position) then
			return (position.x*100), (position.y*100)
		else
			C_Timer.After(0.1, function()
				addon.GetMapPosition(mapID)
			end)
		end
	end
	return "-", "-"
end

function LastSeen:GetBestMapForUnit(unit)
	C_Timer.After(0.5, function()
		local isInCombat = GetCombatStatus("player")
		if (not isInCombat) then
			local mapID = C_Map.GetBestMapForUnit(unit)
			if (mapID) then
				local map = C_Map.GetMapInfo(mapID)
				if (map) then
					if (map.mapType ~= 3) or (map.mapType ~= 4) then
						if ((C_Map.GetMapInfo(map.parentMapID)).mapType ~= 2) then
							if (map.mapType == 5) or (map.mapType == 6) then
								if (not IsInInstance("player")) then
									map = LastSeen:GetParentMap(map.parentMapID)
								end
							end
						end
					end
					if (not LastSeenDB.Maps[map.mapID] and (map.mapType == 3 or map.mapType == 4)) then
						LastSeenDB.Maps[map.mapID] = map.name
					end
					addon.map = map.name
					addon.mapID = map.mapID
				end
			else
				C_Timer.After(0.2, function()
					LastSeen:GetBestMapForUnit(unit)
				end)
			end
		end
	end)
end

e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("LOADING_SCREEN_ENABLED")
e:RegisterEvent("LOADING_SCREEN_DISABLED")
e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("ZONE_CHANGED")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") or (event == "ZONE_CHANGED") or (event == "ZONE_CHANGED_NEW_AREA") then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		if isOnLoadScreen then return end
		
		local map = LastSeen:GetBestMapForUnit("player")
	end
	if (event == "LOADING_SCREEN_ENABLED") then
		isOnLoadScreen = true
	end
	if (event == "LOADING_SCREEN_DISABLED") then
		C_Timer.After(5, function()
			isOnLoadScreen = false
			local map = LastSeen:GetBestMapForUnit("player")
			if (map) then
				if (not LastSeenDB.Maps[map.mapID] and (map.mapType == 3 or map.mapType == 4)) then
					LastSeenDB.Maps[map.mapID] = map.name
				end
				addon.map = map.name
				addon.mapID = map.mapID
			end
		end)
	end
end)