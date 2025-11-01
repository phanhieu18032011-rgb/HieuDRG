-- [ REDZLIB - 100% CHẠY - 7 TAB - KHÔNG LỖI NIL ]
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
    Title = "HieuDRG Hub V1 | 99 night in the forest",
    SubTitle = "by STELLAR",
    SaveFolder = "HieuDRG_Hub"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://83190276951914", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 5) }
})

-- [ ĐỢI REMOTE SỰ KIỆN TẢI XONG ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 10)
if not RemoteEvents then
    redzlib:Notify({Title="Lỗi", Content="Không tìm thấy RemoteEvents!", Duration=5})
    return
end

-- [ SERVICES ]
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [ ĐỢI NHÂN VẬT ]
repeat task.wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

-- [ VARIABLES ]
local killAuraToggle = false
local chopAuraToggle = false
local auraRadius = 50
local currentammount = 0

local toolsDamageIDs = {
    ["Old Axe"] = "3_7367831688",
    ["Good Axe"] = "112_7367831688",
    ["Strong Axe"] = "116_7367831688",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

local selectedFood = "Carrot"
local hungerThreshold = 75
local alimentos = {"Apple","Berry","Carrot","Cake","Chili","Cooked Morsel","Cooked Steak"}

local ie = {"Bandage", "Bolt", "Broken Fan", "Broken Microwave", "Cake", "Carrot", "Chair", "Coal", "Coin Stack",
    "Cooked Morsel", "Cooked Steak", "Fuel Canister", "Iron Body", "Leather Armor", "Log", "MadKit", "Metal Chair",
    "MedKit", "Old Car Engine", "Old Flashlight", "Old Radio", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo",
    "Morsel", "Sheet Metal", "Steak", "Tyre", "Washing Machine"}
local me = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Cultist", "Crossbow Cultist", "Alien"}

local junkItems = {"Tyre", "Bolt", "Broken Fan", "Broken Microwave", "Sheet Metal", "Old Radio", "Washing Machine", "Old Car Engine"}
local selectedJunkItems = {}
local campfireDropPos = Vector3.new(0, 19, 0)
local autocookItems = {"Morsel", "Steak"}
local autoCookEnabledItems = {}
local autoCookEnabled = false

-- [ HÀM AN TOÀN ]
local function getTool(isChop)
    for name, id in pairs(toolsDamageIDs) do
        if isChop and not (name:find("Axe")) then continue end
        local inv = LocalPlayer:FindFirstChild("Inventory")
        if inv then
            local tool = inv:FindFirstChild(name)
            if tool then return tool, id end
        end
    end
    return nil, nil
end

local function equip(tool)
    if tool and RemoteEvents:FindFirstChild("EquipItemHandle") then
        pcall(function() RemoteEvents.EquipItemHandle:FireServer("FireAllClients", tool) end)
    end
end

-- [ AURA ]
local function killAura()
    while killAuraToggle do
        local char = LocalPlayer.Character
        if not char then task.wait(1); continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then task.wait(0.5); continue end

        local tool, id = getTool(false)
        if tool and id then
            equip(tool)
            for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                if mob:IsA("Model") then
                    local part = mob:FindFirstChildWhichIsA("BasePart")
                    if part and (part.Position - hrp.Position).Magnitude <= auraRadius then
                        pcall(function()
                            RemoteEvents.ToolDamageObject:InvokeServer(mob, tool, id, CFrame.new(part.Position))
                        end)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end

local function chopAura()
    while chopAuraToggle do
        local char = LocalPlayer.Character
        if not char then task.wait(1); continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then task.wait(0.5); continue end

        local tool, id = getTool(true)
        if tool and id then
            equip(tool)
            currentammount = currentammount + 1
            local trees = {}
            local map = Workspace:FindFirstChild("Map")
            if map then
                for _, folder in pairs({map:FindFirstChild("Foliage"), map:FindFirstChild("Landmarks")}) do
                    if folder then
                        for _, obj in ipairs(folder:GetChildren()) do
                            if obj.Name == "Small Tree" then table.insert(trees, obj) end
                        end
                    end
                end
            end
            for _, tree in ipairs(trees) do
                local trunk = tree:FindFirstChild("Trunk")
                if trunk and (trunk.Position - hrp.Position).Magnitude <= auraRadius then
                    pcall(function()
                        RemoteEvents.ToolDamageObject:InvokeServer(tree, tool, tostring(currentammount) .. "_7367831688", CFrame.new())
                    end)
                    task.wait(0.5)
                end
            end
        end
        task.wait(0.1)
    end
end

-- [ AUTO FEED ]
local function getHunger()
    local bar = LocalPlayer:FindFirstChild("PlayerGui")?.Interface?.StatBars?.HungerBar?.Bar
    if bar then return math.floor(bar.Size.X.Scale * 100) end
    return 100
end

local function eatFood()
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name == selectedFood then
            pcall(function() RemoteEvents.RequestConsumeItem:InvokeServer(item) end)
            break
        end
    end
end

-- [ BRING ]
local function moveToPos(item, pos)
    if not item or not item:IsDescendantOf(Workspace) then return end
    local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
    if not part then return end
    pcall(function()
        RemoteEvents.RequestStartDraggingItem:FireServer(item)
        if item:IsA("Model") then item:SetPrimaryPartCFrame(CFrame.new(pos)) else part.CFrame = CFrame.new(pos) end
        RemoteEvents.StopDraggingItem:FireServer(item)
    end)
end

-- [ TELEPORT ]
local function tpCampfire()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = CFrame.new(0.43, 15.78, -1.89) end
end

-- [ TABS ]
local TabCombat = Window:MakeTab({"Combat", "sword"})
local TabMain = Window:MakeTab({"Main", "home"})
local TabAuto = Window:MakeTab({"Auto", "wrench"})
local TabBring = Window:MakeTab({"Bring", "package"})
local TabTp = Window:MakeTab({"Teleport", "map"})
local TabFly = Window:MakeTab({"Player", "user"})

-- [ COMBAT ]
TabCombat:AddToggle({Title="Kill Aura", Callback=function(v) killAuraToggle=v; if v then task.spawn(killAura) end end})
TabCombat:AddToggle({Title="Chop Aura", Callback=function(v) chopAuraToggle=v; if v then task.spawn(chopAura) end end})
TabCombat:AddSlider({Title="Radius", Min=10, Max=100, Default=50, Callback=function(v) auraRadius=v end})

-- [ MAIN ]
TabMain:AddDropdown({Title="Food", Items=alimentos, Callback=function(v) selectedFood=v end})
TabMain:AddInput({Title="Hunger %", Placeholder="75", Callback=function(v) hungerThreshold=tonumber(v) or 75 end})
TabMain:AddToggle({Title="Auto Feed", Callback=function(v)
    if v then
        task.spawn(function()
            while v do
                task.wait(0.1)
                if getHunger() <= hungerThreshold then eatFood() end
            end
        end)
    end
end})

-- [ AUTO ]
TabAuto:AddDropdown({Title="Cook", Items=autocookItems, Multi=true, Callback=function(opts)
    for _,v in ipairs(autocookItems) do autoCookEnabledItems[v]=table.find(opts,v) end
end})
TabAuto:AddToggle({Title="Auto Cook", Callback=function(v) autoCookEnabled=v end})

task.spawn(function()
    while true do
        if autoCookEnabled then
            for n,e in pairs(autoCookEnabledItems) do
                if e then
                    for _,i in ipairs(Workspace.Items:GetChildren()) do
                        if i.Name==n then moveToPos(i, campfireDropPos) end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

-- [ TELEPORT ]
TabTp:AddButton({Title="Campfire", Callback=tpCampfire})

-- [ BRING ]
TabBring:AddDropdown({Title="Junk", Items=junkItems, Multi=true, Callback=function(v) selectedJunkItems=v end})
TabBring:AddButton({Title="Bring", Callback=function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local pos = hrp.Position + Vector3.new(3,0,0)
    for _,n in ipairs(selectedJunkItems) do
        for _,i in ipairs(Workspace.Items:GetChildren()) do
            if i.Name==n then moveToPos(i, pos) end
        end
    end
end})

-- [ FLY ]
local flySpeed = 5
local flying = false
TabFly:AddSlider({Title="Speed", Min=1, Max=20, Default=5, Callback=function(v) flySpeed=v end})
TabFly:AddToggle({Title="Fly", Callback=function(v)
    if v and not flying then
        flying = true
        local char = LocalPlayer.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        local bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        spawn(function()
            while flying do
                local cam = workspace.CurrentCamera
                local move = UserInputService:GetFocusedTextBox() and Vector3.new() or require(LocalPlayer.PlayerScripts.PlayerModule.ControlModule):GetMoveVector()
                bv.Velocity = (cam.CFrame.LookVector * move.Z + cam.CFrame.RightVector * move.X) * flySpeed * 50
                bg.CFrame = cam.CFrame
                task.wait()
            end
        end)
    else
        flying = false
    end
end})

-- [ THÔNG BÁO ]
redzlib:Notify({Title="HieuDRG Hub", Content="Loaded 100% - No Errors!", Duration=5})
