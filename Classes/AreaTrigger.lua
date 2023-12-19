local tt = tt
tt.Classes.AreaTrigger = class()
local AreaTrigger = tt.Classes.AreaTrigger

local draw = nil

function AreaTrigger:init(pointer)
    self.pointer = pointer
    self.name = dmc.ObjectName(pointer)
    self.gotype = dmc.GameObjectType(pointer)
    self.x, self.y, self.z = dmc.GetUnitPosition(pointer)
    self.radius = dmc.ObjectField(pointer, 0xD7A4, 10)
    self.createdBy = dmc.UnitCreatedBy(pointer)
    self.duration = 7.2
    self.initTime = tt.time
end

function AreaTrigger:Update()
    self.x, self.y, self.z = dmc.GetUnitPosition(self.pointer)
    self.name = dmc.ObjectName(self.pointer)
    self.gotype = dmc.GameObjectType(self.pointer)
    self.x, self.y, self.z = dmc.GetUnitPosition(self.pointer)
    self.radius = 7
    self.flags = dmc.UnitDynamicFlags(self.pointer)
    self.timeleft = self.initTime + self.duration - tt.time
    self.Distance = dmc.GetDistance3D(self.x, self.y, self.z, tt.LocalPlayer.x, tt.LocalPlayer.y, tt.LocalPlayer.z)
end

function AreaTrigger:Debug()

end

function AreaTrigger:draw()
end

function AreaTrigger:Destroy()
    draw:ClearCanvas()
end