local addon, tbl = ...;
local L = tbl.L

local events = {
	"ADDON_LOADED",
	"ENCOUNTER_START",
	"INSTANCE_GROUP_SIZE_CHANGED",
	"ISLAND_COMPLETED",
	"ITEM_DATA_LOAD_RESULT",
	"LOOT_CLOSED",
	"LOOT_OPENED",
	"LOOT_READY",
	"MAIL_INBOX_UPDATE",
	"MERCHANT_CLOSED",
	"MERCHANT_SHOW",
	"MODIFIER_STATE_CHANGED",
	"NAME_PLATE_UNIT_ADDED",
	"PLAYER_LEVEL_CHANGED",
	"PLAYER_LOGIN",
	"PLAYER_LOGOUT",
	"QUEST_ACCEPTED",
	"QUEST_LOOT_RECEIVED",
	"UPDATE_MOUSEOVER_UNIT",
	"UI_INFO_MESSAGE",
	"UNIT_SPELLCAST_SENT",
	"ZONE_CHANGED_NEW_AREA"
};
-- Synopsis: These are events that must occur before the addon will take action. Each event is documented in main.lua.

tbl.events = events