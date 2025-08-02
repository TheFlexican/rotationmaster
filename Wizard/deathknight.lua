local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Death Knight wizard
local DeathKnightWizard = {}

-- Register the Death Knight wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(6, DeathKnightWizard) -- 6 is the class ID for Death Knight

-- Define available specializations for Death Knight in Classic/non-retail versions
function DeathKnightWizard:GetSpecializations()
    return {
        { id = 1, name = "Blood" },
        { id = 2, name = "Frost" },
        { id = 3, name = "Unholy" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function DeathKnightWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Blood" or specId == 1 then
        -- We'll skip Blood as it's a tank spec
        -- createdRotations = self:CreateBloodRotations()
    elseif specName == "Frost" or specId == 2 then
        createdRotations = self:CreateFrostRotations()
    elseif specName == "Unholy" or specId == 3 then
        createdRotations = self:CreateUnholyRotations()
    end
    
    return createdRotations
end

-- Create Frost rotations
function DeathKnightWizard:CreateFrostRotations()
    local specId = 2  -- Frost spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Pillar of Frost - Major cooldown for burst damage
        { 
            id = 51271, 
            name = "Pillar of Frost",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 51271,
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
        
        -- Raise Dead - Summon ghoul for extra damage
        { 
            id = 46584, 
            name = "Raise Dead",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 46584,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "PET",
                        operator = "NOTEQUALS",
                        value = true
                    }
                }
            }
        },
        
        -- Frost Strike - Runic Power dump
        { 
            id = 49143, 
            name = "Frost Strike",
            conditions = {
                type = "RUNIC_POWER",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 80
            }
        },
        
        -- Howling Blast - Frost Fever application and AoE damage
        { 
            id = 49184, 
            name = "Howling Blast",
            conditions = {
                type = "OR",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Frost Fever",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Rime",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Obliterate - Main damage ability
        { 
            id = 49020, 
            name = "Obliterate",
            conditions = {
                type = "RUNE",
                rune = "FROST",
                count = 1,
                operator = "GREATERTHANOREQUALS",
                value = 1
            }
        },
        
        -- Soul Reaper - Execute phase ability
        { 
            id = 130736, 
            name = "Soul Reaper",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.35
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 130736,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Frost Strike - Runic Power dump
        { 
            id = 49143, 
            name = "Frost Strike",
            conditions = {
                type = "RUNIC_POWER",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 40
            }
        },
        
        -- Horn of Winter - Runic Power generation
        { 
            id = 57330, 
            name = "Horn of Winter",
            conditions = {
                type = "RUNIC_POWER",
                unit = "player",
                operator = "LESSTHAN",
                value = 40
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

-- Create Unholy rotations
function DeathKnightWizard:CreateUnholyRotations()
    local specId = 3  -- Unholy spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Raise Dead - Make sure pet is summoned
        { 
            id = 46584, 
            name = "Raise Dead",
            conditions = {
                type = "PET",
                operator = "NOTEQUALS",
                value = true
            }
        },
        
        -- Summon Gargoyle - Major cooldown for burst damage
        { 
            id = 49206, 
            name = "Summon Gargoyle",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 49206,
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
        
        -- Dark Transformation - Empower ghoul
        { 
            id = 63560, 
            name = "Dark Transformation",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 63560,
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
        
        -- Outbreak - Apply diseases
        { 
            id = 77575, 
            name = "Outbreak",
            conditions = {
                type = "OR",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Blood Plague",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Frost Fever",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Soul Reaper - Execute phase ability
        { 
            id = 130736, 
            name = "Soul Reaper",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.35
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 130736,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Festering Strike - Apply Festering Wounds
        { 
            id = 85948, 
            name = "Festering Strike",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "RUNE",
                        rune = "UNHOLY",
                        count = 1,
                        operator = "GREATERTHANOREQUALS",
                        value = 1
                    },
                    {
                        type = "RUNE",
                        rune = "FROST",
                        count = 1,
                        operator = "GREATERTHANOREQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Scourge Strike - Main damage ability
        { 
            id = 55090, 
            name = "Scourge Strike",
            conditions = {
                type = "RUNE",
                rune = "UNHOLY",
                count = 1,
                operator = "GREATERTHANOREQUALS",
                value = 1
            }
        },
        
        -- Death Coil - Runic Power dump and pet empowerment
        { 
            id = 47541, 
            name = "Death Coil",
            conditions = {
                type = "RUNIC_POWER",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 60
            }
        },
        
        -- Horn of Winter - Runic Power generation
        { 
            id = 57330, 
            name = "Horn of Winter",
            conditions = {
                type = "RUNIC_POWER",
                unit = "player",
                operator = "LESSTHAN",
                value = 40
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Unholy Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
