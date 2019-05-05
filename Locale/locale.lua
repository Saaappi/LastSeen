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
	L["ADDON_NAME"] = "|cff00ccff" .. lastSeen .. "|r: ";
	L["ADDON_NAME_SETTINGS"] = "|cff00ccff" .. lastSeen .. "|r";
	-- INFO | WARNINGS | ERRORS
	L["ADDED_ITEM"] = "Added ";
	L["NO_ITEMS_FOUND"] = "No items found!";
	L["NO_QUESTS_FOUND"] = "No quests found!";
	L["MERCHANT"] = "Merchant";
	L["NEW_LOCATION"] = "Different Map";
	L["NEW_LOOT_DATE"] = "Newer Date";
	L["NEW_SOURCE"] = "Different Source";
	L["IGNORE_ITEM"] = "Ignoring ";
	L["!IGNORE_ITEM"] = "Stopped ignoring ";
	L["ITEM_EXISTS"] = "Item exists!";
	L["REASON"] = "Reason: ";
	L["REMOVE_ITEM"] = "Removed ";
	L["UPDATED_ITEM"] = "Updated ";
	L["MATCHED_TERM"] = " matching ";
	L["NEVER_LOOTED"] = "Never Looted";
	L["WARNING"] = "Unable to complete that action! ";
	-- ERRORS
	L["NO_QUESTS_COMPLETED"] = "No quests have been completed on your account.";
	-- NAMEPLATES
	L["IS_CREATURE"] = "Creature";
	L["IS_VEHICLE"] = "Vehicle";
	-- ITEM TYPES
	L["IS_TRADESKILL_ITEM"] = "Tradeskill";
	L["IS_QUEST_ITEM"] = "Q";
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "30 April, 2019";
	-- Commands
	L["ADD"] = "add";
	L["IGNORE"] = "ignore";
	L["REMOVE"] = "remove";
	L["SEARCH"] = "search";
	-- Options Frame
	L["ITEMS_SEEN"] = "Items Seen";
	-- Mode Options
	L["MODE"] = "Mode";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Quiet";
	-- Rarity Options
	L["RARITY"] = "Rarity";
	L["LEGENDARY"] = "|cffff8000" .. "Legendary|r";
	L["EPIC"] = "|cffa335ee" .. "Epic|r";
	L["RARE"] = "|cff0070dd" .. "Rare|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Uncommon|r";
	L["COMMON"] = "|cffffffff" .. "Common|r";
	L["POOR"] = "|cff9d9d9d" .. "Poor|r";
	-- Other
	L["IS_CRAFTED_ITEM"] = "Crafted";
	L["MAIL"] = "Mail";
	L["TRADE"] = "Trade";
	L["LOOT_ITEM_CREATED_SELF"] = "You create";
	L["LOOT_ITEM_PUSHED_SELF"] = "You receive item";
	L["LOOT_ITEM_SELF"] = "You receive loot";
return end;

if LOCALE == "frFR" then -- French
	-- General
	L["AUTHOR"] = "Oxlotus-Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "30 avril, 2019";
	-- Commands
	L["ADD"] = "ajouter";
	L["IGNORE"] = "ignorer";
	L["REMOVE"] = "retirer";
	L["SEARCH"] = "chercher";
	-- Options Frame
	L["ITEMS_SEEN"] = "objets vus";
	-- Mode Options
	L["MODE"] = "Mode";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Silencieux";
	-- Rarity Options
	L["RARITY"] = "Rareté";
	L["LEGENDARY"] = "|cffff8000" .. "Légendaire|r";
	L["EPIC"] = "|cffa335ee" .. "Epic|r";
	L["RARE"] = "|cff0070dd" .. "Rare|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Peu fréquent|r";
	-- Other
	L["TRADESKILL"] = "Artisanat";
	L["MAIL"] = "Mail";
	L["TRADE"] = "Commerce";
	L["LOOT_ITEM_PUSHED_SELF"] = "Vous recevez l'article";
	L["LOOT_ITEM_SELF"] = "Vous recevez du butin";
return end;

if LOCALE == "deDE" then -- German
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(lastSeen, "Version");
	L["RELEASE_DATE"] = "30. April 2019";
	-- Commands
	L["ADD"] = "hinzufügen";
	L["IGNORE"] = "ignorieren";
	L["REMOVE"] = "löschen";
	L["SEARCH"] = "suche";
	-- Options Frame
	L["ITEMS_SEEN"] = "Artikel gesehen";
	-- Mode Options
	L["MODE"] = "Modus";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Ruhig";
	-- Rarity Options
	L["RARITY"] = "Seltenheit";
	L["LEGENDARY"] = "|cffff8000" .. "Legendär|r";
	L["EPIC"] = "|cffa335ee" .. "Epos|r";
	L["RARE"] = "|cff0070dd" .. "Selten|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Ungewöhnlich|r";
	-- Other
	L["TRADESKILL"] = "Handelsfertigkeit";
	L["MAIL"] = "Mail";
	L["TRADE"] = "Handel";
	L["LOOT_ITEM_PUSHED_SELF"] = "Sie erhalten Artikel";
	L["LOOT_ITEM_SELF"] = "Sie erhalten Artikel";
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