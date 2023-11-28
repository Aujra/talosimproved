local tt = tt
tt.Classes.Unit = tt.Classes.GameObject:extend()
local Unit = tt.Classes.Unit

function Unit:init(point)
    tt.Classes.GameObject.init(self, point)
    self.Reaction = localenv["UnitReaction"]("player", point)
    self.HP = localenv["UnitHealth"](point) / localenv["UnitHealthMax"](point) * 100
    self.Health = localenv["UnitHealth"](point)
    self.HealthMax = localenv["UnitHealthMax"](point)
    self.lastupdate = 0
    self.EnemiesAround = 0
    self.FriendsAround = 0
    self.Dead = localenv["UnitIsDead"](self.pointer)
    self.targetScore = 0
    self.attackable = localenv["UnitCanAttack"]("player", point)
    self.LOS = false
end

function Unit:Update()
    tt.Classes.GameObject.Update(self, self.pointer)
    self.score = self:GetScore()
    self.Dead = localenv["UnitIsDead"](self.pointer)
    self.Health = localenv["UnitHealth"](self.pointer)
    self.HealthMax = localenv["UnitHealthMax"](self.pointer)
    self.FriendsAround = tt.botbases.BGBot:FriendsAround(60)
    self.EnemiesAround = tt.botbases.BGBot:EnemiesAround(60)
    self.attackable = localenv["UnitCanAttack"]("player", self.pointer)
    self.LOS = self:LOS()
end

function Unit:LOS()
    local x,y,z = dmc.GetUnitPosition("player")
    local x2,y2,z2 = dmc.GetUnitPosition(self.pointer)
    local hit = dmc.TraceLine(x,y,z,x2,y2,z2, 0x10)
    if hit == 0 then
        return true
    end
    return false
end

function Unit:GetScore()
    if tt.time - self.lastupdate < 5 then
        return self.score
    end
    local score = 2000
    score = score - self.Distance * 10
    local role = GetSpecializationRole(GetSpecialization())
    local FriendlyScore = 1
    local HostileScore = 1
    if role == "HEALER" then
        FriendlyScore = 5
        HostileScore = 2
    else
        HostileScore = 2
        FriendlyScore = 4
    end


    score = score 
    return score
end

function Unit:HasBuff(spell)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellid = localenv["UnitBuff"](self.pointer, i)
        if name == spell then
            return true
        end
    end
end

function Unit:HasDebuff(spell)
    for i = 1, 40 do
        local name, _, _, _, _, _, _, _, _, spellid = localenv["UnitDebuff"](self.pointer, i)
        if name == spell then
            return true
        end
    end
end

function Unit:TargetingMe()
    local target = dmc.UnitTarget(self.pointer)
    if target == tt.LocalPlayer.pointer then
        return true
    end
    return false
end