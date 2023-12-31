local tt = tt
tt.players, tt.units, tt.gameobjects, tt.areatriggers = {}, {}, {}, {}
local players, units, gameobjects = tt.players, tt.units, tt.gameobjects

function tt:FlushOM()
    self:UpdateOM()
end

function tt:UpdateOM()
    local added = {}
    for i = 1, dmc.GetObjectCount(), 1 do
        local object = dmc.GetObjectWithIndex(i)
        if object then
            table.insert(added, object)
        end
    end

    if #added > 0 then
        tt.areatriggerdraw:ClearCanvas()
        for _, v in pairs(added) do 
            if dmc.ObjectType(v) == 11 then
                if tt.areatriggers[v] then
                    --tt.areatriggers[v]:Update(v)
                else
                    --tt.areatriggers[v] = tt.Classes.AreaTrigger(v)
                end
            end
            if dmc.ObjectType(v) == 7 then
                if tt.LocalPlayer == nil then
                    tt.LocalPlayer = tt.Classes.LocalPlayer(v)
                    tt.players[v] = tt.LocalPlayer
                else
                    tt.LocalPlayer:Update(v)
                end
            end
            if dmc.ObjectType(v) == 8 then
                if tt.gameobjects[v] then
                    tt.gameobjects[v]:Update(v)
                else
                    tt.gameobjects[v] = tt.Classes.GameObject(v)
                end
            end
            if dmc.ObjectType(v) == 5 then
                if tt.units[v] then
                    tt.units[v]:Update(v)
                else
                    tt.units[v] = tt.Classes.Unit(v)
                end
            end
            if dmc.ObjectType(v) == 6 then
                if tt.players[v] then
                    tt.players[v]:Update(v)
                else
                    tt.players[v] = tt.Classes.Player(v)
                end
            end
        end
    end
    tt:ClearOldObjects()
end

function tt:GetObjectByGUID(guid)
    for k,v in pairs(tt.gameobjects) do
        if v.pointer == guid then
            return v
        end
    end
    for k,v in pairs(tt.units) do
        if v.pointer == guid then
            return v
        end
    end
    for k,v in pairs(tt.players) do
        if v.pointer == guid then
            return v
        end
    end
end

function tt:ClearOldObjects()
    for k,v in pairs(tt.areatriggers) do
        if not dmc.ObjectExists(v.pointer) then
            tt.areatriggers[k]:Destroy()
            tt.areatriggers[k] = nil
        end
        if not dmc.ObjectExists(v.pointer) then
            tt.gameobjects[k] = nil
        end
    end
    for k,v in pairs(tt.units) do
        if not dmc.ObjectExists(v.pointer) then
            tt.units[k] = nil
        end
    end
    for k,v in pairs(tt.players) do
        if not dmc.ObjectExists(v.pointer) then
            tt.players[k] = nil
        end
    end
end

