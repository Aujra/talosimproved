tt = {}
tt.rotations = {}
tt.botbases = {}
tt.drawers = {}
tt.drawtriggers = {}
tt.Classes = {}
tt.Drawing = {}
tt.LocalPlayer = nil

tt.time = GetTime()

tt.mountID = nil

tt.running = false
tt.doDebugging = true

local lastOMUpdate = 0

tt.draw = nil
tt.scoredraw = nil
tt.bgdraw = nil
tt.areatriggerdraw = nil

tt.combatrange = 25
tt.pullrange = 35

local afkrest = 0
local inited = false

tt.AceGUI = LibStub and LibStub("AceGUI-3.0", true)

tt.frame = CreateFrame("Frame", "bro", UIParent)
tt.frame:SetScript("OnUpdate", function(self, elapsed)
    if not inited then
        tt:Init()
    end
    if GetTime() - afkrest > 30 then
        afkrest = GetTime()
        ResetAfk()
    end

    if tt.draw == nil then
        tt.draw = Draw:New()
    end
    if tt.scoredraw == nil then
        tt.scoredraw = Draw:New()
    end
    if tt.areatriggerdraw == nil then
        tt.areatriggerdraw = Draw:New()
    end

    if not tt.running then return end
    tt.time = tt.time + elapsed
    if tt.time > lastOMUpdate + .1 then
        if tt.mountID == nil then
            for i = 1, C_MountJournal.GetNumMounts(), 1 do
                local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfoByID(i)
                if isUsable and isCollected then
                    tt.mountID = i
                    break
                end
            end
        end

        tt.scoredraw:ClearCanvas()
        lastOMUpdate = tt.time
        tt:UpdateOM()
        tt:updateObjectViewer()
    end
    if tt.botbase then
        if tt.doDebugging then
            tt.botbases[tt.botbase]:Debug()
        else
            tt.draw:ClearCanvas()
            tt.scoredraw:ClearCanvas()
        end
        
        for k,v in pairs(tt.drawers) do
            v:Pulse()
        end

        tt.rotations[tt.rotation]:SetRange()
        tt.rotations[tt.rotation]:OOC()
        tt.botbases[tt.botbase]:Pulse()
    end
end)

function tt:Init()
    if dmc then
        tt.Log:Add(tt.version)
        for k,v in pairs(tt.changelog) do
        tt.Log:Add("-"..v)
end
        inited = true
    end
end

function tt:tcount(t)
    local c = 0
    for k,v in pairs(t) do
        c = c + 1
    end
    return c
end

tt.frame:SetScript("OnKeyDown", function(self, key)
    if key == "`" then
        print("Hotkey toggling bot")
        tt.running = not tt.running
        tt:UpdateHUD()
    end
    tt.frame:SetPropagateKeyboardInput(true)
end)

function tt:Cast(name, tar)
    if tar == nil then return false end
    local inrange = IsSpellInRange(name, tar.pointer)
    local usable = IsUsableSpell(name)
    local start, duration = GetSpellCooldown(name)

    if inrange == nil then inrange = 1 end

    if inrange == 1 and usable and start == 0 then
        print("Casting "..name)
        localenv["CastSpellByName"](name, tar)
        return true
    end
    return false
end

function tt:MakeTabs(container, title, tabs)
    local tabgroup = tt.AceGUI:Create("TabGroup")
    tabgroup:SetLayout("Flow")
    tabgroup:SetTabs(tabs)
    tabgroup:SetTitle(title)
    container:AddChild(tabgroup)
end