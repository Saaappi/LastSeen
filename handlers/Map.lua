local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local e = CreateFrame("Frame")

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
		
		local mapInfo = GetBestMapForUnit("player")
		if mapInfo then
			if not LastSeenMapDB[mapInfo.mapID] and (mapInfo.mapType == 3 or mapInfo.mapType == 4) then
				LastSeenMapDB[mapInfo.mapID] = mapInfo.name
			end
			
			addonTable.map = mapInfo.name
		end
	end
end)