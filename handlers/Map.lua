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

e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("ZONE_CHANGED")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if ( event == "PLAYER_LOGIN" ) or ( event == "ZONE_CHANGED" ) or ( event == "ZONE_CHANGED_NEW_AREA" ) then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		if ( not IsInInstance("player") ) then
			e:UnregisterEvent("ZONE_CHANGED_INDOORS")
		else
			e:RegisterEvent("ZONE_CHANGED_INDOORS")
		end
		
		local mapID = 0
		local mapInfo = {}
		
		C_Timer.After(1, function()
			mapID = C_Map.GetBestMapForUnit("player")
			if ( mapID ) then
				mapInfo = C_Map.GetMapInfo(mapID)
				addon.map = mapInfo.name
				addon.mapID = mapInfo.mapID
			end
		end)
		
		C_Timer.After(5, function()
			if ( addon.mapID ) then
				if ( IsInInstance("player") ) then
					local instanceID = select(8, GetInstanceInfo())
					local encounters = C_EncounterJournal.GetEncountersOnMap(addon.mapID)
					if ( encounters and encounters ~= {} ) then
						for _, encounter in ipairs(encounters) do
							local encounterName = EJ_GetEncounterInfo(encounter.encounterID)
							print(encounterName..": "..instanceID)
						end
					end
				end
			end
		end)
		
		--[[C_Timer.After(10, function()
			-- Boss Encounter Code
			if ( mapInfo ) then
				if ( mapInfo.mapType == 4 ) or ( mapInfo.mapType == 6 ) then
					if ( IsInInstance("player") ) then
						local encounters = C_EncounterJournal.GetEncountersOnMap(mapInfo.mapID)
						if ( #encounters > 0 ) then
							for _, encounter in ipairs(encounters) do
								local encounterName, _, _, _, _, _, _, instanceID = EJ_GetEncounterInfo(encounter.encounterID)
								if ( encounterName and instanceID ) then
									if ( not LastSeenDB.Encounters[encounter.encounterID] ) then
										LastSeenDB.Encounters[encounter.encounterID] = { encounterName = encounterName, instanceID = instanceID }
									end
								end
							end
						end
					end
				end
			end
		end)]]

		e:UnregisterEvent("PLAYER_LOGIN")
	end
end)