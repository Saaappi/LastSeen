local addon, addonTbl = ...;
local L = addonTbl.L;

local whitelistedItems = {
	[86547]				= "Skyshard",									-- MOUNT
	[109739]			= "Star Chart",									-- TOY
	[113375]			= "Vindicator's Armor Polish Kit",				-- TOY
	[116120]			= "Tasty Talador Lunch",						-- TOY
	[117550]			= "Angry Beehive",								-- TOY
	[138797]			= "Illusion: Mongoose",							-- ILLUSION
	[138798]			= "Illusion: Sunfire",                          -- ILLUSION
	[138799]			= "Illusion: Soulfrost",                        -- ILLUSION
	[138800]			= "Illusion: Blade Ward",                       -- ILLUSION
	[138801]			= "Illusion: Blood Draining",                   -- ILLUSION
	[138802]			= "Illusion: Power Torrent",                    -- ILLUSION
	[138804]			= "Illusion: Colossus",                         -- ILLUSION
	[138805]			= "Illusion: Jade Spirit",                      -- ILLUSION
	[138806]			= "Illusion: Mark of Shadowmoon",               -- ILLUSION
	[138807]			= "Illusion: Mark of the Shattered Hand",       -- ILLUSION
	[138808]			= "Illusion: Mark of the Bleeding Hollow",      -- ILLUSION
	[138809]			= "Illusion: Mark of Blackrock",                -- ILLUSION
	[138827]			= "Illusion: Nightmare",                        -- ILLUSION
	[138828]			= "Illusion: Chronos",                          -- ILLUSION
	[138832]			= "Illusion: Earthliving",                      -- ILLUSION
	[138833]			= "Illusion: Flametongue",                      -- ILLUSION
	[138834]			= "Illusion: Frostbrand",                       -- ILLUSION
	[138835]			= "Illusion: Rockbiter",                        -- ILLUSION
	[138836]			= "Illusion: Windfury",                         -- ILLUSION
	[138838]			= "Illusion: Deathfrost",                       -- ILLUSION
	[138955]			= "Illusion: Rune of Razorice",                 -- ILLUSION
	[163603]			= "Lucille's Handkerchief",						-- TOY
	[163607]			= "Lucille's Sewing Needle",					-- TOY
	[163742]			= "Heartsbane Grimoire",						-- TOY
};

addonTbl.whitelistedItems = whitelistedItems;