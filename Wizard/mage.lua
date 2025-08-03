local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Mage wizard
local MageWizard = {}

-- Register the Mage wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(8, MageWizard) -- 8 is the class ID for Mage

-- Define available specializations for Mage in Classic/non-retail versions
function MageWizard:GetSpecializations()
    return {
        { id = 1, name = "Arcane" },
        { id = 2, name = "Fire" },
        { id = 3, name = "Frost" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function MageWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Arcane" or specId == 1 then
        createdRotations = self:CreateArcaneRotations()
    elseif specName == "Fire" or specId == 2 then
        createdRotations = self:CreateFireRotations()
    elseif specName == "Frost" or specId == 3 then
        createdRotations = self:CreateFrostRotations()
    end
    
    return createdRotations
end

-- Create Arcane rotations
function MageWizard:CreateArcaneRotations()
    local specId = 1  -- Arcane spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Arcane Brilliance - Buff check
        { 
            id = 1459, 
            name = "Arcane Brilliance",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Arcane Brilliance",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Arcane Power - Major cooldown for burst damage
        { 
            id = 12042, 
            name = "Arcane Power",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 12042,
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
        
        -- Mirror Image - Distraction and damage
        { 
            id = 55342, 
            name = "Mirror Image",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 55342,
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
        
        -- Presence of Mind - Instant cast
        { 
            id = 12043, 
            name = "Presence of Mind",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 12043,
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
        
        -- Arcane Missiles - When proc is available
        { 
            id = 5143, 
            name = "Arcane Missiles",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Arcane Missiles!",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Arcane Blast - High mana phase
        { 
            id = 30451, 
            name = "Arcane Blast",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "MANA",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 0.5
                    },
                    {
                        type = "BUFF_STACKS",
                        unit = "player",
                        spell = "Arcane Charge",
                        operator = "LESSTHAN",
                        value = 4
                    }
                }
            }
        },
        
        -- Arcane Barrage - Dump Arcane Charges when low on mana
        { 
            id = 44425, 
            name = "Arcane Barrage",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "MANA",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 0.5
                    },
                    {
                        type = "BUFF_STACKS",
                        unit = "player",
                        spell = "Arcane Charge",
                        operator = "GREATERTHAN",
                        value = 0
                    }
                }
            }
        },
        
        -- Evocation - Mana regeneration
        { 
            id = 12051, 
            name = "Evocation",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "MANA",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 0.4
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 12051,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Frost Nova - For kiting
        { 
            id = 122, 
            name = "Frost Nova",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DISTANCE",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 5
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 122,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Arcane Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Fire rotations
function MageWizard:CreateFireRotations()
    local specId = 2  -- Fire spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Arcane Brilliance - Buff check
        { 
            id = 1459, 
            name = "Arcane Brilliance",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Arcane Brilliance",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Combustion - Major cooldown for burst damage
        { 
            id = 11129, 
            name = "Combustion",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 11129,
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
        
        -- Mirror Image - Distraction and damage
        { 
            id = 55342, 
            name = "Mirror Image",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 55342,
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
        
        -- Living Bomb - Apply DoT if not already applied
        { 
            id = 44457, 
            name = "Living Bomb",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Living Bomb",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Pyroblast - Use when proc is available
        { 
            id = 11366, 
            name = "Pyroblast",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Hot Streak",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Flame Orb/Frozen Orb - Damage and procs
        { 
            id = 82731, 
            name = "Flame Orb",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 82731,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Scorch - When low on mana or moving
        { 
            id = 2948, 
            name = "Scorch",
            conditions = {
                type = "MANA",
                unit = "player",
                operator = "LESSTHAN",
                value = 0.3
            }
        },
        
        -- Fireball - Main damage spell
        { 
            id = 133, 
            name = "Fireball",
            conditions = {
                type = "MANA",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 0.1
            }
        },
        
        -- Evocation - Mana regeneration
        { 
            id = 12051, 
            name = "Evocation",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "MANA",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 0.4
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 12051,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Dragon's Breath - AoE damage with disorient
        { 
            id = 31661, 
            name = "Dragon's Breath",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "PROXIMITY",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 2,
                        distance = 8,
                        samegroup = false,
                        includepets = false
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 31661,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Fire Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Frost rotations
function MageWizard:CreateFrostRotations()
    local specId = 3  -- Frost spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Arcane Brilliance - Buff check
        { 
            id = 1459, 
            name = "Arcane Brilliance",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Arcane Brilliance",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Summon Water Elemental
        { 
            id = 31687, 
            name = "Summon Water Elemental",
            conditions = {
                type = "PET",
                operator = "NOTEQUALS",
                value = true
            }
        },
        
        -- Icy Veins - Haste cooldown
        { 
            id = 12472, 
            name = "Icy Veins",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 12472,
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
        
        -- Mirror Image - Distraction and damage
        { 
            id = 55342, 
            name = "Mirror Image",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 55342,
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
        
        -- Frozen Orb - Damage and Fingers of Frost procs
        { 
            id = 84714, 
            name = "Frozen Orb",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 84714,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Deep Freeze - When target is frozen
        { 
            id = 44572, 
            name = "Deep Freeze",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Frozen",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 44572,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Ice Lance - When Fingers of Frost proc or target is frozen
        { 
            id = 30455, 
            name = "Ice Lance",
            conditions = {
                type = "OR",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Fingers of Frost",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Frozen",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Frostfire Bolt - With Brain Freeze proc
        { 
            id = 44614, 
            name = "Frostfire Bolt",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Brain Freeze",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Frostbolt - Main damage spell
        { 
            id = 116, 
            name = "Frostbolt",
            conditions = {
                type = "MANA",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 0.1
            }
        },
        
        -- Frost Nova - For kiting
        { 
            id = 122, 
            name = "Frost Nova",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DISTANCE",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 5
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 122,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Evocation - Mana regeneration
        { 
            id = 12051, 
            name = "Evocation",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "MANA",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 0.4
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 12051,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Frost Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
