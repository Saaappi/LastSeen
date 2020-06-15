local addon, addonTbl = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

local LOCALE = GetLocale();

if LOCALE == "esES" or LOCALE == "esMX" then -- Spanish (Mexico/Spain)
	addonTbl.L = L;
	
	-- COMMANDS
	L["CMD_DISCORD"]							= "discordia";
	L["CMD_HISTORY"] 							= "historial";
	L["CMD_IMPORT"] 							= "importación";
	L["CMD_LOOT"] 								= "botín";
	L["CMD_REMOVE"] 							= "quitar";
	L["CMD_REMOVE_SHORT"] 						= "rm";
	L["CMD_SEARCH"] 							= "buscar";
	L["CMD_VIEW"] 								= "ver";
	L["SEARCH_OPTION_C"] 						= "c";
	L["SEARCH_OPTION_I"] 						= "i";
	L["SEARCH_OPTION_Q"] 						= "q";
	L["SEARCH_OPTION_Z"] 						= "z";
	
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
	L["LOOT_ITEM_PUSHED_SELF"] 					= "Recibes: ";
	L["LOOT_ITEM_SELF"] 						= "Recibes botín: ";
	L["NO_QUEUE"]								= "Ya no estás en cola.";
	
	-- INFORMATIONAL MESSAGES
	L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "¡Cargado con éxito!";
	L["INFO_MSG_IGNORED_ITEM"] 					= "Este elemento se ignora automáticamente.";
	L["INFO_MSG_ITEM_REMOVED"] 					= " removido con éxito...";
	L["INFO_MSG_LOOT_ENABLED"] 					= "Modo Loot Fast habilitado.";
	L["INFO_MSG_LOOT_DISABLED"] 				= "Modo rápido de saqueo desactivado.";
	L["INFO_MSG_MISCELLANEOUS"]					= "Funciones varias";
	L["INFO_MSG_RESULTS"]						= " resultado(s)";
	
	-- MODE NAMES
	L["DEBUG_MODE"] 							= "Debug";
	L["NORMAL_MODE"] 							= "Normal";
	L["QUIET_MODE"] 							= "Silencio";
	
	-- MODE DESCRIPTIONS
	L["DEBUG_MODE_DESC"] 						= "Modo normal con salida variable.\n";
	L["NORMAL_MODE_DESC"] 						= "Muestra los elementos nuevos y actualizados.\n";
	L["QUIET_MODE_DESC"] 						= "¡No hay salida!\n";
	
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
return end;