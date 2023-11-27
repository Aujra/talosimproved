local tt = tt
tt.rotations.Druid = class()
local Druid = tt.rotations.Druid

Druid.name = "Druid"

function Druid:init()
end

function Druid:Pull()
    tt:Cast("Moonfire", "target")
end

function Druid:Pulse()
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

        if GetShapeshiftForm() ~= 4 then
            tt:Cast("Moonkin Form", "player")
        end
        if not self:HasDebuff("Moonfire", tar) then
            tt:Cast("Moonfire", tar)
        end
        if not self:HasDebuff("Sunfire", tar) then
            tt:Cast("Sunfire", tar)
        end
        tt:Cast("Convoke the Spirits", tar)
        tt:Cast("Starsurge", tar)
        tt:Cast("wrath", tar)
    end
end

function Druid:HasBuff(spell)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellid = localenv["UnitBuff"](target, i)
        if name == spell then
            return true
        end
    end
end

function Druid:HasDebuff(spell, target)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellid = localenv["UnitDebuff"](target, i)
        if name == spell then
            return true
        end
    end
end

tt:RegisterRotation(Druid.name, Druid)