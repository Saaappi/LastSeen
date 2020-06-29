## [2.3]
### Added
- Sources are now displayed on an item's tooltip if it's been seen from 2 or more sources. Only 4 sources are shown on the tooltip, but a total count is displayed.
- Added the command, "locale", which allows the player to change the locale that the addon interprets. All installs start in enUS.
- Added the command, "format", which allows the player to change the date format on existing items. Example: "/ls format 1" will tell the addon to swap all dates to DAY/MONTH/YEAR. Specify nothing to change it back.
- The "manual" command is now available in all supported languages.
- Added support for keybinds.

### Changed
- The item count in the settings frame should now update without reloading.
- Quiet mode has been renamed to "N/A".
- The player can view available commands using the "help" command instead of tossing no arguments to the "man" command.
- The item is ignored message no longer shows on Poor quality items.

### Fixed
- The "Anglers' Water Strider" item should no longer add/update when entering an island.
- The appearance check should now be more accurate. [Author's Note: The appearance check should be against the item that drops, opposed to the normal variant.]
- Search should now locate all items.
- Squashed a bug that caused the itemName attribute not to return.
- Loot acquired from containers should now add/update more reliably, and use the container's name instead of "Miscellaneous".
- The boxes next to the mode names should now highlight when selected.
- Fishing should no longer use the most recent target, and instead will use "Fishing", whether the player is in a pool or not.