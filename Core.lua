local addonName, LastSeen = ...
local eventFrame = CreateFrame("Frame")
local encounterInProgress = false
local lastTime = 0

local ignoredItemClasses = {
    [12] = "Quest"
}

local function GetUnitTypeFromGUID(guid)
    local unitType = string.split("-", guid)
    return unitType
end

local function GetIDFromGUID(guid)
    local id = select(6, string.split("-", guid)); id = tonumber(id)
    return id or 0
end

local function OnEvent(_, event, ...)
    if event == "ADDON_LOADED" then
        local addonLoaded = ...
        if addonLoaded == addonName then
            eventFrame:UnregisterEvent(event)
            if LastSeenDB == nil then
                LastSeenDB = {}
            end

            local oldVariables = {
                "DateFormat",
                "Enabled",
                "IgnoredItems",
                "rarityID",
                "Quests",
                "Filters",
                "ScanOnLootOpenedEnabled",
                "ScanQuestRewardsEnabled",
                "IgnoredItems",
                "modeID",
                "rarityID",
                "Quests"
            }
            for _, key in ipairs(oldVariables) do
                if LastSeenDB[key] or not LastSeenDB[key] then
                    LastSeenDB[key] = nil
                end
            end

            local defaults = {
                Characters = {},
                Creatures = {},
                Encounters = {},
                Items = {},
                Maps = {},
                Objects = {}
            }
            for key, value in next, defaults do
                if LastSeenDB[key] == nil then
                    LastSeenDB[key] = value
                end
            end

            -- Code to reconstruct an old Items table to the new format
            local playerGUID = UnitGUID("player")
            for journalEncounterID, encounter in pairs(LastSeenDB.Encounters) do
                LastSeenDB.Encounters[journalEncounterID] = encounter.encounterName
            end
            for itemID, item in pairs(LastSeenDB.Items) do
                if item.itemLink and item.itemLink ~= "" then
                    LastSeenDB.Items[itemID].link = item.itemLink
                    LastSeenDB.Items[itemID].itemLink = nil
                end
                if item.lootedBy then
                    LastSeenDB.Items[itemID].looterGUID = playerGUID
                    LastSeenDB.Items[itemID].lootedBy = nil
                end
                if item.location then
                    LastSeenDB.Items[itemID].location = nil
                end
                if item.sourceInfo then
                    if not LastSeenDB.Items[itemID].appearances then
                        LastSeenDB.Items[itemID].appearances = {}
                    end
                    for appearanceSourceID, lootDate in pairs(item.sourceInfo) do
                        if appearanceSourceID ~= "sourceID" then
                            LastSeenDB.Items[itemID].appearances[appearanceSourceID] = lootDate
                        end
                    end
                    LastSeenDB.Items[itemID].sourceInfo = nil
                end
                if item.itemIcon then
                    LastSeenDB.Items[itemID].texture = item.itemIcon
                    LastSeenDB.Items[itemID].itemIcon = nil
                end
                if item.itemRarity then
                    LastSeenDB.Items[itemID].quality = item.itemRarity
                    LastSeenDB.Items[itemID].itemRarity = nil
                end
                if item.itemType then
                    LastSeenDB.Items[itemID].itemType = nil
                end
                if item.itemName then
                    LastSeenDB.Items[itemID].name = item.itemName
                    LastSeenDB.Items[itemID].itemName = nil
                end
                if not item.sourceID then
                    for npcID, name in pairs(LastSeenDB.Creatures) do
                        if name == item.source then
                            LastSeenDB.Items[itemID].sourceID = npcID
                            LastSeenDB.Items[itemID].sourceType = "Creature"
                        end
                    end
                    for objectID, name in pairs(LastSeenDB.Objects) do
                        if name == item.source then
                            LastSeenDB.Items[itemID].sourceID = objectID
                            LastSeenDB.Items[itemID].sourceType = "GameObject"
                        end
                    end
                    for encounterID, name in pairs(LastSeenDB.Encounters) do
                        if name == item.source then
                            LastSeenDB.Items[itemID].sourceID = encounterID
                            LastSeenDB.Items[itemID].sourceType = "Encounter"
                        end
                    end
                end

                for key, val in pairs(item) do
                    if key == "appearances" then
                        for id, v in pairs(val) do
                            if id == "sourceID" then
                                LastSeenDB.Items[itemID].appearances[id] = nil
                            end
                        end
                    end
                end
            end
        end
    end

    if event == "ENCOUNTER_LOOT_RECEIVED" then
        local playerName, playerRealm = UnitFullName("player")
        local journalEncounterID, _, itemLink, _, unitName = ...
        if journalEncounterID and itemLink and unitName then
            if format("%s-%s", unitName, playerRealm) ~= format("%s-%s", playerName, playerRealm) then return end

            local name = LastSeenDB.Encounters[journalEncounterID]
            if name then
                local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, _, classID = C_Item.GetItemInfo(itemLink)
                local itemID = C_Item.GetItemInfoInstant(itemLink)
                if (itemName and itemQuality and itemTexture and itemID) then
                    LastSeen.Item(
                        itemID,
                        itemName,
                        itemLink,
                        itemQuality,
                        itemTexture,
                        classID,
                        LastSeen.playerGUID,
                        LastSeenDB.Characters[LastSeen.playerGUID].name,
                        LastSeenDB.Characters[LastSeen.playerGUID].level,
                        "Encounter",
                        journalEncounterID,
                        name,
                        LastSeen.currentMapName
                    )
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
                                local npcID = GetIDFromGUID(sources[j])
                                local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, _, classID = C_Item.GetItemInfo(itemLink)
                                local itemID = C_Item.GetItemInfoInstant(itemLink)
                                if (itemName and itemQuality and itemTexture and itemID) and npcID and (not ignoredItemClasses[classID]) then
                                    LastSeen.Item(
                                        itemID,
                                        itemName,
                                        itemLink,
                                        itemQuality,
                                        itemTexture,
                                        classID,
                                        LastSeen.playerGUID,
                                        LastSeenDB.Characters[LastSeen.playerGUID].name,
                                        LastSeenDB.Characters[LastSeen.playerGUID].level,
                                        "Creature",
                                        npcID,
                                        LastSeenDB.Creatures[npcID],
                                        LastSeen.currentMapName
                                    )
                                end
                            elseif unitType == "GameObject" then
                                local objectID = GetIDFromGUID(sources[j])
                                local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, _, classID = C_Item.GetItemInfo(itemLink)
                                local itemID = C_Item.GetItemInfoInstant(itemLink)
                                if (itemName and itemQuality and itemTexture and itemID) and objectID and (not ignoredItemClasses[classID]) then
                                    LastSeen.Item(
                                        itemID,
                                        itemName,
                                        itemLink,
                                        itemQuality,
                                        itemTexture,
                                        classID,
                                        LastSeen.playerGUID,
                                        LastSeenDB.Characters[LastSeen.playerGUID].name,
                                        LastSeenDB.Characters[LastSeen.playerGUID].level,
                                        "GameObject",
                                        objectID,
                                        LastSeenDB.Objects[objectID],
                                        LastSeen.currentMapName
                                    )
                                end
                            elseif unitType == "Item" then
                                local itemGUID = sources[j]
                                local lootableItemItemLink = C_Item.GetItemLinkByGUID(itemGUID)
                                if lootableItemItemLink then
                                    local lootableItem = Item:CreateFromItemLink(lootableItemItemLink)
                                    lootableItem:ContinueOnItemLoad(function()
                                        local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture, _, classID = C_Item.GetItemInfo(itemLink)
                                        local itemID = C_Item.GetItemInfoInstant(itemLink)
                                        if (itemName and itemQuality and itemTexture and itemID) and (not ignoredItemClasses[classID]) then
                                            LastSeen.Item(
                                                itemID,
                                                itemName,
                                                itemLink,
                                                itemQuality,
                                                itemTexture,
                                                classID,
                                                LastSeen.playerGUID,
                                                LastSeenDB.Characters[LastSeen.playerGUID].name,
                                                LastSeenDB.Characters[LastSeen.playerGUID].level,
                                                "Item",
                                                lootableItem:GetItemID(),
                                                lootableItem:GetItemName(),
                                                LastSeen.currentMapName
                                            )
                                        end
                                    end)
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
            if name == "Unknown" then return end
            if (guid and name) and (not UnitIsFriend("player", token)) and (not UnitIsGameObject(token)) then
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

            -- Set the format to use for date entries
            local locale = GetLocale()
            if locale == "enUS" then
                LastSeen.dateFormat = "%m/%d/%Y"
            else
                LastSeen.dateFormat = "%d/%m/%Y"
            end

            -- If an item's source is unknown, then use the sourceType and sourceID as a lookup
            -- tool to correct the data entry.
            for _, item in pairs(LastSeenDB.Items) do
                if item.source == "Unknown" then
                    if item.sourceType == "Creature" then
                        for npcID, name in pairs(LastSeenDB.Creatures) do
                            if npcID == item.sourceID then
                                item.source = name
                                break
                            end
                        end
                    elseif item.sourceType == "Encounter" then
                        for journalEncounterID, name in pairs(LastSeenDB.Encounters) do
                            if journalEncounterID == item.sourceID then
                                item.source = name
                                break
                            end
                        end
                    end
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

    if event == "PLAYER_SOFT_INTERACT_CHANGED" then
        local _, newTarget = ...
        if newTarget then
            local unit = "softinteract"
            if UnitIsGameObject(unit) then
                local name = UnitName(unit)
                local objectID = GetIDFromGUID(newTarget)
                if name and objectID then
                    if not LastSeenDB.Objects[objectID] then
                        LastSeenDB.Objects[objectID] = name
                    end
                end
            end
        end
    end

    if event == "UPDATE_MOUSEOVER_UNIT" then
        local token = "mouseover"
        if UnitExists(token) then
            local guid = UnitGUID(token)
            local name = UnitName(token)
            if (guid and name) and (not UnitIsFriend("player", token)) then
                local npcID = GetIDFromGUID(guid)
                if (npcID ~= 0 and (not LastSeenDB.Creatures[npcID])) or (npcID ~= 0 and LastSeenDB.Creatures[npcID] == "Unknown") then
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
eventFrame:RegisterEvent("PLAYER_SOFT_INTERACT_CHANGED")
eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
eventFrame:RegisterEvent("ZONE_CHANGED")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
eventFrame:SetScript("OnEvent", OnEvent)

function LastSeen_AddonCompartment(self, button)
    -- Open the search window
    LastSeen.Search()
end