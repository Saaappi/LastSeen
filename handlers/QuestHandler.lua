local addon, tbl = ...;
local L = tbl.L;

tbl.AddQuest = function(id, title, mapID, provider, currentDate)
	if LastSeenQuestsDB[id] then
		tbl.UpdateQuest(id, mapID, provider, currentDate);
	else
		LastSeenQuestsDB[id] = {questTitle = title, mapID = mapID, providers = {}, lastCompleted = currentDate};
		LastSeenQuestsDB[id]["providers"][provider] = 1;
	end
end
-- Synopsis: Add the quest into the quests table so it can be used as a source if the player gets a quest reward that should be tracked.

tbl.UpdateQuest = function(id, mapID, providers, currentDate)
	if id then
		if LastSeenQuestsDB[id] then
			if LastSeenQuestsDB[id]["providers"] == nil then LastSeenQuestsDB[id]["providers"] = {} end;
			LastSeenQuestsDB[id]["mapID"] = mapID;
			LastSeenQuestsDB[id]["lastCompleted"] = currentDate;
			if not LastSeenQuestsDB[id]["providers"][provider] then
				LastSeenQuestsDB[id]["providers"][provider] = 1;
			end
		end
	end
end
-- Synopsis: Update quest information.

tbl.GetQuestInfo = function(questID, provider)
	local title = (C_QuestLog.GetTitleForQuestID(questID));
	local mapID = tbl.GetCurrentMapInfo();
	tbl.AddQuest(questID, title, mapID, provider, tbl.currentDate);
end
-- Synopsis: It's easier to request information about a quest when it's accepted than once it's completed.
-- Ask Blizzard for the quest's name and ID. These are passed on to the AddQuest function.