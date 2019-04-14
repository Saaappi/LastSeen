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
local frame = CreateFrame("Frame");
local date = date("%m/%d/%y");
local T = addonTable.LastSeenItems;
local I = addonTable.LastSeenIgnore;
local IDC = addonTable.LastSeenItemIDCache;
local L = addonTable.L;

frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_LOGOUT");

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
	
	local itemID = select(1, GetItemInfoInstant(itemLooted));
	if not IDC[itemID] then
		local itemName = select(1, GetItemInfo(itemID));
		local itemRarity = select(3, GetItemInfo(itemID));
		local itemType = select(6, GetItemInfo(itemID));
		IDC[itemID] = {itemID = itemID, itemName = itemName, itemRarity = itemRarity, itemType = itemType};
	end
	
	if IDC[itemID].itemRarity >= 2 and IDC[itemID].itemType ~= L["tradeskill"] and not I[IDC[itemID]] then
		if T[IDC[itemID].itemID] then
			if T[IDC[itemID].itemID].itemName == "" then
				T[IDC[itemID].itemID].itemName = itemName;
				T[IDC[itemID].itemID].lootDate = date;
				T[IDC[itemID].itemID].location = currentMap;
				wasUpdated = true;
			elseif T[IDC[itemID].itemID].lootDate ~= date then
				T[IDC[itemID].itemID].lootDate = date;
				if T[IDC[itemID].itemID].location ~= currentMap then
					T[IDC[itemID].itemID].location = currentMap;
				end
				wasUpdated = true;
			else
				if T[IDC[itemID].itemID].location ~= currentMap then
					T[IDC[itemID].itemID].location = currentMap;
					wasUpdated = true;
				end
			end
			if wasUpdated then
				print(addonName .. ": Updated the record for " .. select(2, GetItemInfo(IDC[itemID].itemID)) .. ".");
			end
		else
			T[IDC[itemID].itemID] = {itemName = IDC[itemID].itemName, lootDate = date, location = currentMap};
			print(addonName .. ": Added a new record for " .. select(2, GetItemInfo(IDC[itemID].itemID)) .. ".");
		end
	end
end

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
		I = {};
		print(addonName .. ": Ignore list cleared.");
	elseif I[itemID] then
		I[itemID].ignore = not I[itemID].ignore;
	else
		I[itemID] = {ignore = true};
		return (addonName .. ": Added " .. itemID .. " to the ignore list.");
	end
end

local function Remove(itemID)
	local itemID = tonumber(itemID);
	if itemID == nil then
		T = {};
		print(addonName .. ": Database cleared.");
	elseif T[itemID] then
		T[itemID] = nil;
	else
		return (addonName .. ": " .. itemID .. " not found.");
	end
end

local function Search(query)
	if tonumber(query) == nil then
		local itemsFound = 0;
		for k, v in pairs(T) do
			if find(lower(v.itemName), lower(query)) then
				print(v.itemName .. " (" .. k .. ") - " .. v.lootDate .. " - " .. v.location);
				itemsFound = itemsFound + 1;
			end
		end
	else
		local query = tonumber(query);
		if T[query] then
			print(T[query].itemName .. " (" .. query .. ") - " .. T[query].lootDate .. " - " .. T[query].location);
		else
			print(addonName .. ": No items found.");
		end
	end
	
	if itemsFound == 0 then
		print(addonName .. ": No items found.");
	end
end

SLASH_LastSeen1 = "/lastseen";
SLASH_LastSeen2 = "/last";
SlashCmdList["LastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = find(cmd, "%s?(%w+)%s?(.*)");
	
	if not cmd or cmd == "" then
		print(addonName .. ": \nVersion: " .. L["release"] .. " (" .. L["releaseDate"] .. ")" .. "\n" ..
		"Author: " .. L["author"] .. "\n" .. "Contact: " .. L["contact"] .. "\n" ..
		"Commands: " .. L["add"] .. ", " .. L["ignore"] .. ", " .. L["remove"] .. ", " .. L["search"]);
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

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and addonTable.LastSeen then
		currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name;
		T = LastSeenItemsDB;
		I = LastSeenIgnoresDB;
		IDC = LastSeenItemIDCacheDB;
		if T == nil and I == nil and IDC == nil then
			T = {}; I = {}; IDC = {};
		elseif I == nil then
			I = {};
		elseif IDC == nil then
			IDC = {};
		end
		frame:UnregisterEvent("PLAYER_LOGIN");
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		currentMap = C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player")).name;
	elseif event == "CHAT_MSG_LOOT" then
		local chatMsg, _, _, _, unitName, _, _, _, _, _, _, _, _ = ...;
		if string.match(unitName, "(.*)-") == UnitName("player") then
			AddLoot(chatMsg, unitName);
		end
	elseif event == "PLAYER_LOGOUT" then
		LastSeenItemsDB = T;
		LastSeenIgnoresDB = I;
		LastSeenItemIDCacheDB = IDC;
	end
end)