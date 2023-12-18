local tt = tt
tt.rotations.DeathKnight = tt.rotations.BaseRotation:extend()
local DeathKnight = tt.rotations.DeathKnight

DeathKnight.name = "DeathKnight"
DeathKnight.class = "Death Knight"

function DeathKnight:init()
end

function DeathKnight:SetRange()
    tt.combatrange = 5
    tt.pullrange = 25
end

function DeathKnight:OOC()

end

function DeathKnight:Pulse(target)
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
            if caster ~= nil then
                tt:Cast("Asphyxiate", caster.pointer)
                tt:Cast("Mind Freeze", caster.pointer)
            end          
            if not tt.LocalPlayer:HasBuff("Bone Shield") then
                tt:Cast("Marrowrend", target.pointer)
            end
            if tt.LocalPlayer.HP < 40 then
                tt:Cast("Unbound Fortitude", "player")
            end
            if tt.LocalPlayer.HP < 60 then
                tt:Cast("Dancing Rune Weapon", "player")
            end
            if tt.LocalPlayer.HP < 80 then
                tt:Cast("Vampiric Blood", "player")
            end
            if tt.LocalPlayer.HP < 85 then
                tt:Cast("Death Strike", "player")
            end
            tt:Cast("Blood Boil", target.pointer)
        end

        if spec == 3 then
            if not target:HasDebuff("Virulent Plague") then
                tt:Cast("Outbreak", target.pointer)
            end
            if tt.LocalPlayer.HP < 40 then
                tt:Cast("Unbound Fortitude", "player")
            end
            if tt.LocalPlayer.HP < 60 then
                tt:Cast("Dancing Rune Weapon", "player")
            end
            if tt.LocalPlayer.HP < 80 then
                tt:Cast("Vampiric Blood", "player")
            end
            if tt.LocalPlayer.HP < 85 then
                tt:Cast("Death Strike", "player")
            end
            if tt.LocalPlayer:HasBuff("Sudden Doom") then
                tt:Cast("Death Coil", target.pointer)
            end
            if tt.LocalPlayer:HasBuff("Dark Succor") then
                tt:Cast("Death Strike", target.pointer)
            end
            tt:Cast("Scourge Strike", target.pointer)
        end

        if spec == 2 then
            if  tt.LocalPlayer:HasBuff("Rime") then
                tt:Cast("Howling Blast", target.pointer)
            end
            
            if IsUsableSpell("Frost Strike") and tt.LocalPlayer.power > 90 then
                tt:Cast("Frost Strike", target.pointer)
            end
            
            if IsUsableSpell("Obliterate") and tt.LocalPlayer:HasBuff("Killing Machine") then
                tt:Cast("Obliterate", target.pointer)
            end            
            
            if IsUsableSpell("Frost Strike") and tt.LocalPlayer.power > 70 then
                tt:Cast("Frost Strike", target.pointer)
            end
            
            if IsUsableSpell("Obliterate") then
                tt:Cast("Obliterate", target.pointer)
            end
            
            if IsUsableSpell("Frost Strike") then
                tt:Cast("Frost Strike", target.pointer)
            end
        end
    end
end

tt:RegisterRotation(DeathKnight.name, DeathKnight)