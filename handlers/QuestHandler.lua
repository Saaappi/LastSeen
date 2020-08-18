local addon, tbl = ...;
local L = tbl.L

tbl.AddQuest = function(id, title, mapID, provider, faction, minQuestLevel, coordX, coordY, currentDate)
	if LastSeenQuestsDB[id] then
		tbl.UpdateQuest(id, mapID, provider, faction, minQuestLevel, coordX, coordY, currentDate);
	else
		LastSeenQuestsDB[id] = {questTitle = title, mapID = mapID, providers = {}, factions = {}, questLevel = minQuestLevel, coords = {}, lastCompleted = currentDate};
		LastSeenQuestsDB[id]["providers"][provider] = 1
		LastSeenQuestsDB[id]["factions"][faction] = 1
		LastSeenQuestsDB[id]["coords"]["x"] = coordX
		LastSeenQuestsDB[id]["coords"]["y"] = coordY
	end
end
-- Synopsis: Add the quest into the quests table so it can be used as a source if the player gets a quest reward that should be tracked.

tbl.UpdateQuest = function(id, mapID, provider, faction, minQuestLevel, coordX, coordY, currentDate)
	if id then
		if LastSeenQuestsDB[id] then
			if LastSeenQuestsDB[id]["providers"] == nil then LastSeenQuestsDB[id]["providers"] = {} end
			if LastSeenQuestsDB[id]["factions"] == nil then LastSeenQuestsDB[id]["factions"] = {} end
			if LastSeenQuestsDB[id]["coords"] == nil then LastSeenQuestsDB[id]["coords"] = {} end
			LastSeenQuestsDB[id]["mapID"] = mapID
			LastSeenQuestsDB[id]["lastCompleted"] = currentDate
			if LastSeenQuestsDB[id]["questLevel"] == nil then
				LastSeenQuestsDB[id]["questLevel"] = minQuestLevel
			elseif minQuestLevel then -- On occasion this is nil for God knows what reason... doesn't seem to have an impact on data, though.
				if (minQuestLevel < LastSeenQuestsDB[id]["questLevel"]) then LastSeenQuestsDB[id]["questLevel"] = minQuestLevel end
			end
			if provider then -- On occasion this is nil for God knows what reason... doesn't seem to have an impact on data, though.
				if LastSeenQuestsDB[id]["providers"][provider] == nil then
					LastSeenQuestsDB[id]["providers"][provider] = 1
				end
			end
			if faction then -- On occasion this is nil for God knows what reason... doesn't seem to have an impact on data, though.
				if LastSeenQuestsDB[id]["factions"][faction] == nil then
					LastSeenQuestsDB[id]["factions"][faction] = 1
				end
			end
			LastSeenQuestsDB[id]["coords"]["x"] = coordX
			LastSeenQuestsDB[id]["coords"]["y"] = coordY
		end
	end
end
-- Synopsis: Update quest information.

tbl.GetQuestInfo = function(questID, provider, faction, minQuestLevel, coordX, coordY)
	local title = (C_QuestLog.GetTitleForQuestID(questID));
	local mapID = tbl.GetCurrentMapInfo();
	
	-- Nil checks
	if mapID == nil then
		tbl.GetCurrentMapInfo();
	end
	
	if faction == "Unknown" then
		if UnitGUID("target") then
			print(L["ADDON_NAME"] .. L["ERROR_MSG_UNKNOWN_FACTION"] .. " " .. L["QUEST"] .. ": " .. title .. ", " .. L["PROVIDER"] .. ": " .. provider .. " (" .. UnitGUID("target") .. ")")
		elseif tbl.possibleQuestProvider then
			print(L["ADDON_NAME"] .. L["ERROR_MSG_UNKNOWN_FACTION"] .. " " .. L["QUEST"] .. ": " .. title .. ", " .. L["PROVIDER"] .. ": " .. provider .. " (" .. tbl.possibleQuestProvider .. ")")
		end
	end
	
	tbl.AddQuest(questID, title, mapID, provider, faction, minQuestLevel, coordX, coordY, tbl.currentDate);
end
-- Synopsis: It's easier to request information about a quest when it's accepted than once it's completed.
-- Ask Blizzard for the quest's name and ID. These are passed on to the AddQuest function.