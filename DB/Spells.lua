local addonName, addonTable = ...

local dictionary = {
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
	[2575] = dictionary["Mining"](),
	[265837] = dictionary["Mining"](),
	[265838] = dictionary["Mining"](),
	[265839] = dictionary["Mining"](),
	[265841] = dictionary["Mining"](),
	[265843] = dictionary["Mining"](),
	[265845] = dictionary["Mining"](),
	[265847] = dictionary["Mining"](),
	[265849] = dictionary["Mining"](),
	[265851] = dictionary["Mining"](),
	[265853] = dictionary["Mining"](),
	[265819] = dictionary["Herbalism"](),
	[265821] = dictionary["Herbalism"](),
	[265823] = dictionary["Herbalism"](),
	[265825] = dictionary["Herbalism"](),
	[265827] = dictionary["Herbalism"](),
	[265829] = dictionary["Herbalism"](),
	[265831] = dictionary["Herbalism"](),
	[265834] = dictionary["Herbalism"](),
	[265835] = dictionary["Herbalism"](),
	[309780] = dictionary["Herbalism"](),
	[366252] = dictionary["Herbalism"](),
}
addonTable.noTargetSpells = noTargetSpells