-------------------------------------------------------
-- LastSeen | Oxlotus - Area 52 (US) | Copyright © 2019
-------------------------------------------------------

local addonName, addonTable = ...;

local frame = CreateFrame("Frame");
local date = date("%m/%d/%y");
local T = addonTable.LastSeenItems;
local L = addonTable.L;

frame:RegisterEvent("LOOT_OPENED");
frame:RegisterEvent("CHAT_MSG_LOOT");
frame:RegisterEvent("PLAYER_LOGIN");
frame:RegisterEvent("PLAYER_LOGOUT");

local function AddLoot()
	for i = GetNumLootItems(), 1, -1 do
		local itemName = select(2, GetLootSlotInfo(i)); addonTable.itemName = itemName;
		local itemRarity = select(5, GetLootSlotInfo(i)); addonTable.itemRarity = itemRarity;
		if itemRarity >= 2 then
			local itemLink = GetLootSlotLink(i);
			if itemLink ~= nil then
				local itemID, _, _, _, _, _, _ = GetItemInfoInstant(itemLink); addonTable.itemID = itemID;
				if T[itemID] then
					if T[itemID].itemName == "" then
						-- This is a custom item added by the player. Now is the time to update it.
						T[itemID].itemName = itemName;
						T[itemID].lootDate = date;
					elseif T[itemID].lootDate ~= date then
						T[itemID].lootDate = date; -- Update an existing record.
						print(addonName .. ": Updated the record for " .. itemLink .. ".");
					end
				else
					print(itemLink .. ".");
					T[itemID] = {itemName = itemName, lootDate = date}; -- Add a new record.
					print(addonName .. ": Added a new record for " .. itemLink .. ".");
				end
			end
		end
	end
end

local function AddPushedLoot(chatMsg, unitName)
	if not chatMsg then return end
	local itemLink = string.match(chatMsg, ":(.*])");
	
	if not itemLink then return end
	
	local itemID = select(1, GetItemInfoInstant(itemLink)); addonTable.itemID = itemID;
	local itemName = select(1, GetItemInfo(itemID));
	local itemRarity = select(3, GetItemInfo(itemID));
	if itemRarity >= 2 then
		if T[itemID] then
			if T[itemID].itemName == "" then
				-- This is a custom item added by the player. Now is the time to update it.
				T[itemID].itemName = itemName;
				T[itemID].lootDate = date;
			elseif T[itemID].lootDate ~= date then
				T[itemID].lootDate = date; -- Update an existing record.
				print(addonName .. ": Updated the record for " .. itemLink .. ".");
			end
		else
			T[itemID] = {itemName = itemName, lootDate = date}; -- Add a new record.
			print(addonName .. ": Added a new record for " .. itemLink .. ".");
		end
	end
end

local function AddItem(itemID)
	if T[tonumber(itemID)] then
		print(addonName .. ": That item is already in the database!");
	else
		T[tonumber(itemID)] = {itemName = "", lootDate = ""};
		print(addonName .. ": Added a new record for " .. itemID .. ".");
	end
end

local function ClearDB()
	T = {};
	print(addonName .. ": Database cleared.")
end

local function DumpDB()
	for k,v in pairs(T) do
		print(v.itemName .. " (" .. k .. ")" .. " - " .. v.lootDate);
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
		"Commands: " .. L["add"] .. ", " .. L["clear"] .. ", " .. L["dump"] .. ", " .. L["search"]);
	elseif cmd == L["add"] and args ~= "" then
		AddItem(args);
	elseif cmd == L["clear"] then
		ClearDB();
	elseif cmd == L["dump"] then
		DumpDB();
	elseif cmd == L["search"] and args ~= "" then
		print(Search(args));
	end
end

frame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" and IsAddOnLoaded(addonName) then
		T = LastSeenItemsDB;
		if T == nil then
			T = {};
		end
		frame:UnregisterEvent("PLAYER_LOGIN");
	elseif event == "LOOT_OPENED" then -- Looted items
		if IsAddOnLoaded("AutoLootPlus") then
			C_Timer.After(0.5, function()
				AddLoot();
			end);
		else
			AddLoot();
		end
	elseif event == "CHAT_MSG_LOOT" then -- Pushed items (e.g. world quests, tradeskills, etc.)
		local chatMsg, _, _, _, unitName, _, _, _, _, _, _, _, _ = ...;
		if string.match(unitName, "(.*)-") == UnitName("player") then
			AddPushedLoot(chatMsg, unitName);
		end
	elseif event == "PLAYER_LOGOUT" then
		LastSeenItemsDB = T;
	end
end)