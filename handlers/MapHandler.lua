-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local L = tbl.L;

tbl.GetCurrentMapInfo = function(ret)
	local id = C_Map.GetBestMapForUnit("player");
	
	if id then -- A map ID was found and is usable.
		local mapInfo = C_Map.GetMapInfo(id);
		if not mapInfo.mapID then return end;
		if not LastSeenMapsDB[mapInfo.mapID] then
			LastSeenMapsDB[mapInfo.mapID] = mapInfo.name;
		end

		tbl.currentMap = mapInfo.name;
	else
		C_Timer.After(3, tbl.GetCurrentMapInfo); -- Recursively call the function every 3 seconds until a map ID is found.
	end
	
	if ret == "name" then
		return tbl.currentMap;
	else
		return mapInfo.mapID;
	end
end
-- Synopsis: Gets the player's current map so an item can be accurately recorded.