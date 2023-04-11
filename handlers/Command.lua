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