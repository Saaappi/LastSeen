local addonName, addon = ...
addon.GetMapPosition = function(mapID)
	if (not IsInInstance("player")) then
		local position = C_Map.GetPlayerMapPosition(mapID, "player")
		return (position.x*100), (position.y*100)
	end
	return "-", "-"
end