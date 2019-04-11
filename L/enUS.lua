-------------------------------------------------------------------------
-- LastSeen (US Localization) | Oxlotus - Area 52 (US) | Copyright © 2019
-------------------------------------------------------------------------

local addonName, addonTable = ...;

local addonVersion = GetAddOnMetadata(addonName, "Version"); addonTable.addonVersion = addonVersion;
local addonReleaseDate = "11 April, 2019"; addonTable.addonReleaseDate = addonReleaseDate;
local addonAuthor = "Oxlotus - Area 52 [US]"; addonTable.addonAuthor = addonAuthor;
local addonAuthorContact = "Oxlotus#1001 (Discord)"; addonTable.addonAuthorContact = addonAuthorContact;
local commands = "add, clear, dump, search"; addonTable.commands = commands;