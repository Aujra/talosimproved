local tt = tt
tt.botbases.BGBot = class()
local BGBot = tt.botbases.BGBot

BGBot.name = "BGBot"

function BGBot:Pulse()
    self:GetBestMove()
    if not UnitInBattleground("player") then
        if HonorFrameQueueButton == nil or not HonorFrameQueueButton:IsVisible() and GetBattlefieldStatus(1) ~= "queued" then
          TogglePVPUI()
        end
        if GetBattlefieldStatus(1) ~= "queued" and GetBattlefieldStatus(1) ~= "confirm" then
            localenv["RunMacroText"]("/click HonorFrameQueueButton")
            tt:SetStatusText("Queueing for BG")
        end
        if GetBattlefieldStatus(1) == "confirm" then
          localenv["AcceptBattlefieldPort"](1, true)
          tt:SetStatusText("Accepting BG")
        end
        tt:SetStatusText("Waiting for BG currently waited " .. tt:ConvertToMS(GetBattlefieldTimeWaited(1)))
    else
        if GetBattlefieldWinner() then
            LeaveBattlefield()
            return
          end
        if UnitIsDeadOrGhost("player") then
            localenv["MoveForwardStop"]()
            RepopMe()
            tt:SetStatusText("Releasing and waiting to be alive")
            return
          end

        --off boat
        local point = dmc.ObjectMover('player')
        if point ~= nil then
            tt:SetStatusText("Moving off boat")
            localenv["MoveForwardStart"]()
        end

        local bestmove = self:GetBestMove()
        local closest = self:ClosestTarget()
        local besttarget = self:BestTarget()

        if besttarget ~= nil then closest = besttarget end
        if closest ~= nil then
            if dmc.GetDistance3D("player", closest.pointer) > tt.pullrange then
                tt:NavTo(dmc.GetUnitPosition(closest.pointer))
                tt.draw:ClearCanvas()
                tt.draw:SetColor(0, 255, 0, 255)
                tt.draw:Line(dmc.GetUnitPosition("player"), dmc.GetUnitPosition(closest.pointer))
                tt:SetStatusText("Moving to " .. closest.Name .. " at " .. closest.Distance .. " yards to fight")
                return
            else
                localenv["TargetUnit"](closest.pointer)
                tt:SetStatusText("Fighting in BG with " .. closest.Name .. " at " .. dmc.GetDistance3D(closest.pointer, "player") .. " yards")
                localenv["MoveForwardStop"]()
                tt.rotations[tt.rotation]:Pull()
                if dmc.GetDistance3D("player", closest.pointer) > tt.combatrange then
                    tt:NavTo(dmc.GetUnitPosition(closest.pointer))
                else
                tt.rotations[tt.rotation]:Pulse()
                return
                end
            end
        end
        if bestmove ~= nil and dmc.GetDistance3D(bestmove.pointer, "player") > tt.combatrange then
            tt:SetStatusText("Moving to " .. bestmove.Name .. " at " .. dmc.GetDistance3D(bestmove.pointer, "player") .. " yards to find a fight")
            tt:NavTo(bestmove.x, bestmove.y, bestmove.z)
            return
        else
            localenv["MoveForwardStop"]()
            return
        end
    end
    local bestmove = self:GetBestMove()
end

function tt:ConvertToMS(milliseconds)
    local totalSeconds = milliseconds / 1000
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds - (minutes * 60)
    return string.format("%02d:%02d", minutes, seconds)
end

function BGBot:GetBestMove()
    local bestmove = nil
    local bestscore = 0
    for k,v in pairs(tt.players) do
        if v.pointer ~= "player" and v.Reaction >= 4 then
                local score = 2000
                if v.Distance == nil then
                    v.Distance = 999999
                end
                if v.Name == "Unknown" then
                    v.Distance = 999999
                end
                
                local enemies = self:EnemiesAround(60)
                local friends = self:FriendsAround(60)
                local role = GetSpecializationRole(GetSpecialization())
                local FriendlyScore = 1
                local HostileScore = 1
                if role == "HEALER" then
                    FriendlyScore = 10
                    HostileScore = 5
                else
                    HostileScore = 20
                    FriendlyScore = 5
                end
            score = score + (enemies * HostileScore) + (friends * FriendlyScore)

            if (enemies * HostileScore) > ((friends * FriendlyScore) * 3.5) or (enemies < 1) then
                score = score - 1000
            end

            v.score = score
            v.EnemiesAround = enemies   
            v.FriendsAround = friends

            if (v.Distance ~= nil and v.Distance > 1000) or UnitIsDeadOrGhost(v.pointer) then
                score = 1
            end
            if v.Distance == nil then score = 1 end

            if score ~= nil and score > bestscore then
                bestscore = score
                bestmove = v
            end
        end
    end
    return bestmove
end

function BGBot:BestTarget()
    local bestmove = nil
    local bestscore = 0
    for k,v in pairs(tt.players) do
        if v.pointer ~= "player" then
            if v.Distance ~= nil and dmc.GetDistance3D("player", v.pointer) < 100 and v.Reaction <= 3 and not v.Dead then
                local score = 1000
                score = score - dmc.GetDistance3D("player", v.pointer)
                score = score + (v.Health / v.HealthMax / 5)
                if v:TargetingMe() then
                    score = score + 200
                end
                v.targetScore = score
                if score ~= nil and score > bestscore then
                    bestscore = score
                    bestmove = v
                end
            end            
        end
    end
    return bestmove
end

function BGBot:ClosestTarget()
    local closest = nil
    local closestdist = 999999
    for k,v in pairs(tt.players) do
        if v.pointer ~= "player" then
            if v.Distance ~= nil and dmc.GetDistance3D("player", v.pointer) < 70 and dmc.GetDistance3D("player", v.pointer) < closestdist and v.Reaction <= 3 and not v.Dead then
                closestdist = v.Distance
                closest = v
            end
        end
    end
    return closest
end

function BGBot:EnemiesAround(range)
    local enemies = 0
    for k,v in pairs(tt.players) do
        if v.pointer ~= "player" then
            if v.Distance ~= nil and v.Distance < range and v.Reaction <= 3 then
                enemies = enemies + 1
            end
        end
    end
    return enemies
end

function BGBot:FriendsAround(range)
    local friends = 0
    for k,v in pairs(tt.players) do
        if v.pointer ~= "player" then
            if v.Distance ~= nil and v.Distance < range and v.Reaction >= 5 then
                friends = friends + 1
            end
        end
    end
    return friends
end

function BGBot:Debug()
    if tt.draw == nil then
        tt.draw = Draw:New()
    end
    tt.draw:ClearCanvas()
    tt.draw:SetColor(0, 255, 0, 255)
    local bestmove = self:GetBestMove()
    local closest = self:ClosestTarget()
    if bestmove ~= nil then
        local x,y,z = dmc.GetUnitPosition(bestmove.pointer)
        local px,py,pz = dmc.GetUnitPosition("player")
        tt.draw:Line(px, py, pz, x, y, z,true)
    end
    if closest ~= nil then
        local x,y,z = dmc.GetUnitPosition(closest.pointer)
        local px,py,pz = dmc.GetUnitPosition("player")
        tt.draw:SetColor(255, 0, 0, 255)
        tt.draw:Line(px,py,pz,x,y,z,true)
        tt.draw:Outline(x, y, z, 5)
    end
end

tt:RegisterBotBase(BGBot.name, BGBot)