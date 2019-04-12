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

if LOCALE == "enUS" then
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "12, April 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "add";
	L["clear"] = "clear";
	L["dump"] = "dump";
	L["search"] = "search";
return end;

if LOCALE == "frFR" then
	-- General
	L["author"] = "Oxlotus - Area 52 [US]";
	L["release"] = GetAddOnMetadata(addonName, "Version");
	L["releaseDate"] = "12, April 2019";
	L["contact"] = "Oxlotus#1001 (Discord)";
	-- Commands
	L["add"] = "ajouter";
	L["clear"] = "clair";
	L["dump"] = "déverser";
	L["search"] = "chercher";
return end;