--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all nameplate-related functions.
]]--

local lastSeen, LastSeenTbl = ...;
local L = LastSeenTbl.L;

-- Common API Calls
GetBestMapForUnit = C_Map.GetBestMapForUnit;
GetPlayerMapPosition = C_Map.GetPlayerMapPosition;

local playerName = UnitName(L["IS_PLAYER"]);

local function RareSeen(unit, creatureID, seenDate, isInInstance)
	-- We don't want the sound file to play every time the nameplate is shown. We'll play once a day instead.
	-- This rare has been seen for the first time on a new day or by a new character.
	if LastSeenCreaturesDB[creatureID]["seen"] ~= seenDate or LastSeenCreaturesDB[creatureID]["player"] ~= playerName then
		LastSeenCreaturesDB[creatureID]["seen"] = seenDate;
		LastSeenCreaturesDB[creatureID]["player"] = playerName;
		
		if isInInstance then
			print(L["ADDON_NAME"] .. L["RARE"] .. " - " .. LastSeenCreaturesDB[creatureID].unitName);
		else
			print(L["ADDON_NAME"] .. L["RARE"] .. " - " .. LastSeenCreaturesDB[creatureID].unitName .. " (" .. LastSeenTbl.Round(UnitHealth(unit)/UnitHealthMax(unit), 2) .. "%)");
		end
		
		if not LastSeenTbl.doNotPlayRareSound then
			PlaySoundFile(LastSeenSettingsCacheDB.rareSoundID);
		end

		if unit then
			if GetRaidTargetIndex(unit) == nil then
				SetRaidTarget(unit, 8);
			end
		end
	end
end

LastSeenTbl.AddCreatureByMouseover = function(unit, seenDate)
	if UnitGUID(unit) ~= nil then
		local guid = UnitGUID(unit);
		local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
		creatureID = tonumber(creatureID);
		if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
			local unitname = UnitName(unit);
			if not LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				LastSeenCreaturesDB[creatureID] = {unitName = unitname, seen = "", player = ""};
			elseif LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				if LastSeenCreaturesDB[creatureID]["seen"] == nil then
					LastSeenCreaturesDB[creatureID] = {unitName = unitname, seen = "", player = ""};
				end
				if LastSeenCreaturesDB[creatureID]["unitName"] == "Unknown" then -- LOCALIZE ME
					LastSeenCreaturesDB[creatureID]["unitName"] = UnitName(unit);
				end
			end
			if UnitClassification(unit) == "rare" or UnitClassification(unit) == "rareelite" then
				local isInInstance = IsInInstance();
				if not LastSeenCreaturesDB[creatureID] and UnitIsFriend(unit, L["IS_PLAYER"]) then -- To account for friendly rare encounters.
					LastSeenCreaturesDB[creatureID] = {unitName = unitname, seen = "", player = ""};
				end
				RareSeen(unit, creatureID, seenDate, isInInstance);
			end
		end
	end
end

LastSeenTbl.AddCreatureByNameplate = function(unit, seenDate)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit);
	local unitFrame = namePlate.UnitFrame;
	local guid = UnitGUID(unitFrame:GetAttribute("unit"));
	local unitname = UnitName(unitFrame:GetAttribute("unit"));
	local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
	creatureID = tonumber(creatureID);
	if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
		if not LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			LastSeenCreaturesDB[creatureID] = {unitName = unitname, seen = "", player = ""};
		elseif LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			if LastSeenCreaturesDB[creatureID]["seen"] == nil then
				LastSeenCreaturesDB[creatureID] = {unitName = unitname, seen = "", player = ""};
			end
			if LastSeenCreaturesDB[creatureID]["unitName"] == "Unknown" then -- LOCALIZE ME
				LastSeenCreaturesDB[creatureID]["unitName"] = UnitName(unit);
			end
		end
		if UnitClassification(unit) == "rare" or UnitClassification(unit) == "rareelite" then
			local isInInstance = IsInInstance();
			RareSeen(unit, creatureID, seenDate, isInInstance);
		end
	end
end
