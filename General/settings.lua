--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Houses the skeleton of the system that controls the addon's settings.
]]--

local lastSeen, LastSeenTbl = ...;

----- START SETTINGS FUNCTIONS -----
local function CountItemsSeen(tbl)
	local count = 0;
	for k, v in pairs(tbl) do
		count = count + 1;
	end
	return count;
end
----- END SETTINGS FUNCTIONS -----

----- START SETTINGS UI -----
local settingsFrame = CreateFrame("Frame", "lastSeenSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local L = LastSeenTbl.L;
local SETTINGS = {};
local modeList, rarityList, rareSoundIDList;
local areOptionsOpen = false;
local rarityConversionTable = {
	[0] = L["POOR"],
	[1] = L["COMMON"],
	[2] = L["UNCOMMON"],
	[3] = L["RARE"],
	[4] = L["EPIC"],
	[5] = L["LEGENDARY"],
};

local rareSoundIDConversionTable = {
	[567437] = L["DEFAULT_SOUND"],
	[546633] = L["CTHUN_SOUND"],
	[558780] = L["RAGNAROS_SOUND"],
	[1689869] = L["ARGUS_SOUND"],
};

local function Tab_OnClick(self)
	if (self:GetID() == 1) then
		if LastSeenTbl.tab2 and LastSeenTbl.tab3 then
			LastSeenTbl.tab2:Hide();
			LastSeenTbl.tab3:Hide();
		end
	elseif (self:GetID() == 2) then
		if LastSeenTbl.tab1 and LastSeenTbl.tab3 then
			LastSeenTbl.tab1:Hide();
			LastSeenTbl.tab3:Hide();
		end
	elseif (self:GetID() == 3) then
		if LastSeenTbl.tab1 and LastSeenTbl.tab2 then
			LastSeenTbl.tab1:Hide();
			LastSeenTbl.tab2:Hide();
		end
	end
	PanelTemplates_SetTab(self:GetParent(), self:GetID());
	self.content:Show();
end

local function Tab_SetTab(frame, numTabs, ...)
	frame.numTabs = numTabs;
	
	local contents = {};
	local frameName = frame:GetName();
	
	for i = 1, numTabs do
		local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "CharacterFrameTabButtonTemplate");
		tab:SetID(i);
		tab:SetText(select(i, ...));
		tab:SetScript("OnClick", Tab_OnClick);
		
		tab.content = CreateFrame("Frame", nil, settingsFrame);
		tab.content:Hide();
		
		table.insert(contents, tab.content);
		
		if (i == 1) then
			tab:SetPoint("TOPLEFT", settingsFrame, "BOTTOMLEFT", 5, 1);
		else
			tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", -14, 0);
		end
		
		_G["lastSeenSettingsFrameTab"..i]:SetWidth(0);
		PanelTemplates_TabResize(_G["lastSeenSettingsFrameTab"..i], 0, nil, 36, 88);
	end
	
	Tab_OnClick(_G["lastSeenSettingsFrameTab1"]); -- This is the default tab selected on open.
	
	return unpack(contents);
end
----- END SETTINGS UI -----

----- START SETTINGS -----
local function RemoveIgnoredItems()
	-- When the player re-enables the ignore checks any previously added ignored items will be purged.
	for k, v in pairs(LastSeenItemsDB) do
		if LastSeenTbl.ignoredItems[k] ~= nil or LastSeenTbl.ignoredItemTypes[select(2, GetItemInfoInstant(k))] ~= nil then
			LastSeenItemsDB[k] = nil;
		end
	end
end

local function GetOptions(arg)
	if LastSeenSettingsCacheDB[arg] then
		LastSeenTbl[arg] = LastSeenSettingsCacheDB[arg];
		return LastSeenSettingsCacheDB[arg];
	else
		if arg == "mode" then
			LastSeenSettingsCacheDB[arg] = L["NORMAL_MODE"]; LastSeenTbl[arg] = LastSeenSettingsCacheDB[arg];
			return LastSeenSettingsCacheDB[arg];
		elseif arg == "rarity" then
			LastSeenSettingsCacheDB[arg] = 2; LastSeenTbl[arg] = LastSeenSettingsCacheDB[arg];
			return LastSeenSettingsCacheDB[arg];
		elseif arg == "rareSoundID" then
			LastSeenSettingsCacheDB[arg] = 567437; LastSeenTbl[arg] = LastSeenSettingsCacheDB[arg];
			return LastSeenSettingsCacheDB[arg];
		end
	end
end

local function ModeDropDownMenu_OnClick(self, arg1)
	LastSeenSettingsCacheDB.mode = arg1;
	UIDropDownMenu_SetText(LastSeenTbl.tab1.modeDropDown, arg1);
end

local function RareSoundIDDropDownMenu_OnClick(self, arg1, arg2)
	LastSeenSettingsCacheDB.rareSoundID = arg1;
	UIDropDownMenu_SetText(LastSeenTbl.tab1.rareSoundIDDropDown, arg2);
	PlaySoundFile(arg1);
end

local function RarityDropDownMenu_OnClick(self, arg1, arg2)
	LastSeenSettingsCacheDB.rarity = arg1;
	UIDropDownMenu_SetText(LastSeenTbl.tab1.rarityDropDown, arg2);
end

local function SettingsMenu_OnClose()
	LastSeenTbl.tab2.queryEditBox:SetText(""); LastSeenTbl.tab2.characterEditBox:SetText(""); LastSeenTbl.tab2.realmNameEditBox:SetText("");
	settingsFrame:Hide(); LastSeenTbl.tab1:Hide(); LastSeenTbl.tab2:Hide(); LastSeenTbl.tab3:Hide();
	areOptionsOpen = false;
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
end

local function SettingsMenu_OnShow()
	if not LastSeenTbl.tab1 or not LastSeenTbl.tab2 or not LastSeenTbl.tab3 then
		LastSeenTbl.tab1, LastSeenTbl.tab2, LastSeenTbl.tab3 = Tab_SetTab(settingsFrame, 3, L["SETTINGS_TAB_GENERAL"], L["SETTINGS_TAB_SHARE"], L["SETTINGS_TAB_ACKNOWLEDGMENTS"]);
		LastSeenTbl.tab1:SetSize(308, 500); LastSeenTbl.tab2:SetSize(308, 500); LastSeenTbl.tab3:SetSize(600, 500);
	end
	
	-- General frame settings
	if settingsFrame then
		settingsFrame:SetMovable(true);
		settingsFrame:EnableMouse(true);
		settingsFrame:RegisterForDrag("LeftButton");
		settingsFrame:SetScript("OnDragStart", settingsFrame.StartMoving)
		settingsFrame:SetScript("OnDragStop", settingsFrame.StopMovingOrSizing)
		settingsFrame:SetSize(400, 400);
		settingsFrame:ClearAllPoints();
		settingsFrame:SetPoint("CENTER", WorldFrame, "CENTER");
	end
	
	Tab_OnClick(_G["lastSeenSettingsFrameTab1"]);
	
	if not settingsFrame.title then
		settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY");
		settingsFrame.title:SetFontObject("GameFontHighlight");
		settingsFrame.title:SetPoint("CENTER", settingsFrame.TitleBg, "CENTER", 5, 0);
		settingsFrame.title:SetText(L["ADDON_NAME_SETTINGS"]);
	end
	
	----- START TAB1 -----
	if not LastSeenTbl.tab1.itemsSeenLabel then
		LastSeenTbl.tab1.itemsSeenLabel = LastSeenTbl.tab1:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab1.itemsSeenLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab1.itemsSeenLabel:SetPoint("TOP", settingsFrame.title, "BOTTOM", -125, -15);
		LastSeenTbl.tab1.itemsSeenLabel:SetFont("Fonts\\Arial.ttf", 8);
		LastSeenTbl.tab1.itemsSeenLabel:SetText(L["ITEMS_SEEN"] .. LastSeenTbl.GetItemsSeen(LastSeenItemsDB));
	end
	
	if not LastSeenTbl.tab1.versionLabel then
		LastSeenTbl.tab1.versionLabel = LastSeenTbl.tab1:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab1.versionLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab1.versionLabel:SetPoint("TOPRIGHT", LastSeenTbl.tab1.itemsSeenLabel, 265, 0);
		LastSeenTbl.tab1.versionLabel:SetFont("Fonts\\Arial.ttf", 8);
		LastSeenTbl.tab1.versionLabel:SetText(L["RELEASE"]);
	end

	if not LastSeenTbl.tab1.releaseDateLabel then
		LastSeenTbl.tab1.releaseDateLabel = LastSeenTbl.tab1:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab1.releaseDateLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab1.releaseDateLabel:SetPoint("TOP", LastSeenTbl.tab1.versionLabel, "BOTTOM", -15, -5);
		LastSeenTbl.tab1.releaseDateLabel:SetFont("Fonts\\Arial.ttf", 8);
		LastSeenTbl.tab1.releaseDateLabel:SetText("16.08.2019");
	end

	if not LastSeenTbl.tab1.modeLabel then
		LastSeenTbl.tab1.modeLabel = LastSeenTbl.tab1:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab1.modeLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab1.modeLabel:SetPoint("TOP", LastSeenTbl.tab1.itemsSeenLabel, "BOTTOM", 0, -30);
		LastSeenTbl.tab1.modeLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
		LastSeenTbl.tab1.modeLabel:SetText(L["MODE"]);
	end
	
	if not LastSeenTbl.tab1.modeDropDown then
		LastSeenTbl.tab1.modeDropDown = CreateFrame("Frame", "lastSeenModeDropDown", LastSeenTbl.tab1, "UIDropDownMenuTemplate");
		LastSeenTbl.tab1.modeDropDown:SetPoint("TOP", LastSeenTbl.tab1.modeLabel, "BOTTOM", 25, -2);
		LastSeenTbl.tab1.modeDropDown:SetSize(175, 30);
		LastSeenTbl.tab1.modeDropDown.initialize = function(self, level)
			modeList = UIDropDownMenu_CreateInfo();

			modeList.text = L["VERBOSE_MODE"];
			modeList.func = ModeDropDownMenu_OnClick;
			modeList.arg1 = L["VERBOSE_MODE"];
			UIDropDownMenu_AddButton(modeList, level);
			
			modeList.text = L["NORMAL_MODE"];
			modeList.func = ModeDropDownMenu_OnClick;
			modeList.arg1 = L["NORMAL_MODE"];
			UIDropDownMenu_AddButton(modeList, level);

			modeList.text = L["QUIET_MODE"];
			modeList.func = ModeDropDownMenu_OnClick;
			modeList.arg1 = L["QUIET_MODE"];
			UIDropDownMenu_AddButton(modeList, level);
		end
	end

	if LastSeenSettingsCacheDB.mode then
		UIDropDownMenu_SetText(LastSeenTbl.tab1.modeDropDown, LastSeenSettingsCacheDB.mode);
	end

	if not LastSeenTbl.tab1.rarityLabel then
		LastSeenTbl.tab1.rarityLabel = LastSeenTbl.tab1:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab1.rarityLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab1.rarityLabel:SetPoint("TOP", LastSeenTbl.tab1.modeLabel, "BOTTOM", 0, -40);
		LastSeenTbl.tab1.rarityLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
		LastSeenTbl.tab1.rarityLabel:SetText(L["RARITY"]);
	end

	if not LastSeenTbl.tab1.rarityDropDown then
		LastSeenTbl.tab1.rarityDropDown = CreateFrame("Frame", nil, LastSeenTbl.tab1, "UIDropDownMenuTemplate");
		LastSeenTbl.tab1.rarityDropDown:SetPoint("TOP", LastSeenTbl.tab1.modeDropDown, "BOTTOM", 0, -30);
		LastSeenTbl.tab1.rarityDropDown:SetSize(175, 30);
		LastSeenTbl.tab1.rarityDropDown.initialize = function(self, level)
			rarityList = UIDropDownMenu_CreateInfo();

			rarityList.text = L["POOR"];
			rarityList.func = RarityDropDownMenu_OnClick;
			rarityList.arg1 = 0;
			rarityList.arg2 = L["POOR"];
			rarityList.checked = RarityDropDownMenu_OnClick;
			UIDropDownMenu_AddButton(rarityList, level);

			rarityList.text = L["COMMON"];
			rarityList.func = RarityDropDownMenu_OnClick;
			rarityList.arg1 = 1;
			rarityList.arg2 = L["COMMON"];
			UIDropDownMenu_AddButton(rarityList, level);

			rarityList.text = L["UNCOMMON"];
			rarityList.func = RarityDropDownMenu_OnClick;
			rarityList.arg1 = 2;
			rarityList.arg2 = L["UNCOMMON"];
			rarityList.checked = RarityDropDownMenu_OnClick;
			UIDropDownMenu_AddButton(rarityList, level);

			rarityList.text = L["RARE"];
			rarityList.func = RarityDropDownMenu_OnClick;
			rarityList.arg1 = 3;
			rarityList.arg2 = L["RARE"];
			UIDropDownMenu_AddButton(rarityList, level);

			rarityList.text = L["EPIC"];
			rarityList.func = RarityDropDownMenu_OnClick;
			rarityList.arg1 = 4;
			rarityList.arg2 = L["EPIC"];
			UIDropDownMenu_AddButton(rarityList, level);

			rarityList.text = L["LEGENDARY"];
			rarityList.func = RarityDropDownMenu_OnClick;
			rarityList.arg1 = 5;
			rarityList.arg2 = L["LEGENDARY"];
			UIDropDownMenu_AddButton(rarityList, level);
		end
	end

	if rarityConversionTable[LastSeenSettingsCacheDB.rarity] then
		UIDropDownMenu_SetText(LastSeenTbl.tab1.rarityDropDown, rarityConversionTable[LastSeenSettingsCacheDB.rarity]);
	end
	
	if not LastSeenTbl.tab1.rareSoundIDLabel then
		LastSeenTbl.tab1.rareSoundIDLabel = LastSeenTbl.tab1:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab1.rareSoundIDLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab1.rareSoundIDLabel:SetPoint("TOP", LastSeenTbl.tab1.rarityLabel, "BOTTOM", 25, -40);
		LastSeenTbl.tab1.rareSoundIDLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
		LastSeenTbl.tab1.rareSoundIDLabel:SetText(L["RARE_SOUND"]);
	end
	
	if not LastSeenTbl.tab1.rareSoundIDDropDown then
		LastSeenTbl.tab1.rareSoundIDDropDown = CreateFrame("Frame", nil, LastSeenTbl.tab1, "UIDropDownMenuTemplate");
		LastSeenTbl.tab1.rareSoundIDDropDown:SetPoint("TOP", LastSeenTbl.tab1.rarityDropDown, "BOTTOM", 0, -30);
		LastSeenTbl.tab1.rareSoundIDDropDown:SetSize(175, 30);
		LastSeenTbl.tab1.rareSoundIDDropDown.initialize = function(self, level)
			rareSoundIDList = UIDropDownMenu_CreateInfo();

			rareSoundIDList.text = L["DEFAULT_SOUND"];
			rareSoundIDList.func = RareSoundIDDropDownMenu_OnClick;
			rareSoundIDList.arg1 = 567437;
			rareSoundIDList.arg2 = L["DEFAULT_SOUND"];
			UIDropDownMenu_AddButton(rareSoundIDList, level);

			rareSoundIDList.text = L["CTHUN_SOUND"];
			rareSoundIDList.func = RareSoundIDDropDownMenu_OnClick;
			rareSoundIDList.arg1 = 546633;
			rareSoundIDList.arg2 = L["CTHUN_SOUND"];
			UIDropDownMenu_AddButton(rareSoundIDList, level);
			
			rareSoundIDList.text = L["RAGNAROS_SOUND"];
			rareSoundIDList.func = RareSoundIDDropDownMenu_OnClick;
			rareSoundIDList.arg1 = 558780;
			rareSoundIDList.arg2 = L["RAGNAROS_SOUND"];
			UIDropDownMenu_AddButton(rareSoundIDList, level);
			
			rareSoundIDList.text = L["ARGUS_SOUND"];
			rareSoundIDList.func = RareSoundIDDropDownMenu_OnClick;
			rareSoundIDList.arg1 = 1689869;
			rareSoundIDList.arg2 = L["ARGUS_SOUND"];
			UIDropDownMenu_AddButton(rareSoundIDList, level);
		end
	end
	
	if rareSoundIDConversionTable[LastSeenSettingsCacheDB.rareSoundID] then
		UIDropDownMenu_SetText(LastSeenTbl.tab1.rareSoundIDDropDown, rareSoundIDConversionTable[LastSeenSettingsCacheDB.rareSoundID]);
	end

	if not LastSeenTbl.tab1.optionsLabel then
		LastSeenTbl.tab1.optionsLabel = LastSeenTbl.tab1:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab1.optionsLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab1.optionsLabel:SetPoint("TOP", LastSeenTbl.tab1.modeLabel, 282, 0);
		LastSeenTbl.tab1.optionsLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
		LastSeenTbl.tab1.optionsLabel:SetText(L["OPTIONS_LABEL"]);
	end

	if not LastSeenTbl.tab1.rareSoundButton then
		LastSeenTbl.tab1.rareSoundButton = CreateFrame("CheckButton", "DisableRareSoundButton", LastSeenTbl.tab1, "UICheckButtonTemplate");
		LastSeenTbl.tab1.rareSoundButton:SetPoint("TOP", LastSeenTbl.tab1.optionsLabel, "BOTTOM", -75, -2);
		LastSeenTbl.tab1.rareSoundButton.text:SetText(L["OPTIONS_DISABLE_RARESOUND"]);
	end
	
	LastSeenTbl.tab1.rareSoundButton:SetScript("OnClick", function(self, event, arg1)
		if self:GetChecked() then
			LastSeenTbl.doNotPlayRareSound = true;
			LastSeenSettingsCacheDB.doNotPlayRareSound = true;
		else
			LastSeenTbl.doNotPlayRareSound = false;
			LastSeenSettingsCacheDB.doNotPlayRareSound = false;
		end
	end);
	
	LastSeenTbl.tab1.rareSoundButton:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetText(L["OPTIONS_DISABLE_RARESOUND_TEXT"]);
		GameTooltip:Show();
	end);
	
	LastSeenTbl.tab1.rareSoundButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);

	if LastSeenSettingsCacheDB.doNotPlayRareSound then
		LastSeenTbl.tab1.rareSoundButton:SetChecked(true);
		LastSeenTbl.doNotPlayRareSound = true;
	else
		LastSeenTbl.tab1.rareSoundButton:SetChecked(false);
		LastSeenTbl.doNotPlayRareSound = false;
	end
	
	if not LastSeenTbl.tab1.doNotIgnoreButton then
		LastSeenTbl.tab1.doNotIgnoreButton = CreateFrame("CheckButton", "DisableIgnoresButton", LastSeenTbl.tab1, "UICheckButtonTemplate");
		LastSeenTbl.tab1.doNotIgnoreButton:SetPoint("TOP", LastSeenTbl.tab1.rareSoundButton, "BOTTOM", 0, 5);
		LastSeenTbl.tab1.doNotIgnoreButton.text:SetText(L["OPTIONS_DISABLE_IGNORES"]);
	end
	
	LastSeenTbl.tab1.doNotIgnoreButton:SetScript("OnClick", function(self, event, arg1)
		if self:GetChecked() then
			LastSeenTbl.doNotIgnore = true;
			LastSeenSettingsCacheDB.doNotIgnore = true;
		else
			LastSeenTbl.doNotIgnore = false;
			LastSeenSettingsCacheDB.doNotIgnore = false;
			RemoveIgnoredItems();
		end
	end);
	
	LastSeenTbl.tab1.doNotIgnoreButton:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetText(L["OPTIONS_DISABLE_IGNORES_TEXT"]);
		GameTooltip:Show();
	end);
	
	LastSeenTbl.tab1.doNotIgnoreButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);
	
	if not LastSeenTbl.tab1.lootControlButton then
		LastSeenTbl.tab1.lootControlButton = CreateFrame("CheckButton", "LootControlButton", LastSeenTbl.tab1, "UICheckButtonTemplate");
		LastSeenTbl.tab1.lootControlButton:SetPoint("TOP", LastSeenTbl.tab1.doNotIgnoreButton, "BOTTOM", 0, 5);
		LastSeenTbl.tab1.lootControlButton.text:SetText(L["OPTIONS_LOOT_CONTROL"]);
	end
	
	if GetCVar("autoLootDefault") == "0" then
		LastSeenTbl.tab1.lootControlButton.text:SetText(L["OPTIONS_LOOT_CONTROL"]);
		LastSeenTbl.tab1.lootControlButton:SetScript("OnClick", function(self, event, arg1)
			if self:GetChecked() then
				LastSeenTbl.lootControl = true;
				LastSeenSettingsCacheDB.lootControl = true;
			else
				LastSeenTbl.lootControl = false;
				LastSeenSettingsCacheDB.lootControl = false;
			end
		end);
		
		LastSeenTbl.tab1.lootControlButton:SetScript("OnEnter", function(self)
			GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
			GameTooltip:SetText(L["OPTIONS_LOOT_CONTROL_TEXT"]);
			GameTooltip:Show();
		end);
		
		LastSeenTbl.tab1.lootControlButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end);

		if LastSeenSettingsCacheDB.lootControl then
			LastSeenTbl.tab1.lootControlButton:SetChecked(true);
			LastSeenTbl.lootControl = true;
		else
			LastSeenTbl.tab1.lootControlButton:SetChecked(false);
			LastSeenTbl.lootControl = false;
		end
	else
		LastSeenTbl.lootControl = false;
		LastSeenSettingsCacheDB.lootControl = false;
		LastSeenTbl.tab1.lootControlButton:Disable();
		LastSeenTbl.tab1.lootControlButton.text:SetText("|cff9d9d9d" .. L["OPTIONS_LOOT_CONTROL"] .. "|r");
	end
	
	LastSeenTbl.tab1.modeDropDown:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetText("|cffffffff" .. L["VERBOSE_MODE"] .. "|r: " .. L["VERBOSE_MODE_DESC"] .. 
		"|cffffffff" .. L["NORMAL_MODE"] .. "|r: " .. L["NORMAL_MODE_DESC"] .. 
		"|cffffffff" .. L["QUIET_MODE"] .. "|r: " .. L["QUIET_MODE_DESC"]);
		GameTooltip:Show();
	end);
	
	LastSeenTbl.tab1.modeDropDown:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);

	if LastSeenSettingsCacheDB.doNotIgnore then
		LastSeenTbl.tab1.doNotIgnoreButton:SetChecked(true);
		LastSeenTbl.doNotIgnore = true;
	else
		LastSeenTbl.tab1.doNotIgnoreButton:SetChecked(false);
		LastSeenTbl.doNotIgnore = false;
	end
	----- END TAB1 -----
	
	----- START TAB2 -----
	if not LastSeenTbl.tab2.queryEditBox then
		LastSeenTbl.tab2.queryEditBox = CreateFrame("EditBox", "QueryEditBox", LastSeenTbl.tab2, "InputBoxTemplate");
		LastSeenTbl.tab2.queryEditBox:SetPoint("TOP", settingsFrame.title, "BOTTOM", -100, -30);
		LastSeenTbl.tab2.queryEditBox:SetMaxLetters(8);
		LastSeenTbl.tab2.queryEditBox:SetAutoFocus(false);
		LastSeenTbl.tab2.queryEditBox:SetFontObject("GameFontNormal");
		LastSeenTbl.tab2.queryEditBox:SetCursorPosition(3);
		LastSeenTbl.tab2.queryEditBox:SetSize(100, 35);
	end
	
	if not LastSeenTbl.tab2.itemIDLabel then
		LastSeenTbl.tab2.itemIDLabel = LastSeenTbl.tab2:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab2.itemIDLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab2.itemIDLabel:SetPoint("RIGHT", LastSeenTbl.tab2.queryEditBox, 60, 0);
		LastSeenTbl.tab2.itemIDLabel:SetFont("Fonts\\Arial.ttf", 8);
		LastSeenTbl.tab2.itemIDLabel:SetJustifyH("LEFT");
		LastSeenTbl.tab2.itemIDLabel:SetText(L["ITEM_ID_LABEL"]);
	end
	
	if not LastSeenTbl.tab2.characterEditBox then
		LastSeenTbl.tab2.characterEditBox = CreateFrame("EditBox", "CharacterEditBox", LastSeenTbl.tab2, "InputBoxTemplate");
		LastSeenTbl.tab2.characterEditBox:SetPoint("TOP", LastSeenTbl.tab2.queryEditBox, "BOTTOM", 0, -20);
		LastSeenTbl.tab2.characterEditBox:SetMaxLetters(12);
		LastSeenTbl.tab2.characterEditBox:SetAutoFocus(false);
		LastSeenTbl.tab2.characterEditBox:SetFontObject("GameFontNormal");
		LastSeenTbl.tab2.characterEditBox:SetCursorPosition(3);
		LastSeenTbl.tab2.characterEditBox:SetSize(100, 35);
	end
	
	if not LastSeenTbl.tab2.characterNameLabel then
		LastSeenTbl.tab2.characterNameLabel = LastSeenTbl.tab2:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab2.characterNameLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab2.characterNameLabel:SetPoint("RIGHT", LastSeenTbl.tab2.characterEditBox, 115, 0);
		LastSeenTbl.tab2.characterNameLabel:SetFont("Fonts\\Arial.ttf", 8);
		LastSeenTbl.tab2.characterNameLabel:SetJustifyH("LEFT");
		LastSeenTbl.tab2.characterNameLabel:SetText(L["CHARACTER_NAME_LABEL"]);
	end
	
	if not LastSeenTbl.tab2.realmNameEditBox then
		LastSeenTbl.tab2.realmNameEditBox = CreateFrame("EditBox", "RealmEditBox", LastSeenTbl.tab2, "InputBoxTemplate");
		LastSeenTbl.tab2.realmNameEditBox:SetPoint("TOP", LastSeenTbl.tab2.characterEditBox, "BOTTOM", 10, -20);
		LastSeenTbl.tab2.realmNameEditBox:SetMaxLetters(18);
		LastSeenTbl.tab2.realmNameEditBox:SetAutoFocus(false);
		LastSeenTbl.tab2.realmNameEditBox:SetFontObject("GameFontNormal");
		LastSeenTbl.tab2.realmNameEditBox:SetCursorPosition(3);
		LastSeenTbl.tab2.realmNameEditBox:SetSize(120, 35);
	end
	
	if not LastSeenTbl.tab2.realmNameLabel then
		LastSeenTbl.tab2.realmNameLabel = LastSeenTbl.tab2:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab2.realmNameLabel:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab2.realmNameLabel:SetPoint("RIGHT", LastSeenTbl.tab2.realmNameEditBox, 90, 0);
		LastSeenTbl.tab2.realmNameLabel:SetFont("Fonts\\Arial.ttf", 8);
		LastSeenTbl.tab2.realmNameLabel:SetJustifyH("LEFT");
		LastSeenTbl.tab2.realmNameLabel:SetText(L["REALM_NAME_LABEL"]);
	end
	
	if not LastSeenTbl.tab2.sendButton then
		LastSeenTbl.tab2.sendButton = CreateFrame("Button", "LastSeenSendButton", LastSeenTbl.tab2, "GameMenuButtonTemplate");
		LastSeenTbl.tab2.sendButton:SetPoint("CENTER", settingsFrame.title, "TOP", -35, -360);
		LastSeenTbl.tab2.sendButton:SetSize(70, 20);
		LastSeenTbl.tab2.sendButton:SetText(L["SEND_BUTTON_LABEL"]);
		LastSeenTbl.tab2.sendButton:SetNormalFontObject("GameFontNormal");
		LastSeenTbl.tab2.sendButton:SetHighlightFontObject("GameFontHighlight");
	end
	
	LastSeenTbl.tab2.sendButton:SetScript("OnClick", function(self, event, arg1)
		local itemIDText = LastSeenTbl.tab2.queryEditBox:GetText();
		local characterName = LastSeenTbl.tab2.characterEditBox:GetText();
		local realmName = LastSeenTbl.tab2.realmNameEditBox:GetText();
		if (itemIDText == "" or characterName == "") then
			print(L["ADDON_NAME"] .. L["GENERAL_FAILURE"]);
		else
			itemIDText = tonumber(itemIDText);
			for k, v in pairs(LastSeenItemsDB) do
				if (itemIDText == k) then
					StaticPopupDialogs["DO_YOU_WANT_TO_SEND"] = {
						text = "Are you sure you want to send to " .. characterName .. "?",
						button1 = "Yes",
						button2 = "No",
						OnAccept = function()
							if realmName == "" then
								SendChatMessage(v.itemLink .. " last seen on " .. v.lootDate .. " from " ..
								v.source .. " in " .. v.location .. "! (Generated by " .. lastSeen .. ")", "WHISPER", nil, characterName);
							else
								SendChatMessage(v.itemLink .. " last seen on " .. v.lootDate .. " from " ..
								v.source .. " in " .. v.location .. "! (Generated by " .. lastSeen .. ")", "WHISPER", nil, characterName .. "-" .. realmName);
							end
						end,
						timeout = 0,
						whileDead = true,
						hideOnEscape = true,
						preferredIndex = 3,
					};
					StaticPopup_Show("DO_YOU_WANT_TO_SEND");
				end
			end
		end
	end);
	
	if not LastSeenTbl.tab2.clearButton then
		LastSeenTbl.tab2.clearButton = CreateFrame("Button", "LastSeenClearButton", LastSeenTbl.tab2, "GameMenuButtonTemplate");
		LastSeenTbl.tab2.clearButton:SetPoint("CENTER", settingsFrame.title, "TOP", 35, -360);
		LastSeenTbl.tab2.clearButton:SetSize(70, 20);
		LastSeenTbl.tab2.clearButton:SetText(L["CLEAR_BUTTON_LABEL"]);
		LastSeenTbl.tab2.clearButton:SetNormalFontObject("GameFontNormal");
		LastSeenTbl.tab2.clearButton:SetHighlightFontObject("GameFontHighlight");
	end
	
	LastSeenTbl.tab2.clearButton:SetScript("OnClick", function(self, event, arg1)
		LastSeenTbl.tab2.queryEditBox:SetText(""); LastSeenTbl.tab2.characterEditBox:SetText(""); LastSeenTbl.tab2.realmNameEditBox:SetText("");
	end);
	----- END TAB2 -----
	
	----- START TAB3 -----
	if not LastSeenTbl.tab3.ackLabel1 then
		LastSeenTbl.tab3.ackLabel1 = LastSeenTbl.tab3:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab3.ackLabel1:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab3.ackLabel1:SetPoint("TOP", settingsFrame.title, "BOTTOM", 0, -10);
		LastSeenTbl.tab3.ackLabel1:SetFont("Fonts\\Arial.ttf", 8);
		LastSeenTbl.tab3.ackLabel1:SetJustifyH("LEFT");
		LastSeenTbl.tab3.ackLabel1:SetText(L["VANDIEL"]);
	end
	
	if not LastSeenTbl.tab2.ackLabel2 then
		LastSeenTbl.tab3.ackLabel2 = LastSeenTbl.tab3:CreateFontString(nil, "OVERLAY");
		LastSeenTbl.tab3.ackLabel2:SetFontObject("GameFontHighlight");
		LastSeenTbl.tab3.ackLabel2:SetPoint("TOP", LastSeenTbl.tab3.ackLabel1, "BOTTOM", 1, -10);
		LastSeenTbl.tab3.ackLabel2:SetFont("Fonts\\Arial.ttf", 8);
		LastSeenTbl.tab3.ackLabel2:SetJustifyH("LEFT");
		LastSeenTbl.tab3.ackLabel2:SetText(L["CRIEVE"]);
	end
	----- END TAB3 -----

	areOptionsOpen = true;

	settingsFrame.CloseButton:SetScript("OnClick", function(self)
		SettingsMenu_OnClose();
	end);
	
	settingsFrame:Show(); LastSeenTbl.tab1:Show();
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN);
end

LastSeenTbl.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenSettingsCacheDB = {mode = GetOptions("mode"), rarity = GetOptions("rarity"), doNotPlayRareSound = GetOptions("doNotPlayRareSound"), doNotIgnore = GetOptions("doNotIgnore"), 
		lootControl = GetOptions("lootControl"), rareSoundID = GetOptions("rareSoundID")};
	else
		if areOptionsOpen then
			SettingsMenu_OnClose();
		else
			SettingsMenu_OnShow();
		end
	end
end
----- END SETTINGS -----