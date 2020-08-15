local addon, tbl = ...;
local L = tbl.L;

tbl.AddQuest = function(id, title, mapID, provider, minQuestLevel, currentDate)
	if LastSeenQuestsDB[id] then
		tbl.UpdateQuest(id, mapID, provider, minQuestLevel, currentDate);
	else
		LastSeenQuestsDB[id] = {questTitle = title, mapID = mapID, providers = {}, questLevel = minQuestLevel, lastCompleted = currentDate};
		LastSeenQuestsDB[id]["providers"][provider] = 1;
	end
end
-- Synopsis: Add the quest into the quests table so it can be used as a source if the player gets a quest reward that should be tracked.

tbl.UpdateQuest = function(id, mapID, provider, minQuestLevel, currentDate)
	if id then
		if LastSeenQuestsDB[id] then
			if LastSeenQuestsDB[id]["providers"] == nil then LastSeenQuestsDB[id]["providers"] = {} end;
			LastSeenQuestsDB[id]["mapID"] = mapID;
			LastSeenQuestsDB[id]["lastCompleted"] = currentDate;
			if LastSeenQuestsDB[id]["questLevel"] == nil then
				LastSeenQuestsDB[id]["questLevel"] = minQuestLevel;
			else
				if minQuestLevel < LastSeenQuestsDB[id]["questLevel"] then LastSeenQuestsDB[id]["questLevel"] = minQuestLevel;
			end
			if not LastSeenQuestsDB[id]["providers"][provider] then
				LastSeenQuestsDB[id]["providers"][provider] = 1;
			end
		end
	end
end
-- Synopsis: Update quest information.

tbl.GetQuestInfo = function(questID, provider, minQuestLevel)
	local title = (C_QuestLog.GetTitleForQuestID(questID));
	local mapID = tbl.GetCurrentMapInfo();
	tbl.AddQuest(questID, title, mapID, provider, minQuestLevel, tbl.currentDate);
end
-- Synopsis: It's easier to request information about a quest when it's accepted than once it's completed.
-- Ask Blizzard for the quest's name and ID. These are passed on to the AddQuest function.