-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local L = tbl.L;

tbl.GetCurrentMap = function()
	local uiMapID = C_Map.GetBestMapForUnit("player");
	local isInInstance;
	
	if uiMapID then -- A map ID was found and is usable.
		local uiMap = C_Map.GetMapInfo(uiMapID);
		if not uiMap.mapID then return end;
		if not LastSeenMapsDB[uiMap.mapID] then
			LastSeenMapsDB[uiMap.mapID] = uiMap.name;
		end

		tbl.currentMap = uiMap.name;
	else
		C_Timer.After(3, tbl.GetCurrentMap); -- Recursively call the function every 3 seconds until a map ID is found.
	end
	
	return tbl.currentMap;
end
-- Synopsis: Gets the player's current map so an item can be accurately recorded.