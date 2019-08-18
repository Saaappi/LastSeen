--[[
	Project			: lastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-04-19
	Purpose			: The powerhouse of all of the addon's localization.
]]--

local lastSeen, LastSeenTbl = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

LastSeenTbl.L = L;

local LOCALE = GetLocale();

if LOCALE == "enUS" or LOCALE == "enGB" then -- EU/US English
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
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
	L["IGNORE_CMD"] = "ignore";
	L["REMOVE_CMD"] = "remove";
	L["SEARCH_CMD"] = "search";
	L["LOCATION_CMD"] = "loc";
	L["LOOT_CMD"] = "loot";
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
	L["DISCORD_REPORT"] = "Please report to the LastSeen Discord!";
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
	L["IGNORE_ITEM"] = "Ignoring ";
	L["!IGNORE_ITEM"] = "Stopped ignoring ";
	L["MATCHED_TERM"] = " matching ";
	L["NEVER_LOOTED"] = "Never Looted";
	L["RECORDS_FOUND"] = " records found.";
	L["REMOVE_ITEM"] = "Removed ";
	L["UPDATED_ITEM"] = "Updated ";
	L["BAD_DATA_ITEM_COUNT_TEXT1"] = "Bad or ignored data detected. ";
	L["BAD_DATA_ITEM_COUNT_TEXT2"] = " item(s) removed.";
	L["COMING_SOON_TEXT"] = "Coming Soon!";
	L["REMOVED_ITEMS_ANNOUNCEMENT_TEXT"] = "Removed Items";
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
		-- START TABS SECTION --
		L["SETTINGS_TAB_GENERAL"] = "General";
		L["SETTINGS_TAB_SHARE"] = "Share";
		L["SETTINGS_TAB_ACKNOWLEDGMENTS"] = "Acknowledgments";
		-- START SHARE SECTION --
		L["ITEM_ID_LABEL"] = "(|cff00ccffItem ID|r)";
		L["CHARACTER_NAME_LABEL"] = "(|cff00ccffCharacter Name|r)";
		L["REALM_NAME_LABEL"] = "(|cff00ccffRealm Name|r)";
		L["SEND_BUTTON_LABEL"] = "Send";
		L["CLEAR_BUTTON_LABEL"] = "Clear";
		-- END SHARE SECTION --
		-- START ACKNOWLEDGMENT SECTION --
		L["VANDIEL"] = "Without |cff00ccff" .. "Vandiel|r, not as many bugs or quirks would have\nbeen discovered. He's unveiled more bugs and\nmisbehaviors than I can count on my fingers and toes.\nThank you so much for your support!\n";
		L["CRIEVE"] = "|cff00ccff" .. "Crieve|r has been a huge inspiration to me for addon\ndevelopment. Working on All The Things and endlessly\nasking questions, helped shape my understanding of the\nWoW API. Thank you, good sir!";
		-- END ACKNOWLEDGMENT SECTION --
		-- START MODES SECTION --
		L["MODE"] = "Mode";
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
		L["RARITY"] = "Rarity";
		L["LEGENDARY"] = "|cffff8000" .. "Legendary|r";
		L["EPIC"] = "|cffa335ee" .. "Epic|r";
		L["RARE"] = "|cff0070dd" .. "Rare|r";
		L["UNCOMMON"] = "|cff1eff00" .. "Uncommon|r";
		L["COMMON"] = "|cffffffff" .. "Common|r";
		L["POOR"] = "|cff9d9d9d" .. "Poor|r";
		-- END RARITIES SECTION --
		-- START RARE SOUND SECTION --
		L["RARE_SOUND"] = "Rare Sound";
		L["DEFAULT_SOUND"] = "Default";
		L["CTHUN_SOUND"] = "C'Thun";
		L["RAGNAROS_SOUND"] = "Ragnaros";
		L["ARGUS_SOUND"] = "Argus";
		-- END RARE SOUND SECTION --
		-- OPTIONS
		L["OPTIONS_LABEL"] = "Options";
		L["OPTIONS_DISABLE_RARESOUND"] = "Disable Rare Sound";
		L["OPTIONS_DISABLE_RARESOUND_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_RARESOUND"] .. "|r\nDisables the audio whenever a rare is spotted. However, the message is still printed to the chat window.";
		L["OPTIONS_DISABLE_IGNORES"] = "Disable All Ignores";
		L["OPTIONS_DISABLE_IGNORES_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_IGNORES"] .. "|r\nDisables all ignore checks performed by the System. Enabling and disabling this option will purge ignored items.";
		L["OPTIONS_LOOT_CONTROL"] = "Loot Control";
		L["OPTIONS_LOOT_CONTROL_TEXT"] = "|cffffffff" .. L["OPTIONS_LOOT_CONTROL"] .. "|r\nForce LastSeen to add/update loot when the loot window is open. Auto Loot MUST be disabled!";
return end;

if LOCALE == "frFR" then -- French
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	-- START AUCTION HOUSE SECTION --
	L["AUCTION_HOUSE"] = "Maison de vente aux enchères";
	L["AUCTION_HOUSE_SOURCE"] = "Enchères";
	L["AUCTION_WON_SUBJECT"] = "Enchère gagnée:";
	-- END AUCTION HOUSE SECTION --
	-- ITEM STATUSES
	L["TRUSTED"] = "De confiance";
	L["SUSPICIOUS"] = "Méfiant";
	L["UNTRUSTED"] = "Non approuvé";
	-- COMMANDS
	L["ADD_CMD"] = "ajouter";
	L["IGNORE_CMD"] = "ignorer";
	L["REMOVE_CMD"] = "retirer";
	L["SEARCH_CMD"] = "chercher";
	L["LOCATION_CMD"] = "loc";
	L["LOOT_CMD"] = "butin";
	L["REMOVED_CMD"] = "enlevée";
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
	L["NO_QUEST_LINK"] = "Lien de quête introuvable!";
	L["NO_QUESTS_COMPLETED"] = "Aucune quête n'a été effectuée sur ce compte.";
	L["NO_QUESTS_FOUND"] = "Aucune quête trouvée!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Impossible de terminer cette action! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Impossible de déterminer la source du butin pour ";
	L["GENERAL_FAILURE"] = "Défaillance générale";
	-- INFO
	L["ADDED_ITEM"] = "Ajoutée ";
	L["IGNORE_ITEM"] = "En ignorant ";
	L["!IGNORE_ITEM"] = "Cessé d'ignorer ";
	L["MATCHED_TERM"] = " correspondant à ";
	L["NEVER_LOOTED"] = "Jamais Pillé";
	L["RECORDS_FOUND"] = " enregistrements trouvés.";
	L["REMOVE_ITEM"] = "Enlevé ";
	L["UPDATED_ITEM"] = "Mis à jour ";
	L["BAD_DATA_ITEM_COUNT_TEXT1"] = "Données incorrectes ou ignorées détectées. ";
	L["BAD_DATA_ITEM_COUNT_TEXT2"] = " article(s) enlevé(s).";
	L["COMING_SOON_TEXT"] = "Arrive bientôt!";
	L["REMOVED_ITEMS_ANNOUNCEMENT_TEXT"] = "Articles supprimés";
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
	L["MAIL"] = "Courrier";
	L["OBJECT"] = "Objet: ";
	L["QUEST"] = "Quête: ";
	-- OTHER
	L["ITEMS_SEEN"] = "Articles vus: ";
	-- OPTIONS INTERFACE
		-- START MODES SECTION --
		L["MODE"] = "Mode";
		L["VERBOSE_MODE"] = "Verbeuse";
		L["NORMAL_MODE"] = "Ordinaire";
		L["QUIET_MODE"] = "Silencieux";
		-- END MODES SECTION --
		-- START MODE DESCRIPTIONS SECTION --
		L["VERBOSE_MODE_DESC"] = "Ce mode affichera toutes les informations, y compris les éléments ajoutés, les éléments mis à jour et les éléments vus.\n";
		L["NORMAL_MODE_DESC"] = "Ce mode affichera les éléments nouveaux et mis à jour.\n";
		L["QUIET_MODE_DESC"] = "Aucune sortie. SILENCE!\n";
		-- END MODE DESCRIPTIONS SECTION --
		-- START RARITIES SECTION --
		L["RARITY"] = "Rareté";
		L["LEGENDARY"] = "|cffff8000" .. "Légendaire|r";
		L["EPIC"] = "|cffa335ee" .. "Épique|r";
		L["RARE"] = "|cff0070dd" .. "Rare|r";
		L["UNCOMMON"] = "|cff1eff00" .. "Uncommon|r";
		L["COMMON"] = "|cffffffff" .. "Commun|r";
		L["POOR"] = "|cff9d9d9d" .. "Pauvre|r";
		-- END RARITIES SECTION --
		-- START RARE SOUND SECTION --
		L["RARE_SOUND"] = "Son Rare";
		L["DEFAULT_SOUND"] = "Défaut";
		L["CTHUN_SOUND"] = "C'Thun";
		L["RAGNAROS_SOUND"] = "Ragnaros";
		L["ARGUS_SOUND"] = "Argus";
		-- END RARE SOUND SECTION --
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
	-- START AUCTION HOUSE SECTION --
	L["AUCTION_HOUSE"] = "Auktions Haus";
	L["AUCTION_HOUSE_SOURCE"] = "Versteigerung";
	L["AUCTION_WON_SUBJECT"] = "Auktion gewonnen:";
	-- END AUCTION HOUSE SECTION --
	-- ITEM STATUSES
	L["TRUSTED"] = "Vertrauenswürdige";
	L["SUSPICIOUS"] = "Verdächtig";
	L["UNTRUSTED"] = "Nicht vertrauenswürdig";
	-- COMMANDS
	L["ADD_CMD"] = "hinzufügen";
	L["IGNORE_CMD"] = "ignorieren";
	L["REMOVE_CMD"] = "löschen";
	L["SEARCH_CMD"] = "suche";
	L["LOCATION_CMD"] = "loc";
	L["LOOT_CMD"] = "beute";
	L["REMOVED_CMD"] = "entfernt";
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
	L["NO_QUEST_LINK"] = "Questlink nicht gefunden!";
	L["NO_QUESTS_COMPLETED"] = "Für dieses konto wurden keine quests abgeschlossen.";
	L["NO_QUESTS_FOUND"] = "Keine quests gefunden!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Diese aktion kann nicht abgeschlossen werden! ";
	L["UNABLE_TO_DETERMINE_SOURCE"] = "Die Quelle für die Beute konnte nicht ermittelt werden ";
	L["GENERAL_FAILURE"] = "Allgemeiner Misserfolg";
	-- INFO
	L["ADDED_ITEM"] = "Hinzugefügt ";
	L["IGNORE_ITEM"] = "Ignorieren ";
	L["!IGNORE_ITEM"] = "Ich hörte auf zu ignorieren ";
	L["MATCHED_TERM"] = " passend ";
	L["NEVER_LOOTED"] = "Niemals Geplündert";
	L["RECORDS_FOUND"] = " Datensätze gefunden.";
	L["REMOVE_ITEM"] = "Entfernt ";
	L["UPDATED_ITEM"] = "Aktualisierte ";
	L["BAD_DATA_ITEM_COUNT_TEXT1"] = "Ungültige oder ignorierte Daten erkannt. ";
	L["BAD_DATA_ITEM_COUNT_TEXT2"] = " Gegenstand(e) entfernt.";
	L["COMING_SOON_TEXT"] = "Demnächst!";
	L["REMOVED_ITEMS_ANNOUNCEMENT_TEXT"] = "Entfernte Gegenstände";
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
	L["MAIL"] = "Mail";
	L["OBJECT"] = "Objekt: ";
	L["QUEST"] = "Suche: ";
	-- OTHER
	L["ITEMS_SEEN"] = "Artikel Gesehen: ";
	-- OPTIONS INTERFACE
		-- START MODES SECTION --
		L["MODE"] = "Modus";
		L["VERBOSE_MODE"] = "Ausführlich";
		L["NORMAL_MODE"] = "Normal";
		L["QUIET_MODE"] = "Ruhig";
		-- END MODES SECTION --
		-- START MODE DESCRIPTIONS SECTION --
		L["VERBOSE_MODE_DESC"] = "In diesem Modus werden alle Informationen einschließlich hinzugefügter Elemente, aktualisierter Elemente und des Zählers für gesehene Elemente ausgegeben.\n";
		L["NORMAL_MODE_DESC"] = "In diesem Modus werden neue und aktualisierte Elemente ausgegeben.\n";
		L["QUIET_MODE_DESC"] = "Keine Leistung. STILLE!\n";
		-- END MODE DESCRIPTIONS SECTION --
		-- START RARITIES SECTION --
		L["RARITY"] = "Seltenheit";
		L["LEGENDARY"] = "|cffff8000" .. "Legendär|r";
		L["EPIC"] = "|cffa335ee" .. "Epos|r";
		L["RARE"] = "|cff0070dd" .. "Selten|r";
		L["UNCOMMON"] = "|cff1eff00" .. "Ungewöhnlich|r";
		L["COMMON"] = "|cffffffff" .. "Verbreitet|r";
		L["POOR"] = "|cff9d9d9d" .. "Arm|r";
		-- END RARITIES SECTION --
		-- START RARE SOUND SECTION --
		L["RARE_SOUND"] = "Seltener Sound";
		L["DEFAULT_SOUND"] = "Standard";
		L["CTHUN_SOUND"] = "C'Thun";
		L["RAGNAROS_SOUND"] = "Ragnaros";
		L["ARGUS_SOUND"] = "Argus";
		-- OPTIONS INTERFACE
		L["OPTIONS_LABEL"] = "Optionen";
		L["OPTIONS_DISABLE_RARESOUND"] = "Seltener Ton Deaktivieren";
		L["OPTIONS_DISABLE_RARESOUND_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_IGNORES"] .. "|r\nDeaktiviert den Ton, wenn eine seltene entdeckt wird. Die Nachricht wird jedoch weiterhin in dem Chatfenster gedruckt.";
		L["OPTIONS_DISABLE_IGNORES"] = "Alle ignorieren deaktivieren";
		L["OPTIONS_DISABLE_IGNORES_TEXT"] = "|cffffffff" .. L["OPTIONS_DISABLE_IGNORES"] .. "|r\nDeaktiviert alle Ignorierprüfungen durch das System. Durch Aktivieren und Deaktivieren dieser Option werden ignorierte Elemente gelöscht.";
return end;
