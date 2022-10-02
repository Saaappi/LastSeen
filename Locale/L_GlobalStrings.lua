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
	L_GLOBALSTRINGS["Tabs.Features"] 															= "|T134152:0|t" .. " " .. "Features" -- Icon: Hertz Locker (Achievement)
	L_GLOBALSTRINGS["Tabs.Filters"] 															= "|T134400:0|t" .. " " .. "Filters" -- Icon: Inv_misc_questionmark
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
	L_GLOBALSTRINGS["DropDowns.General.Mode.Desc"] 												= "Select the addon's output mode.\n\n|cffFFD100Debug|r: All the same output from Normal mode and then some.\n|cffFFD100Normal|r: Informs the player when an item is seen for the first time and when it's updated.\n|cffFFD100Silent|r: No output from LastSeen. It's too quiet in here."
	L_GLOBALSTRINGS["DropDowns.Disabled"] 														= "Disabled"
	L_GLOBALSTRINGS["DropDowns.General.Mode.Debug"] 											= "Debug"
	L_GLOBALSTRINGS["DropDowns.General.Mode.Normal"] 											= "Normal"
	L_GLOBALSTRINGS["DropDowns.General.Mode.Silent"] 											= "Silent"
	L_GLOBALSTRINGS["DropDowns.General.Rarity.Title"]											= "Rarity"
	L_GLOBALSTRINGS["DropDowns.General.Rarity.Desc"]											= "Select the minimum item rarity threshold that the addon will process."
	L_GLOBALSTRINGS["DropDowns.General.Rarity.Poor"]											= "|cff9D9D9DPoor|r"
	L_GLOBALSTRINGS["DropDowns.General.Rarity.Common"]											= "|cffFFFFFFCommon|r"
	L_GLOBALSTRINGS["DropDowns.General.Rarity.Uncommon"]										= "|cff1EFF00Uncommon|r"
	L_GLOBALSTRINGS["DropDowns.General.Rarity.Rare"]											= "|cff0070DDRare|r"
	L_GLOBALSTRINGS["DropDowns.General.Rarity.Epic"]											= "|cffA335EEEpic|r"
	L_GLOBALSTRINGS["DropDowns.General.DateFormat.Title"]										= "Date Format"
	L_GLOBALSTRINGS["DropDowns.General.DateFormat.Desc"]										= "Choose the date format LastSeen should use when adding and updating items in its database."
	L_GLOBALSTRINGS["DropDowns.General.DateFormat.US"]											= "MM/DD/YYYY"
	L_GLOBALSTRINGS["DropDowns.General.DateFormat.EU"]											= "DD/MM/YYYY"
	-- End: 	General DropDowns
	--
	-- Start: 	Features Toggles
	L_GLOBALSTRINGS["Features.Toggle.ScanOnLootOpened"] 										= "Scan on Loot Opened"
	L_GLOBALSTRINGS["Features.Toggle.ScanOnLootOpenedDesc"] 									= "Toggle for LastSeen to scan when the loot window is opened, as opposed to when items are looted into your inventory.\n\nThis is only useful for boss loot from dungeons and raids. I recommend you leave this unchecked."
	L_GLOBALSTRINGS["Features.Toggle.ScanTooltipsOnHover"] 										= "Scan Tooltip on Hover"
	L_GLOBALSTRINGS["Features.Toggle.ScanTooltipsOnHoverDesc"] 									= "Scans the tooltip while the Quest frame is open. This is useful for cataloging all available quest rewards and not only the one you chose.\n\n|cffFFD100NOTE|r: This will scan ALL tooltips while the Quest frame is open. I recommend you leave this unchecked."
	L_GLOBALSTRINGS["Features.Toggle.ShowExtraSources"] 										= "Show Extra Sources"
	L_GLOBALSTRINGS["Features.Toggle.ShowExtraSourcesDesc"] 									= "Toggle to show how many sources the current item (on hover) has and display up to 4 additional sources in the tooltip."
	-- End: 	Features Toggles
	--
	-- Start: 	Filters Toggles
	L_GLOBALSTRINGS["Filters.Toggle.Consumable"] 												= "Consumable"
	L_GLOBALSTRINGS["Filters.Toggle.ConsumableDesc"] 											= "Toggle the |cffFFD100Consumable|r item type filter."
	L_GLOBALSTRINGS["Filters.Toggle.Weapon"] 													= "Weapon"
	L_GLOBALSTRINGS["Filters.Toggle.WeaponDesc"] 												= "Toggle the |cffFFD100Weapon|r item type filter."
	L_GLOBALSTRINGS["Filters.Toggle.Gem"] 														= "Gem"
	L_GLOBALSTRINGS["Filters.Toggle.GemDesc"] 													= "Toggle the |cffFFD100Gem|r item type filter."
	L_GLOBALSTRINGS["Filters.Toggle.Armor"] 													= "Armor"
	L_GLOBALSTRINGS["Filters.Toggle.ArmorDesc"] 												= "Toggle the |cffFFD100Armor|r item type filter."
	L_GLOBALSTRINGS["Filters.Toggle.TradeGoods"] 												= "Trade Goods"
	L_GLOBALSTRINGS["Filters.Toggle.TradeGoodsDesc"] 											= "Toggle the |cffFFD100Trade Goods|r item type filter."
	L_GLOBALSTRINGS["Filters.Toggle.Recipe"] 													= "Recipe"
	L_GLOBALSTRINGS["Filters.Toggle.RecipeDesc"] 												= "Toggle the |cffFFD100Recipe|r item type filter."
	L_GLOBALSTRINGS["Filters.Toggle.Quest"] 													= "Quest"
	L_GLOBALSTRINGS["Filters.Toggle.QuestDesc"] 												= "Toggle the |cffFFD100Quest|r item type filter."
	L_GLOBALSTRINGS["Filters.Toggle.Miscellaneous"] 											= "Miscellaneous"
	L_GLOBALSTRINGS["Filters.Toggle.MiscellaneousDesc"] 										= "Toggle the |cffFFD100Miscellaneous|r item type filter."
	-- End: 	Filters Toggles
	--
	-- Start: 	Text Output
	L_GLOBALSTRINGS["Text.Output.ColoredAddOnName"]												= "|cff00FFFF"..addonName.."|r"
	L_GLOBALSTRINGS["Text.Output.AddedItem.Debug"]												= "Added: |T%s:0|t %s (Source: %s) (Date: %s) (Map: %s)"
	L_GLOBALSTRINGS["Text.Output.AddedItem.Normal"]												= "Added: |T%s:0|t %s"
	L_GLOBALSTRINGS["Text.Output.UpdatedItem.Debug"]											= "Updated: |T%s:0|t %s"
	L_GLOBALSTRINGS["Text.Output.UpdatedItem.Normal"]											= "Updated: |T%s:0|t %s (Source: %s) (Date: %s) (Map: %s)"
	-- End: 	Text Output
	--
	-- Start: 	Minimap UI Buttons
	L_GLOBALSTRINGS["Minimap.UI.Button.SubText"] 												= "Configure LastSeen's settings."
	-- End: 	Minimap UI Buttons
	--
	-- Start: 	Constants
	L_GLOBALSTRINGS["Constant.LOOT_ITEM_SELF"] 													= "You receive loot: "
	L_GLOBALSTRINGS["Constant.LOOT_ITEM_PUSHED_SELF"] 											= "You receive item: "
	-- End: 	Constants
end

addonTable.L_GLOBALSTRINGS = L_GLOBALSTRINGS