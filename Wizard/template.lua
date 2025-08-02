--[[
    Template file for creating new class wizards
    
    To create a wizard for a new class:
    1. Copy this file and rename it to your class name in lowercase (e.g., mage.lua)
    2. Replace "TemplateWizard" with "[YourClass]Wizard"
    3. Fill in the spell data for your class specializations
    4. Register your wizard with the correct class ID at the bottom of the file
    
    Class IDs:
    1 = Warrior, 2 = Paladin, 3 = Hunter, 4 = Rogue, 5 = Priest,
    6 = Death Knight, 7 = Shaman, 8 = Mage, 9 = Warlock, 10 = Monk,
    11 = Druid
]]

local addonName, addon = ...
local L = addon.L
local WizardSystem = addon.WizardSystem
local AceGUI = LibStub("AceGUI-3.0")

local TemplateWizard = {}

-- Class spell data for MoP Classic
-- Fill this with appropriate spells for each specialization
local ClassSpells = {
    -- Spec1
    Specialization1 = {
        rotation = {
            { id = 0000, name = "Spell Name 1" },
            { id = 0000, name = "Spell Name 2" },
            { id = 0000, name = "Spell Name 3" },
        },
        cooldowns = {
            { id = 0000, name = "Cooldown Name 1" },
            { id = 0000, name = "Cooldown Name 2" },
        },
    },
    -- Spec2
    Specialization2 = {
        rotation = {
            { id = 0000, name = "Spell Name 1" },
            { id = 0000, name = "Spell Name 2" },
            { id = 0000, name = "Spell Name 3" },
        },
        cooldowns = {
            { id = 0000, name = "Cooldown Name 1" },
            { id = 0000, name = "Cooldown Name 2" },
        },
    },
    -- Spec3
    Specialization3 = {
        rotation = {
            { id = 0000, name = "Spell Name 1" },
            { id = 0000, name = "Spell Name 2" },
            { id = 0000, name = "Spell Name 3" },
        },
        cooldowns = {
            { id = 0000, name = "Cooldown Name 1" },
            { id = 0000, name = "Cooldown Name 2" },
        },
    },
}
function TemplateWizard:ShowWizard(className, specName, specId)
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(L["RotationMaster: "] .. className .. L[" Setup Wizard"])
    frame:SetLayout("Flow")
    frame:SetWidth(500)
    frame:SetHeight(450)

    -- Introduction text
    local intro = AceGUI:Create("Label")
    intro:SetText(L["This wizard will help you set up basic rotations for your "] .. className .. L[". You can customize these later in the Rotations section."])
    intro:SetFullWidth(true)
    frame:AddChild(intro)
    
    -- Spec selection
    local specHeader = AceGUI:Create("Heading")
    specHeader:SetText(L["Select Specialization"])
    specHeader:SetFullWidth(true)
    frame:AddChild(specHeader)
    
    -- Customize this list for your class's specializations
    local specDropdown = AceGUI:Create("Dropdown")
    specDropdown:SetList({
        ["Specialization1"] = L["Specialization1"],
        ["Specialization2"] = L["Specialization2"],
        ["Specialization3"] = L["Specialization3"]
    })
    specDropdown:SetValue(specName or "Specialization1")
    specDropdown:SetFullWidth(true)
    frame:AddChild(specDropdown)
    
    -- Spell selection group
    local spellGroup = AceGUI:Create("InlineGroup")
    spellGroup:SetTitle(L["Rotation Spells"])
    spellGroup:SetLayout("Flow")
    spellGroup:SetFullWidth(true)
    frame:AddChild(spellGroup)
    
    local selectedSpec = specName or "Specialization1"
    local spellCheckboxes = {}
    
    local function updateSpellList(spec)
        -- Clear existing checkboxes
        spellGroup:ReleaseChildren()
        spellCheckboxes = {}
        
        -- Add new checkboxes for the selected spec
        local spells = ClassSpells[spec].rotation
        for _, spell in ipairs(spells) do
            local checkbox = AceGUI:Create("CheckBox")
            checkbox:SetLabel(spell.name)
            checkbox:SetValue(true)  -- Default to checked
            checkbox:SetWidth(200)
            spellGroup:AddChild(checkbox)
            spellCheckboxes[spell.id] = checkbox
        end
    end
    
    -- Update spell list when spec changes
    specDropdown:SetCallback("OnValueChanged", function(widget, event, value)
        selectedSpec = value
        updateSpellList(value)
    end)
    
    -- Initial spell list
    updateSpellList(selectedSpec)
    
    -- Cooldown selection group
    local cooldownGroup = AceGUI:Create("InlineGroup")
    cooldownGroup:SetTitle(L["Cooldown Spells"])
    cooldownGroup:SetLayout("Flow")
    cooldownGroup:SetFullWidth(true)
    frame:AddChild(cooldownGroup)
    
    local cooldownCheckboxes = {}
    
    local function updateCooldownList(spec)
        -- Clear existing checkboxes
        cooldownGroup:ReleaseChildren()
        cooldownCheckboxes = {}
        
        -- Add new checkboxes for the selected spec
        local cooldowns = ClassSpells[spec].cooldowns
        for _, spell in ipairs(cooldowns) do
            local checkbox = AceGUI:Create("CheckBox")
            checkbox:SetLabel(spell.name)
            checkbox:SetValue(true)  -- Default to checked
            checkbox:SetWidth(200)
            cooldownGroup:AddChild(checkbox)
            cooldownCheckboxes[spell.id] = checkbox
        end
    end
    
    -- Update cooldown list when spec changes
    specDropdown:SetCallback("OnValueChanged", function(widget, event, value)
        selectedSpec = value
        updateSpellList(value)
        updateCooldownList(value)
    end)
    
    -- Initial cooldown list
    updateCooldownList(selectedSpec)
    
    -- Rotation name
    local nameHeader = AceGUI:Create("Heading")
    nameHeader:SetText(L["Rotation Name"])
    nameHeader:SetFullWidth(true)
    frame:AddChild(nameHeader)
    
    local nameInput = AceGUI:Create("EditBox")
    nameInput:SetText(selectedSpec .. " " .. L["Rotation"])
    nameInput:SetFullWidth(true)
    frame:AddChild(nameInput)
    
    -- Create button
    local createButton = AceGUI:Create("Button")
    createButton:SetText(L["Create Rotation"])
    createButton:SetFullWidth(true)
    createButton:SetCallback("OnClick", function()
        -- Collect selected spells
        local selectedRotationSpells = {}
        for id, checkbox in pairs(spellCheckboxes) do
            if checkbox:GetValue() then
                for _, spellData in ipairs(ClassSpells[selectedSpec].rotation) do
                    if spellData.id == id then
                        table.insert(selectedRotationSpells, spellData)
                        break
                    end
                end
            end
        end
        
        -- Collect selected cooldowns
        local selectedCooldownSpells = {}
        for id, checkbox in pairs(cooldownCheckboxes) do
            if checkbox:GetValue() then
                for _, spellData in ipairs(ClassSpells[selectedSpec].cooldowns) do
                    if spellData.id == id then
                        table.insert(selectedCooldownSpells, spellData)
                        break
                    end
                end
            end
        end
        
        -- Create and save rotation
        local rotationName = nameInput:GetText()
        local rotation = WizardSystem:CreateBasicRotation(rotationName, selectedRotationSpells)
        local rotationId = WizardSystem:SaveRotation(rotation)
        
        -- Create and save cooldown if any cooldowns selected
        if #selectedCooldownSpells > 0 then
            local cooldownName = selectedSpec .. " " .. L["Cooldowns"]
            local cooldown = WizardSystem:CreateBasicCooldown(cooldownName, selectedCooldownSpells)
            local cooldownId = WizardSystem:SaveCooldown(cooldown)
        end
        
        -- Close the wizard
        frame:Release()
        
        -- Show confirmation
        addon:Print(L["Created new rotation: "] .. rotationName)
    end)
    frame:AddChild(createButton)
end

-- Register with the wizard system (replace X with your class ID)
-- WizardSystem:RegisterClassWizard(X, TemplateWizard)
