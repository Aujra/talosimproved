local tt = tt
tt.Classes.GameObject = class()
local GameObject = tt.Classes.GameObject

function GameObject:init(point)
    self.pointer = point
    self.Name = dmc.ObjectName(point)
    self.NextUpdate = tt.time + 1
    self.x, self.y, self.z = dmc.GetUnitPosition(point)
    self.Distance = dmc.GetDistance3D(x, y, z, self.x, self.y, self.z)
    self.score = 0
    self.radius = dmc.UnitBoundingRadius(point)
    self.NextUpdate = 0
end

function GameObject:Update(point)
    if GetTime() < self.NextUpdate then return end
    self.Name = dmc.ObjectName(self.pointer)
    local x,y,z = dmc.GetUnitPosition("player")
    self.x, self.y, self.z = dmc.GetUnitPosition(self.pointer)
    self.Distance = dmc.GetDistance3D(x, y, z, self.x, self.y, self.z)
    self.radius = dmc.ObjectField(self.pointer, 0xD7A4, 10)
    self.NextUpdate = GetTime() + self:getUpdateRate()
end

function GameObject:ToTable()
    local table = {
        self.Name, string.format("%0d", self.Distance), self.score, string.format("%2d", self.NextUpdate)
    }
    return table
end

function GameObject:getUpdateRate()
    if self.Distance == nil then return 0 end
    if self.Distance < 50 then
        return 0.2
    end
    if self.Distance < 150 then
        return 1
    end
    return 2.5
end

function GameObject:HasPath()
    local x,y,z = dmc.GetUnitPosition("player")
    local mapId = dmc.GetMapID()
    local PathCnt = dmc.FindPath(mapId, self.x, self.y, self.z, x, y, z, true )
    if PathCnt == 0 then 
        return false
    else
        return true
    end
end


function GameObject:LOS()
    local x,y,z = dmc.GetUnitPosition("player")
    local hit = dmc.TraceLine(x,y,z,self.x,self.y,self.z, 0x10)
    if hit == 0 then
        return true
    end
    return false
end

function GameObject:GetEnemiesAround(range)
    local count = 0
    for k,v in pairs(tt.players) do
        if dmc.GetDistance3D(self.x, self.y, self.z, v.x, v.y, v.z) < range and v.Reaction <= 3 and not v.Dead then
            count = count + 1
        end
    end
    return count
end

function GameObject:GetFriendsAround(range)
    local count = 0
    for k,v in pairs(tt.players) do
        if dmc.GetDistance3D(self.x, self.y, self.z, v.x, v.y, v.z) < range and v.Reaction > 4 and not v.Dead then
            count = count + 1
        end
    end
    return count
end

function GameObject:DistanceFrom(object)
    return dmc.GetDistance3D(self.x, self.y, self.z, object.x, object.y, object.z)
end