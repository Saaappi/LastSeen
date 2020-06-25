-- Namespace Variables
local addon, addonTbl = ...;

addonTbl.Widget = function(name, type, frameName)
	if type == "Button" then
	elseif type == "DropDownMenu" then
	elseif type == "FontString" then
		if not 
	end
end
-- Synopsis: Creates a widget.
--[[
	name: 		Widget's name
	type: 		Widget's type (see below for supported widget types)
	frameName: 	Name of the frame the widget will be added to after its creation.
]]

addonTbl.AddWidget = function(widgetName)
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