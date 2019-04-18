-------------------------------------------------------------------------
-- LastSeen (FR Localization) | Oxlotus - Area 52 (US) | Copyright © 2019
-------------------------------------------------------------------------

local addonName, addonTable = ...;

local L = setmetatable({}, { __index = function(t, k)
	local text = tostring(k);
	rawset(t, k, text);
	return text;
end });

addonTable.L = L;

local LOCALE = GetLocale();

if LOCALE == "enUS" or LOCALE == "enGB" then -- US/EU English
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	-- Commands
	L["ADD"] = "add";
	L["IGNORE"] = "ignore";
	L["REMOVE"] = "remove";
	L["SEARCH"] = "search";
	-- Options Frame
	L["ITEMS_SEEN"] = "Items Seen";
	-- Mode Options
	L["MODE"] = "mode";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Quiet";
	-- Rarity Options
	L["Rarity"] = "Rarity";
	L["LEGENDARY"] = "|cffff8000" .. "Legendary|r";
	L["EPIC"] = "|cffa335ee" .. "Epic|r";
	L["RARE"] = "|cff0070dd" .. "Rare|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Uncommon|r";
	-- Other
	L["TRADESKILL"] = "Tradeskill";
	L["MAIL"] = "Mail";
	L["LOOT_ITEM_PUSHED_SELF"] = "You receive item";
	L["LOOT_ITEM_SELF"] = "You receive loot";
return end;

if LOCALE == "frFR" then -- French
	-- General
	L["AUTHOR"] = "Oxlotus-Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 avril, 2019";
	-- Commands
	L["ADD"] = "ajouter";
	L["IGNORE"] = "ignorer";
	L["REMOVE"] = "retirer";
	L["SEARCH"] = "chercher";
	-- Options Frame
	L["ITEMS_SEEN"] = "objets vus";
	-- Mode Options
	L["MODE"] = "mode";
	L["NORMAL_MODE"] = "Normal";
	L["QUIET_MODE"] = "Silencieux";
	-- Rarity Options
	L["Rarity"] = "Rareté";
	L["LEGENDARY"] = "|cffff8000" .. "Légendaire|r";
	L["EPIC"] = "|cffa335ee" .. "Epic|r";
	L["RARE"] = "|cff0070dd" .. "Rare|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Peu fréquent|r";
	-- Other
	L["TRADESKILL"] = "Artisanat";
	L["MAIL"] = "Mail";
	L["LOOT_ITEM_PUSHED_SELF"] = "Vous recevez l'article";
	L["LOOT_ITEM_SELF"] = "Vous recevez du butin";
return end;

if LOCALE == "deDE" then -- German
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15. April 2019";
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
	L["Rarity"] = "Seltenheit";
	L["LEGENDARY"] = "|cffff8000" .. "Legendär|r";
	L["EPIC"] = "|cffa335ee" .. "Epos|r";
	L["RARE"] = "|cff0070dd" .. "Selten|r";
	L["UNCOMMON"] = "|cff1eff00" .. "Ungewöhnlich|r";
	-- Other
	L["TRADESKILL"] = "Handelsfertigkeit";
	L["MAIL"] = "Mail";
	L["LOOT_ITEM_PUSHED_SELF"] = "Sie erhalten Artikel";
	L["LOOT_ITEM_SELF"] = "Sie erhalten Artikel";
return end;

if LOCALE == "esES" or LOCALE == "esMX" then -- Spanish
	-- General
	L["AUTHOR"] = "Oxlotus - Área 52 [US]";
	L["RELEASE"] = GetAddOnMetadata (addonName, "Version");
	L["RELEASE_DATE"] = "15 de abril de 2019";
	-- Commands
	L["ADD"] = "añadir";
	L["IGNORE"] = "ignorar";
	L["REMOVE"] = "eliminar";
	L["SEARCH"] = "búsqueda";
	-- Options Frame
	L["ITEMS_SEEN"] = "Artículos vistos";
	-- Mode Options
	L["MODE"] = "modo";
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
	L["LOOT_ITEM_PUSHED_SELF"] = "Usted recibe el artículo";
	L["LOOT_ITEM_SELF"] = "Usted recibe botín";
return end;

if LOCALE == "ptBR" then -- Brazilian Portuguese 
	-- General
	L["AUTHOR"] = "Oxlotus - Área 52 [EUA]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 de abril de 2019";
	-- Commands
	L["ADD"] = "adicionar";
	L["IGNORE"] = "ignorar";
	L["REMOVE"] = "remover";
	L["SEARCH"] = "procurar";
	-- Options Frame
	L["ITEMS_SEEN"] = "Itens vistos";
	-- Mode Options
	L["MODE"] = "modo";
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
	L["LOOT_ITEM_PUSHED_SELF"] = "Você recebe um item";
	L["LOOT_ITEM_SELF"] = "Você recebe saque";
return end;

if LOCALE == "ruRU" then -- Russian
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "«15 апреля 2019 года»";
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
	L["LOOT_ITEM_PUSHED_SELF"] = "«Вы получаете товар»";
	L["LOOT_ITEM_SELF"] = "Вы получаете добычу";
return end;

if LOCALE == "koKR" then -- Korean
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "2019 년 4 월 15 일";
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
	L["LOOT_ITEM_PUSHED_SELF"] = "당신은 아이템을받습니다";
	L["LOOT_ITEM_SELF"] = "당신은 전리품을 얻는다";
return end;

if LOCALE == "zhCN" then -- Simplified Chinese
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "2019年4月15日";
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
	L["LOOT_ITEM_PUSHED_SELF"] = "你收到物品";
	L["LOOT_ITEM_SELF"] = "你收到战利品";
return end;

if LOCALE == "zhTW" then -- Traditional Chinese
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "2019年4月15日";
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
	L["LOOT_ITEM_PUSHED_SELF"] = "你收到物品";
	L["LOOT_ITEM_SELF"] = "你收到戰利品";
return end;