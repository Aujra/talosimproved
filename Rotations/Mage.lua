local tt = tt
tt.rotations.Mage = class()
local Mage = tt.rotations.Mage

Mage.name = "Mage"

function Mage:init()
end

function Mage:Pull()
    if localenv["UnitAffectingCombat"]("player") then
        return self:Pulse()
    end
    tt:Cast("Fireball", tar)
end

function Mage:Pulse()
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

        tt:Cast("Combustion", tar)
        if self:HasBuff("Hot Streak!", tt.LocalPlayer.pointer) then
            tt:Cast("Pyroblast", tar)
        end
        if self:HasBuff("Heating Up") then
            tt:Cast("Fire Blast", tar)
        end
        tt:Cast("Fireball", tar)
    end
end

function Mage:HasBuff(spell, target)
    if target == nil then
        target = tt.LocalPlayer.pointer
    end
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellid = localenv["UnitBuff"](target, i)
        if name == spell then
            return true
        end
    end
end

function Mage:HasDebuff(spell, target)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellid = localenv["UnitDebuff"](target, i)
        if name == spell then
            return true
        end
    end
end

tt:RegisterRotation(Mage.name, Mage)