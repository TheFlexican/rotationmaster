# Rotation Master

## [2.2.1a](https://github.com/TheFlexican/rotationmaster/tree/feat/wizards) (2025-08-02)
[Full Changelog](https://github.com/TheFlexican/rotationmaster/compare/2.2.1...2.2.1a)

### Class Wizard Expansion
- **NEW**: Added Wizard support for all remaining classes:
  - Warrior (Arms, Fury)
  - Paladin (Retribution)
  - Hunter (Beast Mastery, Marksmanship, Survival)
  - Priest (Shadow)
  - Death Knight (Frost, Unholy)
  - Shaman (Elemental, Enhancement)
  - Mage (Arcane, Fire, Frost)
  - Warlock (Affliction, Demonology, Destruction)
  - Druid (Balance, Feral)
- **IMPROVED**: All DPS specs now have optimized single-target rotations
- **IMPROVED**: Comprehensive condition setups for all class resources and abilities

### Credits
- Complete class wizard implementation with assistance from GitHub Copilot

## [2.2.1](https://github.com/TheFlexican/rotationmaster/tree/feat/wizards) (2025-08-01)
[Full Changelog](https://github.com/TheFlexican/rotationmaster/compare/2.2.0...2.2.1)

### Class Wizard Initial Implementation
- **NEW**: Added Monk class wizard with optimized rotations for:
  - Windwalker (DPS)
  - Brewmaster (Tank)
- **NEW**: Added Rogue class wizard with optimized rotations for:
  - Assassination
  - Combat
  - Subtlety
- **IMPROVED**: Enhanced wizard system to support per-class rotation creation
- **IMPROVED**: Detailed condition setup for class-specific resources and abilities

### Credits
- Initial class wizard implementation with assistance from GitHub Copilot

## [2.2.0](https://github.com/TheFlexican/rotationmaster/tree/feat/wizards) (2025-07-31)
[Full Changelog](https://github.com/TheFlexican/rotationmaster/compare/2.1.0...2.2.0)

### Rotation Creation Wizard System
- **NEW**: Added WizardSystem framework for automated rotation creation
- **NEW**: Created wizard GUI for generating class and spec-specific rotations
- **NEW**: Implemented wizard initialization system in init.lua
- **NEW**: Added basic wizard template for creating standard rotations
- **IMPROVED**: Enhanced rotation handling to support wizard-generated rotations
- **IMPROVED**: Added rotation registration system for tracking created rotations

### Technical Changes
- Created Wizard/ directory structure with core wizard files
- Implemented class registration system for wizard modules
- Added rotation template system for standardized rotation creation
- Enhanced UI to support wizard-guided rotation setup

### Credits
- Wizard system implemented with assistance from GitHub Copilot

## [2.1.0](https://github.com/TheFlexican/rotationmaster/tree/master) (2025-08-01)
[Full Changelog](https://github.com/TheFlexican/rotationmaster/compare/2.0.2...2.1.0)

### Major Performance Optimization - Combat-Only Operation
- **PERFORMANCE**: Implemented combat-only rotation system - addon now only performs rotation evaluation when actually in combat
- **NEW**: Added "Combat-Only Mode" checkbox in General options to allow players to enable/disable this feature
- **PERFORMANCE**: Added intelligent event registration system:
  - Registers only minimal events when enabled but out of combat (9 essential events)
  - Automatically registers full rotation events when entering combat (40+ events)
  - Automatically unregisters rotation events when leaving combat
- **PERFORMANCE**: Dramatic reduction in CPU usage when out of combat (estimated 80-90% reduction in event processing)
- **NEW**: Added combat detection polling system (100ms intervals) to manage combat state transitions
- **IMPROVED**: Enhanced `enable()` function to support both combat-only and legacy modes
- **IMPROVED**: Added `RegisterRotationEvents()` and `UnregisterRotationEvents()` functions for dynamic event management
- **IMPROVED**: Added `SetCombatOnlyMode()` function to handle mode switching

### Bug Fixes
- **FIXED**: Resolved AceLocale error for missing cleanup command localization string
- **FIXED**: Fixed nil reference error in optionsFrames when addon disabled and reloaded
- **FIXED**: Added automatic options initialization with proper error handling
- **FIXED**: Ensured glows are properly removed when exiting combat
- **IMPROVED**: Added defensive nil checks throughout options handling code

### Localization
- **LOCALIZATION**: Added "/rm cleanup - Removes all migrated profile rotations" string
- **LOCALIZATION**: Added "Options not ready. Please wait for addon to fully load." string  
- **LOCALIZATION**: Added "Failed to initialize options interface." string
- **LOCALIZATION**: Added "Combat-Only Mode" and related help text strings

### Technical Changes
- Created separate event arrays for minimal vs. full rotation operation
- Enhanced `CheckCombatStatus()` function to handle event registration and glow removal
- Modified `enable()` function to support both combat-only and legacy operation modes
- Added comprehensive glow cleanup when exiting combat
- Improved error handling for options interface initialization
- Added combat-only mode checkbox in General options with comprehensive help documentation

### Performance Impact
This release significantly reduces the addon's resource usage when not actively in combat, making it much more efficient for players who spend time in cities, traveling, or doing non-combat activities while keeping the addon enabled.

### Credits
- Combat-only optimization system implemented with assistance from GitHub Copilot

## [2.0.2](https://github.com/TheFlexican/rotationmaster/tree/master) (2025-07-29)
[Full Changelog](https://github.com/TheFlexican/rotationmaster/compare/2.0.1...2.0.2)

### Technical Changes
- **UPDATED**: Ace3 libraries updated to Ace3-r1365-alpha for improved compatibility and stability

### Credits
- Combat-aware polling implemented with assistance from GitHub Copilot

## [2.0.1](https://github.com/TheFlexican/rotationmaster/tree/master) (2025-07-28)
[Full Changelog](https://github.com/TheFlexican/rotationmaster/compare/2.0.0...2.0.1)

### Performance Improvements
- **PERFORMANCE**: Improved polling performance by changing default interval from 0.15s to 0.25s (40% reduction in CPU usage)
- **PERFORMANCE**: Increased minimum polling interval from 0.05s to 0.1s to prevent overly aggressive settings

### Credits
- Performance optimizations implemented with assistance from GitHub Copilot

## [2.0.0](https://github.com/TheFlexican/rotationmaster/tree/feat/mop-compatible) (2025-07-28)
[Full Changelog](https://github.com/TheFlexican/rotationmaster/compare/1.4.3e...2.0.0)

### MoP Classic Compatibility (feat/mop-compatible branch)
- **BREAKING**: Updated Interface version from 11403 (WotLK) to 50400 (MoP Classic 5.4.0)
- **NEW**: Added comprehensive Monk class support for MoP Classic
- **NEW**: Added specific ENERGY condition for Monks, Rogues, and Cat Form Druids
- **NEW**: Added specific CHI condition for Monk's unique resource system
- **FIXED**: Resolved `GetNumTalentTabs()` API errors in MoP Classic by implementing proper expansion-level handling
- **FIXED**: Resolved `GetActiveTalentGroup()` API errors by adding MoP-specific specialization handling
- **FIXED**: Resolved `GetNumTalentGroups()` API errors in Options UI with MoP compatibility layer
- **FIXED**: Resolved `GetTalentGroupRole()` API errors by restricting role conditions to WotLK Classic only
- **IMPROVED**: Enhanced talent system handling with separate logic for:
  - Mainline (retail): Modern talent system
  - MoP Classic (LE_EXPANSION_LEVEL_CURRENT >= 4): 6-tier talent system
  - WotLK Classic (LE_EXPANSION_LEVEL_CURRENT >= 2 but < 4): Talent trees with dual spec
  - Earlier Classic: Basic talent support
- **IMPROVED**: Added proper API safety checks to prevent crashes when APIs don't exist
- **IMPROVED**: Enhanced specialization detection for MoP's new spec system
- **LOCALIZATION**: Added English localization for "Energy", "Chi", and related terms

### Technical Changes
- Created `monk_conditions.lua` for MoP-specific Monk resource conditions
- Updated main.lua talent handling with expansion-specific logic
- Updated Options/general.lua with MoP specialization tab handling  
- Updated Conditions/character.lua with MoP talent system support
- Updated utils.lua GetSpecialization() method for MoP compatibility
- Added proper error handling for missing APIs across all expansion levels

### Credits
- MoP Classic compatibility implemented with assistance from GitHub Copilot
- Thanks to the community for testing and feedback on Classic expansion support

## [1.4.3e](https://github.com/corporategoth/rotationmaster/tree/1.4.3e) (2022-09-30)
[Full Changelog](https://github.com/corporategoth/rotationmaster/compare/1.4.3d...1.4.3e) [Previous Releases](https://github.com/corporategoth/rotationmaster/releases)

- is\_uuid should first ensure it's a string.  
