local tt = tt

function tt:NavTo(x,y,z)
    if UnitCastingInfo("player") ~= nil or UnitChannelInfo("player") ~= nil then
        localenv["MoveForwardStop"]()
        return
    end

    local px, py, pz = dmc.GetUnitPosition("player")
    if dmc.GetDistance3D(tt.LocalPlayer.x, tt.LocalPlayer.y, tt.LocalPlayer.z, x, y, z) > 100 and not IsMounted() and not UnitCastingInfo("player") ~= nil then
        local useDruidMount = (UnitClass("player") == "Druid" and GetShapeshiftForm() ~= 3);
        if useDruidMount then
            tt:Cast("Travel Form")
        else
            if tt.mountID ~= nil then
                localenv["MoveForwardStop"]()
                C_MountJournal.SummonByID(tt.mountID)
                return
            end
        end 
    end
    local mapId = dmc.GetMapID()
    local PathCnt = dmc.FindPath(mapId, px, py, pz, x, y, z )
    if PathCnt == 0 then 
        return 
    end
    local P2X, P2Y, P2Z = dmc.GetPathNode(2)
    if P2X == nil then
        return
    end
    local P2Dist = dmc.GetDistance3D(px, py, pz, P2X, P2Y, P2Z)
    local PathDist2 = dmc.GetDistance3D(PathX, PathY, PathZ, P2X, P2Y, P2Z)

    if P2X then
        local dx, dy, dz = px-P2X, py-P2Y, pz-P2Z
        local radians = math.atan2(-dy, -dx)
        if radians < 0 then radians = radians + math.pi * 2 end
        dmc.FaceDirection(radians, false)
        if P2Dist > .1 then
            localenv["MoveForwardStart"]()
        else
            localenv["MoveForwardStop"]()
        end
    end
end