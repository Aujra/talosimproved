local tt = tt
tt.Classes.GameObject = class()
local GameObject = tt.Classes.GameObject

local pointer

function GameObject:init(point)
    self.pointer = point
    self.Name = dmc.ObjectName(point)
    self.NextUpdate = tt.time + 1
    self.x, self.y, self.z = dmc.GetUnitPosition(point)
    self.Distance = dmc.GetDistance3D(x, y, z, self.x, self.y, self.z)
    self.score = 0
end

function GameObject:Update(point)
    local x, y, z = dmc.GetUnitPosition("player")
    self.Distance = dmc.GetDistance3D(x, y, z, self.x, self.y, self.z)
end

function GameObject:GetScore()
    local score = 2000 
    self.Distance = dmc.GetDistance3D(dmc.GetUnitPosition(self.pointer), dmc.GetUnitPosition("player"))
    score = score - self.Distance
    self.score = score    
    return score
end

function GameObject:GetEnemiesAround(range)
    local count = 0
    for k,v in pairs(tt.units) do
        if v.pointer ~= self.pointer then
            if self:DistanceFrom(v) < range and v.Reaction <= 3 then
                count = count + 1
            end
        end
    end
    return count
end

function GameObject:GetFriendsAround(range)
    local count = 0
    for k,v in pairs(tt.units) do
        if v.pointer ~= self.pointer then
            if self:DistanceFrom(v) < range and v.Reaction >= 4 then
                count = count + 1
            end
        end
    end
    return count
end

function GameObject:DistanceFrom(object)
    return dmc.GetDistance3D(self.x, self.y, self.z, object.x, object.y, object.z)
end