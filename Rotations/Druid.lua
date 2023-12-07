local tt = tt
tt.rotations.Druid = class()
local Druid = tt.rotations.Druid

Druid.name = "Druid"

function Druid:init()
end

function Druid:Pull()
end

function Druid:Pulse(target)
    local spec = GetSpecialization()
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then 
        return 
    end

    if target ~= nil then
        if type(target) == "string" then
            target = tt:GetObjectByGUID(target)
        end        
        local tarob = tt:GetObjectByGUID(target)

        if spec == 1 then
            
            if target.Distance > 35 then
                tt:NavTo(target.PosX, target.PosY, target.PosZ)
            end

            local caster = tt.CombatHelpers:GetClosestCaster(40)
            if caster ~= nil then
                tt:Cast("Solar Beam", caster.pointer)
            end
            
            if GetShapeshiftForm() ~= 4 then
                tt:Cast("Moonkin Form", "player")
            end
            if not target:HasDebuff("Moonfire", target.pointer) then
                tt:Cast("Moonfire", target.pointer)
            end
            if not target:HasDebuff("Sunfire", target.pointer) then
                tt:Cast("Sunfire", target.pointer)
            end

            local moonfirecount = tt.CombatHelpers:GetDebuffCount("Moonfire")
            local sunfirecount = tt.CombatHelpers:GetDebuffCount("Sunfire")
            local closest_no_moonfire = tt.CombatHelpers:ClosestWithoutDebuff("Moonfire")

            if moonfirecount <= 1 and closest_no_moonfire ~= nil then
                tt:Cast("Moonfire", closest_no_moonfire.pointer)
            end

            tt:Cast("Celestial Alignment", "player")
            tt:Cast("Convoke the Spirits", target.pointer)
            tt:Cast("Starsurge", target.pointer)
            if tt.LocalPlayer:HasBuff("Ownkin Frenzy") then
                tt:Cast("Starfire", target.pointer)
            end
            tt:Cast("wrath", target.pointer)
        end
        if spec == 2 then
            if target.Distance > 5 then
                tt:NavTo(target.x, target.y, target.z)
            end            

            if GetShapeshiftForm() ~= 2 then
                tt:Cast("Cat Form", "player")
            end
            tt:Cast("Wild Charge", target.pointer)
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
            print("lbcount is " .. lbcount)

            if lowest ~= nil then
                print("lowest is " .. lowest.Name .. " " .. lowest.HP)
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
        end
    end
end

function Druid:PVPTarget()

end

tt:RegisterRotation(Druid.name, Druid)