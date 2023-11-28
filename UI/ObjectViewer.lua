local tt = tt
local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
local ScrollingTable = LibStub("ScrollingTable");
tt.ObjectViewer = class()
local ObjectViewer = tt.ObjectViewer

local OMFrame = nil
local scrollcontainer = nil
local scroll = nil
local ScrollTable = nil

local green ="|cFF00FF00"
local red ="|cffff0000"

ObjectViewer.mode = "objects"

local cols = { 
}

function tt:ToggleObjectViewer()
    if OMFrame:IsShown() then
        OMFrame:Hide()
    else
        OMFrame:Show()
    end
end

function tt:SelectGroup(group)
    print("SelectGroup", group)
    if group == "objects" then
        ObjectViewer.mode = "objects"
    end
    if group == "players" then
        ObjectViewer.mode = "players"
    end
    if group == "units" then
        ObjectViewer.mode = "units"
    end
    local str = string.gsub(" "..ObjectViewer.mode, "%W%l", string.upper):sub(2)
    OMFrame:SetTitle("Object Manager - " .. str)
end

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
    if ObjectViewer.mode == "objects" then
        for k,v in pairs(tt.gameobjects) do
            local tree = {"", v.Name, string.format("%0d",v.Distance), 0, 0, 0, 0, string.format("%02d",v.HP)}
            table.insert(data, tree)
        end
    end
    if ObjectViewer.mode == "players" then
        table.sort(tt.players, function(x, y)
            return x.score > y.score
        end)
        for k,v in pairs(tt.players) do
            local react = ""
            if v.Reaction <= 3 then
                react = "Hostile"
            else
                react = "Friendly"
            end
            local tree = {react,v.Name, string.format("%0d",v.Distance), v.FriendsAround, v.EnemiesAround, string.format("%0d", v.score), string.format("%0d", v.targetScore), string.format("%02d",v.HP)}
            table.insert(data, tree)
        end
    end
    if ObjectViewer.mode == "units" then
        for k,v in pairs(tt.units) do
            local tree = {"", v.Name, string.format("%0d",v.Distance), v.FriendsAround, v.EnemiesAround, string.format("%0d", v.score), v.targetScore, string.format("%02d",v.HP)}
            table.insert(data, tree)
        end
    end
    ScrollTable:SetData(data, true)
    ScrollTable:SetWidth(950)    
    

end

if not OMFrame then
    OMFrame = AceGUI:Create("Window", "ObjectViewerFrame", UIParent)
    local str = string.gsub(" "..ObjectViewer.mode, "%W%l", string.upper):sub(2)
    OMFrame:SetTitle("Object Manager - " .. str)
    OMFrame:SetLayout("Flow")
    OMFrame:SetWidth(1024) 

    local objectbutton = AceGUI:Create("Button")
    objectbutton:SetText("Objects")
    objectbutton:SetWidth(100)
    objectbutton:SetCallback("OnClick", function() tt:SelectGroup("objects") end)
    OMFrame:AddChild(objectbutton)

    local playerbutton = AceGUI:Create("Button")
    playerbutton:SetText("Players")
    playerbutton:SetWidth(100)
    playerbutton:SetCallback("OnClick", function() tt:SelectGroup("players") end)
    OMFrame:AddChild(playerbutton)

    local unitsbutton = AceGUI:Create("Button")
    unitsbutton:SetText("Units")
    unitsbutton:SetWidth(100)
    unitsbutton:SetCallback("OnClick", function() tt:SelectGroup("units") end)
    OMFrame:AddChild(unitsbutton)

    tt:AddColumn("Reaction")
    tt:AddColumn("Name")
    tt:AddColumn("Distance")
    tt:AddColumn("Friends")
    tt:AddColumn("Enemies")
    tt:AddColumn("Score")
    tt:AddColumn("TargetScore")
    tt:AddColumn("HP")

    if ScrollTable == nil then
        ScrollTable = ScrollingTable:CreateST(cols, nil, nil, nil, OMFrame.frame);
    end

    tt:updateObjectViewer()

    local pullrange = tt.AceGUI:Create("EditBox")
    pullrange:SetLabel("Pull Range")
    pullrange:SetWidth(100)
    pullrange:SetText(tt.pullrange)
    pullrange:SetCallback("OnEnterPressed", function(self, event, text)
        tt.pullrange = tonumber(text)
        print("tt.pullrange", tt.pullrange)
    end)
    OMFrame:AddChild(pullrange)

    local combatrange = tt.AceGUI:Create("EditBox")
    combatrange:SetLabel("Combat Range")
    combatrange:SetWidth(100)
    combatrange:SetText(tt.combatrange)
    combatrange:SetCallback("OnEnterPressed", function(self, event, text)
        tt.combatrange = tonumber(text)
        print("tt.combatrange", tt.combatrange)
    end)
    OMFrame:AddChild(combatrange)

end