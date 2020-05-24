## [2.0] - ??
### Added
- New history command. Accessible using /ls (or /lastseen) history. This command allows the player to review the last 20 items obtained, persistent between sessions and contributed to by all characters.
- An icon will now precede the item icon in the chat frame to indicate whether or not the account has the appearance learned.

### Changed
- The settings menu is more appropriately sized.
- All gear tokens from Firelands are now ignored.
- [Crystallized Firestone], the Firelands currency, is now ignored.
- Verbose mode is now Debug mode, which will print variable content when looting trackable items.
- Loot fast command is now loot.
- Removed the location, add, and ignore commands.
- The remove command now supports item links.
- The 'removed' command is now 'view'.
- Trinkets and junk items (e.g. lock boxes) are now ignored.

### Fixed
- Looting from chests should function correctly once again.
- The lootFast variable should now be persistent, as intended.
- Loot Fast mode should no longer break loot tracking.