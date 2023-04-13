local addonName, addonTable = ...
local targetSpells = {
	[6478] = "", -- Opening (used by lots of chests and objects in the game)
}
addonTable.targetSpells = targetSpells

local noTargetSpells = {
	[2575] = "Mining",
	[115011] = UnitName("target"), -- Dead Packer, Kun-Lai Summit
}
addonTable.noTargetSpells = noTargetSpells