local tt = tt
tt.CombatHelpers = {}
local CombatHelpers = tt.CombatHelpers

function CombatHelpers:GetClosestCaster(range)
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.players) do
        if v.Distance ~= nil and v.Distance < closestDistance and v.Distance < range and v.Reaction <= 3 and v:IsCasting() then
            closest = v
            closestDistance = v.Distance
        end
    end
    return closest
end

function CombatHelpers:GetDebuffCount(spellName)
    local count = 0
    for k,v in pairs(tt.players) do
        if v:HasDebuff(spellName) then
            count = count + 1
        end
    end
    return count
end

function CombatHelpers:GetBuffCount(spellName)
    local count = 0
    for k,v in pairs(tt.players) do
        if v:HasBuff(spellName) then
            count = count + 1
        end
    end
    return count
end

function CombatHelpers:BelowHealthCount(health)
    local count = 0
    for k,v in pairs(tt.players) do
        if v.HealthPercent < health then
            count = count + 1
        end
    end
    return count
end

function CombatHelpers:ClosestWithOutBuff(spellName)
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.players) do
        if v.Distance < closestDistance and v.Distance < 40 and not v:HasBuff(spellName) then
            closest = v
            closestDistance = v.Distance
        end
    end
    return closest
end

function CombatHelpers:ClosestWithBuff(spellName)
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.players) do
        if v.Distance < closestDistance and v.Distance < 40 and v:HasBuff(spellName) then
            closest = v
            closestDistance = v.Distance
        end
    end
    return closest
end

function CombatHelpers:ClosestWithDebuff(spellName)
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.players) do
        if v.Distance < closestDistance and v.Distance < 40 and v:HasDebuff(spellName) then
            closest = v
            closestDistance = v.Distance
        end
    end
    return closest
end

function CombatHelpers:ClosestWithoutDebuff(spellName)
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.players) do
        if v.Distance ~= nil and v.Distance < closestDistance and v.Distance < 40 and not v:HasDebuff(spellName) then
            closest = v
            closestDistance = v.Distance
        end
    end
    return closest
end

function CombatHelpers:LowestFriend()
    local lowest = nil
    local lowestHealth = 101
    for k,v in pairs(tt.players) do
        if v.Distance ~= nil and v.Distance < 40 and v.Reaction > 4 and v.HP < lowestHealth and not v.Dead and v.HP > 0 then
            lowest = v
            lowestHealth = v.HP
        end
    end
    return lowest
end

function CombatHelpers:CountUnderHealth(health)
    local count = 0
    for k,v in pairs(tt.players) do
        if v.Distance ~= nil and v.Distance < 40 and v.Reaction > 4 and v.HP < health and not v.Dead then
            count = count + 1
        end
    end
    return count
end

function CombatHelpers:GetClosestHeal(hp, range)
    local closest = nil
    local closestDistance = 9999
    for k,v in pairs(tt.players) do
        if v.Distance ~= nil and v.Distance < closestDistance and v.Distance < range and v.Reaction > 4 and v.HP < hp and not v.Dead then
            closest = v
            closestDistance = v.Distance
        end
    end
    return closest
end