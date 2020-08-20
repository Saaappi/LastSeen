local addon, tbl = ...

tbl.SetLocale = function(locale)
	if tbl.Settings then -- When the user calls the command, this will exist
		tbl.Settings["locale"] = locale
	end
	if locale == "enUS" then
		tbl.L = {
			["ADDED"]									= "Added";
			["ADDON_LOADED_SUCCESSFULLY"] 				= "Loaded successfully!";
			["ADDON_NAME"] 								= "|cff00ccff" .. addon .. "|r: ";
			["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
			["APPROXIMATELY"] 							= "approximately";
			["AUCTION_HOUSE"]							= "Auction House";
			["AUCTION_WON_SUBJECT"]						= "Auction won:";
			["BAD_DATA_SINGLE"]							= " cffffdc14item purged from the items table due to corrupt information or it's been ignored.|r";
			["BAD_DATA_MULTIPLE"]						= " cffffdc14item(s) purged from the items table due to corrupt information or they're now ignored.|r";
			["BAD_REQUEST"]								= "cffffdc14Bad request. Please try again.|r";
			["COMMAND_FORMAT"]							= "format";
			["COMMAND_HISTORY"] 						= "history";
			["COMMAND_LOCALE"]							= "locale";
			["COMMAND_LOOT"] 							= "loot";
			["COMMAND_PROGRESS"]						= "progress";
			["COMMAND_REMOVE"] 							= "remove";
			["COMMAND_REMOVE_SHORT"] 					= "rm";
			["COMMAND_SEARCH"] 							= "search";
			["COMMAND_SLASH1"]							= "/ls";
			["COMMAND_SLASH2"]							= "/lastseen";
			["COMMAND_VIEW"] 							= "view";
			["CREATURE"] 								= "Creature";
			["DATE"]									= date("%m/%d/%Y");
			["DEBUG"] 									= "Debug";
			["DESCRIPTION_FILTER_NECK"]					= "Tells the addon to track or ignore necklaces. Check to track or uncheck to ignore.";
			["DESCRIPTION_FILTER_QUEST"]				= "Tells the addon to track or ignore quest items. Check to track or uncheck to ignore.";
			["DESCRIPTION_FILTER_RING"]					= "Tells the addon to track or ignore rings. Check to track or uncheck to ignore.";
			["DESCRIPTION_FILTER_TRINKET"]				= "Tells the addon to track or ignore trinkets. Check to track or uncheck to ignore.";
			["DESCRIPTION_MODE_DEBUG"]					= "|cffffffffDebug|r: Normal mode, but also shows variable content for debugging.";
			["DESCRIPTION_MODE_NORMAL"]					= "|cffffffffNormal|r: Lets the player know when items are added or updated.";
			["DESCRIPTION_MODE_SILENT"]					= "|cffffffffSilent|r: This mode won't share any information with the player. Does *NOT* affect tracking.";
			["DESCRIPTION_SCAN_ON_LOOT1"]				= "Consider bonus IDs as items are looted.";
			["DESCRIPTION_SCAN_ON_LOOT2"]				= "This option will not remove variants like \"of the Fireflash\" from item links or names.";
			["DESCRIPTION_SHOW_SOURCES"]				= "If an item has been seen from more than one source, checking this button\nwill tell you how many and display up to 4 of the other sources.";
			["ERR_JOIN_SINGLE_SCENARIO_S"]				= "You have joined the queue for Island Expeditions.";
			["FILTERS"]									= "Filters";
			["INVALID_GUID_OR_UNITNAME"]				= "cffffdc14Invalid GUID or unit name detected.|r";
			["ISLAND_EXPEDITIONS"]						= "Island Expeditions";
			["KEYBIND_OPEN_SETTINGS"]					= "Open Settings";
			["LOOT_FAST_DISABLED"] 						= "Loot Fast mode disabled.";
			["LOOT_FAST_ENABLED"] 						= "Loot Fast mode enabled.";
			["LOOT_ITEM_PUSHED_SELF"] 					= "You receive item: ";
			["LOOT_ITEM_SELF"] 							= "You receive loot: ";
			["MALFORMED_ITEM_LINK"]						= "cffffdc14A malformed item link was detected.|r";
			["NECK"]									= "Neck";
			["NO_ITEMS_FOUND"]							= "cffffdc14No item(s) found.|r";
			["NO_QUEUE"]								= "You are no longer queued.";
			["NORMAL"] 									= "Normal";
			["OF"] 										= "of";
			["PLAYER"] 									= "Player";
			["QUEST"]									= "Quest";
			["QUESTS"]									= "Quests";
			["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "]";
			["REMOVED"]									= "Removed";
			["RESULTS"]									= " result(s)";
			["RINGS"]									= "Rings";
			["SCAN_ON_LOOT"] 							= "Scan on Loot";
			["SEEN_FROM"]								= "Seen from ";
			["SHOW_SOURCES"]							= "Show Sources";
			["SILENT"] 									= "Silent";
			["SOURCES"] 								= "sources";
			["THIS_ITEM_IS_IGNORED"]					= "This item is ignored.";
			["TRINKETS"]								= "Trinkets";
			["UNKNOWN"]									= "Unknown";
			["UNKNOWN_SOURCE"]							= " |cffffdc14was looted from an unknown source.|r";
			["UPDATED"]									= "Updated";
			["VEHICLE"] 								= "Vehicle";
			["Z_SPELL_NAMES"] = {
				{
					["spellName"] 						= "Collecting",
				},						
				{						
					["spellName"] 						= "Fishing",
				},						
				{						
					["spellName"] 						= "Frisking Toga",
				},						
				{						
					["spellName"] 						= "Herb Gathering",
				},						
				{						
					["spellName"] 						= "Looting",
				},						
				{						
					["spellName"] 						= "Mining",
				},						
				{						
					["spellName"] 						= "Opening",
				},						
				{						
					["spellName"] 						= "Skinning",
				},						
				{						
					["spellName"] 						= "Survey",
				},
			};
		}
	elseif locale == "enGB" then
		tbl.L = {
			["ADDED"]									= "Added";
			["ADDON_LOADED_SUCCESSFULLY"] 				= "Loaded successfully!";
			["ADDON_NAME"] 								= "|cff00ccff" .. addon .. "|r: ";
			["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
			["APPROXIMATELY"]							= "approximately";
			["AUCTION_HOUSE"]							= "Auction House";
			["AUCTION_WON_SUBJECT"]						= "Auction won:";
			["BAD_DATA_SINGLE"]							= " cffffdc14item purged from the items table due to corrupt information or it's been ignored.|r";
			["BAD_DATA_MULTIPLE"]						= " cffffdc14item(s) purged from the items table due to corrupt information or they're now ignored.|r";
			["BAD_REQUEST"]								= "cffffdc14Bad request. Please try again.|r";
			["COMMAND_FORMAT"]							= "format";
			["COMMAND_HISTORY"] 						= "history";
			["COMMAND_LOCALE"]							= "locale";
			["COMMAND_LOOT"] 							= "loot";
			["COMMAND_PROGRESS"]						= "progress";
			["COMMAND_REMOVE"] 							= "remove";
			["COMMAND_REMOVE_SHORT"] 					= "rm";
			["COMMAND_SEARCH"] 							= "search";
			["COMMAND_SLASH1"]							= "/ls";
			["COMMAND_SLASH2"]							= "/lastseen";
			["COMMAND_VIEW"] 							= "view";
			["CREATURE"] 								= "Creature";
			["DATE"]									= date("%d/%m/%Y");
			["DEBUG"] 									= "Debug";
			["DESCRIPTION_FILTER_NECK"]					= "Tells the addon to track or ignore necklaces. Check to track or uncheck to ignore.";
			["DESCRIPTION_FILTER_QUEST"]				= "Tells the addon to track or ignore quest items. Check to track or uncheck to ignore.";
			["DESCRIPTION_FILTER_RING"]					= "Tells the addon to track or ignore rings. Check to track or uncheck to ignore.";
			["DESCRIPTION_FILTER_TRINKET"]				= "Tells the addon to track or ignore trinkets. Check to track or uncheck to ignore.";
			["DESCRIPTION_MODE_DEBUG"]					= "|cffffffffDebug|r: Normal mode, but also shows variable content for debugging.";
			["DESCRIPTION_MODE_NORMAL"]					= "|cffffffffNormal|r: Lets the player know when items are added or updated.";
			["DESCRIPTION_MODE_SILENT"]					= "|cffffffffSilent|r: This mode won't share any information with the player. Does *NOT* affect tracking.";
			["DESCRIPTION_SCAN_ON_LOOT1"]				= "Consider bonus IDs as items are looted.";
			["DESCRIPTION_SCAN_ON_LOOT2"]				= "This option will not remove variants like \"of the Fireflash\" from item links or names.";
			["DESCRIPTION_SHOW_SOURCES"]				= "If an item has been seen from more than one source, checking this button\nwill tell you how many and display up to 4 of the other sources.";
			["ERR_JOIN_SINGLE_SCENARIO_S"]				= "You have joined the queue for Island Expeditions.";
			["FILTERS"]									= "Filters";
			["INVALID_GUID_OR_UNITNAME"]				= "cffffdc14Invalid GUID or unit name detected.|r";
			["ISLAND_EXPEDITIONS"]						= "Island Expeditions";
			["KEYBIND_OPEN_SETTINGS"]					= "Open Settings";
			["LOOT_FAST_DISABLED"] 						= "Loot Fast mode disabled.";
			["LOOT_FAST_ENABLED"] 						= "Loot Fast mode enabled.";
			["LOOT_ITEM_PUSHED_SELF"] 					= "You receive item: ";
			["LOOT_ITEM_SELF"] 							= "You receive loot: ";
			["MALFORMED_ITEM_LINK"]						= "cffffdc14A malformed item link was detected.|r";
			["NECK"]									= "Neck";
			["NO_ITEMS_FOUND"]							= "cffffdc14No item(s) found.|r";
			["NO_QUEUE"]								= "You are no longer queued.";
			["NORMAL"] 									= "Normal";
			["OF"]										= "of";
			["PLAYER"] 									= "Player";
			["QUEST"]									= "Quest";
			["QUESTS"]									= "Quests";
			["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "]";
			["REMOVED"]									= "Removed";
			["RESULTS"]									= " result(s)";
			["RINGS"]									= "Rings";
			["SCAN_ON_LOOT"] 							= "Scan on Loot";
			["SEEN_FROM"]								= "Seen from ";
			["SHOW_SOURCES"]							= "Show Sources";
			["SILENT"] 									= "Silent";
			["SOURCES"] 								= "sources";
			["THIS_ITEM_IS_IGNORED"]					= "This item is ignored.";
			["TRINKETS"]								= "Trinkets";
			["UNKNOWN"]									= "Unknown";
			["UNKNOWN_SOURCE"]							= " |cffffdc14was looted from an unknown source.|r";
			["UPDATED"]									= "Updated";
			["VEHICLE"] 								= "Vehicle";
			["Z_SPELL_NAMES"] = {
				{
					["spellName"] 						= "Collecting",
				},						
				{						
					["spellName"] 						= "Fishing",
				},						
				{						
					["spellName"] 						= "Frisking Toga",
				},						
				{						
					["spellName"] 						= "Herb Gathering",
				},						
				{						
					["spellName"] 						= "Looting",
				},						
				{						
					["spellName"] 						= "Mining",
				},						
				{						
					["spellName"] 						= "Opening",
				},						
				{						
					["spellName"] 						= "Skinning",
				},						
				{						
					["spellName"] 						= "Survey",
				},
			};
		}
	end
end

tbl.SetLocale("enUS")