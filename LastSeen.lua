-------------------------------------------------------
-- LastSeen | Oxlotus - Area 52 (US) | Copyright © 2019
-------------------------------------------------------

local addonName, addonTable = ...;

local frame = CreateFrame("Frame");
local date = date("%m/%d/%y");
local T = addonTable.LastSeenItems;
local I = addonTable.LastSeenIgnore;
local L = addonTable.L;

frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_LOGOUT");

local function AddLoot(chatMsg, unitName)
	if not chatMsg then return end
	local itemLink = string.match(chatMsg, ":(.*])");
	
	if not itemLink then return end
	
	local itemID = select(1, GetItemInfoInstant(itemLink)); addonTable.itemID = itemID;
	local itemName = select(1, GetItemInfo(itemID));
	local itemRarity = select(3, GetItemInfo(itemID));
	local itemType = select(6, GetItemInfo(itemID));
	if itemRarity >= 2 and itemType ~= L["tradeskill"] and not I[itemID] then
		if T[itemID] then
			if T[itemID].itemName == "" then
				T[itemID].itemName = itemName;
				T[itemID].lootDate = date;
			elseif T[itemID].lootDate ~= date then
				T[itemID].lootDate = date;
				print(addonName .. ": Updated the record for " .. select(2, GetItemInfo(itemID)) .. ".");
			end
		else
			T[itemID] = {itemName = itemName, lootDate = date};
			print(addonName .. ": Added a new record for " .. select(2, GetItemInfo(itemID)) .. "|r.");
		end
	end
end

local function Add(itemID)
	if T[tonumber(itemID)] then
		print(addonName .. ": That item is already in the database!");
	else
		T[tonumber(itemID)] = {itemName = "", lootDate = ""};
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

local function Search(itemID)
	for k,v in pairs(T) do
		if T[tonumber(itemID)] then
			return (T[tonumber(itemID)].itemName .. " - " .. T[tonumber(itemID)].lootDate);
		else
			return (addonName .. ": " .. itemID .. " not found.");
		end
	end
end

SLASH_LastSeen1 = "/lastseen";
SLASH_LastSeen2 = "/last";
SlashCmdList["LastSeen"] = function(cmd, editbox)
	local _, _, cmd, args = string.find(cmd, "%s?(%w+)%s?(.*)");
	
	if not cmd or cmd == "" then
		print(addonName .. ": \nVersion: " .. L["release"] .. " (" .. L["releaseDate"] .. ")" .. "\n" ..
		"Author: " .. L["author"] .. "\n" .. "Contact: " .. L["contact"] .. "\n" ..
		"Commands: " .. L["add"] .. ", " .. L["remove"] .. ", " .. ", " .. L["search"]);
	elseif cmd == L["add"] and args ~= "" then
		Add(args);
	elseif cmd == L["ignore"] then
		print(Ignore(args));
	elseif cmd == L["remove"] then
		print(Remove(args));
	elseif cmd == L["search"] and args ~= "" then
		print(Search(args));
	end
end

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and IsAddOnLoaded(addonName) then
		T = LastSeenItemsDB;
		I = LastSeenIgnoresDB;
		if T == nil and I == nil then
			T = {}; I = {};
		elseif I == nil then
			I = {};
		end
		frame:UnregisterEvent("PLAYER_LOGIN");
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