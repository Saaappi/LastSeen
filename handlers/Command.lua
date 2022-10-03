local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS

function LastSeen:SlashCommandHandler(cmd)
	local cmd, arg1, arg2 = string.split(" ", cmd)
	if not cmd or cmd == "" then
		if InterfaceOptionsFrame:IsVisible() then
			InterfaceOptionsFrameOkay:Click()
		else
			InterfaceAddOnsList_Update()
			InterfaceOptionsFrame_OpenToCategory(addonTable.mainOptions)
		end
	elseif cmd == "1" then
		if InterfaceOptionsFrame:IsVisible() then
			InterfaceOptionsFrameOkay:Click()
		else
			InterfaceAddOnsList_Update()
			InterfaceOptionsFrame_OpenToCategory(addonTable.generalOptions)
		end
	elseif cmd == "2" then
		if InterfaceOptionsFrame:IsVisible() then
			InterfaceOptionsFrameOkay:Click()
		else
			InterfaceAddOnsList_Update()
			InterfaceOptionsFrame_OpenToCategory(addonTable.featuresOptions)
		end
	elseif cmd == "3" then
		if InterfaceOptionsFrame:IsVisible() then
			InterfaceOptionsFrameOkay:Click()
		else
			InterfaceAddOnsList_Update()
			InterfaceOptionsFrame_OpenToCategory(addonTable.filtersOptions)
		end
	end
end

--[[tbl.Ignore = function(arg)
	if tonumber(arg) ~= nil then
		arg = tonumber(arg)
		tbl.Ignore_ID(arg)
	else
		tbl.Ignore_Text(arg)
	end
end

tbl.Remove = function(arg)
	if tonumber(arg) then -- The passed argument is a number or item ID.
		arg = tonumber(arg);
		if tbl.Items[arg] then
			if tbl.Items[arg].itemLink ~= nil then
				print(tbl.L["ADDON_NAME"] .. tbl.L["REMOVED"] .. " " .. tbl.Items[arg].itemLink .. ".")
			else
				print(tbl.L["ADDON_NAME"] .. tbl.L["REMOVED"] .. " " .. arg .. ".")
			end
			tbl.Items[arg] = nil
		end
	elseif not tonumber(arg) then -- The passed argument isn't a number, and is likely an item's link.
		arg = (GetItemInfoInstant(arg)); -- Converts the supposed item link into an item ID.
		if tonumber(arg) then
			arg = tonumber(arg);
			if tbl.Items[arg] then
				if tbl.Items[arg].itemLink ~= nil then
					print(tbl.L["ADDON_NAME"] .. tbl.L["REMOVED"] .. " " .. tbl.Items[arg].itemLink .. ".")
				else
					print(tbl.L["ADDON_NAME"] .. tbl.L["REMOVED"] .. " " .. arg .. ".")
				end
				tbl.Items[arg] = nil
			end
		end
	else
		print(tbl.L["ADDON_NAME"] .. tbl.L["BAD_REQUEST"]);
	end
	
	if (tbl.LootTemplate[arg]) then tbl.LootTemplate[arg] = nil end -- Remove all associated entries that the player looted the item from.
end
-- Synopsis: Allows the player to remove undesired items from the items table using its ID or link.

tbl.Search = function(query)
	if tonumber(query) ~= nil then
		query = tonumber(query)
		tbl.Search_ID(query)
	else
		tbl.Search_Text(query)
	end
end

tbl.CheckProgress = function()
	print(tbl.L["ADDON_NAME"] .. tbl.GetCount(tbl.Items) .. " " .. tbl.L["OF"] .. " " .. tbl.L["APPROXIMATELY"] .. " " .. 154000 .. " (" .. tbl.Round(tbl.GetCount(tbl.Items)/154000) .. "%)")
end]]