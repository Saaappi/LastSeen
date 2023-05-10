local addonName, addon = ...
local AceGUI = LibStub("AceGUI-3.0")
local maxResults = 30

local function StartsWith(str, substr)
    return string.sub(str, 1, #substr) == substr
end

local function GetItemID(text)
	local itemID = 0
	if tonumber(text) then
		itemID = tonumber(text)
	else
		local _, _, itemString = string.find(text, "|H(item:%d+)")
		itemID = tonumber(string.match(itemString, "item:(%d+)"))
	end
	return itemID
end

local function GetClassIcon(classID)
	if classID ~= 0 then
		local _, className = GetClassInfo(classID)
		className = string.lower(className)
	
		return "classicon-" .. className
	end
	return "-"
end

local function GetFactionIcon(factionID)
	if factionID == 0 then
		return "|T" .. 132486 .. ":0|t"
	elseif factionID == 1 then
		return "|T" .. 255132 .. ":0|t"
	end
	return "|T" .. 348543 .. ":0|t"
end

local function FormatNumber(num)
	return string.format("%d", num):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function PlotWayPoint(mapID, x, y, title)
	local opts = {
		title = title,
		persistent = nil,
		minimap = true,
		world = true,
		from = addonName,
	}
	TomTom:AddWaypoint(mapID,(x / 100),(y / 100),opts)
	TomTom:SetClosestWaypoint()
end

function LastSeen:SlashCommandHandler(cmd)
	local cmd, arg1, arg2 = string.split(" ", cmd)
	if not cmd or cmd == "" then
		Settings.OpenToCategory(addonName)
	elseif (cmd == "rm" or cmd == "remove") and arg1 ~= nil then
		local itemID = GetItemID(arg1)
		if LastSeenDB.Items[itemID] then
			print(string.format("Removed: |T%s:0|t %s", LastSeenDB.Items[itemID].itemIcon, LastSeenDB.Items[itemID].itemLink))
			LastSeenDB.Items[itemID] = nil
		end
	elseif cmd == "ignore" and arg1 ~= nil then
		local itemID = GetItemID(arg1)
		LastSeen:SlashCommandHandler("rm " .. itemID)
		if LastSeenDB.IgnoredItems[itemID] then
			LastSeenDB.IgnoredItems[itemID] = nil
		else
			LastSeenDB.IgnoredItems[itemID] = true
		end
	elseif cmd == "search" then
		local frame = AceGUI:Create("Frame")
		frame:EnableResize(false)
		frame:SetTitle(addonName)
		frame:SetStatusText(string.format("%s: |cffFFFFFF%s|r", "Results", 0))
		frame:SetWidth(900)

		local scrollFrame = AceGUI:Create("ScrollFrame")
		scrollFrame:SetParent(frame.frame)
		scrollFrame:SetLayout("Flow")
		scrollFrame:SetWidth(850)
		scrollFrame:SetHeight(375)
		
		local searchBox = AceGUI:Create("EditBox")
		searchBox:SetLabel("Search:")
		searchBox:SetFocus(true)
		searchBox:SetCallback("OnEnterPressed", function(self)
			local numResults = 0
			
			if self:GetText() ~= nil and self:GetText() ~= "" then
				local items = {}
				local text = self:GetText()
				
				scrollFrame:ReleaseChildren()

				if (self:GetText() ~= "*") and (not StartsWith(self:GetText(), "-")) then
					for _, item in pairs(LastSeenDB.Items) do
						if string.find(string.lower(item.itemName), string.lower(text)) then
							table.insert(items, item)
						elseif item.source and string.find(string.lower(item.source), string.lower(text)) then
							table.insert(items, item)
						elseif item.map and string.find(string.lower(item.map), string.lower(text)) then
							table.insert(items, item)
						elseif string.find(item.lootDate, text) then
							table.insert(items, item)
						end
					end
				elseif (StartsWith(self:GetText(), "-")) then
					local _, rarity = string.split("-", self:GetText())
					if tonumber(rarity) then
						rarity = tonumber(rarity)
						for _, item in pairs(LastSeenDB.Items) do
							if item.itemRarity == rarity then
								table.insert(items, item)
							end
						end
					end
				elseif self:GetText() == "*" then
					for _, item in pairs(LastSeenDB.Items) do
						table.insert(items, item)
					end
				end
				
				table.sort(items, function(a, b) return string.lower(a.itemName) < string.lower(b.itemName) end)
				
				for _, item in pairs(items) do
					numResults = numResults + 1
					
					if numResults <= maxResults then
						local row = AceGUI:Create("InlineGroup")
						row:SetLayout("Flow")
						row:SetFullWidth(true)
						scrollFrame:AddChild(row)

						local nameLabel = AceGUI:Create("InteractiveLabel")
						nameLabel:SetText("|T" .. item.itemIcon .. ":0|t " .. item.itemLink)
						nameLabel:SetWidth(150)
						nameLabel:SetCallback("OnClick", function(self)
							if item.itemType == "Armor" or item.itemType == "Weapon" then
								DressUpItemLink(item.itemLink)
							end
						end)
						nameLabel:SetCallback("OnEnter", function(self)
							GameTooltip:SetOwner(self.frame, "ANCHOR_BOTTOMRIGHT")
							GameTooltip:SetHyperlink(item.itemLink)
							GameTooltip:Show()
						end)
						nameLabel:SetCallback("OnLeave", function(self)
							GameTooltip:Hide()
						end)
						row:AddChild(nameLabel)
						
						local sourceLabel = AceGUI:Create("InteractiveLabel")
						local source = item.source
						if source == "" then
							source = "-"
						end
						sourceLabel:SetText(source)
						sourceLabel:SetWidth(150)
						sourceLabel:SetCallback("OnEnter", function(self)
							GameTooltip:SetOwner(self.frame, "ANCHOR_BOTTOMRIGHT")
							GameTooltip:SetHyperlink(item.source)
							GameTooltip:Show()
						end)
						sourceLabel:SetCallback("OnLeave", function(self)
							GameTooltip:Hide()
						end)
						row:AddChild(sourceLabel)
						
						local mapLabel = AceGUI:Create("Label")
						mapLabel:SetText(item.map)
						mapLabel:SetWidth(150)
						row:AddChild(mapLabel)
						
						local locationLabel = AceGUI:Create("InteractiveLabel")
						locationLabel:SetText(string.sub(item.location.x,1,6)..", "..string.sub(item.location.y,1,6))
						locationLabel:SetWidth(150)
						locationLabel:SetCallback("OnClick", function(self)
							if (IsAddOnLoaded("TomTom")) then
								PlotWayPoint(item.location.mapID,item.location.x,item.location.y,item.itemName.." - "..item.source)
							end
						end)
						row:AddChild(locationLabel)
						
						local characterLabel = AceGUI:Create("Label")
						characterLabel:SetText(GetFactionIcon(item.lootedBy.factionID) .. " " .. CreateAtlasMarkup(GetClassIcon(item.lootedBy.classID)) .. " " .. item.lootedBy.level)
						characterLabel:SetWidth(100)
						row:AddChild(characterLabel)

						local dateLabel = AceGUI:Create("Label")
						dateLabel:SetText(item.lootDate)
						dateLabel:SetWidth(100)
						row:AddChild(dateLabel)
					end
				end
				
				if numResults <= maxResults then
					frame:SetStatusText(string.format("%s for |cffFFFFFF\"%s\"|r: |cffFFFFFF%s|r", "Results", self:GetText(), numResults))
				else
					frame:SetStatusText(string.format("%s for |cffFFFFFF\"%s\"|r: |cffFFFFFF%s|r     (%s)", "Results", self:GetText(), FormatNumber(numResults), "Only showing " .. maxResults .. " results, please narrow your search."))
				end
				
				self:SetText("")
			else
				frame:SetStatusText(string.format("%s: |cffFFFFFF%s|r", "Results", 0))
				scrollFrame:ReleaseChildren()
			end
		end)

		frame:AddChild(searchBox)
		frame:AddChild(scrollFrame)
	elseif (cmd == "location") then
		StaticPopupDialogs["LASTSEEN_MAP_POSITION"] = {
			text = "The precise x/y coordinates for "..GetUnitName("player").."'s position are below.",
			button1 = "OK",
			OnShow = function(self)
				local currentMapID = C_Map.GetBestMapForUnit("player")
				local position = C_Map.GetPlayerMapPosition(currentMapID, "player")
				local x, y = position.x, position.y
				x = (x*100); y = (y*100)
				self.editBox:SetText("mapID = "..currentMapID..", x = "..x..", y = "..y)
			end,
			OnAccept = function(self)
			end,
			showAlert = true,
			whileDead = false,
			hideOnEscape = true,
			enterClicksFirstButton = true,
			hasEditBox = true,
			preferredIndex = 3,
		}
		StaticPopup_Show("LASTSEEN_MAP_POSITION")
	end
end