-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local L = addonTbl.L;

-- Keybindings
BINDING_HEADER_LASTSEEN = addon;
BINDING_NAME_LASTSEEN_OPEN_SETTINGS = L["KEYBIND_SETTING_OPEN_SETTINGS"];

function LastSeenKeyPressHandler(key)
	if key == GetBindingKey("LASTSEEN_OPEN_SETTINGS") then
		addonTbl.LoadSettings(false);
	end
end