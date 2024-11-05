local addonName, LastSeen = ...

--[[local frame = CreateFrame("Frame", nil, UIParent, "PortraitFrameTemplate")
frame:SetSize(500, 300)
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

frame:SetPortraitToAsset(237297)]]

--[[function LastSearchSearchFrameMixin:OnShow()
    self:SetPortraitToAsset(237297)
end

function LastSearchSearchFrameMixin:OnHide()
    --self:SetPortraitToAsset(237297)
end

function LastSeenSearchFrameMixin:OnLoad()
    --
end]]