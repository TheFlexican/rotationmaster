local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Create the Monk wizard
local MonkWizard = {}

-- Register the Monk wizard with the wizard system
addon.WizardSystem:RegisterClassWizard(10, MonkWizard) -- 10 is the class ID for Monk

-- Define available specializations for Monk in Classic/non-retail versions
function MonkWizard:GetSpecializations()
    return {
        { id = 1, name = "Windwalker" },
        { id = 2, name = "Brewmaster" },
        { id = 3, name = "Mistweaver" }
    }
end

-- Main rotation creation function - delegates to spec-specific functions
function MonkWizard:CreateRotations(specName, specId)
    local createdRotations = {}
    
    if specName == "Windwalker" or specId == 1 then
        createdRotations = self:CreateWindwalkerRotations()
    elseif specName == "Brewmaster" or specId == 2 then
        createdRotations = self:CreateBrewmasterRotations()
    elseif specName == "Mistweaver" or specId == 3 then
        createdRotations = self:CreateMistweaverRotations()
    end
    
    return createdRotations
end

-- Create Windwalker rotations
function MonkWizard:CreateWindwalkerRotations()
    local specId = 1  -- Windwalker spec ID
    local createdRotations = {}
    
    -- Single target rotation - Organized by priority
    local singleTargetSpells = {
        -- Tigereye Brew at 10 stacks for maximum damage
        { 
            id = 116740, 
            name = "Tigereye Brew",
            conditions = {
                type = "BUFF_STACKS",
                unit = "player",
                spell = "Tigereye Brew",
                operator = "GREATERTHANOREQUALS",
                value = 10
            }
        },
        
        -- Touch of Death - Use when available (target below 10% health)
        { 
            id = 115080, 
            name = "Touch of Death",
            conditions = {
                type = "HEALTHPCT",
                unit = "target",
                operator = "LESSTHAN",
                value = 0.1
            }
        },
        
        -- Energizing Brew - Use when low on energy
        { 
            id = 115288, 
            name = "Energizing Brew",
            conditions = {
                type = "ENERGY",
                unit = "player",
                operator = "LESSTHAN",
                value = 40
            }
        },
        
        -- Rising Sun Kick - Keep the debuff up
        { 
            id = 107428, 
            name = "Rising Sun Kick",
            conditions = {
                type = "CHI",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 2
            }
        },
        
        -- Fists of Fury - Core channeled ability
        { 
            id = 113656, 
            name = "Fists of Fury",
            conditions = {
                type = "CHI",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 3
            }
        },
        
        -- Chi Wave - If talented
        { 
            id = 115098, 
            name = "Chi Wave",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 115098,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Expel Harm - Chi builder with healing when health is not full
        { 
            id = 115072, 
            name = "Expel Harm",
            conditions = {
                type = "HEALTHPCT",
                unit = "player",
                operator = "LESSTHAN",
                value = 1
            }
        },
        
        -- Tiger Palm - Apply Tiger Power buff
        { 
            id = 100787, 
            name = "Tiger Palm",
            conditions = {
                type = "BUFF_REMAIN",
                unit = "player",
                spell = "Tiger Power",
                operator = "LESSTHAN",
                value = 4
            }
        },
        
        -- Blackout Kick - Use when Tiger Power is up and we have Chi
        { 
            id = 100784, 
            name = "Blackout Kick",
            conditions = {
                type = "CHI",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 2
            }
        },
        
        -- Jab - Main Chi builder
        { 
            id = 100780, 
            name = "Jab",
            conditions = {
                type = "CHI",
                unit = "player",
                operator = "LESSTHAN",
                value = 4
            }
        },
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Windwalker Single Target", singleTargetSpells)


    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget, specId)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end

-- Create Brewmaster rotations
function MonkWizard:CreateBrewmasterRotations()
    local specId = 2  -- Brewmaster spec ID
    local createdRotations = {}
    
    -- Core Brewmaster defensive rotation
    local defensiveSpells = {
        -- Ironskin Brew - Active mitigation
        { 
            id = 115308, 
            name = "Ironskin Brew",
            conditions = {
                type = "HEALTHPCT",
                unit = "player",
                operator = "LESSTHAN",
                value = 0.8
            }
        },
        
        -- Guard - Shield absorption
        { 
            id = 115295, 
            name = "Guard",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 0.75
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 115295,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Fortifying Brew - Major defensive cooldown
        { 
            id = 115203, 
            name = "Fortifying Brew",
            conditions = {
                type = "HEALTHPCT",
                unit = "player",
                operator = "LESSTHAN",
                value = 0.4
            }
        },
        
        -- Expel Harm - Self-healing
        { 
            id = 115072, 
            name = "Expel Harm",
            conditions = {
                type = "HEALTHPCT",
                unit = "player",
                operator = "LESSTHAN",
                value = 0.7
            }
        },
        
        -- Avert Harm - Raid damage reduction
        { 
            id = 115213, 
            name = "Avert Harm",
            conditions = {
                type = "HEALTHPCT",
                unit = "target",
                operator = "LESSTHAN",
                value = 0.5
            }
        },
        
        -- Healing Elixirs - Passive healing (if talented)
        { 
            id = 122280, 
            name = "Healing Elixirs",
            conditions = {
                type = "HEALTHPCT",
                unit = "player",
                operator = "LESSTHAN",
                value = 0.65
            }
        },
        
        -- Chi Brew - Generate Chi (if talented)
        { 
            id = 115399, 
            name = "Chi Brew",
            conditions = {
                type = "CHI",
                unit = "player",
                operator = "LESSTHAN",
                value = 2
            }
        }
    }
    
    -- Brewmaster offensive rotation for threat generation
    local offensiveSpells = {
        -- Keg Smash - High threat, AoE, generates Chi
        { 
            id = 121253, 
            name = "Keg Smash",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 121253,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Breath of Fire - AoE damage and debuff
        { 
            id = 115181, 
            name = "Breath of Fire",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "CHI",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 2
                    },
                    {
                        type = "DEBUFF",
                        unit = "target",
                        spell = "Weakened Blows",
                        operator = "NOTEQUALS",
                        value = 1
                    }
                }
            }
        },
        
        -- Blackout Kick - Chi spender
        { 
            id = 100784, 
            name = "Blackout Kick",
            conditions = {
                type = "CHI",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 2
            }
        },
        
        -- Rising Sun Kick - High damage
        { 
            id = 107428, 
            name = "Rising Sun Kick",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "CHI",
                        unit = "player",
                        operator = "GREATERTHAN",
                        value = 2
                    },
                    {
                        type = "NOT",
                        value = {
                            type = "DEBUFF",
                            unit = "target",
                            spell = "Rising Sun Kick"
                        }
                    }
                }
            }
        },
        
        -- Tiger Palm - Generate Power Guard stacks
        { 
            id = 100787, 
            name = "Tiger Palm",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "CHI",
                        unit = "player",
                        operator = "GREATERTHAN",
                        value = 0
                    },
                    {
                        type = "BUFF_REMAIN",
                        unit = "player",
                        spell = "Power Guard",
                        operator = "LESSTHAN",
                        value = 4
                    }
                }
            }
        },
        
        -- Spinning Fire Blossom - Ranged attack
        { 
            id = 115073, 
            name = "Spinning Fire Blossom",
            conditions = {
                type = "DISTANCE",
                unit = "target",
                operator = "GREATERTHAN",
                value = 10
            }
        },
        
        -- Jab - Chi builder
        { 
            id = 100780, 
            name = "Jab",
            conditions = {
                type = "CHI",
                unit = "player",
                operator = "LESSTHAN",
                value = 4
            }
        }
    }
    
    -- AoE tanking rotation
    local aoeSpells = {
        -- Ironskin Brew - Active mitigation
        { 
            id = 115308, 
            name = "Ironskin Brew",
            conditions = {
                type = "HEALTHPCT",
                unit = "player",
                operator = "LESSTHAN",
                value = 0.8
            }
        },
        
        -- Dizzying Haze - Ranged AoE threat
        { 
            id = 115180, 
            name = "Dizzying Haze",
            conditions = {
                type = "PROXIMITY",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 3,
                distance = 8,
                samegroup = false,
                includepets = false
            }
        },
        
        -- Keg Smash - High threat, AoE, generates Chi
        { 
            id = 121253, 
            name = "Keg Smash",
            conditions = {
                type = "SPELL_COOLDOWN",
                spell = 121253,
                ranked = false,
                operator = "EQUALS",
                value = 0
            }
        },
        
        -- Breath of Fire - AoE damage and debuff
        { 
            id = 115181, 
            name = "Breath of Fire",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "CHI",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 2
                    },
                    {
                        type = "ENEMIES",
                        operator = "GREATERTHANOREQUALS",
                        value = 3,
                    }
                }
            }
        },
        
        -- Spinning Crane Kick - AoE damage
        { 
            id = 101546, 
            name = "Spinning Crane Kick",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "ENERGY",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 40
                    },
                    {
                        type = "PROXIMITY",
                        operator = "GREATERTHANOREQUALS",
                        value = 4,
                        distance = 8,
                        samegroup = false,
                        includepets = false
                    }
                }
            }
        },
        
        -- Summon Black Ox Statue - Statue for threat
        { 
            id = 115315, 
            name = "Summon Black Ox Statue",
            conditions = {
                type = "NOT",
                value = {
                    type = "TOTEM",
                    totem = "Black Ox Statue"
                }
            }
        },
        
        -- Blackout Kick - Chi spender
        { 
            id = 100784, 
            name = "Blackout Kick",
            conditions = {
                type = "CHI",
                unit = "player",
                operator = "GREATERTHANOREQUALS",
                value = 2
            }
        }
    }
    
    -- Utility/Movement
    local utilitySpells = {
        { id = 115008, name = "Chi Torpedo" },      -- Movement ability (if talented)
        { id = 107079, name = "Quaking Palm" },     -- Racial stun if Pandaren
        { id = 115078, name = "Paralysis" },        -- CC
        { id = 115546, name = "Provoke" },          -- Taunt
        { id = 119392, name = "Charging Ox Wave" }, -- Stun (if talented)
        { id = 119381, name = "Leg Sweep" },        -- AoE stun
        { id = 116844, name = "Ring of Peace" },    -- AoE crowd control
        { id = 115178, name = "Resuscitate" }       -- Combat resurrection
    }

    -- Cooldowns
    local cooldownSpells = {
        { id = 115203, name = "Fortifying Brew" },
        { id = 115176, name = "Zen Meditation" },
        { id = 115399, name = "Chi Brew" },         -- Generate Chi (if talented)
        { id = 115315, name = "Summon Black Ox Statue" }
    }

    -- Create and save rotations
    local defensive = addon.WizardSystem:CreateBasicRotation("Brewmaster Defensive", defensiveSpells)
    local offensive = addon.WizardSystem:CreateBasicRotation("Brewmaster Offensive", offensiveSpells)

    -- Save rotations and track their names
    local _, defensiveName = addon.WizardSystem:SaveRotation(defensive, specId)
    local _, offensiveName = addon.WizardSystem:SaveRotation(offensive, specId)
    
    table.insert(createdRotations, defensiveName)
    table.insert(createdRotations, offensiveName)
    
    return createdRotations
end

-- Create Mistweaver rotations
function MonkWizard:CreateMistweaverRotations()
    local specId = 3  -- Mistweaver spec ID
    local createdRotations = {}
    
    -- Single target healing rotation
    local singleTargetSpells = {
        -- Uplift - Heals all targets with Renewing Mist
        { 
            id = 116670, 
            name = "Uplift",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "CHI",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 2
                    },
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.9
                    }
                }
            }
        },
        
        -- Renewing Mist - HoT, generates Chi
        { 
            id = 115151, 
            name = "Renewing Mist",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.95
                    },
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 115151,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    }
                }
            }
        },
        
        -- Surging Mist - Fast direct heal, consumes Vital Mists
        { 
            id = 116694, 
            name = "Surging Mist",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.6
                    },
                    {
                        type = "BUFF_STACKS",
                        unit = "player",
                        spell = "Vital Mists",
                        operator = "GREATERTHANOREQUALS",
                        value = 4
                    }
                }
            }
        },
        
        -- Soothing Mist - Channeled heal, generates Vital Mists
        { 
            id = 115175, 
            name = "Soothing Mist",
            conditions = {
                type = "HEALTHPCT",
                unit = "target",
                operator = "LESSTHAN",
                value = 0.9
            }
        },
        
        -- Enveloping Mist - Powerful HoT, requires Chi
        { 
            id = 124682, 
            name = "Enveloping Mist",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "CHI",
                        unit = "player",
                        operator = "GREATERTHANOREQUALS",
                        value = 3
                    },
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.7
                    }
                }
            }
        },
        
        -- Revival - AoE healing cooldown
        { 
            id = 115310, 
            name = "Revival",
            conditions = {
                type = "PROXIMITY_HEALTH",
                unit = "player",
                operation = "average",
                operator = "LESSTHAN",
                value = 0.6,
                distance = 40,
                samegroup = true
            }
        },
        
        -- Thunder Focus Tea - Empowers next healing spell
        { 
            id = 116680, 
            name = "Thunder Focus Tea",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "SPELL_COOLDOWN",
                        spell = 116680,
                        ranked = false,
                        operator = "EQUALS",
                        value = 0
                    },
                    {
                        type = "HEALTHPCT",
                        unit = "target",
                        operator = "LESSTHAN",
                        value = 0.65
                    }
                }
            }
        },
        
        -- Detox - Dispel
        { 
            id = 115450, 
            name = "Detox",
            conditions = {
                type = "OR",
                value = {
                    {
                        type = "DISPELLABLE",
                        unit = "target",
                        debufftype = "Magic",
                        dispellable = true
                    },
                    {
                        type = "DISPELLABLE",
                        unit = "target",
                        debufftype = "Disease",
                        dispellable = true
                    },
                    {
                        type = "DISPELLABLE",
                        unit = "target",
                        debufftype = "Poison",
                        dispellable = true
                    }
                }
            }
        },
        
        -- Expel Harm - Self-heal that generates Chi
        { 
            id = 115072, 
            name = "Expel Harm",
            conditions = {
                type = "AND",
                value = {
                    {
                        type = "HEALTHPCT",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 0.8
                    },
                    {
                        type = "CHI",
                        unit = "player",
                        operator = "LESSTHAN",
                        value = 5
                    }
                }
            }
        }
    }
    
    -- Create and save rotations
    local singleTarget = addon.WizardSystem:CreateBasicRotation("Mistweaver Single Target", singleTargetSpells)

    -- Save rotations and track their names
    local _, singleTargetName = addon.WizardSystem:SaveRotation(singleTarget)
    
    table.insert(createdRotations, singleTargetName)
    
    return createdRotations
end
