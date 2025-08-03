-- MoP Classic Monk Support: Add specific Energy and Chi conditions
local addon_name, addon = ...

local AceGUI = LibStub("AceGUI-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(addon_name)
local color = color
local helpers = addon.help_funcs

-- Only add Monk conditions for MoP Classic and later
if (LE_EXPANSION_LEVEL_CURRENT >= 4) then
    addon:RegisterCondition("ENERGY", {
        description = L["Energy"],
        icon = "Interface\\Icons\\spell_shadow_unstableaffliction_3",
        fields = { unit = "string", operator = "string", value = "number" },
        valid = function(_, value)
            return (value.operator ~= nil and addon.isin(addon.operators, value.operator) and
                    value.unit ~= nil and addon.isin(addon.units, value.unit) and
                    value.value ~= nil)
        end,
        evaluate = function(value, cache)
            if not addon.getCached(cache, UnitExists, value.unit) then return false end
            local cur = addon.getCached(cache, UnitPower, value.unit, 3) -- Energy = Power Type 3
            if value.value < 0 then
                local max = addon.getCached(cache, UnitPowerMax, value.unit, 3)
                return addon.compare(value.operator, (max-cur), -value.value)
            else
                return addon.compare(value.operator, cur, value.value)
            end
        end,
        print = function(_, value)
            if value.value ~= nil and value.value < 0 then
                return addon.compareString(value.operator, string.format(L["%s energy defecit"], addon.nullable(addon.unitsPossessive[value.unit], L["<unit>"])), -value.value)
            else
                return addon.compareString(value.operator, string.format(L["%s energy"], addon.nullable(addon.unitsPossessive[value.unit], L["<unit>"])), addon.nullable(value.value))
            end
        end,
        widget = function(parent, spec, value)
            local top = parent:GetUserData("top")
            local root = top:GetUserData("root")
            local funcs = top:GetUserData("funcs")

            local unit = addon:Widget_UnitWidget(value, addon.units,
                function() top:SetStatusText(funcs:print(root, spec)) end)
            parent:AddChild(unit)

            local operator_group = addon:Widget_OperatorWidget(value, L["Energy"],
                function() top:SetStatusText(funcs:print(root, spec)) end)
            parent:AddChild(operator_group)
        end,
        help = function(frame)
            addon.layout_condition_unitwidget_help(frame)
            frame:AddChild(helpers.Gap())
            addon.layout_condition_operatorwidget_help(frame, L["Energy"], L["Energy"],
                "The raw energy value of " .. color.BLIZ_YELLOW .. L["Unit"] .. color.RESET .. ". " ..
                "Energy is used by Rogues, Monks, and Druids in Cat Form. " ..
                "If this number is negative, it means the energy deficit (from max energy).")
        end
    })

    addon:RegisterCondition("CHI", {
        description = L["Chi"],
        icon = "Interface\\Icons\\ability_monk_healthsphere",
        fields = { unit = "string", operator = "string", value = "number" },
        valid = function(_, value)
            return (value.operator ~= nil and addon.isin(addon.operators, value.operator) and
                    value.unit ~= nil and addon.isin(addon.units, value.unit) and
                    value.value ~= nil)
        end,
        evaluate = function(value, cache)
            if not addon.getCached(cache, UnitExists, value.unit) then return false end
            local cur = addon.getCached(cache, UnitPower, value.unit, 12) -- Chi = Power Type 12
            return addon.compare(value.operator, cur, value.value)
        end,
        print = function(_, value)
            return addon.compareString(value.operator, string.format(L["%s chi"], addon.nullable(addon.unitsPossessive[value.unit], L["<unit>"])), addon.nullable(value.value))
        end,
        widget = function(parent, spec, value)
            local top = parent:GetUserData("top")
            local root = top:GetUserData("root")
            local funcs = top:GetUserData("funcs")

            local unit = addon:Widget_UnitWidget(value, addon.units,
                function() top:SetStatusText(funcs:print(root, spec)) end)
            parent:AddChild(unit)

            local operator_group = addon:Widget_OperatorWidget(value, L["Chi"],
                function() top:SetStatusText(funcs:print(root, spec)) end)
            parent:AddChild(operator_group)
        end,
        help = function(frame)
            addon.layout_condition_unitwidget_help(frame)
            frame:AddChild(helpers.Gap())
            addon.layout_condition_operatorwidget_help(frame, L["Chi"], L["Chi"],
                "The raw chi value of " .. color.BLIZ_YELLOW .. L["Unit"] .. color.RESET .. ". " ..
                "Chi is the Monk's unique resource, typically ranging from 0 to 5.")
        end
    })
end
