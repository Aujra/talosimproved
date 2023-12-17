local tt = tt
tt.rotations.Druid = tt.rotations.BaseRotation:extend()
local Druid = tt.rotations.Druid

Druid.name = "Druid"
Druid.class = "druid"

local druidFrame
local lastMove = 0

local lastpulse = 0

local targetcachetime = 0

function Druid:init()
end

function Druid:OOC()
    if not tt.LocalPlayer:HasBuff("Mark of the Wild") then
        tt:Cast("Mark of the Wild", "player")
    end
end

function Druid:SetRange()
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

function Druid:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        tt.rotations.BaseRotation:Pulse(target)

        if spec == 1 then
            tt.combatrange = 30
            local caster = tt.CombatHelpers:GetClosestCaster(40)

            if caster ~= nil then
                localenv["CastSpellByName"]("Solar Beam")
            end
            
            if GetShapeshiftForm() ~= 4 then
                tt:Cast("Moonkin Form", "player")
            end

            if tt.LocalPlayer.HP < 50 then
                tt:Cast("Barkskin", "player")
            end
            if tt.LocalPlayer.HP < 40 then
                tt:Cast("Renewal", "player")
            end
            
            if not target:HasDebuff("Moonfire", target.pointer) then
                tt:Cast("Moonfire", target.pointer)
            end
            if not target:HasDebuff("Sunfire", target.pointer) then
                tt:Cast("Sunfire", target.pointer)
            end

            tt:Cast("Celestial Alignment", "player")
            tt:Cast("Convoke the Spirits", target.pointer)
            tt:Cast("Starsurge", target.pointer)
            if tt.LocalPlayer:HasBuff("Ownkin Frenzy") then
                tt:Cast("Starfire", target.pointer)
            end
            tt:Cast("Wrath", target.pointer)
        end

        if spec == 2 then
            local caster = tt.CombatHelpers:GetClosestCaster(8)
            if GetShapeshiftForm() ~= 2 then
                tt:Cast("Cat Form", "player")
            end
            if caster ~= nil then
                tt:Cast("Skull Bash", caster.pointer)
            end

            if not localenv["UnitAffectingCombat"]("player") and not tt.LocalPlayer:HasBuff("Prowl") then
                tt:Cast("Prowl", "player")
            end

            if tt.LocalPlayer:HasBuff("Predatory Swiftness") then
                tt:Cast("Regrowth", "player")
            end

            if tt.botbases[tt.botbase].allowMovement and target.Distance > 8 then
                tt:Cast("Wild Charge", target.pointer)
            end

            if tt.LocalPlayer:HasBuff("Prowl") then
                tt:Cast("Rake", target.pointer)
            end
            
            if tt.LocalPlayer.power < 40 then
                tt:Cast("Tiger's Fury", "player")
            end
            if tt.LocalPlayer:HasBuff("Tiger's Fury") then
                tt:Cast("Berserk", target.pointer)
            end
            if not target:HasDebuff("Adaptive Swarm") then
                tt:Cast("Adaptive Swarm", target.pointer)
            end
            tt:Cast("Feral Frenzy", target.pointer)
            if tt.LocalPlayer:HasBuff("Apex Predator's Craving") then
                tt:Cast("Ferocious Bite", target.pointer)
            end
            if tt.LocalPlayer.combo == 3 then
                tt:Cast("Brutal Slash", target.pointer)
            end
            if not target:HasDebuff("Rip") and tt.LocalPlayer.combo >= 5 then
                tt:Cast("Rip", target.pointer)
            end
            if tt.LocalPlayer.combo >= 5 then
                tt:Cast("Ferocious Bite", target.pointer)
            end
            if not target:HasDebuff("Rake") then
                tt:Cast("Rake", target.pointer)
            end
            tt:Cast("Shred", target)
        end

        if spec == 4 then
            local lowest = tt.CombatHelpers:LowestFriend()            
            local lbcount = tt.CombatHelpers:GetBuffCount("Lifebloom")

            if lowest ~= nil and lowest.HP > 0 then
                tt:Cast("Wild Growth", lowest.pointer)
                if lowest.HP < 95 and lbcount < 1 then
                    tt:Cast("Lifebloom", lowest.pointer)
                end
                if lowest.HP < 50 and lowest:HasBuff("Regrowth") then
                    tt:Cast("Swiftmend", lowest.pointer)
                end
                if lowest.HP < 65 then
                    tt:Cast("Regrowth", lowest.pointer)
                end
                if lowest.HP < 80 and not lowest:HasBuff("Rejuvenation") then
                    tt:Cast("Rejuvenation", lowest.pointer)
                end
            end
            if not target:HasDebuff("Moonfire", target.pointer) then
                tt:Cast("Moonfire", target.pointer)
            end
            tt:Cast("Wrath", target.pointer)
        end
    end
end

function Druid:PVPTarget()

end

function Druid:BuildConfig()
    if druidFrame == nil then
        druidFrame = tt.AceGUI:Create("Frame")
        druidFrame:SetTitle("Druid Config")
        druidFrame:SetStatusText("Druid Config")
        druidFrame:SetWidth(800)
        druidFrame:SetHeight(800)
        druidFrame:SetLayout("Flow")

        local tabgroup = tt:MakeTabs(druidFrame, "Druid Config", {{value = "Resto", text = "Resto"}, {value = "Feral", text = "Feral"}, {value = "Balance", text = "Balance"},
            {value = "Guardian", text = "Guardian"}})

    end
end

function Druid:OpenConfig()
    if druidFrame == nil then
        Druid:BuildConfig()
    end
    print("Opening Druid Config")
    druidFrame:Show()
end

tt:RegisterRotation(Druid.name, Druid)