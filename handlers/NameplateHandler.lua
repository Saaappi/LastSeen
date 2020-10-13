local addon, tbl = ...;

local playerName = UnitName(tbl.L["PLAYER"]);

tbl.AddCreatureByMouseover = function(unit, seenDate)
	if UnitGUID(unit) ~= nil then
		local guid = UnitGUID(unit);
		local entityType, _, _, _, _, creatureID, _ = strsplit("-", guid);
		creatureID = tonumber(creatureID);
		if entityType == tbl.L["CREATURE"] or entityType == tbl.L["VEHICLE"] then
			local unitname = UnitName(unit);
			if not tbl.Creatures[creatureID] and not UnitIsFriend(unit, tbl.L["PLAYER"]) then
				tbl.Creatures[creatureID] = {unitName = unitname};
			elseif tbl.Creatures[creatureID] and not UnitIsFriend(unit, tbl.L["PLAYER"]) then
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
		if tbl.Settings["mode"] == tbl.L["DEBUG"] then
			print(tbl.L["ADDON_NAME"] .. tbl.L["INVALID_GUID_OR_UNITNAME"])
		end
		return
	end
	creatureID = tonumber(creatureID);
	if entityType == tbl.L["CREATURE"] or entityType == tbl.L["VEHICLE"] then
		if not tbl.Creatures[creatureID] and not UnitIsFriend(unit, tbl.L["PLAYER"]) then
			tbl.Creatures[creatureID] = {unitName = unitName};
		elseif tbl.Creatures[creatureID] and not UnitIsFriend(unit, tbl.L["PLAYER"]) then
			if tbl.Creatures[creatureID]["seen"] == nil then
				tbl.Creatures[creatureID] = {unitName = unitName};
			end
			if tbl.Creatures[creatureID]["unitName"] == tbl.L["UNKNOWN"] then
				tbl.Creatures[creatureID]["unitName"] = UnitName(unit);
			end
		end
	end
end
