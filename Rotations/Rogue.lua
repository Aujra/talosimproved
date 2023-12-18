local tt = tt
tt.rotations.Rogue = tt.rotations.BaseRotation:extend()
local Rogue = tt.rotations.Rogue

Rogue.name = "Rogue"
Rogue.class = "Rogue"

function Rogue:init()
end

function Rogue:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
end

function Rogue:OOC()
    if not tt.LocalPlayer:HasBuff("Deadly Poison") then
        tt:Cast("Deadly Poison", "player")
    end
end

function Rogue:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        tt.rotations.BaseRotation:Pulse(target)
        target = tt.rotations.BaseRotation:NormalizeTarget(target)

        local caster = tt.CombatHelpers:GetClosestCaster(8)

        if caster ~= nil then
            tt:Cast("Kick", caster.pointer)
        end
        local combo = tt.LocalPlayer.combo

        if spec == 1 then  
            if not tt.LocalPlayer:HasBuff("Slice and Dice") then
                tt:Cast("Slice and Dice", "player")
            end
            if combo == 5 and not target:HasDebuff("Crimson Tempest") then
                tt:Cast("Crimson Tempest", target.pointer)
            end
            if combo == 5 and target:HasDebuff("Crimson Tempest") then
                tt:Cast("Envenom", target.pointer)
            end
            if combo < 5 then
                tt:Cast("Mutilate", target.pointer)
            end
        end

        if spec == 3 then
            if not tt.LocalPlayer:HasBuff("Slice and Dice") then
                tt:Cast("Slice and Dice", "player")
            end
            if not target:HasDebuff("Rupture") then
                tt:Cast("Rupture", target.pointer)
            end
            if combo >= 5 then
                tt:Cast("Eviscerate", target.pointer)
            end
            tt:Cast("Gloomblade", target.pointer)
        end

        if spec == 2 then
            if not tt.LocalPlayer:HasBuff("Slice and Dice") then
                tt:Cast("Slice and Dice", "player")
            end
            if combo == 5 then
                tt:Cast("Between the Eyes", target.pointer)
                tt:Cast("Dispatch", target.pointer)
            end
            if combo < 5 then
                tt:Cast("Pistol Shot", target.pointer)
            end          
        end
    end
end

tt:RegisterRotation(Rogue.name, Rogue)