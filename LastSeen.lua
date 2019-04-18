-------------------------------------------------------
-- LastSeen | Oxlotus - Area 52 (US) | Copyright © 2019
-------------------------------------------------------

local addonName, addonTable = ...;

addonName = "|cff00ccff" .. addonName .. "|r";

-- Highest-level Variables
local itemLooted = "";
local currentMap = "";
local wasUpdated = false;
local isMailboxOpen = false;
local isTradeOpen = false;

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
eventFrame:RegisterEvent("MAIL_SHOW");
eventFrame:RegisterEvent("MAIL_CLOSED");
eventFrame:RegisterEvent("TRADE_SHOW");
eventFrame:RegisterEvent("TRADE_CLOSED");

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
		print(addonName .. ": No items found.");
	end
end

local function Search(query)
	if tonumber(query) == nil then
		local itemsFound = 0;
		for k, v in pairs(T) do
			if find(lower(v.itemName), lower(query)) then
				local itemLink = select(2, GetItemInfo(k)); print(itemLink .. " (" .. k .. ") - " .. v.lootDate .. " - " .. v.location);
				itemsFound = itemsFound + 1;
			end
		end
		if itemsFound == 0 then
			print(addonName .. ": No items found.");
		end
	else
		local query = tonumber(query);
		if T[query] then
			print(select(2, GetItemInfo(query)) .. " (" .. query .. ") - " .. T[query].lootDate .. " - " .. T[query].location);
		else
			print(addonName .. ": No items found.");
		end
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
	local itemLink = select(2, GetItemInfo(itemID));
	if not ITEMIDCACHE[itemID] then
		local itemName = select(1, GetItemInfo(itemID));
		local itemRarity = select(3, GetItemInfo(itemID));
		local itemType = select(6, GetItemInfo(itemID));
		ITEMIDCACHE[itemID] = {itemID = itemID, itemName = itemName, itemRarity = itemRarity, itemType = itemType, itemLink = itemLink};
	elseif ITEMIDCACHE[itemID].itemLink == nil then
		ITEMIDCACHE[itemID].itemLink = itemLink;
	end
	
	if ITEMIDCACHE[itemID].itemRarity >= rarity and ITEMIDCACHE[itemID].itemType ~= L["TRADESKILL"] and not IGNORE[itemID] then
		if T[itemID] then
			if T[itemID].itemName == nil then
				T[itemID].itemName = ITEMIDCACHE[itemID].itemName;
				T[itemID].lootDate = date;
				T[itemID].location = currentMap;
				wasUpdated = true;
			elseif T[itemID].lootDate ~= date then
				T[itemID].lootDate = date;
				if T[itemID].location ~= currentMap then
					T[itemID].location = currentMap;
				end
				wasUpdated = true;
			elseif T[itemID].location ~= currentMap and not isMailboxOpen then
				T[itemID].location = currentMap;
				wasUpdated = true;
			end
			if wasUpdated and mode ~= 2 then
				print(addonName .. ": Updated " .. itemLink .. ".");
			end
		else
			if isMailboxOpen then
				T[itemID] = {itemName = ITEMIDCACHE[itemID].itemName, lootDate = date, location = L["MAIL"]};
			elseif isTradeOpen then
				T[itemID] = {itemName = ITEMIDCACHE[itemID].itemName, lootDate = date, location = L["TRADE"]};
			else
				T[itemID] = {itemName = ITEMIDCACHE[itemID].itemName, lootDate = date, location = currentMap};
			end
			if mode ~= 2 then
				print(addonName .. ": Added " .. itemLink .. ".");
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
	elseif cmd == L["ADD"] and args ~= "" then
		Add(args);
	elseif cmd == L["IGNORE"] then
		print(Ignore(args));
	elseif cmd == L["REMOVE"] then
		print(Remove(args));
	elseif cmd == L["SEARCH"] and args ~= "" then
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
	elseif event == "MAIL_SHOW" then
		isMailboxOpen = true;
	elseif event == "MAIL_CLOSED" then
		isMailboxOpen = false;
	elseif event == "TRADE_SHOW" then
		isTradeOpen = true;
	elseif event == "TRADE_CLOSED" then
		isTradeOpen = false;
	elseif event == "PLAYER_LOGOUT" then
		LastSeenItemsDB = T;
		LastSeenIgnoresDB = IGNORE;
		LastSeenItemIDCacheDB = ITEMIDCACHE;
	end
end)