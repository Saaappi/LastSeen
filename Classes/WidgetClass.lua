-- Namespace Variables
local addon, addonTbl = ...;

addonTbl.Widget = function(name, type, text, frameName)
	if type == "Button" then
	elseif type == "DropDownMenu" then
	elseif type == "FontString" then
		frameName.name = frameName:CreateFontString(nil, "OVERLAY");
		frameName.name:SetFontObject("GameFontHighlight");
		frameName.name:SetText(text);
	end
end
-- Synopsis: Creates a widget.
--[[
	name: 		Widget's name
	type: 		Widget's type (see below for supported widget types)
	text:		The text, if necessary, to use (eg. button or fontstring)
	frameName: 	Name of the frame the widget will be added to after its creation.
]]

addonTbl.AddWidget = function(name, frameName)
	if not frameName.name then
		if name == "title" then
			frameName.name:SetPoint("CENTER", frameName.TitleBg, "CENTER", 5, 0);
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