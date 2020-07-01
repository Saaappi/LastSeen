-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local L = addonTbl.L;

addonTbl.GetCurrentMap = function()
	local uiMapID = C_Map.GetBestMapForUnit("player");
	local isInInstance;
	
	if uiMapID then -- A map ID was found and is usable.
		local uiMap = C_Map.GetMapInfo(uiMapID);
		if not uiMap.mapID then return end;
		if not LastSeenMapsDB[uiMap.mapID] then
			LastSeenMapsDB[uiMap.mapID] = uiMap.name;
		end

		addonTbl.currentMap = uiMap.name;
	else
		C_Timer.After(3, addonTbl.GetCurrentMap); -- Recursively call the function every 3 seconds until a map ID is found.
	end
	
	return addonTbl.currentMap;
end
-- Synopsis: Gets the player's current map so an item can be accurately recorded.