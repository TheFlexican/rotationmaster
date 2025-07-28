# Rotation Master

## [1.4.3f](https://github.com/TheFlexican/rotationmaster/tree/feat/mop-compatible) (2025-07-28)
[Full Changelog](https://github.com/TheFlexican/rotationmaster/compare/1.4.3e...1.4.3f)

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
