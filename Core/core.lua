tt = {}
tt.rotations = {}
tt.botbases = {}
tt.Classes = {}

tt.time = GetTime()

local lastOMUpdate = 0

setfenv(1, localenv)

local AceGUI = LibStub and LibStub("AceGUI-3.0", true)

tt.frame = CreateFrame("Frame", "bro", UIParent)
tt.frame:SetScript("OnUpdate", function(self, elapsed)
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