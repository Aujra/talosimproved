local tt = tt
tt.rotations.Priest = class()
local Priest = tt.rotations.Priest

Priest.name = "Priest"
Priest.class = "Priest"

function Priest:init()
end

function Priest:SetRange()
    tt.combatrange = 35
    tt.pullrange = 35
end

function Priest:OOC()
    if not tt.LocalPlayer:HasBuff("Power Word: Fortitude") then
        tt:Cast("Power Word: Fortitude", "player")
    end
end

function Priest:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        tt.rotations.BaseRotation:Pulse(target)
        target = tt.rotations.BaseRotation:NormalizeTarget(target)       
        local caster = tt.CombatHelpers:GetClosestCaster(30)
        if spec == 1 then
            local lowest = tt.CombatHelpers:LowestFriend()
            if lowest ~= nil then
                if lowest.HP < 90 and not lowest:HasBuff("Power Word: Shield") then
                    tt:Cast("Power Word: Shield", lowest.pointer)
                end
                if lowest.HP < 85 and not lowest:HasBuff("Atonement") then
                    tt:Cast("Power Word: Radiance", lowest.pointer)
                end
                if lowest.HP < 80 and not lowest:HasBuff("Renew") then
                    tt:Cast("Renew", lowest.pointer)
                end
            end
            tt:Cast("Mind Blast", target.pointer)
            tt:Cast("Penance", target.pointer)
            tt:Cast("Smite", target.pointer)
        end

        if spec == 3 then   
            if caster ~= nil then
                tt:Cast("Silence", caster.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Shadowform") then
                localenv["CastSpellByName"]("Shadowform")
            end
            if not tt.LocalPlayer:HasBuff("Vampiric Embrace") then
                localenv["CastSpellByName"]("Vampiric Embrace")
            end
            if not target:HasDebuff("Vampiric Touch") then
                localenv["CastSpellByName"]("Vampiric Touch", target.pointer)
            end
            if not target:HasDebuff("Shadow Word: Pain") then
                localenv["CastSpellByName"]("Shadow Word: Pain", target.pointer)
            end
            if not target:HasDebuff("Devouring Plague") then
                localenv["CastSpellByName"]("Devouring Plague", target.pointer)
            end
            localenv["CastSpellByName"]("Mind Blast", target.pointer)
            localenv["CastSpellByName"]("Mind Flay", target.pointer)
        end

        if spec == 2 then
            local lowest = tt.CombatHelpers:LowestFriend()
            if lowest ~= nil then
                if lowest.HP < 90 then
                    tt:Cast("Prayer of Mending", lowest.pointer)
                end
                if lowest.HP < 80 and not lowest:HasBuff("Renew") then
                    tt:Cast("Renew", lowest.pointer)
                end
                if lowest.HP < 60 then
                    tt:Cast("Flash Heal", lowest.pointer)
                end
            end
            tt:Cast("Holy Fire", target.pointer)
            tt:Cast("Smite", target.pointer)
        end
    end
end

tt:RegisterRotation(Priest.name, Priest)