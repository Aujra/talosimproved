local tt = tt

function tt:RegisterBotBase(name, base)
    tt.botbases[name] = base
end

function tt:RegisterRotation(name, rotation)
    tt.rotations[name] = rotation
end

function tt:getBotBaseIndex(name)
    local i = 1
    for k,v in pairs(tt.botbases) do
        if k == name then
            return i
        end
        i = i + 1
    end
end
function tt:getRotationIndex(name)
    local i = 1
    for k,v in pairs(tt.rotations) do
        if k == name then
            return i
        end
        i = i + 1
    end
end