local tt = tt
tt.rotations.Warlock = tt.rotations.BaseRotation:extend()
local Warlock = tt.rotations.Warlock

Warlock.name = "Warlock"
Warlock.class = "Warlock"

function Warlock:init()
end

function Warlock:SetRange()
    tt.combatrange = 35
    tt.pullrange = 35
end

function Warlock:OOC()
    if not tt.LocalPlayer.pet then
        tt:Cast("Summon Felhunter", "player")
    end
end

function Warlock:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        tt.rotations.BaseRotation:Pulse(target)
        target = tt.rotations.BaseRotation:NormalizeTarget(target)

        local caster = tt.CombatHelpers:GetClosestCaster(30)

        if caster ~= nil then
        end

        if spec == 1 then  
           if not target:HasDebuff("Agony") then
            tt:Cast("Agony", target.pointer)
           end
            if not target:HasDebuff("Corruption") then
            tt:Cast("Corruption", target.pointer)
            end
            if not target:HasDebuff("Unstable Affliction") then
            tt:Cast("Unstable Affliction", target.pointer)
            end
            tt:Cast("Drain Life", target.pointer)
        end

        if spec == 3 then
              if not target:HasDebuff("Immolate") then
                tt:Cast("Immolate", target.pointer)
              end
              tt:Cast("Chaos Bolt", target.pointer)
              tt:Cast("Conflagrate", target.pointer)
              tt:Cast("Incinerate", target.pointer)
        end

        if spec == 2 then
           if not target:HasDebuff("Corruption") then
            tt:Cast("Corruption", target.pointer)
           end
           tt:Cast("Hand of Gul'dan", target.pointer)
           tt:Cast("Demonbolt", target.pointer)
        end
    end
end

tt:RegisterRotation(Warlock.name, Warlock)