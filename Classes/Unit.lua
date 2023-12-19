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
    self.lootable = dmc.UnitIsLootable(point)
end

function Unit:Update()
    tt.Classes.GameObject.Update(self, self.pointer)
    self.Dead = localenv["UnitIsDead"](self.pointer)
    self.Health = localenv["UnitHealth"](self.pointer)
    self.HealthMax = localenv["UnitHealthMax"](self.pointer)
    self.HP = self.Health / self.HealthMax * 100
    self.attackable = localenv["UnitCanAttack"]("player", self.pointer)
    self.lootable = dmc.UnitIsLootable(self.pointer)
    self.los = self:LOS()
end

function Unit:IsCasting()
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = localenv["UnitCastingInfo"](self.pointer)
    local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = localenv["UnitChannelInfo"](self.pointer)
    if name ~= nil then
        return true
    end
    if name2 ~= nil then
        return true
    end
    return false
end

function Unit:ToTable()
    local table = {
        self.Name, string.format("%0d", self.Distance), self.score, string.format("%2d", self.NextUpdate), self.isQuest
    }
    return table
end

function Unit:HasBuff(spell, byme)
    byme = byme or false
    for i = 1, 40 do
        local name, _, count, dispelType, duration, expirationTime, unitCaster, _, _, spellId, _, _, _, _, timeMod = localenv["UnitAura"](self.pointer, i, "HELPFUL")
        if byme then
            if unitCaster == "player" and name == spell then
                return true
            end
        else
            if name == spell then
                return true
            end
        end
    end
    return false
end

function Unit:HasDebuff(spell, byme)
    for i = 1, 40 do
        local name, _, count, dispelType, duration, expirationTime, unitCaster, _, _, spellId, _, _, _, _, timeMod = localenv["UnitAura"](self.pointer, i, "HARMFUL")
        if byme then
            if unitCaster == "player" and name == spell then
                return true
            end
        else
            if name == spell then
                return true
            end
        end
    end
    return false
end

function Unit:TargetingMe()
    local target = dmc.UnitTarget(self.pointer)
    if target == tt.LocalPlayer.pointer then
        return true
    end
    return false
end