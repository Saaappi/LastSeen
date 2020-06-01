local addon, addonTbl = ...;
local L = addonTbl.L;

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
	local guid = UnitGUID(unit);
	local unitName = UnitName(unit);
	if guid and unitName then
		local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
	else
		if addonTbl.mode == L["DEBUG_MODE"] then
			print(L["ADDON_NAME"] .. L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"])
		end
		return;
	end
	creatureID = tonumber(creatureID);
	if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
		if not LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			LastSeenCreaturesDB[creatureID] = {unitName = unitName};
		elseif LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			if LastSeenCreaturesDB[creatureID]["seen"] == nil then
				LastSeenCreaturesDB[creatureID] = {unitName = unitName};
			end
			if LastSeenCreaturesDB[creatureID]["unitName"] == L["IS_UNKNOWN"] then
				LastSeenCreaturesDB[creatureID]["unitName"] = UnitName(unit);
			end
		end
	end
end
