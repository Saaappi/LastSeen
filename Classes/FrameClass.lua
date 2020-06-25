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
		addonTbl.Show(variableName);
	end
end
-- Synopsis: Responsible for building a frame.

addonTbl.Show = function(variableName)
	if isFrameVisible then
		addonTbl.Hide(variableName);
	else
		isFrameVisible = true;
		print("Frame shown");
		addonTbl.variableName:Show();
	end
end
-- Synopsis: Displays the provided frame on screen.

addonTbl.Hide = function(variableName)
	isFrameVisible = false;
	print("Frame hidden");
	addonTbl.variableName:Hide();
end
-- Synopsis: Hides the provided frame from the screen.

addonTbl.PlaySound = function(soundKit)
	PlaySound(soundKit);
end
-- Synopsis: Plays the provided soundkit.