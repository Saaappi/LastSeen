## [2.0] - ??
### Added
- New history command. Accessible using /ls (or /lastseen) history. This command allows the player to review the last 20 items obtained, persistent between sessions and contributed to by all characters.
- An icon will now precede the item icon in the chat frame to indicate whether or not the account has the appearance learned.
- If an item is ignored automatically, then a line will appear in the tooltip to make it easier for identification. This should help reduce false positives.
- New discord command. Provides the player with a link to a Discord server where they can interact with the author in the #last-seen channel.

### Changed
- The settings menu is more appropriately sized.
- More items are ignored.
- Verbose mode is now Debug mode, which will print variable content when looting trackable items.
- Loot fast command is now 'loot'.
- Removed the location, add, and ignore commands.
- The remove command now supports item links.
- The 'removed' command is now 'view'.
- The view command will no longer print an "error" if no items are available in that table.
- The contents of containers, such as lock boxes, are now treated as Miscellaneous. Miscellaneous sourced items won't return in search results, but do count toward the total items seen.

### Fixed
- Looting from chests should function correctly once again.
- The lootFast variable should now be persistent, as intended.
- Loot Fast mode should no longer break loot tracking.
- If an item isn't found using Search, there should no longer be a random "S" at the end.