-- Namespace Variables
local addon, addonTbl = ...;

addonTbl.Widget = function(name, type)
	if type == "Button" then
	elseif type == "DropDownMenu" then
	elseif type == "FontString" then
	end
end
-- Synopsis: Creates a widget.

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