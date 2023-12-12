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

function Priest:Pull()
    if localenv["UnitAffectingCombat"]("player") then
        return self:Pulse()
    end
    tt:Cast("Fireball", tar)
end

function Priest:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        if type(target) == "string" then
            target = tt:GetObjectByGUID(target)
        end      

        local tarob = tt:GetObjectByGUID(target)
        local x, y, z = dmc.GetUnitPosition("player")
        local px, py, pz = dmc.GetUnitPosition(target.pointer)
        if (px == nil) then
            return
        end
        local dx, dy, dz = x-px, y-py, z-pz
        local radians = math.atan2(-dy, -dx)
        if tt.botbases[tt.botbase].allowMovement then
            dmc.FaceDirection(radians, false)
        end

        local caster = tt.CombatHelpers:GetClosestCaster(30)

        if caster ~= nil then
            tt:Cast("Counterspell", caster.pointer)
        end

        if spec == 1 then
            if target.Distance > 30 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
            end   
            local hasUI, isPriestPet = HasPetUI();
            if not hasUI then
                localenv["CastSpellByName"]("Call Pet 1")
            end
            localenv["CastSpellByName"]("Kill Command")
            localenv["CastSpellByName"]("Bestial Wrath")
            localenv["CastSpellByName"]("Cobra Shot")
            localenv["CastSpellByName"]("Barbed Shot")
        end

        if spec == 3 then
            if target.Distance > 30 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
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
            if target.Distance > 30 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
            end     
            if not target:HasDebuff("Priest's Mark") then
                localenv["CastSpellByName"]("Priest's Mark", target.pointer)
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

tt:RegisterRotation(Priest.name, Priest)