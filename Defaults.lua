local addon, tbl = ...;

tbl.SetDefaults = function()
	if LastSeenCreaturesDB and LastSeenCreaturesDB ~= nil then
		tbl.Creatures = LastSeenCreaturesDB
	else
		LastSeenCreaturesDB = {}
		tbl.Creatures = LastSeenCreaturesDB
	end
	if LastSeenEncountersDB and LastSeenEncountersDB ~= nil then
		tbl.Encounters = LastSeenEncountersDB
	else
		LastSeenEncountersDB = {}
		tbl.Encounters = LastSeenEncountersDB
	end
	if LastSeenHistoryDB and LastSeenHistoryDB ~= nil then
		tbl.History = LastSeenHistoryDB
	else
		LastSeenHistoryDB = {}
		tbl.History = LastSeenHistoryDB
	end
	if LastSeenIgnoredItemsDB and LastSeenIgnoredItemsDB ~= nil then
		-- Do nothing, for now...
	else
		LastSeenIgnoredItemsDB = {}
	end
	if LastSeenItemsDB and LastSeenItemsDB ~= nil then
		tbl.Items = LastSeenItemsDB
	else
		LastSeenItemsDB = {}
		tbl.Items = LastSeenItemsDB
	end
	if LastSeenLootTemplate and LastSeenLootTemplate ~= nil then
		tbl.LootTemplate = LastSeenLootTemplate
	else
		LastSeenLootTemplate = {}
		tbl.LootTemplate = LastSeenLootTemplate
	end
	if LastSeenMapsDB and LastSeenMapsDB ~= nil then
		tbl.Maps = LastSeenMapsDB
	else
		LastSeenMapsDB = {}
		tbl.Maps = LastSeenMapsDB
	end
	if LastSeenQuestsDB and LastSeenQuestsDB ~= nil then
		tbl.Quests = LastSeenQuestsDB
	else
		LastSeenQuestsDB = {}
		tbl.Quests = LastSeenQuestsDB
	end
	if LastSeenSettingsCacheDB then
		tbl.Settings = LastSeenSettingsCacheDB;
		if tbl.Settings["rarity"] ~= 1 then
			tbl.Settings["rarity"] = 1
		end
		if tbl.Settings["scanOnLoot"] == nil then
			tbl.Settings["scanOnLoot"] = false
		end
		if tbl.Settings["scanQuestRewardsOnHover"] == nil then
			tbl.Settings["scanQuestRewardsOnHover"] = false
		end
	else
		LastSeenSettingsCacheDB = {
			["mode"] = tbl.L["NORMAL_MODE"],
			["rarity"] = 1,
			["locale"] = "enUS",
			["lootFast"] = true,
			["scanOnLoot"] = false,
			["showSources"] = false,
			["scanQuestRewardsOnHover"] = false,
			["isNeckFilterEnabled"] = false,
			["isRingFilterEnabled"] = false,
			["isTrinketFilterEnabled"] = false,
			["isQuestFilterEnabled"] = false,
		};
		tbl.Settings = LastSeenSettingsCacheDB
	end
end