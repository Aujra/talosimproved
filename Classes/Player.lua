local tt = tt
tt.Classes.Player = tt.Classes.Unit:extend()
local Player = tt.Classes.Player

function Player:init(point)
    tt.Classes.Unit.init(self, point)
    self.power = localenv["UnitPower"](self.pointer)
    self.combo = localenv["UnitPower"](self.pointer, 4)
end

function Player:Update()
    tt.Classes.Unit.Update(self, point)
    self.power = localenv["UnitPower"](self.pointer)
    self.combo = localenv["UnitPower"](self.pointer, 4)
    self:Debug()
end

function Player:ToTable()
    local table = {
        self.Name,
        self.Distance,
        self.score,
        self.NextUpdate
    }
    return table
end

function Player:Debug()
    if tt.scoredraw == nil then
        tt.scoredraw = Draw:New()
    end
    if self.score ~= nil and self.score > 0 then
        tt.scoredraw:SetColor(0, 255, 0, 255)
        tt.scoredraw:Text(self.Name.." "..string.format("%0d",self.HP), "GameFontNormal", self.x, self.y, self.z+5)
    end
    if self.targetScore ~= nil and self.targetScore > 0 then
        tt.scoredraw:SetColor(255, 0, 0, 255)
        tt.scoredraw:Text(self.Name.." "..string.format("%0d",self.targetScore), "GameFontNormal", self.x, self.y, self.z+5)
    end
end