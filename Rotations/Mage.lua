local tt = tt
tt.rotations.Mage = class()
local Mage = tt.rotations.Mage

Mage.name = "Mage"
Mage.class = "mage"

function Mage:init()
end

function Mage:SetRange()
    tt.combatrange = 35
    tt.pullrange = 35
end

function Mage:Pull()
    if localenv["UnitAffectingCombat"]("player") then
        return self:Pulse()
    end
    tt:Cast("Fireball", tar)
end

function Mage:Pulse(target)
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
            if not tt.LocalPlayer:HasBuff("Arcane Power") then
                tt:Cast("Arcane Power", "player")
            end
            if not tt.LocalPlayer:HasBuff("Rune of Power") then
                tt:Cast("Rune of Power", "player")
            end
            if not tt.LocalPlayer:HasBuff("Arcane Familiar") then
                tt:Cast("Arcane Familiar", "player")
            end
            if not tt.LocalPlayer:HasBuff("Arcane Intellect") then
                tt:Cast("Arcane Intellect", "player")
            end
            if tt.LocalPlayer:HasBuff("Clearcasting") then
                tt:Cast("Arcane Missiles", target.pointer)
            end
            if tt.LocalPlayer.arcane ~= nil and tt.LocalPlayer.arcane < 4 then
                tt:Cast("Arcane Blast", target.pointer)
            end
            if tt.LocalPlayer.arcane == 4 then
                tt:Cast("Arcane Barrage", target.pointer)
            end
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
            tt.rotations.BaseRotation:Pulse(target)
            if not tt.LocalPlayer:HasBuff("Blazing Barrier") then
                tt:Cast("Blazing Barrier", "player")
            end
            tt:Cast("Combustion", "player")
            if tt.LocalPlayer:HasBuff("Hot Streak!") then
                tt:Cast("Pyroblast", target.pointer)
            end
            if tt.LocalPlayer:HasBuff("Heating Up") then
                tt:Cast("Fire Blast", target.pointer)
            end            
            tt:Cast("Fireball", target.pointer)
        end
    end
end

tt:RegisterRotation(Mage.name, Mage)