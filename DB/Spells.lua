local addonName, addonTable = ...
local _, PROFESSIONS_MINING = string.split(" ", UNIT_SKINNABLE_ROCK)
local _, PROFESSIONS_HERBALISM = string.split(" ", UNIT_SKINNABLE_HERB)

local targetSpells = {
	[3365] = "", -- Opening (used by lots of chests and objects in the game)
	[6477] = "", -- Opening (used by lots of chests and objects in the game)
	[6478] = "", -- Opening (used by lots of chests and objects in the game)
}
addonTable.targetSpells = targetSpells

local noTargetSpells = {
	[2575] = PROFESSIONS_MINING,
	[265819] = PROFESSIONS_HERBALISM, -- Classic Herbalism
	[265821] = PROFESSIONS_HERBALISM, -- Outland Herbalism
	[265823] = PROFESSIONS_HERBALISM, -- Northrend Herbalism
	[265825] = PROFESSIONS_HERBALISM, -- Cataclysm Herbalism
	[265827] = PROFESSIONS_HERBALISM, -- Pandaria Herbalism
	[265829] = PROFESSIONS_HERBALISM, -- Draenor Herbalism
	[265831] = PROFESSIONS_HERBALISM, -- Kul Tiran Herbalism
	[265834] = PROFESSIONS_HERBALISM, -- Legion Herbalism
	[265835] = PROFESSIONS_HERBALISM, -- Kul Tiran Herbalism
	[309780] = PROFESSIONS_HERBALISM, -- Shadowlands Herbalism
	[366252] = PROFESSIONS_HERBALISM, -- Dragonflight Herbalism
}
addonTable.noTargetSpells = noTargetSpells