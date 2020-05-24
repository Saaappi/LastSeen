local addon, addonTbl = ...;
local L = addonTbl.L;

-- Common API Calls
GetBestMapForUnit = C_Map.GetBestMapForUnit;
GetPlayerMapPosition = C_Map.GetPlayerMapPosition;

local playerName = UnitName(L["IS_PLAYER"]);

addonTbl.AddCreatureByMouseover = function(unit, seenDate)
	if UnitGUID(unit) ~= nil then
		local guid = UnitGUID(unit);
		local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
		creatureID = tonumber(creatureID);
		if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
			local unitname = UnitName(unit);
			if not LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				LastSeenCreaturesDB[creatureID] = {unitName = unitname};
			elseif LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				if LastSeenCreaturesDB[creatureID]["seen"] == nil then
					LastSeenCreaturesDB[creatureID] = {unitName = unitname};
				end
				if LastSeenCreaturesDB[creatureID]["unitName"] == "Unknown" then -- LOCALIZE ME
					LastSeenCreaturesDB[creatureID]["unitName"] = UnitName(unit);
				end
			end
		end
	end
end

addonTbl.AddCreatureByNameplate = function(unit, seenDate)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit);
	local unitFrame = namePlate.UnitFrame;
	if unitFrame then
		local guid = UnitGUID(unitFrame:GetAttribute("unit"));
		local unitname = UnitName(unitFrame:GetAttribute("unit"));
	else
		if addonTbl.mode == L["DEBUG_MODE"] then
			print(L["ADDON_NAME"] .. L["ERROR_MSG_INVALID_UNITFRAME"] .. unit .. ".")
		end
	end
	local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
	creatureID = tonumber(creatureID);
	if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
		if not LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			LastSeenCreaturesDB[creatureID] = {unitName = unitname};
		elseif LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			if LastSeenCreaturesDB[creatureID]["seen"] == nil then
				LastSeenCreaturesDB[creatureID] = {unitName = unitname};
			end
			if LastSeenCreaturesDB[creatureID]["unitName"] == "Unknown" then -- LOCALIZE ME
				LastSeenCreaturesDB[creatureID]["unitName"] = UnitName(unit);
			end
		end
	end
end
