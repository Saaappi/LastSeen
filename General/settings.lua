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
local tab1, tab2;
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
		if tab2 then
			tab2:Hide();
		end
	elseif (self:GetID() == 2) then
		if tab1 then
			tab1:Hide();
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
	
	Tab_OnClick(_G[frameName.."Tab1"]); -- This is the default tab selected on open.
	
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
		end
	end
end

local function ModeDropDownMenu_OnClick(self, arg1)
	LastSeenSettingsCacheDB.mode = arg1;
	UIDropDownMenu_SetText(tab1.modeDropDown, arg1);
end

local function RareSoundIDDropDownMenu_OnClick(self, arg1, arg2)
	LastSeenSettingsCacheDB.rareSoundID = arg1;
	UIDropDownMenu_SetText(tab1.rareSoundIDDropDown, arg2);
	PlaySoundFile(arg1);
end

local function RarityDropDownMenu_OnClick(self, arg1, arg2)
	LastSeenSettingsCacheDB.rarity = arg1;
	UIDropDownMenu_SetText(tab1.rarityDropDown, arg2);
end

local function SettingsMenu_OnClose()
	settingsFrame:Hide(); tab1:Hide(); tab2:Hide();
	areOptionsOpen = false;
	PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE);
end

local function SettingsMenu_OnShow()
	if not tab1 or not tab2 then
		tab1, tab2 = Tab_SetTab(settingsFrame, 2, L["SETTINGS_TAB_GENERAL"], L["SETTINGS_TAB_ACKNOWLEDGMENTS"]);
		tab1:SetSize(308, 500); tab2:SetSize(600, 500);
	end
	
	-- General frame settings
	settingsFrame:SetMovable(true);
	settingsFrame:EnableMouse(true);
	settingsFrame:RegisterForDrag("LeftButton");
	settingsFrame:SetScript("OnDragStart", settingsFrame.StartMoving)
	settingsFrame:SetScript("OnDragStop", settingsFrame.StopMovingOrSizing)
	settingsFrame:SetSize(400, 400);
	settingsFrame:SetPoint("CENTER", UIParent, "CENTER");
	
	if not settingsFrame.title then
		settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY");
		settingsFrame.title:SetFontObject("GameFontHighlight");
		settingsFrame.title:SetPoint("CENTER", settingsFrame.TitleBg, "CENTER", 5, 0);
		settingsFrame.title:SetText(L["ADDON_NAME_SETTINGS"]);
	end
	
	if not tab1.itemsSeenLabel then
		tab1.itemsSeenLabel = tab1:CreateFontString(nil, "OVERLAY");
		tab1.itemsSeenLabel:SetFontObject("GameFontHighlight");
		tab1.itemsSeenLabel:SetPoint("TOP", settingsFrame.title, "BOTTOM", -125, -15);
		tab1.itemsSeenLabel:SetFont("Fonts\\Arial.ttf", 8);
		tab1.itemsSeenLabel:SetText(L["ITEMS_SEEN"] .. LastSeenTbl.GetItemsSeen(LastSeenItemsDB));
	end
	
	if not tab1.versionLabel then
		tab1.versionLabel = tab1:CreateFontString(nil, "OVERLAY");
		tab1.versionLabel:SetFontObject("GameFontHighlight");
		tab1.versionLabel:SetPoint("TOPRIGHT", tab1.itemsSeenLabel, 265, 0);
		tab1.versionLabel:SetFont("Fonts\\Arial.ttf", 8);
		tab1.versionLabel:SetText(L["RELEASE"]);
	end

	if not tab1.releaseDateLabel then
		tab1.releaseDateLabel = tab1:CreateFontString(nil, "OVERLAY");
		tab1.releaseDateLabel:SetFontObject("GameFontHighlight");
		tab1.releaseDateLabel:SetPoint("TOP", tab1.versionLabel, "BOTTOM", -15, -5);
		tab1.releaseDateLabel:SetFont("Fonts\\Arial.ttf", 8);
		tab1.releaseDateLabel:SetText("23.07.2019");
	end

	if not tab1.modeLabel then
		tab1.modeLabel = tab1:CreateFontString(nil, "OVERLAY");
		tab1.modeLabel:SetFontObject("GameFontHighlight");
		tab1.modeLabel:SetPoint("TOP", tab1.itemsSeenLabel, "BOTTOM", 0, -30);
		tab1.modeLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
		tab1.modeLabel:SetText(L["MODE"]);
	end
	
	if not tab1.modeDropDown then
		tab1.modeDropDown = CreateFrame("Frame", "lastSeenModeDropDown", tab1, "UIDropDownMenuTemplate");
		tab1.modeDropDown:SetPoint("TOP", tab1.modeLabel, "BOTTOM", 25, -2);
		tab1.modeDropDown:SetSize(175, 30);
		tab1.modeDropDown.initialize = function(self, level)
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
		UIDropDownMenu_SetText(tab1.modeDropDown, LastSeenSettingsCacheDB.mode);
	end

	if not tab1.rarityLabel then
		tab1.rarityLabel = tab1:CreateFontString(nil, "OVERLAY");
		tab1.rarityLabel:SetFontObject("GameFontHighlight");
		tab1.rarityLabel:SetPoint("TOP", tab1.modeLabel, "BOTTOM", 0, -40);
		tab1.rarityLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
		tab1.rarityLabel:SetText(L["RARITY"]);
	end

	if not tab1.rarityDropDown then
		tab1.rarityDropDown = CreateFrame("Frame", nil, tab1, "UIDropDownMenuTemplate");
		tab1.rarityDropDown:SetPoint("TOP", tab1.modeDropDown, "BOTTOM", 0, -30);
		tab1.rarityDropDown:SetSize(175, 30);
		tab1.rarityDropDown.initialize = function(self, level)
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
		UIDropDownMenu_SetText(tab1.rarityDropDown, rarityConversionTable[LastSeenSettingsCacheDB.rarity]);
	end
	
	if not tab1.rareSoundIDLabel then
		tab1.rareSoundIDLabel = tab1:CreateFontString(nil, "OVERLAY");
		tab1.rareSoundIDLabel:SetFontObject("GameFontHighlight");
		tab1.rareSoundIDLabel:SetPoint("TOP", tab1.rarityLabel, "BOTTOM", 25, -40);
		tab1.rareSoundIDLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
		tab1.rareSoundIDLabel:SetText(L["RARE_SOUND"]);
	end
	
	if not tab1.rareSoundIDDropDown then
		tab1.rareSoundIDDropDown = CreateFrame("Frame", nil, tab1, "UIDropDownMenuTemplate");
		tab1.rareSoundIDDropDown:SetPoint("TOP", tab1.rarityDropDown, "BOTTOM", 0, -30);
		tab1.rareSoundIDDropDown:SetSize(175, 30);
		tab1.rareSoundIDDropDown.initialize = function(self, level)
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
		UIDropDownMenu_SetText(tab1.rareSoundIDDropDown, rareSoundIDConversionTable[LastSeenSettingsCacheDB.rareSoundID]);
	end

	if not tab1.optionsLabel then
		tab1.optionsLabel = tab1:CreateFontString(nil, "OVERLAY");
		tab1.optionsLabel:SetFontObject("GameFontHighlight");
		tab1.optionsLabel:SetPoint("TOP", tab1.modeLabel, 282, 0);
		tab1.optionsLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
		tab1.optionsLabel:SetText(L["OPTIONS_LABEL"]);
	end

	if not tab1.rareSoundButton then
		tab1.rareSoundButton = CreateFrame("CheckButton", "DisableRareSoundButton", tab1, "UICheckButtonTemplate");
		tab1.rareSoundButton:SetPoint("TOP", tab1.optionsLabel, "BOTTOM", -75, -2);
		tab1.rareSoundButton.text:SetText(L["OPTIONS_DISABLE_RARESOUND"]);
	end
	
	tab1.rareSoundButton:SetScript("OnClick", function(self, event, arg1)
		if self:GetChecked() then
			LastSeenTbl.doNotPlayRareSound = true;
			LastSeenSettingsCacheDB.doNotPlayRareSound = true;
		else
			LastSeenTbl.doNotPlayRareSound = false;
			LastSeenSettingsCacheDB.doNotPlayRareSound = false;
		end
	end);
	
	tab1.rareSoundButton:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetText(L["OPTIONS_DISABLE_RARESOUND_TEXT"]);
		GameTooltip:Show();
	end);
	
	tab1.rareSoundButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);

	if LastSeenSettingsCacheDB.doNotPlayRareSound then
		tab1.rareSoundButton:SetChecked(true);
		LastSeenTbl.doNotPlayRareSound = true;
	else
		tab1.rareSoundButton:SetChecked(false);
		LastSeenTbl.doNotPlayRareSound = false;
	end
	
	if not tab1.doNotIgnoreButton then
		tab1.doNotIgnoreButton = CreateFrame("CheckButton", "DisableIgnoresButton", tab1, "UICheckButtonTemplate");
		tab1.doNotIgnoreButton:SetPoint("TOP", tab1.rareSoundButton, "BOTTOM", 0, 5);
		tab1.doNotIgnoreButton.text:SetText(L["OPTIONS_DISABLE_IGNORES"]);
	end
	
	tab1.doNotIgnoreButton:SetScript("OnClick", function(self, event, arg1)
		if self:GetChecked() then
			LastSeenTbl.doNotIgnore = true;
			LastSeenSettingsCacheDB.doNotIgnore = true;
		else
			LastSeenTbl.doNotIgnore = false;
			LastSeenSettingsCacheDB.doNotIgnore = false;
			RemoveIgnoredItems();
		end
	end);
	
	tab1.doNotIgnoreButton:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetText(L["OPTIONS_DISABLE_IGNORES_TEXT"]);
		GameTooltip:Show();
	end);
	
	tab1.doNotIgnoreButton:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);
	
	if GetCVar("autoLootDefault") == "0" then
		if not tab1.lootControlButton then
			tab1.lootControlButton = CreateFrame("CheckButton", "LootControlButton", tab1, "UICheckButtonTemplate");
			tab1.lootControlButton:SetPoint("TOP", tab1.doNotIgnoreButton, "BOTTOM", 0, 5);
			tab1.lootControlButton.text:SetText(L["OPTIONS_LOOT_CONTROL"]);
		end
		
		tab1.lootControlButton:SetScript("OnClick", function(self, event, arg1)
			if self:GetChecked() then
				LastSeenTbl.lootControl = true;
				LastSeenSettingsCacheDB.lootControl = true;
			else
				LastSeenTbl.lootControl = false;
				LastSeenSettingsCacheDB.lootControl = false;
			end
		end);
		
		tab1.lootControlButton:SetScript("OnEnter", function(self)
			GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
			GameTooltip:SetText(L["OPTIONS_LOOT_CONTROL_TEXT"]);
			GameTooltip:Show();
		end);
		
		tab1.lootControlButton:SetScript("OnLeave", function(self)
			GameTooltip:Hide();
		end);

		if LastSeenSettingsCacheDB.lootControl then
			tab1.lootControlButton:SetChecked(true);
			LastSeenTbl.lootControl = true;
		else
			tab1.lootControlButton:SetChecked(false);
			LastSeenTbl.lootControl = false;
		end
	else
		LastSeenTbl.lootControl = false;
		LastSeenSettingsCacheDB.lootControl = false;
	end
	
	tab1.modeDropDown:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetText("|cffffffff" .. L["VERBOSE_MODE"] .. "|r: " .. L["VERBOSE_MODE_DESC"] .. 
		"|cffffffff" .. L["NORMAL_MODE"] .. "|r: " .. L["NORMAL_MODE_DESC"] .. 
		"|cffffffff" .. L["QUIET_MODE"] .. "|r: " .. L["QUIET_MODE_DESC"]);
		GameTooltip:Show();
	end);
	
	tab1.modeDropDown:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);

	if LastSeenSettingsCacheDB.doNotIgnore then
		tab1.doNotIgnoreButton:SetChecked(true);
		LastSeenTbl.doNotIgnore = true;
	else
		tab1.doNotIgnoreButton:SetChecked(false);
		LastSeenTbl.doNotIgnore = false;
	end
	
	if not tab2.ackLabel1 then
		tab2.ackLabel1 = tab2:CreateFontString(nil, "OVERLAY");
		tab2.ackLabel1:SetFontObject("GameFontHighlight");
		tab2.ackLabel1:SetPoint("TOP", settingsFrame.title, "BOTTOM", 0, -10);
		tab2.ackLabel1:SetFont("Fonts\\Arial.ttf", 8);
		tab2.ackLabel1:SetJustifyH("LEFT");
		tab2.ackLabel1:SetText(L["VANDIEL"]);
	end
	
	if not tab2.ackLabel2 then
		tab2.ackLabel2 = tab2:CreateFontString(nil, "OVERLAY");
		tab2.ackLabel2:SetFontObject("GameFontHighlight");
		tab2.ackLabel2:SetPoint("TOP", tab2.ackLabel1, "BOTTOM", 1, -10);
		tab2.ackLabel2:SetFont("Fonts\\Arial.ttf", 8);
		tab2.ackLabel2:SetJustifyH("LEFT");
		tab2.ackLabel2:SetText(L["CRIEVE"]);
	end

	areOptionsOpen = true;

	settingsFrame.CloseButton:SetScript("OnClick", function(self)
		SettingsMenu_OnClose();
	end);
	
	settingsFrame:Show(); tab1:Show();
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