--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: This file is used for event handling. This is the traffic cop of the addon.
]]--

local lastseen, lastseendb = ...;

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
local getDate = date("%m/%d/%y");

-- Table Variables
--local T = addonTable.LastSeenItems;
--local IGNORE = addonTable.LastSeenIgnore;
--local ITEMIDCACHE = addonTable.LastSeenItemIDCache;
--local L = addonTable.L;

eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
eventFrame:RegisterEvent("CHAT_MSG_LOOT");
eventFrame:RegisterEvent("PLAYER_LOGIN");
eventFrame:RegisterEvent("MAIL_SHOW");
eventFrame:RegisterEvent("MAIL_CLOSED");
eventFrame:RegisterEvent("TRADE_SHOW");
eventFrame:RegisterEvent("TRADE_CLOSED");

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
	
	local mode = addonTable.mode;
	local rarity = addonTable.rarity;
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
			elseif T[itemID].lootDate ~= getDate then
				print(T[itemID].lootDate);
				T[itemID].lootDate = date;
				print(T[itemID].lootDate);
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

eventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and lastseendb.lastseen then
		currentMap = lastseendb:GetBestMapForUnit("player");
		lastseendb.itemstgdb = LastSeenItemsDB;
		lastseendb.itemignrdb = LastSeenIgnoresDB;
		ITEMIDCACHE = LastSeenItemIDCacheDB;
		if T == nil and IGNORE == nil and ITEMIDCACHE == nil then
			T = {}; IGNORE = {}; ITEMIDCACHE = {};
		elseif IGNORE == nil then
			IGNORE = {};
		elseif ITEMIDCACHE == nil then
			ITEMIDCACHE = {};
		end
		LoadLastSeenSettings(true);
		eventFrame:UnregisterEvent("PLAYER_LOGIN");
	elseif event == "ZONE_CHANGED_NEW_AREA" then
		currentMap = lastseendb:GetBestMapForUnit("player");
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
	end
end)