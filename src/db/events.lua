local addon, addonTbl = ...; addon = "|cffb19cd9" .. addon .. "|r";
local L = addonTbl.L;

local events = {
	"BAG_UPDATE",
	"CHAT_MSG_LOOT",
	"ENCOUNTER_START",
	"INSTANCE_GROUP_SIZE_CHANGED",
	"LOOT_CLOSED",
	"LOOT_OPENED",
	"MAIL_INBOX_UPDATE",
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

-- Namespace Additions
addonTbl.events = events;