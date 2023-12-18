local tt = tt
tt.rotations.Hunter = tt.rotations.BaseRotation:extend()
local Hunter = tt.rotations.Hunter

Hunter.name = "Hunter"
Hunter.class = "Hunter"
Hunter.skip = false

function Hunter:init()
end

function Hunter:SetRange()
    tt.combatrange = 35
    tt.pullrange = 35
end

function Hunter:Pull()
    if localenv["UnitAffectingCombat"]("player") then
        return self:Pulse()
    end
end

function Hunter:OOC()
    if tt.LocalPlayer.pet == false then
        localenv["CastSpellByName"]("Call Pet 1")
    end
end

function Hunter:Pulse(target)
    local spec = GetSpecialization()

    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then
        return
    end

    tt.rotations.BaseRotation:Pulse(target)
    target = tt.rotations.BaseRotation:NormalizeTarget(target)

    if target ~= nil then
        local caster = tt.CombatHelpers:GetClosestCaster(30)

        if caster ~= nil then
            tt:Cast("Counter Shot", caster.pointer)
        end

        if spec == 1 then             
            localenv["CastSpellByName"]("Kill Command")
            localenv["CastSpellByName"]("Bestial Wrath")
            localenv["CastSpellByName"]("Cobra Shot")
            localenv["CastSpellByName"]("Barbed Shot")
        end

        if spec == 3 then
            tt:Cast("Harpoon", target.pointer)
            tt:Cast("Kill Command", target.pointer)
            tt:Cast("Wildfire Bomb", target.pointer)
            tt:Cast("Raptor Strike", target.pointer)
        end

        if spec == 2 then  
            local caster = tt.CombatHelpers:GetClosestCaster(30)
            if caster ~= nil then
                tt:Cast("Counter Shot", caster.pointer)
            end
            if not target:HasDebuff("Hunter's Mark") then
                localenv["CastSpellByName"]("Hunter's Mark", target.pointer)
            end

            if tt.LocalPlayer.HP < 50 then
                localenv["CastSpellByName"]("Exhilaration")
            end

            localenv["CastSpellByName"]("Kill Shot")
            localenv["CastSpellByName"]("Rapid Fire")
            if tt.LocalPlayer:HasBuff("Precise Shots") then
                localenv["CastSpellByName"]("Multi-Shot", target.pointer)
            end
            localenv["CastSpellByName"]("Aimed Shot", target.pointer)
            localenv["CastSpellByName"]("Steady Shot", target.pointer)
        end
    end
end

tt:RegisterRotation(Hunter.name, Hunter)