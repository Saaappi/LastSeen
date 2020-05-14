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
	L["ADDON_NAME"] = "|cff00ccff" .. addon .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. addon .. "|r";
	L["ADDON_NAME_HISTORY"] = "|cff00ccff" .. addon .. " History|r";
	L["RELEASE"] = GetAddOnMetadata(addon, "Version");
	if LOCALE == "enUS" then 
		L["DATE"] = date("%m/%d/%Y");
	else 
		L["DATE"] = date("%d/%m/%Y");
	end
	L["YES"] = "Accept";
	L["NO"] = "Decline";
	-- START AUCTION HOUSE SECTION --
	L["AUCTION_HOUSE"] = "Auction House";
	L["AUCTION_HOUSE_SOURCE"] = "Auction";
	L["AUCTION_WON_SUBJECT"] = "Auction won:";
	-- END AUCTION HOUSE SECTION --
	-- ITEM STATUSES
	L["TRUSTED"] = "Trusted";
	L["SUSPICIOUS"] = "Suspicious";
	L["UNTRUSTED"] = "Untrusted";
	-- COMMANDS
	L["ADD_CMD"] = "add";
	L["HISTORY"] = "history";
	L["IGNORE_CMD"] = "ignore";
	L["REMOVE_CMD"] = "remove";
	L["SEARCH_CMD"] = "search";
	L["LOCATION_CMD"] = "loc";
	L["LOOT_CMD"] = "loot";
	L["LOOT_FAST_CMD"] = "lootfast";
	L["REMOVED_CMD"] = "removed";
	L["SEARCH_OPTION_C"] = "c";
	L["SEARCH_OPTION_I"] = "i";
	L["SEARCH_OPTION_Q"] = "q";
	L["SEARCH_OPTION_Z"] = "z";
	-- CONSTANTS
	L["LOOT_ITEM_CREATED_SELF"] = "You create: ";
	L["LOOT_ITEM_PUSHED_SELF"] = "You receive item: ";
	L["LOOT_ITEM_SELF"] = "You receive loot: ";
	-- ERRORS
	L["BAD_DATA_FOUND"] = "Bad Data Found";
	L["DISCORD_REPORT"] = "Please report to the addon Discord!";
	L["ITEM_EXISTS"] = "Item exists!";
	L["ITEM_IGNORED_BY_SYSTEM_OR_PLAYER"] = "That item is ignored by System or player. Try /last remove itemID.";
	L["NO_ITEMS_FOUND"] = "No items found!";
	L["NO_QUEST_LINK"] = "Quest link not found! ";
	L["NO_QUESTS_COMPLETED"] = "No quests have been completed on this account.";
	L["NO_QUESTS_FOUND"] = "No quests found!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Unable to complete that action! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Unable to determine source of loot for ";
	L["GENERAL_FAILURE"] = "General Failure";
	-- INFO
	L["ADDED_ITEM"] = "Added ";
	L["BAD_DATA_ITEM_COUNT_TEXT1"] = "Bad or ignored data detected. ";
	L["BAD_DATA_ITEM_COUNT_TEXT2"] = " item(s) removed.";
	L["COMING_SOON_TEXT"] = "Coming Soon!";
	L["IGNORE_ITEM"] = "Ignoring ";
	L["!IGNORE_ITEM"] = "Stopped ignoring ";
	L["LOAD_SUCCESSFUL"] = "All settings loaded successfully!";
	L["LOOT_FAST_ENABLED"] = " Loot Fast mode enabled.";
	L["LOOT_FAST_DISABLED"] = " Loot Fast mode disabled.";
	L["MATCHED_TERM"] = " matching ";
	L["NEVER_LOOTED"] = "Never Looted";
	L["RECORDS_FOUND"] = " record(s) found.";
	L["REMOVE_ITEM"] = "Removed ";
	L["REMOVED_ITEMS_ANNOUNCEMENT_TEXT"] = "Removed Items";
	L["UPDATED_ITEM"] = "Updated ";
	-- ITEM SOURCES
	L["IS_OBJECT"] = "Object";
	L["IS_GEM"] = "Gem";
	L["IS_MISCELLANEOUS"] = "Miscellaneous";
	L["IS_CONSUMABLE"] = "Consumable";
	L["IS_QUEST_ITEM"] = "Quest";
	L["IS_TRADESKILL_ITEM"] = "Tradeskill";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Creature";
	L["IS_PLAYER"] = "Player";
	L["IS_NPC"] = "npc";
	L["IS_VEHICLE"] = "Vehicle";
	-- SPELLS
	L["OPENING"] = "Opening";
	-- SOURCES
	L["MAIL"] = "Mail";
	L["OBJECT"] = "Object: ";
	L["QUEST"] = "Quest: ";
	-- OPTIONS INTERFACE
		-- START TABS SECTION --
		L["SETTINGS_TAB_GENERAL"] = "General";
		L["SETTINGS_TAB_SHARE"] = "Share";
		-- START GENERAL SECTION --
		L["ITEMS_SEEN"] = "Items Seen: ";
		L["RANK"] = "Rank: ";
		-- END GENERAL SECTION -- 
		-- START SHARE SECTION --
		L["ITEM_ID_LABEL"] = "(|cff00ccffItem ID|r)";
		L["CHARACTER_NAME_LABEL"] = "(|cff00ccffCharacter Name|r)";
		L["REALM_NAME_LABEL"] = "(|cff00ccffRealm Name|r)";
		L["SEND_BUTTON_LABEL"] = "Send";
		L["CLEAR_BUTTON_LABEL"] = "Clear";
		-- END SHARE SECTION --
		-- START MODES SECTION --
		L["VERBOSE_MODE"] = "Verbose";
		L["NORMAL_MODE"] = "Normal";
		L["QUIET_MODE"] = "Quiet";
		-- END MODES SECTION --
		-- START MODE DESCRIPTIONS SECTION --
		L["VERBOSE_MODE_DESC"] = "This mode will output all information including added items, updated items, and the items seen counter.\n";
		L["NORMAL_MODE_DESC"] = "This mode will output new and updated items.\n";
		L["QUIET_MODE_DESC"] = "No output. SILENCE!\n";
		-- END MODE DESCRIPTIONS SECTION --
		-- START RARITIES SECTION --
		L["ARTIFACT"] = "|cffe6cc80" .. "Artifact|r";
		L["LEGENDARY"] = "|cffff8000" .. "Legendary|r";
		L["EPIC"] = "|cffa335ee" .. "Epic|r";
		L["RARE"] = "|cff0070dd" .. "Rare|r";
		L["UNCOMMON"] = "|cff1eff00" .. "Uncommon|r";
		L["COMMON"] = "|cffffffff" .. "Common|r";
		L["POOR"] = "|cff9d9d9d" .. "Poor|r";
		-- END RARITIES SECTION --
		-- START RARE SOUND SECTION --
		L["DEFAULT_SOUND"] = "Default";
		L["CTHUN_SOUND"] = "C'Thun";
		L["RAGNAROS_SOUND"] = "Ragnaros";
		L["ARGUS_SOUND"] = "Argus";
		-- END RARE SOUND SECTION --
		-- OPTIONS
		L["OPTIONS_DISABLE_RARESOUND"] = "Disable Rare Sound";
		L["OPTIONS_DISABLE_RARESOUND_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_RARESOUND"] .. "|r\nDisables the audio whenever a rare is spotted. However, the message is still printed to the chat window.";
		L["OPTIONS_DISABLE_IGNORES"] = "Disable All Ignores";
		L["OPTIONS_DISABLE_IGNORES_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_IGNORES"] .. "|r\nDisables all ignore checks performed by the System. Enabling and disabling this option will purge ignored items.";
		L["OPTIONS_AUTO_MARKER"] = "Disable Auto Mark";
		L["OPTIONS_AUTO_MARKER_TEXT"] = "|cffffffff" .. L["OPTIONS_AUTO_MARKER"] .. "|r\nDisables the use of the skull raid target marker.";
		L["OPTIONS_FASTER_LOOT"] = "Faster Loot";
		L["OPTIONS_FASTER_LOOT_TEXT"] = "|cffffffff" .. L["OPTIONS_FASTER_LOOT"] .. "|r\nInforms the addon to loot items quicker than normal.";
		L["OPTIONS_ENABLE_FASTERLOOT_CONFIRM"] = "Are you sure you wish to enable " .. L["OPTIONS_FASTER_LOOT"] .. "? This may impact game performance.";
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
		"Teleport to Dark Portal, Blasted Lands",
	};
return end;