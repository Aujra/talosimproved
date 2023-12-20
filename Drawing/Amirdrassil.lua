local tt = tt
tt.Drawing.Amirdrassil = class()
local Amirdrassil = tt.Drawing.Amirdrassil

local triggers = {}

local draws = {
{id = 8936, type="buff", text = "This is good", rad = 6, arc=30, shape = "circle", color = {r = 0, g = 255, b = 0, a = 255}, tar = "target", from = "player"}
}

function Amirdrassil:init()

end

function Amirdrassil:Pulse()
    if dmc.GetMapID() == 1111 then
        for k,v in pairs(draws) do
            if not triggers[v.id] then
                triggers[v.id] = tt.Classes.DrawTrigger(v.id, v.type, v.text, v.rad, v.arc, v.shape, v.color, v.tar, v.from)
            end
        end

        for k,v in pairs(triggers) do
            if v.from == "player" then
                print(v.type)
                if v.type == "debuff" or v.type == "buff" then
                    if tt.LocalPlayer:HasBuffByID(v.id) then
                        v:Draw()
                    else
                        v:Clear()
                    end
                end

                if v.type == "cast" then
                    if tt.LocalPlayer:IsCasting(v.id) then
                        v:Draw()
                    else
                        v:Clear()
                    end
                end
            end            
        end
    end
end

tt:RegisterDrawer("Amirdrassil", Amirdrassil)