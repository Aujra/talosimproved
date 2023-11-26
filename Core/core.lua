tt = {}
tt.rotations = {}
tt.botbases = {}
tt.Classes = {}

tt.time = GetTime()

tt.running = false

local lastOMUpdate = 0

setfenv(1, localenv)

tt.AceGUI = LibStub and LibStub("AceGUI-3.0", true)
tt.chatcom = LibStub("AceAddon-3.0"):NewAddon("tt", "AceConsole-3.0")


tt.frame = CreateFrame("Frame", "bro", UIParent)
tt.frame:SetScript("OnUpdate", function(self, elapsed)
    if not tt.running then return end
    tt.time = tt.time + elapsed
    if tt.time > lastOMUpdate + .25 then
        lastOMUpdate = tt.time
        tt:UpdateOM()
        tt:updateObjectViewer()
    end
end)

function tt:tcount(t)
    local c = 0
    for k,v in pairs(t) do
        c = c + 1
    end
    return c
end