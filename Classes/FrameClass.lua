-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local isFrameVisible;
local L = addonTbl.L;

addonTbl.Frame = function(variableName, frameName)
	-- If the frame is already created, then call the Show function instead.
	if not addonTbl.variableName then
		addonTbl.variableName = CreateFrame("Frame", frameName, UIParent, "BasicFrameTemplateWithInset");
	else
		addonTbl.Show(variableName, 200, 125);
	end
end
-- Synopsis: Responsible for building a frame.

addonTbl.Show = function(variableName, height, width)
	if isFrameVisible then
		addonTbl.Hide(variableName);
	else
		isFrameVisible = true;
		if variableName then
			variableName:SetMovable(true);
			variableName:EnableMouse(true);
			variableName:RegisterForDrag("LeftButton");
			variableName:SetScript("OnDragStart", variableName.StartMoving);
			variableName:SetScript("OnDragStop", variableName.StopMovingOrSizing);
			variableName:SetSize(height, width);
			variableName:ClearAllPoints();
			variableName:SetPoint("CENTER", WorldFrame, "CENTER");
		end
		addonTbl.Widget(title, "FontString", L["RELEASE"] .. L["ADDON_NAME_SETTINGS"], variableName);
		addonTbl.variableName:Show();
	end
end
-- Synopsis: Displays the provided frame on screen.

addonTbl.Hide = function(variableName)
	isFrameVisible = false;
	addonTbl.variableName:Hide();
end
-- Synopsis: Hides the provided frame from the screen.

addonTbl.PlaySound = function(soundKit)
	PlaySound(soundKit);
end
-- Synopsis: Plays the provided soundkit.