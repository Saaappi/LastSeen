local addonName, LastSeen = ...
local eventFrame = CreateFrame("Frame")
local encounterInProgress = false
local lastTime = 0

local function GetUnitTypeFromGUID(guid)
    local unitType = string.split("-", guid)
    return unitType
end

local function GetIDFromGUID(guid)
    local npcID = select(6, string.split("-", guid)); npcID = tonumber(npcID)
    return npcID or 0
end

local function OnEvent(_, event, ...)
    if event == "ADDON_LOADED" then
        local addonLoaded = ...
        if addonLoaded == addonName then
            eventFrame:UnregisterEvent(event)
            if LastSeenDB == nil then
                LastSeenDB = {}

                local defaults = {
                    Creatures = {},
                    Encounters = {},
                    Items = {},
                    Maps = {}
                }
                for key, value in next, defaults do
                    if LastSeenDB[key] == nil then
                        LastSeenDB[key] = value
                    end
                end
            end
        end
    end

    if event == "ENCOUNTER_LOOT_RECEIVED" then
        local journalEncounterID, itemID = ...
        if journalEncounterID and itemID then
            local name = LastSeenDB.Encounters[journalEncounterID]
            if name then
                local itemName, itemLink, itemQuality, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemID)
                if (itemName and itemLink and itemQuality and itemTexture) then
                    print(format("|T%s:0|t %s dropped from %s! {E}", itemTexture, itemLink, name))
                end
            end
        end
    end

    if event == "ENCOUNTER_START" then
        encounterInProgress = true
        local journalEncounterID, name = ...
        if journalEncounterID and name then
            if not LastSeenDB.Encounters[journalEncounterID] then
                LastSeenDB.Encounters[journalEncounterID] = name
            end
        end
    end

    if event == "LOOT_CLOSED" then
        encounterInProgress = false
    end

    if event == "LOOT_READY" then
        if encounterInProgress then return end -- To prevent encounter loot from logging twice
        local currentTime = GetTime()
        if currentTime < (lastTime + 1) then return end -- To prevent multiple LOOT_READY events that fire in the same frame from being processed simultaneously
        if currentTime > (lastTime + 1) then lastTime = currentTime end

        for i=1,GetNumLootItems() do
            local itemLink = GetLootSlotLink(i)
            -- There are some currencies that return a valid link (like Spirit Shards),
            -- so I'll plan around that by making a call to GetCurrencyInfoFromLink. If
            -- nothing is found, then we'll assume we can continue.
            if itemLink and (not C_CurrencyInfo.GetCurrencyInfoFromLink(itemLink)) then
                local sources = { GetLootSourceInfo(i) }
                if sources then
                    -- I skip every other entry in the table because
                    -- it's laid out like {guid1, quantity1, guid2, quantity2, ...}.
                    -- In other words, I only want to know what dropped the item and
                    -- I don't care about the quantity in which it was dropped.
                    for j=1,#sources,2 do
                        local item = Item:CreateFromItemLink(itemLink)
                        item:ContinueOnItemLoad(function()
                            local unitType = GetUnitTypeFromGUID(sources[j])
                            if unitType == "Creature" or unitType == "Vehicle" then
                                local unitID = GetIDFromGUID(sources[j])
                                local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemLink)
                                if (itemName and itemQuality and itemTexture) and unitID then
                                    print(format("|T%s:0|t %s dropped from %s!", itemTexture, itemLink, LastSeenDB.Creatures[unitID] or "UNK"))
                                end
                            elseif unitType == "GameObject" then
                                local unitID = GetIDFromGUID(sources[j])
                                local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemLink)
                                if (itemName and itemQuality and itemTexture) and unitID then
                                    print(format("|T%s:0|t %s dropped from an object; objects are currently unsupported. Sorry!", itemTexture, itemLink))
                                end
                            end
                        end)
                    end
                end
            end
        end
    end

    if event == "NAME_PLATE_UNIT_ADDED" then
        local token = ...
        if token then
            local guid = UnitGUID(token)
            local name = UnitName(token)
            if (guid and name) and (not UnitIsFriend("player", token)) then
                local npcID = GetIDFromGUID(guid)
                if npcID ~= 0 and (not LastSeenDB.Creatures[npcID]) then
                    LastSeenDB.Creatures[npcID] = name
                end
            end
        end
    end

    if event == "PLAYER_LOGIN" then
        eventFrame:UnregisterEvent(event)
        C_Timer.After(1, function()
            LastSeen.currentMapID = C_Map.GetBestMapForUnit("player")
            if LastSeen.currentMapID then
                local map = LastSeen.GetAppropriateMapName(LastSeen.currentMapID)
                if map and map ~= 0 then
                    LastSeenDB.Maps[map.mapID] = map.name
                end
            end
        end)
    end

    if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
        C_Timer.After(1, function()
            LastSeen.currentMapID = C_Map.GetBestMapForUnit("player")
            if LastSeen.currentMapID then
                local map = LastSeen.GetAppropriateMapName(LastSeen.currentMapID)
                if map and map ~= 0 then
                    LastSeenDB.Maps[map.mapID] = map.name
                end
            end
        end)
    end
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("ENCOUNTER_START")
eventFrame:RegisterEvent("ENCOUNTER_LOOT_RECEIVED")
eventFrame:RegisterEvent("LOOT_CLOSED")
eventFrame:RegisterEvent("LOOT_READY")
eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", OnEvent)

SlashCmdList["LASTSEEN"] = function(cmd)
	if not cmd or cmd == "" then
        print("HELLO WORLD!")
	end
end
SLASH_LASTSEEN1 = "/lastseen"