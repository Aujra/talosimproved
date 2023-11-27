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

function GameObject:DistanceFrom(object)
    return dmc.GetDistance3D(self.x, self.y, self.z, object.x, object.y, object.z)
end