local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)

-- Initialize the Wizard System
addon.WizardSystem = {}
local WizardSystem = addon.WizardSystem

-- Class wizards registration
local registeredWizards = {}

-- Register a class-specific wizard
function WizardSystem:RegisterClassWizard(classId, wizard)
    registeredWizards[classId] = wizard
end

-- Get player class and spec information
function WizardSystem:GetPlayerInfo()
    local _, className = UnitClass("player")
    local classId = select(3, UnitClass("player"))
    
    -- For Classic: use talents to determine spec instead of GetSpecialization
    local specId, specName = nil, nil
    
    -- In Retail WoW, we can use GetSpecialization
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        local specIndex = GetSpecialization()
        if specIndex then
            specId, specName = GetSpecializationInfo(specIndex)
        end
    end
    -- For Classic WoW versions, we'll rely on class-specific detection
    
    return className, classId, specId, specName
end

-- Get specializations for a given class
function WizardSystem:GetClassSpecializations(classId)
    local specs = {}
    
    -- In Retail WoW
    if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
        for i = 1, GetNumSpecializationsForClassID(classId) do
            local specId, specName = GetSpecializationInfoForClassID(classId, i)
            table.insert(specs, { id = specId, name = specName })
        end
    else
        -- For Classic WoW versions
        -- Rely on the class wizard to provide specialization information
        if registeredWizards[classId] and registeredWizards[classId].GetSpecializations then
            specs = registeredWizards[classId]:GetSpecializations()
        end
    end
    
    return specs
end

-- Create rotations for a specific specialization
function WizardSystem:CreateRotationForSpec(classId, specId, specName)
    if not classId then
        addon:Print(L["Error: Missing classId in CreateRotationForSpec"])
        return
    end
    
    if not registeredWizards[classId] then
        addon:Print(L["No wizard registered for this class."])
        return
    end
    
    if not registeredWizards[classId].CreateRotations then
        addon:Print(L["Wizard doesn't have a CreateRotations method."])
        return
    end
    
    -- Before creating rotations, we should check which ones already exist
    local existingRotations = {}
    
    -- Safely check if rotations exist for this spec
    if addon.db and addon.db.profile and addon.db.profile.rotations and 
       addon.db.profile.rotations[specId] and type(addon.db.profile.rotations[specId]) == "table" then
        for id, rotation in pairs(addon.db.profile.rotations[specId]) do
            if rotation and rotation.name then
                existingRotations[rotation.name] = true
            end
        end
    end
    
    local createdRotations = registeredWizards[classId]:CreateRotations(specName, specId)
    
    if not createdRotations then
        addon:Print(L["No rotations were created."])
        return
    end
    
    -- Track which rotations were overwritten
    local overwrittenRotations = {}
    local overwrittenCount = 0
    
    -- Make sure both existingRotations and createdRotations are valid tables
    if existingRotations and type(existingRotations) == "table" and createdRotations and type(createdRotations) == "table" then
        for i, rotationName in ipairs(createdRotations) do
            if rotationName and existingRotations[rotationName] then
                overwrittenRotations[i] = true
                overwrittenCount = overwrittenCount + 1
            end
        end
    end
    
    if #createdRotations > 0 then
        addon.WizardGUI:ShowCompletionDialog(createdRotations, overwrittenRotations, overwrittenCount)
    else
        addon:Print(L["No rotation creator is available for this specialization yet."])
    end
end

-- Show the appropriate wizard for the player's class
function WizardSystem:ShowWizard()
    local className, classId = self:GetPlayerInfo()
    
    if registeredWizards[classId] then
        addon.WizardGUI:ShowClassWizard(className, classId)
    else
        addon:Print(L["No setup wizard is available for your class yet."])
    end
end

-- Utility function to create a basic rotation
function WizardSystem:CreateBasicRotation(rotationName, spellList)
    if not rotationName or not spellList then
        addon:Print(L["Error: Missing rotation name or spell list"])
        return {
            name = "Error Rotation",
            disabled = true,
            switch = {},
            cooldowns = {},
            rotation = {}
        }
    end
    
    local rotation = {
        name = rotationName,
        disabled = false,
        switch = {},
        cooldowns = {},
        rotation = {}
    }
    
    -- Add spells to rotation - ensure each entry is properly formatted
    for i, spell in ipairs(spellList) do
        local spellID = spell.id or spell
        local spellName = spell.name or GetSpellInfo(spellID) or "Unknown Spell"
        
        table.insert(rotation.rotation, {
            type = "spell",
            action = spellID,
            id = addon:uuid(),  -- Each spell entry needs its own UUID
            use_name = false,   -- Don't use spell name for display
            conditions = spell.conditions or {}     -- Use provided conditions or empty by default
        })
    end
    
    return rotation
end

-- Utility function to create a basic cooldown set
function WizardSystem:CreateBasicCooldown(cooldownName, spellList)
    if not cooldownName or not spellList then
        addon:Print(L["Error: Missing cooldown name or spell list"])
        return {
            name = "Error Cooldown",
            disabled = true,
            switch = {},
            cooldowns = {},
            rotation = {}
        }
    end
    
    local cooldown = {
        name = cooldownName,
        disabled = false,
        switch = {},
        cooldowns = {},
        rotation = {}
    }
    
    -- Add spells to cooldowns - ensure each entry is properly formatted
    for i, spell in ipairs(spellList) do
        local spellID = spell.id or spell
        local spellName = spell.name or GetSpellInfo(spellID) or "Unknown Spell"
        
        table.insert(cooldown.cooldowns, {
            type = "spell",
            action = spellID,
            id = addon:uuid(),
            conditions = spell.conditions or {
                type = "SPELL_COOLDOWN_DURATION",
                spell = spellID,
                operator = "<=",
                value = 0
            }
        })
    end
    
    return cooldown
end

-- Find a rotation by name in the specified specialization
function WizardSystem:FindRotationByName(name, specID)
    if not name or not addon.db.profile.rotations then
        return nil
    end
    
    -- Default to current class if no spec is set
    specID = specID or 0
    if not addon.db.profile.rotations[specID] then
        return nil
    end
    
    -- Search for a rotation with the given name
    for id, rotation in pairs(addon.db.profile.rotations[specID]) do
        if rotation.name == name then
            return id, rotation
        end
    end
    
    return nil
end

-- Save a rotation to the addon's DB, overwriting any existing rotation with the same name
function WizardSystem:SaveRotation(rotation, specID)
    if not rotation then
        addon:Print(L["Error: Attempted to save a nil rotation."])
        return nil, "Unknown"
    end

    if not addon.db.profile.rotations then
        addon.db.profile.rotations = {}
    end
    
    -- Default to current class if no spec is set
    specID = specID or 0
    if not addon.db.profile.rotations[specID] then
        addon.db.profile.rotations[specID] = {}
    end
    
    -- Check if a rotation with this name already exists
    local existingID = self:FindRotationByName(rotation.name, specID)
    local id = existingID or addon:uuid()
    
    -- Log the action (overwriting or creating new)
    if existingID then
        addon:debug(L["Overwriting existing rotation: %s"], rotation.name)
    else
        addon:debug(L["Creating new rotation: %s"], rotation.name)
    end
    
    addon.db.profile.rotations[1][id] = rotation
    
    -- Set version numbers to prevent migration logic from running
    addon.db.char.version = addon.CHAR_VERSION
    addon.db.profile.version = addon.PROFILE_VERSION
    addon.db.global.version = addon.GLOBAL_VERSION
    
    return id, rotation.name
end

-- Save a cooldown to the addon's DB
function WizardSystem:SaveCooldown(cooldown, specID)
    return self:SaveRotation(cooldown, specID)  -- Cooldowns use the same structure
end