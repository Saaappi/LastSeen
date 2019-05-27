--[[
	Project			: LastSeen © 2019
	Author			: Oxlotus - Area 52-US
	Date Created	: 2019-05-23
	Purpose			: Handler for all object-related functions.
]]--

local lastSeen, lastSeenNS = ...;
local L = lastSeenNS.L;
local select = select;

local itemName;
local itemRarity;
local itemID;
local itemType;

lastSeenNS.ObjectLooted = function(constant, lootDate, currentMap, object)
	if not constant then return end;
		
	local link = lastSeenNS.ExtractItemLink(constant); 
	if not link then return end; -- To handle edge cases. $%&! these things.
	
	if select(1, GetItemInfoInstant(link)) == 0 then return end; -- This is here for items like pet cages.
	
	local itemID = select(1, GetItemInfoInstant(link));
	if not itemID then return end;
	
	local itemLink = select(2, GetItemInfo(itemID));
	local itemName = select(1, GetItemInfo(itemID));
	local itemRarity = select(3, GetItemInfo(itemID));
	local itemType = select(6, GetItemInfo(itemID));
	
	if itemRarity >= LastSeenSettingsCacheDB.rarity then
		lastSeenNS.IfExists(lastSeenNS.ignoredItemTypes, itemType);
		lastSeenNS.IfExists(LastSeenIgnoredItemsDB, itemID);
		lastSeenNS.IfExists(lastSeenNS.ignoredItems, itemID);
		if lastSeenNS.exists == false then
			if LastSeenItemsDB[itemID] then
				local coords = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit(L["IS_PLAYER"]), L["IS_PLAYER"]);
				lastSeenNS.Update(manualEntry, itemID, itemName, itemLink, itemType, itemRarity, currentDate, object, currentMap .. " (" .. lastSeenNS.Round(coords, 4) .. ")");
			else
				local coords = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit(L["IS_PLAYER"]), L["IS_PLAYER"]);
				lastSeenNS.New(itemID, itemName, itemLink, itemRarity, itemType, currentDate, object, currentMap .. " (" .. lastSeenNS.Round(coords, 4) .. ")");
			end
		else
			lastSeenNS.exists = false;
		end
	end
end