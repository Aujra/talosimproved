local tt = tt
tt.rotations.Shaman = tt.rotations.BaseRotation:extend()
local Shaman = tt.rotations.Shaman

Shaman.name = "Shaman"
Shaman.class = "Shaman"

function Shaman:init()
end

function Shaman:SetRange()
    tt.combatrange = 35
    tt.pullrange = 35
end

function Shaman:OOC()

end

function Shaman:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        tt.rotations.BaseRotation:Pulse(target)
        target = tt.rotations.BaseRotation:NormalizeTarget(target)

        local caster = tt.CombatHelpers:GetClosestCaster(8)

        if caster ~= nil then
        end

        if spec == 1 then  
           tt:Cast("Flame Shock", target.pointer)
           tt:Cast("Lightning Bolt", target.pointer)
        end

        if spec == 3 then
            
        end

        if spec == 2 then
          
        end
    end
end

tt:RegisterRotation(Shaman.name, Shaman)