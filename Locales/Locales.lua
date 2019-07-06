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
	L["RELEASE_DATE"] = "25 June, 2019";
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
	L["ADD"] = "add";
	L["IGNORE"] = "ignore";
	L["REMOVE"] = "remove";
	L["SEARCH"] = "search";
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
	L["DISCORD_REPORT"] = "Please report to the LastSeen Discord!";
	L["ITEM_EXISTS"] = "Item exists!";
	L["ITEM_IGNORED_BY_SYSTEM_OR_PLAYER"] = "That item is ignored by System or player. Try /last remove itemID.";
	L["NO_ITEMS_FOUND"] = "No items found!";
	L["NO_QUEST_LINK"] = "Quest link not found.";
	L["NO_QUESTS_COMPLETED"] = "No quests have been completed on this account.";
	L["NO_QUESTS_FOUND"] = "No quests found!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Unable to complete that action! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Unable to determine source of loot for ";
	-- INFO
	L["ADDED_ITEM"] = "Added ";
	L["IGNORE_ITEM"] = "Ignoring ";
	L["!IGNORE_ITEM"] = "Stopped ignoring ";
	L["MATCHED_TERM"] = " matching ";
	L["NEVER_LOOTED"] = "Never Looted";
	L["RECORDS_FOUND"] = " records found.";
	L["REMOVE_ITEM"] = "Removed ";
	L["UPDATED_ITEM"] = "Updated ";
	L["BAD_DATA_ITEM_COUNT_TEXT1"] = "Oof! I found some items with bad data. I removed ";
	L["BAD_DATA_ITEM_COUNT_TEXT2"] = " item(s) for you.";
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
	-- OTHER
	L["ITEMS_SEEN"] = "Items Seen: ";
	-- OPTIONS INTERFACE
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
		-- OPTIONS
		L["OPTIONS_LABEL"] = "Options";
		L["OPTIONS_DISABLE_RARESOUND"] = "Disable Rare Sound";
		L["OPTIONS_DISABLE_RARESOUND_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_RARESOUND"] .. "|r\nDisables the audio whenever a rare is spotted. However, the message is still printed to the chat window.";
		L["OPTIONS_DISABLE_IGNORES"] = "Disable All Ignores";
		L["OPTIONS_DISABLE_IGNORES_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_IGNORES"] .. "|r\nDisables all ignore checks performed by the System. Enabling and disabling this option will purge ignored items.";
return end;

if LOCALE == "frFR" then -- French
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "25 Juin 2019";
	-- ITEM STATUSES
	L["TRUSTED"] = "De confiance";
	L["SUSPICIOUS"] = "Méfiant";
	L["UNTRUSTED"] = "Non approuvé";
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
	L["ITEM_IGNORED_BY_SYSTEM_OR_PLAYER"] = "Cet élément est ignoré par le système ou le joueur. Essayez /dernier supprimer itemID.";
	L["NO_ITEMS_FOUND"] = "Aucun élément trouvé!";
	L["NO_QUEST_LINK"] = "Lien de quête introuvable.";
	L["NO_QUESTS_COMPLETED"] = "Aucune quête n'a été effectuée sur ce compte.";
	L["NO_QUESTS_FOUND"] = "Aucune quête trouvée!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Impossible de terminer cette action! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Impossible de déterminer la source du butin pour ";
	-- INFO
	L["ADDED_ITEM"] = "Ajoutée ";
	L["IGNORE_ITEM"] = "En ignorant ";
	L["!IGNORE_ITEM"] = "Cessé d'ignorer ";
	L["MATCHED_TERM"] = " correspondant à ";
	L["NEVER_LOOTED"] = "Jamais Pillé";
	L["RECORDS_FOUND"] = " enregistrements trouvés.";
	L["REMOVE_ITEM"] = "Enlevé ";
	L["UPDATED_ITEM"] = "Mis à jour ";
	L["BAD_DATA_ITEM_COUNT_TEXT1"] = "Oof! J'ai trouvé des articles avec de mauvaises données. j'ai enlevé ";
	L["BAD_DATA_ITEM_COUNT_TEXT2"] = " article(s) pour vous.";
	-- ITEM SOURCES
	L["IS_OBJECT"] = "Objet";
	L["IS_GEM"] = "Gemme";
	L["IS_MISCELLANEOUS"] = "Divers";
	L["IS_CONSUMABLE"] = "Consommable";
	L["IS_QUEST_ITEM"] = "Quête";
	L["IS_TRADESKILL_ITEM"] = "Artisanat";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Créature";
	L["IS_PLAYER"] = "joueur";
	L["IS_NPC"] = "npc";
	L["IS_VEHICLE"] = "Véhicule";
	-- SOURCES
	L["AUCTION"] = "Enchères";
	L["MAIL"] = "Courrier";
	L["OBJECT"] = "Objet: ";
	L["QUEST"] = "Quête: ";
	-- OTHER
	L["ITEMS_SEEN"] = "Articles vus: ";
	L["AUCTION_WON"] = "Enchère gagnée:";
	-- OPTIONS INTERFACE
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
		-- OPTIONS
		L["OPTIONS_LABEL"] = "Les Options";
		L["OPTIONS_DISABLE_RARESOUND"] = "Désactiver le Son Rare";
		L["OPTIONS_DISABLE_RARESOUND_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_RARESOUND"] .. "|r\nDésactive l'audio chaque fois qu'un rare est repéré. Cependant, le message est toujours imprimé dans la fenêtre de discussion.";
		L["OPTIONS_DISABLE_IGNORES"] = "Désactiver tout ignore";
		L["OPTIONS_DISABLE_IGNORES_TEXT"] = "Désactivez toutes les vérifications ignorées par le système afin que celui-ci n'adhère qu'au filtre de rareté.";
return end;

if LOCALE == "deDE" then -- German
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "25. Juni 2019";
	-- ITEM STATUSES
	L["TRUSTED"] = "Vertrauenswürdige";
	L["SUSPICIOUS"] = "Verdächtig";
	L["UNTRUSTED"] = "Nicht vertrauenswürdig";
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
	L["ITEM_IGNORED_BY_SYSTEM_OR_PLAYER"] = "Dieser Gegenstand wird vom System oder vom Spieler ignoriert. Versuchen /letzte löschen itemID.";
	L["NO_ITEMS_FOUND"] = "Keine elemente gefunden!";
	L["NO_QUEST_LINK"] = "Questlink nicht gefunden.";
	L["NO_QUESTS_COMPLETED"] = "Für dieses konto wurden keine quests abgeschlossen.";
	L["NO_QUESTS_FOUND"] = "Keine quests gefunden!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Diese aktion kann nicht abgeschlossen werden! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Die Quelle für die Beute konnte nicht ermittelt werden ";
	-- INFO
	L["ADDED_ITEM"] = "Hinzugefügt ";
	L["IGNORE_ITEM"] = "Ignorieren ";
	L["!IGNORE_ITEM"] = "Ich hörte auf zu ignorieren ";
	L["MATCHED_TERM"] = " passend ";
	L["NEVER_LOOTED"] = "Niemals Geplündert";
	L["RECORDS_FOUND"] = " Datensätze gefunden.";
	L["REMOVE_ITEM"] = "Entfernt ";
	L["UPDATED_ITEM"] = "Aktualisierte ";
	L["BAD_DATA_ITEM_COUNT_TEXT1"] = "Oof! Ich habe einige Artikel mit schlechten Daten gefunden. Ich entfernte ";
	L["BAD_DATA_ITEM_COUNT_TEXT2"] = " artikel für sie.";
	-- ITEM SOURCES
	L["IS_OBJECT"] = "Objekt";
	L["IS_GEM"] = "Juwel";
	L["IS_MISCELLANEOUS"] = "Verschiedenes";
	L["IS_CONSUMABLE"] = "Verbrauchbar";
	L["IS_QUEST_ITEM"] = "Suche";
	L["IS_TRADESKILL_ITEM"] = "Handelsfertigkeit";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Kreatur";
	L["IS_PLAYER"] = "Spieler";
	L["IS_NPC"] = "npc";
	L["IS_VEHICLE"] = "Fahrzeug";
	-- SOURCES
	L["AUCTION"] = "Versteigerung";
	L["MAIL"] = "Mail";
	L["OBJECT"] = "Objekt: ";
	L["QUEST"] = "Suche: ";
	-- OTHER
	L["ITEMS_SEEN"] = "Artikel Gesehen: ";
	L["AUCTION_WON"] = "Auktion gewonnen:";
	-- OPTIONS INTERFACE
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
		-- OPTIONS INTERFACE
		L["OPTIONS_LABEL"] = "Optionen";
		L["OPTIONS_DISABLE_RARESOUND"] = "Seltener Ton Deaktivieren";
		L["OPTIONS_DISABLE_RARESOUND_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_IGNORES"] .. "|r\nDeaktiviert den Ton, wenn eine seltene entdeckt wird. Die Nachricht wird jedoch weiterhin in dem Chatfenster gedruckt.";
		L["OPTIONS_DISABLE_IGNORES"] = "Alle ignorieren deaktivieren";
		L["OPTIONS_DISABLE_IGNORES_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_IGNORES"] .. "|r\nDeaktiviert alle Ignorierprüfungen durch das System. Durch Aktivieren und Deaktivieren dieser Option werden ignorierte Elemente gelöscht.";
return end;
