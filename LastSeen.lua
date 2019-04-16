-------------------------------------------------------
-- LastSeen | Oxlotus - Area 52 (US) | Copyright © 2019
-------------------------------------------------------

local addonName, addonTable = ...;

-- Highest-level Variables
local itemLooted = "";
local currentMap = "";
local wasUpdated = false;

-- Local function variables
local find = string.find;
local gsub = string.gsub;
local lower = string.lower;
local match = string.match;

-- AddOn Variables
local eventFrame = CreateFrame("Frame");
local date = date("%m/%d/%y");

-- Table Variables
local T = addonTable.LastSeenItems;
local IGNORE = addonTable.LastSeenIgnore;
local ITEMIDCACHE = addonTable.LastSeenItemIDCache;
local L = addonTable.L;

eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
eventFrame:RegisterEvent("CHAT_MSG_LOOT");
eventFrame:RegisterEvent("PLAYER_LOGIN");
eventFrame:RegisterEvent("PLAYER_LOGOUT");

local function Add(itemID)
	local itemID = tonumber(itemID);
	if T[itemID] then
		print(addonName .. ": That item is already in the database!");
	else
		T[itemID] = {itemName = "", lootDate = ""};
		print(addonName .. ": Added a new record for " .. itemID .. ".");
	end
end

local function Ignore(itemID)
	local itemID = tonumber(itemID);
	if itemID == nil then
		IGNORE = {};
	elseif IGNORE[itemID] then
		IGNORE[itemID].ignore = not IGNORE[itemID].ignore;
	else
		IGNORE[itemID] = {ignore = true};
		return (addonName .. ": Added " .. itemID .. " to the ignore list.");
	end
end

local function Remove(itemID)
	local itemID = tonumber(itemID);
	if itemID == nil then
		T = {};
	elseif T[itemID] then
		T[itemID] = nil;
	else
		return Report(0, 0);
	end
end

local function Report(reportType, itemID)
	if reportType == 0 then -- No results
		print(addonName .. ": No items found.");
	elseif reportType == 1 then -- Search query
		print(v.itemName .. " (" .. k .. ") - " .. v.lootDate .. " - " .. v.location);
	elseif reportType == 2 then -- Updated record
		print(addonName .. ": Updated the record for " .. select(2, GetItemInfo(ITEMIDCACHE[itemID].itemID)) .. ".");
	elseif reportType == 3 then -- New record
		print(addonName .. ": Added a new record for " .. select(2, GetItemInfo(ITEMIDCACHE[itemID].itemID)) .. ".");
	end
end

local function Search(query)
	if tonumber(query) == nil then
		local itemsFound = 0;
		for k, v in pairs(T) do
			if find(lower(v.itemName), lower(query)) then
				Report(1, 0);
				itemsFound = itemsFound + 1;
			end
		end
	else
		local query = tonumber(query);
		if T[query] then
			print(T[query].itemName .. " (" .. query .. ") - " .. T[query].lootDate .. " - " .. T[query].location);
		else
			Report(0, 0);
		end
	end
	
	if itemsFound == 0 then
		Report(0, 0);
	end
end

local function AddLoot(chatMsg, unitName)
	if not chatMsg then return end;
	
	if match(chatMsg, L["LOOT_ITEM_PUSHED_SELF"]) then
		itemLooted = select(3, find(chatMsg, gsub(gsub(LOOT_ITEM_PUSHED_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	elseif match(chatMsg, L["LOOT_ITEM_SELF"]) then
		itemLooted = select(3, find(chatMsg, gsub(gsub(LOOT_ITEM_SELF, "%%s", "(.+)"), "%%d", "(.+)")));
	else
		itemLooted = match(chatMsg, "[%+%p%s](.*)[%s%p%+]");
	end
	
	if not itemLooted then return end;
	
	local mode = LastSeenSettingsCacheDB.mode;
	local rarity = LastSeenSettingsCacheDB.rarity;
	local itemID = select(1, GetItemInfoInstant(itemLooted));
	if not ITEMIDCACHE[itemID] then
		local itemName = select(1, GetItemInfo(itemID));
		local itemRarity = select(3, GetItemInfo(itemID));
		local itemType = select(6, GetItemInfo(itemID));
		ITEMIDCACHE[itemID] = {itemID = itemID, itemName = itemName, itemRarity = itemRarity, itemType = itemType};
	end
	
	if ITEMIDCACHE[itemID].itemRarity >= rarity and ITEMIDCACHE[itemID].itemType ~= L["tradeskill"] and not IGNORE[ITEMIDCACHE[itemID]] then
		if T[ITEMIDCACHE[itemID].itemID] then
			if T[ITEMIDCACHE[itemID].itemID].itemName == "" then
				T[ITEMIDCACHE[itemID].itemID].itemName = itemName;
				T[ITEMIDCACHE[itemID].itemID].lootDate = date;
				T[ITEMIDCACHE[itemID].itemID].location = currentMap;
				wasUpdated = true;
			elseif T[ITEMIDCACHE[itemID].itemID].lootDate ~= date then
				T[ITEMIDCACHE[itemID].itemID].lootDate = date;
				if T[ITEMIDCACHE[itemID].itemID].location ~= currentMap then
					T[ITEMIDCACHE[itemID].itemID].location = currentMap;
				end
				wasUpdated = true;
			else
				if T[ITEMIDCACHE[itemID].itemID].location ~= currentMap then
					T[ITEMIDCACHE[itemID].itemID].location = currentMap;
					wasUpdated = true;
				end
			end
			if wasUpdated and mode ~= 2 then
				Report(2, itemID);
			end
		else
			--T[ITEMIDCACHE[itemID].itemID] = {itemName = ITEMIDCACHE[itemID].itemName, lootDate = date, location = currentMap};
			if mode ~= 2 then
				Report(3, itemID);
			end
		end
	end
end

SLASH_LastSeen1 = "/lastseen";
SLASH_LastSeen2 = "/last";
SlashCmdList["LastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = find(cmd, "%s?(%w+)%s?(.*)");
	
	if not cmd or cmd == "" then
		LoadLastSeenSettings();
	elseif cmd == L["add"] and args ~= "" then
		Add(args);
	elseif cmd == L["ignore"] then
		print(Ignore(args));
	elseif cmd == L["remove"] then
		print(Remove(args));
	elseif cmd == L["search"] and args ~= "" then
		Search(args);
	end
end

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and addonTable.LastSeen then
		currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name;
		T = LastSeenItemsDB;
		IGNORE = LastSeenIgnoresDB;
		ITEMIDCACHE = LastSeenItemIDCacheDB;
		if T == nil and IGNORE == nil and ITEMIDCACHE == nil then
			T = {}; IGNORE = {}; ITEMIDCACHE = {};
		elseif IGNORE == nil then
			IGNORE = {};
		elseif ITEMIDCACHE == nil then
			ITEMIDCACHE = {};
		end
		eventFrame:UnregisterEvent("PLAYER_LOGIN");
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name;
	elseif event == "CHAT_MSG_LOOT" then
		local chatMsg, _, _, _, unitName, _, _, _, _, _, _, _, _ = ...;
		if string.match(unitName, "(.*)-") == UnitName("player") then
			AddLoot(chatMsg, unitName);
		end
	elseif event == "PLAYER_LOGOUT" then
		LastSeenItemsDB = T;
		LastSeenIgnoresDB = IGNORE;
		LastSeenItemIDCacheDB = ITEMIDCACHE;
	end
end)