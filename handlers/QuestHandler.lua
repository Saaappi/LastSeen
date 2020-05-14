local addon, addonTbl = ...;
local L = addonTbl.L;
local select = select;

local itemName;
local itemRarity;
local itemID;
local itemType;
local itemIcon;
local questTitle;

addonTbl.AddQuest = function(questID, currentDate)
	local questLink = GetQuestLink(questID);
	
	if LastSeenQuestsDB[questID] then
		LastSeenQuestsDB[questID]["lastCompleted"] = currentDate;
	else
		LastSeenQuestsDB[questID] = {questTitle = questTitle, lastCompleted = currentDate, questLink = questLink};
	end
end

addonTbl.GetQuestInfo = function(questIndex)
	questTitle = (GetQuestLogTitle(questIndex));
	local questID = select(8, GetQuestLogTitle(questIndex));
	addonTbl.AddQuest(questID, addonTbl.currentDate);
end