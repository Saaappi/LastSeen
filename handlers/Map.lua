local addonName, addonTable = ...
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

function LastSeen:GetBestMapForUnit(unit)
	local isInCombat = GetCombatStatus("player")
	if (not isInCombat) then
		local map = C_Map.GetMapInfo(C_Map.GetBestMapForUnit(unit))
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
			return map
		else
			C_Timer.After(0.2, function()
				LastSeen:GetBestMapForUnit(unit)
			end)
		end
	end
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
		
		C_Timer.After(0.5, function()
			local map = LastSeen:GetBestMapForUnit("player")
			if (map) then
				if (not LastSeenDB.Maps[map.mapID] and (map.mapType == 3 or map.mapType == 4)) then
					LastSeenDB.Maps[map.mapID] = map.name
				end
				addonTable.map = map.name
			end
		end)
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
				addonTable.map = map.name
			end
		end)
	end
end)