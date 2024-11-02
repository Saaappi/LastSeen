local addonName, LastSeen = ...
local eventFrame = CreateFrame("Frame")
local encounterInProgress = false
local lastTime = 0
local debugBreakLoop = false

local ignoredItemClasses = {
    [12] = "Quest"
}

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
            end

            local defaults = {
                Characters = {},
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

    if event == "ENCOUNTER_LOOT_RECEIVED" then
        local journalEncounterID, _, itemLink = ...
        if journalEncounterID and itemLink then
            local name = LastSeenDB.Encounters[journalEncounterID]
            if name then
                local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemLink)
                if (itemName and itemQuality and itemTexture) then
                    print(format("|T%s:0|t %s dropped from %s!", itemTexture, itemLink, name))
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
        debugBreakLoop = false
    end

    if event == "LOOT_READY" then
        if encounterInProgress then return end -- To prevent encounter loot from logging twice
        local currentTime = GetTime()
        if currentTime < (lastTime + 1) then return end -- To prevent multiple LOOT_READY events that fire in the same frame from being processed simultaneously
        if currentTime > (lastTime + 1) then lastTime = currentTime end

        for i=1,GetNumLootItems() do
            if debugBreakLoop then break end -- This is here to prevent spamming the chat window with output regarding objects/lootable items not being supported

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
                                local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, _, classID = C_Item.GetItemInfo(itemLink)
                                if (itemName and itemQuality and itemTexture) and unitID and (not ignoredItemClasses[classID]) then
                                    print(format("|T%s:0|t %s dropped from %s!", itemTexture, itemLink, LastSeenDB.Creatures[unitID] or "UNK"))
                                end
                            elseif unitType == "GameObject" then
                                debugBreakLoop = true
                                print("Items acquired from game objects are currently unsupported. Sorry!")
                                return
                            elseif unitType == "Item" then
                                debugBreakLoop = true
                                print("Items acquired from lootable containers are currently unsupported. Sorry!")
                                return
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

    if event == "PLAYER_LEVEL_CHANGED" then
        local _, newLevel = ...
        if newLevel then
            LastSeenDB.Characters[LastSeen.playerGUID].level = newLevel
        end
    end

    if event == "PLAYER_LOGIN" then
        eventFrame:UnregisterEvent(event)
        C_Timer.After(1, function()
            LastSeen.currentMapID = C_Map.GetBestMapForUnit("player")
            if LastSeen.currentMapID then
                local map = LastSeen.GetAppropriateMapName(LastSeen.currentMapID)
                if map and map ~= 0 then
                    LastSeen.currentMapName = map.name
                    LastSeenDB.Maps[map.mapID] = LastSeen.currentMapName
                end
            end

            -- Get information about the current character and log that information
            LastSeen.playerGUID = UnitGUID("player")
            if LastSeen.playerGUID and (not LastSeenDB.Characters[LastSeen.playerGUID]) then
                LastSeenDB.Characters[LastSeen.playerGUID] = {}
            end

            -- General character information
            local playerName = UnitName("player")
            local playerLevel = UnitLevel("player")
            local playerRace = UnitRace("player")
            local playerClass = UnitClass("player")
            local playerFaction = UnitFactionGroup("player")
            local realmName = GetRealmName()

            -- Professions
            local professionIndices = {GetProfessions()}
            local professions = {}
            for i,professionIndex in ipairs(professionIndices) do
                if professionIndex then
                    local profession = C_SpellBook.GetSpellBookSkillLineInfo(professionIndex)
                    if profession then
                        professions[i] = profession.name or nil
                    end
                end
            end
            local prof1, prof2 = professions[1], professions[2]

            LastSeenDB.Characters[LastSeen.playerGUID] = {
                name = playerName,
                level = playerLevel,
                race = playerRace,
                class = playerClass,
                faction = playerFaction,
                realm = realmName,
                professions = { profession1 = prof1, profession2 = prof2 }
            }
        end)
    end

    if event == "UPDATE_MOUSEOVER_UNIT" then
        local token = "mouseover"
        if UnitExists(token) then
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

    if event == "ZONE_CHANGED" or event == "ZONE_CHANGED_NEW_AREA" then
        C_Timer.After(1, function()
            LastSeen.currentMapID = C_Map.GetBestMapForUnit("player")
            if LastSeen.currentMapID then
                local map = LastSeen.GetAppropriateMapName(LastSeen.currentMapID)
                if map and map ~= 0 then
                    LastSeen.currentMapName = map.name
                    LastSeenDB.Maps[map.mapID] = LastSeen.currentMapName
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
eventFrame:RegisterEvent("PLAYER_LEVEL_CHANGED")
eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", OnEvent)

SlashCmdList["LASTSEEN"] = function(cmd)
	if not cmd or cmd == "" then
        print("HELLO WORLD!")
	end
end
SLASH_LASTSEEN1 = "/lastseen"