--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: The powerhouse of all of the addon's localization.
]]--

local lastSeen, lastSeenNS = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

lastSeenNS.L = L;

local LOCALE = GetLocale();

if LOCALE == "enUS" or LOCALE == "enGB" then -- EU/US English
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "15 May, 2019";
	-- COMMANDS
	L["ADD"] = "add";
	L["IGNORE"] = "ignore";
	L["REMOVE"] = "remove";
	L["SEARCH"] = "search";
	L["SEARCH_OPTION_C"] = "c";
	L["SEARCH_OPTION_I"] = "i";
	L["SEARCH_OPTION_Q"] = "q";
	L["SEARCH_OPTION_Z"] = "z";
	-- CONSTANTS
	L["LOOT_ITEM_CREATED_SELF"] = "You create";
	L["LOOT_ITEM_PUSHED_SELF"] = "You receive item";
	L["LOOT_ITEM_SELF"] = "You receive loot";
	-- ERRORS
	L["BAD_DATA_FOUND"] = "Bad Data Found";
	L["DISCORD_REPORT"] = "Please report to the LastSeen Discord!";
	L["ITEM_EXISTS"] = "Item exists!";
	L["NO_ITEMS_FOUND"] = "No items found!";
	L["NO_QUESTS_COMPLETED"] = "No quests have been completed on this account.";
	L["NO_QUESTS_FOUND"] = "No quests found!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Unable to complete that action! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Unable to determine source of loot. ";
	-- INFO
	L["ADDED_ITEM"] = "Added ";
	L["IGNORE_ITEM"] = "Ignoring ";
	L["!IGNORE_ITEM"] = "Stopped ignoring ";
	L["MATCHED_TERM"] = " matching ";
	L["NEVER_LOOTED"] = "Never Looted";
	L["NEW_LOCATION"] = "Different Map";
	L["NEW_LOOT_DATE"] = "Newer Date";
	L["NEW_SOURCE"] = "Different Source";
	L["REASON"] = "Reason: ";
	L["RECORDS_FOUND"] = " records found.";
	L["REMOVE_ITEM"] = "Removed ";
	L["UPDATED_ITEM"] = "Updated ";
	-- ITEM TYPES
	L["IS_CRAFTED_ITEM"] = "Crafted";
	L["IS_TRADESKILL_ITEM"] = "Tradeskill";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Creature";
	L["IS_PLAYER"] = "player";
	L["IS_VEHICLE"] = "Vehicle";
	-- MODES
	L["MODE"] = "Mode";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Quiet";
	-- RARITIES
	L["RARITY"] = "Rarity";
	L["LEGENDARY"] = "|cffff8000" .. "Legendary|r";
	L["EPIC"] = "|cffa335ee" .. "Epic|r";
	L["RARE"] = "|cff0070dd" .. "Rare|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Uncommon|r";
	L["COMMON"] = "|cffffffff" .. "Common|r";
	L["POOR"] = "|cff9d9d9d" .. "Poor|r";
	-- SPELLS
	L["OPENING"] = "Opening";
	-- SOURCES
	L["AUCTION"] = "|cffFFA533" .. "Auction" .. "|r";
	L["MAIL"] = "|cffFFA533" .. "Mail" .. "|r";
	L["TRADE"] = "|cffFFA533" .. "Trade" .. "|r";
	-- OTHER
	L["ITEMS_SEEN"] = "Items Seen";
	L["WON"] = "won";
return end;

if LOCALE == "frFR" then -- French
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "15 Mai 2019";
	-- COMMANDS
	L["ADD"] = "ajouter";
	L["IGNORE"] = "ignorer";
	L["REMOVE"] = "retirer";
	L["SEARCH"] = "chercher";
	L["SEARCH_OPTION_C"] = "c";
	L["SEARCH_OPTION_I"] = "je";
	L["SEARCH_OPTION_Q"] = "q";
	L["SEARCH_OPTION_Z"] = "z";
	-- CONSTANTS
	L["LOOT_ITEM_CREATED_SELF"] = "Tu crées";
	L["LOOT_ITEM_PUSHED_SELF"] = "Vous recevez l'article";
	L["LOOT_ITEM_SELF"] = "Vous recevez du butin";
	-- ERRORS
	L["BAD_DATA_FOUND"] = "Données Erronées Trouvées";
	L["DISCORD_REPORT"] = "S'il vous plaît rapport à la LastSeen Discord!";
	L["ITEM_EXISTS"] = "L'article existe!";
	L["NO_ITEMS_FOUND"] = "Aucun élément trouvé!";
	L["NO_QUESTS_COMPLETED"] = "Aucune quête n'a été effectuée sur ce compte.";
	L["NO_QUESTS_FOUND"] = "Aucune quête trouvée!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Impossible de terminer cette action! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Impossible de déterminer la source du butin. ";
	-- INFO
	L["ADDED_ITEM"] = "Ajoutée ";
	L["IGNORE_ITEM"] = "En ignorant ";
	L["!IGNORE_ITEM"] = "Cessé d'ignorer ";
	L["MATCHED_TERM"] = " correspondant à ";
	L["NEVER_LOOTED"] = "Jamais Pillé";
	L["NEW_LOCATION"] = "Carte Différente";
	L["NEW_LOOT_DATE"] = "Date plus récente";
	L["NEW_SOURCE"] = "Source différente";
	L["REASON"] = "Raison: ";
	L["RECORDS_FOUND"] = " enregistrements trouvés.";
	L["REMOVE_ITEM"] = "Enlevé ";
	L["UPDATED_ITEM"] = "Mis à jour ";
	-- ITEM TYPES
	L["IS_CRAFTED_ITEM"] = "Fabriqué";
	L["IS_TRADESKILL_ITEM"] = "Artisanat";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Créature";
	L["IS_PLAYER"] = "joueur";
	L["IS_VEHICLE"] = "Véhicule";
	-- MODES
	L["MODE"] = "Mode";
	L["NORMAL_MODE"] = "Ordinaire";
	L["QUIET_MODE"] = "Silencieux";
	-- RARITIES
	L["RARITY"] = "Rareté";
	L["LEGENDARY"] = "|cffff8000" .. "Légendaire|r";
	L["EPIC"] = "|cffa335ee" .. "Épique|r";
	L["RARE"] = "|cff0070dd" .. "Rare|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Uncommon|r";
	L["COMMON"] = "|cffffffff" .. "Commun|r";
	L["POOR"] = "|cff9d9d9d" .. "Pauvre|r";
	-- SOURCES
	L["AUCTION"] = "Enchères";
	L["MAIL"] = "Courrier";
	L["TRADE"] = "Commerce";
	-- OTHER
	L["ITEMS_SEEN"] = "Articles vus";
	L["WON"] = "a gagné";
return end;

if LOCALE == "deDE" then -- German
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "15. Mai 2019";
	-- COMMANDS
	L["ADD"] = "hinzufügen";
	L["IGNORE"] = "ignorieren";
	L["REMOVE"] = "löschen";
	L["SEARCH"] = "suche";
	L["SEARCH_OPTION_C"] = "c";
	L["SEARCH_OPTION_I"] = "ich";
	L["SEARCH_OPTION_Q"] = "q";
	L["SEARCH_OPTION_Z"] = "z";
	-- CONSTANTS
	L["LOOT_ITEM_CREATED_SELF"] = "Du erschaffst";
	L["LOOT_ITEM_PUSHED_SELF"] = "Sie erhalten einen artikel";
	L["LOOT_ITEM_SELF"] = "Sie erhalten beute";
	-- ERRORS
	L["BAD_DATA_FOUND"] = "Fehlerhafte Daten Gefunden";
	L["DISCORD_REPORT"] = "Bitte melde dich beim LastSeen Discord!";
	L["ITEM_EXISTS"] = "Artikel existiert!";
	L["NO_ITEMS_FOUND"] = "Keine elemente gefunden!";
	L["NO_QUESTS_COMPLETED"] = "Für dieses konto wurden keine quests abgeschlossen.";
	L["NO_QUESTS_FOUND"] = "Keine quests gefunden!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Diese aktion kann nicht abgeschlossen werden! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Die Quelle der Beute konnte nicht ermittelt werden! ";
	-- INFO
	L["ADDED_ITEM"] = "Hinzugefügt ";
	L["IGNORE_ITEM"] = "Ignorieren ";
	L["!IGNORE_ITEM"] = "Ich hörte auf zu ignorieren ";
	L["MATCHED_TERM"] = " passend ";
	L["NEVER_LOOTED"] = "Niemals Geplündert";
	L["NEW_LOCATION"] = "Unterschiedliche Karte";
	L["NEW_LOOT_DATE"] = "Newer Date";
	L["NEW_SOURCE"] = "Neueres Datum";
	L["REASON"] = "Grund: ";
	L["RECORDS_FOUND"] = " Datensätze gefunden.";
	L["REMOVE_ITEM"] = "Entfernt ";
	L["UPDATED_ITEM"] = "Aktualisierte ";
	-- ITEM TYPES
	L["IS_CRAFTED_ITEM"] = "Handarbeit";
	L["IS_TRADESKILL_ITEM"] = "Handelsfertigkeit";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Kreatur";
	L["IS_PLAYER"] = "Spieler";
	L["IS_VEHICLE"] = "Fahrzeug";
	-- MODES
	L["MODE"] = "Modus";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Ruhig";
	-- RARITIES
	L["RARITY"] = "Seltenheit";
	L["LEGENDARY"] = "|cffff8000" .. "Legendär|r";
	L["EPIC"] = "|cffa335ee" .. "Epos|r";
	L["RARE"] = "|cff0070dd" .. "Selten|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Ungewöhnlich|r";
	L["COMMON"] = "|cffffffff" .. "Verbreitet|r";
	L["POOR"] = "|cff9d9d9d" .. "Arm|r";
	-- SOURCES
	L["AUCTION"] = "Versteigerung";
	L["MAIL"] = "Mail";
	L["TRADE"] = "Handel";
	-- OTHER
	L["ITEMS_SEEN"] = "Artikel Gesehen";
	L["WON"] = "gewonnen";
return end;