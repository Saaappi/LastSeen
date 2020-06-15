local addon, addonTbl = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

local LOCALE = GetLocale();

if LOCALE == "ruRU" then -- Russian
	addonTbl.L = L;
	
	-- COMMANDS
	L["CMD_DISCORD"]							= "диссонанс";
	L["CMD_HISTORY"] 							= "история";
	L["CMD_IMPORT"] 							= "импорт";
	L["CMD_LOOT"] 								= "ограбление";
	L["CMD_REMOVE"] 							= "удалить";
	L["CMD_REMOVE_SHORT"] 						= "rm";
	L["CMD_SEARCH"] 							= "поиск";
	L["CMD_VIEW"] 								= "просмотр";
	L["SEARCH_OPTION_C"] 						= "c";
	L["SEARCH_OPTION_I"] 						= "i";
	L["SEARCH_OPTION_Q"] 						= "q";
	L["SEARCH_OPTION_Z"] 						= "z";
	
	-- ERROR MESSAGES
	L["ERROR_MSG_BAD_DATA"] 					= " пункт(ы), удаленный(ые) из-за отсутствующей или поврежденной информации.";
	L["ERROR_MSG_BAD_REQUEST"] 					= "Плохая просьба. Пожалуйста, попробуйте еще раз.";
	L["ERROR_MSG_CANT_ADD"] 					= "Не может добавить указанный пункт.";
	L["ERROR_MSG_CANT_COMPLETE_REQUEST"] 		= "Не может выполнить запрос: ";
	L["ERROR_MSG_INVALID_GUID_OR_UNITNAME"]		= "Недействительный GUID или имя устройства! Сделайте снимок экрана и доложите о результатах Раздора!";
	L["ERROR_MSG_NO_ITEMS_FOUND"] 				= "Ничего не найдено.";
	L["ERROR_MSG_UNKNOWN_SOURCE"] 				= " был ограблен из неизвестного источника. Его источник был установлен как \"Разное\".";

	-- GENERAL
	L["ADDON_NAME"] 							= "|cff00ccff" .. addon .. "|r: ";
	L["ADDON_NAME_SETTINGS"] 					= "|cff00ccff" .. addon .. "|r";
	L["RELEASE"] 								= "[" .. GetAddOnMetadata(addon, "Version") .. "] ";
	L["DATE"]									= date("%m/%d/%Y");
	
	-- GLOBAL STRINGS
	L["AUCTION_HOUSE"] 							= "Аукционный дом";
	L["AUCTION_WON_SUBJECT"] 					= "Вы выиграли торги:";
	L["ERR_JOIN_SINGLE_SCENARIO_S"]				= "Вы встали в очередь Островные экспедиции.";
	L["ISLAND_EXPEDITIONS"]						= "Островные экспедиции";
	L["LOOT_ITEM_PUSHED_SELF"] 					= "Вы получаете предмет: ";
	L["LOOT_ITEM_SELF"] 						= "Ваша добыча: ";
	L["NO_QUEUE"]								= "Вы вышли из очереди.";
	
	-- INFORMATIONAL MESSAGES
	L["INFO_MSG_ADDON_LOAD_SUCCESSFUL"] 		= "Заряжено успешно!";
	L["INFO_MSG_IGNORED_ITEM"] 					= "Этот пункт автоматически игнорируется.";
	L["INFO_MSG_ITEM_REMOVED"] 					= " успешно удалено.";
	L["INFO_MSG_LOOT_ENABLED"] 					= "Включен режим Loot Fast.";
	L["INFO_MSG_LOOT_DISABLED"] 				= "Режим Loot Fast отключен.";
	L["INFO_MSG_MISCELLANEOUS"]					= "Разное";
	L["INFO_MSG_RESULTS"]						= " результат(ы)";
	
	-- MODE NAMES
	L["DEBUG_MODE"] 							= "Отладка";
	L["NORMAL_MODE"] 							= "Нормальный";
	L["QUIET_MODE"] 							= "Тихий";
	-- MODE DESCRIPTIONS
	L["DEBUG_MODE_DESC"] 						= "Нормальный режим с переменным выходом.\n";
	L["NORMAL_MODE_DESC"] 						= "Показывает новые и обновленные пункты.\n";
	L["QUIET_MODE_DESC"] 						= "Выхода нет!\n";
	
	-- OBJECT TYPES
	L["IS_CREATURE"] 							= "Существо";
	L["IS_PLAYER"] 								= "Игрок";
	L["IS_VEHICLE"] 							= "Автомобиль";
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
			["spellName"] 						= "Открывание",
		},						
		{						
			["spellName"] 						= "Снятие шкур",
		},						
		{						
			["spellName"] 						= "Исследовать",
		},
	};
return end;