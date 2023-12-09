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

    frame.editbox = tt.AceGUI:Create("MultiLineEditBox")
    frame.editbox:SetLabel("Log")
    frame.editbox:SetFullWidth(true)
    frame.editbox:SetFullHeight(true)
    frame.editbox:SetDisabled(false)
    frame:AddChild(frame.editbox)
end

function log:Add(message)
    local current = frame.editbox:GetText()
    frame.editbox:SetText(current .. "\n" .. message)
end

local lastmessage
local oldprint = print

print = function(...)
    if lastmessage ~= ... then
        lastmessage = ...
        oldprint(...)
        tt.Log:Add(...)
    end
end