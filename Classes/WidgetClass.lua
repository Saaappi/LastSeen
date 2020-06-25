-- Namespace Variables
local addon, addonTbl = ...;

addonTbl.Widget = function(name, type, text, frameName, point, parent, relativePos, xOffset, yOffset)
	if type == "Button" then
	elseif type == "DropDownMenu" then
	elseif type == "FontString" then
		frameName[name] = frameName:CreateFontString(nil, "OVERLAY");
		frameName[name]:SetFontObject("GameFontHighlight");
		frameName[name]:SetText(text);
		addonTbl.AddWidget(name, frameName, point, parent, relativePos, xOffset, yOffset);
	end
end
-- Synopsis: Creates a widget.
--[[
	name: 		Widget's name
	type: 		Widget's type (see below for supported widget types)
	text:		The text, if necessary, to use (eg. button or fontstring)
	frameName: 	Name of the frame the widget will be added to after its creation.
]]

addonTbl.AddWidget = function(name, frameName, point, parent, relativePos, xOffset, yOffset)
	if not frameName[name] then
		if name == "title" then
			frameName[name]:SetPoint(point, parent, relativePos, xOffset, yOffset);
		end
	end
end
-- Synopsis: Places a widget on a frame.

addonTbl.RemoveWidget = function(widgetName)
end
-- Synopsis: Hides a widget on a frame.

--[[
	Supported Widgets:
	- Button
	- DropDownMenu
	- FontString
]]