local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Shaman wizard
local ShamanWizard = {}

-- Register the Shaman wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(7, ShamanWizard) -- 7 is the class ID for Shaman

-- Define available specializations for Shaman in Classic/non-retail versions
function ShamanWizard:GetSpecializations()
    return {
        { id = 1, name = "Elemental" },
        { id = 2, name = "Enhancement" },
        { id = 3, name = "Restoration" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function ShamanWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Elemental" or specId == 1 then
        createdRotations = self:CreateElementalRotations()
    elseif specName == "Enhancement" or specId == 2 then
        createdRotations = self:CreateEnhancementRotations()
    elseif specName == "Restoration" or specId == 3 then
        -- We'll skip Restoration as it's a healing spec
        -- createdRotations = self:CreateRestorationRotations()
    end
    
    return createdRotations
end

-- Create Elemental rotations
function ShamanWizard:CreateElementalRotations()
    local specId = 1  -- Elemental spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Summon totems if not active
        { 
            id = 8227, 
            name = "Flametongue Totem",
            conditions = {
                type = "NOT",
                value = {
                    type = "TOTEM",
                    totem = "Flametongue Totem"
                }
            }
        },
        
        -- Elemental Mastery - Haste cooldown
        { 
            id = 16166, 
            name = "Elemental Mastery",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 16166,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "COMBAT",
                        value = true,
                        unit = "player"
                    }
                }
            }
        },
        
        -- Ascendance - Major cooldown for burst damage
        { 
            id = 114050, 
            name = "Ascendance",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 114050,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "COMBAT",
                        value = true,
                        unit = "player"
                    }
                }
            }
        },
        
        -- Flame Shock - Apply DoT if not already applied
        { 
            id = 8050, 
            name = "Flame Shock",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Flame Shock",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Lava Burst - Main damage when Flame Shock is active
        { 
            id = 51505, 
            name = "Lava Burst",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 51505,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Flame Shock",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Earth Shock - Use when Fulmine is at max stacks
        { 
            id = 8042, 
            name = "Earth Shock",
            conditions = {
                type = "BUFF_STACKS",
                unit = "player",
                spell = "Lightning Shield",
                operator = "GREATERTHANOREQUALS",
                value = 7
            }
        },
        
        -- Elemental Blast - If talented
        { 
            id = 117014, 
            name = "Elemental Blast",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 117014,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Chain Lightning - When multiple targets are available
        { 
            id = 421, 
            name = "Chain Lightning",
            conditions = {
                type = "ENEMIES",
                operator = "GREATERTHANOREQUALS",
                value = 2
            }
        },
        
        -- Lightning Bolt - Main filler spell
        { 
            id = 403, 
            name = "Lightning Bolt",
            conditions = {
                type = "MANA",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 0.1
            }
        },
        
        -- Thunderstorm - Mana regen and knockback
        { 
            id = 51490, 
            name = "Thunderstorm",
            conditions = {
                type = "MANA",
                unit = "player",
                operator = "LESSTHAN",
                value = 0.5
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Elemental Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Enhancement rotations
function ShamanWizard:CreateEnhancementRotations()
    local specId = 2  -- Enhancement spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Summon totems if not active
        { 
            id = 8227, 
            name = "Flametongue Totem",
            conditions = {
                type = "NOT",
                value = {
                    type = "TOTEM",
                    totem = "Flametongue Totem"
                }
            }
        },
        
        -- Check weapon enchants
        { 
            id = 8232, 
            name = "Windfury Weapon",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Windfury Weapon",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Feral Spirit - Wolf summon for damage and healing
        { 
            id = 51533, 
            name = "Feral Spirit",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 51533,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "COMBAT",
                        value = true,
                        unit = "player"
                    }
                }
            }
        },
        
        -- Ascendance - Major cooldown for burst damage
        { 
            id = 114051, 
            name = "Ascendance",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 114051,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "COMBAT",
                        value = true,
                        unit = "player"
                    }
                }
            }
        },
        
        -- Flame Shock - Apply DoT if not already applied
        { 
            id = 8050, 
            name = "Flame Shock",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Flame Shock",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Stormstrike - Main damage ability
        { 
            id = 17364, 
            name = "Stormstrike",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 17364,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Lava Lash - Off-hand strike
        { 
            id = 60103, 
            name = "Lava Lash",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 60103,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Unleash Elements - Weapon empowerment
        { 
            id = 73680, 
            name = "Unleash Elements",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 73680,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Lightning Bolt with Maelstrom Weapon - Range filler with procs
        { 
            id = 403, 
            name = "Lightning Bolt",
            conditions = {
                type = "BUFF_STACKS",
                unit = "player",
                spell = "Maelstrom Weapon",
                operator = "GREATERTHANOREQUALS",
                value = 5
            }
        },
        
        -- Earth Shock - Ranged attack
        { 
            id = 8042, 
            name = "Earth Shock",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 8042,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Fire Nova - When Flame Shock is applied and AOE is needed
        { 
            id = 1535, 
            name = "Fire Nova",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Flame Shock",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "ENEMIES",
                        operator = "GREATERTHANOREQUALS",
                        value = 3
                    }
                }
            }
        },
        
        -- Primal Strike - Filler attack
        { 
            id = 73899, 
            name = "Primal Strike",
            conditions = {
                type = "MANA",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 0.2
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Enhancement Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
