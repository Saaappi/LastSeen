local _, LastSeen = ...

LastSeen.Item = function(...)
    local itemID, itemName, itemLink, itemQuality, itemTexture, playerGUID, playerName, playerLevel, sourceType, source, map = ...

    -- The item is new, so let's create a table for it
    if not LastSeenDB.Items[itemID] then
        LastSeenDB.Items[itemID] = {}
    end

    LastSeenDB.Items[itemID] = {
        name = itemName,
        link = itemLink,
        quality = itemQuality,
        texture = itemTexture,
        looterGUID = playerGUID,
        looterName = playerName,
        looterLevel = playerLevel,
        sourceType = sourceType,
        source = source,
        map = map,
        lootDate = date(LastSeen.dateFormat)
    }
end