local addonName, LastSeen = ...
local inputSearchText
local NO_RESULTS = "no results"
local frame

local function UpdateClassColor(className)
    if className then
        className = string.upper(className)
        local classColor = C_ClassColor.GetClassColor(className)
        if classColor then
            return classColor
        end
    end
    return NORMAL_FONT_COLOR
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

local function CreateLastSeenDataProvider()
    local dataProvider = CreateDataProvider()
    local count = 0

    -- If the search query is empty, then the scroll box
    -- should be emptied too.
    if inputSearchText == nil or inputSearchText == "" then
        local blankDataProvider = CreateDataProvider()
        frame.scrollBox:SetDataProvider(blankDataProvider)
        frame.searchResultsText:SetText(NO_RESULTS)
        return
    end

    local fields = {"name", "looterName", "looterLevel", "source", "map", "lootDate"}
    for _, item in pairs(LastSeenDB.Items) do
        for _, field in ipairs(fields) do
            local fieldLowerCase = string.lower(tostring(item[field]))
            if string.find(fieldLowerCase, inputSearchText) then
                count = count + 1
                local character = LastSeenDB.Characters[item.looterGUID]
                local searchItem = {
                    name = item.name,
                    link = item.link,
                    looterName = item.looterName,
                    looterLevel = item.looterLevel,
                    looterRace = character.race,
                    looterClass = character.class,
                    texture = item.texture,
                    quality = item.quality,
                    source = item.source,
                    map = item.map,
                    lootDate = item.lootDate
                }
                dataProvider:Insert(searchItem)
            end
        end
    end

    dataProvider:SetSortComparator(function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    dataProvider:Sort()

    frame.scrollBox:SetDataProvider(dataProvider, true)
    frame.searchResultsText:SetText(format("%d result(s)", count))
end

LastSeen.Search = function(text)
    if not frame then
        frame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplate")
        frame.TitleText:SetText(format("%s Search", addonName))
        frame:SetSize(650, 400)
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

        local searchBox = CreateFrame("EditBox", nil, frame, "SearchBoxTemplate")
        searchBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 10, -50)
        searchBox:SetAutoFocus(false)
        searchBox:SetSize(145, 24)
        searchBox:SetScript("OnTextChanged", function(self)
            SearchBoxTemplate_OnTextChanged(self)
            inputSearchText = self:GetText()
            CreateLastSeenDataProvider()
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

        local scrollBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
        scrollBox:SetSize(frame:GetWidth()-5, frame:GetHeight()-65)
        scrollBox:SetPoint("CENTER", frame, "CENTER", 5, -20)

        local eventFrame = CreateFrame("EventFrame", nil, frame, "WowTrimScrollBar")
        eventFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 2, 0)
        eventFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 2, 0)

        frame.scrollBox = scrollBox
        frame.eventFrame = eventFrame

        local scrollView = CreateScrollBoxListLinearView()
        scrollView:SetElementInitializer("LastSeenItemTemplate", function(itemButton, elementData)
            itemButton.name:SetText(elementData.name)
            itemButton.itemTexture:SetTexture(elementData.texture)
            itemButton.link = elementData.link
            itemButton.source:SetText(elementData.source)
            itemButton.map:SetText(elementData.map)
            itemButton.looterRace:SetText(elementData.looterRace)
            itemButton.looterClass:SetText(elementData.looterClass)
            itemButton.looterLevel:SetText(elementData.looterLevel)
            itemButton.lootDate:SetText(elementData.lootDate)

            -- Change font color for the class
            local classColor = UpdateClassColor(elementData.looterClass)
            itemButton.looterClass:SetVertexColor(classColor.r, classColor.g, classColor.b)

            UpdateQuality(itemButton, elementData.link, elementData.quality)
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