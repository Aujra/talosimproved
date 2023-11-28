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
for k,v in pairs(tt.botbases) do
    table.insert(botBaseNames, k)
end
for k,v in pairs(tt.rotations) do
    table.insert(rotationNames, k)
end

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
HUDFrame:SetWidth(UIParent:GetWidth()/2)
HUDFrame:SetHeight(20)
HUDFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)

HUDFrame.tex = HUDFrame:CreateTexture()
HUDFrame.tex:SetAllPoints(HUDFrame)
HUDFrame.tex:SetColorTexture(0, 0, 0, 0.9)

HUDFrame.Running = HUD:CreateHUDFrame("Running", 50, 400, "LEFT")
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

HUDFrame.Botbase = HUD:CreateHUDFrame("Botbase", 50, 50, "LEFT")
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

HUDFrame.ToggleObjectViewer = HUD:CreateHUDFrame("ObjectManager", 150, 800, "LEFT")
HUDFrame.ToggleObjectViewer:SetText("Toggle ObjectManager")
HUDFrame.ToggleObjectViewer:SetScript("OnClick", function()
    tt:ToggleObjectViewer()
end)
HUDFrame.ToggleObjectViewer:Show()

HUDFrame.ToggleDebug = HUD:CreateHUDFrame("ToggleDebug", 150, 600, "LEFT")
HUDFrame.ToggleDebug:SetText("Toggle Debugging")
HUDFrame.ToggleDebug:SetScript("OnClick", function()
    if tt.doDebugging then
        tt.doDebugging = false
    else
        tt.doDebugging = true
    end
    print("Debugging is now", tt.doDebugging)
end)
HUDFrame.ToggleDebug:Show()

HUDFrame.MoveSpot = HUD:CreateHUDFrame("MoveSpot", 150, -150, "CENTER", -100)
HUDFrame.MoveSpot:SetText("Mark Move Spot")
HUDFrame.MoveSpot:SetScript("OnClick", function()
    local x, y, z = dmc.GetUnitPosition("player")
    tt.movespot[x] = tt.Classes.Spot(x,y,z,dmc.GetMapID())
end)
HUDFrame.MoveSpot:Show()

HUDFrame.BadSpot = HUD:CreateHUDFrame("BadSpot", 150, -50, "CENTER", -100)
HUDFrame.BadSpot:SetText("Mark Bad Spot")
HUDFrame.BadSpot:SetScript("OnClick", function()
    print(dmc.GetMapID())
    print(dmc.GetUnitPosition("player"))
end)
HUDFrame.BadSpot:Show()

HUDFrame.ShowSpots = HUD:CreateHUDFrame("ShowSpots", 150, 50, "CENTER", -100)
HUDFrame.ShowSpots:SetText("Show Spots")
HUDFrame.ShowSpots:SetScript("OnClick", function()
    
end)
HUDFrame.ShowSpots:Show()

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