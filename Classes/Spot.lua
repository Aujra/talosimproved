local tt = tt
tt.Classes.Spot = class()
local Spot = tt.Classes.Spot

function Spot:init(x,y,z,mapID, facex, facey, facez)
    self.x = x
    self.y = y
    self.z = z
    self.mapID = mapID
    self.facex = facex
    self.facey = facey
    self.facez = facez
end