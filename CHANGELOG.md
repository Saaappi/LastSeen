## [3.0]
### Added
- An asterisk now succeeds the item link of any unknown appearance the current character can equip.
- "Scan on Loot" allows the player to get a more specific item link, instead of the generic item's link.
- The addon now tracks the class and level of the character that looted the item. This information is available in the Search output.
- A new command, progress, tells you how many items you've seen versus an approximation of what's in the game.
- Reinstated the ability for players to ignore their own items.

### Changed
- The modes are now Debug, Normal, and Silent.
- The minimum rarity is now 1 (down from 2). This is from Green (Uncommon) to White (Common) items.

### Fixed
- The addon now explicitly listens for auto loot toggle key holds more reliably. [This setting is defined in Interface > Controls; only that modifier key is watched.]

### Removed
- No more import command.
- No more discord command.
- No more help command.
- No more man command.
- Items looted from containers are no longer considered by the addon.
- The "Miscellaneous" source was removed. [Users expressed a concern with items updating from a genuine source to a generic source. This alleviates that concern.]