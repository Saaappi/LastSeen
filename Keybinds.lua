local addonName, addon = ...

BINDING_NAME_LASTSEEN_OPEN_SETTINGS = "Open Settings"
BINDING_NAME_LASTSEEN_OPEN_SEARCH = "Open Search"

function LastSeen:KeyBind(keybind)
	if keybind == GetBindingKey("LASTSEEN_OPEN_SETTINGS") then
		Settings.OpenToCategory(addonName)
	elseif keybind == GetBindingKey("LASTSEEN_OPEN_SEARCH") then
		LastSeen:SlashCommandHandler("search")
	end
end