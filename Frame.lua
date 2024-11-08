local addonName, LastSeen = ...
local inputSearchText

local frame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplate")
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
    for _, item in pairs(LastSeenDB.Items) do
        local name = string.lower(item.name)
        if string.find(name, inputSearchText) then
            count = count + 1
            local searchItem = { link = item.link }
            dataProvider:Insert(searchItem)
        end
    end
    frame.scrollBox:SetDataProvider(dataProvider, true)
    frame.searchResultsText:SetText(format("%d result(s)", count))
end

local searchBox = CreateFrame("EditBox", nil, frame, "SearchBoxTemplate")
searchBox:SetPoint("BOTTOMLEFT", frame, "TOPLEFT", 0, 5)
searchBox:SetAutoFocus(false)
searchBox:SetSize(145, 24)
searchBox:SetScript("OnTextChanged", function(self)
    if self:GetText() ~= nil and self:GetText() ~= "" then
        SearchBoxTemplate_OnTextChanged(self)
        inputSearchText = self:GetText()
        CreateLastSeenDataProvider()
    end
end)

local searchResultsText = frame:CreateFontString(nil, "OVERLAY")
searchResultsText:SetFont("fonts/2002.ttf", 10)
searchResultsText:SetText("no results")
searchResultsText:SetPoint("LEFT", searchBox, "RIGHT", 7, 0)

frame.searchBox = searchBox
frame.searchResultsText = searchResultsText

local scrollBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
scrollBox:SetPoint("TOPLEFT", -5)
scrollBox:SetPoint("BOTTOMRIGHT", -5)
scrollBox:SetScript("OnShow", function()
    --C_Timer.After(0.5, CreateLastSeenDataProvider)
end)
--scrollBox:SetPoint("TOPLEFT", frame, "TOPLEFT")
scrollBox:SetSize(frame:GetWidth(), 200)

local eventFrame = CreateFrame("EventFrame", nil, frame, "WowTrimScrollBar")
eventFrame:SetPoint("TOPLEFT", frame, "TOPRIGHT", 2, 1)
eventFrame:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT", 2, -7)

frame.scrollBox = scrollBox
frame.eventFrame = eventFrame

local scrollView = CreateScrollBoxListLinearView()
scrollView:SetElementInitializer("BetterMerchantItemTemplate", function(itemButton, elementData)
    itemButton:SetID(elementData.index);
    itemButton.hasItem = true;
    itemButton.Label:SetText(elementData.name)
    itemButton.SlotTexture:SetTexture(elementData.texture);
    itemButton.texture = elementData.texture;
    itemButton.link = elementData.link;
    itemButton.extendedCost = elementData.extendedCost or nil;
    itemButton.showNonrefundablePrompt = not C_MerchantFrame.IsMerchantItemRefundable(elementData.index);
    SetItemButtonCount(itemButton, elementData.stackCount);

    --UpdateQuality(itemButton, elementData.link, elementData.itemQuality);
    --UpdateButton(itemButton, elementData);
end)

ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, eventFrame, scrollView)