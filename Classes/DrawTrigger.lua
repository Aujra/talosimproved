local tt = tt
tt.Classes.DrawTrigger = class()
local DrawTrigger = tt.Classes.DrawTrigger

function DrawTrigger:init(id, type, text, radius, arc, shape, color, tar, from)
    self.id = id
    self.type = type
    self.text = text
    self.radius = radius
    self.shape = shape
    self.color = color
    self.target =tar
    self.arc = arc
    self.from = from
end

function DrawTrigger:Draw()
    tt.draw:ClearCanvas()
    local x,y,z = nil
    if self.from == "player" then
        x,y,z = dmc.GetUnitPosition("player")
    end
    if self.from == "target" then
        x,y,z = dmc.GetUnitPosition("target")
        print("Target is at " .. x .. " " .. y .. " " .. z)
    end
    tt.draw:SetColor(self.color.r, self.color.g, self.color.b, self.color.a)
    if self.shape == "circle" then
        tt.draw:Circle(x,y,z,self.radius)
    end
    if self.shape == "cone" then
        tt.draw:Arc(x,y,z,self.radius, self.arc, 50)
    end
    if self.text ~= "" then
        tt.draw:Text(self.text,"GameFontNormal", x,y,z)
    end
end

function DrawTrigger:Clear()
    tt.draw:ClearCanvas()
end