local addonName, LastSeen = ...

LastSeen.ColoredAddOnName = function()
    return "|cff009AE4" .. addonName .. "|r"
end

LastSeen.ItemIconString = function(iconTexture, itemLink)
    return format("|T%s:0|t %s", iconTexture, itemLink)
end