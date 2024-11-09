local _, LastSeen = ...

SlashCmdList["LASTSEEN"] = function(cmd)
	if not cmd or cmd == "" then
	elseif cmd == "search" then
		LastSeen.Search()
    else
		print("Unknown command.")
	end
end
SLASH_LASTSEEN1 = "/ls"
SLASH_LASTSEEN2 = "/lastseen"