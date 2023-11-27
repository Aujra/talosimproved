local tt = tt
tt.Classes.Player = tt.Classes.Unit:extend()
local Player = tt.Classes.Player

function Player:init(point)
    tt.Classes.Unit.init(self, point)
end

function Player:Update()
    tt.Classes.Unit.Update(self, point)
    self:Debug()
end

function Player:Debug()
    if tt.scoredraw == nil then
        tt.scoredraw = Draw:New()
    end
    tt.scoredraw:SetColor(0, 255, 0, 255)
    tt.scoredraw:Text(string.format("%0d",self.score), "GameFontNormal", self.x, self.y, self.z+5)
end