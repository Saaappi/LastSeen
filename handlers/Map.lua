local addonName, addon = ...
local e = CreateFrame("Frame")

local function GetCombatStatus(unit)
	C_Timer.After(0.5, function()
		if UnitAffectingCombat(unit) then
			GetCombatStatus(unit)
		end
		return false
	end)
end

--[[
-- This function was deprecated in commit 267e17e. It's slated for removal in 4.0.8 or later.
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
]]

function LastSeen:GetMapPosition(mapID)
	if (not IsInInstance("player")) then
		if (mapID) then
			local position = C_Map.GetPlayerMapPosition(mapID, "player")
			if (position) then
				return (position.x*100), (position.y*100)
			else
				C_Timer.After(0.1, function()
					LastSeen:GetMapPosition(mapID)
				end)
			end
		end
	end
	return "-", "-"
end

--[[
-- This function was deprecated in commit 267e17e. It's slated for removal in 4.0.8 or later.
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
]]

-- This is a placeholder function.
-- This function is slated to replace the "LastSeen:GetParentMap" function in 4.0.8 or later.
function LastSeen:PHF_GetParentMap(mapInfo)
	local isInCombat = GetCombatStatus("player")
	if ( isInCombat ~= true ) then
		local parentMapInfo = C_Map.GetMapInfo(mapInfo.parentMapID)
		if ( mapInfo.parentMapID == 0 ) then
			-- The parent map is unknown, so just return the given map.
			-- This has only occurred on Exile's Reach thus far.
			return mapInfo
		elseif ( parentMapInfo.mapType > 0 and parentMapInfo.mapType <= 2 ) then
			-- This map is parented by a Cosmic, World, or Continent map.
			return mapInfo
		elseif ( parentMapInfo.mapType == 5 or parentMapInfo.mapType == 6 ) then
			C_Timer.After(0.1, function()
				LastSeen:PHF_GetParentMap(parentMapInfo)
			end)
		else
			addon.map = parentMapInfo.name
			addon.mapID = parentMapInfo.mapID
		end
	end
end

e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("ZONE_CHANGED")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if (event == "PLAYER_LOGIN") or (event == "ZONE_CHANGED") or (event == "ZONE_CHANGED_NEW_AREA") then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		C_Timer.After(1, function()
			local mapInfo
			local mapID = C_Map.GetBestMapForUnit("player")
			if ( mapID ) then
				mapInfo = C_Map.GetMapInfo(mapID)
				if ( mapInfo.mapType == 5 or mapInfo.mapType == 6 ) then
					mapInfo = LastSeen:PHF_GetParentMap(mapInfo)
					addon.map = mapInfo.name
					addon.mapID = mapInfo.mapID
				else
					addon.map = mapInfo.name
					addon.mapID = mapInfo.mapID
				end
				
				-- Boss Encounter Code
				if ( mapInfo ) then
					if ( mapInfo.mapType == 4 ) or ( mapInfo.mapType == 6 ) then
						if ( IsInInstance("player") ) then
							local numEncounters = C_EncounterJournal.GetEncountersOnMap(mapInfo.mapID)
							if ( #numEncounters > 0 ) then
								for _, encounter in ipairs(numEncounters) do
									local encounterName, _, _, _, _, _, encounterID, instanceID = EJ_GetEncounterInfo(encounter.encounterID)
									if ( encounterName ) then
										if ( not LastSeenDB.Encounters[encounterID] ) then
											LastSeenDB.Encounters[encounterID] = { encounterName = encounterName, instanceID = instanceID }
										end
									end
								end
							end
						end
					end
				end
			end
		end)
	end
end)