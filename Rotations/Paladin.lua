local tt = tt
tt.rotations.Paladin = class()
local Paladin = tt.rotations.Paladin

Paladin.name = "Paladin"
Paladin.class = "paladin"

function Paladin:init()
end

function Paladin:OOC()
end

function Paladin:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
    
    if GetSpecialization() == 1 then
        tt.combatrange = 35
        tt.pullrange = 35
    end
end

function Paladin:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    tt.rotations.BaseRotation:Pulse(target)
    target = tt.rotations.BaseRotation:NormalizeTarget(target)

    if target ~= nil then
        tt.rotations.BaseRotation:Pulse(target)

        if spec == 3 then   
            tt:Cast("Blade of Justice", target.pointer)
            tt:Cast("Judgment", target.pointer)
            tt:Cast("Avenge Wrath", "player")
            tt:Cast("Hammer of Wrath", target.pointer)
            tt:Cast("Templar's Verdict", target.pointer)
            tt:Cast("Crusader Strike", target.pointer)
        end

        if spec == 2 then  
            tt:Cast("Avenger's Shield", target.pointer)
            tt:Cast("Judgment", target.pointer)
            tt:Cast("Hammer of Wrath", target.pointer)
            tt:Cast("Consecration", target.pointer)
            tt:Cast("Holy Wrath", target.pointer)
            tt:Cast("Shield of the Righteous", target.pointer)
            tt:Cast("Hammer of the Righteous", target.pointer)
        end

        if spec == 1 then  
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