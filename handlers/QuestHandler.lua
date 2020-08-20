local addon, tbl = ...;

tbl.AddQuest = function(id, title, currentDate)
	if tbl.Quests[id] then
		tbl.Quests[id]["lastCompleted"] = currentDate
	else
		tbl.Quests[id] = { questTitle = title, lastCompleted = currentDate }
	end
end
-- Synopsis: Add the quest into the quests table so it can be used as a source if the player gets a quest reward that should be tracked.

tbl.GetQuestInfo = function(questID)
	local title = (C_QuestLog.GetTitleForQuestID(questID))
	tbl.AddQuest(questID, title, tbl.currentDate)
end
-- Synopsis: It's easier to request information about a quest when it's accepted than once it's completed.
-- Ask Blizzard for the quest's name and ID. These are passed on to the AddQuest function.