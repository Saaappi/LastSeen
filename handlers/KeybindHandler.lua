-- Namespace Variables
local addon, tbl = ...;

-- Module-Local Variables
local L = tbl.L

-- Keybindings
BINDING_HEADER_LASTSEEN = addon
BINDING_NAME_LASTSEEN_OPEN_SETTINGS = L["KEYBIND_SETTING_OPEN_SETTINGS"];

function LastSeenKeyPressHandler(key)
	if key == GetBindingKey("LASTSEEN_OPEN_SETTINGS") then
		tbl.LoadSettings(false);
	end
end