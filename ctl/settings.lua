local addon, addonTbl = ...;

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
local settingsFrame = CreateFrame("Frame", "LastSeenSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local L = addonTbl.L;
local SETTINGS = {};
local modeList;
local areOptionsOpen = false;
----- END SETTINGS UI -----

----- START SETTINGS -----
local function RemoveIgnoredItems()
	-- When the player re-enables the ignore checks any previously added ignored items will be purged.
	for k, v in pairs(LastSeenItemsDB) do
		if addonTbl.ignoredItems[k] ~= nil or addonTbl.ignoredItemTypes[select(2, GetItemInfoInstant(k))] ~= nil then
			LastSeenItemsDB[k] = nil;
		end
	end
end

local function GetOptions(arg)
	if LastSeenSettingsCacheDB[arg] ~= nil then
		addonTbl[arg] = LastSeenSettingsCacheDB[arg];
		return addonTbl[arg];
	else
		if arg == "mode" then
			LastSeenSettingsCacheDB[arg] = L["NORMAL_MODE"]; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "rarity" then
			LastSeenSettingsCacheDB[arg] = 2; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "lootFast" then
			print("A");
			LastSeenSettingsCacheDB[arg] = true; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
	end
end

local function ModeDropDownMenu_OnClick(self, arg1)
	LastSeenSettingsCacheDB["mode"] = arg1; addonTbl["mode"] = arg1;
	UIDropDownMenu_SetText(settingsFrame.modeDropDown, arg1);
end

local function SettingsMenu_OnClose()
	settingsFrame:Hide();
	areOptionsOpen = false;
	PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE);
end

local function SettingsMenu_OnShow()
	-- General frame settings
	if settingsFrame then
		settingsFrame:SetMovable(true);
		settingsFrame:EnableMouse(true);
		settingsFrame:RegisterForDrag("LeftButton");
		settingsFrame:SetScript("OnDragStart", settingsFrame.StartMoving);
		settingsFrame:SetScript("OnDragStop", settingsFrame.StopMovingOrSizing);
		settingsFrame:SetSize(200, 100);
		settingsFrame:ClearAllPoints();
		settingsFrame:SetPoint("CENTER", WorldFrame, "CENTER");
	end
	
	if not settingsFrame.title then
		settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY");
		settingsFrame.title:SetFontObject("GameFontHighlight");
		settingsFrame.title:SetPoint("CENTER", settingsFrame.TitleBg, "CENTER", 5, 0);
		settingsFrame.title:SetText(L["RELEASE"] .. L["ADDON_NAME_SETTINGS"]);
	end
	
	----- START settingsFrame -----
	if not settingsFrame.modeDropDown then
		settingsFrame.modeDropDown = CreateFrame("Frame", "addonModeDropDown", settingsFrame, "UIDropDownMenuTemplate");
		settingsFrame.modeDropDown:SetPoint("CENTER", settingsFrame, "CENTER");
		settingsFrame.modeDropDown:SetSize(175, 30);
		settingsFrame.modeDropDown.initialize = function(self, level)
			modeList = UIDropDownMenu_CreateInfo();

			modeList.text = L["DEBUG_MODE"];
			modeList.func = ModeDropDownMenu_OnClick;
			modeList.arg1 = L["DEBUG_MODE"];
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
	
	if not settingsFrame.itemCount then
		settingsFrame.itemCount = settingsFrame:CreateFontString(nil, "OVERLAY");
		settingsFrame.itemCount:SetFontObject("GameFontHighlight");
		settingsFrame.itemCount:SetPoint("CENTER", settingsFrame, "CENTER", 0, -25);
		settingsFrame.itemCount:SetText(addonTbl.GetItemsSeen(LastSeenItemsDB));
	end

	if LastSeenSettingsCacheDB.mode then
		UIDropDownMenu_SetText(settingsFrame.modeDropDown, LastSeenSettingsCacheDB.mode);
	end
	
	settingsFrame.modeDropDown:SetScript("OnEnter", function(self)
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		GameTooltip:SetText("|cffffffff" .. L["DEBUG_MODE"] .. "|r: " .. L["DEBUG_MODE_DESC"] .. 
		"|cffffffff" .. L["NORMAL_MODE"] .. "|r: " .. L["NORMAL_MODE_DESC"] .. 
		"|cffffffff" .. L["QUIET_MODE"] .. "|r: " .. L["QUIET_MODE_DESC"]);
		GameTooltip:Show();
	end);
	
	settingsFrame.modeDropDown:SetScript("OnLeave", function(self)
		GameTooltip:Hide();
	end);
	
	----- END settingsFrame -----

	areOptionsOpen = true;

	settingsFrame.CloseButton:SetScript("OnClick", function(self)
		SettingsMenu_OnClose();
	end);
	
	settingsFrame:Show(); settingsFrame:Show();
	PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);
end

addonTbl.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenSettingsCacheDB = {mode = GetOptions("mode"), rarity = GetOptions("rarity"), lootFast = GetOptions("lootFast")};
	else
		if areOptionsOpen then
			SettingsMenu_OnClose();
		else
			SettingsMenu_OnShow();
		end
	end
end
----- END SETTINGS -----