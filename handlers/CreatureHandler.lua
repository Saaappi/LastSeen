local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local e = CreateFrame("Frame")

function LastSeen:AddCreatureFromMouseover(unit)
	-- Add the creature from mouseover information.
	if UnitGUID(unit) then
		local GUID = UnitGUID(unit)
		local type, _, _, _, _, creatureId = string.split("-", GUID)
		
		if type == "Creature" or type == "Vehicle" then
			local unitName = UnitName(unit)
			if not LastSeenCreatureDB[unitName] and not UnitIsFriend(unit, "PLAYER") then
				-- Only add the creature to the database if they're NOT
				-- friendly to the player.
				LastSeenCreatureDB[tonumber(creatureId)] = unitName
			end
		end
	end
end

function LastSeen:AddCreatureFromNameplate(unit)
	-- Add the creature from nameplate information.
	if UnitGUID(unit) then
		local GUID = UnitGUID(unit)
		local type, _, _, _, _, creatureId = string.split("-", GUID)
		
		if type == "Creature" or type == "Vehicle" then
			local unitName = UnitName(unit)
			if not LastSeenCreatureDB[unitName] and not UnitIsFriend(unit, "PLAYER") then
				-- Only add the creature to the database if they're NOT
				-- friendly to the player.
				LastSeenCreatureDB[tonumber(creatureId)] = unitName
			end
		end
	end
end

e:RegisterEvent("NAME_PLATE_UNIT_ADDED")
e:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
e:SetScript("OnEvent", function(self, event, ...)
	if event == "NAME_PLATE_UNIT_ADDED" then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		local unit = ...
		LastSeen:AddCreatureFromNameplate(unit)
	end
	if event == "UPDATE_MOUSEOVER_UNIT" then
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		LastSeen:AddCreatureFromMouseover("mouseover")
	end
end)