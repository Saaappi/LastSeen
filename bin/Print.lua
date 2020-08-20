local addon, tbl = ...
local L = tbl.L

tbl.Print = function(id, itemLink, count, source, location, lootDate, class, level)
	if class and level then
		print(id .. ": " .. 
			itemLink .. ", " .. 
			count .. ", " .. 
			source .. ", " .. 
			location .. ", " .. 
			lootDate .. ", [" .. 
			class .. ", " .. level .. "]"
		)
	else
		print(id .. ": " .. 
			itemLink .. ", " .. 
			count .. ", " .. 
			source .. ", " .. 
			location .. ", " .. 
			lootDate
		)
	end
end