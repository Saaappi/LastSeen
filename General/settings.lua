--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Houses the skeleton of the system that controls the addon's settings.
]]--

local lastSeen, lastSeenNS = ...;

-- High-level Variables
local settingsFrame = CreateFrame("Frame", "lastSeenSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
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
	if arg == "doNotIgnore" then
		if LastSeenSettingsCacheDB.doNotIgnore then
			lastSeenNS.doNotIgnore = LastSeenSettingsCacheDB.doNotIgnore;
			return LastSeenSettingsCacheDB.doNotIgnore;
		else
			LastSeenSettingsCacheDB.doNotIgnore = false;
			lastSeenNS.doNotIgnore = LastSeenSettingsCacheDB.doNotIgnore;
			return LastSeenSettingsCacheDB.doNotIgnore;
		end
	elseif arg == "doNotPlayRareSound" then
		if LastSeenSettingsCacheDB.doNotPlayRareSound then
			lastSeenNS.doNotPlayRareSound = LastSeenSettingsCacheDB.doNotPlayRareSound;
			return LastSeenSettingsCacheDB.doNotPlayRareSound;
		else
			LastSeenSettingsCacheDB.doNotPlayRareSound = false;
			lastSeenNS.doNotPlayRareSound = LastSeenSettingsCacheDB.doNotPlayRareSound;
			return LastSeenSettingsCacheDB.doNotPlayRareSound;
		end
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
	UIDropDownMenu_SetText(settingsFrame.modeDropDown, arg1);
end

local function RarityDropDownMenu_OnClick(self, arg1, arg2)
	LastSeenSettingsCacheDB.rarity = arg1;
	UIDropDownMenu_SetText(settingsFrame.rarityDropDown, arg2);
end

lastSeenNS.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenSettingsCacheDB = {mode = GetMode(), rarity = GetRarity(), doNotPlayRareSound = GetOptions("doNotPlayRareSound"), doNotIgnore = GetOptions("doNotIgnore")};
	else
		if areOptionsOpen then
			settingsFrame:Hide();
			settingsFrame:SetParent(nil);
			areOptionsOpen = false;
		else
			-- Creating the frame and providing its attributes
			if settingsFrame:GetParent() == nil then -- The frame was previously closed - now it's time to reconstruct it.
				settingsFrame = CreateFrame("Frame", "lastSeenSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
			end

			-- General frame settings
			settingsFrame:SetMovable(true);
			settingsFrame:EnableMouse(true);
			settingsFrame:RegisterForDrag("LeftButton");
			settingsFrame:SetScript("OnDragStart", settingsFrame.StartMoving)
			settingsFrame:SetScript("OnDragStop", settingsFrame.StopMovingOrSizing)
			settingsFrame:SetSize(400, 400);
			settingsFrame:SetPoint("CENTER", UIParent, "CENTER");

			-- Children frames and regions
			settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY");
			settingsFrame.title:SetFontObject("GameFontHighlight");
			settingsFrame.title:SetPoint("CENTER", settingsFrame.TitleBg, "CENTER", 5, 0);
			settingsFrame.title:SetText(L["ADDON_NAME_SETTINGS"]);

			settingsFrame.versionLabel = settingsFrame:CreateFontString(nil, "OVERLAY");
			settingsFrame.versionLabel:SetFontObject("GameFontHighlight");
			settingsFrame.versionLabel:SetPoint("TOPRIGHT", settingsFrame, -16, -32);
			settingsFrame.versionLabel:SetFont("Fonts\\Arial.ttf", 8);
			settingsFrame.versionLabel:SetText(L["RELEASE"]);

			settingsFrame.releaseDateLabel = settingsFrame:CreateFontString(nil, "OVERLAY");
			settingsFrame.releaseDateLabel:SetFontObject("GameFontHighlight");
			settingsFrame.releaseDateLabel:SetPoint("TOPRIGHT", settingsFrame, -16, -48);
			settingsFrame.releaseDateLabel:SetFont("Fonts\\Arial.ttf", 8);
			settingsFrame.releaseDateLabel:SetText("23.07.2019");

			settingsFrame.itemsSeenLabel = settingsFrame:CreateFontString(nil, "OVERLAY");
			settingsFrame.itemsSeenLabel:SetFontObject("GameFontHighlight");
			settingsFrame.itemsSeenLabel:SetPoint("TOPLEFT", settingsFrame, 16, -32);
			settingsFrame.itemsSeenLabel:SetFont("Fonts\\Arial.ttf", 8);
			settingsFrame.itemsSeenLabel:SetText(L["ITEMS_SEEN"] .. lastSeenNS.GetItemsSeen(LastSeenItemsDB));

			settingsFrame.modeLabel = settingsFrame:CreateFontString(nil, "OVERLAY");
			settingsFrame.modeLabel:SetFontObject("GameFontHighlight");
			settingsFrame.modeLabel:SetPoint("TOPLEFT", settingsFrame, 16, -72);
			settingsFrame.modeLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
			settingsFrame.modeLabel:SetText(L["MODE"]);

			settingsFrame.modeDropDown = CreateFrame("Frame", "lastSeenModeDropDown", settingsFrame, "UIDropDownMenuTemplate");
			settingsFrame.modeDropDown:SetPoint("TOPLEFT", settingsFrame, 0, -93);
			settingsFrame.modeDropDown:SetSize(175, 30);
			settingsFrame.modeDropDown.initialize = function(self, level)
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

			if LastSeenSettingsCacheDB.mode then
				UIDropDownMenu_SetText(settingsFrame.modeDropDown, LastSeenSettingsCacheDB.mode);
			end

			settingsFrame.rarityLabel = settingsFrame:CreateFontString(nil, "OVERLAY");
			settingsFrame.rarityLabel:SetFontObject("GameFontHighlight");
			settingsFrame.rarityLabel:SetPoint("TOPLEFT", settingsFrame, 16, -137);
			settingsFrame.rarityLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
			settingsFrame.rarityLabel:SetText(L["RARITY"]);

			settingsFrame.rarityDropDown = CreateFrame("Frame", nil, settingsFrame, "UIDropDownMenuTemplate");
			settingsFrame.rarityDropDown:SetPoint("TOPLEFT", settingsFrame, 0, -158);
			settingsFrame.rarityDropDown:SetSize(175, 30);
			settingsFrame.rarityDropDown.initialize = function(self, level)

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

			if rarityConversionTable[LastSeenSettingsCacheDB.rarity] then
				UIDropDownMenu_SetText(settingsFrame.rarityDropDown, rarityConversionTable[LastSeenSettingsCacheDB.rarity]);
			end

			settingsFrame.optionsLabel = settingsFrame:CreateFontString(nil, "OVERLAY");
			settingsFrame.optionsLabel:SetFontObject("GameFontHighlight");
			settingsFrame.optionsLabel:SetPoint("TOPRIGHT", settingsFrame, -16, -72);
			settingsFrame.optionsLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
			settingsFrame.optionsLabel:SetText(L["OPTIONS_LABEL"]);

			settingsFrame.rareSoundButton = CreateFrame("CheckButton", "DisableRareSoundButton", settingsFrame, "UICheckButtonTemplate");
			settingsFrame.rareSoundButton:SetPoint("TOPRIGHT", settingsFrame, -112, -88);
			settingsFrame.rareSoundButton.text:SetText(L["OPTIONS_DISABLE_RARESOUND"]);
			settingsFrame.rareSoundButton:SetScript("OnClick", function(self, event, arg1)
				if self:GetChecked() then
					lastSeenNS.doNotPlayRareSound = true;
					LastSeenSettingsCacheDB.doNotPlayRareSound = true;
				else
					lastSeenNS.doNotPlayRareSound = false;
					LastSeenSettingsCacheDB.doNotPlayRareSound = false;
				end
			end);
			settingsFrame.rareSoundButton:SetScript("OnEnter", function(self)
				GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
				GameTooltip:SetText(L["OPTIONS_DISABLE_RARESOUND_TEXT"]);
				GameTooltip:Show();
			end);
			settingsFrame.rareSoundButton:SetScript("OnLeave", function(self)
				GameTooltip:Hide();
			end);

			if LastSeenSettingsCacheDB.doNotPlayRareSound then
				settingsFrame.rareSoundButton:SetChecked(true);
				lastSeenNS.doNotPlayRareSound = true;
			else
				settingsFrame.rareSoundButton:SetChecked(false);
				lastSeenNS.doNotPlayRareSound = false;
			end

			settingsFrame.doNotIgnoreButton = CreateFrame("CheckButton", "DisableIgnoresButton", settingsFrame, "UICheckButtonTemplate");
			settingsFrame.doNotIgnoreButton:SetPoint("TOPRIGHT", settingsFrame, -112, -110);
			settingsFrame.doNotIgnoreButton.text:SetText(L["OPTIONS_DISABLE_IGNORES"]);
			settingsFrame.doNotIgnoreButton:SetScript("OnClick", function(self, event, arg1)
				if self:GetChecked() then
					lastSeenNS.doNotIgnore = true;
					LastSeenSettingsCacheDB.doNotIgnore = true;
				else
					lastSeenNS.doNotIgnore = false;
					LastSeenSettingsCacheDB.doNotIgnore = false;
					RemoveIgnoredItems();
				end
			end);
			settingsFrame.doNotIgnoreButton:SetScript("OnEnter", function(self)
				GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
				GameTooltip:SetText(L["OPTIONS_DISABLE_IGNORES_TEXT"]);
				GameTooltip:Show();
			end);
			settingsFrame.doNotIgnoreButton:SetScript("OnLeave", function(self)
				GameTooltip:Hide();
			end);
			
			settingsFrame.modeDropDown:SetScript("OnEnter", function(self)
				GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
				GameTooltip:SetText("|cffffffff" .. L["VERBOSE_MODE"] .. "|r: " .. L["VERBOSE_MODE_DESC"] .. 
				"|cffffffff" .. L["NORMAL_MODE"] .. "|r: " .. L["NORMAL_MODE_DESC"] .. 
				"|cffffffff" .. L["QUIET_MODE"] .. "|r: " .. L["QUIET_MODE_DESC"]);
				GameTooltip:Show();
			end);
			
			settingsFrame.modeDropDown:SetScript("OnLeave", function(self)
				GameTooltip:Hide();
			end);

			if LastSeenSettingsCacheDB.doNotIgnore then
				settingsFrame.doNotIgnoreButton:SetChecked(true);
				lastSeenNS.doNotIgnore = true;
			else
				settingsFrame.doNotIgnoreButton:SetChecked(false);
				lastSeenNS.doNotIgnore = false;
			end

			areOptionsOpen = true;

			settingsFrame.CloseButton:SetScript("OnClick", function(self)
				self:GetParent():Hide();
				self:GetParent():SetParent(nil);
				areOptionsOpen = false;
			end);
		end
	end
end
