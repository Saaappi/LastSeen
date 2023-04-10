local addonName, addonTable = ...
local L_GLOBALSTRINGS = addonTable.L_GLOBALSTRINGS
local AceGUI = LibStub("AceGUI-3.0")

local xpcall = xpcall

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(func, ...)
	if func then
		return xpcall(func, errorhandler, ...)
	end
end

function LastSeen:SlashCommandHandler(cmd)
	local cmd, arg1, arg2 = string.split(" ", cmd)
	if not cmd or cmd == "" then
		Settings.OpenToCategory(addonName)
	elseif (cmd == "rm" or cmd == "remove") and arg1 ~= nil then
		local itemID = 0
		if tonumber(arg1) then
			itemID = tonumber(arg1)
		else
			local _, _, itemString = string.find(arg1, "|H(item:%d+)")
			itemID = tonumber(string.match(itemString, "item:(%d+)"))
		end
		
		if LastSeenDB.Items[itemID] then
			print(string.format("Removed: |T%s:0|t %s", LastSeenDB.Items[itemID].itemIcon, LastSeenDB.Items[itemID].itemLink))
			LastSeenDB.Items[itemID] = nil
		end
	elseif cmd == "search" then
		-- Create a custom layout to use for the frame.
		AceGUI:RegisterLayout("MyLayout",
			function(content, children)
				for i = 1, #children do
					local child = children[i]
					local frame = child.frame
					frame:ClearAllPoints()
					frame:Show()
					if i == 1 then -- Name Label
						frame:SetPoint("TOPLEFT", content)
					elseif i >= 2 and i <= 4 then -- All other Labels
						frame:SetPoint("TOPLEFT", children[i-1].frame, "TOPRIGHT", 20, 0)
					else -- Search EditBox
						frame:SetPoint("BOTTOMLEFT", content)
					end
				end
				safecall(content.obj.LayoutFinished, content.obj, nil, 100)
			end
		)
		
		local searchFrame = AceGUI:Create("Frame")
		_G["LastSeenSearchFrame"] = searchFrame.frame
		searchFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
		searchFrame:SetTitle("LastSeen")
		searchFrame:SetStatusText("")
		searchFrame:SetLayout("MyLayout")
		searchFrame:EnableResize(false)
		tinsert(UISpecialFrames, "LastSeenSearchFrame")
		
		local nameLabel = AceGUI:Create("Label")
		nameLabel:SetWidth(200)
		nameLabel:SetHeight(100)
		searchFrame:AddChild(nameLabel)
		nameLabel:SetPoint("TOPLEFT", searchFrame.frame, "TOPLEFT", 0, -40)
		
		local sourceLabel = AceGUI:Create("Label")
		sourceLabel:SetWidth(150)
		sourceLabel:SetHeight(100)
		searchFrame:AddChild(sourceLabel)
		sourceLabel:SetPoint("TOPLEFT", searchFrame.frame, "TOPLEFT", 250, -40)
		
		local mapLabel = AceGUI:Create("Label")
		mapLabel:SetWidth(150)
		mapLabel:SetHeight(100)
		searchFrame:AddChild(mapLabel)
		mapLabel:SetPoint("TOPLEFT", searchFrame.frame, "TOPLEFT", 400, -40)
		
		local dateLabel = AceGUI:Create("Label")
		dateLabel:SetWidth(150)
		dateLabel:SetHeight(100)
		searchFrame:AddChild(dateLabel)
		dateLabel:SetPoint("TOPLEFT", searchFrame.frame, "TOPLEFT", 550, -40)
		
		-- Add an editbox to the frame.
		local textBox = AceGUI:Create("EditBox")
		textBox:SetLabel("Search")
		textBox:SetWidth(175)
		textBox:DisableButton(true)
		textBox:SetCallback("OnEnterPressed", function(self)
			local numResults = 0 -- The number of items found.
			local nameText, sourceText, mapText, dateText = "", "", "", "" -- Used to populate the data columns.
			local items = {}
			
			if self:GetText() == "*" then
				-- Return all items in the table.
				-- This shouldn't overflow the GUI, but the number
				-- of results found should be accurate.
				for k, v in pairs(LastSeenDB.Items) do
					table.insert(items, v)
				end
			elseif self:GetText() ~= "" then
				for k, v in pairs(LastSeenDB.Items) do
					if string.find(string.lower(v.itemName), string.lower(self:GetText())) then
						table.insert(items, v)
					elseif string.find(string.lower(v.source), string.lower(self:GetText())) then
						table.insert(items, v)
					elseif string.find(string.lower(v.map), string.lower(self:GetText())) then
						table.insert(items, v)
					elseif string.find(v.lootDate, self:GetText()) then
						table.insert(items, v)
					end
				end
			end
			
			-- Sort the items table by item name to make the results
			-- look nice.
			table.sort(items, function(a, b) return string.lower(a.itemName) < string.lower(b.itemName) end)
			
			for _, v in ipairs(items) do
				-- Iterate over the temporary items table.
				--
				-- Count the number of results and populate
				-- the strings that will populate the column
				-- labels.
				numResults = numResults + 1
				nameText = nameText .. "|T" .. v.itemIcon .. ":0|t" .. v.itemLink .. "\n"
				sourceText = sourceText .. v.source .. "\n"
				mapText = mapText .. v.map .. "\n"
				dateText = dateText .. v.lootDate .. "\n"
			end
			
			nameLabel:SetText(string.format("%s\n%s", "Name", nameText))
			sourceLabel:SetText(string.format("%s\n%s", "Source", sourceText))
			mapLabel:SetText(string.format("%s\n%s", "Map", mapText))
			dateLabel:SetText(string.format("%s\n%s", "Date", dateText))
			searchFrame:SetStatusText(string.format("%s: %s", "Results", numResults))
			self:SetText("")
		end)
		textBox:SetCallback("OnEnter", function(self)
			GameTooltip:SetOwner(self.frame, "ANCHOR_RIGHT")
			GameTooltip:SetText("Search the item table by name, source, map, or date.", 1, 1, 1, true)
			GameTooltip:Show()
		end)
		textBox:SetCallback("OnLeave", function(self)
			if GameTooltip:GetOwner() == self.frame then
				GameTooltip:Hide()
			end
		end)
		searchFrame:AddChild(textBox)
		textBox:SetFocus()
		textBox:SetPoint("BOTTOMLEFT", searchFrame.frame, "BOTTOMLEFT", 25, 40)
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

tbl.CheckProgress = function()
	print(tbl.L["ADDON_NAME"] .. tbl.GetCount(tbl.Items) .. " " .. tbl.L["OF"] .. " " .. tbl.L["APPROXIMATELY"] .. " " .. 154000 .. " (" .. tbl.Round(tbl.GetCount(tbl.Items)/154000) .. "%)")
end]]