local tt = tt
tt.botbases.QuestBot = class()
local QuestBot = tt.botbases.QuestBot

QuestBot.name = "QuestBot"

QuestBot.Tank = nil
QuestBot.Target = nil
QuestBot.allowMovement = true

local closestQuest = nil

function QuestBot:init()
end

function QuestBot:Pulse()
    localenv["RunMacroText"]("/qp closest")
    local close =  TomTom:GetClosestWaypoint()
    if close ~= nil then
        local dist =  TomTom:GetDistanceToWaypoint(close)
        local angle = TomTom:GetDirectionToWaypoint(close)
        local player = dmc.UnitFacing("player")
        local destx, desty = nil, nil
        if angle ~= nil then        

            if localenv["UnitAffectingCombat"]("player") then
                tt:SetStatusText("In combat")
                local closest = self:GetClosestAttacker()
                tt.rotations[tt.rotation]:Pulse(closest)
                return
            end

            local lootable = self:GetNearestLoot()
        if lootable ~= nil and not localenv["UnitAffectingCombat"]("player") then
            tt:SetStatusText("Looting "..lootable.Name)
            tt:NavTo(lootable.x, lootable.y, lootable.z)
            if lootable.Distance < 5 then
                localenv["MoveForwardStop"]()
                dmc.Interact(lootable.pointer)
            end
            return
        end

            destx = (dist * math.cos(angle)) + tt.LocalPlayer.x
            desty = (dist * math.sin(angle)) + tt.LocalPlayer.y
            if dist > 5 then
                local flags = bit.bor(0x10, 0x100, 0x1)
                local hit,x,y,z = dmc.TraceLine(destx,desty,tt.LocalPlayer.z-1000,destx,desty,tt.LocalPlayer.z+1000,flags)
                tt:SetStatusText("Moving to quest "..dist .. " " .. hit .. " " .. x .. " " .. y .. " " .. z)
                tt:NavTo(destx,desty,z)
            else
                localenv["MoveForwardStop"]()
                local closestquestobj = self:GetClosestQuestObjective()
                if closestquestobj ~= nil then
                    tt:SetStatusText("Interacting with quest objective "..closestquestobj.Name)
                    tt:NavTo(closestquestobj.x, closestquestobj.y, closestquestobj.z)
                    if closestquestobj.Distance < 5 then
                        localenv["MoveForwardStop"]()
                        dmc.Interact(closestquestobj.pointer)
                    end     
                end           
            end
        end
    end
end

function QuestBot:GetClosestQuestObjective()
    local closest = nil
    local closestDist = 999999
    for k,v in pairs(tt.units) do
        if v.isQuest and v.Distance < 40 then
            local dist = dmc.GetDistance3D(tt.LocalPlayer.x, tt.LocalPlayer.y, tt.LocalPlayer.z, v.x, v.y, v.z)
            if dist < closestDist then
                closest = v
                closestDist = dist
            end
        end
    end
    return closest
end

function QuestBot:GetClosestAttacker()
    local closest = nil
    local closestDist = 999999
    for k,v in pairs(tt.units) do
        if v.Reaction < 4 and localenv["UnitAffectingCombat"](v.pointer) then
            local dist = dmc.GetDistance3D(tt.LocalPlayer.x, tt.LocalPlayer.y, tt.LocalPlayer.z, v.x, v.y, v.z)
            if dist < closestDist then
                closest = v
                closestDist = dist
            end
        end
    end
    return closest
end

function QuestBot:GetNearestLoot()
    local dist = 99999
    local nearest = nil
    for k,v in pairs(tt.units) do
        if v.lootable == 1 and v.Distance < 40 then
            local distance = v.Distance
            if distance < dist then
                nearest = v
                dist = distance
            end
        end
    end
    return nearest
end

function QuestBot:Debug()

end

tt:RegisterBotBase(QuestBot.name, QuestBot)