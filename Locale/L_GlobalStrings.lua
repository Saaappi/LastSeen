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
	-- Start: 	Tabs
	L_GLOBALSTRINGS["Tabs.General"] 															= "|T136243:0|t" .. " " .. "General" -- Icon: Engineering
	L_GLOBALSTRINGS["Tabs.Filters"] 															= "|T134152:0|t" .. " " .. "Filters" -- Icon: Hertz Locker (Achievement)
	-- End: 	Tabs
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
	-- Start: 	General Toggles
	L_GLOBALSTRINGS["General.Toggle.Enable"] 													= "Enable"
	L_GLOBALSTRINGS["General.Toggle.EnableDesc"] 												= "Enables and disables addon functionality.\n\nChecked: |cff218721Enabled|r\nUnchecked: |cffFF0000Disabled|r"
	L_GLOBALSTRINGS["General.Toggle.MinimapIcon"] 												= "Minimap Icon"
	L_GLOBALSTRINGS["General.Toggle.MinimapIconDesc"] 											= "Enables and disables the minimap icon.\n\nChecked: |cff218721Shown|r\nUnchecked: |cffFF0000Hidden|r"
	-- End: 	General Toggles
	--
	-- Start: 	General Buttons
	L_GLOBALSTRINGS["General.Button.OpenIssue"] 												= "Open Issue"
	L_GLOBALSTRINGS["General.Button.OpenIssue.Text"] 											= "|T236688:36|t\n\nCopy the link below, and thank you for opening an issue!"
	-- End: 	General Buttons
	--
	-- Start: 	General DropDowns
	L_GLOBALSTRINGS["DropDowns.General.Mode.Title"] 											= "Mode"
	L_GLOBALSTRINGS["DropDowns.General.Mode.Desc"] 												= "Select the addon's output mode.\n\n|cffFFD100Debug|r: All the same output from |cffFFD100Normal|r mode and then some.\n|cffFFD100Normal|r: Informs the player when an item is seen for the first time and when it's updated.\n|cffFFD100Silent|r: No output from LastSeen. It's too quiet in here."
	L_GLOBALSTRINGS["DropDowns.Disabled"] 														= "Disabled"
	L_GLOBALSTRINGS["DropDowns.General.Mode.Debug"] 											= "Debug"
	L_GLOBALSTRINGS["DropDowns.General.Mode.Normal"] 											= "Normal"
	L_GLOBALSTRINGS["DropDowns.General.Mode.Silent"] 											= "Silent"
	-- End: 	General DropDowns
	--
	-- Start: 	Text Output
	L_GLOBALSTRINGS["Text.Output.ColoredAddOnName"]												= "|cff00FFFF"..addonName.."|r"
	-- End: 	Text Output
	--
	-- Start: 	Minimap UI Buttons
	L_GLOBALSTRINGS["Minimap.UI.Button.SubText"] 												= "Configure LastSeen's settings."
	-- End: 	Minimap UI Buttons
end

addonTable.L_GLOBALSTRINGS = L_GLOBALSTRINGS