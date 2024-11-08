local addonName, LastSeen = ...
local inputSearchText
local NO_RESULTS = "no results"

local frame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplate")
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

    for _, item in pairs(LastSeenDB.Items) do
        local name = string.lower(item.name)
        if string.find(name, inputSearchText) then
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
    frame.scrollBox:SetDataProvider(dataProvider, true)
    frame.searchResultsText:SetText(format("%d result(s)", count))
end

local searchBox = CreateFrame("EditBox", nil, frame, "SearchBoxTemplate")
searchBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 10, -50)
searchBox:SetAutoFocus(false)
searchBox:SetSize(145, 24)
searchBox:SetScript("OnTextChanged", function(self)
    SearchBoxTemplate_OnTextChanged(self)
    inputSearchText = self:GetText()
    CreateLastSeenDataProvider()
end)

local searchResultsText = frame:CreateFontString(nil, "OVERLAY")
searchResultsText:SetFont("fonts/2002.ttf", 10)
searchResultsText:SetText(NO_RESULTS)
searchResultsText:SetPoint("LEFT", searchBox, "RIGHT", 7, 0)

frame.searchBox = searchBox
frame.searchResultsText = searchResultsText

local scrollBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
scrollBox:SetSize(frame:GetWidth()-5, frame:GetHeight()-100)
scrollBox:SetPoint("CENTER", frame, "CENTER", 5, 0)

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
    itemButton.looterRace:SetText(elementData.looterRace)
    itemButton.looterClass:SetText(elementData.looterClass)
    itemButton.looterLevel:SetText(elementData.looterLevel)
    itemButton.map:SetText(elementData.map)
    itemButton.lootDate:SetText(elementData.lootDate)
    --UpdateQuality(itemButton, elementData.link, elementData.itemQuality)
end)

ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, eventFrame, scrollView)