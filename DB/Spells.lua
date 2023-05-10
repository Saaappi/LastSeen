local addonName, addon = ...

local dictionary = {
	["Herbalism"] = function() return select(2, string.split(" ", UNIT_SKINNABLE_HERB)) end,
	["Mining"] = function() return select(2, string.split(" ", UNIT_SKINNABLE_ROCK)) end,
	["Skinning"] = function() return (GetSpellInfo(265857)) end,
	["Archaeology"] = function() return (GetSpellInfo(78670)) end,
}

local targetSpells = {
	[3365] = "",
	[6477] = "",
	[6478] = "",
	[407741] = "",
}
addon.targetSpells = targetSpells

local noTargetSpells = {
	-- Mining
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
	
	-- Herbalism
	[2366] = dictionary["Herbalism"](), 	-- Classic
	[265819] = dictionary["Herbalism"](), 	-- Classic
	[265821] = dictionary["Herbalism"](), 	-- Outland
	[265823] = dictionary["Herbalism"](), 	-- Northrend
	[265825] = dictionary["Herbalism"](), 	-- Cataclysm
	[265827] = dictionary["Herbalism"](), 	-- Pandaria
	[265829] = dictionary["Herbalism"](), 	-- Draenor
	[265834] = dictionary["Herbalism"](), 	-- Legion
	[265831] = dictionary["Herbalism"](), 	-- Kul Tiran
	[265835] = dictionary["Herbalism"](), 	-- Zandalari
	[309780] = dictionary["Herbalism"](), 	-- Shadowlands
	[366252] = dictionary["Herbalism"](), 	-- Dragonflight
	
	-- Archaeology
	[73979] = dictionary["Archaeology"](), 	-- Searching for Artifacts
}
addon.noTargetSpells = noTargetSpells

local skinningSpells = {
	[8613] = dictionary["Skinning"](), 		-- Classic
	[265855] = dictionary["Skinning"](), 	-- Classic
	[265857] = dictionary["Skinning"](), 	-- Outland
	[265859] = dictionary["Skinning"](), 	-- Northrend
	[265861] = dictionary["Skinning"](), 	-- Cataclysm
	[265863] = dictionary["Skinning"](), 	-- Pandaria
	[265865] = dictionary["Skinning"](), 	-- Draenor
	[265867] = dictionary["Skinning"](), 	-- Legion
	[265869] = dictionary["Skinning"](), 	-- Kul Tiran
	[265871] = dictionary["Skinning"](), 	-- Zandalari
	[308569] = dictionary["Skinning"](), 	-- Shadowlands
	[366259] = dictionary["Skinning"](), 	-- Dragonflight
}
addon.skinningSpells = skinningSpells