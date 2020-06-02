local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

local events = {
	"CHAT_MSG_LOOT",
	"ENCOUNTER_START",
	"INSTANCE_GROUP_SIZE_CHANGED",
	"LOOT_CLOSED",
	"LOOT_OPENED",
	"MAIL_INBOX_UPDATE",
	"MERCHANT_CLOSED",
	"MERCHANT_SHOW",
	"MODIFIER_STATE_CHANGED",
	"NAME_PLATE_UNIT_ADDED",
	"PLAYER_LOGIN",
	"PLAYER_LOGOUT",
	"QUEST_ACCEPTED",
	"QUEST_LOOT_RECEIVED",
	"UPDATE_MOUSEOVER_UNIT",
	"UNIT_SPELLCAST_SENT",
	"ZONE_CHANGED_NEW_AREA"
};
-- Synopsis: These are events that must occur before the addon will take action. Each event is documented in main.lua.

addonTbl.events = events;