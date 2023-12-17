local tt = tt
tt.rotations.BaseRotation = class()
local BaseRotation = tt.rotations.BaseRotation

BaseRotation.skip = true
BaseRotation.name = "skip"

function BaseRotation:init()
end

function BaseRotation:OOC()
end

function BaseRotation:Pulse(target)
    if not tt.botbases[tt.botbase].allowMovement then
        return
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

    if target.Distance > tt.combatrange then
        tt:SetStatusText("Moving to target");
        tt:NavTo(target.x, target.y, target.z, true)
    else
        C_Timer.After(0.5, function() localenv["MoveForwardStop"]() end)
    end
end

function BaseRotation:NormalizeTarget(target)
    if type(target) == "string" then
        target = tt:GetObjectByGUID(target)
    end
    return target
end
