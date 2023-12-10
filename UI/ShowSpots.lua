local tt = tt
tt.ShowSpots = {}
local ShowSpots = tt.ShowSpots

local spotsframe = nil

if not spotsframe then
    spotsframe = tt.AceGUI:Create("Frame")
    spotsframe:SetTitle("Spots")
    spotsframe:SetStatusText("Spots")
    spotsframe:SetLayout("Flow")
    spotsframe:SetWidth(600)
    spotsframe:SetHeight(650)
    spotsframe:EnableResize(false)

    local badspots = tt.AceGUI:Create("MultiLineEditBox")
    badspots:SetLabel("Bad Spots")
    badspots:SetWidth(600)
    badspots:SetHeight(300)
    spotsframe:AddChild(badspots)

    local movespots = tt.AceGUI:Create("MultiLineEditBox")
    movespots:SetLabel("Move Spots")
    movespots:SetWidth(600)
    movespots:SetHeight(300)
    spotsframe:AddChild(movespots)

end
spotsframe:Hide()