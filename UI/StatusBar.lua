local tt = tt
tt.StatusBar = {}
local StatusBar = tt.StatusBar
local StatusBarFrame = StatusBar.Frames

StatusBarFrame = CreateFrame("Frame", nil, UIParent)
StatusBarFrame:SetWidth(UIParent:GetWidth()/2)
StatusBarFrame:SetHeight(20)
StatusBarFrame:SetPoint("TOP", UIParent, "TOP", 0, -20)


function StatusBar:CreateHUDFrame(name, width, offset, rel, heightoff)
    print("CreateHUDFrame", name, width, offset, rel, heightoff)
    heightoff = heightoff and heightoff or 10
    local f = CreateFrame("BUTTON", name, StatusBarFrame)
    f:SetNormalFontObject(GameFontNormalSmall)
    f:SetHighlightFontObject(GameFontHighlightSmall)
    f:SetWidth(width)
    f:SetHeight(20)
    f:SetPoint("TOP", StatusBarFrame, rel, offset, heightoff)
    return f
end

function StatusBar:CreateLabel(name, width, offset, rel, heightoff)
    print("CreateHUDFrame", name, width, offset, rel, heightoff)
    heightoff = heightoff and heightoff or 10
    local f = tt.AceGUI:Create("Label")
    f:SetWidth(width)
    f:SetHeight(20)
    f:SetPoint("TOP", StatusBarFrame, rel, offset, heightoff)
    return f
end

StatusBarFrame.tex = StatusBarFrame:CreateTexture()
StatusBarFrame.tex:SetAllPoints(StatusBarFrame)
StatusBarFrame.tex:SetColorTexture(0, 0, 0, 0.9)

StatusBarFrame.StatusBarText = StatusBar:CreateHUDFrame("StatusText", 50, 0, "CENTER")
StatusBarFrame.StatusBarText:SetText("|c0000ff00Current Status")

function tt:SetStatusText(text)
    StatusBarFrame.StatusBarText:SetText("|c0000ff00 Status: "..text)
end