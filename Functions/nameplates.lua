--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all nameplate-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

lastSeenNS.AddCreatureByMouseover = function(unit)
	if lastSeenNS.LastSeenCreatures == nil then
		lastSeenNS.LastSeenCreatures = lastSeenNS.NilTable(lastSeenNS.LastSeenCreatures);
	end
	if UnitGUID(unit) ~= nil then
		local guid = UnitGUID(unit);
		local type, _, _, _, _, creatureID, _ = strsplit("-", guid);
		if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
			local unitname = UnitName(unit);
			if not lastSeenNS.LastSeenCreatures[creatureID] and not UnitIsFriend(unit, "player") then
				creatureID = tonumber(creatureID);
				lastSeenNS.LastSeenCreatures[creatureID] = {unitName = unitname};
			end
		end
	end
end

lastSeenNS.AddCreatureByNameplate = function(unit)
	if lastSeenNS.LastSeenCreatures == nil then
		lastSeenNS.LastSeenCreatures = lastSeenNS.NilTable(lastSeenNS.LastSeenCreatures);
	end
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit);
	local unitFrame = namePlate.UnitFrame;
	local guid = UnitGUID(unitFrame:GetAttribute("unit"));
	local unitname = UnitName(unitFrame:GetAttribute("unit"));
	local type, _, _, _, _, creatureID, _ = strsplit("-", guid);
	if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
		if not lastSeenNS.LastSeenCreatures[creatureID] and not UnitIsFriend(unit, "player") then
			creatureID = tonumber(creatureID);
			lastSeenNS.LastSeenCreatures[creatureID] = {unitName = unitname};
		end
	end
end