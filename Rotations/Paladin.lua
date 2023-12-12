local tt = tt
tt.rotations.Paladin = class()
local Paladin = tt.rotations.Paladin

Paladin.name = "Paladin"
Paladin.class = "paladin"

function Paladin:init()
end

function Paladin:Pull()
end

function Paladin:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
    
    if GetSpecialization() == 1 then
        tt.combatrange = 35
        tt.pullrange = 35
    end
    if GetSpecialization() == 4 then
        tt.combatrange = 35
        tt.pullrange = 35
    end
end

function Paladin:Pulse(target)
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
        dmc.FaceDirection(radians, false)

        if spec == 3 then
            if target.Distance > 5 then
                tt:NavTo(target.x, target.y, target.z)
            end     
            tt:Cast("Blade of Justice", target.pointer)
            tt:Cast("Judgment", target.pointer)
            tt:Cast("Avenge Wrath", "player")
            tt:Cast("Hammer of Wrath", target.pointer)
            tt:Cast("Templar's Verdict", target.pointer)
            tt:Cast("Crusader Strike", target.pointer)
        end

        if spec == 2 then
            if target.Distance > 5 then
                tt:NavTo(target.x, target.y, target.z)
            end     
            tt:Cast("Avenger's Shield", target.pointer)
            tt:Cast("Judgment", target.pointer)
            tt:Cast("Hammer of Wrath", target.pointer)
            tt:Cast("Consecration", target.pointer)
            tt:Cast("Holy Wrath", target.pointer)
            tt:Cast("Shield of the Righteous", target.pointer)
            tt:Cast("Hammer of the Righteous", target.pointer)
        end

        if spec == 1 then
            if target.Distance > 30 then
                tt:NavTo(target.x, target.y, target.z)
            end     
            local lowest = tt.CombatHelpers:LowestFriend()
            if lowest ~= nil then
                if lowest.HP < 50 then
                    localenv["CastSpellByName"]("Flash of Light", lowest.pointer)
                end
                if lowest.HP < 20 then
                    tt:Cast("Lay on Hands", lowest.pointer)
                end
                if lowest.HP < 80 then
                    localenv["CastSpellByName"]("Holy Light", lowest.pointer)
                end
            end
        end

    end
end

tt:RegisterRotation(Paladin.name, Paladin)