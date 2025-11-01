-- [ REDZLIB - 100% HOẠT ĐỘNG - 7 TAB - ĐÃ TEST ]
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
    Title = "HieuDRG Hub V1 | 99 night in the forest",
    SubTitle = "by up3",
    SaveFolder = "HieuDRG_Hub"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://83190276951914", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 5) }
})

-- [ SERVICES ]
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [ VARIABLES - GIỮ NGUYÊN ]
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
local fuelItems = {"Log", "Chair", "Coal", "Fuel Canister", "Oil Barrel"}
local selectedFuelItems = {}
local foodItems = {"Cake", "Cooked Steak", "Cooked Morsel", "Steak", "Morsel", "Berry", "Carrot"}
local selectedFoodItems = {}
local medicalItems = {"Bandage", "MedKit"}
local selectedMedicalItems = {}
local equipmentItems = {"Revolver", "Rifle", "Leather Body", "Iron Body", "Revolver Ammo", "Rifle Ammo", "Giant Sack", "Good Sack", "Strong Axe", "Good Axe"}
local selectedEquipmentItems = {}

local campfireFuelItems = {"Log", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}
local campfireDropPos = Vector3.new(0, 19, 0)

local autocookItems = {"Morsel", "Steak"}
local autoCookEnabledItems = {}
local autoCookEnabled = false

-- [ HÀM CƠ BẢN - GIỮ NGUYÊN ]
local function getAnyToolWithDamageID(isChopAura)
    for toolName, damageID in pairs(toolsDamageIDs) do
        if isChopAura and toolName ~= "Old Axe" and toolName ~= "Good Axe" and toolName ~= "Strong Axe" then
            continue
        end
        local tool = LocalPlayer:FindFirstChild("Inventory") and LocalPlayer.Inventory:FindFirstChild(toolName)
        if tool then return tool, damageID end
    end
    return nil, nil
end

local function equipTool(tool) if tool then ReplicatedStorage.RemoteEvents.EquipItemHandle:FireServer("FireAllClients", tool) end end
local function unequipTool(tool) if tool then ReplicatedStorage.RemoteEvents.UnequipItemHandle:FireServer("FireAllClients", tool) end end

-- [ AURA ]
local function killAuraLoop()
    while killAuraToggle do
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID(false)
            if tool and damageID then
                equipTool(tool)
                for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= auraRadius then
                            pcall(function()
                                ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(mob, tool, damageID, CFrame.new(part.Position))
                            end)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end

local function chopAuraLoop()
    while chopAuraToggle do
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, baseDamageID = getAnyToolWithDamageID(true)
            if tool and baseDamageID then
                equipTool(tool)
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
                        task.spawn(function()
                            while chopAuraToggle and tree and tree.Parent do
                                currentammount = currentammount + 1
                                pcall(function()
                                    ReplicatedStorage.RemoteEvents.ToolDamageObject:InvokeServer(
                                        tree, tool,
                                        tostring(currentammount) .. "_7367831688",
                                        CFrame.new(-2.962610244751, 4.5547881126404, -75.950843811035, 0.89621275663376, -1.3894891459643e-08, 0.44362446665764, -7.994568895775e-10, 1, 3.293635941759e-08, -0.44362446665764, -2.9872644802253e-08, 0.89621275663376)
                                    )
                                end)
                                task.wait(0.5)
                            end
                        end)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end

-- [ AUTO FEED ]
function wiki(nome) local c = 0; for _, i in ipairs(Workspace.Items:GetChildren()) do if i.Name == nome then c += 1 end end; return c end
function ghn() return math.floor(LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100) end
function feed(nome) for _, item in ipairs(Workspace.Items:GetChildren()) do if item.Name == nome then ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item); break end end end
function notifeed() redzlib:Notify({Title = "Auto Food", Content = "Food hết!", Duration = 3}) end

-- [ BRING ]
local function moveItemToPos(item, pos)
    if not item or not item:IsDescendantOf(Workspace) then return end
    local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")) or item
    if not part or not part:IsA("BasePart") then return end
    pcall(function()
        ReplicatedStorage.RemoteEvents.RequestStartDraggingItem:FireServer(item)
        if item:IsA("Model") then item:SetPrimaryPartCFrame(CFrame.new(pos)) else part.CFrame = CFrame.new(pos) end
        ReplicatedStorage.RemoteEvents.StopDraggingItem:FireServer(item)
    end)
end

-- [ TELEPORT ]
local function tp1()
    local hrp = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(0.43132782, 15.77634621, -1.88620758, -0.270917892, 0.102997094, 0.957076371, 0.639657021, 0.762253821, 0.0990355015, -0.719334781, 0.639031112, -0.272391081)
end

local function tp2()
    local path = Workspace:FindFirstChild("Map")?.Landmarks?.Stronghold?.Functional?.EntryDoors?.DoorRight?.Model
    if path then
        local part = path:GetChildren()[5]
        if part and part:IsA("BasePart") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = part.CFrame + Vector3.new(0,5,0) end
        end
    end
end

local function getChests()
    local chests, names = {}, {}
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name:match("^Item Chest") and not item:GetAttribute("8721081708Opened") then
            table.insert(chests, item)
            table.insert(names, "Chest " .. #names + 1)
        end
    end
    return chests, names
end

local function getMobs()
    local mobs, names = {}, {}
    for _, char in ipairs(Workspace.Characters:GetChildren()) do
        if char.Name:match("^Lost Child") and char:GetAttribute("Lost") then
            table.insert(mobs, char)
            table.insert(names, char.Name)
        end
    end
    return mobs, names
end

-- [ ESP ]
local function createESP(part, text, color)
    if part:FindFirstChild("ESP") then return end
    local bg = Instance.new("BillboardGui", part)
    bg.Name = "ESP"; bg.Adornee = part; bg.Size = UDim2.new(0,100,0,20); bg.StudsOffset = Vector3.new(0,2.5,0)
    bg.AlwaysOnTop = true; bg.MaxDistance = 300
    local lbl = Instance.new("TextLabel", bg)
    lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1; lbl.Text = text
    lbl.TextColor3 = color; lbl.TextStrokeTransparency = 0.2; lbl.TextScaled = true; lbl.Font = Enum.Font.GothamBold
end

-- [ TABS - ĐẢM BẢO HOẠT ĐỘNG ]
local TabCombat = Window:MakeTab({"Combat", "sword"})
local TabMain = Window:MakeTab({"Main", "home"})
local TabAuto = Window:MakeTab({"Auto", "wrench"})
local TabEsp = Window:MakeTab({"Esp", "sparkles"})
local TabBring = Window:MakeTab({"Bring", "package"})
local TabTp = Window:MakeTab({"Teleport", "map"})
local TabFly = Window:MakeTab({"Player", "user"})

-- [ COMBAT ]
TabCombat:AddToggle({Title="Kill Aura", Callback=function(s) killAuraToggle=s; if s then task.spawn(killAuraLoop) end end})
TabCombat:AddToggle({Title="Chop Aura", Callback=function(s) chopAuraToggle=s; if s then task.spawn(chopAuraLoop) end end})
TabCombat:AddSlider({Title="Radius", Min=10, Max=100, Default=50, Callback=function(v) auraRadius=v end})

-- [ MAIN ]
TabMain:AddDropdown({Title="Food", Items=alimentos, Callback=function(v) selectedFood=v end})
TabMain:AddInput({Title="Hunger %", Placeholder="75", Callback=function(v) hungerThreshold=tonumber(v) or 75 end})
local autoFeedToggleRef = TabMain:AddToggle({Title="Auto Feed", Callback=function(s)
    if s then
        task.spawn(function()
            while s do
                task.wait(0.1)
                if wiki(selectedFood)==0 then autoFeedToggleRef:Set(false); notifeed(); break end
                if ghn() <= hungerThreshold then feed(selectedFood) end
            end
        end)
    end
end})

-- [ AUTO ]
TabAuto:AddDropdown({Title="Cook Items", Items=autocookItems, Multi=true, Callback=function(opts)
    for _,v in ipairs(autocookItems) do autoCookEnabledItems[v]=table.find(opts,v)~=nil end
end})
TabAuto:AddToggle({Title="Auto Cook", Callback=function(s) autoCookEnabled=s end})

task.spawn(function()
    while true do
        if autoCookEnabled then
            for n,e in pairs(autoCookEnabledItems) do
                if e then for _,i in ipairs(Workspace.Items:GetChildren()) do if i.Name==n then moveItemToPos(i,campfireDropPos) end end end
            end
        end
        task.wait(0.5)
    end
end)

-- [ TELEPORT ]
local currentMobs, currentMobNames = getMobs()
local currentChests, currentChestNames = getChests()
local selectedMob, selectedChest

local mobDrop = TabTp:AddDropdown({Title="Child", Items=currentMobNames, Callback=function(v) selectedMob=v end})
local chestDrop = TabTp:AddDropdown({Title="Chest", Items=currentChestNames, Callback=function(v) selectedChest=v end})

TabTp:AddButton({Title="Campfire", Callback=tp1})
TabTp:AddButton({Title="Stronghold", Callback=tp2})
TabTp:AddButton({Title="Refresh", Callback=function()
    currentMobs, currentMobNames = getMobs()
    currentChests, currentChestNames = getChests()
    mobDrop:Refresh(currentMobNames)
    chestDrop:Refresh(currentChestNames)
end})
TabTp:AddButton({Title="TP Child", Callback=function()
    for i,v in ipairs(currentMobNames) do if v==selectedMob then
        local mob = currentMobs[i]
        if mob and mob.PrimaryPart then
            LocalPlayer.Character.HumanoidRootPart.CFrame = mob.PrimaryPart.CFrame + Vector3.new(0,5,0)
        end
    end end
end})

-- [ BRING ]
TabBring:AddDropdown({Title="Junk", Items=junkItems, Multi=true, Callback=function(v) selectedJunkItems=v end})
TabBring:AddButton({Title="Bring", Callback=function()
    local pos = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(2,0,0)
    for _,n in ipairs(selectedJunkItems) do for _,i in ipairs(Workspace.Items:GetChildren()) do if i.Name==n then moveItemToPos(i,pos) end end end
end})

-- [ ESP ]
local selectedItemsESP, selectedMobsESP = {}, {}
TabEsp:AddDropdown({Title="Items", Items=ie, Multi=true, Callback=function(v) selectedItemsESP=v end})
TabEsp:AddToggle({Title="ESP Items", Callback=function(s)
    for _,n in ipairs(ie) do
        if s and table.find(selectedItemsESP,n) then
            for _,i in ipairs(Workspace.Items:GetChildren()) do if i.Name==n then createESP(i.PrimaryPart or i:FindFirstChildWhichIsA("BasePart"), n, Color3.fromRGB(0,255,0)) end end
        else
            for _,i in ipairs(Workspace.Items:GetDescendants()) do if i.Name=="ESP" then i:Destroy() end end
        end
    end
end})

-- [ FLY ]
local flySpeed = 5
local flying = false
TabFly:AddSlider({Title="Speed", Min=1, Max=20, Default=5, Callback=function(v) flySpeed=v end})
TabFly:AddToggle({Title="Fly", Callback=function(s)
    if s and not flying then
        flying = true
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        local bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        spawn(function()
            while flying do
                local cam = workspace.CurrentCamera
                local move = require(LocalPlayer.PlayerScripts.PlayerModule.ControlModule):GetMoveVector()
                bv.Velocity = (cam.CFrame.LookVector * move.Z + cam.CFrame.RightVector * move.X) * flySpeed * 50
                bg.CFrame = cam.CFrame
                task.wait()
            end
        end)
    else
        flying = false
    end
end})

redzlib:Notify({Title="HieuDRG Hub", Content="7 Tabs Loaded!", Duration=5})
