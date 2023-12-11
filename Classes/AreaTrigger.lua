local tt = tt
tt.Classes.AreaTrigger = class()
local AreaTrigger = tt.Classes.AreaTrigger

function AreaTrigger:init(pointer)
    self.pointer = pointer
    self.name = dmc.ObjectName(pointer)
    self.gotype = dmc.GameObjectType(pointer)
    self.x, self.y, self.z = dmc.GetUnitPosition(pointer)
    self.radius = dmc.ObjectField(pointer, 0xD7A4, 10)
    self.createdBy = dmc.UnitCreatedBy(pointer)
end

function AreaTrigger:Update()
    self.x, self.y, self.z = dmc.GetUnitPosition(self.pointer)
    self.name = dmc.ObjectName(self.pointer)
    self.gotype = dmc.GameObjectType(self.pointer)
    self.x, self.y, self.z = dmc.GetUnitPosition(self.pointer)
    self.radius = dmc.ObjectField(self.pointer, 0xD7A4, 10)
    self.flags = dmc.UnitDynamicFlags(self.pointer)
end