local tt = tt
tt.botbases.RotationBot = class()
local RotationBot = tt.botbases.RotationBot

RotationBot.name = "RotationBot"

function RotationBot:init()
end

function RotationBot:Pulse()
    if localenv["UnitAffectingCombat"]("player") then
        print("Pulsing")
        tt.rotations[tt.rotation]:Pulse()
    end
end

function RotationBot:Debug()

end

tt:RegisterBotBase(RotationBot.name, RotationBot)