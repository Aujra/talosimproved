local tt = tt
tt.botbases.DungeonBot = class()
local DungeonBot = tt.botbases.DungeonBot

DungeonBot.name = "DungeonBot"

DungeonBot.Tank = nil
DungeonBot.Target = nil
DungeonBot.allowMovement = true

function DungeonBot:init()
end

function DungeonBot:Pulse()
    if IsInInstance() then
        if not tt.LocalPlayer.role == "TANK" then
            local tank = self:GetTank()
            tt:SetStatusText("Finding tank")

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

            if tank ~= nil and tank.Distance > 30 then
                DungeonBot.Tank = tank
                tt:SetStatusText("Moving to tank "..tank.Name)
                tt:NavTo(tank.x, tank.y, tank.z)
            else
                localenv["MoveForwardStop"]()
                if tank ~= nil then
                    tt:SetStatusText("Assisting tank "..tank.Name)
                    localenv["AssistUnit"](tank.pointer)
                    local target = dmc.UnitTarget("player")
                    target = tt.rotations.BaseRotation:NormalizeTarget(target)
                    if target ~= nil and localenv["UnitAffectingCombat"](target.pointer) then
                        DungeonBot.Target = target
                        tt:SetStatusText("Fighting "..target.Name)
                        if target.Distance > tt.combatrange then
                            tt:NavTo(target.x, target.y, target.z)
                        else
                            tt.rotations[tt.rotation]:Pulse(target)
                        end
                    end
                end
            end
        else
            if (select(1,GetLFGQueueStats(LE_LFG_CATEGORY_LFD))) == nil then
                tt:SetStatusText("Queueing for dungeon")
                if not LFDQueueFrame:IsVisible() then
                    LFDMicroButton:Click()
                else
                    if GetLFGMode(LE_LFG_CATEGORY_LFD) ~= "queued" and GetLFGMode(LE_LFG_CATEGORY_LFD) ~= "proposal" then
                        localenv["RunMacroText"]("/click LFDQueueFrameFindGroupButton")
                    end
                end
            else
                tt:SetStatusText("Waiting for dungeon")
                if LFGDungeonReadyDialog and LFGDungeonReadyDialog:IsShown() then
                    print("time to enter")
                    localenv["RunMacroText"]("/click LFGDungeonReadyDialogEnterDungeonButton")
                end
            end
        end
    end
end

function DungeonBot:GetNearestLoot()
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

function DungeonBot:GetNearestEnemy()
    local nearest = nil
    local nearestDistance = 999999
    for k,v in pairs(tt.units) do
        if v.attackable and not v.Dead and localenv["UnitAffectingCombat"](v.pointer) then
            local x,y,z = dmc.GetUnitPosition("player")
            local distance = dmc.GetDistance3D(v.x, v.y, v.z,x,y,z )
            if distance < nearestDistance then
                nearest = v
                nearestDistance = distance
            end
        end
    end
    return nearest
end

function DungeonBot:GetTank()
    for k,v in pairs(tt.players) do
        if v.role == "TANK" then
            return v
        end
    end
    return nil
end

function DungeonBot:GetNearestEnemy()
    local nearest = nil
    local nearestDistance = 999999
    for k,v in pairs(tt.units) do
        if v.attackable and not v.Dead then
            local x,y,z = dmc.GetUnitPosition("player")
            local distance = dmc.GetDistance3D(v.x, v.y, v.z,x,y,z )
            if distance < nearestDistance then
                nearest = v
                nearestDistance = distance
            end
        end
    end
    return nearest

end

function DungeonBot:Debug()
    local tank = DungeonBot.Tank
    local target = DungeonBot.Target
    if tank ~= nil then
        tt.scoredraw:SetColor(0, 255, 0, 255)
        tt.scoredraw:Line(tank.x, tank.y, tank.z, tt.LocalPlayer.x, tt.LocalPlayer.y, tt.LocalPlayer.z)
    end
    if target then
        tt.scoredraw:SetColor(255, 0, 0, 255)
        tt.scoredraw:Line(target.x, target.y, target.z, tt.LocalPlayer.x, tt.LocalPlayer.y, tt.LocalPlayer.z)
    end
end

tt:RegisterBotBase(DungeonBot.name, DungeonBot)