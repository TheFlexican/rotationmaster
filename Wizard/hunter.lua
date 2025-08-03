local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Hunter wizard
local HunterWizard = {}

-- Register the Hunter wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(3, HunterWizard) -- 3 is the class ID for Hunter

-- Define available specializations for Hunter in Classic/non-retail versions
function HunterWizard:GetSpecializations()
    return {
        { id = 1, name = "Beast Mastery" },
        { id = 2, name = "Marksmanship" },
        { id = 3, name = "Survival" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function HunterWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Beast Mastery" or specId == 1 then
        createdRotations = self:CreateBeastMasteryRotations()
    elseif specName == "Marksmanship" or specId == 2 then
        createdRotations = self:CreateMarksmanshipRotations()
    elseif specName == "Survival" or specId == 3 then
        createdRotations = self:CreateSurvivalRotations()
    end
    
    return createdRotations
end

-- Create Beast Mastery rotations
function HunterWizard:CreateBeastMasteryRotations()
    local specId = 1  -- Beast Mastery spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Bestial Wrath - Major cooldown for burst damage
        { 
            id = 19574, 
            name = "Bestial Wrath",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 19574,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "COMBAT",
                        value = true,
                        unit = "player"
                    },
                    {
                        type = "PET",
                        operator = "EQUALS",
                        value = true
                    }
                }
            }
        },
        
        -- Rapid Fire - Haste cooldown
        { 
            id = 3045, 
            name = "Rapid Fire",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 3045,
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
        
        -- Kill Command - Main damage ability
        { 
            id = 34026, 
            name = "Kill Command",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 34026,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "PET",
                        operator = "EQUALS",
                        value = true
                    }
                }
            }
        },
        
        -- Focus Fire - Use when pet has max Frenzy stacks
        { 
            id = 82692, 
            name = "Focus Fire",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF_STACKS",
                        unit = "pet",
                        spell = "Frenzy",
                        operator = "GREATERTHANOREQUALS",
                        value = 5
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Focus Fire",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Dire Beast - Focus regeneration and damage
        { 
            id = 120679, 
            name = "Dire Beast",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 120679,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Serpent Sting - Apply DoT if not already applied
        { 
            id = 1978, 
            name = "Serpent Sting",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Serpent Sting",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Arcane Shot - Focus dump
        { 
            id = 3044, 
            name = "Arcane Shot",
            conditions = {
                type = "FOCUS",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 50
            }
        },
        
        -- Steady Shot/Cobra Shot - Focus generator
        { 
            id = 56641, 
            name = "Steady Shot",
            conditions = {
                type = "FOCUS",
                unit = "player",
                operator = "LESSTHAN",
                value = 70
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Beast Mastery Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Marksmanship rotations
function HunterWizard:CreateMarksmanshipRotations()
    local specId = 2  -- Marksmanship spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Rapid Fire - Haste cooldown
        { 
            id = 3045, 
            name = "Rapid Fire",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 3045,
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
        
        -- Chimera Shot - Main damage ability and focus generator
        { 
            id = 53209, 
            name = "Chimera Shot",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 53209,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Aimed Shot - During Rapid Fire procs
        { 
            id = 19434, 
            name = "Aimed Shot",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Rapid Fire",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "FOCUS",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 50
                    }
                }
            }
        },
        
        -- Serpent Sting - Apply DoT if not already applied
        { 
            id = 1978, 
            name = "Serpent Sting",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Serpent Sting",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Arcane Shot - Focus dump
        { 
            id = 3044, 
            name = "Arcane Shot",
            conditions = {
                type = "FOCUS",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 50
            }
        },
        
        -- Glaive Toss/Powershot - If talented
        { 
            id = 117050, 
            name = "Glaive Toss",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 117050,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Steady Shot/Cobra Shot - Focus generator
        { 
            id = 56641, 
            name = "Steady Shot",
            conditions = {
                type = "FOCUS",
                unit = "player",
                operator = "LESSTHAN",
                value = 70
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Marksmanship Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Survival rotations
function HunterWizard:CreateSurvivalRotations()
    local specId = 3  -- Survival spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Rapid Fire - Haste cooldown
        { 
            id = 3045, 
            name = "Rapid Fire",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 3045,
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
        
        -- Black Arrow - DoT and trap proc
        { 
            id = 3674, 
            name = "Black Arrow",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 3674,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Black Arrow",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Explosive Shot - Main damage ability
        { 
            id = 53301, 
            name = "Explosive Shot",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 53301,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Serpent Sting - Apply DoT if not already applied
        { 
            id = 1978, 
            name = "Serpent Sting",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Serpent Sting",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Arcane Shot - Focus dump when Lock and Load is not active
        { 
            id = 3044, 
            name = "Arcane Shot",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Lock and Load",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "FOCUS",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 50
                    }
                }
            }
        },
        
        -- Glaive Toss/Powershot - If talented
        { 
            id = 117050, 
            name = "Glaive Toss",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 117050,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Cobra Shot - Focus generator
        { 
            id = 77767, 
            name = "Cobra Shot",
            conditions = {
                type = "FOCUS",
                unit = "player",
                operator = "LESSTHAN",
                value = 70
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Survival Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
