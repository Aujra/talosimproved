local tt = tt
tt.Classes.Player = tt.Classes.Unit:extend()
local Player = tt.Classes.Player

function Player:init(point)
    tt.Classes.Unit.init(self, point)
end

function Player:Update()
    tt.Classes.Unit.Update(self, point)
end