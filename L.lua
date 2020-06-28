-- Namespace Variables
local addon, addonTbl = ...;

-- Module-Local Variables
local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

addonTbl.GetLocale = function()
	print(L["ADDON_NAME"] .. addonTbl["locale"]);
end

addonTbl.SetLocale = function(locale)
	addonTbl["locale"] = locale;
	if locale == "deDE" then -- German
		addonTbl.L = L;
	
		-- COMMANDS
		L["CMD_DISCORD"]							= "zwietracht";
		L["CMD_FORMAT"]								= "formatieren";
		L["CMD_HELP"]								= "helfen";
		L["CMD_HISTORY"] 							= "geschichte";
		L["CMD_IMPORT"] 							= "importieren";
		L["CMD_LOCALE"]								= "gebietsschema";
		L["CMD_LOOT"] 								= "beute";
		L["CMD_MAN"]								= "handbuch";
		L["CMD_REMOVE"] 							= "entfernen";
		L["CMD_REMOVE_SHORT"] 						= "rm";
		L["CMD_SEARCH"] 							= "suchen";
		L["CMD_VIEW"] 								= "ansehen";
		L["SLASH_CMD_1"]							= "/ls";
		L["SLASH_CMD_2"]							= "/lastseen";
		
		-- ERROR MESSAGES
		L["ERROR_MSG_BAD_DATA"] 					= " elemente, die aufgrund fehlender oder beschädigter Informationen entfernt wurden.";
		L["ERROR_MSG_BAD_REQUEST"] 					= "Schlechte Anfrage. Bitte versuchen Sie es erneut.";
		L["ERROR_MSG_CANT_ADD"] 					= "Angegebenes Element kann nicht hinzugefügt werden.";
		L["ERROR_MSG_CANT_COMPLETE_REQUEST"] 		= "Antrag kann nicht abgeschlossen werden: ";
		L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"]		= "Ungültige GUID oder Einheitsname! Machen Sie einen Screenshot und melden Sie sich bei Discord!";
		L["ERROR_MSG_NO_ITEMS_FOUND"] 				= "Keine elemente gefunden.";
		L["ERROR_MSG_UNKNOWN_SOURCE"] 				= " wurde von einer unbekannten Quelle geplündert. Die Quelle wurde als \"Verschiedenes\" festgelegt.";

		-- GENERAL
		L["ADDON_NAME"] 							= "|cff00ccff" .. addon .. "|r: ";
		L["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
		L["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "] ";
		L["DATE"]									= date("%m/%d/%Y");
		
		-- GLOBAL STRINGS
		L["AUCTION_HOUSE"] 							= "Auktionshaus";
		L["AUCTION_WON_SUBJECT"] 					= "Auktion gewonnen:";
		L["ERR_JOIN_SINGLE_SCENARIO_S"]				= "Ihr seid der Warteschlange für Inselexpeditionen beigetreten.";
		L["ISLAND_EXPEDITIONS"]						= "Inselexpeditionen";
		L["ITEM_SEEN_FROM"]							= L["ADDON_NAME"] .. "This item was seen from %s source(s):";
		L["LOOT_ITEM_PUSHED_SELF"] 					= "Ihr bekommt einen Gegenstand: ";
		L["LOOT_ITEM_SELF"] 						= "Ihr erhaltet Beute: ";
		L["NO_QUEUE"]								= "Ihr befindet Euch nicht mehr in der Warteschlange.";
		
		-- INFORMATIONAL MESSAGES
		L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "Erfolgreich geladen!";
		L["INFO_MSG_IGNORED_ITEM"] 					= "Dieser Punkt wird automatisch ignoriert.";
		L["INFO_MSG_ITEM_ADDED_NO_SRC"] 			= L["ADDON_NAME"] .. "Added |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_KNOWN"] 			= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_REMOVED"] 					= L["ADDON_NAME"] .. "%s erfolgreich entfernt.";
		L["INFO_MSG_ITEM_UPDATED_NO_SRC"] 			= L["ADDON_NAME"] .. "Updated |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_KNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_LOOT_ENABLED"] 					= "Beute Schnellmodus aktiviert.";
		L["INFO_MSG_LOOT_DISABLED"] 				= "Beute Schnellmodus deaktiviert.";
		L["INFO_MSG_MISCELLANEOUS"]					= "Verschiedene Funktionen";
		L["INFO_MSG_RESULTS"]						= " ergebnis(se)";
		
		-- MODE NAMES
		L["NORMAL_MODE"] 							= "Normal";
		L["SHOW_SOURCES"]							= "Show Sources";
		
		-- DESCRIPTIONS
		L["MODE_DESCRIPTIONS"]						= "|cffffffffDebug|r|cff86c5da mode displays the contents of numerous variables and addon messages.|r\n|cffffffffNormal|r|cff86c5da mode displays only addon messages.|r\n|cffffffffN/A|r|cff86c5da mode has no output.|r";
		L["SHOW_SOURCES_DESC"]						= "|cff86c5daIf an item has been seen from more than one source, checking this button will tell you how many and display up to 4 of those sources.|r";
		
		-- OBJECT TYPES
		L["IS_CREATURE"] 							= "Kreatur";
		L["IS_PLAYER"] 								= "Spieler";
		L["IS_VEHICLE"] 							= "Fahrzeug";
		L["IS_UNKNOWN"]								= "Unbekannt";
		
		-- OTHER
		L["SPELL_NAMES"] = {
			{
				["spellName"] 						= "Einsammeln",
			},						
			{						
				["spellName"] 						= "Angeln",
			},						
			{						
				["spellName"] 						= "Toga durchsuchen",
			},						
			{						
				["spellName"] 						= "Kräutersammeln",
			},						
			{						
				["spellName"] 						= "Plündern",
			},						
			{						
				["spellName"] 						= "Bergbau",
			},						
			{						
				["spellName"] 						= "Öffnen",
			},						
			{						
				["spellName"] 						= "Kürschnerei",
			},						
			{						
				["spellName"] 						= "Untersuchen",
			},
		};
	end
	if locale == "enGB" then -- English (EU)
		addonTbl.L = L;
	
		-- COMMANDS
		L["CMD_DISCORD"]							= "discord";
		L["CMD_FORMAT"]								= "format";
		L["CMD_HELP"]								= "help";
		L["CMD_HISTORY"] 							= "history";
		L["CMD_IMPORT"] 							= "import";
		L["CMD_LOCALE"]								= "locale";
		L["CMD_LOOT"] 								= "loot";
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
		L["DATE"]									= date("%d/%m/%Y");
		
		-- GLOBAL STRINGS
		L["AUCTION_HOUSE"]							= "Auction House";
		L["AUCTION_WON_SUBJECT"]					= "Auction won:";
		L["ERR_JOIN_SINGLE_SCENARIO_S"]				= "You have joined the queue for Island Expeditions.";
		L["ISLAND_EXPEDITIONS"]						= "Island Expeditions";
		L["ITEM_SEEN_FROM"]							= L["ADDON_NAME"] .. "This item was seen from %s source(s):";
		L["LOOT_ITEM_PUSHED_SELF"] 					= "You receive item: ";
		L["LOOT_ITEM_SELF"] 						= "You receive loot: ";
		L["NO_QUEUE"]								= "You are no longer queued.";
		
		-- INFORMATIONAL MESSAGES
		L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "Loaded successfully!";
		L["INFO_MSG_IGNORED_ITEM"] 					= "This item is automatically ignored.";
		L["INFO_MSG_ITEM_ADDED_NO_SRC"] 			= L["ADDON_NAME"] .. "Added |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_KNOWN"] 			= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_REMOVED"] 					= L["ADDON_NAME"] .. "%s successfully removed.";
		L["INFO_MSG_ITEM_UPDATED_NO_SRC"] 			= L["ADDON_NAME"] .. "Updated |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_KNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_LOOT_ENABLED"] 					= "Loot Fast mode enabled.";
		L["INFO_MSG_LOOT_DISABLED"] 				= "Loot Fast mode disabled.";
		L["INFO_MSG_MISCELLANEOUS"]					= "Miscellaneous";
		L["INFO_MSG_RESULTS"]						= " result(s)";
		
		-- MODE NAMES
		L["NORMAL_MODE"] 							= "Normal";
		L["SHOW_SOURCES"]							= "Show Sources";
		
		-- DESCRIPTIONS
		L["MODE_DESCRIPTIONS"]						= "|cffffffffDebug|r|cff86c5da mode displays the contents of numerous variables and addon messages.|r\n|cffffffffNormal|r|cff86c5da mode displays only addon messages.|r\n|cffffffffN/A|r|cff86c5da mode has no output.|r";
		L["SHOW_SOURCES_DESC"]						= "|cff86c5daIf an item has been seen from more than one source, checking this button will tell you how many and display up to 4 of those sources.|r";
		
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
	end
	if locale == "enUS" then -- English (US)
		addonTbl.L = L;
	
		-- COMMANDS
		L["CMD_DISCORD"]							= "discord";
		L["CMD_FORMAT"]								= "format";
		L["CMD_HELP"]								= "help";
		L["CMD_HISTORY"] 							= "history";
		L["CMD_IMPORT"] 							= "import";
		L["CMD_LOCALE"]								= "locale";
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
		L["ITEM_SEEN_FROM"]							= L["ADDON_NAME"] .. "This item was seen from %s source(s):";
		L["LOOT_ITEM_PUSHED_SELF"] 					= "You receive item: ";
		L["LOOT_ITEM_SELF"] 						= "You receive loot: ";
		L["NO_QUEUE"]								= "You are no longer queued.";
		
		-- INFORMATIONAL MESSAGES
		L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "Loaded successfully!";
		L["INFO_MSG_CMD_DISCORD"]					= "Provides a link to a Discord server.";
		L["INFO_MSG_CMD_FORMAT"]					= "Allows the player to change the format of dates in the items table. D/M/Y or M/D/Y.";
		L["INFO_MSG_CMD_HELP"]						= "Lists out the commands of the addon.";
		L["INFO_MSG_CMD_HISTORY"]					= "Provides a list of the last 20 items the addon saw, persistent between sessions.";
		L["INFO_MSG_CMD_IMPORT"]					= "Imports data from the LastSeen2 beta test.";
		L["INFO_MSG_CMD_LOCALE"]					= "Changes the current locale of the addon.";
		L["INFO_MSG_CMD_LOOT"]						= "Enables or disables a quick loot setting. This may or may not impact performance.";
		L["INFO_MSG_CMD_MAN"]						= "A handbook with information about other commands.";
		L["INFO_MSG_CMD_REMOVE"]					= "Deletes an item from the items table. Accepts both ID and links.\nAliases: " .. L["CMD_REMOVE_SHORT"];
		L["INFO_MSG_CMD_SEARCH"]					= "Finds an item in the items table and returns the results to the player. Accepts ID, links, and partial names.";
		L["INFO_MSG_CMD_VIEW"]						= "Used to view items that were automatically removed from the items table.";
		L["INFO_MSG_IGNORED_ITEM"] 					= "This item is automatically ignored.";
		L["INFO_MSG_ITEM_ADDED_NO_SRC"] 			= L["ADDON_NAME"] .. "Added |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_KNOWN"] 			= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_REMOVED"] 					= L["ADDON_NAME"] .. "%s successfully removed.";
		L["INFO_MSG_ITEM_UPDATED_NO_SRC"] 			= L["ADDON_NAME"] .. "Updated |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_KNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_LOOT_ENABLED"] 					= "Loot Fast mode enabled.";
		L["INFO_MSG_LOOT_DISABLED"] 				= "Loot Fast mode disabled.";
		L["INFO_MSG_MISCELLANEOUS"]					= "Miscellaneous";
		L["INFO_MSG_RESULTS"]						= " result(s)";
		
		-- MODE NAMES
		L["NORMAL_MODE"] 							= "Normal";
		L["SHOW_SOURCES"]							= "Show Sources";
		
		-- DESCRIPTIONS
		L["MODE_DESCRIPTIONS"]						= "|cffffffffDebug|r|cff86c5da mode displays the contents of numerous variables and addon messages.|r\n|cffffffffNormal|r|cff86c5da mode displays only addon messages.|r\n|cffffffffN/A|r|cff86c5da mode has no output.|r";
		L["SHOW_SOURCES_DESC"]						= "|cff86c5daIf an item has been seen from more than one source, checking this button will tell you how many and display up to 4 of those sources.|r";
		
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
	end
	if locale == "esES" then -- Spanish (Spain)
		addonTbl.L = L;
	
		-- COMMANDS
		L["CMD_DISCORD"]							= "discordia";
		L["CMD_FORMAT"]								= "formato";
		L["CMD_HELP"]								= "ayudar";
		L["CMD_HISTORY"] 							= "historial";
		L["CMD_IMPORT"] 							= "importación";
		L["CMD_LOCALE"]								= "local";
		L["CMD_LOOT"] 								= "botín";
		L["CMD_MAN"]								= "manual";
		L["CMD_REMOVE"] 							= "quitar";
		L["CMD_REMOVE_SHORT"] 						= "rm";
		L["CMD_SEARCH"] 							= "buscar";
		L["CMD_VIEW"] 								= "ver";
		L["SLASH_CMD_1"]							= "/ls";
		L["SLASH_CMD_2"]							= "/lastseen";
		
		-- ERROR MESSAGES
		L["ERROR_MSG_BAD_DATA"] 					= " elementos eliminados debido a la información perdida o corrupta.";
		L["ERROR_MSG_BAD_REQUEST"] 					= "Mala petición. Por favor, inténtelo de nuevo.";
		L["ERROR_MSG_CANT_ADD"] 					= "No se puede añadir un elemento específico.";
		L["ERROR_MSG_CANT_COMPLETE_REQUEST"] 		= "No puedo completar la solicitud: ";
		L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"]		= "¡Guión o nombre de la unidad inválido! ¡Haz una captura de pantalla e informa a Discord!";
		L["ERROR_MSG_NO_ITEMS_FOUND"] 				= "No se han encontrado artículos.";
		L["ERROR_MSG_UNKNOWN_SOURCE"] 				= " fue saqueado de una fuente desconocida. Su fuente se ha establecido como Miscelánea.";
		
		-- GENERAL
		L["ADDON_NAME"] 							= "|cff00ccff" .. addon .. "|r: ";
		L["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
		L["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "] ";
		L["DATE"]									= date("%d/%m/%Y");
		
		-- GLOBAL STRINGS
		L["AUCTION_HOUSE"] 							= "Casa de subastas";
		L["AUCTION_WON_SUBJECT"] 					= "Subasta ganada:";
		L["ERR_JOIN_SINGLE_SCENARIO_S"]				= "Te has unido a la cola para Expediciones a la isla.";
		L["ISLAND_EXPEDITIONS"]						= "Expediciones a la isla";
		L["ITEM_SEEN_FROM"]							= L["ADDON_NAME"] .. "This item was seen from %s source(s):";
		L["LOOT_ITEM_PUSHED_SELF"] 					= "Recibes: ";
		L["LOOT_ITEM_SELF"] 						= "Recibes botín: ";
		L["NO_QUEUE"]								= "Ya no estás en cola.";
		
		-- INFORMATIONAL MESSAGES
		L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "¡Cargado con éxito!";
		L["INFO_MSG_IGNORED_ITEM"] 					= "Este elemento se ignora automáticamente.";
		L["INFO_MSG_ITEM_ADDED_NO_SRC"] 			= L["ADDON_NAME"] .. "Added |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_KNOWN"] 			= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_REMOVED"] 					= L["ADDON_NAME"] .. "%s removido con éxito...";
		L["INFO_MSG_ITEM_UPDATED_NO_SRC"] 			= L["ADDON_NAME"] .. "Updated |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_KNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_LOOT_ENABLED"] 					= "Modo Loot Fast habilitado.";
		L["INFO_MSG_LOOT_DISABLED"] 				= "Modo rápido de saqueo desactivado.";
		L["INFO_MSG_MISCELLANEOUS"]					= "Funciones varias";
		L["INFO_MSG_RESULTS"]						= " resultado(s)";
		
		-- MODE NAMES
		L["NORMAL_MODE"] 							= "Normal";
		L["SHOW_SOURCES"]							= "Show Sources";
		
		-- DESCRIPTIONS
		L["MODE_DESCRIPTIONS"]						= "|cffffffffDebug|r|cff86c5da mode displays the contents of numerous variables and addon messages.|r\n|cffffffffNormal|r|cff86c5da mode displays only addon messages.|r\n|cffffffffN/A|r|cff86c5da mode has no output.|r";
		L["SHOW_SOURCES_DESC"]						= "|cff86c5daIf an item has been seen from more than one source, checking this button will tell you how many and display up to 4 of those sources.|r";
		
		-- OBJECT TYPES
		L["IS_CREATURE"] 							= "Criatura";
		L["IS_PLAYER"] 								= "Jugador";
		L["IS_VEHICLE"] 							= "Vehiculo";
		L["IS_UNKNOWN"]								= "Desconocido";
		
		-- OTHER
		L["SPELL_NAMES"] = {
			{
				["spellName"] 						= "Recogiendo",
			},						
			{						
				["spellName"] 						= "Pesca",
			},						
			{						
				["spellName"] 						= "Toga ágil",
			},						
			{						
				["spellName"] 						= "Recolectar hierbas",
			},						
			{						
				["spellName"] 						= "Despojando",
			},						
			{						
				["spellName"] 						= "Minería",
			},						
			{						
				["spellName"] 						= "Abriendo",
			},						
			{						
				["spellName"] 						= "Desuello",
			},						
			{						
				["spellName"] 						= "Estudiar",
			},
		};
	end
	if locale == "esMX" then -- Spanish (Mexico)
		addonTbl.L = L;
	
		-- COMMANDS
		L["CMD_DISCORD"]							= "discordia";
		L["CMD_FORMAT"]								= "formato";
		L["CMD_HELP"]								= "ayudar";
		L["CMD_HISTORY"] 							= "historial";
		L["CMD_IMPORT"] 							= "importación";
		L["CMD_LOCALE"]								= "local";
		L["CMD_LOOT"] 								= "botín";
		L["CMD_MAN"]								= "manual";
		L["CMD_REMOVE"] 							= "quitar";
		L["CMD_REMOVE_SHORT"] 						= "rm";
		L["CMD_SEARCH"] 							= "buscar";
		L["CMD_VIEW"] 								= "ver";
		L["SLASH_CMD_1"]							= "/ls";
		L["SLASH_CMD_2"]							= "/lastseen";
		
		-- ERROR MESSAGES
		L["ERROR_MSG_BAD_DATA"] 					= " elementos eliminados debido a la información perdida o corrupta.";
		L["ERROR_MSG_BAD_REQUEST"] 					= "Mala petición. Por favor, inténtelo de nuevo.";
		L["ERROR_MSG_CANT_ADD"] 					= "No se puede añadir un elemento específico.";
		L["ERROR_MSG_CANT_COMPLETE_REQUEST"] 		= "No puedo completar la solicitud: ";
		L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"]		= "¡Guión o nombre de la unidad inválido! ¡Haz una captura de pantalla e informa a Discord!";
		L["ERROR_MSG_NO_ITEMS_FOUND"] 				= "No se han encontrado artículos.";
		L["ERROR_MSG_UNKNOWN_SOURCE"] 				= " fue saqueado de una fuente desconocida. Su fuente se ha establecido como Miscelánea.";
		
		-- GENERAL
		L["ADDON_NAME"] 							= "|cff00ccff" .. addon .. "|r: ";
		L["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
		L["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "] ";
		L["DATE"]									= date("%d/%m/%Y");
		
		-- GLOBAL STRINGS
		L["AUCTION_HOUSE"] 							= "Casa de subastas";
		L["AUCTION_WON_SUBJECT"] 					= "Subasta ganada:";
		L["ERR_JOIN_SINGLE_SCENARIO_S"]				= "Te has unido a la cola para Expediciones a la isla.";
		L["ISLAND_EXPEDITIONS"]						= "Expediciones a la isla";
		L["ITEM_SEEN_FROM"]							= L["ADDON_NAME"] .. "This item was seen from %s source(s):";
		L["LOOT_ITEM_PUSHED_SELF"] 					= "Recibes: ";
		L["LOOT_ITEM_SELF"] 						= "Recibes botín: ";
		L["NO_QUEUE"]								= "Ya no estás en cola.";
		
		-- INFORMATIONAL MESSAGES
		L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "¡Cargado con éxito!";
		L["INFO_MSG_IGNORED_ITEM"] 					= "Este elemento se ignora automáticamente.";
		L["INFO_MSG_ITEM_ADDED_NO_SRC"] 			= L["ADDON_NAME"] .. "Added |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_KNOWN"] 			= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_REMOVED"] 					= L["ADDON_NAME"] .. "%s removido con éxito...";
		L["INFO_MSG_ITEM_UPDATED_NO_SRC"] 			= L["ADDON_NAME"] .. "Updated |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_KNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_LOOT_ENABLED"] 					= "Modo Loot Fast habilitado.";
		L["INFO_MSG_LOOT_DISABLED"] 				= "Modo rápido de saqueo desactivado.";
		L["INFO_MSG_MISCELLANEOUS"]					= "Funciones varias";
		L["INFO_MSG_RESULTS"]						= " resultado(s)";
		
		-- MODE NAMES
		L["NORMAL_MODE"] 							= "Normal";
		L["SHOW_SOURCES"]							= "Show Sources";
		
		-- DESCRIPTIONS
		L["MODE_DESCRIPTIONS"]						= "|cffffffffDebug|r|cff86c5da mode displays the contents of numerous variables and addon messages.|r\n|cffffffffNormal|r|cff86c5da mode displays only addon messages.|r\n|cffffffffN/A|r|cff86c5da mode has no output.|r";
		L["SHOW_SOURCES_DESC"]						= "|cff86c5daIf an item has been seen from more than one source, checking this button will tell you how many and display up to 4 of those sources.|r";
		
		-- OBJECT TYPES
		L["IS_CREATURE"] 							= "Criatura";
		L["IS_PLAYER"] 								= "Jugador";
		L["IS_VEHICLE"] 							= "Vehiculo";
		L["IS_UNKNOWN"]								= "Desconocido";
		
		-- OTHER
		L["SPELL_NAMES"] = {
			{
				["spellName"] 						= "Recogiendo",
			},						
			{						
				["spellName"] 						= "Pesca",
			},						
			{						
				["spellName"] 						= "Toga ágil",
			},						
			{						
				["spellName"] 						= "Recolectar hierbas",
			},						
			{						
				["spellName"] 						= "Despojando",
			},						
			{						
				["spellName"] 						= "Minería",
			},						
			{						
				["spellName"] 						= "Abriendo",
			},						
			{						
				["spellName"] 						= "Desuello",
			},						
			{						
				["spellName"] 						= "Estudiar",
			},
		};
	end
	if locale == "frFR" then -- French
	end
	if locale == "koKR" then -- Korean
	end
	if locale == "ptBR" then -- Portuguese (Brazil)
	end
	if locale == "ruRU" then -- Russian
		addonTbl.L = L;
	
		-- COMMANDS
		L["CMD_DISCORD"]							= "discord";
		L["CMD_FORMAT"]								= "формат";
		L["CMD_HELP"]								= "помощь";
		L["CMD_HISTORY"] 							= "история";
		L["CMD_IMPORT"] 							= "импортировать";
		L["CMD_LOCALE"]								= "регион";
		L["CMD_LOOT"] 								= "добыча";
		L["CMD_MAN"]								= "руководство";
		L["CMD_REMOVE"] 							= "удалить";
		L["CMD_REMOVE_SHORT"] 						= "уд";
		L["CMD_SEARCH"] 							= "поиск";
		L["CMD_VIEW"] 								= "вид";
		L["SLASH_CMD_1"]							= "/ls";
		L["SLASH_CMD_2"]							= "/lastseen";
		
		-- ERROR MESSAGES
		L["ERROR_MSG_BAD_DATA"] 					= " элемент(ы) удален из-за отсутствия или повреждения информации.";
		L["ERROR_MSG_BAD_REQUEST"] 					= "Неправильный запрос. Пожалуйста, попробуйте еще раз.";
		L["ERROR_MSG_CANT_ADD"] 					= "Не удается добавить указанный предмет.";
		L["ERROR_MSG_CANT_COMPLETE_REQUEST"] 		= "Не удается выполнить запрос: ";
		L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"]		= "Неверный GUID или имя! Сделайте скриншот и сообщите Discord!";
		L["ERROR_MSG_NO_ITEMS_FOUND"] 				= "Товар(ы) не найден.";
		L["ERROR_MSG_UNKNOWN_SOURCE"] 				= " был получен из неизвестного источника. Его источник был установлен как Разное.";

		-- GENERAL
		L["ADDON_NAME"] 							= "|cff00ccff" .. addon .. "|r: ";
		L["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
		L["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "] ";
		L["DATE"]									= date("%m/%d/%Y");
		
		-- GLOBAL STRINGS
		L["AUCTION_HOUSE"] 							= "Аукционный Дом";
		L["AUCTION_WON_SUBJECT"] 					= "Аукцион выигран:";
		L["ERR_JOIN_SINGLE_SCENARIO_S"]				= "Вы присоединились к очереди на островные экспедиции.";
		L["ISLAND_EXPEDITIONS"]						= "Островные Экспедиции";
		L["ITEM_SEEN_FROM"]							= L["ADDON_NAME"] .. "This item was seen from %s source(s):";
		L["LOOT_ITEM_PUSHED_SELF"] 					= "Вы получаете товар: ";
		L["LOOT_ITEM_SELF"] 						= "Вы получаете добычу: ";
		L["NO_QUEUE"]								= "Вы больше не стоите в очереди.";
		
		-- INFORMATIONAL MESSAGES
		L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "Успешно загружен!";
		L["INFO_MSG_IGNORED_ITEM"] 					= "Этот пункт Автоматически игнорируется.";
		L["INFO_MSG_ITEM_ADDED_NO_SRC"] 			= L["ADDON_NAME"] .. "Added |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_KNOWN"] 			= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_ADDED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Added |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_REMOVED"] 					= L["ADDON_NAME"] .. "%s успешно удален.";
		L["INFO_MSG_ITEM_UPDATED_NO_SRC"] 			= L["ADDON_NAME"] .. "Updated |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_KNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\known:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_ITEM_UPDATED_SRC_UNKNOWN"] 		= L["ADDON_NAME"] .. "Updated |TInterface\\Addons\\LastSeen\\Assets\\unknown:0|t |T%s:0|t %s - %s";
		L["INFO_MSG_LOOT_ENABLED"] 					= "Быстрый режим добычи включен.";
		L["INFO_MSG_LOOT_DISABLED"] 				= "Быстрый режим добычи отключен.";
		L["INFO_MSG_MISCELLANEOUS"]					= "Разное";
		L["INFO_MSG_RESULTS"]						= " результат(ы)";
		
		-- MODE NAMES
		L["NORMAL_MODE"] 							= "Обычный";
		L["SHOW_SOURCES"]							= "Show Sources";
		
		-- DESCRIPTIONS
		L["MODE_DESCRIPTIONS"]						= "|cffffffffDebug|r|cff86c5da mode displays the contents of numerous variables and addon messages.|r\n|cffffffffNormal|r|cff86c5da mode displays only addon messages.|r\n|cffffffffN/A|r|cff86c5da mode has no output.|r";
		L["SHOW_SOURCES_DESC"]						= "|cff86c5daIf an item has been seen from more than one source, checking this button will tell you how many and display up to 4 of those sources.|r";
		
		-- OBJECT TYPES
		L["IS_CREATURE"] 							= "Существо";
		L["IS_PLAYER"] 								= "Игрок";
		L["IS_VEHICLE"] 							= "Транспортное средство";
		L["IS_UNKNOWN"]								= "Неизвестно";
		
		-- OTHER
		L["SPELL_NAMES"] = {
			{
				["spellName"] 						= "Сбор",
			},						
			{						
				["spellName"] 						= "Рыбная ловля",
			},						
			{						
				["spellName"] 						= "Обыск мантии",
			},						
			{						
				["spellName"] 						= "Сбор трав",
			},						
			{						
				["spellName"] 						= "Сбор добычи",
			},						
			{						
				["spellName"] 						= "Горное дело",
			},						
			{						
				["spellName"] 						= "Открытие",
			},						
			{						
				["spellName"] 						= "Снятие шкур",
			},						
			{						
				["spellName"] 						= "Исследование",
			},
		};
	end
	if locale == "zhCN" then -- Chinese (Simplified)
	end
	if locale == "zhTW" then -- Chinese (Traditional)
	end
end

addonTbl.SetLocale("enUS");