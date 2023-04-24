local addonName, addonTable = ...

local spellDictionary = {
	["Nomi"] = function() return select(2, string.split(" ", (GetSpellInfo(202510)))) end,
}

-- These are items that have a valid source, but the addon is classifying them
-- as unknown.
local unknownItems = {
	-- Non-Recipes Items
	[143681] = spellDictionary["Nomi"](), -- Slightly Burnt Food
	[146757] = spellDictionary["Nomi"](), -- Prepared Ingredients
	-- Azshari Salad
	[133822] = spellDictionary["Nomi"](), -- Rank 1
	[133842] = spellDictionary["Nomi"](), -- Rank 2
	[133862] = spellDictionary["Nomi"](), -- Rank 3
	-- Barracuda Mrglgagh
	[133838] = spellDictionary["Nomi"](), -- Rank 2
	[133858] = spellDictionary["Nomi"](), -- Rank 3
	-- Bear Tartare
	[133847] = spellDictionary["Nomi"](), -- Rank 2
	[133867] = spellDictionary["Nomi"](), -- Rank 3
	-- Crispy Bacon
	[133871] = spellDictionary["Nomi"](), -- Rank 1
	[133872] = spellDictionary["Nomi"](), -- Rank 2
	[133873] = spellDictionary["Nomi"](), -- Rank 3
	-- Deep-Fried Mossgill
	[133832] = spellDictionary["Nomi"](), -- Rank 2
	[133852] = spellDictionary["Nomi"](), -- Rank 3
	-- Drogbar-Style Salmon
	[133840] = spellDictionary["Nomi"](), -- Rank 2
	[133860] = spellDictionary["Nomi"](), -- Rank 3
	-- Faronaar Fizz
	[133834] = spellDictionary["Nomi"](), -- Rank 2
	[133854] = spellDictionary["Nomi"](), -- Rank 3
	-- Fighter Chow
	[133848] = spellDictionary["Nomi"](), -- Rank 2
	[133868] = spellDictionary["Nomi"](), -- Rank 3
	-- Fishbrul Special
	[133825] = spellDictionary["Nomi"](), -- Rank 1
	[133845] = spellDictionary["Nomi"](), -- Rank 2
	[133865] = spellDictionary["Nomi"](), -- Rank 3
	-- Hearty Feast
	[133829] = spellDictionary["Nomi"](), -- Rank 1
	[133849] = spellDictionary["Nomi"](), -- Rank 2
	[133869] = spellDictionary["Nomi"](), -- Rank 3
	-- Koi-Scented Stormray
	[133839] = spellDictionary["Nomi"](), -- Rank 2
	[133859] = spellDictionary["Nomi"](), -- Rank 3
	-- Lavish Suramar Feast
	[133830] = spellDictionary["Nomi"](), -- Rank 1
	[133850] = spellDictionary["Nomi"](), -- Rank 2
	[133870] = spellDictionary["Nomi"](), -- Rank 3
	-- Leybeque Ribs
	[133816] = spellDictionary["Nomi"](), -- Rank 1
	[133836] = spellDictionary["Nomi"](), -- Rank 2
	[133856] = spellDictionary["Nomi"](), -- Rank 3
	-- Nightborne Delicacy Platter
	[133823] = spellDictionary["Nomi"](), -- Rank 1
	[133843] = spellDictionary["Nomi"](), -- Rank 2
	[133863] = spellDictionary["Nomi"](), -- Rank 3
	-- Pickled Stormray
	[133833] = spellDictionary["Nomi"](), -- Rank 2
	[133853] = spellDictionary["Nomi"](), -- Rank 3
	-- Salt & Pepper Shank
	[133831] = spellDictionary["Nomi"](), -- Rank 2
	[133851] = spellDictionary["Nomi"](), -- Rank 3
	-- Seed-Battered Fish Plate
	[133824] = spellDictionary["Nomi"](), -- Rank 1
	[133844] = spellDictionary["Nomi"](), -- Rank 2
	[133864] = spellDictionary["Nomi"](), -- Rank 3
	-- Spiced Rib Roast
	[133835] = spellDictionary["Nomi"](), -- Rank 2
	[133855] = spellDictionary["Nomi"](), -- Rank 3
	-- Suramar Surf and Turf
	[133837] = spellDictionary["Nomi"](), -- Rank 2
	[133857] = spellDictionary["Nomi"](), -- Rank 3
	-- The Hungry Magister
	[133821] = spellDictionary["Nomi"](), -- Rank 1
	[133841] = spellDictionary["Nomi"](), -- Rank 2
	[133861] = spellDictionary["Nomi"](), -- Rank 3
}
addonTable.unknownItems = unknownItems