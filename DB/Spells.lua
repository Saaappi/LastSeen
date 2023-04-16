local addonName, addonTable = ...
local targetSpells = {
	[3365] = "", -- Opening (used by lots of chests and objects in the game)
	[6477] = "", -- Opening (used by lots of chests and objects in the game)
	[6478] = "", -- Opening (used by lots of chests and objects in the game)
}
addonTable.targetSpells = targetSpells

local noTargetSpells = {
	[2575] = "Mining", -- LOCALIZE ME
	-- Need Herbalism/Skinning in here too
}
addonTable.noTargetSpells = noTargetSpells