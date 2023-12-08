local tt = tt
tt.HUD = {}
local HUD = tt.HUD
local HUDFrame = HUD.Frames

local green ="|cFF00FF00"
local red ="|cffff0000"
local white ="|cffffffff"
local botBaseIndex = 1
local botBaseNames = {}
local rotationIndex = 1
local rotationNames = {}

function HUD:CreateHUDFrame(name, width, offset, rel, heightoff)
    print("CreateHUDFrame", name, width, offset, rel, heightoff)
    heightoff = heightoff and heightoff or 10
    local f = CreateFrame("Button", name, HUDFrame)
    f:SetNormalFontObject(GameFontNormalSmall)
    f:SetHighlightFontObject(GameFontHighlightSmall)
    f:SetWidth(width)
    f:SetHeight(20)
    f:SetPoint("TOP", HUDFrame, rel, offset, heightoff)
    return f
end

HUDFrame = CreateFrame("Frame", nil, UIParent)
HUDFrame:SetWidth(UIParent:GetWidth())
HUDFrame:SetHeight(20)
HUDFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)

HUDFrame.tex = HUDFrame:CreateTexture()
HUDFrame.tex:SetAllPoints(HUDFrame)
HUDFrame.tex:SetColorTexture(0, 0, 0, 0.4)

HUDFrame.Running = HUD:CreateHUDFrame("Running", 50, 500, "LEFT")
if tt.running then
    HUDFrame.Running:SetText(green.."Running")
else
    HUDFrame.Running:SetText(red.."Stopped")
end
HUDFrame.Running:SetScript("OnClick", function(self, button, down)
    if tt.running then
        tt.running = false
        self:SetText(red.."Stopped")
    else
        tt.running = true
        self:SetText(green.."Running")
    end
end)

for k,v in pairs(tt.botbases) do
    table.insert(botBaseNames, k)
end
for k,v in pairs(tt.rotations) do
    if string.lower(v.class) == string.lower(UnitClass("player")) or v.class == "all" then
        table.insert(rotationNames, k)
    end
end

HUDFrame.Botbase = HUD:CreateHUDFrame("Botbase", 50, 100, "LEFT")
HUDFrame.Botbase:SetText(white..botBaseNames[botBaseIndex])
HUDFrame.Botbase:SetScript("OnClick", function()
    botBaseIndex = botBaseIndex + 1
    if (botBaseIndex > #botBaseNames) then
        botBaseIndex = 1
    end
    tt.botbase = botBaseNames[botBaseIndex]
    HUDFrame:Update()
end)
HUDFrame.Botbase:Show()

HUDFrame.Rotation = HUD:CreateHUDFrame("Rotation", 50, 200, "LEFT")
HUDFrame.Rotation:SetText(white..rotationNames[rotationIndex])
HUDFrame.Rotation:SetScript("OnClick", function()
    rotationIndex = rotationIndex + 1
    if (rotationIndex > #rotationNames) then
        rotationIndex = 1
    end
    tt.rotation = rotationNames[rotationIndex]
    HUDFrame:Update()
end)
HUDFrame.Botbase:Show()

HUDFrame.ToggleObjectViewer = HUD:CreateHUDFrame("ObjectManager", 150, 300, "LEFT")
HUDFrame.ToggleObjectViewer:SetText("Toggle OM")
HUDFrame.ToggleObjectViewer:SetScript("OnClick", function()
    tt:ToggleObjectViewer()
end)
HUDFrame.ToggleObjectViewer:Show()

HUDFrame.ToggleDebug = HUD:CreateHUDFrame("ToggleDebug", 150, 400, "LEFT")
HUDFrame.ToggleDebug:SetText("Toggle Debug")
HUDFrame.ToggleDebug:SetScript("OnClick", function()
    if tt.doDebugging then
        tt.doDebugging = false
    else
        tt.doDebugging = true
    end
    print("Debugging is now", tt.doDebugging)
end)


HUDFrame.StatusBarText = HUD:CreateHUDFrame("StatusText", 50, 600, "LEFT")
HUDFrame.StatusBarText:SetText("|c0000ff00Current Status")

function HUDFrame:Update()
    HUDFrame.Botbase:SetText(white..botBaseNames[botBaseIndex])
    HUDFrame.Rotation:SetText(white..rotationNames[rotationIndex])
    if tt.running then
        HUDFrame.Running:SetText(green.."Running")
    else
        HUDFrame.Running:SetText(red.."Stopped")
    end
end

function tt:UpdateHUD()
    HUDFrame:Update()
end

function tt:SetStatusText(text)
    HUDFrame.StatusBarText:SetText("|c0000ff00 Status: "..text)
end