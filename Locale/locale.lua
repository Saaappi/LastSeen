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
	L["RELEASE_DATE"] = "30 April, 2019";
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
	L["ITEM_EXISTS"] = "Item exists!";
	L["NO_ITEMS_FOUND"] = "No items found!";
	L["NO_QUESTS_COMPLETED"] = "No quests have been completed on this account.";
	L["NO_QUESTS_FOUND"] = "No quests found!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Unable to complete that action! ";
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
	L["IS_QUEST_ITEM"] = "Q";
	L["IS_TRADESKILL_ITEM"] = "Tradeskill";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Creature";
	L["IS_MERCHANT"] = "Merchant";
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
	L["SPELL_NAME_OPENING"] = "Opening";
	-- SOURCES
	L["AUCTION"] = "Auction";
	L["MAIL"] = "Mail";
	L["TRADE"] = "Trade";
	-- OTHER
	L["ITEMS_SEEN"] = "Items Seen";
	L["WON"] = "won";
return end;

if LOCALE == "frFR" then -- French
	-- GENERAL
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "30 April, 2019";
	-- COMMANDS
	L["ADD"] = "ajouter";
	L["IGNORE"] = "ignorer";
	L["REMOVE"] = "retirer";
	L["SEARCH"] = "chercher";
	L["SEARCH_OPTION_C"] = "c";
	L["SEARCH_OPTION_I"] = "je";
	L["SEARCH_OPTION_Q"] = "q";
	L["SEARCH_OPTION_z"] = "z";
	-- CONSTANTS
	L["LOOT_ITEM_CREATED_SELF"] = "Tu crées";
	L["LOOT_ITEM_PUSHED_SELF"] = "Vous recevez l'article";
	L["LOOT_ITEM_SELF"] = "Vous recevez du butin";
	-- ERRORS
	L["BAD_DATA_FOUND"] = "Données Erronées Trouvées";
	L["ITEM_EXISTS"] = "L'article existe!";
	L["NO_ITEMS_FOUND"] = "Aucun élément trouvé!";
	L["NO_QUESTS_COMPLETED"] = "Aucune quête n'a été effectuée sur ce compte.";
	L["NO_QUESTS_FOUND"] = "Aucune quête trouvée!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Impossible de terminer cette action! ";
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
	L["IS_QUEST_ITEM"] = "Q";
	L["IS_TRADESKILL_ITEM"] = "Artisanat";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Créature";
	L["IS_MERCHANT"] = "Marchande";
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
	L["RELEASE_DATE"] = "30 April, 2019";
	-- COMMANDS
	L["ADD"] = "hinzufügen";
	L["IGNORE"] = "ignorieren";
	L["REMOVE"] = "löschen";
	L["SEARCH"] = "suche";
	L["SEARCH_OPTION_C"] = "c";
	L["SEARCH_OPTION_I"] = "ich";
	L["SEARCH_OPTION_Q"] = "q";
	L["SEARCH_OPTION_z"] = "z";
	-- CONSTANTS
	L["LOOT_ITEM_CREATED_SELF"] = "Du erschaffst";
	L["LOOT_ITEM_PUSHED_SELF"] = "Sie erhalten einen artikel";
	L["LOOT_ITEM_SELF"] = "Sie erhalten beute";
	-- ERRORS
	L["BAD_DATA_FOUND"] = "Fehlerhafte Daten Gefunden";
	L["ITEM_EXISTS"] = "Artikel existiert!";
	L["NO_ITEMS_FOUND"] = "Keine elemente gefunden!";
	L["NO_QUESTS_COMPLETED"] = "Für dieses konto wurden keine quests abgeschlossen.";
	L["NO_QUESTS_FOUND"] = "Keine quests gefunden!";
	L["UNABLE_TO_COMPLETE_ACTION"] = "Diese aktion kann nicht abgeschlossen werden! ";
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
	L["IS_QUEST_ITEM"] = "Q";
	L["IS_TRADESKILL_ITEM"] = "Handelsfertigkeit";
	-- OBJECT TYPES
	L["IS_CREATURE"] = "Kreatur";
	L["IS_MERCHANT"] = "Händler";
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

if LOCALE == "esES" or LOCALE == "esMX" then -- Spanish
	-- General
	L["AUTHOR"] = "Oxlotus - Área 52 [US]";
	L["RELEASE"] = GetAddOnMetadata (lastSeen, "Version");
	L["RELEASE_DATE"] = "30 de abril de 2019";
	-- Commands
	L["ADD"] = "añadir";
	L["IGNORE"] = "ignorar";
	L["REMOVE"] = "eliminar";
	L["SEARCH"] = "búsqueda";
	-- Options Frame
	L["ITEMS_SEEN"] = "Artículos vistos";
	-- Mode Options
	L["MODE"] = "Modo";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Silencio";
	-- Rarity Options
	L["Rareza"] = "Rareza";
	L["LEGENDARY"] = "| cffff8000" .. "Legendario|r";
	L["EPIC"] = "| cffa335ee" .. "Épico|r";
	L["RARE"] = "| cff0070dd" .. "Raro|r";
	L["UNCOMMON"] = "| cff1eff00" .. "Poco común|r";
	-- Other
	L["TRADESKILL"] = "Destreza";
	L["MAIL"] = "Correo";
	L["TRADE"] = "Comercio";
	L["LOOT_ITEM_PUSHED_SELF"] = "Usted recibe el artículo";
	L["LOOT_ITEM_SELF"] = "Usted recibe botín";
return end;

if LOCALE == "ptBR" then -- Brazilian Portuguese 
	-- General
	L["AUTHOR"] = "Oxlotus - Área 52 [EUA]";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "30 de abril de 2019";
	-- Commands
	L["ADD"] = "adicionar";
	L["IGNORE"] = "ignorar";
	L["REMOVE"] = "remover";
	L["SEARCH"] = "procurar";
	-- Options Frame
	L["ITEMS_SEEN"] = "Itens vistos";
	-- Mode Options
	L["MODE"] = "Modo";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Quieto";
	-- Rarity Options
	L["Rareza"] = "Raridade";
	L["LEGENDARY"] = "| cffff8000" .. "Lendário|r";
	L["EPIC"] = "| cffa335ee" .. "Épico|r";
	L["RARE"] = "| cff0070dd" .. "Raro|r";
	L["UNCOMMON"] = "| cff1eff00" .. "Incomum|r";
	-- Other
	L["tradeskill"] = "Tradeskill";
	L["MAIL"] = "Enviar";
	L["TRADE"] = "Comércio";
	L["LOOT_ITEM_PUSHED_SELF"] = "Você recebe um item";
	L["LOOT_ITEM_SELF"] = "Você recebe saque";
return end;

if LOCALE == "ruRU" then -- Russian
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "«30 апреля 2019 года»";
	-- Commands
	L["ADD"] = "добавлять";
	L["IGNORE"] = "игнорировать";
	L["REMOVE"] = "Удалить";
	L["SEARCH"] = "поиск";
	-- Options Frame
	L["ITEMS_SEEN"] = "«Видимые предметы»";
	-- Mode Options
	L["MODE"] = "Режим";
	L["NORMAL_MODE"] = "Нормальный";
	L["QUIET_MODE"] = "Тихо";
	-- Rarity Options
	L["Rareza"] = "«Раритет»";
	L["LEGENDARY"] = "| cffff8000" .. "«Легендарный»|r";
	L["EPIC"] = "| cffa335ee" .. "«Эпос»|r";
	L["RARE"] = "| cff0070dd" .. "«Редкие»|r";
	L["UNCOMMON"] = "| cff1eff00" .. "«Необычный»|r";
	-- Other
	L["TRADESKILL"] = "«Ремесленный»";
	L["MAIL"] = "«Почта»";
	L["TRADE"] = "Сделка";
	L["LOOT_ITEM_PUSHED_SELF"] = "«Вы получаете товар»";
	L["LOOT_ITEM_SELF"] = "Вы получаете добычу";
return end;

if LOCALE == "koKR" then -- Korean
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "2019 년 4 월 30 일";
	-- Commands
	L["ADD"] = "더하다";
	L["IGNORE"] = "무시하다";
	L["REMOVE"] = "풀다";
	L["SEARCH"] = "수색";
	-- Options Frame
	L["ITEMS_SEEN"] = "본 아이템";
	-- Mode Options
	L["MODE"] = "방법";
	L["NORMAL_MODE"] = "표준";
	L["QUIET_MODE"] = "조용한";
	-- Rarity Options
	L["Rareza"] = "희박";
	L["LEGENDARY"] = "| cffff8000" .. "전설적인|r";
	L["EPIC"] = "| cffa335ee" .. "서사시|r";
	L["RARE"] = "| cff0070dd" .. "드문|r";
	L["UNCOMMON"] = "| cff1eff00" .. "드문|r";
	-- Other
	L["TRADESKILL"] = "Tradeskill";
	L["MAIL"] = "우편";
	L["TRADE"] = "무역";
	L["LOOT_ITEM_PUSHED_SELF"] = "당신은 아이템을받습니다";
	L["LOOT_ITEM_SELF"] = "당신은 전리품을 얻는다";
return end;

if LOCALE == "zhCN" then -- Simplified Chinese
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "2019年4月30日";
	-- Commands
	L["ADD"] = "加";
	L["IGNORE"] = "忽视";
	L["REMOVE"] = "去掉";
	L["SEARCH"] = "搜索";
	-- Options Frame
	L["ITEMS_SEEN"] = "看到的物品";
	-- Mode Options
	L["MODE"] = "模式";
	L["NORMAL_MODE"] = "正常";
	L["QUIET_MODE"] = "安静";
	-- Rarity Options
	L["Rareza"] = "稀有";
	L["LEGENDARY"] = "| cffff8000" .. "传奇的|r";
	L["EPIC"] = "| cffa335ee" .. "史诗|r";
	L["RARE"] = "| cff0070dd" .. "罕见|r";
	L["UNCOMMON"] = "| cff1eff00" .. "罕见|r";
	-- Other
	L["TRADESKILL"] = "商业技能";
	L["MAIL"] = "邮件";
	L["TRADE"] = "交易";
	L["LOOT_ITEM_PUSHED_SELF"] = "你收到物品";
	L["LOOT_ITEM_SELF"] = "你收到战利品";
return end;

if LOCALE == "zhTW" then -- Traditional Chinese
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "2019年4月30日";
	-- Commands
	L["ADD"] = "加";
	L["IGNORE"] = "忽視";
	L["REMOVE"] = "去掉";
	L["SEARCH"] = "搜索";
	-- Options Frame
	L["ITEMS_SEEN"] = "看到的物品";
	-- Mode Options
	L["MODE"] = "模式";
	L["NORMAL_MODE"] = "正常";
	L["QUIET_MODE"] = "安靜";
	-- Rarity Options
	L["Rareza"] = "稀有";
	L["LEGENDARY"] = "| cffff8000" .. "傳奇的|r";
	L["EPIC"] = "| cffa335ee" .. "史詩|r";
	L["RARE"] = "| cff0070dd" .. "罕見|r";
	L["UNCOMMON"] = "| cff1eff00" .. "罕見|r";
	-- Other
	L["TRADESKILL"] = "商業技能";
	L["MAIL"] = "郵件";
	L["TRADE"] = "交易";
	L["LOOT_ITEM_PUSHED_SELF"] = "你收到物品";
	L["LOOT_ITEM_SELF"] = "你收到戰利品";
return end;