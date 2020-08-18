local addon, tbl = ...;
local L = tbl.L;

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
		tbl.IgnoredItems = LastSeenIgnoredItemsDB
	else
		LastSeenIgnoredItemsDB = {
			{
				["itemType"] = "Consumable",
			},
			{
				["itemType"] = "Gem",
			},
			{
				["itemType"] = "INVTYPE_BAG",
			},
			{
				["itemType"] = "Item Enhancement",
			},
			{
				["itemType"] = "Junk",
			},
			{
				["itemType"] = "Key",
			},
			{
				["itemType"] = "Reagent",
			},
			{
				["itemType"] = "Tradeskill",
			},
			[11736] 		= "Libram of Resilience",
			[21218] 		= "Blue Qiraji Resonating Crystal",
			[21321] 		= "Red Qiraji Resonating Crystal",
			[21323] 		= "Green Qiraji Resonating Crystal",
			[21324] 		= "Yellow Qiraji Resonating Crystal",
			[137642]		= "Mark of Honor",
			[141605] 		= "Flight Master's Whistle",
			[143785]		= "Tome of the Tranquil Mind",
			[163611]		= "Seafarer's Coin Pouch",
			[163612]		= "Wayfinder's Satchel",
			[163613]		= "Sack of Plunder",
			[166846]		= "Spare Parts",
			[168416]		= "Anglers' Water Striders",
			[168822]		= "Thin Jelly",
			[168825]		= "Rich Jelly",
			[168828]		= "Purple Jelly",
			[171305]		= "Salvaged Cache of Goods",
			[173363]		= "Vessel of Horrific Visions",
			[174758]		= "Voidwarped Relic Fragment",
			[174759]		= "Mogu Relic Fragment",
		}
		tbl.IgnoredItems = LastSeenIgnoredItemsDB
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
			tbl.Settings["rarity"] = 1;
		end
		if tbl.Settings["scanOnLoot"] == nil then
			tbl.Settings["scanOnLoot"] = false;
		end
	else
		LastSeenSettingsCacheDB = {
			["mode"] = L["NORMAL_MODE"],
			["rarity"] = 1,
			["locale"] = "enUS",
			["lootFast"] = true,
			["scanOnLoot"] = false,
			["showSources"] = false,
			["isNeckFilterEnabled"] = false,
			["isRingFilterEnabled"] = false,
			["isTrinketFilterEnabled"] = false,
			["isQuestFilterEnabled"] = false,
		};
		tbl.Settings = LastSeenSettingsCacheDB;
	end
end