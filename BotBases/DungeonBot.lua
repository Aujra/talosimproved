local tt = tt
tt.botbases.DungeonBot = class()
local DungeonBot = tt.botbases.DungeonBot

DungeonBot.name = "DungeonBot"

function DungeonBot:init()
end

function DungeonBot:Pulse()
    if IsInInstance() then
        local enemy = self:GetNearestEnemy()
        if enemy then
            local x,y,z = dmc.GetUnitPosition("player")
            if dmc.GetDistance3D(enemy.x, enemy.y, enemy.z, x,y,z) > tt.combatrange then
                tt:NavTo(enemy.x, enemy.y, enemy.z)
                tt.rotations[tt.rotation]:Pulse()
            else
                localenv["MoveForwardStop"]()
                localenv["TargetUnit"](enemy.pointer)
                tt.rotations[tt.rotation]:Pulse()
            end
        end
    end
end

function DungeonBot:GetNearestEnemy()
    local nearest = nil
    local nearestDistance = 999999
    for k,v in pairs(tt.units) do
        if v.attackable and not v.Dead then
            local x,y,z = dmc.GetUnitPosition("player")
            local distance = dmc.GetDistance3D(v.x, v.y, v.z,x,y,z )
            if distance < nearestDistance then
                nearest = v
                nearestDistance = distance
            end
        end
    end
    return nearest
end

function DungeonBot:Debug()

end

tt:RegisterBotBase(DungeonBot.name, DungeonBot)