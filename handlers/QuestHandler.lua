local addon, tbl = ...;
local L = tbl.L;

tbl.AddQuest = function(id, title, mapID, currentDate)
	if LastSeenQuestsDB[id] then
		tbl.UpdateQuest(id, mapID, sourceQuests, currentDate);
	else
		LastSeenQuestsDB[id] = {questTitle = title, mapID = mapID, lastCompleted = currentDate};
	end
end
-- Synopsis: Add the quest into the quests table so it can be used as a source if the player gets a quest reward that should be tracked.

tbl.UpdateQuest = function(id, mapID, currentDate)
	if id then
		if LastSeenQuestsDB[id] then
			LastSeenQuestsDB[id]["mapID"] = mapID;
			LastSeenQuestsDB[id]["lastCompleted"] = currentDate;
		end
	end
end
-- Synopsis: Update quest information.

tbl.GetQuestInfo = function(questID)
	local title = (C_QuestLog.GetTitleForQuestID(questID));
	local mapID = tbl.GetCurrentMapInfo();
	tbl.AddQuest(questID, title, mapID, tbl.currentDate);
end
-- Synopsis: It's easier to request information about a quest when it's accepted than once it's completed.
-- Ask Blizzard for the quest's name and ID. These are passed on to the AddQuest function.