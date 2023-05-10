local addonName, addon = ...
local L_GLOBALSTRINGS = addon.L_GLOBALSTRINGS
local e = CreateFrame("Frame")

local function GetType(type)
	-- We only want to support "creatures" and "vehicles".
	-- There are some creatures in the game that are technically "vehicles", such as
	-- Slagmaw in Ragefire Chasm.
	if type == "Creature" or type == "Vehicle" then
		return true
	end
	return false
end

function LastSeen:AddCreatureFromMouseover(unit)
	-- Add the creature from mouseover information.
	local GUID = UnitGUID(unit)
	
	-- If the GUID is valid, then continue.
	if GUID then
		-- Get the GUID's entity type and npc ID.
		local type, _, _, _, _, npcID = string.split("-", GUID)
		if GetType(type) then
			npcID = tonumber(npcID)
			local unitName = UnitName(unit)
			if unitName == "Unknown" then
				C_Timer.After(0.5, function()
					LastSeen:AddCreatureFromMouseover(unit)
				end)
			else
				if not LastSeenDB.Creatures[npcID] and not UnitIsFriend(unit, "player") then
					LastSeenDB.Creatures[npcID] = unitName
				end
			end
		end
	end
end

function LastSeen:AddCreatureFromNameplate(unit)
	-- Add the creature from nameplate information.
	local GUID = UnitGUID(unit)
	if GUID then
		local type, _, _, _, _, npcID = string.split("-", GUID)
		if GetType(type) then
			npcID = tonumber(npcID)
			local unitName = UnitName(unit)
			if unitName == "Unknown" then
				C_Timer.After(0.5, function()
					LastSeen:AddCreatureFromNameplate(unit)
				end)
			else
				if not LastSeenDB.Creatures[npcID] and not UnitIsFriend(unit, "player") then
					LastSeenDB.Creatures[npcID] = unitName
				end
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