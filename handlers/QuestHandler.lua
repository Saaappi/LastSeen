local addon, tbl = ...;
local L = tbl.L;
local select = select;

local itemName;
local itemRarity;
local itemID;
local itemType;
local itemIcon;
local questTitle;

tbl.AddQuest = function(questID, currentDate)
	
	if LastSeenQuestsDB[questID] then
		LastSeenQuestsDB[questID]["lastCompleted"] = currentDate;
	else
		LastSeenQuestsDB[questID] = {questTitle = questTitle, lastCompleted = currentDate, mapID = };
	end
end
-- Synopsis: Add the quest into the quests table so it can be used as a source if the player gets a quest reward that should be tracked.

tbl.GetQuestInfo = function(questID)
	questTitle = (C_QuestLog.GetTitleForQuestID(questID));
	tbl.AddQuest(questID, tbl.currentDate);
end
-- Synopsis: It's easier to request information about a quest when it's accepted than once it's completed.
-- Ask Blizzard for the quest's name and ID. These are passed on to the AddQuest function.