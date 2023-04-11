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
		--[[AceGUI:RegisterLayout("MyLayout",
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
			
			local source
			for _, v in ipairs(items) do
				source = v.source
				if source == "" then
					source = "-"
				end
				
				-- Iterate over the temporary items table.
				--
				-- Count the number of results and populate
				-- the strings that will populate the column
				-- labels.
				numResults = numResults + 1
				nameText = nameText .. "|T" .. v.itemIcon .. ":0|t" .. v.itemLink .. "\n"
				sourceText = sourceText .. source .. "\n"
				mapText = mapText .. v.map .. "\n"
				dateText = dateText .. v.lootDate .. "\n"
			end
			
			nameLabel:SetText(string.format("%s\n%s", "|cffFFD100Name|r", nameText))
			sourceLabel:SetText(string.format("%s\n%s", "|cffFFD100Source|r", sourceText))
			mapLabel:SetText(string.format("%s\n%s", "|cffFFD100Map|r", mapText))
			dateLabel:SetText(string.format("%s\n%s", "|cffFFD100Date|r", dateText))
			searchFrame:SetStatusText(string.format("%s: |cffFFFFFF%s|r", "Results", numResults))
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
		textBox:SetPoint("BOTTOMLEFT", searchFrame.frame, "BOTTOMLEFT", 25, 40)]]
		
		--
		
		-- Create an AceGUI frame to hold the child frames and the scroll frame
		local frame = AceGUI:Create("Frame")
		frame:SetTitle(addonName)

		-- Create a scroll frame to hold the child frames
		local scrollFrame = AceGUI:Create("ScrollFrame")
		scrollFrame:SetParent(frame.frame)
		scrollFrame:SetLayout("List")
		scrollFrame:SetWidth(650)
		scrollFrame:SetHeight(350)
		
		-- Create an editbox for searching the table
		local searchBox = AceGUI:Create("EditBox")
		searchBox:SetLabel("Search:")
		searchBox:SetCallback("OnTextChanged", function(self)
			if self:GetText() then
				local numResults = 0
				local items = {}
				local text = self:GetText()
				
				-- Clear the child frame
				scrollFrame:ReleaseChildren()

				-- Make sure the user's search query is in the items table somewhere.
				for _, item in pairs(LastSeenDB.Items) do
					if string.find(string.lower(item.itemName), string.lower(text)) then
						table.insert(items, item)
					elseif string.find(string.lower(item.source), string.lower(text)) then
						table.insert(items, item)
					elseif string.find(string.lower(item.map), string.lower(text)) then
						table.insert(items, item)
					elseif string.find(item.lootDate, text) then
						table.insert(items, item)
					end
				end
				
				-- Sort the items table by item name to make the results
				-- look nice.
				table.sort(items, function(a, b) return string.lower(a.itemName) < string.lower(b.itemName) end)
				
				-- Iterate through the items table and create a widget for each item of text
				for _, item in pairs(items) do
					-- Increment the number of results
					numResults = numResults + 1
					
					-- Create a row group to hold the children labels
					local row = AceGUI:Create("InlineGroup")
					row:SetLayout("Flow")
					row:SetFullWidth(true)
					scrollFrame:AddChild(row)

					-- Add the item icon and link to the name column
					local nameLabel = AceGUI:Create("Label")
					nameLabel:SetText("|T" .. item.itemIcon .. ":0|t " .. item.itemLink)
					nameLabel:SetWidth(150)
					row:AddChild(nameLabel)
					
					-- Add the source to the source column
					local sourceLabel = AceGUI:Create("Label")
					local source = item.source
					if source == "" then
						source = "-"
					end
					sourceLabel:SetText(source)
					sourceLabel:SetWidth(150)
					row:AddChild(sourceLabel)
					
					-- Add map name to the map column
					local mapLabel = AceGUI:Create("Label")
					mapLabel:SetText(item.map)
					mapLabel:SetWidth(150)
					row:AddChild(mapLabel)

					-- Add the loot date to the date column
					local dateLabel = AceGUI:Create("Label")
					dateLabel:SetText(item.lootDate)
					dateLabel:SetWidth(100)
					row:AddChild(dateLabel)
				end
				
				-- Set the status text to the number of results
				frame:SetStatusText(string.format("%s: |cffFFFFFF%s|r", "Results", numResults))
			end
		end)

		-- Add the header frame and scroll frame to the frame
		frame:AddChild(searchBox)
		frame:AddChild(scrollFrame)
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