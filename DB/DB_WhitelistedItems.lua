local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

-- TODO: Reconsider the approach to ignoring specific items.
local whitelistedItems = {
	[138797]			= "Illusion: Mongoose",
	[138798]			= "Illusion: Sunfire",
	[138799]			= "Illusion: Soulfrost",
	[138800]			= "Illusion: Blade Ward",
	[138801]			= "Illusion: Blood Draining",
	[138802]			= "Illusion: Power Torrent",
	[138804]			= "Illusion: Colossus",
	[138805]			= "Illusion: Jade Spirit",
	[138806]			= "Illusion: Mark of Shadowmoon",
	[138807]			= "Illusion: Mark of the Shattered Hand",
	[138808]			= "Illusion: Mark of the Bleeding Hollow",
	[138809]			= "Illusion: Mark of Blackrock",
	[138827]			= "Illusion: Nightmare",
	[138828]			= "Illusion: Chronos",
	[138832]			= "Illusion: Earthliving",
	[138833]			= "Illusion: Flametongue",
	[138834]			= "Illusion: Frostbrand",
	[138835]			= "Illusion: Rockbiter",
	[138836]			= "Illusion: Windfury",
	[138838]			= "Illusion: Deathfrost",
	[138955]			= "Illusion: Rune of Razorice",
};

addonTbl.whitelistedItems = whitelistedItems;