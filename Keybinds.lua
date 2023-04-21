local addonName, addonTable = ...

BINDING_HEADER_LASTSEEN = "LastSeen"
BINDING_NAME_LASTSEEN_OPEN_SETTINGS = "LastSeen: Open Settings"
BINDING_NAME_LASTSEEN_OPEN_SEARCH = "LastSeen: Open Search"

function LastSeen:KeyBind(keybind)
	if keybind == GetBindingKey("LASTSEEN_OPEN_SETTINGS") then
		Settings.OpenToCategory(addonName)
	elseif keybind == GetBindingKey("LASTSEEN_OPEN_SEARCH")
		LastSeen:SlashCommandHandler("search")
	end
end