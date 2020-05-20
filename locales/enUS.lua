local addon, addonTbl = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

addonTbl.L = L;

local LOCALE = GetLocale();

if LOCALE == "enUS" then
	-- GENERAL
	L["ADDON_NAME"] 						= "|cff00ccff" .. addon .. "|r: ";
	L["ADDON_NAME_SETTINGS"] 				= "|cff00ccff" .. addon .. "|r";
	L["RELEASE"] 							= "[" .. GetAddOnMetadata(addon, "Version") .. "] ";
	if LOCALE == "enUS" then 
		L["DATE"] 							= date("%m/%d/%Y");
	else 
		L["DATE"] 							= date("%d/%m/%Y");
	end
	-- START AUCTION HOUSE SECTION --
	L["AUCTION_HOUSE"] 						= "Auction House";
	L["AUCTION_HOUSE_SOURCE"] 				= "Auction";
	L["AUCTION_WON_SUBJECT"] 				= "Auction won:";
	-- COMMANDS
	L["ADD_CMD"] 							= "add";
	L["HISTORY"] 							= "history";
	L["IGNORE_CMD"] 						= "ignore";
	L["REMOVE_CMD"] 						= "remove";
	L["SEARCH_CMD"] 						= "search";
	L["LOOT_CMD"] 							= "loot";
	L["REMOVED_CMD"] 						= "removed";
	L["SEARCH_OPTION_C"] 					= "c";
	L["SEARCH_OPTION_I"] 					= "i";
	L["SEARCH_OPTION_Q"] 					= "q";
	L["SEARCH_OPTION_Z"] 					= "z";
	-- CONSTANTS
	L["LOOT_ITEM_PUSHED_SELF"] 				= "You receive item: ";
	L["LOOT_ITEM_SELF"] 					= "You receive loot: ";
	-- ERROR MESSAGES
	L["ERROR_MSG_BAD_DATA"] 				= " item(s) removed due to missing or corrupt information.";
	L["ERROR_MSG_BAD_REQUEST"] 				= "Bad request. Please try again.";
	L["ERROR_MSG_CANT_ADD"] 				= "Can't add specified item.";
	L["ERROR_MSG_CANT_COMPLETE_REQUEST"] 	= "Can't complete request: ";
	L["ERROR_MSG_NO_ITEMS_FOUND"] 			= "No item(s) found.";
	L["ERROR_MSG_UNKNOWN_SOURCE"] 			= "Unknown source for ";
	-- INFORMATIONAL MESSAGES	
	L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 	= "Loaded successfully!";
	L["INFO_MSG_ITEM_ADDED"] 				= " successfully added.";
	L["INFO_MSG_ITEMS_FOUND"] 				= " item(s) found.";
	L["INFO_MSG_ITEM_IGNORED"] 				= " successfully ignored.";
	L["INFO_MSG_ITEM_REMOVED"] 				= " successfully removed.";
	L["INFO_MSG_ITEM_UNIGNORED"] 			= " successfully unignored.";
	L["INFO_MSG_LOOT_ENABLED"] 				= "Loot Fast mode enabled.";
	L["INFO_MSG_LOOT_DISABLED"] 			= "Loot Fast mode disabled.";
	L["INFO_MSG_MATCHING"] 					= " matching ";
	-- IGNORED ITEMTYPES		
	L["IS_GEM"] 							= "Gem";
	L["IS_QUEST_ITEM"] 						= "Quest";
	L["IS_TRADESKILL_ITEM"] 				= "Tradeskill";
	-- OBJECT TYPES		
	L["IS_CREATURE"] 						= "Creature";
	L["IS_PLAYER"] 							= "Player";
	L["IS_VEHICLE"] 						= "Vehicle";
	-- MODE NAMES --		
	L["DEBUG_MODE"] 						= "Debug";
	L["NORMAL_MODE"] 						= "Normal";
	L["QUIET_MODE"] 						= "Quiet";
	-- MODE DESCRIPTIONS --		
	L["DEBUG_MODE_DESC"] 					= "Same as normal, but variables are printed during loot operations.\n";
	L["NORMAL_MODE_DESC"] 					= "This mode will output new and updated items.\n";
	L["QUIET_MODE_DESC"] 					= "No output. SILENCE!\n";
	-- OTHER
	L["SPELL_NAMES"] = {
		"Collecting",
		"Fishing",
		"Frisking Toga",
		"Herb Gathering",
		"Looting",
		"Mining",
		"Opening",
		"Skinning",
		"Survey",
	};
return end;