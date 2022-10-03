local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

BINDING_HEADER_LASTSEEN = "LastSeen"
BINDING_NAME_LASTSEEN_OPEN_SETTINGS = L_GLOBALSTRINGS["Keybind.OpenSettings"]

function LastSeen:Keybind(key)
	if key == GetBindingKey("LASTSEEN_OPEN_SETTINGS") then
		if InterfaceOptionsFrame:IsVisible() then
			InterfaceOptionsFrameOkay:Click()
		else
			InterfaceAddOnsList_Update()
			InterfaceOptionsFrame_OpenToCategory(addonTable.mainOptions)
		end
	end
end