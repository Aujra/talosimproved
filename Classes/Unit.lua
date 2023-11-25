local tt = tt
tt.Classes.Unit = tt.Classes.GameObject:extend()
local Unit = tt.Classes.Unit

function Unit:init(point)
    tt.Classes.GameObject.init(self, point)
    self.Reaction = localenv["UnitReaction"](point, "player")
    self.HP = localenv["UnitHealth"](point) / localenv["UnitHealthMax"](point) * 100
end

function Unit:Update()
    tt.Classes.GameObject.Update(self, point)
end
