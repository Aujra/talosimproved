tt = {}
tt.rotations = {}
tt.botbases = {}
tt.Classes = {}
tt.LocalPlayer = nil

tt.time = GetTime()

tt.mountID = nil

tt.running = false
tt.doDebugging = true

local lastOMUpdate = 0

tt.draw = nil
tt.scoredraw = nil
tt.bgdraw = nil

tt.combatrange = 25
tt.pullrange = 35

setfenv(1, localenv)

tt.AceGUI = LibStub and LibStub("AceGUI-3.0", true)
tt.chatcom = LibStub("AceAddon-3.0"):NewAddon("tt", "AceConsole-3.0")

tt.frame = CreateFrame("Frame", "bro", UIParent)
tt.frame:SetScript("OnUpdate", function(self, elapsed)
    if tt.draw == nil then
        tt.draw = Draw:New()
    end
    if tt.scoredraw == nil then
        tt.scoredraw = Draw:New()
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

        local missileCount = dmc.GetMissileCount()
        draw:ClearCanvas()
        draw:SetColor(0, 255, 0, 255)

        if tt.botbase then
            if tt.doDebugging then
                tt.botbases[tt.botbase]:Debug()
            else
                tt.draw:ClearCanvas()
                tt.scoredraw:ClearCanvas()
            end
            tt.rotations[tt.rotation]:SetRange()
            tt.botbases[tt.botbase]:Pulse()
        end
    end
end)

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
    print("Casting "..name)
    localenv["CastSpellByName"](name, tar)
end

function tt:MakeTabs(container, title, tabs)
    local tabgroup = tt.AceGUI:Create("TabGroup")
    tabgroup:SetLayout("Flow")
    tabgroup:SetTabs(tabs)
    tabgroup:SetTitle(title)
    container:AddChild(tabgroup)
end