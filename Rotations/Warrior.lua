local tt = tt
tt.rotations.Warrior = class()
local Warrior = tt.rotations.Warrior

Warrior.name = "Warrior"
Warrior.class = "Warrior"

function Warrior:init()
end

function Warrior:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
end

function Warrior:Pull()
    if localenv["UnitAffectingCombat"]("player") then
        return self:Pulse()
    end
end

function Warrior:Pulse(target)
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

        if spec == 2 then
            if target.Distance > 5 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
            end
            if not tt.LocalPlayer:HasBuff("Battle Shout") then
                tt:Cast("Battle Shout", "player")
            end
            if not target:HasDebuff("Rend") then
                tt:Cast("Rend", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Enrage") then
                tt:Cast("Enrage", "player")
            end
            tt:Cast("Execute", target.pointer)
            tt:Cast("Bloodthirst", target.pointer)
            tt:Cast("Raging Blow", target.pointer)

        end

        if spec == 1 then
            if target.Distance > 5 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
            else
                --localenv["MoveForwardStop"]()
            end
            tt:Cast("Charge", target.pointer)
            if not tt.LocalPlayer:HasBuff("Battle Shout") then
                tt:Cast("Battle Shout", "player")
            end
            if not tt.LocalPlayer:HasBuff("Enrage") then
                tt:Cast("Enrage", "player")
            end
            tt:Cast("Warbreaker", target.pointer)
            tt:Cast("Execute", target.pointer)
            tt:Cast("Overpower", target.pointer)
            tt:Cast("Mortal Strike", target.pointer)
        end

        if spec == 2 then
            
        end
          
    end
end

tt:RegisterRotation(Warrior.name, Warrior)