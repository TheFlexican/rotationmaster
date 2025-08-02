local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Warrior wizard
local WarriorWizard = {}

-- Register the Warrior wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(1, WarriorWizard) -- 1 is the class ID for Warrior

-- Define available specializations for Warrior in Classic/non-retail versions
function WarriorWizard:GetSpecializations()
    return {
        { id = 1, name = "Arms" },
        { id = 2, name = "Fury" },
        { id = 3, name = "Protection" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function WarriorWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Arms" or specId == 1 then
        createdRotations = self:CreateArmsRotations()
    elseif specName == "Fury" or specId == 2 then
        createdRotations = self:CreateFuryRotations()
    elseif specName == "Protection" or specId == 3 then
        -- We'll skip Protection as it's a tank spec
        -- createdRotations = self:CreateProtectionRotations()
    end
    
    return createdRotations
end

-- Create Arms rotations
function WarriorWizard:CreateArmsRotations()
    local specId = 1  -- Arms spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Recklessness - Major cooldown for burst damage
        { 
            id = 1719, 
            name = "Recklessness",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 1719,
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
        
        -- Mortal Strike - Main rotational ability
        { 
            id = 12294, 
            name = "Mortal Strike",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 12294,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Colossus Smash - Apply armor debuff
        { 
            id = 86346, 
            name = "Colossus Smash",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 86346,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Colossus Smash",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Overpower - Use when proc is up
        { 
            id = 7384, 
            name = "Overpower",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Overpower",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Execute - Use during execute phase (target below 20% health)
        { 
            id = 5308, 
            name = "Execute",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.2
                    },
                    {
                        type = "RAGE",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 30
                    }
                }
            }
        },
        
        -- Slam - Rage dump when above threshold
        { 
            id = 1464, 
            name = "Slam",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "RAGE",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 40
                    },
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "GREATERTHANOREQUALS",
                        value = 0.2
                    }
                }
            }
        },
        
        -- Heroic Strike - Rage dump when capped
        { 
            id = 78, 
            name = "Heroic Strike",
            conditions = {
                type = "RAGE",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 80
            }
        },
        
        -- Rend - Keep DoT up if not already applied
        { 
            id = 772, 
            name = "Rend",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Rend",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "GREATERTHAN",
                        value = 0.2
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Arms Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Fury rotations
function WarriorWizard:CreateFuryRotations()
    local specId = 2  -- Fury spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Recklessness - Major cooldown for burst damage
        { 
            id = 1719, 
            name = "Recklessness",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 1719,
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
        
        -- Bloodthirst - Main rotational ability and enrage proc
        { 
            id = 23881, 
            name = "Bloodthirst",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 23881,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Colossus Smash - Apply armor debuff
        { 
            id = 86346, 
            name = "Colossus Smash",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 86346,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Colossus Smash",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Raging Blow - Use when Enraged
        { 
            id = 85288, 
            name = "Raging Blow",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Enrage",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 85288,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Execute - Use during execute phase (target below 20% health)
        { 
            id = 5308, 
            name = "Execute",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.2
                    },
                    {
                        type = "RAGE",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 30
                    }
                }
            }
        },
        
        -- Wild Strike - Rage dump
        { 
            id = 100130, 
            name = "Wild Strike",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "RAGE",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 60
                    },
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "GREATERTHANOREQUALS",
                        value = 0.2
                    }
                }
            }
        },
        
        -- Heroic Strike - Rage dump when capped
        { 
            id = 78, 
            name = "Heroic Strike",
            conditions = {
                type = "RAGE",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 90
            }
        },
        
        -- Berserker Rage - Force Enrage if not already enraged
        { 
            id = 18499, 
            name = "Berserker Rage",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Enrage",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 18499,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Fury Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
