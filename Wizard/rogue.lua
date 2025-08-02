local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Rogue wizard
local RogueWizard = {}

-- Register the Rogue wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(4, RogueWizard) -- 4 is the class ID for Rogue

-- Define available specializations for Rogue in Classic/non-retail versions
function RogueWizard:GetSpecializations()
    return {
        { id = 1, name = "Assassination" },
        { id = 2, name = "Combat" },
        { id = 3, name = "Subtlety" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function RogueWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Assassination" or specId == 1 then
        createdRotations = self:CreateAssassinationRotations()
    elseif specName == "Combat" or specId == 2 then
        createdRotations = self:CreateCombatRotations()
    elseif specName == "Subtlety" or specId == 3 then
        createdRotations = self:CreateSubtletyRotations()
    end
    
    return createdRotations
end

-- Create Assassination rotations
function RogueWizard:CreateAssassinationRotations()
    local specId = 1  -- Assassination spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Vendetta - Major cooldown, increases damage done to target
        { 
            id = 79140, 
            name = "Vendetta",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 79140,
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
        
        -- Slice and Dice - Keep this up at all times
        { 
            id = 5171, 
            name = "Slice and Dice",
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
                        spell = "Slice and Dice",
                        operator = "LESSTHAN",
                        value = 6
                    }
                }
            }
        },
        
        -- Rupture - Apply and maintain this DoT
        { 
            id = 1943, 
            name = "Rupture",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 4
                    },
                    {
                        type = "DEBUFF_REMAIN",
                        unit = "target",
                        spell = "Rupture",
                        operator = "LESSTHAN",
                        value = 3
                    }
                }
            }
        },
        
        -- Mutilate - Primary combo POINT builder
        { 
            id = 1329, 
            name = "Mutilate",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 5
                    },
                    {
                        type = "ENERGY",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 60
                    }
                }
            }
        },
        
        -- Envenom - Finisher when DoTs are up
        { 
            id = 32645, 
            name = "Envenom",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 4
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Rupture",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Slice and Dice",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Fan of Knives - AOE
        { 
            id = 51723, 
            name = "Fan of Knives",
            conditions = {
                type = "ENEMIES",
                operator = "GREATERTHANOREQUALS",
                value = 3
            }
        },
        
        -- Vanish - Tactical stealth
        { 
            id = 1856, 
            name = "Vanish",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 0.25
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 1856,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        }
    }

    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Assassination Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Combat rotations
function RogueWizard:CreateCombatRotations()
    local specId = 2  -- Combat spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Adrenaline Rush - Major cooldown for energy regen
        { 
            id = 13750, 
            name = "Adrenaline Rush",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 13750,
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
        
        -- Killing Spree - Mobility and burst damage
        { 
            id = 51690, 
            name = "Killing Spree",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 51690,
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
        
        -- Slice and Dice - Keep this up at all times
        { 
            id = 5171, 
            name = "Slice and Dice",
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
                        spell = "Slice and Dice",
                        operator = "LESSTHAN",
                        value = 6
                    }
                }
            }
        },
        
        -- Revealing Strike - Debuff that increases finisher damage
        { 
            id = 84617, 
            name = "Revealing Strike",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 4
                    },
                    {
                        type = "DEBUFF_REMAIN",
                        unit = "target",
                        spell = "Revealing Strike",
                        operator = "LESSTHAN",
                        value = 3
                    }
                }
            }
        },
        
        -- Rupture - Apply and maintain this DoT
        { 
            id = 1943, 
            name = "Rupture",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 4
                    },
                    {
                        type = "DEBUFF_REMAIN",
                        unit = "target",
                        spell = "Rupture",
                        operator = "LESSTHAN",
                        value = 3
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Revealing Strike",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Sinister Strike - Primary combo POINT builder
        { 
            id = 1752, 
            name = "Sinister Strike",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 5
                    },
                    {
                        type = "ENERGY",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 50
                    }
                }
            }
        },
        
        -- Eviscerate - Finisher when DoTs are up
        { 
            id = 2098, 
            name = "Eviscerate",
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
                        spell = "Rupture",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Slice and Dice",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Blade Flurry - Cleave damage for 2+ targets
        { 
            id = 13877, 
            name = "Blade Flurry",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "ENEMIES",
                        operator = "GREATERTHANOREQUALS",
                        value = 2
                    },
                    {   
                        type = "NOT",
                        value = {
                            type = "BUFF",
                            unit = "player",
                            spell = "Blade Flurry",
                            operator = "NOTEQUALS",
                            value = 1
                         }
                    }
                }
            }
        }
    }

    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Combat Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Subtlety rotations
function RogueWizard:CreateSubtletyRotations()
    local specId = 3  -- Subtlety spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Shadow Dance - Major offensive cooldown
        { 
            id = 51713, 
            name = "Shadow Dance",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 51713,
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
        
        -- Shadow Blades - Major offensive cooldown
        { 
            id = 121471, 
            name = "Shadow Blades",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 121471,
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
        
        -- Slice and Dice - Keep this up at all times
        { 
            id = 5171, 
            name = "Slice and Dice",
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
                        spell = "Slice and Dice",
                        operator = "LESSTHAN",
                        value = 6
                    }
                }
            }
        },
        
        -- Hemorrhage - Apply for the debuff
        { 
            id = 16511, 
            name = "Hemorrhage",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DEBUFF_REMAIN",
                        unit = "target",
                        spell = "Hemorrhage",
                        operator = "LESSTHAN",
                        value = 3
                    },
                    {
                        type = "ENERGY",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 45
                    }
                }
            }
        },
        
        -- Rupture - Apply and maintain this DoT
        { 
            id = 1943, 
            name = "Rupture",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 4
                    },
                    {
                        type = "DEBUFF_REMAIN",
                        unit = "target",
                        spell = "Rupture",
                        operator = "LESSTHAN",
                        value = 3
                    }
                }
            }
        },
        
        -- Ambush - When Shadow Dance is active
        { 
            id = 8676, 
            name = "Ambush",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Shadow Dance",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "ENERGY",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 60
                    }
                }
            }
        },
        
        -- Backstab - Main combo POINT builder
        { 
            id = 53, 
            name = "Backstab",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "POINT",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 5
                    },
                    {
                        type = "ENERGY",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 60
                    }
                }
            }
        },
        
        -- Eviscerate - Finisher when DoTs are up
        { 
            id = 2098, 
            name = "Eviscerate",
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
                        spell = "Rupture",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Slice and Dice",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Shadowstep - Gap closer
        { 
            id = 36554, 
            name = "Shadowstep",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 36554,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "ENERGY",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 30
                    }
                }
            }
        }
    }


    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Subtlety Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

