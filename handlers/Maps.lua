local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

hooksecurefunc(WorldMapFrame, "OnMapChanged", function()
	if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
	
	local mapInfo = C_Map.GetMapInfo(WorldMapFrame:GetMapID())
	if mapInfo then
		if not LastSeenMapDB[mapInfo.mapID] and (mapInfo.mapType == 3 or mapInfo.mapType == 4) then
			LastSeenMapDB[mapInfo.mapID] = mapInfo.name
		end
		
		if mapInfo.mapType == 3 or mapInfo.mapType == 4 then
			addonTable.map = mapInfo.name
		end
	end
end)