local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Warlock wizard
local WarlockWizard = {}

-- Register the Warlock wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(9, WarlockWizard) -- 9 is the class ID for Warlock

-- Define available specializations for Warlock in Classic/non-retail versions
function WarlockWizard:GetSpecializations()
    return {
        { id = 1, name = "Affliction" },
        { id = 2, name = "Demonology" },
        { id = 3, name = "Destruction" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function WarlockWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Affliction" or specId == 1 then
        createdRotations = self:CreateAfflictionRotations()
    elseif specName == "Demonology" or specId == 2 then
        createdRotations = self:CreateDemonologyRotations()
    elseif specName == "Destruction" or specId == 3 then
        createdRotations = self:CreateDestructionRotations()
    end
    
    return createdRotations
end

-- Create Affliction rotations
function WarlockWizard:CreateAfflictionRotations()
    local specId = 1  -- Affliction spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Check if pet is summoned
        { 
            id = 691, 
            name = "Summon Felhunter",
            conditions = {
                type = "PET",
                operator = "NOTEQUALS",
                value = true
            }
        },
        
        -- Dark Soul: Misery - Major cooldown for burst damage
        { 
            id = 113860, 
            name = "Dark Soul: Misery",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 113860,
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
        
        -- Curse of the Elements - Apply debuff if not already applied
        { 
            id = 1490, 
            name = "Curse of the Elements",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Curse of the Elements",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Haunt - Apply debuff and heal on expiration
        { 
            id = 48181, 
            name = "Haunt",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 48181,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Haunt",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Agony - Apply DoT if not already applied
        { 
            id = 980, 
            name = "Agony",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Agony",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Corruption - Apply DoT if not already applied
        { 
            id = 172, 
            name = "Corruption",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Corruption",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Unstable Affliction - Apply DoT if not already applied
        { 
            id = 30108, 
            name = "Unstable Affliction",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Unstable Affliction",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Drain Soul - Execute phase ability or Soul Shard generator
        { 
            id = 1120, 
            name = "Drain Soul",
            conditions = {
                type = "OR",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.2
                    },
                    {
                        type = "SHARD",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 3
                    }
                }
            }
        },
        
        -- Malefic Grasp/Drain Life - Main filler
        { 
            id = 103103, 
            name = "Malefic Grasp",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Agony",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Corruption",
                        operator = "EQUALS",
                        value = 1
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Unstable Affliction",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Life Tap - Mana management
        { 
            id = 1454, 
            name = "Life Tap",
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
                        type = "HEALTHPCT",
                        unit = "player",
                        operator = "GREATERTHAN",
                        value = 0.5
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Affliction Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Demonology rotations
function WarlockWizard:CreateDemonologyRotations()
    local specId = 2  -- Demonology spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Check if pet is summoned
        { 
            id = 30146, 
            name = "Summon Felguard",
            conditions = {
                type = "PET",
                operator = "NOTEQUALS",
                value = true
            }
        },
        
        -- Dark Soul: Knowledge - Major cooldown for burst damage
        { 
            id = 113861, 
            name = "Dark Soul: Knowledge",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 113861,
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
        
        -- Summon Doomguard/Infernal - Major cooldown
        { 
            id = 18540, 
            name = "Summon Doomguard",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 18540,
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
        
        -- Curse of the Elements - Apply debuff if not already applied
        { 
            id = 1490, 
            name = "Curse of the Elements",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Curse of the Elements",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Hand of Gul'dan - Apply DoT and generate Demonic Fury
        { 
            id = 105174, 
            name = "Hand of Gul'dan",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Shadowflame",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Corruption - Apply DoT if not already applied
        { 
            id = 172, 
            name = "Corruption",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Corruption",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Doom - Apply DoT if not already applied
        { 
            id = 603, 
            name = "Doom",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Doom",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Metamorphosis - Enter demon form when Demonic Fury is high
        { 
            id = 103958, 
            name = "Metamorphosis",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "DEMONIC_FURY",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 900
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Metamorphosis",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Soul Fire - With Molten Core proc
        { 
            id = 6353, 
            name = "Soul Fire",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Molten Core",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Chaos Wave - While in Metamorphosis
        { 
            id = 124915, 
            name = "Chaos Wave",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Metamorphosis",
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
        
        -- Touch of Chaos - While in Metamorphosis
        { 
            id = 103964, 
            name = "Touch of Chaos",
            conditions = {
                type = "BUFF",
                unit = "player",
                spell = "Metamorphosis",
                operator = "EQUALS",
                value = 1
            }
        },
        
        -- Shadow Bolt - Main filler
        { 
            id = 686, 
            name = "Shadow Bolt",
            conditions = {
                type = "MANA",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 0.1
            }
        },
        
        -- Command Demon - Pet special ability
        { 
            id = 119898, 
            name = "Command Demon",
            conditions = {
                type = "PET",
                operator = "EQUALS",
                value = true
            }
        },
        
        -- Life Tap - Mana management
        { 
            id = 1454, 
            name = "Life Tap",
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
                        type = "HEALTHPCT",
                        unit = "player",
                        operator = "GREATERTHAN",
                        value = 0.5
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Demonology Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Destruction rotations
function WarlockWizard:CreateDestructionRotations()
    local specId = 3  -- Destruction spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Check if pet is summoned
        { 
            id = 688, 
            name = "Summon Imp",
            conditions = {
                type = "PET",
                operator = "NOTEQUALS",
                value = true
            }
        },
        
        -- Dark Soul: Instability - Major cooldown for burst damage
        { 
            id = 113858, 
            name = "Dark Soul: Instability",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 113858,
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
        
        -- Summon Doomguard/Infernal - Major cooldown
        { 
            id = 18540, 
            name = "Summon Doomguard",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 18540,
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
        
        -- Curse of the Elements - Apply debuff if not already applied
        { 
            id = 1490, 
            name = "Curse of the Elements",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Curse of the Elements",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Immolate - Apply DoT if not already applied
        { 
            id = 348, 
            name = "Immolate",
            conditions = {
                type = "DEBUFF",
                unit = "target",
                spell = "Immolate",
                operator = "NOTEQUALS",
                value = 1
            }
        },
        
        -- Conflagrate - Consume Immolate to generate Burning Embers
        { 
            id = 17962, 
            name = "Conflagrate",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 17962,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Immolate",
                        operator = "EQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Chaos Bolt - Main nuke when Burning Embers are available
        { 
            id = 116858, 
            name = "Chaos Bolt",
            conditions = {
                type = "BURNING_EMBERS",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 2
            }
        },
        
        -- Shadowburn - Execute phase when Burning Embers are available
        { 
            id = 17877, 
            name = "Shadowburn",
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
                        type = "BURNING_EMBERS",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Rain of Fire - AoE damage
        { 
            id = 5740, 
            name = "Rain of Fire",
            conditions = {
                type = "ENEMIES",
                operator = "GREATERTHANOREQUALS",
                value = 3
            }
        },
        
        -- Fire and Brimstone - AoE mode when multiple targets
        { 
            id = 108683, 
            name = "Fire and Brimstone",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "ENEMIES",
                        operator = "GREATERTHANOREQUALS",
                        value = 3
                    },
                    {
                        type = "BURNING_EMBERS",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 1
                    },
                    {
                        type = "BUFF",
                        unit = "player",
                        spell = "Fire and Brimstone",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Incinerate - Main filler
        { 
            id = 29722, 
            name = "Incinerate",
            conditions = {
                type = "MANA",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 0.1
            }
        },
        
        -- Life Tap - Mana management
        { 
            id = 1454, 
            name = "Life Tap",
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
                        type = "HEALTHPCT",
                        unit = "player",
                        operator = "GREATERTHAN",
                        value = 0.5
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Destruction Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
