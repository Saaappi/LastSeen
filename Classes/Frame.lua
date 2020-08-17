-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local frame;
local isFrameVisible;
local L = tbl.L;

local function ShowTooltip(self, text)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
	GameTooltip:SetText(text);
	GameTooltip:Show();
end
-- Displays a custom tooltip.
--[[
	self:			This is the instance of the GameTooltip object
	text:			Text to display when the tooltip is shown
]]

local function HideTooltip(self)
	if GameTooltip:GetOwner() == self then
		GameTooltip:Hide();
	end
end
-- Synopsis: Hides a custom tooltip.
--[[
	self:			This is the instance of the GameTooltip object
]]

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
		if not frame["title"] then -- If title doesn't exist, then it's likely that none of the other widgets exist.
			tbl.CreateWidget("FontString", "title", "[Shadowlands] " .. L["ADDON_NAME_SETTINGS"], frame, "CENTER", frame.TitleBg, "CENTER", 5, 0);
			tbl.CreateWidget("FontString", "itemCounter", tbl.GetCount(LastSeenItemsDB), frame, "CENTER", frame, "CENTER", 0, 35);
			tbl.CreateWidget("FontString", "filtersText", "Filters", frame, "CENTER", frame, "CENTER", 100, 30, "morpheus", 14);
			tbl.CreateWidget("Button", "showSourcesCheckButton", L["SHOW_SOURCES"], frame, "CENTER", frame, "CENTER", -150, -40);
			tbl.CreateWidget("DropDownMenu", "modeDropDownMenu", "", frame, "CENTER", frame, "CENTER", -100, 0);
			tbl.CreateWidget("Button", "neckFilterButton", "Neck", frame, "CENTER", frame, "CENTER", 45, 0);
			tbl.CreateWidget("Button", "ringFilterButton", "Rings", frame, "CENTER", frame, "CENTER", 45, -40);
			tbl.CreateWidget("Button", "trinketFilterButton", "Trinkets", frame, "CENTER", frame, "CENTER", 110, 0);
			tbl.CreateWidget("Button", "questFilterButton", "Quests", frame, "CENTER", frame, "CENTER", 110, -40);
		elseif frame["itemCounter"] then -- If the widgets were already created, we don't want to recreate the itemCounter widget, but update it.
			tbl.UpdateWidget("itemCounter", frame, tbl.GetCount(LastSeenItemsDB));
		end
		
		if frame then
			frame:SetMovable(true);
			frame:EnableMouse(true);
			frame:RegisterForDrag("LeftButton");
			frame:SetScript("OnDragStart", frame.StartMoving);
			frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
			frame:ClearAllPoints();
			frame:SetPoint("CENTER", WorldFrame, "CENTER");
		end
		
		-- FRAME BEHAVIORS
		frame.CloseButton:SetScript("OnClick", function(self) Hide(frame) end); -- When the player selects the X on the frame, hide it. Same behavior as typing the command consecutively.
		
		frame.modeDropDownMenu:SetScript("OnEnter", function(self) ShowTooltip(self, L["MODE_DESCRIPTIONS"]) end); -- When the player hovers over the dropdown menu, display a custom tooltip.
		frame.modeDropDownMenu:SetScript("OnLeave", function(self) HideTooltip(self) end); -- When the player is no longer hovering, hide the tooltip.
		if LastSeenSettingsCacheDB["mode"] then
			UIDropDownMenu_SetText(modeDropDownMenu, LastSeenSettingsCacheDB["mode"]);
		end
		
		if LastSeenSettingsCacheDB["showSources"] then
			frame.showSourcesCheckButton:SetChecked(true);
			tbl.showSources = true;
		else
			frame.showSourcesCheckButton:SetChecked(false);
			tbl.showSources = false;
		end
		frame.showSourcesCheckButton:SetScript("OnClick", function(self, event, arg1)
			if self:GetChecked() then
				tbl.showSources = true;
				LastSeenSettingsCacheDB.showSources = true;
			else
				tbl.showSources = false;
				LastSeenSettingsCacheDB.showSources = false;
			end
		end);
		frame.showSourcesCheckButton:SetScript("OnEnter", function(self) ShowTooltip(self, L["SHOW_SOURCES_DESC"]) end);
		frame.showSourcesCheckButton:SetScript("OnLeave", function(self) HideTooltip(self) end);
		
		frame.neckFilterButton:SetScript("OnEnter", function(self) ShowTooltip(self, "Tells the addon to track or ignore necklaces. Check to track or uncheck to ignore.") end);
		frame.neckFilterButton:SetScript("OnLeave", function(self) HideTooltip(self) end);
		
		frame.ringFilterButton:SetScript("OnEnter", function(self) ShowTooltip(self, "Tells the addon to track or ignore rings. Check to track or uncheck to ignore.") end);
		frame.ringFilterButton:SetScript("OnLeave", function(self) HideTooltip(self) end);
		
		frame.trinketFilterButton:SetScript("OnEnter", function(self) ShowTooltip(self, "Tells the addon to track or ignore trinkets. Check to track or uncheck to ignore.") end);
		frame.trinketFilterButton:SetScript("OnLeave", function(self) HideTooltip(self) end);
		
		frame.questFilterButton:SetScript("OnEnter", function(self) ShowTooltip(self, "Tells the addon to track or ignore quest items. Check to track or uncheck to ignore.") end);
		frame.questFilterButton:SetScript("OnLeave", function(self) HideTooltip(self) end);
		
		frame:Show();
	end
end
-- Synopsis: Displays the provided frame on screen.
--[[
	frame:			Name of the frame to display
]]

tbl.CreateFrame = function(name, width, height)
	-- If the frame is already created, then call the Show function instead.
	if not frame then
		frame = CreateFrame("Frame", name, UIParent, "BasicFrameTemplateWithInset");
		frame:SetSize(width, height);
		Show(frame);
	else
		Show(frame);
	end
end
-- Synopsis: Responsible for building a frame.
--[[
	name:			Name of the frame
	width:			The width or length, in pixels, of the frame
	height:			The height, in pixels, of the frame
]]