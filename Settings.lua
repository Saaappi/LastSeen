local addon, tbl = ...;

tbl.LoadSettings = function()
	tbl.CreateFrame("LastSeenSettingsFrame", 400, 175);
end
--[[
	Synopsis: Loads either the settings from the cache or loads the settings frame.
	Use Case(s):
		true: If 'doNotOpen' is true, then the addon made the call so it can load the settings from the cache.
		false: If 'doNotOpen' is false, then the player made the call so the settings menu should be shown (or closed if already open.)
]]