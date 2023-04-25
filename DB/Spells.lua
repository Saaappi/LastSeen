local addonName, addonTable = ...

local dictionary = {
	["Herbalism"] = function() return select(2, string.split(" ", UNIT_SKINNABLE_HERB)) end,
	["Mining"] = function() return select(2, string.split(" ", UNIT_SKINNABLE_ROCK)) end,
	["Skinning"] = function() return (GetSpellInfo(265857)) end,
}

local targetSpells = {
	[3365] = "", -- Opening (used by lots of chests and objects in the game)
	[6477] = "", -- Opening (used by lots of chests and objects in the game)
	[6478] = "", -- Opening (used by lots of chests and objects in the game)
}
addonTable.targetSpells = targetSpells

local noTargetSpells = {
	[2575] = dictionary["Mining"](), 		-- Classic
	[265837] = dictionary["Mining"](), 		-- Classic
	[265839] = dictionary["Mining"](), 		-- Outland
	[265841] = dictionary["Mining"](), 		-- Northrend
	[265843] = dictionary["Mining"](), 		-- Cataclysm
	[265845] = dictionary["Mining"](), 		-- Pandaria
	[265847] = dictionary["Mining"](), 		-- Draenor
	[265849] = dictionary["Mining"](), 		-- Legion
	[265851] = dictionary["Mining"](), 		-- Kul Tiran
	[265853] = dictionary["Mining"](), 		-- Zandalari
	[309835] = dictionary["Mining"](), 		-- Shadowlands
	[366260] = dictionary["Mining"](), 		-- Dragonflight
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

local skinningSpells = {
	[8613] = dictionary["Skinning"](), 		-- Classic
	[265857] = dictionary["Skinning"](), 	-- Outland
	[265859] = dictionary["Skinning"](), 	-- Northrend
	[265861] = dictionary["Skinning"](), 	-- Cataclysm
	[265863] = dictionary["Skinning"](), 	-- Pandaria
	[265865] = dictionary["Skinning"](), 	-- Draenor
	[265867] = dictionary["Skinning"](), 	-- Legion
	[265869] = dictionary["Skinning"](), 	-- Kul Tiran
	[265871] = dictionary["Skinning"](), 	-- Zandalari
	[308569] = dictionary["Skinning"](), 	-- Shadowlands
}