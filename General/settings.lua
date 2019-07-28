--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Houses the skeleton of the system that controls the addon's settings.
]]--

local lastSeen, lastSeenNS = ...;

----- START SETTINGS UI -----
local settingsFrame = CreateFrame("Frame", "lastSeenSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local tab1, tab2;
local L = lastSeenNS.L;
local SETTINGS = {};
local modeList;
local rarityList = UIDropDownMenu_CreateInfo();
local areOptionsOpen = false;
local rarityConversionTable = {
	[0] = L["POOR"],
	[1] = L["COMMON"],
	[2] = L["UNCOMMON"],
	[3] = L["RARE"],
	[4] = L["EPIC"],
	[5] = L["LEGENDARY"],
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
	end
	
	Tab_OnClick(_G[frameName.."Tab1"]); -- This is the default tab selected on open.
	
	return unpack(contents);
end
----- END SETTINGS UI -----

----- START SETTINGS -----
local function RemoveIgnoredItems()
	-- When the player re-enables the ignore checks any previously added ignored items will be purged.
	for k, v in pairs(LastSeenItemsDB) do
		if lastSeenNS.ignoredItems[k] ~= nil or lastSeenNS.ignoredItemTypes[select(2, GetItemInfoInstant(k))] ~= nil then
			LastSeenItemsDB[k] = nil;
		end
	end
end

local function GetMode()
	if LastSeenSettingsCacheDB.mode then
		lastSeenNS.mode = LastSeenSettingsCacheDB.mode;
		return LastSeenSettingsCacheDB.mode;
	else
		LastSeenSettingsCacheDB.mode = L["NORMAL_MODE"];
		lastSeenNS.mode = LastSeenSettingsCacheDB.mode;
		return LastSeenSettingsCacheDB.mode;
	end
end

local function GetRarity()
	if LastSeenSettingsCacheDB.rarity then
		lastSeenNS.rarity = LastSeenSettingsCacheDB.rarity;
		return LastSeenSettingsCacheDB.rarity;
	else
		LastSeenSettingsCacheDB.rarity = 2;
		lastSeenNS.rarity = LastSeenSettingsCacheDB.rarity;
		return LastSeenSettingsCacheDB.rarity;
	end
end

local function GetOptions(arg)
	if LastSeenSettingsCacheDB[arg] then
		lastSeenNS[arg] = LastSeenSettingsCacheDB[arg];
		return LastSeenSettingsCacheDB[arg];
	else
		LastSeenSettingsCacheDB[arg] = false;
		lastSeenNS[arg] = LastSeenSettingsCacheDB[arg];
		return LastSeenSettingsCacheDB[arg];
	end
end

local function CountItemsSeen(tbl)
	local count = 0;
	for k, v in pairs(tbl) do
		count = count + 1;
	end
	return count;
end

local function ModeDropDownMenu_OnClick(self, arg1)
	LastSeenSettingsCacheDB.mode = arg1;
	UIDropDownMenu_SetText(tab1.modeDropDown, arg1);
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
		tab1:SetSize(308, 500); tab2:SetSize(308, 600);
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
		tab1.itemsSeenLabel:SetText(L["ITEMS_SEEN"] .. lastSeenNS.GetItemsSeen(LastSeenItemsDB));
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
		tab1.rarityDropDown:SetPoint("TOP", tab1.rarityLabel, "BOTTOM", 25, -2);
		tab1.rarityDropDown:SetSize(175, 30);
		tab1.rarityDropDown.initialize = function(self, level)

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
			lastSeenNS.doNotPlayRareSound = true;
			LastSeenSettingsCacheDB.doNotPlayRareSound = true;
		else
			lastSeenNS.doNotPlayRareSound = false;
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
		lastSeenNS.doNotPlayRareSound = true;
	else
		tab1.rareSoundButton:SetChecked(false);
		lastSeenNS.doNotPlayRareSound = false;
	end
	
	if not tab1.doNotIgnoreButton then
		tab1.doNotIgnoreButton = CreateFrame("CheckButton", "DisableIgnoresButton", tab1, "UICheckButtonTemplate");
		tab1.doNotIgnoreButton:SetPoint("TOP", tab1.rareSoundButton, "BOTTOM", 0, 5);
		tab1.doNotIgnoreButton.text:SetText(L["OPTIONS_DISABLE_IGNORES"]);
	end
	
	tab1.doNotIgnoreButton:SetScript("OnClick", function(self, event, arg1)
		if self:GetChecked() then
			lastSeenNS.doNotIgnore = true;
			LastSeenSettingsCacheDB.doNotIgnore = true;
		else
			lastSeenNS.doNotIgnore = false;
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
				lastSeenNS.lootControl = true;
				LastSeenSettingsCacheDB.lootControl = true;
			else
				lastSeenNS.lootControl = false;
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
			lastSeenNS.lootControl = true;
		else
			tab1.lootControlButton:SetChecked(false);
			lastSeenNS.lootControl = false;
		end
	else
		lastSeenNS.lootControl = false;
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
		lastSeenNS.doNotIgnore = true;
	else
		tab1.doNotIgnoreButton:SetChecked(false);
		lastSeenNS.doNotIgnore = false;
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

lastSeenNS.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenSettingsCacheDB = {mode = GetMode(), rarity = GetRarity(), doNotPlayRareSound = GetOptions("doNotPlayRareSound"), doNotIgnore = GetOptions("doNotIgnore"), lootControl = GetOptions("lootControl")};
	else
		if areOptionsOpen then
			SettingsMenu_OnClose();
		else
			SettingsMenu_OnShow();
		end
	end
end
----- END SETTINGS -----