local tt = tt
tt.Classes.LocalPlayer = tt.Classes.Player:extend()
local LocalPlayer = tt.Classes.LocalPlayer

function LocalPlayer:init(point)
    tt.Classes.Player.init(self, point)
end

function LocalPlayer:Update()
    tt.Classes.Player.Update(self, point)
    self.arcane = localenv["UnitPower"]("player", 16)
end

function LocalPlayer:Debug()
end

function LocalPlayer:HasItem(name)
    
end