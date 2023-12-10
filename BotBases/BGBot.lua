local tt = tt
tt.botbases.BGBot = class()
local BGBot = tt.botbases.BGBot

BGBot.name = "BGBot"
BGBot.allowMovement = true

function BGBot:init()
    self.allowMovement = true
end

local acceptedtime = 0
local lastupdate = 0
local lasttargetupdate = 0

tt.movespot = {
}
tt.badspot = {
}

tt.bestmove = nil
tt.besttarget = nil

local bestmove = nil
local besttarget = nil

tt.bgdraw = dmc.Draw:New()

tt.PVPMoveScores = {}
tt.PVPTargetScores = {}

local spot = tt.Classes.Spot(628.09710693359, 230.25869750977, 328.99182128906, 727, 675.06805419922, 222.31399536133, 319.90646362305)
local spots = tt.Classes.Spot(1816.8699951172, 160.08299255371, 1.8064399957657, 726, 1812.6453857422, 200.64604187012, -20.939380645752)
local spot2 = tt.Classes.Spot(1061.9154052734, 1378.19140625, 328.5080871582, 726, 1090.0329589844, 1397.9826660156, 319.44784545898)
tinsert(tt.movespot, spot)
tinsert(tt.movespot, spots)
tinsert(tt.movespot, spot2)

local bspot = tt.Classes.Spot(1803.0208740234, 1539.9670410156, 1249.1867675781, 566, 671.68951416016, 222.47822570801, 320.1237487793)
tinsert(tt.badspot, bspot)

function BGBot:Pulse()
    self:BuildMoveScores()
    self:BuildTargetScores()

    tt.LocalPlayer:HasBuff("Regrowth")

    if not UnitInBattleground("player") then
        if HonorFrameQueueButton == nil or not HonorFrameQueueButton:IsVisible() and GetBattlefieldStatus(1) ~= "queued" then
          TogglePVPUI()
        end
        if GetBattlefieldStatus(1) ~= "queued" and GetBattlefieldStatus(1) ~= "confirm" then
            localenv["RunMacroText"]("/click HonorFrameQueueButton")
            tt:SetStatusText("Queueing for BG")
        end
        if GetBattlefieldStatus(1) == "queued" then
            tt:SetStatusText("Waiting for BG to pop currently waited " .. tt:ConvertToMS(GetBattlefieldTimeWaited(1)))
            if PVPQueueFrame ~= nil and PVPQueueFrame:IsVisible() then
                TogglePVPUI()
            end
        end                                                 
        if GetBattlefieldStatus(1) == "confirm" then             
          localenv["AcceptBattlefieldPort"](1, true)
          tt:SetStatusText("Accepting BG")
        end
    else
        local role = UnitGroupRolesAssigned("player")

        self:BuildMoveScores()
        self:BuildTargetScores()

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

          if TimerTrackerTimer1 ~= nil and TimerTrackerTimer1.barShowing then
            tt:SetStatusText("Waiting for BG to start")
            return
        end

        --off boat
        local point = dmc.ObjectMover('player')
        if point ~= nil then
            tt:SetStatusText("Moving off boat")
            localenv["MoveForwardStart"]()
            local x, y, z = dmc.GetUnitPosition("player")
            local px, py, pz = 5,31,34
            local dx, dy, dz = x-px, y-py, z-pz
            local radians = math.atan2(-dy, -dx)
            if dmc.GetDistance3D(x,y,z, px, py, pz) < 10 then
                return
            end
            dmc.FaceDirection(radians, false)
            return
        end

        if self:InMoveSpot() then
            print("in move spot")
            return
        end

        for k,v in pairs(tt.PVPMoveScores) do
            if v.player:HasPath() and v.player.Distance ~= nil then
                bestmove = v.player
                break
            end
        end

        for k,v in pairs(tt.PVPTargetScores) do
            if v.player:HasPath() and v.player.Distance ~= nil and v.player.Reaction <= 3 and v.player.Distance < 70 and
            not v.player:LOS() then
                besttarget = v.player
            end
        end

        besttarget = self:ClosestTarget()
        local closestheal = tt.CombatHelpers:GetClosestHeal(101, 40)

        --if role == "HEALER" then besttarget = closestheal end

        tt.besttarget = besttarget


        if besttarget ~= nil and role ~= "HEALER" then
            if besttarget.Distance < tt.pullrange then
                localenv["MoveForwardStop"]()
                tt:SetStatusText("Targeting best target " .. besttarget.Name .. " " .. besttarget.Distance)
                localenv["TargetUnit"](besttarget.pointer)
                local x, y, z = dmc.GetUnitPosition("player")
                local px, py, pz = dmc.GetUnitPosition(besttarget.pointer)
                if (px == nil) then
                    return
                end
                local dx, dy, dz = x-px, y-py, z-pz
                local radians = math.atan2(-dy, -dx)
                dmc.FaceDirection(radians, false)
                tt.rotations[tt.rotation]:Pulse(besttarget)
                return
            else
                tt:SetStatusText("Moving to best target " .. besttarget.Name .. " " .. besttarget.Distance)
                tt:NavTo(besttarget.x, besttarget.y, besttarget.z)
                return
            end
        end

        if bestmove ~= nil then
            if bestmove.Distance < tt.pullrange then
                if bestmove.Distance < (tt.pullrange - 5) then
                    localenv["MoveForwardStop"]()
                end
                if role == "HEALER" then
                    local x, y, z = dmc.GetUnitPosition("player")
                    local px, py, pz = dmc.GetUnitPosition(bestmove.pointer)
                    if (px == nil) then
                        return
                    end
                    local dx, dy, dz = x-px, y-py, z-pz
                    local radians = math.atan2(-dy, -dx)
                    dmc.FaceDirection(radians, false)
                    tt.rotations[tt.rotation]:Pulse(bestmove)
                end
                return
            else
                tt:SetStatusText("Moving to best move spot " .. bestmove.Name .. " " .. bestmove.Distance)
                tt:NavTo(bestmove.x, bestmove.y, bestmove.z)
                return
            end
        end

    end
end

function BGBot:BuildMoveScores()
    if GetTime() - lastupdate < 2.5 then
        return
    end

    for k,v in pairs(tt.PVPMoveScores) do tt.PVPMoveScores[k] = nil end

    local FriendlyScore = 4
    local EnemyScore = 2
    local role = UnitGroupRolesAssigned("player")
    if role == "HEALER" then
        FriendlyScore = 5
        EnemyScore = 2
    else
        EnemyScore = 5
        FriendlyScore = 2
    end

    for k,v in pairs(tt.players) do
        if v.pointer ~= tt.LocalPlayer.pointer and not v.Dead and dmc.ObjectExists(v.pointer) and v.Reaction >= 5 then
            local friends = v:GetFriendsAround(30)
            local enemies = v:GetEnemiesAround(30)
            local score = (1000 + (friends * FriendlyScore) + (enemies * EnemyScore)) * 15
            if v.Distance == nil then
                score = score - 100000
            else
                score = score - (v.Distance * .5)
            end

            if  (enemies / friends) > 2 then
                score = score - 5000
            end

            if localenv["UnitAffectingCombat"](v.pointer) then
                score = score + 500
            end
            v.score = score
            tinsert(tt.PVPMoveScores, {score = score, player = v})
        end
    end
    table.sort(tt.PVPMoveScores, function(x, y)
        return x.score > y.score
    end)
    lastupdate = GetTime()
end



function BGBot:BuildTargetScores()
    if GetTime() - lasttargetupdate < .5 then
        return
    end

    for k,v in pairs(tt.PVPTargetScores) do tt.PVPTargetScores[k] = nil end

    for k,v in pairs(tt.players) do
        if not v.Dead and v.Reaction <= 3 and v.Distance ~= nil and v.Distance < 60 and not v:LOS() then
            local score = 1000
            if v.Distance == nil then
                score = score - 100000
            else
                score = score - dmc.GetDistance3D("player", v.pointer)
            end
            if v:TargetingMe() then
                score = score + 100
            end
            if v.Distance ~= nil and v.Distance < 15 then
                score = score + 100000
            end
            v.targetScore = score
            tinsert(tt.PVPTargetScores, {score = score, player = v})
        end
    end
    table.sort(tt.PVPTargetScores, function(x, y)
        return 
        x.score > y.score
    end)
    lasttargetupdate = GetTime()
end

function BGBot:InMoveSpot()
    local x, y, z = dmc.GetUnitPosition("player")
    for k,v in pairs(tt.movespot) do
        if dmc.GetDistance3D(x,y,z,v.x,v.y,v.z) < 35 then
            local px, py, pz = v.facex, v.facey, v.facez
            local dx, dy, dz = x-px, y-py, z-pz
            local radians = math.atan2(-dy, -dx)
            localenv["MoveForwardStart"]()
            return true
        end
    end
    return false
end

function BGBot:IsInSpawn(x,y,z)
    for k,v in pairs(tt.badspot) do
        if dmc.GetDistance3D(x,y,z,v.x,v.y,v.z) < 35 then
            print("in bad spot not going here")
            return true
        end
    end
    return false
end

function tt:ConvertToMS(milliseconds)
    local totalSeconds = milliseconds / 1000
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds - (minutes * 60)
    return string.format("%02d:%02d", minutes, seconds)
end

function BGBot:ClosestTarget()
    local closest = nil
    local closestdist = 999999
    for k,v in pairs(tt.players) do
        if v.pointer ~= "player" then
            if v.Distance ~= nil and dmc.GetDistance3D("player", v.pointer) < 150 and dmc.GetDistance3D("player", v.pointer) < closestdist and v.Reaction <= 3 and not v.Dead then
            --and not v.LOS() then
                closestdist = v.Distance
                closest = v
            end
        end
    end
    return closest
end

function BGBot:Debug()
    tt.draw:ClearCanvas()
    tt.draw:SetColor(0,255,0)
    local x,y,z = dmc.GetUnitPosition("player")
    if besttarget ~= nil then
        tt.draw:SetColor(255,0,0)
        tt.draw:Line(besttarget.x, besttarget.y, besttarget.z, x,y,z, true )
    end
    if bestmove ~= nil then
        tt.draw:SetColor(0,255,0)
        tt.draw:Line(bestmove.x, bestmove.y, bestmove.z, x,y,z, true )
    end
end

tt:RegisterBotBase(BGBot.name, BGBot)