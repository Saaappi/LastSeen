local _, LastSeen = ...

SlashCmdList["LASTSEEN"] = function(input)
	local command, args = input:match("^(%S+)%s*(.*)$")
	if not command or command == "" then
	elseif command == "search" then
		LastSeen.Search(args)
	else
		print("Unknown command")
	end
end
SLASH_LASTSEEN1 = "/ls"
SLASH_LASTSEEN2 = "/lastseen"