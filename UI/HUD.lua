local tt = tt
tt.HUD = {}
local HUD = tt.HUD
local HUDFrame = HUD.Frames

local green ="|cFF00FF00"
local red ="|cffff0000"
local white ="|cffffffff"

function HUD:CreateHUDFrame(name, width, offset, rel, heightoff)
    print("CreateHUDFrame", name, width, offset, rel, heightoff)
    heightoff = heightoff and heightoff or 15
    local f = CreateFrame("BUTTON", name, HUDFrame)
    f:SetNormalFontObject(GameFontNormalSmall)
    f:SetHighlightFontObject(GameFontHighlightSmall)
    f:SetWidth(width)
    f:SetHeight(30)
    f:SetPoint("TOP", HUDFrame, rel, offset, heightoff)
    return f
end

HUDFrame = CreateFrame("Frame", nil, UIParent)
HUDFrame:SetWidth(UIParent:GetWidth()/2)
HUDFrame:SetHeight(20)
HUDFrame:SetPoint("TOP", UIParent, "TOP", 0, 0)

HUDFrame.tex = HUDFrame:CreateTexture()
HUDFrame.tex:SetAllPoints(HUDFrame)
HUDFrame.tex:SetTexture("Interface/Tooltips/UI-Tooltip-Background")

HUDFrame.Running = HUD:CreateHUDFrame("Running", 100, 50, "LEFT")
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

