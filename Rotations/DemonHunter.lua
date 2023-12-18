local tt = tt
tt.rotations.DemonHunter = tt.rotations.BaseRotation:extend()
local DemonHunter = tt.rotations.DemonHunter

DemonHunter.name = "DemonHunter"
DemonHunter.class = "Demon Hunter"

function DemonHunter:init()
end

function DemonHunter:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
end

function DemonHunter:OOC()

end

function DemonHunter:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        tt.rotations.BaseRotation:Pulse(target)
        target = tt.rotations.BaseRotation:NormalizeTarget(target)

        local caster = tt.CombatHelpers:GetClosestCaster(8)

        if caster ~= nil then
            tt:Cast("Counterspell", caster.pointer)
        end

        if spec == 1 then  
            tt:Cast("Blade Dance", target.pointer)
            tt:Cast("Eye Beam", target.pointer)
            tt:Cast("Demon's Bite", target.pointer)    
            tt:Cast("Chaos Strike", target.pointer)                                
        end

        if spec == 2 then
            if not tt.LocalPlayer:HasBuff("Demon Spikes") then
                tt:Cast("Demon Spikes", "player")
            end
            tt:Cast("Metamorphosis", "player")
            tt:Cast("Immolation Aura", target.pointer)
            tt:Cast("Soul Cleave", target.pointer)
            tt:Cast("Fracture", target.pointer)
            tt:Cast("Shear", target.pointer)
        end
    end
end

tt:RegisterRotation(DemonHunter.name, DemonHunter)