local addonName, LastSeen = ...
local inputSearchText

local pairs = pairs
local format = format
local CreateDataProvider = CreateDataProvider
local stringLower = string.lower
local stringUpper = string.upper
local stringFind = string.find

-- Constants for UI dimensions
local SEARCH_BOX_WIDTH = 200
local SEARCH_BOX_HEIGHT = 24
local MAX_RESULTS = 500
local NO_RESULTS = "no results"
local frame

local function GetClassColorRGB(className)
    if className then
        className = stringUpper(className)
        if RAID_CLASS_COLORS and RAID_CLASS_COLORS[className] then
            local color = RAID_CLASS_COLORS[className]
            return color.r, color.g, color.b
        end
    end
    return NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b
end

local function UpdateQuality(button, link, quality)
    local r, g, b
    if quality then
        r = ITEM_QUALITY_COLORS[quality].r
        g = ITEM_QUALITY_COLORS[quality].g
        b = ITEM_QUALITY_COLORS[quality].b
    else
        r = NORMAL_FONT_COLOR.r
        g = NORMAL_FONT_COLOR.g
        b = NORMAL_FONT_COLOR.b
    end

    SetItemButtonQuality(button, quality, link, false)
    button.name:SetVertexColor(r, g, b)
end

---@param text string|nil
---@return string
local function NormalizeQuery(text)
    if not text or text == "" then
        return ""
    end
    return stringLower(text)
end

---@param item table
---@return string
local function GetItemSearchText(item)
    if type(item) ~= "table" then
        return ""
    end

    if not item.searchText and LastSeen and LastSeen.UpdateItemSearchText then
        LastSeen.UpdateItemSearchText(item)
    end

    return item.searchText or ""
end

---@param item table
---@param query string
---@return boolean
local function MatchesQuery(item, query)
    if query == "" then
        return true
    end

    local haystack = GetItemSearchText(item)
    if haystack == "" then
        return false
    end

    -- This is a plain find: it's faster and avoids Lua patterns
    return stringFind(haystack, query, 1, true) ~= nil
end

---@param item table
---@return string
local function GetNameSort(item)
    if type(item) ~= "table" then
        return ""
    end
    if not item.nameSort then
        item.nameSort = stringLower(item.name or "")
    end
    return item.nameSort
end

local function CreateLastSeenDataProvider()
    if not LastSeenDB or not LastSeenDB.Items then
        return
    end

    local query = NormalizeQuery(inputSearchText)
    if query == "" then
        frame.scrollBox:SetDataProvider(CreateDataProvider())
        frame.searchResultsText:SetText("Enter 2+ characters to search.")
        return
    end

    local count = 0
    local results = {}
    for itemID, item in pairs(LastSeenDB.Items) do
        if MatchesQuery(item, query) then
            count = count + 1
            if #results < MAX_RESULTS then
                results[#results + 1] = itemID
            end
        end
    end

    -- Sort only the shown results.
    if #results > 1 then
        table.sort(results, function(a, b)
            local itemA = LastSeenDB.Items[a]
            local itemB = LastSeenDB.Items[b]

            if not itemA and not itemB then
                return false
            end
            if not itemA then
                return false
            end
            if not itemB then
                return false
            end

            return GetNameSort(itemA) < GetNameSort(itemB)
        end)
    end

    local dataProvider = CreateDataProvider()
    dataProvider:InsertTable(results)

    frame.scrollBox:SetDataProvider(dataProvider, true)

    if count == 0 then
        frame.searchResultsText:SetText(NO_RESULTS)
    elseif count > MAX_RESULTS then
        frame.searchResultsText:SetText(format("%d result(s) (showing %d; please refine your search)", count, MAX_RESULTS))
    else
        frame.searchResultsText:SetText(format("%d result(s)", count))
    end
end

LastSeen.Search = function(text)
    if not frame then
        frame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplate")
        frame.TitleText:SetText(format("%s Search", addonName))
        frame:SetSize(900, 500)
        frame:SetPoint("CENTER", UIParent, "CENTER")

        -- Make the frame movable.
        frame:SetMovable(true)
        frame:SetScript("OnMouseDown", function(self)
            self:StartMoving()
        end)
        frame:SetScript("OnMouseUp", function(self)
            self:StopMovingOrSizing()
        end)

        -- Make sure the frame can't be moved off screen.
        frame:SetClampedToScreen(true)

        local pendingSearchTimer
        local function ScheduleSearch()
            if pendingSearchTimer then
                pendingSearchTimer:Cancel()
            end
            pendingSearchTimer = C_Timer.NewTimer(0.15, function()
                CreateLastSeenDataProvider()
            end)
        end

        local searchBox = CreateFrame("EditBox", nil, frame, "SearchBoxTemplate")
        searchBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 10, -50)
        searchBox:SetAutoFocus(false)
        searchBox:SetSize(SEARCH_BOX_WIDTH, SEARCH_BOX_HEIGHT)
        searchBox:SetScript("OnTextChanged", function(self)
            SearchBoxTemplate_OnTextChanged(self)
            inputSearchText = self:GetText() or ""
            ScheduleSearch()
        end)
        if text then
            searchBox:SetText(text)
        end

        local searchResultsText = frame:CreateFontString(nil, "OVERLAY")
        searchResultsText:SetFont("fonts/2002.ttf", 10)
        searchResultsText:SetText(NO_RESULTS)
        searchResultsText:SetPoint("LEFT", searchBox, "RIGHT", 7, 0)

        frame.searchBox = searchBox
        frame.searchResultsText = searchResultsText

        -- Add headers above the data columns
        local headers = {
            { text = "Name", x = 0 },
            { text = "Map", x = 320 },
            { text = "Looter Race", x = 550 },
            { text = "Looter Class", x = 670 },
            { text = "Lvl", x = 760 },
            { text = "Loot Date", x = 790 }
        }
        for i, header in ipairs(headers) do
            local headerText = frame:CreateFontString(nil, "OVERLAY")
            headerText:SetFont("fonts/2002.ttf", 10)
            headerText:SetText(header.text)
            headerText:SetPoint("TOPLEFT", frame, "TOPLEFT", header.x + 10, -60)
            headerText:SetJustifyH("LEFT")
        end

        local scrollBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
        scrollBox:SetSize(frame:GetWidth()-35, frame:GetHeight()-85)
        scrollBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -75)

        local eventFrame = CreateFrame("EventFrame", nil, frame, "MinimalScrollBar")
        eventFrame:SetPoint("TOPLEFT", scrollBox, "TOPRIGHT", 4, 0)
        eventFrame:SetPoint("BOTTOMLEFT", scrollBox, "BOTTOMRIGHT", 4, 0)

        frame.scrollBox = scrollBox
        frame.eventFrame = eventFrame

        local scrollView = CreateScrollBoxListLinearView()
        scrollView:SetElementInitializer("LastSeenItemTemplate", function(itemButton, elementData)
            local item = LastSeenDB and LastSeenDB.Items and LastSeenDB.Items[elementData] or nil
            if not item then
                return
            end

            local character = (LastSeenDB.Characters and item.looterGUID) and LastSeenDB.Characters[item.looterGUID] or nil

            itemButton.name:SetText(item.name or "")
            itemButton.itemTexture:SetTexture(item.texture)
            itemButton.link = item.link
            itemButton.source:SetText(item.source or "")
            itemButton.map:SetText(item.map or "")

            local race = character and character.race or "--"
            local class = character and character.class or "--"

            itemButton.looterRace:SetText(race)
            itemButton.looterClass:SetText(class)
            itemButton.looterLevel:SetText(item.looterLevel or "--")
            itemButton.lootDate:SetText(item.lootDate or "")

            local r, g, b = GetClassColorRGB(character and character.class or nil)
            itemButton.looterClass:SetVertexColor(r, g, b)

            UpdateQuality(itemButton, item.link, item.quality)
        end)

        ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, eventFrame, scrollView)
    else
        if frame:IsVisible() then
            frame:Hide()
        else
            frame:Show()
            if text then
                frame.searchBox:SetText(text)
            end
        end
    end
end