local addonName, addonTable = ...
local e = CreateFrame("Frame")

e:RegisterEvent("ENCOUNTER_START")
e:RegisterEvent("PLAYER_LOGIN")
e:RegisterEvent("ZONE_CHANGED")
e:RegisterEvent("ZONE_CHANGED_NEW_AREA")
e:SetScript("OnEvent", function(self, event, ...)
	if (event == "ENCOUNTER_START") then
		addonTable.isOnEncounter = true
	end
	if (event == "PLAYER_LOGIN") or (event == "ZONE_CHANGED") or (event == "ZONE_CHANGED_NEW_AREA") then
		-- Don't do anything if the addon functionality is disabled.
		if LastSeenDB.Enabled == false or LastSeenDB.Enabled == nil then return false end
		
		local map = LastSeen:GetBestMapForUnit("player")
		if map then
			if (map.mapType == 4) or (map.mapType == 6) then
				-- Get the encounters for the current map.
				local encountersOnMap = C_EncounterJournal.GetEncountersOnMap(map.mapID)
				if (#encountersOnMap > 0) then
					-- If there is at least 1 encounter on the map, then continue.
					for _, encounter in ipairs(encountersOnMap) do
						-- Get the each encounter's information from its ID.
						local encounterName, _, _, _, _, _, encounterID, instanceID = EJ_GetEncounterInfo(encounter.encounterID)
						if encounterName then
							-- If at least the encounter name is valid, then log it to the encounter table
							-- for later reference.
							if (not LastSeenDB.Encounters[encounterID]) then
								LastSeenDB.Encounters[encounterID] = { encounterName = encounterName, instanceID = instanceID }
							end
						end
					end
				end
			end
		end
	end
end)