-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local dropDownButtons;
local L = addonTbl.L;

local function OnClick(self, buttonText)
	UIDropDownMenu_SetText(dropDownButtons.parent, buttonText);
end
-- Synopsis: Changes the value of the mode dropdown to whatever the player selects.
--[[
	self: 			The button object within the dropdown menu
	buttonText:		This is what the button is supposed to say (eg. Debug, Normal, Quiet)
]]

addonTbl.CreateWidget = function(name, type, text, frameName, point, parent, relativePos, xOffset, yOffset, height, width)
	if not height and width then height = 0; width = 0; end; -- Height and Width are optional arguments
	if type == "Button" then
		frameName[name] = CreateFrame("CheckButton", name, parent, "UICheckButtonTemplate");
		frameName[name]:SetPoint(point, parent, relativePos, xOffset, yOffset);
		frameName[name].text:SetText(text);
	elseif type == "DropDownMenu" then
		frameName[name] = CreateFrame("Frame", name, parent, "UIDropDownMenuTemplate");
		frameName[name]:SetPoint(point, parent, relativePos, xOffset, yOffset);
		frameName[name]:SetSize(width, height);
		frameName[name].initialize = function(name, level)
			dropDownButtons = UIDropDownMenu_CreateInfo();
			dropDownButtons.parent = name;
			dropDownButtons.func = OnClick;
			
			for i = 1, #addonTbl.MODE_DROPDOWN do
				dropDownButtons.text, dropDownButtons.arg1 = addonTbl.MODE_DROPDOWN[i], addonTbl.MODE_DROPDOWN[i];
				UIDropDownMenu_AddButton(dropDownButtons);
			end
			
		end
	elseif type == "FontString" then
		frameName[name] = frameName:CreateFontString(nil, "OVERLAY");
		frameName[name]:SetFontObject("GameFontHighlight");
		frameName[name]:SetPoint(point, parent, relativePos, xOffset, yOffset);
		frameName[name]:SetText(text);
	end
end
-- Synopsis: Creates a widget.
--[[
	name: 			Widget's name
	type: 			Widget's type (see below for supported widget types)
	text:			The text, if necessary, to use (eg. button or fontstring)
	frameName: 		Name of the frame the widget will be added to after its creation
	point:			The position on the screen the frame should be placed. Left, Center, etc.
	parent:			The parent frame's name
	relativePos:	The position, relative to the parent, that the frame should be placed
	xOffset:		From the final position, how many pixels left or right to offset the frame
	yOffset:		From the final position, how many pixels up or down to offset the frame
	height:			The height of the widget (optional arg)
	width:			The height of the widget (optional arg)
	
	Supported Widgets:
	- Button
	- DropDownMenu
	- FontString
]]