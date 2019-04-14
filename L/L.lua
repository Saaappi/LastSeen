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
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "add";
	L["ignore"] = "ignore";
	L["remove"] = "remove";
	L["search"] = "search";
	-- Other
	L["tradeskill"] = "Tradeskill";
return end;

if LOCALE == "frFR" then -- French
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (Discorde)";
	-- Commands
	L["add"] = "ajouter";
	L["ignore"] = "ignorer";
	L["remove"] = "retirer";
	L["search"] = "chercher";
	-- Other
	L["tradeskill"] = "Artisanat";
return end;

if LOCALE == "deDE" then -- German
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (Zwietracht)";
	-- Commands
	L["add"] = "hinzufügen";
	L["ignore"] = "ignorieren";
	L["remove"] = "löschen";
	L["search"] = "suche";
	-- Other
	L["tradeskill"] = "Handelsfertigkeit";
return end;

if LOCALE == "esES" or LOCALE == "esMX" then -- Spanish
	-- General
	L["author"] = "Oxlotus - Área 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (Discordia)";
	-- Commands
	L["add"] = "añadir";
	L["ignore"] = "ignorar";
	L["remove"] = "retirar";
	L["search"] = "buscar";
	-- Other
	L["tradeskill"] = "Destreza";
return end;

if LOCALE == "ptBR" then -- Brazilian Portuguese 
	-- General
	L["author"] = "Oxlotus - Área 52 [EUA]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (discórdia)";
	-- Commands
	L["add"] = "adicionar";
	L["ignore"] = "ignorar";
	L["remove"] = "remover";
	L["search"] = "procurar";
	-- Other
	L["tradeskill"] = "Tradeskill";
return end;

if LOCALE == "ruRU" then -- Russian
	-- General
	L["author"] = "Окслот - Зона 52 [США]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "добавлять";
	L["ignore"] = "игнорировать";
	L["remove"] = "Удалить";
	L["search"] = "поиск";
	-- Other
	L["tradeskill"] = "ремесленных";
return end;

if LOCALE == "koKR" then -- Korean
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (불화)";
	-- Commands
	L["add"] = "더하다";
	L["ignore"] = "무시하다";
	L["remove"] = "풀다";
	L["search"] = "수색";
	-- Other
	L["tradeskill"] = "Tradeskill";
return end;

if LOCALE == "zhCN" then -- Simplified Chinese
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "加";
	L["ignore"] = "忽视";
	L["remove"] = "去掉";
	L["search"] = "搜索";
	-- Other
	L["tradeskill"] = "商业技能";
return end;

if LOCALE == "zhTW" then -- Traditional Chinese
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "13, April 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "加";
	L["ignore"] = "忽視";
	L["remove"] = "去掉";
	L["search"] = "搜索";
	-- Other
	L["tradeskill"] = "商業技能";
return end;