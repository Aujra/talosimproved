local tt = tt
tt.rotations.Warrior = class()
local Warrior = tt.rotations.Warrior

Warrior.name = "Warrior"

function Warrior:init()
end

function Warrior:Pull()
end

function Warrior:Pulse()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
        end
    local tar = dmc.UnitTarget("player")
    if tar ~= nil then
        local x, y, z = dmc.GetUnitPosition("player")
        local px, py, pz = dmc.GetUnitPosition(tar)
        if (px == nil) then
            return
        end
        local dx, dy, dz = x-px, y-py, z-pz
        local radians = math.atan2(-dy, -dx)
        dmc.FaceDirection(radians, false)

        local tarob = tt:GetObjectByGUID(tar)

        tt:Cast("Charge", "target")

        if not self:HasDebuff("Rend", tar) then
            tt:Cast("Rend", tar)
        end
        tt:Cast("Overpower", tar)
        tt:Cast("Mortal Strike", tar)

    end
end

function Warrior:HasBuff(spell)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellid = localenv["UnitBuff"](target, i)
        if name == spell then
            return true
        end
    end
end

function Warrior:HasDebuff(spell, target)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellid = localenv["UnitDebuff"](target, i)
        if name == spell then
            return true
        end
    end
end

tt:RegisterRotation(Warrior.name, Warrior)