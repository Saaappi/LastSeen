local addonName, addon = ...
addon.GetMapPosition = function(mapID)
	local position = C_Map.GetPlayerMapPosition(mapID, "player")
	return (position.x*100), (position.y*100)
end