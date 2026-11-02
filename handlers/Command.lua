local _, LastSeen = ...

SlashCmdList["LASTSEEN"] = function(input)
  local command, args = input:match("^(%S+)%s*(.*)$")
  if not command or command == "" then
  elseif command == "search" then
    LastSeen.Search(args)
  elseif command == "resolve" then
    local started, noID = LastSeen.ResolveUnknownCreatures()
    print(format("%s: resolving %d unknown creature(s); %d item(s) have no source ID.", LastSeen.ColoredAddOnName(), started, noID))
  else
    print("Unknown command")
  end
end
SLASH_LASTSEEN1 = "/ls"
SLASH_LASTSEEN2 = "/lastseen"
