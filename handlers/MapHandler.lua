local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local e = CreateFrame("Frame")

function LastSeen:GetCurrentMapInfo()
	if UnitAffectingCombat("player") then
		-- Maps can't be updated in combat.
		while UnitAffectingCombat("player") do
			C_Timer.After(1.5, LastSeen:GetCurrentMapInfo())
		end
	end
	
	return C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player"))
end

e:RegisterEvent("INSTANCE_GROUP_SIZE_CHANGED")
e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if (event == "INSTANCE_GROUP_SIZE_CHANGED" or event == "PLAYER_LOGIN" or event == "ZONE_CHANGED_NEW_AREA") then
		local mapInfo = LastSeen:GetCurrentMapInfo()
		if not LastSeenMapDB[mapInfo.mapID] then
			LastSeenMapDB[mapInfo.mapID] = mapInfo.name
		end
	end
end)