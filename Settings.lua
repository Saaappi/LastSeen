local addon, addonTbl = ...;

local function CountItemsSeen(tbl)
	local count = 0;
	for k, v in pairs(tbl) do
		count = count + 1;
	end
	return count;
end

local settingsFrame = CreateFrame("Frame", "LastSeenSettingsFrame", UIParent, "BasicFrameTemplateWithInset");
local L = addonTbl.L;
local SETTINGS = {};
local modeList;
local areOptionsOpen = false;

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
			LastSeenSettingsCacheDB[arg] = true; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
		if arg == "showSources" then
			LastSeenSettingsCacheDB[arg] = false; addonTbl[arg] = LastSeenSettingsCacheDB[arg];
			return addonTbl[arg];
		end
	end
end
-- Synopsis: When the addon is loaded into memory after login, the addon will ask the cache for the last known
-- value of the mode, rarity, and lootFast variables.

local function ModeDropDownMenu_OnClick(self, arg1)
	LastSeenSettingsCacheDB["mode"] = arg1; addonTbl["mode"] = arg1;
	UIDropDownMenu_SetText(settingsFrame.modeDropDown, arg1);
end
-- Synopsis: Changes the value of the mode dropdown to whatever the player selects.

local function SettingsMenu_OnClose()
	settingsFrame:Hide();
	areOptionsOpen = false;
	PlaySound(SOUNDKIT.IG_QUEST_LOG_CLOSE);
end
-- Synopsis: Hide the frame when the player closes it.

local function SettingsMenu_OnShow()
	if settingsFrame then
		settingsFrame:SetMovable(true);
		settingsFrame:EnableMouse(true);
		settingsFrame:RegisterForDrag("LeftButton");
		settingsFrame:SetScript("OnDragStart", settingsFrame.StartMoving);
		settingsFrame:SetScript("OnDragStop", settingsFrame.StopMovingOrSizing);
		settingsFrame:SetSize(200, 125);
		settingsFrame:ClearAllPoints();
		settingsFrame:SetPoint("CENTER", WorldFrame, "CENTER");
	end
	-- Synopsis: Builds the frame itself and allows it to be draggable.
	
	if not settingsFrame.title then
		settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY");
		settingsFrame.title:SetFontObject("GameFontHighlight");
		settingsFrame.title:SetPoint("CENTER", settingsFrame.TitleBg, "CENTER", 5, 0);
		settingsFrame.title:SetText(L["RELEASE"] .. L["ADDON_NAME_SETTINGS"]);
	end
	-- Synopsis: Adds a title to the top of the frame, consisting of the addon's release version and its name.
	
	if not settingsFrame.modeDropDown then
		settingsFrame.modeDropDown = CreateFrame("Frame", "addonModeDropDown", settingsFrame, "UIDropDownMenuTemplate");
		settingsFrame.modeDropDown:SetPoint("CENTER", settingsFrame, "CENTER", 0, 15);
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
	-- Synopsis: These are the mode menu options.
	
	if not settingsFrame.itemCount then
		settingsFrame.itemCount = settingsFrame:CreateFontString(nil, "OVERLAY");
		settingsFrame.itemCount:SetFontObject("GameFontHighlight");
		settingsFrame.itemCount:SetPoint("CENTER", settingsFrame, "CENTER", 0, -10);
		settingsFrame.itemCount:SetText(addonTbl.GetCount(LastSeenItemsDB));
	end
	-- Synopsis: This is a count of how many items the player has seen. It counts from the cached database so
	-- players will need to reload to see items that were just looted.
	
	if not settingsFrame.showSourcesButton then
		settingsFrame.showSourcesButton = CreateFrame("CheckButton", "LastSeenShowSourcesButton", settingsFrame, "UICheckButtonTemplate");
		settingsFrame.showSourcesButton:SetPoint("CENTER", settingsFrame, "CENTER", -60, -35);
		settingsFrame.showSourcesButton.text:SetText("LOL");
	end
	settingsFrame.showSourcesButton:SetScript("OnClick", function(self, event, arg1)
		if self:GetChecked() then
			addonTbl.showSources = true;
			LastSeenSettingsCacheDB.showSources = true;
		else
			addonTbl.showSources = false;
			LastSeenSettingsCacheDB.showSources = false;
		end
	end);
	-- Synopsis: Tells the addon whether or not to show some of the sources an item was seen from.
	
	if LastSeenSettingsCacheDB.showSources then
		settingsFrame.showSourcesButton:SetChecked(true);
		addonTbl.showSources = true;
	else
		settingsFrame.showSourcesButton:SetChecked(false);
		addonTbl.showSources = false;
	end

	if LastSeenSettingsCacheDB.mode then
		UIDropDownMenu_SetText(settingsFrame.modeDropDown, LastSeenSettingsCacheDB.mode);
	end
	-- Synopsis: Sets the value of the mode dropdown to whatever the settings cache holds for that value.
	
	settingsFrame.modeDropDown:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(string.format("|cffffffff%s|r: %s|cffffffff%s|r: %s|cffffffff%s|r: %s", L["DEBUG_MODE"], L["DEBUG_DESC"], L["NORMAL_MODE"], L["NORMAL_DESC"], L["QUIET_MODE"], L["QUIET_DESC"]));
		GameTooltip:Show();
	end);
	
	settingsFrame.modeDropDown:SetScript("OnLeave", function(self)
		if GameTooltip:GetOwner() == self then
			GameTooltip:Hide();
		end
	end);
	-- Synopsis: The above two code blocks are what show and hide the mode descriptions when a player hoves over the dropdown.
	
	settingsFrame.showSourcesButton:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
		GameTooltip:SetText(L["SHOW_SOURCES_DESC"]);
		GameTooltip:Show();
	end);
	
	settingsFrame.showSourcesButton:SetScript("OnLeave", function(self)
		if GameTooltip:GetOwner() == self then
			GameTooltip:Hide();
		end
	end);

	areOptionsOpen = true; -- Let's the addon known that the player is actively looking at the options menu.

	settingsFrame.CloseButton:SetScript("OnClick", function(self)
		SettingsMenu_OnClose();
	end);
	-- Synopsis: If the player clicks the red X in the upper right corner of the frame, then call the SettingsMenu_OnClose()
	-- function so the frame can be properly hidden.
	
	settingsFrame:Show(); settingsFrame:Show(); -- TODO: Test if the second Show() function call is necessary.
	PlaySound(SOUNDKIT.IG_QUEST_LOG_OPEN);
end

addonTbl.LoadSettings = function(doNotOpen)
	if doNotOpen then
		LastSeenSettingsCacheDB = {mode = GetOptions("mode"), rarity = GetOptions("rarity"), lootFast = GetOptions("lootFast"), showSources = GetOptions("showSources")};
	else
		if areOptionsOpen then
			SettingsMenu_OnClose();
		else
			SettingsMenu_OnShow();
		end
	end
end
--[[
	Synopsis: Loads either the settings from the cache or loads the settings frame.
	Use Case(s):
		true: If 'doNotOpen' is true, then the addon made the call so it can load the settings from the cache.
		false: If 'doNotOpen' is false, then the player made the call so the settings menu should be shown (or closed if already open.)
]]