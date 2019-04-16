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
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "add";
	L["ignore"] = "ignore";
	L["remove"] = "remove";
	L["search"] = "search";
	-- Options
	L["mode"] = "Mode";
	L["verbose"] = "Verbose";
	L["normal"] = "Normal";
	L["quiet"] = "Quiet";
	-- Other
	L["tradeskill"] = "Tradeskill";
	L["LOOT_ITEM_PUSHED_SELF"] = "You receive item";
	L["LOOT_ITEM_SELF"] = "You receive loot";
return end;

if LOCALE == "frFR" then -- French
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (Discorde)";
	-- Commands
	L["add"] = "ajouter";
	L["ignore"] = "ignorer";
	L["remove"] = "retirer";
	L["search"] = "chercher";
	-- Other
	L["tradeskill"] = "Artisanat";
	L["LOOT_ITEM_PUSHED_SELF"] = "Vous recevez l'article";
	L["LOOT_ITEM_SELF"] = "Vous recevez du butin";
return end;

if LOCALE == "deDE" then -- German
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (Zwietracht)";
	-- Commands
	L["add"] = "hinzufügen";
	L["ignore"] = "ignorieren";
	L["remove"] = "löschen";
	L["search"] = "suche";
	-- Other
	L["tradeskill"] = "Handelsfertigkeit";
	L["LOOT_ITEM_PUSHED_SELF"] = "Sie erhalten einen Artikel";
	L["LOOT_ITEM_SELF"] = "Sie erhalten Beute";
return end;

if LOCALE == "esES" or LOCALE == "esMX" then -- Spanish
	-- General
	L["author"] = "Oxlotus - Área 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (Discordia)";
	-- Commands
	L["add"] = "añadir";
	L["ignore"] = "ignorar";
	L["remove"] = "retirar";
	L["search"] = "buscar";
	-- Other
	L["tradeskill"] = "Destreza";
	L["LOOT_ITEM_PUSHED_SELF"] = "Usted recibe el artículo";
	L["LOOT_ITEM_SELF"] = "Usted recibe botín";
return end;

if LOCALE == "ptBR" then -- Brazilian Portuguese 
	-- General
	L["author"] = "Oxlotus - Área 52 [EUA]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (discórdia)";
	-- Commands
	L["add"] = "adicionar";
	L["ignore"] = "ignorar";
	L["remove"] = "remover";
	L["search"] = "procurar";
	-- Other
	L["tradeskill"] = "Tradeskill";
	L["LOOT_ITEM_PUSHED_SELF"] = "Você recebe item";
	L["LOOT_ITEM_SELF"] = "Você recebe saque";
return end;

if LOCALE == "ruRU" then -- Russian
	-- General
	L["author"] = "Окслот - Зона 52 [США]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "добавлять";
	L["ignore"] = "игнорировать";
	L["remove"] = "Удалить";
	L["search"] = "поиск";
	-- Other
	L["tradeskill"] = "ремесленных";
	L["LOOT_ITEM_PUSHED_SELF"] = "Вы получаете товар";
	L["LOOT_ITEM_SELF"] = "Вы получаете добычу";
return end;

if LOCALE == "koKR" then -- Korean
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (불화)";
	-- Commands
	L["add"] = "더하다";
	L["ignore"] = "무시하다";
	L["remove"] = "풀다";
	L["search"] = "수색";
	-- Other
	L["tradeskill"] = "Tradeskill";
	L["LOOT_ITEM_PUSHED_SELF"] = "아이템을받습니다.";
	L["LOOT_ITEM_SELF"] = "당신은 전리품을받습니다.";
return end;

if LOCALE == "zhCN" then -- Simplified Chinese
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "加";
	L["ignore"] = "忽视";
	L["remove"] = "去掉";
	L["search"] = "搜索";
	-- Other
	L["tradeskill"] = "商业技能";
	L["LOOT_ITEM_PUSHED_SELF"] = "你收到物品";
	L["LOOT_ITEM_SELF"] = "你收到战利品";
return end;

if LOCALE == "zhTW" then -- Traditional Chinese
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "15 April, 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "加";
	L["ignore"] = "忽視";
	L["remove"] = "去掉";
	L["search"] = "搜索";
	-- Other
	L["tradeskill"] = "商業技能";
	L["LOOT_ITEM_PUSHED_SELF"] = "你收到物品";
	L["LOOT_ITEM_SELF"] = "你收到戰利品";
return end;