--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-23
	Purpose			: Handler for all nameplate-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;

lastSeenNS.AddCreatureByMouseover = function(unit, seenDate)
	if UnitGUID(unit) ~= nil then
		local guid = UnitGUID(unit);
		local type, _, _, _, _, creatureID, _ = strsplit("-", guid);
		if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
			local unitname = UnitName(unit);
			if not LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
				creatureID = tonumber(creatureID);
				LastSeenCreaturesDB[creatureID] = {unitName = unitname};
			end
		end
	end
end

lastSeenNS.AddCreatureByNameplate = function(unit, seenDate)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit);
	local unitFrame = namePlate.UnitFrame;
	local guid = UnitGUID(unitFrame:GetAttribute("unit"));
	local unitname = UnitName(unitFrame:GetAttribute("unit"));
	local type, _, _, _, _, creatureID, _ = strsplit("-", guid);
	if type == L["IS_CREATURE"] or type == L["IS_VEHICLE"] then
		if not LastSeenCreaturesDB[creatureID] and not UnitIsFriend(unit, L["IS_PLAYER"]) then
			creatureID = tonumber(creatureID);
			LastSeenCreaturesDB[creatureID] = {unitName = unitname};
			if UnitClassification(unit) == "rare" or UnitClassification(unit) == "rareelite" then
				LastSeenCreaturesDB[creatureID]["seenDate"] = seenDate;
				PlaySoundFile("Sound\\Creature\\Cthun\\cthunyouwilldie.ogg", "Master");
				print(L["ADDON_NAME"] .. LastSeenCreaturesDB[creatureID][unitName]);
				--print(L["ADDON_NAME"] .. LastSeenCreaturesDB[creatureID].unitName);
			end
		end
	end
end