local addon, addonTbl = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

local LOCALE = GetLocale();

if LOCALE == "enUS" then -- US English
	addonTbl.L = L;
	
	-- COMMANDS
	L["CMD_DISCORD"]							= "discord";
	L["CMD_HISTORY"] 							= "history";
	L["CMD_IMPORT"] 							= "import";
	L["CMD_LOOT"] 								= "loot";
	L["CMD_MAN"]								= "man";
	L["CMD_REMOVE"] 							= "remove";
	L["CMD_REMOVE_SHORT"] 						= "rm";
	L["CMD_SEARCH"] 							= "search";
	L["CMD_VIEW"] 								= "view";
	L["SLASH_CMD_1"]							= "/ls";
	L["SLASH_CMD_2"]							= "/lastseen";
	
	-- ERROR MESSAGES
	L["ERROR_MSG_BAD_DATA"] 					= " item(s) removed due to missing or corrupt information.";
	L["ERROR_MSG_BAD_REQUEST"] 					= "Bad request. Please try again.";
	L["ERROR_MSG_CANT_ADD"] 					= "Can't add specified item.";
	L["ERROR_MSG_CANT_COMPLETE_REQUEST"] 		= "Can't complete request: ";
	L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"]		= "Invalid GUID or unit name! Take a screenshot and report to Discord!";
	L["ERROR_MSG_NO_ITEMS_FOUND"] 				= "No item(s) found.";
	L["ERROR_MSG_UNKNOWN_SOURCE"] 				= " was looted from an unknown source. Its source has been set as Miscellaneous.";
	
	-- GENERAL
	L["ADDON_NAME"] 							= "|cff00ccff" .. addon .. "|r: ";
	L["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
	L["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "] ";
	L["DATE"]									= date("%m/%d/%Y");
	
	-- GLOBAL STRINGS
	L["AUCTION_HOUSE"]							= "Auction House";
	L["AUCTION_WON_SUBJECT"]					= "Auction won:";
	L["ERR_JOIN_SINGLE_SCENARIO_S"]				= "You have joined the queue for Island Expeditions.";
	L["ISLAND_EXPEDITIONS"]						= "Island Expeditions";
	L["LOOT_ITEM_PUSHED_SELF"] 					= "You receive item: ";
	L["LOOT_ITEM_SELF"] 						= "You receive loot: ";
	L["NO_QUEUE"]								= "You are no longer queued.";
	
	-- INFORMATIONAL MESSAGES
	L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "Loaded successfully!";
	L["INFO_MSG_IGNORED_ITEM"] 					= "This item is automatically ignored.";
	L["INFO_MSG_ITEM_REMOVED"] 					= " successfully removed.";
	L["INFO_MSG_LOOT_ENABLED"] 					= "Loot Fast mode enabled.";
	L["INFO_MSG_LOOT_DISABLED"] 				= "Loot Fast mode disabled.";
	L["INFO_MSG_MISCELLANEOUS"]					= "Miscellaneous";
	L["INFO_MSG_RESULTS"]						= " result(s)";
	
	-- MODE NAMES
	L["DEBUG_MODE"] 							= "Debug";
	L["NORMAL_MODE"] 							= "Normal";
	L["QUIET_MODE"] 							= "Quiet";
	
	-- MODE DESCRIPTIONS
	L["DEBUG_MODE_DESC"] 						= "Normal mode with variable output.\n";
	L["NORMAL_MODE_DESC"] 						= "Shows new and updated items.\n";
	L["QUIET_MODE_DESC"] 						= "No output!\n";
	
	-- OBJECT TYPES
	L["IS_CREATURE"] 							= "Creature";
	L["IS_PLAYER"] 								= "Player";
	L["IS_VEHICLE"] 							= "Vehicle";
	L["IS_UNKNOWN"]								= "Unknown";
	
	-- OTHER
	L["SPELL_NAMES"] = {
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
return end;