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
	L["CONTACT"] = "Oxlotus#1001 (Discord)";
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
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	L["CONTACT"] = "Oxlotus#1001 (Discorde)";
	-- Commands
	L["ADD"] = "ajouter";
	L["IGNORE"] = "ignorer";
	L["REMOVE"] = "retirer";
	L["SEARCH"] = "chercher";
	-- Other
	L["tradeskill"] = "Artisanat";
	L["LOOT_ITEM_PUSHED_SELF"] = "Vous recevez l'article";
	L["LOOT_ITEM_SELF"] = "Vous recevez du butin";
return end;

if LOCALE == "deDE" then -- German
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	L["CONTACT"] = "Oxlotus#1001 (Zwietracht)";
	-- Commands
	L["ADD"] = "hinzufügen";
	L["IGNORE"] = "ignorieren";
	L["REMOVE"] = "löschen";
	L["SEARCH"] = "suche";
	-- Other
	L["tradeskill"] = "Handelsfertigkeit";
	L["LOOT_ITEM_PUSHED_SELF"] = "Sie erhalten einen Artikel";
	L["LOOT_ITEM_SELF"] = "Sie erhalten Beute";
return end;

if LOCALE == "esES" or LOCALE == "esMX" then -- Spanish
	-- General
	L["AUTHOR"] = "Oxlotus - Área 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	L["CONTACT"] = "Oxlotus#1001 (Discordia)";
	-- Commands
	L["ADD"] = "añadir";
	L["IGNORE"] = "ignorar";
	L["REMOVE"] = "retirar";
	L["SEARCH"] = "buscar";
	-- Other
	L["tradeskill"] = "Destreza";
	L["LOOT_ITEM_PUSHED_SELF"] = "Usted recibe el artículo";
	L["LOOT_ITEM_SELF"] = "Usted recibe botín";
return end;

if LOCALE == "ptBR" then -- Brazilian Portuguese 
	-- General
	L["AUTHOR"] = "Oxlotus - Área 52 [EUA]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	L["CONTACT"] = "Oxlotus#1001 (discórdia)";
	-- Commands
	L["ADD"] = "adicionar";
	L["IGNORE"] = "ignorar";
	L["REMOVE"] = "remover";
	L["SEARCH"] = "procurar";
	-- Other
	L["tradeskill"] = "Tradeskill";
	L["LOOT_ITEM_PUSHED_SELF"] = "Você recebe item";
	L["LOOT_ITEM_SELF"] = "Você recebe saque";
return end;

if LOCALE == "ruRU" then -- Russian
	-- General
	L["AUTHOR"] = "Окслот - Зона 52 [США]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	L["CONTACT"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["ADD"] = "добавлять";
	L["IGNORE"] = "игнорировать";
	L["REMOVE"] = "Удалить";
	L["SEARCH"] = "поиск";
	-- Other
	L["tradeskill"] = "ремесленных";
	L["LOOT_ITEM_PUSHED_SELF"] = "Вы получаете товар";
	L["LOOT_ITEM_SELF"] = "Вы получаете добычу";
return end;

if LOCALE == "koKR" then -- Korean
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	L["CONTACT"] = "Oxlotus#1001 (불화)";
	-- Commands
	L["ADD"] = "더하다";
	L["IGNORE"] = "무시하다";
	L["REMOVE"] = "풀다";
	L["SEARCH"] = "수색";
	-- Other
	L["tradeskill"] = "Tradeskill";
	L["LOOT_ITEM_PUSHED_SELF"] = "아이템을받습니다.";
	L["LOOT_ITEM_SELF"] = "당신은 전리품을받습니다.";
return end;

if LOCALE == "zhCN" then -- Simplified Chinese
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	L["CONTACT"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["ADD"] = "加";
	L["IGNORE"] = "忽视";
	L["REMOVE"] = "去掉";
	L["SEARCH"] = "搜索";
	-- Other
	L["tradeskill"] = "商业技能";
	L["LOOT_ITEM_PUSHED_SELF"] = "你收到物品";
	L["LOOT_ITEM_SELF"] = "你收到战利品";
return end;

if LOCALE == "zhTW" then -- Traditional Chinese
	-- General
	L["AUTHOR"] = "Oxlotus - Area 52 [US]";
	L["RELEASE"] = GetAddOnMetadata(addonName, "Version");
	L["RELEASE_DATE"] = "15 April, 2019";
	L["CONTACT"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["ADD"] = "加";
	L["IGNORE"] = "忽視";
	L["REMOVE"] = "去掉";
	L["SEARCH"] = "搜索";
	-- Other
	L["tradeskill"] = "商業技能";
	L["LOOT_ITEM_PUSHED_SELF"] = "你收到物品";
	L["LOOT_ITEM_SELF"] = "你收到戰利品";
return end;