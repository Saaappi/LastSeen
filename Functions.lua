local addonName, addon = ...

function LastSeen:Print(text)
    print(string.format("|cff00CCFF"..addonName..":|r %s", text))
end

function LastSeen:IsItemUpdatable(itemID, source)
    if ( not LastSeenDB.Items[itemID] ) then
        return true
    else
        local item = LastSeenDB.Items[itemID]
        if ( item.lootDate ~= date(LastSeenDB.DateFormat) ) then
            return true
        elseif ( item.map ~= addon.map ) then
            return true
        elseif ( item.source ~= source ) then
            return true
        end
        return false
    end
end