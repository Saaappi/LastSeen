local addonName, addonTable = ...
local locale = GAME_LOCALE or GetLocale()
local isLocaleSupported = false
local supportedLocales = {
	"enGB",
	"enUS",
	"deDE",
	"esMX",
	"ptBR",
	"esES",
	"frFR",
	"itIT",
	"ruRU",
	"koKR",
	"zhTW",
	"zhCN",
}
local L_GLOBALSTRINGS = setmetatable({}, { __index = function(t, k)
	local v = tostring(k)
	rawset(t, k, v)
	return v
end })

for i=1,#supportedLocales do
	if (supportedLocales[i] == locale) then
		isLocaleSupported = true
	end
end

if (isLocaleSupported) then
	-- Start: 	Commands
	L_GLOBALSTRINGS["Command.Slash1"] 															= "ls"
	L_GLOBALSTRINGS["Command.Slash2"] 															= "lastseen"
	-- End: 	Commands
	--
	-- Start: 	Headers
	L_GLOBALSTRINGS["Header.Toggles"] 															= "Toggles"
	L_GLOBALSTRINGS["Header.DropDowns"] 														= "DropDowns"
	L_GLOBALSTRINGS["Header.About"] 															= "About"
	L_GLOBALSTRINGS["Header.Resources"] 														= "Resources"
	-- End: 	Headers
	--
	-- Start: 	Descriptions
	L_GLOBALSTRINGS["MainOptions.Version"] 														= "|cffFFD100Version|r: " .. GetAddOnMetadata(addonName, "Version")
	L_GLOBALSTRINGS["MainOptions.Author"] 														= "|cffFFD100Author|r: Newtreants (AeriePeak-US) (aka Lightsky)"
	L_GLOBALSTRINGS["MainOptions.Contact"] 														= "|cffFFD100Contact|r: Lightsky#0658 (Discord)"
	-- End: 	Descriptions
	--
	-- Start: 	General Buttons
	L_GLOBALSTRINGS["General.Button.OpenIssue"] 												= "Open Issue"
	L_GLOBALSTRINGS["General.Button.OpenIssue.Text"] 											= "|T236688:36|t\n\nCopy the link below, and thank you for opening an issue!"
	-- End: 	General Buttons
end

addonTable.L_GLOBALSTRINGS = L_GLOBALSTRINGS