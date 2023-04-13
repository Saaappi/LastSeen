local addonName, addonTable = ...
local targetSpells = {
	[3365] = "", -- Opening (used by lots of chests and objects in the game)
	[6478] = "", -- Opening (used by lots of chests and objects in the game)
}
addonTable.targetSpells = targetSpells

local noTargetSpells = {
	[2575] = "Mining",
}
addonTable.noTargetSpells = noTargetSpells