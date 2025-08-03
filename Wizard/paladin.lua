local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Paladin wizard
local PaladinWizard = {}

-- Register the Paladin wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(2, PaladinWizard) -- 2 is the class ID for Paladin

-- Define available specializations for Paladin in Classic/non-retail versions
function PaladinWizard:GetSpecializations()
    return {
        { id = 1, name = "Holy" },
        { id = 2, name = "Protection" },
        { id = 3, name = "Retribution" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function PaladinWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Holy" or specId == 1 then
        -- We'll skip Holy as it's a healing spec
        -- createdRotations = self:CreateHolyRotations()
    elseif specName == "Protection" or specId == 2 then
        -- We'll skip Protection as it's a tank spec
        -- createdRotations = self:CreateProtectionRotations()
    elseif specName == "Retribution" or specId == 3 then
        createdRotations = self:CreateRetributionRotations()
    end
    
    return createdRotations
end

-- Create Retribution rotations
function PaladinWizard:CreateRetributionRotations()
    local specId = 3  -- Retribution spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Avenging Wrath - Major cooldown for burst damage
        { 
            id = 31884, 
            name = "Avenging Wrath",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 31884,
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
        
        -- Execution Sentence - Strong single-target DoT if talented
        { 
            id = 114157, 
            name = "Execution Sentence",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 114157,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "HOLY_POWER",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 3
                    }
                }
            }
        },
        
        -- Templar's Verdict - Main Holy Power spender
        { 
            id = 85256, 
            name = "Templar's Verdict",
            conditions = {
                type = "HOLY_POWER",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 3
            }
        },
        
        -- Hammer of Wrath - Execute phase ability
        { 
            id = 24275, 
            name = "Hammer of Wrath",
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
                        type = "SPELL_COOLDOWN",
                        spell = 24275,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Crusader Strike - Main Holy Power generator
        { 
            id = 35395, 
            name = "Crusader Strike",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 35395,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Judgment - Holy Power generator with debuff
        { 
            id = 20271, 
            name = "Judgment",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 20271,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Exorcism - Filler ability
        { 
            id = 879, 
            name = "Exorcism",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 879,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Divine Storm - AOE alternative to Templar's Verdict
        { 
            id = 53385, 
            name = "Divine Storm",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HOLY_POWER",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 3
                    },
                    {
                        type = "ENEMIES",
                        operator = "GREATERTHANOREQUALS",
                        value = 3
                    }
                }
            }
        },
        
        -- Consecration - AOE damage
        { 
            id = 26573, 
            name = "Consecration",
            conditions = {
                type = "ENEMIES",
                operator = "GREATERTHANOREQUALS",
                value = 3
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Retribution Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
