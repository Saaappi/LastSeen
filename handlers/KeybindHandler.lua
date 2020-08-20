local addon, tbl = ...

BINDING_HEADER_LASTSEEN = addon
BINDING_NAME_LASTSEEN_OPEN_SETTINGS = tbl.L["KEYBIND_OPEN_SETTINGS"]

function LastSeenKeyPressHandler(key)
	if key == GetBindingKey("LASTSEEN_OPEN_SETTINGS") then
		tbl.LoadSettings()
	end
end