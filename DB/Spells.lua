local addonName, addonTable = ...
local spells = {
	[2575] = "Mining",
	[6478] = "",
	[115011] = UnitName("target"), -- Dead Packer, Kun-Lai Summit
}
addonTable.spells = spells