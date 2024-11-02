local addonName, LastSeen = ...
local eventFrame = CreateFrame("Frame")

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

    if event == "LOOT_READY" then
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
                            local npcID = GetIDFromGUID(sources[j])
                            local itemName, _, itemQuality, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemLink)
                            if (itemName and itemQuality and itemTexture) and npcID then
                                print(format("|T%s:0|t %s dropped from %s!", itemTexture, itemLink, LastSeenDB.Creatures[npcID] or "UNK"))
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