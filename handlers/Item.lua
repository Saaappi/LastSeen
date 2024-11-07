local _, LastSeen = ...

LastSeen.Item = function(...)
    local itemID, itemName, itemLink, itemQuality, itemTexture, classID, playerGUID, playerName, playerLevel, sourceType, sourceID, source, map = ...

    -- The item is new, so let's create a table for it
    if not LastSeenDB.Items[itemID] then
        print(format("%s: Added %s.", LastSeen.ColoredAddOnName(), LastSeen.ItemIconString(itemTexture, itemLink)))
        LastSeenDB.Items[itemID] = {}
        LastSeenDB.Items[itemID].appearances = {}
    end

    -- If the item is armor or a weapon, let's get the appearance information
    local appearanceSourceID = 0
    if classID == 2 or classID == 4 then
        appearanceSourceID = select(2, C_TransmogCollection.GetItemInfo(itemLink))
        if appearanceSourceID then
            LastSeenDB.Items[itemID].appearances[appearanceSourceID] = date(LastSeen.dateFormat)
        end
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
        sourceID = sourceID,
        source = source,
        map = map,
        lootDate = date(LastSeen.dateFormat)
    }
end