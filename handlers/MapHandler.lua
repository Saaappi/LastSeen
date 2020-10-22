local addon, tbl = ...;
tbl.GetCurrentMapInfo = function()
	local id = C_Map.GetBestMapForUnit("player");
	if id then
		if LastSeenMapsDB[id] then
			tbl.currentMap = LastSeenMapsDB[id]; -- Return the name of the map stored in the table for the given ID.
		else
			local mapInfo = C_Map.GetMapInfo(id);
			if not mapInfo.mapID then return end
			LastSeenMapsDB[id] = mapInfo.name; -- Add the new map to the map table for future use.
			tbl.currentMap = mapInfo.name;
		end
	else
		C_Timer.After(3, tbl.GetCurrentMapInfo); -- Recursively call the function every 3 seconds until a map ID is found.
	end
end
-- Synopsis: Gets the player's current map so an item can be accurately recorded.