local tt = tt
tt.rotations.Warrior = class()
local Warrior = tt.rotations.Warrior

Warrior.name = "Warrior"
Warrior.class = "Warrior"

function Warrior:init()
end

local lastmove = 0

function Warrior:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
end

function Warrior:Pull()
    if localenv["UnitAffectingCombat"]("player") then
        return self:Pulse()
    end
end

function Warrior:Pulse(target)
    local spec = GetSpecialization()
    self:SetRange()
    tt.rotations.BaseRotation:Pulse(target)

    local tar = tt.rotations.BaseRotation:NormalizeTarget(target)

    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then       
        if spec == 2 then
            tt:Cast("Charge", target.pointer)
            if not tt.LocalPlayer:HasBuff("Battle Shout") then
                tt:Cast("Battle Shout", "player")
            end
            if not target:HasDebuff("Hamstring") then
                tt:Cast("Hamstring", target.pointer)
            end
            if not target:HasDebuff("Rend") then
                tt:Cast("Rend", target.pointer)
            end
            tt:Cast("Rampage", target.pointer)
            tt:Cast("Execute", target.pointer)
            tt:Cast("Bloodthirst", target.pointer)
            tt:Cast("Raging Blow", target.pointer)

        end

        if spec == 1 then
            if not IsCurrentSpell(6603) then
                localenv["StartAttack"]()
            end

            local caster = tt.CombatHelpers:GetClosestCaster(5)
            if caster ~= nil then
                if tt:Cast("Pummel", caster.pointer) then return end
            end

            if tt:Cast("Charge", target.pointer) then return end
            if target.Distance > 20 then
                localenv["CastSpellByName"]("Heroic Leap")
                print("leaping")
                if dmc.IsSpellPending() then
                    dmc.ClickPosition(target.x, target.y, target.z)
                end
            end
            if not tt.LocalPlayer:HasBuff("Battle Shout") then
                tt:Cast("Battle Shout", "player")
            end
            if not tt.LocalPlayer:HasBuff("Enrage") then
                tt:Cast("Enrage", "player")
            end
            if not target:HasDebuff("Hamstring") then
                tt:Cast("Hamstring", target.pointer)
            end
            if not target:HasDebuff("Rend") then
                tt:Cast("Rend", target.pointer)
            end
            if tt:Cast("Warbreaker", target.pointer) then return end
            if tt:Cast("Execute", target.pointer) then return end
            if tt:Cast("Overpower", target.pointer) then return end
            if tt:Cast("Mortal Strike", target.pointer) then return end
            if tt:Cast("Slam", target.pointer) then return end
        end      
    end
end

tt:RegisterRotation(Warrior.name, Warrior)