local addonName, LastSeen = ...

local frame = CreateFrame("Frame", nil, UIParent, "PortraitFrameTemplate")
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

frame:SetPortraitToAsset(134442)

--[[function LastSearchSearchFrameMixin:OnShow()
    self:SetPortraitToAsset(237297)
end

function LastSearchSearchFrameMixin:OnHide()
    --self:SetPortraitToAsset(237297)
end

function LastSeenSearchFrameMixin:OnLoad()
    --
end]]

--[[local SearchBox = CreateFrame("EditBox", nil, UIParent, "SearchBoxTemplate")
SearchBox:SetPoint("BOTTOMRIGHT", ScrollBox, "TOPRIGHT", 0, 5)
SearchBox:SetAutoFocus(false)
SearchBox:SetSize(145, 24)]]

local ScrollBox = CreateFrame("Frame", nil, frame, "WowScrollBoxList")
ScrollBox:SetPoint("TOPLEFT", frame, "TOPLEFT")
ScrollBox:SetSize(frame:GetWidth()-20, 250)

local ScrollBar = CreateFrame("EventFrame", nil, UIParent, "MinimalScrollBar")
ScrollBar:SetPoint("TOPLEFT", ScrollBox, "TOPRIGHT")
ScrollBar:SetPoint("BOTTOMLEFT", ScrollBox, "BOTTOMRIGHT")

local DataProvider = CreateDataProvider()
local ScrollView = CreateScrollBoxListLinearView()
ScrollView:SetDataProvider(DataProvider)

ScrollUtil.InitScrollBoxListWithScrollBar(ScrollBox, ScrollBar, ScrollView)