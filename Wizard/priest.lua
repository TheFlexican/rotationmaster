local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Priest wizard
local PriestWizard = {}

-- Register the Priest wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(5, PriestWizard) -- 5 is the class ID for Priest

-- Define available specializations for Priest in Classic/non-retail versions
function PriestWizard:GetSpecializations()
    return {
        { id = 1, name = "Discipline" },
        { id = 2, name = "Holy" },
        { id = 3, name = "Shadow" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function PriestWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Discipline" or specId == 1 then
        -- We'll skip Discipline as it's primarily a healing spec
        -- createdRotations = self:CreateDisciplineRotations()
    elseif specName == "Holy" or specId == 2 then
        -- We'll skip Holy as it's a healing spec
        -- createdRotations = self:CreateHolyRotations()
    elseif specName == "Shadow" or specId == 3 then
        createdRotations = self:CreateShadowRotations()
    end
    
    return createdRotations
end

-- Create Shadow rotations
function PriestWizard:CreateShadowRotations()
    local specId = 3  -- Shadow spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Shadowform - Make sure it's active
        { 
            id = 15473, 
            name = "Shadowform",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Shadowform",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Shadow Word: Pain - Apply DoT if not already applied
        { 
            id = 589, 
            name = "Shadow Word: Pain",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Shadow Word: Pain",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Vampiric Touch - Apply DoT if not already applied
        { 
            id = 34914, 
            name = "Vampiric Touch",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Vampiric Touch",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Devouring Plague - Apply when at max Shadow Orbs
        { 
            id = 2944, 
            name = "Devouring Plague",
            conditions = {
                type = "SHADOW_ORBS",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 3
            }
        },
        
        -- Shadow Word: Death - Execute phase or when on cooldown
        { 
            id = 32379, 
            name = "Shadow Word: Death",
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
                        spell = 32379,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Shadowfiend/Mindbender - Mana regeneration and damage
        { 
            id = 34433, 
            name = "Shadowfiend",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "MANA",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 0.75
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 34433,
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
        
        -- Mind Blast - Shadow Orbs generator
        { 
            id = 8092, 
            name = "Mind Blast",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 8092,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Mind Spike - When movement is needed or to refresh DoTs
        { 
            id = 73510, 
            name = "Mind Spike",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Surge of Darkness",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Mind Flay - Filler spell
        { 
            id = 15407, 
            name = "Mind Flay",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Shadow Word: Pain",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Vampiric Touch",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Shadow Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
