local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Druid wizard
local DruidWizard = {}

-- Register the Druid wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(11, DruidWizard) -- 11 is the class ID for Druid

-- Define available specializations for Druid in Classic/non-retail versions
function DruidWizard:GetSpecializations()
    return {
        { id = 1, name = "Balance" },
        { id = 2, name = "Feral" },
        { id = 3, name = "Guardian" },
        { id = 4, name = "Restoration" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function DruidWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Balance" or specId == 1 then
        createdRotations = self:CreateBalanceRotations()
    elseif specName == "Feral" or specId == 2 then
        createdRotations = self:CreateFeralRotations()
    elseif specName == "Guardian" or specId == 3 then
        -- We'll skip Guardian as it's a tank spec
        -- createdRotations = self:CreateGuardianRotations()
    elseif specName == "Restoration" or specId == 4 then
        -- We'll skip Restoration as it's a healing spec
        -- createdRotations = self:CreateRestorationRotations()
    end
    
    return createdRotations
end

-- Create Balance rotations
function DruidWizard:CreateBalanceRotations()
    local specId = 1  -- Balance spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Mark of the Wild - Buff check
        { 
            id = 1126, 
            name = "Mark of the Wild",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Mark of the Wild",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Moonkin Form - Form check
        { 
            id = 24858, 
            name = "Moonkin Form",
            conditions = {
                type = "FORM",
                form = "Moonkin Form",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Celestial Alignment - Major cooldown for burst damage
        { 
            id = 112071, 
            name = "Celestial Alignment",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 112071,
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
        
        -- Incarnation: Chosen of Elune - Major cooldown for burst damage if talented
        { 
            id = 102560, 
            name = "Incarnation: Chosen of Elune",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 102560,
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
        
        -- Moonfire - Apply DoT if in Solar Eclipse or if not already applied
        { 
            id = 8921, 
            name = "Moonfire",
            conditions = {
                type = "OR",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Moonfire",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Solar Eclipse",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Sunfire - Apply DoT if in Lunar Eclipse or if not already applied
        { 
            id = 93402, 
            name = "Sunfire",
            conditions = {
                type = "OR",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Sunfire",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Lunar Eclipse",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Starsurge - Use when available for burst damage
        { 
            id = 78674, 
            name = "Starsurge",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 78674,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Starfire - Use during Lunar Eclipse
        { 
            id = 2912, 
            name = "Starfire",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Lunar Eclipse",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Wrath - Use during Solar Eclipse
        { 
            id = 5176, 
            name = "Wrath",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Solar Eclipse",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Starfire - Default when no Eclipse is active and targeting for Lunar Eclipse
        { 
            id = 2912, 
            name = "Starfire",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Lunar Eclipse",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Solar Eclipse",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "ECLIPSE_DIRECTION",
                        operator = "EQUALS",
                        value = -1
                    }
                }
            }
        },
        
        -- Wrath - Default when no Eclipse is active and targeting for Solar Eclipse
        { 
            id = 5176, 
            name = "Wrath",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Lunar Eclipse",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Solar Eclipse",
                        operator = "NOTEQUALS",
                        value = 1
                    },
                    {
                        type = "ECLIPSE_DIRECTION",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Balance Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Feral rotations
function DruidWizard:CreateFeralRotations()
    local specId = 2  -- Feral spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Mark of the Wild - Buff check
        { 
            id = 1126, 
            name = "Mark of the Wild",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Mark of the Wild",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Cat Form - Form check
        { 
            id = 768, 
            name = "Cat Form",
            conditions = {
                type = "FORM",
                form = "Cat Form",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Berserk - Major cooldown for burst damage
        { 
            id = 106951, 
            name = "Berserk",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 106951,
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
        
        -- Incarnation: King of the Jungle - Major cooldown for burst damage if talented
        { 
            id = 102543, 
            name = "Incarnation: King of the Jungle",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 102543,
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
        
        -- Tiger's Fury - Energy regeneration and damage boost
        { 
            id = 5217, 
            name = "Tiger's Fury",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 5217,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "ENERGY",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 40
                    }
                }
            }
        },
        
        -- Savage Roar - Keep this up at all times
        { 
            id = 52610, 
            name = "Savage Roar",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF_REMAIN",
                        unit = "player",
                        spell = "Savage Roar",
                        operator = "LESSTHAN",
                        value = 6
                    }
                }
            }
        },
        
        -- Rip - Apply DoT if not already applied
        { 
            id = 1079, 
            name = "Rip",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 5
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Rip",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Rake - Apply DoT if not already applied
        { 
            id = 1822, 
            name = "Rake",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Rake",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Ferocious Bite - Finisher when Rip is already applied
        { 
            id = 22568, 
            name = "Ferocious Bite",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 5
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Rip",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Thrash - Apply DoT for AoE damage
        { 
            id = 106830, 
            name = "Thrash",
            conditions = {
                type = "ENEMIES",
                operator = "GREATERTHANOREQUALS",
                value = 3
            }
        },
        
        -- Shred - Main combo point builder
        { 
            id = 5221, 
            name = "Shred",
            conditions = {
                type = "POINT",
                unit = "player",
                operator = "LESSTHAN",
                value = 5
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Feral Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
