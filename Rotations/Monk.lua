local tt = tt
tt.rotations.Monk = tt.rotations.BaseRotation:extend()
local Monk = tt.rotations.Monk

Monk.name = "Monk"
Monk.class = "Monk"

function Monk:init()
end

function Monk:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
end

function Monk:Pull()
    if localenv["UnitAffectingCombat"]("player") then
        return self:Pulse()
    end
end

function Monk:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        tt.rotations.BaseRotation:Pulse(target)
        target = tt.rotations.BaseRotation:NormalizeTarget(target)
        if spec == 1 then 
            if not tt.LocalPlayer:HasBuff("Ironskin Brew") then
                tt:Cast("Ironskin Brew", "player")
            end
            if not tt.LocalPlayer:HasBuff("Stagger") then
                tt:Cast("Stagger", "player")
            end
            if not tt.LocalPlayer:HasBuff("Fortifying Brew") then
                tt:Cast("Fortifying Brew", "player")
            end
            if not tt.LocalPlayer:HasBuff("Keg Smash") then
                tt:Cast("Keg Smash", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Breath of Fire") then
                tt:Cast("Breath of Fire", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Blackout Strike") then
                tt:Cast("Blackout Strike", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Tiger Palm") then
                tt:Cast("Tiger Palm", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Rushing Jade Wind") then
                tt:Cast("Rushing Jade Wind", "player")
            end
            if not tt.LocalPlayer:HasBuff("Black Ox Brew") then
                tt:Cast("Black Ox Brew", "player")
            end
            tt:Cast("Rising Sun Kick", target.pointer)
        end

        if spec == 2 then 
            local lowest = tt.CombatHelpers:LowestFriend()
            if lowest ~= nil then
                if lowest.HealthPercent < 50 then
                    tt:Cast("Life Cocoon", lowest.pointer)
                end
                if lowest.HealthPercent < 20 then
                    tt:Cast("Revival", lowest.pointer)
                end
                if lowest.HealthPercent < 80 then
                    tt:Cast("Vivify", lowest.pointer)
                end
            end
        end

        if spec == 3 then
            localenv["CastSpellByName"]("Rising Sun Kick", target.pointer)
            localenv["CastSpellByName"]("Fists of Fury", target.pointer)
            localenv["CastSpellByName"]("Blackout Kick", target.pointer)
            localenv["CastSpellByName"]("Whirling Dragon Punch", target.pointer)
            localenv["CastSpellByName"]("Tiger Palm", target.pointer)
        end
    end
end

tt:RegisterRotation(Monk.name, Monk)