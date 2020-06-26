-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local isFrameVisible;
local L = addonTbl.L;

addonTbl.Frame = function(objName, frameName)
	-- If the frame is already created, then call the Show function instead.
	if not addonTbl.objName then
		addonTbl.objName = CreateFrame("Frame", frameName, UIParent, "BasicFrameTemplateWithInset");
		addonTbl.Show(addonTbl.objName, 200, 125);
	else
		addonTbl.Show(addonTbl.objName, 200, 125);
	end
end
-- Synopsis: Responsible for building a frame.

addonTbl.Show = function(objName, height, width)
	if isFrameVisible then
		addonTbl.Hide(objName);
	else
		isFrameVisible = true;
		if objName then
			objName:SetMovable(true);
			objName:EnableMouse(true);
			objName:RegisterForDrag("LeftButton");
			objName:SetScript("OnDragStart", objName.StartMoving);
			objName:SetScript("OnDragStop", objName.StopMovingOrSizing);
			objName:SetSize(height, width);
			objName:ClearAllPoints();
			objName:SetPoint("CENTER", WorldFrame, "CENTER");
		end
		addonTbl.Widget("title", "FontString", L["RELEASE"] .. L["ADDON_NAME_SETTINGS"], objName, "CENTER", objName.TitleBg, "CENTER", 5, 0);
		addonTbl.objName:Show();
	end
end
-- Synopsis: Displays the provided frame on screen.

addonTbl.Hide = function(objName)
	isFrameVisible = false;
	addonTbl.objName:Hide();
end
-- Synopsis: Hides the provided frame from the screen.

addonTbl.PlaySound = function(soundKit)
	PlaySound(soundKit);
end
-- Synopsis: Plays the provided soundkit.