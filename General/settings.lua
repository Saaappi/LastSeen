--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: Houses the skeleton of the system that controls the addon's settings.
]]--

local lastSeen, lastSeenNS = ...;

----- START SETTINGS UI -----
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

local function Tab_OnClick(self)
	PanelTemplates_SetTab(self:GetParent(), self:GetID());
	self.content:Show();
end

local function SetTabs(frame, numTabs, ...)
	frame.numTabs = numTabs;
	
	local contents = {};
	local frameName = frame:GetName();
	
	for i = 1, numTabs do
		local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "CharacterFrameTabButtonTemplate");
		tab:SetID(i);
		tab:SetText(select(i, ...));
		tab:SetScript("OnClick", Tab_OnClick);
		
		tab.content = CreateFrame("Frame", nil, settingsFrame);
		tab.content:SetSize(308, 500);
		tab.content:Hide();
		
		table.insert(contents, tab.content);
		
		if (i == 1) then
			tab:SetPoint("TOPLEFT", settingsFrame, "BOTTOMLEFT", 5, 1);
		else
			tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", -14, 0);
		end
	end
	
	Tab_OnClick(_G[frameName.."Tab1"]);
	
	return unpack(contents);
end

local tab1, tab2 = SetTabs(settingsFrame, 2, L["SETTINGS_TAB_GENERAL"], L["SETTINGS_TAB_ACKNOWLEDGMENTS"]);
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
	UIDropDownMenu_SetText(settingsFrame.modeDropDown, arg1);
end

local function RarityDropDownMenu_OnClick(self, arg1, arg2)
	LastSeenSettingsCacheDB.rarity = arg1;
	UIDropDownMenu_SetText(settingsFrame.rarityDropDown, arg2);
end

lastSeenNS.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenSettingsCacheDB = {mode = GetMode(), rarity = GetRarity(), doNotPlayRareSound = GetOptions("doNotPlayRareSound"), doNotIgnore = GetOptions("doNotIgnore"), lootControl = GetOptions("lootControl")};
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

			tab1.versionLabel = tab1:CreateFontString(nil, "OVERLAY");
			tab1.versionLabel:SetFontObject("GameFontHighlight");
			tab1.versionLabel:SetPoint("TOPRIGHT", tab1, -16, -32);
			tab1.versionLabel:SetFont("Fonts\\Arial.ttf", 8);
			tab1.versionLabel:SetText(L["RELEASE"]);

			tab1.releaseDateLabel = tab1:CreateFontString(nil, "OVERLAY");
			tab1.releaseDateLabel:SetFontObject("GameFontHighlight");
			tab1.releaseDateLabel:SetPoint("TOPRIGHT", tab1, -16, -48);
			tab1.releaseDateLabel:SetFont("Fonts\\Arial.ttf", 8);
			tab1.releaseDateLabel:SetText("23.07.2019");

			tab1.itemsSeenLabel = tab1:CreateFontString(nil, "OVERLAY");
			tab1.itemsSeenLabel:SetFontObject("GameFontHighlight");
			tab1.itemsSeenLabel:SetPoint("TOPLEFT", tab1, 16, -32);
			tab1.itemsSeenLabel:SetFont("Fonts\\Arial.ttf", 8);
			tab1.itemsSeenLabel:SetText(L["ITEMS_SEEN"] .. lastSeenNS.GetItemsSeen(LastSeenItemsDB));

			tab1.modeLabel = tab1:CreateFontString(nil, "OVERLAY");
			tab1.modeLabel:SetFontObject("GameFontHighlight");
			tab1.modeLabel:SetPoint("TOPLEFT", tab1, 16, -72);
			tab1.modeLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
			tab1.modeLabel:SetText(L["MODE"]);

			tab1.modeDropDown = CreateFrame("Frame", "lastSeenModeDropDown", tab1, "UIDropDownMenuTemplate");
			tab1.modeDropDown:SetPoint("TOPLEFT", tab1, 0, -93);
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

			if LastSeenSettingsCacheDB.mode then
				UIDropDownMenu_SetText(tab1.modeDropDown, LastSeenSettingsCacheDB.mode);
			end

			tab1.rarityLabel = tab1:CreateFontString(nil, "OVERLAY");
			tab1.rarityLabel:SetFontObject("GameFontHighlight");
			tab1.rarityLabel:SetPoint("TOPLEFT", tab1, 16, -137);
			tab1.rarityLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
			tab1.rarityLabel:SetText(L["RARITY"]);

			tab1.rarityDropDown = CreateFrame("Frame", nil, tab1, "UIDropDownMenuTemplate");
			tab1.rarityDropDown:SetPoint("TOPLEFT", tab1, 0, -158);
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

			if rarityConversionTable[LastSeenSettingsCacheDB.rarity] then
				UIDropDownMenu_SetText(tab1.rarityDropDown, rarityConversionTable[LastSeenSettingsCacheDB.rarity]);
			end

			tab1.optionsLabel = tab1:CreateFontString(nil, "OVERLAY");
			tab1.optionsLabel:SetFontObject("GameFontHighlight");
			tab1.optionsLabel:SetPoint("TOPRIGHT", tab1, -16, -72);
			tab1.optionsLabel:SetFont("Fonts\\FRIZQT__.ttf", 18, "OUTLINE");
			tab1.optionsLabel:SetText(L["OPTIONS_LABEL"]);

			tab1.rareSoundButton = CreateFrame("CheckButton", "DisableRareSoundButton", tab1, "UICheckButtonTemplate");
			tab1.rareSoundButton:SetPoint("TOPRIGHT", tab1, -112, -88);
			tab1.rareSoundButton.text:SetText(L["OPTIONS_DISABLE_RARESOUND"]);
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

			tab1.doNotIgnoreButton = CreateFrame("CheckButton", "DisableIgnoresButton", tab1, "UICheckButtonTemplate");
			tab1.doNotIgnoreButton:SetPoint("TOPRIGHT", tab1, -112, -110);
			tab1.doNotIgnoreButton.text:SetText(L["OPTIONS_DISABLE_IGNORES"]);
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
				tab1.lootControlButton = CreateFrame("CheckButton", "LootControlButton", tab1, "UICheckButtonTemplate");
				tab1.lootControlButton:SetPoint("TOPRIGHT", tab1, -112, -132);
				tab1.lootControlButton.text:SetText(L["OPTIONS_LOOT_CONTROL"]);
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

			areOptionsOpen = true;

			settingsFrame.CloseButton:SetScript("OnClick", function(self)
				self:GetParent():Hide();
				self:GetParent():SetParent(nil);
				areOptionsOpen = false;
			end);
		end
	end
end
----- END SETTINGS -----