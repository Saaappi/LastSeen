local addon, tbl = ...;
local L = tbl.L

local playerName = UnitName(L["IS_PLAYER"]);

tbl.AddCreatureByMouseover = function(unit, seenDate)
	if UnitGUID(unit) ~= nil then
		local guid = UnitGUID(unit);
		local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
		creatureID = tonumber(creatureID);
		if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
			local unitname = UnitName(unit);
			if not tbl.Creatures[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				tbl.Creatures[creatureID] = {unitName = unitname};
			elseif tbl.Creatures[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				if tbl.Creatures[creatureID]["seen"] == nil then
					tbl.Creatures[creatureID] = {unitName = unitname};
				end
				if tbl.Creatures[creatureID]["unitName"] == "Unknown" then -- LOCALIZE ME
					tbl.Creatures[creatureID]["unitName"] = UnitName(unit);
				end
			end
		end
	end
end

tbl.AddCreatureByNameplate = function(unit, seenDate)
	local guid = UnitGUID(unit);
	local unitName = UnitName(unit);
	if guid and unitName then
		local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
	else
		if tbl.Settings["mode"] == L["DEBUG"] then
			print(L["ADDON_NAME"] .. L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"])
		end
		return
	end
	creatureID = tonumber(creatureID);
	if entityType == L["IS_CREATURE"] or entityType == L["IS_VEHICLE"] then
		if not tbl.Creatures[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			tbl.Creatures[creatureID] = {unitName = unitName};
		elseif tbl.Creatures[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			if tbl.Creatures[creatureID]["seen"] == nil then
				tbl.Creatures[creatureID] = {unitName = unitName};
			end
			if tbl.Creatures[creatureID]["unitName"] == L["IS_UNKNOWN"] then
				tbl.Creatures[creatureID]["unitName"] = UnitName(unit);
			end
		end
	end
end
