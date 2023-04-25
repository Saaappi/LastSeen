local addonName, addonTable = ...

local dictionary = {
	["Nomi"] = function() return select(2, string.split(" ", (GetSpellInfo(202510)))) end,
}

-- These are items that have a valid source, but the addon is classifying them
-- as unknown.
local unknownItems = {
	-- Non-Recipe Items
	[133913] = dictionary["Nomi"](), -- Badly Burnt Food
	[143681] = dictionary["Nomi"](), -- Slightly Burnt Food
	[146757] = dictionary["Nomi"](), -- Prepared Ingredients
	[151653] = dictionary["Nomi"](), -- Broken Isles Recipe Scrap
	-- Azshari Salad
	[133822] = dictionary["Nomi"](), -- Rank 1
	[133842] = dictionary["Nomi"](), -- Rank 2
	[133862] = dictionary["Nomi"](), -- Rank 3
	-- Barracuda Mrglgagh
	[133838] = dictionary["Nomi"](), -- Rank 2
	[133858] = dictionary["Nomi"](), -- Rank 3
	-- Bear Tartare
	[133847] = dictionary["Nomi"](), -- Rank 2
	[133867] = dictionary["Nomi"](), -- Rank 3
	-- Crispy Bacon
	[133871] = dictionary["Nomi"](), -- Rank 1
	[133872] = dictionary["Nomi"](), -- Rank 2
	[133873] = dictionary["Nomi"](), -- Rank 3
	-- Deep-Fried Mossgill
	[133832] = dictionary["Nomi"](), -- Rank 2
	[133852] = dictionary["Nomi"](), -- Rank 3
	-- Dried Mackerel Strips
	[133846] = dictionary["Nomi"](), -- Rank 2
	[133866] = dictionary["Nomi"](), -- Rank 3
	-- Drogbar-Style Salmon
	[133840] = dictionary["Nomi"](), -- Rank 2
	[133860] = dictionary["Nomi"](), -- Rank 3
	-- Faronaar Fizz
	[133834] = dictionary["Nomi"](), -- Rank 2
	[133854] = dictionary["Nomi"](), -- Rank 3
	-- Fighter Chow
	[133848] = dictionary["Nomi"](), -- Rank 2
	[133868] = dictionary["Nomi"](), -- Rank 3
	-- Fishbrul Special
	[133825] = dictionary["Nomi"](), -- Rank 1
	[133845] = dictionary["Nomi"](), -- Rank 2
	[133865] = dictionary["Nomi"](), -- Rank 3
	-- Hearty Feast
	[133829] = dictionary["Nomi"](), -- Rank 1
	[133849] = dictionary["Nomi"](), -- Rank 2
	[133869] = dictionary["Nomi"](), -- Rank 3
	-- Koi-Scented Stormray
	[133839] = dictionary["Nomi"](), -- Rank 2
	[133859] = dictionary["Nomi"](), -- Rank 3
	-- Lavish Suramar Feast
	[133830] = dictionary["Nomi"](), -- Rank 1
	[133850] = dictionary["Nomi"](), -- Rank 2
	[133870] = dictionary["Nomi"](), -- Rank 3
	-- Leybeque Ribs
	[133816] = dictionary["Nomi"](), -- Rank 1
	[133836] = dictionary["Nomi"](), -- Rank 2
	[133856] = dictionary["Nomi"](), -- Rank 3
	-- Nightborne Delicacy Platter
	[133823] = dictionary["Nomi"](), -- Rank 1
	[133843] = dictionary["Nomi"](), -- Rank 2
	[133863] = dictionary["Nomi"](), -- Rank 3
	-- Pickled Stormray
	[133833] = dictionary["Nomi"](), -- Rank 2
	[133853] = dictionary["Nomi"](), -- Rank 3
	-- Salt & Pepper Shank
	[133831] = dictionary["Nomi"](), -- Rank 2
	[133851] = dictionary["Nomi"](), -- Rank 3
	-- Seed-Battered Fish Plate
	[133824] = dictionary["Nomi"](), -- Rank 1
	[133844] = dictionary["Nomi"](), -- Rank 2
	[133864] = dictionary["Nomi"](), -- Rank 3
	-- Spiced Rib Roast
	[133835] = dictionary["Nomi"](), -- Rank 2
	[133855] = dictionary["Nomi"](), -- Rank 3
	-- Suramar Surf and Turf
	[133837] = dictionary["Nomi"](), -- Rank 2
	[133857] = dictionary["Nomi"](), -- Rank 3
	-- The Hungry Magister
	[133821] = dictionary["Nomi"](), -- Rank 1
	[133841] = dictionary["Nomi"](), -- Rank 2
	[133861] = dictionary["Nomi"](), -- Rank 3
}
addonTable.unknownItems = unknownItems