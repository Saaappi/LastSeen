local _, LastSeen = ...

LastSeen.GetAppropriateMapName = function(mapID)
    if mapID then
        local info = C_Map.GetMapInfo(mapID)
        if info then
            -- I don't want the addon to log item information to micro or orphan
            -- maps like caves, so let's ensure we only log item information under
            -- ZONE and DUNGEON maps.
            if (info.mapType ~= 3 and info.mapType ~= 4) and info.mapType > 4 then
                -- If the mapType is less than 4, then we're dealing with a World or
                -- Continent map and I'm not sure we could ever loot something on a
                -- map of that type, so I won't plan around it. If that's ever a case
                -- in the future, then I'll cross the bridge then.
                C_Timer.After(1, function() LastSeen.GetAppropriateMapName(info.parentMapID) end)
            end
            return info
        end
    end
    return 0
end