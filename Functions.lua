local addonName, addon = ...
addon.GetMapPosition = function(mapID)
	if (not IsInInstance("player")) then
		local position = C_Map.GetPlayerMapPosition(mapID, "player")
		if (position) then
			return (position.x*100), (position.y*100)
		else
			C_Timer.After(0.1, function()
				addon.GetMapPosition(mapID)
			end)
		end
	end
	return "-", "-"
end