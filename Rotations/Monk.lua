local tt = tt
tt.rotations.Monk = class()
local Monk = tt.rotations.Monk

Monk.name = "Monk"
Monk.class = "Monk"

function Monk:init()
end

function Monk:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
end

function Monk:Pull()
    if localenv["UnitAffectingCombat"]("player") then
        return self:Pulse()
    end
end

function Monk:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        if type(target) == "string" then
            target = tt:GetObjectByGUID(target)
        end      

        local tarob = tt:GetObjectByGUID(target)
        local x, y, z = dmc.GetUnitPosition("player")
        local px, py, pz = dmc.GetUnitPosition(target.pointer)
        if (px == nil) then
            return
        end
        local dx, dy, dz = x-px, y-py, z-pz
        local radians = math.atan2(-dy, -dx)
        if tt.botbases[tt.botbase].allowMovement then
            dmc.FaceDirection(radians, false)
        end

        if spec == 1 then
            if target.Distance > 5 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
            end   
            if not tt.LocalPlayer:HasBuff("Ironskin Brew") then
                tt:Cast("Ironskin Brew", "player")
            end
            if not tt.LocalPlayer:HasBuff("Stagger") then
                tt:Cast("Stagger", "player")
            end
            if not tt.LocalPlayer:HasBuff("Fortifying Brew") then
                tt:Cast("Fortifying Brew", "player")
            end
            if not tt.LocalPlayer:HasBuff("Keg Smash") then
                tt:Cast("Keg Smash", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Breath of Fire") then
                tt:Cast("Breath of Fire", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Blackout Strike") then
                tt:Cast("Blackout Strike", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Tiger Palm") then
                tt:Cast("Tiger Palm", target.pointer)
            end
            if not tt.LocalPlayer:HasBuff("Rushing Jade Wind") then
                tt:Cast("Rushing Jade Wind", "player")
            end
            if not tt.LocalPlayer:HasBuff("Black Ox Brew") then
                tt:Cast("Black Ox Brew", "player")
            end
            tt:Cast("Rising Sun Kick", target.pointer)
        end

        if spec == 3 then
            if target.Distance > 30 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
            end     
            if not tt.LocalPlayer:HasBuff("Icy Veins") then
                tt:Cast("Icy Veins", "player")
            end
            if not tt.LocalPlayer:HasBuff("Rune of Power") then
                tt:Cast("Rune of Power", "player")
            end
            if not tt.LocalPlayer:HasBuff("Arcane Intellect") then
                tt:Cast("Arcane Intellect", "player")
            end
            if tt.LocalPlayer:HasBuff("Brain Freeze") then
                tt:Cast("Flurry", target.pointer)
            end
            if tt.LocalPlayer:HasBuff("Fingers of Frost") then
                tt:Cast("Ice Lance", target.pointer)
            end
            tt:Cast("Frozen Orb", target.pointer)
            tt:Cast("Ice Nova", target.pointer)
            tt:Cast("Frostbolt", target.pointer)
        end

        if spec == 2 then
            if target.Distance > 30 and tt.botbases[tt.botbase].allowMovement then
                tt:NavTo(target.x, target.y, target.z)
            end     
            if not tt.LocalPlayer:HasBuff("Blazing Barrier") then
                tt:Cast("Blazing Barrier", "player")
            end
            tt:Cast("Combustion", "player")
            if tt.LocalPlayer:HasBuff("Hot Streak!") then
                tt:Cast("Pyroblast", target.pointer)
            end
            if tt.LocalPlayer:HasBuff("Heating Up") then
                tt:Cast("Fire Blast", target.pointer)
            end            
            tt:Cast("Fireball", target.pointer)
        end
    end
end

tt:RegisterRotation(Monk.name, Monk)