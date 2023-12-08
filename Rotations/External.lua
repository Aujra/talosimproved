local tt = tt
tt.rotations.External = class()
local External = tt.rotations.External

External.name = "External"
External.class = "all"

function External:init()
end

function External:Pulse()
    return
end

tt:RegisterRotation(External.name, External)