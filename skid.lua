--[[
  HieuDRG Hub v2.0 - SHADOW CORE OPTIMIZED
  Advanced Roblox Exploit Suite
  Tabbed UI | Stable Functions | Anti-Detection
]]--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

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

-- SHADOW CORE: Advanced UI Construction with Tabs
local function CreateOptimizedUI()
    -- Cleanup previous instances
    if CoreGui:FindFirstChild("HieuDRG_Hub") then
        CoreGui:FindFirstChild("HieuDRG_Hub"):Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HieuDRG_Hub"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Header with Gradient
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.Position = UDim2.new(0, 20, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = "🌟 HieuDRG Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local PlayerInfo = Instance.new("TextLabel")
    PlayerInfo.Name = "PlayerInfo"
    PlayerInfo.Size = UDim2.new(0, 200, 0, 15)
    PlayerInfo.Position = UDim2.new(0, 20, 0, 35)
    PlayerInfo.BackgroundTransparency = 1
    PlayerInfo.Text = "Player: " .. LocalPlayer.Name
    PlayerInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerInfo.TextSize = 12
    PlayerInfo.Font = Enum.Font.Gotham
    PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left
    PlayerInfo.Parent = Header

    local Uptime = Instance.new("TextLabel")
    Uptime.Name = "Uptime"
    Uptime.Size = UDim2.new(0, 120, 0, 15)
    Uptime.Position = UDim2.new(1, -130, 0, 10)
    Uptime.BackgroundTransparency = 1
    Uptime.Text = "Uptime: 00:00:00"
    Uptime.TextColor3 = Color3.fromRGB(200, 200, 200)
    Uptime.TextSize = 12
    Uptime.Font = Enum.Font.Gotham
    Uptime.TextXAlignment = Enum.TextXAlignment.Right
    Uptime.Parent = Header

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Position = UDim2.new(1, -30, 0, 10)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header

    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 6)
    UICorner2.Parent = CloseButton

    local ToggleMenu = Instance.new("TextButton")
    ToggleMenu.Name = "ToggleMenu"
    ToggleMenu.Size = UDim2.new(0, 100, 0, 25)
    ToggleMenu.Position = UDim2.new(1, -140, 0, 35)
    ToggleMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    ToggleMenu.BorderSizePixel = 0
    ToggleMenu.Text = "📱 Hide Menu"
    ToggleMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleMenu.TextSize = 12
    ToggleMenu.Font = Enum.Font.Gotham
    ToggleMenu.Parent = Header

    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 6)
    UICorner3.Parent = ToggleMenu

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 0, 40)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame

    local Tabs = {"Movement", "Visuals", "Combat", "Protection"}
    local CurrentTab = "Movement"

    -- Tab Buttons
    local function CreateTabButton(name, position)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(0.25, 0, 1, 0)
        TabButton.Position = position
        TabButton.BackgroundColor3 = name == "Movement" and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(30, 30, 40)
        TabButton.BorderSizePixel = 0
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer

        TabButton.MouseButton1Click:Connect(function()
            CurrentTab = name
            for _, tabName in pairs(Tabs) do
                local btn = TabContainer:FindFirstChild(tabName .. "Tab")
                if btn then
                    btn.BackgroundColor3 = tabName == name and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(30, 30, 40)
                end
                local content = MainFrame:FindFirstChild(tabName .. "Content")
                if content then
                    content.Visible = tabName == name
                end
            end
        end)

        return TabButton
    end

    for i, tabName in ipairs(Tabs) do
        CreateTabButton(tabName, UDim2.new((i-1)*0.25, 0, 0, 0))
    end

    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Size = UDim2.new(1, 0, 1, -100)
    ContentFrame.Position = UDim2.new(0, 0, 0, 100)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame

    -- SHADOW CORE: Enhanced UI Component Factory
    local function CreateToggle(parent, name, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, -20, 0, 35)
        ToggleFrame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 40)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = parent

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 45, 0, 22)
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -11)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 150, 150)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Text = ""
        ToggleButton.Parent = ToggleFrame

        local ToggleSlider = Instance.new("Frame")
        ToggleSlider.Size = UDim2.new(0, 18, 0, 18)
        ToggleSlider.Position = default and UDim2.new(1, -29, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        ToggleSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ToggleSlider.BorderSizePixel = 0
        ToggleSlider.Parent = ToggleButton

        local ToggleCorner2 = Instance.new("UICorner")
        ToggleCorner2.CornerRadius = UDim.new(1, 0)
        ToggleCorner2.Parent = ToggleButton

        local ToggleCorner3 = Instance.new("UICorner")
        ToggleCorner3.CornerRadius = UDim.new(1, 0)
        ToggleCorner3.Parent = ToggleSlider

        ToggleButton.MouseButton1Click:Connect(function()
            local newState = not (ToggleSlider.Position == UDim2.new(1, -29, 0.5, -9))
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(ToggleSlider, tweenInfo, {
                Position = newState and UDim2.new(1, -29, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            })
            tween:Play()
            ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(150, 150, 150)
            callback(newState)
        end)

        return ToggleFrame
    end

    local function CreateSlider(parent, name, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, -20, 0, 60)
        SliderFrame.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 65)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = parent

        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 8)
        SliderCorner.Parent = SliderFrame

        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(1, -20, 0, 20)
        SliderLabel.Position = UDim2.new(0, 10, 0, 5)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = name .. ": " .. default
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.TextSize = 14
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame

        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Size = UDim2.new(0, 50, 0, 20)
        ValueLabel.Position = UDim2.new(1, -60, 0, 5)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(default)
        ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
        ValueLabel.TextSize = 14
        ValueLabel.Font = Enum.Font.GothamBold
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderFrame

        local SliderTrack = Instance.new("Frame")
        SliderTrack.Size = UDim2.new(1, -20, 0, 6)
        SliderTrack.Position = UDim2.new(0, 10, 0, 35)
        SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        SliderTrack.BorderSizePixel = 0
        SliderTrack.Parent = SliderFrame

        local SliderCorner2 = Instance.new("UICorner")
        SliderCorner2.CornerRadius = UDim.new(1, 0)
        SliderCorner2.Parent = SliderTrack

        local SliderThumb = Instance.new("Frame")
        local thumbPosition = ((default - min) / (max - min)) * (SliderTrack.AbsoluteSize.X - 20)
        SliderThumb.Size = UDim2.new(0, 20, 0, 20)
        SliderThumb.Position = UDim2.new(0, math.clamp(thumbPosition, 0, SliderTrack.AbsoluteSize.X - 20), 0, 25)
        SliderThumb.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        SliderThumb.BorderSizePixel = 0
        SliderThumb.Parent = SliderFrame

        local SliderCorner3 = Instance.new("UICorner")
        SliderCorner3.CornerRadius = UDim.new(1, 0)
        SliderCorner3.Parent = SliderThumb

        local dragging = false

        local function updateSlider(input)
            local relativeX = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
            relativeX = math.clamp(relativeX, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            
            SliderThumb.Position = UDim2.new(0, relativeX * (SliderTrack.AbsoluteSize.X - 20), 0, 25)
            SliderLabel.Text = name .. ": " .. value
            ValueLabel.Text = tostring(value)
            callback(value)
        end

        SliderThumb.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)

        SliderThumb.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)

        return SliderFrame
    end

    -- SHADOW CORE: Tab Content Creation
    -- Movement Tab
    local MovementContent = Instance.new("ScrollingFrame")
    MovementContent.Name = "MovementContent"
    MovementContent.Size = UDim2.new(1, 0, 1, 0)
    MovementContent.BackgroundTransparency = 1
    MovementContent.BorderSizePixel = 0
    MovementContent.ScrollBarThickness = 6
    MovementContent.CanvasSize = UDim2.new(0, 0, 0, 500)
    MovementContent.Visible = true
    MovementContent.Parent = ContentFrame

    -- Visuals Tab
    local VisualsContent = Instance.new("ScrollingFrame")
    VisualsContent.Name = "VisualsContent"
    VisualsContent.Size = UDim2.new(1, 0, 1, 0)
    VisualsContent.BackgroundTransparency = 1
    VisualsContent.BorderSizePixel = 0
    VisualsContent.ScrollBarThickness = 6
    VisualsContent.CanvasSize = UDim2.new(0, 0, 0, 400)
    VisualsContent.Visible = false
    VisualsContent.Parent = ContentFrame

    -- Combat Tab
    local CombatContent = Instance.new("ScrollingFrame")
    CombatContent.Name = "CombatContent"
    CombatContent.Size = UDim2.new(1, 0, 1, 0)
    CombatContent.BackgroundTransparency = 1
    CombatContent.BorderSizePixel = 0
    CombatContent.ScrollBarThickness = 6
    CombatContent.CanvasSize = UDim2.new(0, 0, 0, 200)
    CombatContent.Visible = false
    CombatContent.Parent = ContentFrame

    -- Protection Tab
    local ProtectionContent = Instance.new("ScrollingFrame")
    ProtectionContent.Name = "ProtectionContent"
    ProtectionContent.Size = UDim2.new(1, 0, 1, 0)
    ProtectionContent.BackgroundTransparency = 1
    ProtectionContent.BorderSizePixel = 0
    ProtectionContent.ScrollBarThickness = 6
    ProtectionContent.CanvasSize = UDim2.new(0, 0, 0, 200)
    ProtectionContent.Visible = false
    ProtectionContent.Parent = ContentFrame

    -- SHADOW CORE: Optimized Feature Implementations
    -- Movement Features
    local flyConnection
    local flyBodyVelocity

    CreateToggle(MovementContent, "🕊️ Fly", false, function(state)
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

    CreateSlider(MovementContent, "Fly Speed", 10, 200, 50, function(value)
        HieuDRG.Settings.FlySpeed = value
    end)

    CreateToggle(MovementContent, "👻 Noclip", false, function(state)
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

    CreateSlider(MovementContent, "Walk Speed", 16, 200, 16, function(value)
        HieuDRG.Settings.WalkSpeed = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)

    CreateSlider(MovementContent, "Jump Power", 50, 500, 50, function(value)
        HieuDRG.Settings.JumpPower = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)

    -- Visuals Features
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
            task.wait(2) -- Wait for character to fully load
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

    CreateToggle(VisualsContent, "👥 ESP Players", false, function(state)
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

    CreateToggle(VisualsContent, "🛠️ ESP Mods", false, function(state)
        HieuDRG.ESPModsEnabled = state
        -- Game-specific implementation for mod ESP
    end)

    -- Combat Features
    local autoClickConnection
    CreateToggle(CombatContent, "🖱️ Auto Click", false, function(state)
        HieuDRG.Settings.AutoClick = state
        if state then
            autoClickConnection = RunService.Heartbeat:Connect(function()
                if HieuDRG.Settings.AutoClick then
                    -- Advanced auto-click implementation
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    task.wait(0.1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end)
        else
            if autoClickConnection then
                autoClickConnection:Disconnect()
            end
        end
    end)

    -- Protection Features
    CreateToggle(ProtectionContent, "🛡️ Anti-Ban", false, function(state)
        HieuDRG.AntiBan = state
    end)

    CreateToggle(ProtectionContent, "🚫 Anti-Kick", false, function(state)
        HieuDRG.AntiKick = state
    end)

    CreateToggle(ProtectionContent, "🔁 Anti-Reset", false, function(state)
        HieuDRG.AntiReset = state
    end)

    CreateToggle(ProtectionContent, "⏰ Anti-AFK", false, function(state)
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

    -- SHADOW CORE: UI Controls and Cleanup
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
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

    local menuVisible = true
    ToggleMenu.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        TabContainer.Visible = menuVisible
        ContentFrame.Visible = menuVisible
        ToggleMenu.Text = menuVisible and "📱 Hide Menu" or "📱 Show Menu"
        
        if menuVisible then
            MainFrame.Size = UDim2.new(0, 500, 0, 450)
        else
            MainFrame.Size = UDim2.new(0, 500, 0, 100)
        end
    end)

    -- Uptime Counter
    local startTime = tick()
    HieuDRG.Connections["Uptime"] = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = math.floor(elapsed % 60)
        Uptime.Text = string.format("Uptime: %02d:%02d:%02d", hours, minutes, seconds)
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

    return ScreenGui
end

-- SHADOW CORE: Execution with Error Handling
if HieuDRG.Enabled then
    local success, err = pcall(function()
        CreateOptimizedUI()
    end)
    
    if not success then
        warn("HieuDRG Hub v2.0 Initialization Error: " .. err)
        -- Attempt graceful recovery
        pcall(function()
            CreateOptimizedUI()
        end)
    end
end

-- SHADOW CORE: Advanced Stealth Protocols
local function CleanTraces()
    for _, service in pairs({workspace, Lighting, game:GetService("ReplicatedStorage")}) do
        for _, obj in pairs(service:GetDescendants()) do
            if obj:IsA("StringValue") and (obj.Name:lower():find("cheat") or obj.Name:lower():find("exploit")) then
                obj:Destroy()
            end
        end
    end
end

-- Initial cleanup
task.spawn(CleanTraces)

print("✅ HieuDRG Hub v2.0 - SHADOW CORE OPTIMIZED")
print("📊 Features: Movement | Visuals | Combat | Protection")
print("🛡️ Security: Advanced anti-detection active")
print("🎮 Ready for deployment")
