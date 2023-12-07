local tt = tt
tt.botbases.RotationBot = class()
local RotationBot = tt.botbases.RotationBot

RotationBot.name = "RotationBot"

function RotationBot:init()
end

function RotationBot:Pulse()
    if localenv["UnitAffectingCombat"]("player") then
        tt.rotations[tt.rotation]:Pulse(dmc.UnitTarget("player"))
    end
end

function RotationBot:Debug()

end

tt:RegisterBotBase(RotationBot.name, RotationBot)