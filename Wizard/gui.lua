local addon_name, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)
local AceGUI = LibStub("AceGUI-3.0")

local WizardGUI = {}
addon.WizardGUI = WizardGUI

-- Creates and shows the main wizard window
function WizardGUI:ShowClassWizard(className, classId)
    -- Create the main window
    local window = AceGUI:Create("Window")
    window:SetTitle(L["RotationMaster: "] .. className .. L[" Setup Wizard"])
    window:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
    end)
    window:SetLayout("Flow")
    window:SetWidth(500)
    window:SetHeight(200)
    window:EnableResize(false)
    
    -- Handle the backdrop in a way that works in all WoW versions
    local f = window.frame
    Mixin(f, BackdropTemplateMixin)
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        tile = true,
        tileSize = 8
    })
    f:SetBackdropColor(0, 0, 0, 1)


    -- Introduction text
    local intro = AceGUI:Create("Label")
    intro:SetFullWidth(true)
    intro:SetText(L["This wizard will help you set up basic rotations for your "] .. className .. 
                  L[". You can customize these later in the Rotations section."])
    window:AddChild(intro)

    -- Get specializations for this class
    local specializations = addon.WizardSystem:GetClassSpecializations(classId)
    
    if not specializations or #specializations == 0 then
        local noSpecsLabel = AceGUI:Create("Label")
        noSpecsLabel:SetFullWidth(true)
        noSpecsLabel:SetText(L["No specializations found for this class."])
        window:AddChild(noSpecsLabel)
        return window
    end
    
    -- Specialization selection
    local specGroup = AceGUI:Create("InlineGroup")
    specGroup:SetTitle(L["Select Specialization"])
    specGroup:SetFullWidth(true)
    specGroup:SetLayout("Flow")
    window:AddChild(specGroup)
    
    -- Create buttons for each specialization
    local buttonWidth = 1 / #specializations
    
    for _, spec in ipairs(specializations) do
        local specButton = AceGUI:Create("Button")
        specButton:SetText(spec.name)
        specButton:SetRelativeWidth(buttonWidth)
        specButton:SetCallback("OnClick", function()
            if addon.WizardSystem.CreateRotationForSpec then
                addon.WizardSystem:CreateRotationForSpec(classId, spec.id, spec.name)
                window:Release()
            end
        end)
        specGroup:AddChild(specButton)
    end
    
    return window
end

-- Shows the completion dialog
function WizardGUI:ShowCompletionDialog(rotations, overwrittenMap, overwrittenCount)
    local dialog = AceGUI:Create("Window")
    dialog:SetTitle(L["Setup complete!"])
    dialog:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
    end)
    dialog:SetLayout("Flow")
    dialog:SetWidth(400)
    dialog:SetHeight(200)
    dialog:EnableResize(false)
    
    f = dialog.frame
    Mixin(f, BackdropTemplateMixin)
    f:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        tile = true,
        tileSize = 8
    })
    f:SetBackdropColor(0, 0, 0, 1)

    local complete = AceGUI:Create("Label")
    complete:SetFullWidth(true)
    
    if overwrittenCount and overwrittenCount > 0 then
        if #rotations == overwrittenCount then
            complete:SetText(L["Existing rotations have been updated. You can find them in the Rotations tab."])
        else
            complete:SetText(L["Rotations have been created or updated. You can find them in the Rotations tab."])
        end
    else
        complete:SetText(L["Basic rotations have been created. You can now customize them in the Rotations tab."])
    end
    
    dialog:AddChild(complete)
    
    -- List all created rotations
    if rotations and #rotations > 0 then
        for i, rotationName in ipairs(rotations) do
            local created = AceGUI:Create("Label")
            created:SetFullWidth(true)
            
            if overwrittenMap and overwrittenMap[i] then
                created:SetText(L["Updated rotation: "] .. rotationName)
            else
                created:SetText(L["Created rotation: "] .. rotationName)
            end
            
            dialog:AddChild(created)
        end
    end
    
    return dialog
end
