local tt = tt
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local ScrollingTable = LibStub("ScrollingTable");
tt.ObjectViewer = class()
local ObjectViewer = tt.ObjectViewer

local OMFrame = nil
local scrollcontainer = nil
local scroll = nil
local ScrollTable = nil

local cols = { 
}

function tt:AddColumn(name)
    local column = {
        ["name"] = name,
        ["width"] = 100,
        ["align"] = "LEFT",
        ["color"] = { 
            ["r"] = 1.0, 
            ["g"] = 1.0, 
            ["b"] = 1.0, 
            ["a"] = 1.0 
        },
        ["colorargs"] = nil,
        ["bgcolor"] = {
            ["r"] = 0.0, 
            ["g"] = 0.0, 
            ["b"] = 0.0, 
            ["a"] = 1.0 
        }, -- red backgrounds, eww!
        ["defaultsort"] = "dsc",
        ["sortnext"]= 4,
        ["comparesort"] = function (cella, cellb, column)
            return cella.value < cellb.value;
        end,    
        ["DoCellUpdate"] = nil,
    }
    table.insert(cols, column)
end

function tt:updateObjectViewer()
    local data = {}
    for k,v in pairs(tt.units) do
        local tree = {v.Name, string.format("%0d",v.Distance), v:GetEnemiesAround(30), v:GetFriendsAround(30), v.HP}
        table.insert(data, tree)
    end
    ScrollTable:SetData(data, true)
    ScrollTable:SetWidth(950)    
    

end

if not OMFrame then
    OMFrame = AceGUI:Create("Window", "ObjectViewerFrame", UIParent)
    OMFrame:SetTitle("Object Manager")
    OMFrame:SetLayout("Flow")
    OMFrame:SetWidth(1024) 

    tt:AddColumn("Name")
    tt:AddColumn("Distance")
    tt:AddColumn("Enemies")
    tt:AddColumn("Friends")
    tt:AddColumn("HP")

    if ScrollTable == nil then
        ScrollTable = ScrollingTable:CreateST(cols, nil, nil, nil, OMFrame.frame);
    end

    tt:updateObjectViewer()
end