local addonName, addon = ...

local oldSettings = {
	["minimapPos"] = true,
	["RarityId"] = true,
	["ModeId"] = true,
	["ShowExtraSourcesEnabled"] = true,
}
addon.oldSettings = oldSettings