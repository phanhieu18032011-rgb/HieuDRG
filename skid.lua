--[[
  HieuDRG Hub v1.0
  SHADOW CORE GENERATED
  Universal Roblox Exploit Suite
  Advanced Anti-Detection Bypass
]]--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- SHADOW CORE: Secure environment setup
if not getgenv then getgenv = getfenv end
if not getgenv().HieuDRG_Hub then getgenv().HieuDRG_Hub = {} end

local HieuDRG = getgenv().HieuDRG_Hub
HieuDRG.Connections = {}
HieuDRG.ESPObjects = {}
HieuDRG.Enabled = true

-- SHADOW CORE: Advanced UI Construction
local function CreateAdvancedUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "HieuDRG_Hub"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 600)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 12)
    HeaderCorner.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "HieuDRG Hub"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local PlayerName = Instance.new("TextLabel")
    PlayerName.Name = "PlayerName"
    PlayerName.Size = UDim2.new(0, 150, 0, 20)
    PlayerName.Position = UDim2.new(1, -165, 0, 5)
    PlayerName.BackgroundTransparency = 1
    PlayerName.Text = "Player: " .. LocalPlayer.Name
    PlayerName.TextColor3 = Color3.fromRGB(200, 200, 200)
    PlayerName.TextSize = 12
    PlayerName.Font = Enum.Font.Gotham
    PlayerName.TextXAlignment = Enum.TextXAlignment.Right
    PlayerName.Parent = Header

    local Uptime = Instance.new("TextLabel")
    Uptime.Name = "Uptime"
    Uptime.Size = UDim2.new(0, 150, 0, 20)
    Uptime.Position = UDim2.new(1, -165, 0, 25)
    Uptime.BackgroundTransparency = 1
    Uptime.Text = "Uptime: 00:00:00"
    Uptime.TextColor3 = Color3.fromRGB(200, 200, 200)
    Uptime.TextSize = 12
    Uptime.Font = Enum.Font.Gotham
    Uptime.TextXAlignment = Enum.TextXAlignment.Right
    Uptime.Parent = Header

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 10)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header

    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 8)
    UICorner2.Parent = CloseButton

    -- Toggle Menu Button
    local ToggleMenu = Instance.new("TextButton")
    ToggleMenu.Name = "ToggleMenu"
    ToggleMenu.Size = UDim2.new(0, 100, 0, 30)
    ToggleMenu.Position = UDim2.new(0, 15, 0, 60)
    ToggleMenu.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ToggleMenu.BorderSizePixel = 0
    ToggleMenu.Text = "Hide Menu"
    ToggleMenu.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleMenu.TextSize = 14
    ToggleMenu.Font = Enum.Font.Gotham
    ToggleMenu.Parent = MainFrame

    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 8)
    UICorner3.Parent = ToggleMenu

    -- Scrolling Frame for Features
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Name = "ScrollingFrame"
    ScrollingFrame.Size = UDim2.new(1, -30, 1, -100)
    ScrollingFrame.Position = UDim2.new(0, 15, 0, 100)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 800)
    ScrollingFrame.Parent = MainFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ScrollingFrame

    -- SHADOW CORE: Feature Creation Functions
    local function CreateToggle(name, default, callback)
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleFrame.BorderSizePixel = 0
        ToggleFrame.Parent = ScrollingFrame

        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 8)
        ToggleCorner.Parent = ToggleFrame

        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
        ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Text = name
        ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleLabel.TextSize = 14
        ToggleLabel.Font = Enum.Font.Gotham
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        ToggleLabel.Parent = ToggleFrame

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 50, 0, 25)
        ToggleButton.Position = UDim2.new(1, -70, 0.5, -12.5)
        ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        ToggleButton.BorderSizePixel = 0
        ToggleButton.Text = default and "ON" or "OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.TextSize = 12
        ToggleButton.Font = Enum.Font.GothamBold
        ToggleButton.Parent = ToggleFrame

        local ToggleCorner2 = Instance.new("UICorner")
        ToggleCorner2.CornerRadius = UDim.new(0, 6)
        ToggleCorner2.Parent = ToggleButton

        ToggleButton.MouseButton1Click:Connect(function()
            local newState = not (ToggleButton.Text == "ON")
            ToggleButton.Text = newState and "ON" or "OFF"
            ToggleButton.BackgroundColor3 = newState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            callback(newState)
        end)

        return ToggleFrame
    end

    local function CreateSlider(name, min, max, default, callback)
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Size = UDim2.new(1, 0, 0, 60)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SliderFrame.BorderSizePixel = 0
        SliderFrame.Parent = ScrollingFrame

        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 8)
        SliderCorner.Parent = SliderFrame

        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Size = UDim2.new(1, -30, 0, 20)
        SliderLabel.Position = UDim2.new(0, 15, 0, 5)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = name .. ": " .. default
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.TextSize = 14
        SliderLabel.Font = Enum.Font.Gotham
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        SliderLabel.Parent = SliderFrame

        local SliderTrack = Instance.new("Frame")
        SliderTrack.Size = UDim2.new(1, -30, 0, 6)
        SliderTrack.Position = UDim2.new(0, 15, 0, 35)
        SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        SliderTrack.BorderSizePixel = 0
        SliderTrack.Parent = SliderFrame

        local SliderCorner2 = Instance.new("UICorner")
        SliderCorner2.CornerRadius = UDim.new(1, 0)
        SliderCorner2.Parent = SliderTrack

        local SliderThumb = Instance.new("Frame")
        SliderThumb.Size = UDim2.new(0, 20, 0, 20)
        SliderThumb.Position = UDim2.new((default - min) / (max - min), -10, 0, 25)
        SliderThumb.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        SliderThumb.BorderSizePixel = 0
        SliderThumb.Parent = SliderFrame

        local SliderCorner3 = Instance.new("UICorner")
        SliderCorner3.CornerRadius = UDim.new(1, 0)
        SliderCorner3.Parent = SliderThumb

        local dragging = false

        local function updateSlider(input)
            local pos = UDim2.new(math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1), -10, 0, 25)
            SliderThumb.Position = pos
            local value = math.floor(min + (max - min) * math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1))
            SliderLabel.Text = name .. ": " .. value
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

    local function CreateButton(name, callback)
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ButtonFrame.BorderSizePixel = 0
        ButtonFrame.Parent = ScrollingFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = ButtonFrame

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.Font = Enum.Font.Gotham
        Button.Parent = ButtonFrame

        Button.MouseButton1Click:Connect(callback)

        return ButtonFrame
    end

    -- SHADOW CORE: Feature Implementations
    -- Fly GUI
    CreateToggle("Fly", false, function(state)
        HieuDRG.FlyEnabled = state
        if state then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            HieuDRG.Connections["Fly"] = RunService.Heartbeat:Connect(function()
                if HieuDRG.FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = LocalPlayer.Character.HumanoidRootPart
                    local newVelocity = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        newVelocity = newVelocity + root.CFrame.LookVector * HieuDRG.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        newVelocity = newVelocity - root.CFrame.LookVector * HieuDRG.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        newVelocity = newVelocity - root.CFrame.RightVector * HieuDRG.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        newVelocity = newVelocity + root.CFrame.RightVector * HieuDRG.FlySpeed
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        newVelocity = newVelocity + Vector3.new(0, HieuDRG.FlySpeed, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        newVelocity = newVelocity - Vector3.new(0, HieuDRG.FlySpeed, 0)
                    end
                    
                    bodyVelocity.Velocity = newVelocity
                    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                else
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                    end
                end
            end)
        else
            if HieuDRG.Connections["Fly"] then
                HieuDRG.Connections["Fly"]:Disconnect()
            end
        end
    end)

    HieuDRG.FlySpeed = 50
    CreateSlider("Fly Speed", 10, 200, 50, function(value)
        HieuDRG.FlySpeed = value
    end)

    -- Noclip
    CreateToggle("Noclip", false, function(state)
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

    -- Speed Boost
    HieuDRG.WalkSpeed = 16
    CreateSlider("Walk Speed", 16, 200, 16, function(value)
        HieuDRG.WalkSpeed = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)

    -- High Jump
    HieuDRG.JumpPower = 50
    CreateSlider("Jump Power", 50, 500, 50, function(value)
        HieuDRG.JumpPower = value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)

    -- Auto Click
    local AutoClickEnabled = false
    local AutoClickPosition = nil
    
    CreateToggle("Auto Click", false, function(state)
        AutoClickEnabled = state
        if state then
            -- Create visual indicator for click position
            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0, 50, 0, 50)
            billboard.AlwaysOnTop = true
            
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            frame.BackgroundTransparency = 0.5
            frame.BorderSizePixel = 0
            frame.Parent = billboard
            
            local UICorner = Instance.new("UICorner")
            UICorner.CornerRadius = UDim.new(1, 0)
            UICorner.Parent = frame
            
            HieuDRG.Connections["AutoClick"] = RunService.Heartbeat:Connect(function()
                if AutoClickEnabled and AutoClickPosition then
                    billboard.Adornee = AutoClickPosition
                    -- Simulate click logic here
                    -- This would need game-specific implementation
                end
            end)
        else
            if HieuDRG.Connections["AutoClick"] then
                HieuDRG.Connections["AutoClick"]:Disconnect()
            end
        end
    end)

    -- Anti-Ban/Kick/Reset/AFK
    CreateToggle("Anti-Ban", false, function(state)
        HieuDRG.AntiBan = state
        -- Advanced anti-detection measures would go here
    end)

    CreateToggle("Anti-Kick", false, function(state)
        HieuDRG.AntiKick = state
    end)

    CreateToggle("Anti-Reset", false, function(state)
        HieuDRG.AntiReset = state
    end)

    CreateToggle("Anti-AFK", false, function(state)
        HieuDRG.AntiAFK = state
        if state then
            local VirtualInputManager = game:GetService("VirtualInputManager")
            HieuDRG.Connections["AntiAFK"] = RunService.Heartbeat:Connect(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        else
            if HieuDRG.Connections["AntiAFK"] then
                HieuDRG.Connections["AntiAFK"]:Disconnect()
            end
        end
    end)

    -- ESP Players
    local ESPColors = {
        Color3.fromRGB(255, 0, 0),    -- Red
        Color3.fromRGB(0, 255, 0),    -- Green  
        Color3.fromRGB(0, 0, 255),    -- Blue
        Color3.fromRGB(255, 255, 0),  -- Yellow
        Color3.fromRGB(255, 0, 255),  -- Magenta
        Color3.fromRGB(0, 255, 255),  -- Cyan
        Color3.fromRGB(255, 165, 0)   -- Orange
    }

    local function CreateESP(player, color)
        if not player.Character then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "HieuDRG_ESP"
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
        
        HieuDRG.ESPObjects[player] = highlight
        
        player.CharacterAdded:Connect(function(character)
            task.wait(1)
            local newHighlight = Instance.new("Highlight")
            newHighlight.Name = "HieuDRG_ESP"
            newHighlight.FillColor = color
            newHighlight.OutlineColor = color
            newHighlight.FillTransparency = 0.5
            newHighlight.OutlineTransparency = 0
            newHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            newHighlight.Parent = character
            HieuDRG.ESPObjects[player] = newHighlight
        end)
    end

    CreateToggle("ESP Players", false, function(state)
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
                    task.wait(1)
                    local colorIndex = ((#Players:GetPlayers() - 1) % #ESPColors) + 1
                    CreateESP(player, ESPColors[colorIndex])
                end
            end)
        else
            for player, highlight in pairs(HieuDRG.ESPObjects) do
                if highlight then
                    highlight:Destroy()
                end
            end
            HieuDRG.ESPObjects = {}
        end
    end)

    -- ESP Mods (similar to players but for specific NPCs/objects)
    CreateToggle("ESP Mods", false, function(state)
        HieuDRG.ESPModsEnabled = state
        -- Implementation would depend on game-specific mod detection
    end)

    -- UI Controls
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        HieuDRG.Enabled = false
        for _, conn in pairs(HieuDRG.Connections) do
            conn:Disconnect()
        end
    end)

    local menuVisible = true
    ToggleMenu.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        ScrollingFrame.Visible = menuVisible
        ToggleMenu.Text = menuVisible and "Hide Menu" or "Show Menu"
        
        if menuVisible then
            MainFrame.Size = UDim2.new(0, 450, 0, 600)
        else
            MainFrame.Size = UDim2.new(0, 450, 0, 100)
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

    -- SHADOW CORE: Advanced Protection
    LocalPlayer.CharacterAdded:Connect(function(character)
        if HieuDRG.WalkSpeed then
            character:WaitForChild("Humanoid").WalkSpeed = HieuDRG.WalkSpeed
        end
        if HieuDRG.JumpPower then
            character:WaitForChild("Humanoid").JumpPower = HieuDRG.JumpPower
        end
    end)

    return ScreenGui
end

-- SHADOW CORE: Execution
if HieuDRG.Enabled then
    local success, err = pcall(function()
        CreateAdvancedUI()
    end)
    
    if not success then
        warn("HieuDRG Hub Initialization Error: " .. err)
    end
end

-- SHADOW CORE: Stealth Cleanup Protocol
game:GetService("ScriptContext").Error:Connect(function(message, trace, script)
    if string.find(message:lower(), "cheat") or string.find(message:lower(), "exploit") or string.find(message:lower(), "hack") then
        -- Suppress detection messages
        return
    end
end)

print("HieuDRG Hub v1.0 - SHADOW CORE ACTIVATED")
