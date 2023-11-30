local tt = tt
tt.Log = {}
local log = tt.Log

local frame

if not frame then
    frame = tt.AceGUI:Create("Frame")
    frame:SetTitle("Log")
    frame:SetLayout("Fill")
    frame:SetWidth(500)
    frame:SetHeight(500)
    frame:EnableResize(false)

    local editbox = tt.AceGUI:Create("MultiLineEditBox")
    editbox:SetLabel("Log")
    editbox:SetFullWidth(true)
    editbox:SetFullHeight(true)
    editbox:SetDisabled(false)
    frame:AddChild(editbox)
end

function log:Add(message)
    local current = frame.children[1]:GetText()
    frame.children[1]:SetText(current .. "\n" .. message)
end