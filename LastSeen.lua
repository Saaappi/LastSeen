-------------------------------------------------------
-- LastSeen | Oxlotus - Area 52 (US) | Copyright © 2019
-------------------------------------------------------

local addonName, addonTable = ...;

local frame = CreateFrame("Frame");
local date = date("%m/%d/%y");
local currentMap = "";
local wasUpdated = false;
local T = addonTable.LastSeenItems;
local I = addonTable.LastSeenIgnore;
local L = addonTable.L;

frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_LOGOUT");

local function AddLoot(chatMsg, unitName)
	if not chatMsg then return end
	local itemLooted = string.match(chatMsg, "[%+%p%s](.*)[%s%p%+]");
	
	if not itemLooted then return end;
	
	local itemID = select(1, GetItemInfoInstant(itemLooted));
	local itemName = select(1, GetItemInfo(itemID));
	local itemRarity = select(3, GetItemInfo(itemID));
	local itemType = select(6, GetItemInfo(itemID));
	if itemRarity >= 2 and itemType ~= L["tradeskill"] and not I[itemID] then
		if T[itemID] then
			if T[itemID].itemName == "" then
				T[itemID].itemName = itemName;
				T[itemID].lootDate = date;
				T[itemID].location = currentMap;
				wasUpdated = true;
			elseif T[itemID].lootDate ~= date then
				T[itemID].lootDate = date;
				if T[itemID].location ~= currentMap then
					T[itemID].location = currentMap;
				end
				wasUpdated = true;
			else
				if T[itemID].location ~= currentMap then
					T[itemID].location = currentMap;
					wasUpdated = true;
				end
			end
			if wasUpdated then
				print(addonName .. ": Updated the record for " .. select(2, GetItemInfo(itemID)) .. ".");
			end
		else
			T[itemID] = {itemName = itemName, lootDate = date, location = currentMap};
			print(addonName .. ": Added a new record for " .. select(2, GetItemInfo(itemID)) .. ".");
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
			if string.find(string.lower(v.itemName), string.lower(query)) then
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
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");
	
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
		if T == nil and I == nil then
			T = {}; I = {};
		elseif I == nil then
			I = {};
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
	end
end)