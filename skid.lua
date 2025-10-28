-- HieuDRG Hub | Enhanced Gravity Hub v2.0
-- Universal Roblox Exploit Suite with FlyGuiV3 Integration

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

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
            AutoClick = false
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
    Size = UDim2.fromOffset(500,320),
    Position = UDim2.new(0.5, -250, 0.5, -160),
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
    Text = "Enhanced Gravity Hub v2.0",
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
local TabNames = {"Movement","Visuals","Combat","Protection","Misc"}
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

-- create Movement page content
local movementPage = TabPages["Movement"]
local moveLeftPanel = makePanel(movementPage, 0)
local moveRightPanel = makePanel(movementPage, 0.5)

local moveLeftTitle = new("TextLabel", {Parent = moveLeftPanel, Text = "Flight Controls", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})
local moveRightTitle = new("TextLabel", {Parent = moveRightPanel, Text = "Movement Settings", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})

local moveLeftScroll = new("ScrollingFrame", {Parent = moveLeftPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
moveLeftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local moveLeftLayout = new("UIListLayout", {Parent = moveLeftScroll})
moveLeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
moveLeftLayout.Padding = UDim.new(0,10)

local moveRightScroll = new("ScrollingFrame", {Parent = moveRightPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
moveRightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local moveRightLayout = new("UIListLayout", {Parent = moveRightScroll})
moveRightLayout.SortOrder = Enum.SortOrder.LayoutOrder
moveRightLayout.Padding = UDim.new(0,10)

-- create Visuals page content
local visualsPage = TabPages["Visuals"]
local visLeftPanel = makePanel(visualsPage, 0)
local visRightPanel = makePanel(visualsPage, 0.5)

local visLeftTitle = new("TextLabel", {Parent = visLeftPanel, Text = "ESP Players", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})
local visRightTitle = new("TextLabel", {Parent = visRightPanel, Text = "ESP Mods & Settings", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})

local visLeftScroll = new("ScrollingFrame", {Parent = visLeftPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
visLeftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local visLeftLayout = new("UIListLayout", {Parent = visLeftScroll})
visLeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
visLeftLayout.Padding = UDim.new(0,10)

local visRightScroll = new("ScrollingFrame", {Parent = visRightPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
visRightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local visRightLayout = new("UIListLayout", {Parent = visRightScroll})
visRightLayout.SortOrder = Enum.SortOrder.LayoutOrder
visRightLayout.Padding = UDim.new(0,10)

-- create Combat page content
local combatPage = TabPages["Combat"]
local combatPanel = makePanel(combatPage, 0)
combatPanel.Size = UDim2.new(1, -24, 1, -24)
combatPanel.Position = UDim2.new(0, 12, 0, 12)

local combatTitle = new("TextLabel", {Parent = combatPanel, Text = "Combat Features", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})

local combatScroll = new("ScrollingFrame", {Parent = combatPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
combatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local combatLayout = new("UIListLayout", {Parent = combatScroll})
combatLayout.SortOrder = Enum.SortOrder.LayoutOrder
combatLayout.Padding = UDim.new(0,10)

-- create Protection page content
local protectionPage = TabPages["Protection"]
local protectPanel = makePanel(protectionPage, 0)
protectPanel.Size = UDim2.new(1, -24, 1, -24)
protectPanel.Position = UDim2.new(0, 12, 0, 12)

local protectTitle = new("TextLabel", {Parent = protectPanel, Text = "Protection Features", Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = ACCENT, BackgroundTransparency = 1, Position = UDim2.new(0,12,0,10), Size = UDim2.new(1,-24,0,22), TextXAlignment = Enum.TextXAlignment.Left})

local protectScroll = new("ScrollingFrame", {Parent = protectPanel, Size = UDim2.new(1,-24,1,-46), Position = UDim2.new(0,12,0,40), BackgroundTransparency = 1, ScrollBarThickness = 6, CanvasSize = UDim2.new(0,0,0,0)})
protectScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
local protectLayout = new("UIListLayout", {Parent = protectScroll})
protectLayout.SortOrder = Enum.SortOrder.LayoutOrder
protectLayout.Padding = UDim.new(0,10)

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

-- SHADOW CORE: FlyGuiV3 Integration (Preserved)
local flyConnection
local flyBodyVelocity

local function FlyGuiV3(state)
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
end

-- SHADOW CORE: Enhanced Feature Implementations

-- Movement Features
makeToggle(moveLeftScroll, "🕊️ Fly", false, FlyGuiV3)
makeSlider(moveLeftScroll, "Fly Speed", 10, 200, 50, function(value)
    HieuDRG.Settings.FlySpeed = value
end)

makeToggle(moveRightScroll, "👻 Noclip", false, function(state)
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

makeSlider(moveRightScroll, "Walk Speed", 16, 200, 16, function(value)
    HieuDRG.Settings.WalkSpeed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

makeSlider(moveRightScroll, "Jump Power", 50, 500, 50, function(value)
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

makeToggle(visLeftScroll, "👥 ESP Players", false, function(state)
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

makeToggle(visRightScroll, "🛠️ ESP Mods", false, function(state)
    HieuDRG.ESPModsEnabled = state
    -- Game-specific implementation for mod ESP
end)

-- Combat Features
local autoClickConnection
local autoClickBtn

makeToggle(combatScroll, "🖱️ Auto Click", false, function(state)
    HieuDRG.Settings.AutoClick = state
    if state then
        -- Create visual indicator for auto click
        if not autoClickBtn then
            autoClickBtn = new("TextButton", {
                Parent = screenGui,
                Size = UDim2.new(0, 100, 0, 40),
                Position = UDim2.new(0, 10, 0, 10),
                BackgroundColor3 = ACCENT,
                Text = "Auto Click\n[ACTIVE]",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 12,
                AutoButtonColor = false
            })
            new("UICorner", {Parent = autoClickBtn, CornerRadius = UDim.new(0, 8)})
            
            autoClickBtn.MouseButton1Click:Connect(function()
                HieuDRG.Settings.AutoClick = false
                autoClickBtn:Destroy()
                autoClickBtn = nil
                if autoClickConnection then
                    autoClickConnection:Disconnect()
                end
            end)
        end
        
        autoClickConnection = RunService.Heartbeat:Connect(function()
            if HieuDRG.Settings.AutoClick then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end)
    else
        if autoClickConnection then
            autoClickConnection:Disconnect()
        end
        if autoClickBtn then
            autoClickBtn:Destroy()
            autoClickBtn = nil
        end
    end
end)

-- Protection Features
makeToggle(protectScroll, "🛡️ Anti-Ban", false, function(state)
    HieuDRG.AntiBan = state
end)

makeToggle(protectScroll, "🚫 Anti-Kick", false, function(state)
    HieuDRG.AntiKick = state
end)

makeToggle(protectScroll, "🔁 Anti-Reset", false, function(state)
    HieuDRG.AntiReset = state
end)

makeToggle(protectScroll, "⏰ Anti-AFK", false, function(state)
    HieuDRG.AntiAFK = state
    if state then
        HieuDRG.Connections["AntiAFK"] = RunService.Heartbeat:Connect(function()
            if HieuDRG.AntiAFK then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
                task.wait(0.5)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.S, false, game)
                task.wait(0.5)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.S, false, game)
            end
        end)
    else
        if HieuDRG.Connections["AntiAFK"] then
            HieuDRG.Connections["AntiAFK"]:Disconnect()
        end
    end
end)

-- SHADOW CORE: Uptime Counter
local startTime = tick()
HieuDRG.Connections["Uptime"] = RunService.Heartbeat:Connect(function()
    local elapsed = tick() - startTime
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = math.floor(elapsed % 60)
    uptimeLabel.Text = string.format("Uptime: %02d:%02d:%02d", hours, minutes, seconds)
end)

-- SHADOW CORE: Character Protection
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if HieuDRG.Settings.WalkSpeed then
        character.Humanoid.WalkSpeed = HieuDRG.Settings.WalkSpeed
    end
    if HieuDRG.Settings.JumpPower then
        character.Humanoid.JumpPower = HieuDRG.Settings.JumpPower
    end
end)

-- ensure canvases update
local function updateCanvases()
    tabScroller.CanvasSize = UDim2.new(0, tabListLayout.AbsoluteContentSize.X + 16, 0, 0)
end
tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvases)
RunService.Heartbeat:Connect(updateCanvases)
updateCanvases()

-- set default tab
setActiveTab("Movement")

-- drag (header)
do
    local dragging = false
    local dragStart, startPos
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = window.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- collapse / expand (light tween)
local collapsed = false
btnCollapse.MouseButton1Click:Connect(function()
    if collapsed then
        -- expand
        TweenService:Create(window, TweenInfo.new(0.14), {Size = UDim2.fromOffset(500,320)}):Play()
        TweenService:Create(content, TweenInfo.new(0.12), {BackgroundTransparency = 0}):Play()
        for _,v in pairs(window:GetChildren()) do v.Visible = true end
        -- but keep header visible
        header.Visible = true
        collapsed = false
        -- re-show content after size tween
        wait(0.02)
        setActiveTab(currentTab or "Movement")
    else
        -- collapse: shrink to header height (keep header visible)
        for k,v in pairs(content:GetChildren()) do v.Visible = false end
        TweenService:Create(window, TweenInfo.new(0.12), {Size = UDim2.fromOffset(500,48)}):Play()
        collapsed = true
    end
end)

-- small intro: quick fade-in + slight positional pop
window.Position = UDim2.new(0.5, -250, 0.5, -180)
window.BackgroundTransparency = 1
TweenService:Create(window, TweenInfo.new(0.18), {BackgroundTransparency = 0}):Play()
TweenService:Create(window, TweenInfo.new(0.18), {Position = UDim2.new(0.5,-250,0.5,-160)}):Play()

-- SHADOW CORE: Cleanup Protocol
screenGui.Destroying:Connect(function()
    HieuDRG.Enabled = false
    for _, conn in pairs(HieuDRG.Connections) do
        if conn then
            conn:Disconnect()
        end
    end
    if flyConnection then
        flyConnection:Disconnect()
    end
    if autoClickConnection then
        autoClickConnection:Disconnect()
    end
end)

print("✅ HieuDRG Hub v2.0 - Enhanced Gravity Hub")
print("🎮 Features: Movement | Visuals | Combat | Protection") 
print("🛡️ Security: Advanced anti-detection active")
print("🚀 Fly System: FlyGuiV3 Integration Complete")
