local tt = tt
tt.rotations.Hunter = class()
local Hunter = tt.rotations.Hunter

Hunter.name = "Hunter"
Hunter.class = "Hunter"

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
    tt:Cast("Fireball", tar)
end

function Hunter:Pulse(target)
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
            local hasUI, isHunterPet = HasPetUI();
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
            if not tt.LocalPlayer:HasBuff("Icy Veins") then
                tt:Cast("Icy Veins", "player")
            end
            if not tt.LocalPlayer:HasBuff("Rune of Power") then
                tt:Cast("Rune of Power", "player")
            end
            if not tt.LocalPlayer:HasBuff("Arcane Intellect") then
                tt:Cast("Arcane Intellect", "player")
            end
            if tt.LocalPlayer:HasBuff("Brain Freeze") then
                tt:Cast("Flurry", target.pointer)
            end
            if tt.LocalPlayer:HasBuff("Fingers of Frost") then
                tt:Cast("Ice Lance", target.pointer)
            end
            tt:Cast("Frozen Orb", target.pointer)
            tt:Cast("Ice Nova", target.pointer)
            tt:Cast("Frostbolt", target.pointer)
        end

        if spec == 2 then
            if target.Distance > 30 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
            end     
            if not target:HasDebuff("Hunter's Mark") then
                localenv["CastSpellByName"]("Hunter's Mark", target.pointer)
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