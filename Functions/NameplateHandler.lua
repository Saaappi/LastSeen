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
		--[[if UnitClassification(unit) == "rare" or UnitClassification(unit) == "rareelite" then
			local isInInstance = IsInInstance();
			RareSeen(unit, creatureID, seenDate, isInInstance);
		end]]
	end
end
