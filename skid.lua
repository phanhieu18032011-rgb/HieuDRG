-- HieuDRG Hub | Specialized Game Exploit Suite
-- Target: https://www.roblox.com/share?code=86b77038205e9e46b189f7312249e9d3

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

-- SHADOW CORE: Secure environment initialization
if not getgenv then getgenv = getfenv end
if not getgenv().HieuDRG_Hub then 
    getgenv().HieuDRG_Hub = {
        Connections = {},
        ESPObjects = {},
        Enabled = true,
        Settings = {
            FlySpeed = 50,
            WalkSpeed = 16,
            JumpPower = 50,
            FarmRange = 50,
            AutoFarm = false,
            AutoCollect = false
        },
        GameSpecific = {
            InfiniteResources = false,
            AutoOpenChests = false,
            AutoFarmResources = false,
            NoClipFarm = false
        }
    }
end

local HieuDRG = getgenv().HieuDRG_Hub

-- cleanup
if CoreGui:FindFirstChild("GravityHubPreview") then
    CoreGui.GravityHubPreview:Destroy()
end

-- colors
local BG = Color3.fromRGB(12,12,12)
local PANEL = Color3.fromRGB(22,22,22)
local PANEL_ALT = Color3.fromRGB(28,28,28)
local ACCENT = Color3.fromRGB(255,165,0) -- orange
local TXT = Color3.fromRGB(230,230,230)
local MUTED = Color3.fromRGB(160,160,160)
local TOGGLE_OFF = Color3.fromRGB(80,80,80)

-- helper
local function new(class, props)
    local inst = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then inst.Parent = v else inst[k] = v end
        end
    end
    return inst
end

-- root gui
local screenGui = new("ScreenGui", {Name = "GravityHubPreview", Parent = CoreGui, ResetOnSpawn = false})
screenGui.IgnoreGuiInset = true

-- window
local window = new("Frame", {
    Name = "Window",
    Parent = screenGui,
    Size = UDim2.fromOffset(500,400),
    Position = UDim2.new(0.5, -250, 0.5, -200),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    ClipsDescendants = true
})
new("UICorner", {Parent = window, CornerRadius = UDim.new(0,12)})

-- header
local header = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,0,48),
    Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = PANEL_ALT,
    BorderSizePixel = 0
})
new("UICorner", {Parent = header, CornerRadius = UDim.new(0,12)})

local titleLabel = new("TextLabel", {
    Parent = header,
    Text = "HieuDRG Hub",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = ACCENT,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,12,0,6),
    Size = UDim2.new(0.7,0,0,20),
    TextXAlignment = Enum.TextXAlignment.Left
})
local subLabel = new("TextLabel", {
    Parent = header,
    Text = "Specialized Game Exploit",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = MUTED,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,12,0,26),
    Size = UDim2.new(0.7,0,0,16),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- Player Info & Uptime
local playerInfo = new("TextLabel", {
    Parent = header,
    Text = "Player: " .. LocalPlayer.Name,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = MUTED,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.7,0,0,6),
    Size = UDim2.new(0.3,-12,0,16),
    TextXAlignment = Enum.TextXAlignment.Right
})

local uptimeLabel = new("TextLabel", {
    Parent = header,
    Text = "Uptime: 00:00:00",
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextColor3 = MUTED,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.7,0,0,26),
    Size = UDim2.new(0.3,-12,0,16),
    TextXAlignment = Enum.TextXAlignment.Right
})

-- collapse button ( - )
local btnCollapse = new("TextButton", {
    Parent = header,
    Size = UDim2.new(0,44,0,30),
    Position = UDim2.new(1,-56,0.5,-15),
    BackgroundColor3 = PANEL,
    Text = "-",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = TXT,
    AutoButtonColor = false
})
new("UICorner", {Parent = btnCollapse, CornerRadius = UDim.new(0,8)})

-- tab bar
local tabBar = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,0,44),
    Position = UDim2.new(0,0,0,48),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
})
new("UICorner", {Parent = tabBar, CornerRadius = UDim.new(0,8)})

local tabScroller = new("ScrollingFrame", {
    Parent = tabBar,
    Size = UDim2.new(1,-24,1,0),
    Position = UDim2.new(0,12,0,0),
    BackgroundTransparency = 1,
    ScrollBarThickness = 6,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.X,
    HorizontalScrollBarInset = Enum.ScrollBarInset.Always
})
local tabListLayout = new("UIListLayout", {Parent = tabScroller})
tabListLayout.FillDirection = Enum.FillDirection.Horizontal
tabListLayout.Padding = UDim.new(0,8)
tabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left

-- content area
local content = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,1, - (48+44)),
    Position = UDim2.new(0,0,0,48+44),
    BackgroundTransparency = 1
})

-- panels (left & right) inside main tab page container
local function makePanel(parent, x)
    local panel = new("Frame", {
        Parent = parent,
        Size = UDim2.new(0.5, -12, 1, -24),
        Position = UDim2.new(x, x==0 and 12 or 6, 0,12),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0
    })
    new("UICorner", {Parent = panel, CornerRadius = UDim.new(0,10)})
    return panel
end

-- tab system
local TabNames = {"Auto Farm","Resources","Movement","Visuals","Combat","Protection"}
local TabButtons = {}
local TabPages = {}
local currentTab = nil

local function setActiveTab(name)
    currentTab = name
    for k,btn in pairs(TabButtons) do
        if k == name then
            btn.BackgroundColor3 = ACCENT
            btn.TextColor3 = Color3.fromRGB(20,20,20)
        else
            btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
            btn.TextColor3 = TXT
        end
    end
    for k,page in pairs(TabPages) do
        page.Visible = (k == name)
    end
end

-- create tab buttons and pages
for i,name in ipairs(TabNames) do
    local btn = new("TextButton", {
        Parent = tabScroller,
        Size = UDim2.new(0,120,0,32),
        BackgroundColor3 = Color3.fromRGB(35,35,35),
        Text = name,
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextColor3 = TXT,
        AutoButtonColor = false
    })
    new("UICorner", {Parent = btn, CornerRadius = UDim.new(0,8)})
    TabButtons[name] = btn

    local page = new("Frame", {
        Parent = content,
        Name = name,
        Size = UDim2.new(1,0,1,0),
        BackgroundTransparency = 1,
        Visible = false
    })
    TabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        setActiveTab(name)
    end)
end

-- create Auto Farm page content
local autoFarmPage = TabPages["Auto Farm"]
local farmLeftPanel = makePanel(autoFarmPage, 0)
local farmRightPanel = makePanel(autoFarmPage, 0.5)

local farmLeftTitle = new("TextLabel", {Parent = farmLeftPanel, Text = "Auto Collection", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})
local farmRightTitle = new("TextLabel", {Parent = farmRightPanel, Text = "Chest Farming", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})

local farmLeftScroll = new("ScrollingFrame", {Parent = farmLeftPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
farmLeftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local farmLeftLayout = new("UIListLayout", {Parent = farmLeftScroll})
farmLeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
farmLeftLayout.Padding = UDim.new(0,10)

local farmRightScroll = new("ScrollingFrame", {Parent = farmRightPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
farmRightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local farmRightLayout = new("UIListLayout", {Parent = farmRightScroll})
farmRightLayout.SortOrder = Enum.SortOrder.LayoutOrder
farmRightLayout.Padding = UDim.new(0,10)

-- create Resources page content
local resourcesPage = TabPages["Resources"]
local resLeftPanel = makePanel(resourcesPage, 0)
local resRightPanel = makePanel(resourcesPage, 0.5)

local resLeftTitle = new("TextLabel", {Parent = resLeftPanel, Text = "Infinite Resources", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})
local resRightTitle = new("TextLabel", {Parent = resRightPanel, Text = "Resource Settings", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})

local resLeftScroll = new("ScrollingFrame", {Parent = resLeftPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
resLeftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local resLeftLayout = new("UIListLayout", {Parent = resLeftScroll})
resLeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
resLeftLayout.Padding = UDim.new(0,10)

local resRightScroll = new("ScrollingFrame", {Parent = resRightPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
resRightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local resRightLayout = new("UIListLayout", {Parent = resRightScroll})
resRightLayout.SortOrder = Enum.SortOrder.LayoutOrder
resRightLayout.Padding = UDim.new(0,10)

-- create other pages (Movement, Visuals, Combat, Protection)
for _, pageName in ipairs({"Movement", "Visuals", "Combat", "Protection"}) do
    local page = TabPages[pageName]
    local panel = makePanel(page, 0)
    panel.Size = UDim2.new(1, -24, 1, -24)
    panel.Position = UDim2.new(0, 12, 0, 12)
    
    local title = new("TextLabel", {Parent = panel, Text = pageName .. " Features", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})
    
    local scroll = new("ScrollingFrame", {Parent = panel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local layout = new("UIListLayout", {Parent = scroll})
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,10)
    
    TabPages[pageName .. "Scroll"] = scroll
end

-- makeRow (button-based so clicks register)
local function makeRow(parent, height)
    local row = new("TextButton", {
        Parent = parent,
        Size = UDim2.new(1,0,0, height or 46),
        BackgroundColor3 = Color3.fromRGB(38,38,38),
        AutoButtonColor = false,
        Text = ""
    })
    new("UICorner", {Parent = row, CornerRadius = UDim.new(0,8)})
    return row
end

-- Toggle factory (uses internal click; returns control)
local function makeToggle(parent, text, default, callback)
    local row = makeRow(parent, 48)
    local label = new("TextLabel", {
        Parent = row,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = TXT,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,12,0,0),
        Size = UDim2.new(1,-96,1,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })
    local sw = new("Frame", {
        Parent = row,
        Size = UDim2.new(0,44,0,24),
        Position = UDim2.new(1,-56,0.5,-12),
        BackgroundColor3 = default and ACCENT or TOGGLE_OFF,
    })
    new("UICorner", {Parent = sw, CornerRadius = UDim.new(1,0)})
    local knob = new("Frame", {
        Parent = sw,
        Size = UDim2.new(0,18,0,18),
        Position = default and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,4,0.5,-9),
        BackgroundColor3 = Color3.fromRGB(245,245,245)
    })
    new("UICorner", {Parent = knob, CornerRadius = UDim.new(1,0)})

    local toggled = default or false
    local function setState(v, animate)
        toggled = v
        local color = toggled and ACCENT or TOGGLE_OFF
        local pos = toggled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,4,0.5,-9)
        if animate then
            TweenService:Create(sw, TweenInfo.new(0.14), {BackgroundColor3 = color}):Play()
            TweenService:Create(knob, TweenInfo.new(0.14), {Position = pos}):Play()
        else
            sw.BackgroundColor3 = color
            knob.Position = pos
        end
        if callback then pcall(callback, toggled) end
    end

    row.MouseButton1Click:Connect(function()
        setState(not toggled, true)
    end)

    return {Row = row, Set = setState, Get = function() return toggled end}
end

-- Slider factory (simple)
local function makeSlider(parent, text, minv, maxv, default, callback)
    local row = makeRow(parent, 64)
    local label = new("TextLabel", {Parent = row, Text = text, Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = TXT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,6), Size = UDim2.new(1,-24,0,18), TextXAlignment = Enum.TextXAlignment.Left})
    local bar = new("Frame", {Parent = row, Size = UDim2.new(1,-120,0,12), Position = UDim2.new(0,12,0,34), BackgroundColor3 = Color3.fromRGB(60,60,60)})
    new("UICorner", {Parent = bar, CornerRadius = UDim.new(0,6)})
    local frac = math.clamp((default-minv)/(maxv-minv),0,1)
    local fill = new("Frame", {Parent = bar, Size = UDim2.new(frac,0,1,0), BackgroundColor3 = ACCENT})
    new("UICorner", {Parent = fill, CornerRadius = UDim.new(0,6)})
    local knob = new("Frame", {Parent = bar, Size = UDim2.new(0,14,0,14), Position = UDim2.new(frac,-7,0.5,-7), BackgroundColor3 = Color3.fromRGB(245,245,245)})
    new("UICorner", {Parent = knob, CornerRadius = UDim.new(1,0)})
    local display = new("TextLabel", {Parent = row, Text = tostring(default), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = TXT, BackgroundTransparency = 1, Size = UDim2.new(0,72,0,20), Position = UDim2.new(1,-92,0,22)})
    local dragging = false
    local function updateFromX(x)
        local absX = math.clamp(x - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
        local frac2 = absX / bar.AbsoluteSize.X
        local val = math.floor(minv + (maxv-minv)*frac2 + 0.5)
        fill.Size = UDim2.new(frac2,0,1,0)
        knob.Position = UDim2.new(frac2,-7,0.5,-7)
        display.Text = tostring(val)
        if callback then pcall(callback,val) end
    end
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then updateFromX(i.Position.X); dragging = true end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then updateFromX(i.Position.X) end end)
    return {Row = row}
end

-- SHADOW CORE: Game-Specific Exploit Functions

-- Auto Farm Functions
local function FindChests()
    local chests = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:lower():find("chest") or obj.Name:lower():find("box") or obj.Name:lower():find("crate")) then
            if obj:FindFirstChildOfClass("Part") then
                table.insert(chests, obj)
            end
        end
    end
    return chests
end

local function FindResources()
    local resources = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Part") and (obj.Name:lower():find("wood") or obj.Name:lower():find("stone") or obj.Name:lower():find("ore") or obj.Name:lower():find("resource")) then
            table.insert(resources, obj)
        end
    end
    return resources
end

local function TeleportToPosition(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Auto Farm System
local autoFarmConnection
makeToggle(farmLeftScroll, "🌾 Auto Farm Resources", false, function(state)
    HieuDRG.GameSpecific.AutoFarmResources = state
    if state then
        autoFarmConnection = RunService.Heartbeat:Connect(function()
            if HieuDRG.GameSpecific.AutoFarmResources and LocalPlayer.Character then
                local resources = FindResources()
                for _, resource in pairs(resources) do
                    local distance = (resource.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= HieuDRG.Settings.FarmRange then
                        -- Simulate resource collection
                        TeleportToPosition(resource.Position + Vector3.new(0, 3, 0))
                        break
                    end
                end
            end
        end)
    else
        if autoFarmConnection then
            autoFarmConnection:Disconnect()
        end
    end
end)

makeToggle(farmRightScroll, "📦 Auto Open Chests", false, function(state)
    HieuDRG.GameSpecific.AutoOpenChests = state
    if state then
        HieuDRG.Connections["AutoChest"] = RunService.Heartbeat:Connect(function()
            if HieuDRG.GameSpecific.AutoOpenChests and LocalPlayer.Character then
                local chests = FindChests()
                for _, chest in pairs(chests) do
                    local distance = (chest:GetModelCFrame().Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance <= HieuDRG.Settings.FarmRange then
                        TeleportToPosition(chest:GetModelCFrame().Position)
                        -- Simulate chest opening interaction
                        break
                    end
                end
            end
        end)
    else
        if HieuDRG.Connections["AutoChest"] then
            HieuDRG.Connections["AutoChest"]:Disconnect()
        end
    end
end)

makeToggle(farmLeftScroll, "⚡ Auto Collect Items", false, function(state)
    HieuDRG.Settings.AutoCollect = state
end)

makeToggle(farmRightScroll, "👻 NoClip Farm", false, function(state)
    HieuDRG.GameSpecific.NoClipFarm = state
end)

makeSlider(farmLeftScroll, "Farm Range", 10, 100, 50, function(value)
    HieuDRG.Settings.FarmRange = value
end)

-- Infinite Resources System
makeToggle(resLeftScroll, "❤️ Infinite Health", false, function(state)
    if state then
        HieuDRG.Connections["InfiniteHealth"] = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    else
        if HieuDRG.Connections["InfiniteHealth"] then
            HieuDRG.Connections["InfiniteHealth"]:Disconnect()
        end
    end
end)

makeToggle(resLeftScroll, "⚡ Infinite Energy", false, function(state)
    HieuDRG.GameSpecific.InfiniteResources = state
    -- Game-specific energy manipulation would go here
end)

makeToggle(resLeftScroll, "🪵 Infinite Wood", false, function(state)
    -- Game-specific wood resource manipulation
end)

makeToggle(resLeftScroll, "💎 Infinite Gems", false, function(state)
    -- Game-specific gem resource manipulation
end)

makeToggle(resRightScroll, "🔧 No Craft Cost", false, function(state)
    -- Game-specific craft cost bypass
end)

makeToggle(resRightScroll, "🔄 Instant Cooldown", false, function(state)
    -- Game-specific cooldown removal
end)

-- Movement Features
local flyConnection
local flyBodyVelocity

makeToggle(TabPages["MovementScroll"], "🕊️ Fly", false, function(state)
    HieuDRG.FlyEnabled = state
    if state then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            flyBodyVelocity = Instance.new("BodyVelocity")
            flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyBodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            flyBodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            
            flyConnection = RunService.Heartbeat:Connect(function()
                if HieuDRG.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = LocalPlayer.Character.HumanoidRootPart
                    local newVelocity = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        newVelocity = newVelocity + root.CFrame.LookVector * HieuDRG.Settings.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        newVelocity = newVelocity - root.CFrame.LookVector * HieuDRG.Settings.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        newVelocity = newVelocity - root.CFrame.RightVector * HieuDRG.Settings.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        newVelocity = newVelocity + root.CFrame.RightVector * HieuDRG.Settings.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        newVelocity = newVelocity + Vector3.new(0, HieuDRG.Settings.FlySpeed, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        newVelocity = newVelocity - Vector3.new(0, HieuDRG.Settings.FlySpeed, 0)
                    end
                    
                    flyBodyVelocity.Velocity = newVelocity
                    flyBodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                end
            end)
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
    end
end)

makeSlider(TabPages["MovementScroll"], "Fly Speed", 10, 200, 50, function(value)
    HieuDRG.Settings.FlySpeed = value
end)

makeToggle(TabPages["MovementScroll"], "👻 Noclip", false, function(state)
    HieuDRG.NoclipEnabled = state
    if state then
        HieuDRG.Connections["Noclip"] = RunService.Stepped:Connect(function()
            if HieuDRG.NoclipEnabled and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if HieuDRG.Connections["Noclip"] then
            HieuDRG.Connections["Noclip"]:Disconnect()
        end
    end
end)

makeSlider(TabPages["MovementScroll"], "Walk Speed", 16, 200, 16, function(value)
    HieuDRG.Settings.WalkSpeed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

makeSlider(TabPages["MovementScroll"], "Jump Power", 50, 500, 50, function(value)
    HieuDRG.Settings.JumpPower = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

-- Visuals Features (ESP)
local ESPColors = {
    Color3.fromRGB(255, 50, 50),    -- Red
    Color3.fromRGB(50, 255, 50),    -- Green  
    Color3.fromRGB(50, 100, 255),   -- Blue
    Color3.fromRGB(255, 255, 50),   -- Yellow
    Color3.fromRGB(255, 50, 255),   -- Magenta
    Color3.fromRGB(50, 255, 255),   -- Cyan
    Color3.fromRGB(255, 150, 50)    -- Orange
}

local function CreateESP(player, color)
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "HieuDRG_ESP"
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.FillTransparency = 0.6
    highlight.OutlineTransparency = 0.2
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = player.Character
    
    HieuDRG.ESPObjects[player] = highlight
    
    player.CharacterAdded:Connect(function(character)
        task.wait(2)
        if HieuDRG.ESPEnabled then
            local newHighlight = Instance.new("Highlight")
            newHighlight.Name = "HieuDRG_ESP"
            newHighlight.FillColor = color
            newHighlight.OutlineColor = color
            newHighlight.FillTransparency = 0.6
            newHighlight.OutlineTransparency = 0.2
            newHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            newHighlight.Parent = character
            HieuDRG.ESPObjects[player] = newHighlight
        end
    end)
end

makeToggle(TabPages["VisualsScroll"], "👥 ESP Players", false, function(state)
    HieuDRG.ESPEnabled = state
    if state then
        for i, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local colorIndex = ((i - 1) % #ESPColors) + 1
                CreateESP(player, ESPColors[colorIndex])
            end
        end
        
        Players.PlayerAdded:Connect(function(player)
            if HieuDRG.ESPEnabled then
                task.wait(2)
                local colorIndex = ((#Players:GetPlayers() - 1) % #ESPColors) + 1
                CreateESP(player, ESPColors[colorIndex])
            end
        end)
    else
        for player, highlight in pairs(HieuDRG.ESPObjects) do
            if highlight and highlight:IsA("Highlight") then
                highlight:Destroy()
            end
        end
        HieuDRG.ESPObjects = {}
    end
end)

makeToggle(TabPages["VisualsScroll"], "📦 ESP Chests", false, function(state)
    HieuDRG.ESPChests = state
    if state then
        HieuDRG.Connections["ESPChests"] = RunService.Heartbeat:Connect(function()
            if HieuDRG.ESPChests then
                local chests = FindChests()
                for _, chest in pairs(chests) do
                    if not chest:FindFirstChild("HieuDRG_ChestESP") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "HieuDRG_ChestESP"
                        highlight.FillColor = Color3.fromRGB(255, 215, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 215, 0)
                        highlight.FillTransparency = 0.7
                        highlight.OutlineTransparency = 0.3
                        highlight.Parent = chest
                    end
                end
            end
        end)
    else
        if HieuDRG.Connections["ESPChests"] then
            HieuDRG.Connections["ESPChests"]:Disconnect()
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "HieuDRG_ChestESP" then
                obj:Destroy()
            end
        end
    end
end)

-- Combat Features
local autoClickConnection
makeToggle(TabPages["CombatScroll"], "🖱️ Auto Click", false, function(state)
    HieuDRG.Settings.AutoClick = state
    if state then
        autoClickConnection = RunService.Heartbeat:Connect(function()
            if HieuDRG.Settings.AutoClick then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0
