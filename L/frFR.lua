-------------------------------------------------------------------------
-- LastSeen (FR Localization) | Oxlotus - Area 52 (US) | Copyright © 2019
-------------------------------------------------------------------------

local addonName, addonTable = ...;

local addonVersion = GetAddOnMetadata(addonName, "Version"); addonTable.addonVersion = addonVersion;
local addonReleaseDate = "12 April, 2019"; addonTable.addonReleaseDate = addonReleaseDate;
local addonAuthor = "Oxlotus - Area 52 [US]"; addonTable.addonAuthor = addonAuthor;
local addonAuthorContact = "Oxlotus#1001 (Discorde)"; addonTable.addonAuthorContact = addonAuthorContact;
local commands = "ajouter, clair, déverser, chercher"; addonTable.commands = commands;