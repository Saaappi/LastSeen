-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local frame;
local isFrameVisible;
local L = addonTbl.L;

local function PlaySound(soundKit)
	PlaySound(soundKit);
end
-- Synopsis: Plays the provided soundkit.
--[[
	soundKit:		Name of the soundkit to play (https://github.com/Gethe/wow-ui-source/blob/live/SharedXML/SoundKitConstants.lua)
]]

local function Hide(frame)
	isFrameVisible = false;
	frame:Hide();
end
-- Synopsis: Hides the provided frame from the screen.
--[[
	frame:			Name of the frame to hide
]]

local function Show(frame)
	if isFrameVisible then
		Hide(frame);
	else
		isFrameVisible = true;
		
		-- WIDGETS
		addonTbl.CreateWidget("title", "FontString", L["RELEASE"] .. L["ADDON_NAME_SETTINGS"], frame, "CENTER", frame.TitleBg, "CENTER", 5, 0, 0, 0);
		addonTbl.CreateWidget("itemCounter", "FontString", addonTbl.GetCount(LastSeenItemsDB), frame, "CENTER", frame, "CENTER", 0, -10, 0, 0);
		addonTbl.CreateWidget("showSourcesCheckButton", "Button", L["SHOW_SOURCES"], frame, "CENTER", frame, "CENTER", -60, -35, 0, 0);
		addonTbl.CreateWidget("modeDropDownMenu", "DropDownMenu", "", frame, "CENTER", frame, "CENTER", 0, 15, 175, 30);
		
		if frame then
			frame:SetMovable(true);
			frame:EnableMouse(true);
			frame:RegisterForDrag("LeftButton");
			frame:SetScript("OnDragStart", frame.StartMoving);
			frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
			frame:ClearAllPoints();
			frame:SetPoint("CENTER", WorldFrame, "CENTER");
		end
		
		frame:Show();
		
		-- FRAME BEHAVIORS
		frame.CloseButton:SetScript("OnClick", function(self) Hide(frame) end); -- When the player selects the X on the frame, hide it. Same behavior as typing the command consecutively.
	end
end
-- Synopsis: Displays the provided frame on screen.
--[[
	frame:			Name of the frame to display
]]

addonTbl.CreateFrame = function(name, height, width)
	-- If the frame is already created, then call the Show function instead.
	if not frame then
		frame = CreateFrame("Frame", name, UIParent, "BasicFrameTemplateWithInset");
		frame:SetSize(height, width);
		Show(frame);
	else
		Show(frame);
	end
end
-- Synopsis: Responsible for building a frame.
--[[
	name:			Name of the frame
	height:			The height, in pixels, of the frame
	width:			The width or length, in pixels, of the frame
]]