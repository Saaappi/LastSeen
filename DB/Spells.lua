local addonName, addonTable = ...

local spellDictionary = {
	["Herbalism"] = function() return select(2, string.split(" ", UNIT_SKINNABLE_HERB)) end,
	["Mining"] = function() return select(2, string.split(" ", UNIT_SKINNABLE_ROCK)) end,
}

local targetSpells = {
	[3365] = "", -- Opening (used by lots of chests and objects in the game)
	[6477] = "", -- Opening (used by lots of chests and objects in the game)
	[6478] = "", -- Opening (used by lots of chests and objects in the game)
}
addonTable.targetSpells = targetSpells

local noTargetSpells = {
	[2575] = spellDictionary["Mining"](),
	[265819] = spellDictionary["Herbalism"](),
	[265821] = spellDictionary["Herbalism"](),
	[265823] = spellDictionary["Herbalism"](),
	[265825] = spellDictionary["Herbalism"](),
	[265827] = spellDictionary["Herbalism"](),
	[265829] = spellDictionary["Herbalism"](),
	[265831] = spellDictionary["Herbalism"](),
	[265834] = spellDictionary["Herbalism"](),
	[265835] = spellDictionary["Herbalism"](),
	[309780] = spellDictionary["Herbalism"](),
	[366252] = spellDictionary["Herbalism"](),
}
addonTable.noTargetSpells = noTargetSpells