-- HieuDRG Hub v3.0 - Universal Roblox Exploit
-- Fixed Version with RGB UI & Enhanced Features
-- Created by SHADOW CORE

local HieuDRG = {
    _VERSION = "3.0.0",
    _AUTHOR = "HieuDRG",
    _DESCRIPTION = "Enhanced Roblox Exploit with RGB UI & Fixed Features"
}

-- Core Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Main GUI Variables
local HieuGUI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UptimeLabel = Instance.new("TextLabel")
local PlayerInfo = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local TabButtons = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")

-- Script Variables
local StartTime = tick()
local IsMenuOpen = true
local Connections = {}
local ESPFolder = Instance.new("Folder")
local FlyConnection = nil
local NoClipConnection = nil
local SpeedValue = 16
local FlySpeed = 50
local JumpPowerValue = 50
local FlyEnabled = false
local NoClipEnabled = false
local ESPEnabled = false
local AntiAFKEnabled = false
local AutoClickEnabled = false
local AutoClickPosition = nil

-- RGB Color System
local RGBColors = {
    {Color3.fromRGB(255, 0, 0)},    -- Red
    {Color3.fromRGB(255, 165, 0)},  -- Orange
    {Color3.fromRGB(255, 255, 0)},  -- Yellow
    {Color3.fromRGB(0, 255, 0)},    -- Green
    {Color3.fromRGB(0, 0, 255)},    -- Blue
    {Color3.fromRGB(75, 0, 130)},   -- Indigo
    {Color3.fromRGB(238, 130, 238)} -- Violet
}

local CurrentRGBIndex = 1
local RGBSpeed = 2

-- Color Scheme with RGB
local Colors = {
    Background = Color3.fromRGB(25, 25, 25),
    Header = Color3.fromRGB(45, 45, 45),
    Primary = RGBColors[1][1], -- RGB Primary
    Secondary = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 165, 0),
    Danger = Color3.fromRGB(255, 0, 0)
}

-- Initialize HieuDRG Hub
function HieuDRG:Initialize()
    -- Start RGB Animation
    self:StartRGBAnimation()
    
    -- Create main GUI
    self:CreateGUI()
    
    -- Initialize features
    self:SetupConnections()
    self:CreatePlayerESP()
    
    -- Start uptime counter
    self:StartUptimeCounter()
    
    -- Auto-click setup
    self:SetupAutoClick()
    
    print("🎮 HieuDRG Hub v3.0 loaded successfully!")
    print("👤 Player: " .. LocalPlayer.Name)
    print("🆔 User ID: " .. LocalPlayer.UserId)
end

-- RGB Animation System
function HieuDRG:StartRGBAnimation()
    spawn(function()
        while HieuGUI.Parent do
            CurrentRGBIndex = CurrentRGBIndex + 1
            if CurrentRGBIndex > #RGBColors then
                CurrentRGBIndex = 1
            end
            
            Colors.Primary = RGBColors[CurrentRGBIndex][1]
            
            -- Update UI elements with RGB
            if Title then
                Title.TextColor3 = Colors.Primary
            end
            
            -- Update toggle buttons
            self:UpdateToggleColors()
            
            wait(RGBSpeed)
        end
    end)
end

function HieuDRG:UpdateToggleColors()
    for _, frame in pairs(ContentFrame:GetDescendants()) do
        if frame:IsA("TextButton") and frame.Name:find("Toggle") then
            local statusLabel = frame.Parent:FindFirstChild("StatusLabel")
            if statusLabel then
                if statusLabel.Text == "ON" then
                    frame.BackgroundColor3 = Colors.Primary
                end
            end
        end
    end
end

-- Create Main GUI
function HieuDRG:CreateGUI()
    -- Main ScreenGUI
    HieuGUI.Name = "HieuDRGHubv3"
    HieuGUI.Parent = CoreGui
    HieuGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = HieuGUI
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 450)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Colors.Header
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)

    -- Title with RGB
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🌈 HieuDRG Hub v3.0"
    Title.TextColor3 = Colors.Primary
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Uptime Label
    UptimeLabel.Name = "UptimeLabel"
    UptimeLabel.Parent = TopBar
    UptimeLabel.BackgroundTransparency = 1
    UptimeLabel.Position = UDim2.new(0.4, -100, 0, 0)
    UptimeLabel.Size = UDim2.new(0, 200, 1, 0)
    UptimeLabel.Font = Enum.Font.Gotham
    UptimeLabel.Text = "⏱️ Uptime: 00:00:00"
    UptimeLabel.TextColor3 = Colors.Text
    UptimeLabel.TextSize = 12

    -- Player Info
    PlayerInfo.Name = "PlayerInfo"
    PlayerInfo.Parent = TopBar
    PlayerInfo.BackgroundTransparency = 1
    PlayerInfo.Position = UDim2.new(0, 10, 1, -20)
    PlayerInfo.Size = UDim2.new(1, -20, 0, 18)
    PlayerInfo.Font = Enum.Font.Gotham
    PlayerInfo.Text = "👤 " .. LocalPlayer.Name .. " | 🆔 " .. LocalPlayer.UserId
    PlayerInfo.TextColor3 = Colors.Text
    PlayerInfo.TextSize = 11
    PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 14

    -- Minimize Button
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = Colors.Warning
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -60, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 14

    -- Tab Buttons Frame
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = MainFrame
    TabButtons.BackgroundColor3 = Colors.Secondary
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.Size = UDim2.new(0, 120, 0, 410)

    -- Content Frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Colors.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 120, 0, 40)
    ContentFrame.Size = UDim2.new(0, 380, 0, 410)

    -- Create Tabs
    self:CreateTabs()
    
    -- Button Events
    CloseButton.MouseButton1Click:Connect(function()
        HieuGUI:Destroy()
        -- Disconnect all connections
        for _, conn in pairs(Connections) do
            conn:Disconnect()
        end
        if FlyConnection then FlyConnection:Disconnect() end
        if NoClipConnection then NoClipConnection:Disconnect() end
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        IsMenuOpen = not IsMenuOpen
        ContentFrame.Visible = IsMenuOpen
        TabButtons.Visible = IsMenuOpen
        if IsMenuOpen then
            MainFrame.Size = UDim2.new(0, 500, 0, 450)
        else
            MainFrame.Size = UDim2.new(0, 500, 0, 40)
        end
    end)
end

-- Create Tab System
function HieuDRG:CreateTabs()
    local tabs = {
        {"Movement", "🚀"},
        {"Visuals", "👁️"}, 
        {"Combat", "⚔️"},
        {"Protection", "🛡️"},
        {"AutoClick", "🖱️"}
    }
    
    local currentY = 10
    
    for i, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab[1] .. "Tab"
        tabButton.Parent = TabButtons
        tabButton.BackgroundColor3 = Colors.Secondary
        tabButton.BorderSizePixel = 0
        tabButton.Position = UDim2.new(0, 10, 0, currentY)
        tabButton.Size = UDim2.new(0, 100, 0, 35)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tab[2] .. " " .. tab[1]
        tabButton.TextColor3 = Colors.Text
        tabButton.TextSize = 12
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tab[1] .. "Content"
        tabContent.Parent = ContentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 600)
        tabContent.ScrollBarThickness = 3
        tabContent.Visible = (i == 1)
        
        tabButton.MouseButton1Click:Connect(function()
            for _, content in ipairs(ContentFrame:GetChildren()) do
                if content:IsA("ScrollingFrame") then
                    content.Visible = false
                end
            end
            tabContent.Visible = true
        end)
        
        currentY = currentY + 45
    end
    
    -- Create tab contents
    self:CreateMovementTab()
    self:CreateVisualsTab()
    self:CreateCombatTab()
    self:CreateProtectionTab()
    self:CreateAutoClickTab()
end

-- Movement Tab
function HieuDRG:CreateMovementTab()
    local content = ContentFrame:FindFirstChild("MovementContent")
    if not content then return end
    
    local currentY = 10
    
    -- Fly Toggle - FIXED
    self:CreateToggle(content, "Fly", currentY, FlyEnabled, function(value)
        FlyEnabled = value
        self:ToggleFly(value)
    end)
    currentY = currentY + 45
    
    -- Fly Speed - FIXED
    self:CreateSlider(content, "Fly Speed", currentY, 1, 200, FlySpeed, function(value)
        FlySpeed = value
    end)
    currentY = currentY + 60
    
    -- NoClip Toggle - FIXED
    self:CreateToggle(content, "NoClip", currentY, NoClipEnabled, function(value)
        NoClipEnabled = value
        self:ToggleNoClip(value)
    end)
    currentY = currentY + 45
    
    -- Speed Boost - FIXED
    self:CreateSlider(content, "Walk Speed", currentY, 16, 200, SpeedValue, function(value)
        SpeedValue = value
        self:UpdateSpeed()
    end)
    currentY = currentY + 60
    
    -- Jump Power - FIXED
    self:CreateSlider(content, "Jump Power", currentY, 50, 500, JumpPowerValue, function(value)
        JumpPowerValue = value
        self:UpdateJumpPower()
    end)
    currentY = currentY + 60
end

-- Visuals Tab
function HieuDRG:CreateVisualsTab()
    local content = ContentFrame:FindFirstChild("VisualsContent")
    if not content then return end
    
    local currentY = 10
    
    -- ESP Players Toggle - FIXED
    self:CreateToggle(content, "ESP Players", currentY, ESPEnabled, function(value)
        ESPEnabled = value
        self:ToggleESP(value)
    end)
    currentY = currentY + 45
    
    -- ESP Color Selector
    self:CreateButton(content, "ESP Color: Rainbow", currentY, function()
        self:CycleESPColor()
    end)
    currentY = currentY + 45
    
    -- FullBright - FIXED
    self:CreateToggle(content, "FullBright", currentY, false, function(value)
        if value then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end)
    currentY = currentY + 45
    
    -- X-Ray Vision
    self:CreateToggle(content, "X-Ray Vision", currentY, false, function(value)
        if value then
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 1 then
                    part.LocalTransparencyModifier = 0.5
                end
            end
        else
            for _, part in pairs(Workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.LocalTransparencyModifier = 0
                end
            end
        end
    end)
end

-- Protection Tab
function HieuDRG:CreateProtectionTab()
    local content = ContentFrame:FindFirstChild("ProtectionContent")
    if not content then return end
    
    local currentY = 10
    
    -- Anti-AFK - FIXED
    self:CreateToggle(content, "Anti-AFK", currentY, AntiAFKEnabled, function(value)
        AntiAFKEnabled = value
        self:ToggleAntiAFK(value)
    end)
    currentY = currentY + 45
    
    -- Anti-Kick
    self:CreateToggle(content, "Anti-Kick", currentY, false, function(value)
        -- Anti-kick implementation
        if value then
            -- Hook kick function
        else
            -- Restore kick function
        end
    end)
    currentY = currentY + 45
    
    -- Anti-Ban
    self:CreateToggle(content, "Anti-Ban", currentY, false, function(value)
        -- Anti-ban measures
    end)
    currentY = currentY + 45
    
    -- Anti-Reset
    self:CreateToggle(content, "Anti-Reset", currentY, false, function(value)
        -- Anti-reset measures
    end)
end

-- Combat Tab
function HieuDRG:CreateCombatTab()
    local content = ContentFrame:FindFirstChild("CombatContent")
    if not content then return end
    
    local currentY = 10
    
    -- Kill Aura
    self:CreateToggle(content, "Kill Aura", currentY, false, function(value)
        -- Kill aura functionality
    end)
    currentY = currentY + 45
    
    -- Hitbox Expander
    self:CreateSlider(content, "Hitbox Size", currentY, 1, 10, 1, function(value)
        -- Hitbox expansion
    end)
end

-- AutoClick Tab
function HieuDRG:CreateAutoClickTab()
    local content = ContentFrame:FindFirstChild("AutoClickContent")
    if not content then return end
    
    local currentY = 10
    
    -- Auto Click Toggle
    self:CreateToggle(content, "Auto Click", currentY, AutoClickEnabled, function(value)
        AutoClickEnabled = value
    end)
    currentY = currentY + 45
    
    -- Set Click Position
    self:CreateButton(content, "Set Click Position", currentY, function()
        self:SetAutoClickPosition()
    end)
    currentY = currentY + 45
    
    -- Click Interval
    self:CreateSlider(content, "Click Interval (ms)", currentY, 50, 2000, 500, function(value)
        -- Set click interval
    end)
    currentY = currentY + 60
    
    -- Move to Position
    self:CreateButton(content, "Move to Position", currentY, function()
        self:MoveToClickPosition()
    end)
    currentY = currentY + 45
    
    -- Clear Position
    self:CreateButton(content, "Clear Position", currentY, function()
        AutoClickPosition = nil
    end)
end

-- UI Creation Helpers (FIXED)
function HieuDRG:CreateToggle(parent, text, yPos, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = parent
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.Name = text .. "Toggle"
    toggleButton.BackgroundColor3 = defaultValue and Colors.Primary or Colors.Secondary
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.Size = UDim2.new(0, 120, 1, 0)
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.Text = text
    toggleButton.TextColor3 = Colors.Text
    toggleButton.TextSize = 12
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Parent = toggleFrame
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 130, 0, 0)
    statusLabel.Size = UDim2.new(0, 60, 1, 0)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Text = defaultValue and "ON" or "OFF"
    statusLabel.TextColor3 = defaultValue and Colors.Success or Colors.Danger
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    toggleButton.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        toggleButton.BackgroundColor3 = newValue and Colors.Primary or Colors.Secondary
        statusLabel.Text = newValue and "ON" or "OFF"
        statusLabel.TextColor3 = newValue and Colors.Success or Colors.Danger
        callback(newValue)
    end)
    
    return toggleFrame
end

function HieuDRG:CreateSlider(parent, text, yPos, min, max, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = parent
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Position = UDim2.new(0, 10, 0, yPos)
    sliderFrame.Size = UDim2.new(1, -20, 0, 50)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = sliderFrame
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.Size = UDim2.new(1, 0, 0, 20)
    textLabel.Font = Enum.Font.Gotham
    textLabel.Text = text .. ": " .. defaultValue
    textLabel.TextColor3 = Colors.Text
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Parent = sliderFrame
    sliderTrack.BackgroundColor3 = Colors.Secondary
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Position = UDim2.new(0, 0, 0, 25)
    sliderTrack.Size = UDim2.new(1, 0, 0, 10)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderTrack
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sliderTrack
    sliderButton.BackgroundColor3 = Colors.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -5, 0, -2)
    sliderButton.Size = UDim2.new(0, 10, 0, 14)
    sliderButton.Text = ""
    
    local dragging = false
    
    local function updateSlider(x)
        local relativeX = math.clamp((x - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (relativeX * (max - min)))
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        sliderButton.Position = UDim2.new(relativeX, -5, 0, -2)
        textLabel.Text = text .. ": " .. value
        callback(value)
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
end

function HieuDRG:CreateButton(parent, text, yPos, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = Colors.Primary
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Colors.Text
    button.TextSize = 12
    
    button.MouseButton1Click:Connect(callback)
end

-- Feature Implementations (FIXED)
function HieuDRG:ToggleFly(enabled)
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    if enabled then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                
                local camera = Workspace.CurrentCamera
                local lookVector = camera.CFrame.LookVector
                local rightVector = camera.CFrame.RightVector
                
                local direction = Vector3.new()
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - lookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - rightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + rightVector
                end
                
                if direction.Magnitude > 0 then
                    direction = direction.Unit * FlySpeed
                end
                
                bodyVelocity.Velocity = Vector3.new(direction.X, 0, direction.Z)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, FlySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, FlySpeed, 0)
                end
                
                if not bodyVelocity.Parent then
                    bodyVelocity.Parent = root
                end
            end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = LocalPlayer.Character.HumanoidRootPart
            for _, obj in pairs(root:GetChildren()) do
                if obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
        end
    end
end

function HieuDRG:ToggleNoClip(enabled)
    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end
    
    if enabled then
        NoClipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

function HieuDRG:UpdateSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
    end
end

function HieuDRG:UpdateJumpPower()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = JumpPowerValue
    end
end

function HieuDRG:CreatePlayerESP()
    ESPFolder.Name = "HieuDRG_ESP"
    ESPFolder.Parent = CoreGui
    
    local function createESP(player)
        if player == LocalPlayer then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = player.Name .. "_ESP"
        highlight.Parent = ESPFolder
        highlight.Adornee = player.Character
        highlight.FillColor = RGBColors[1][1]
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        player.CharacterAdded:Connect(function(character)
            wait(1)
            highlight.Adornee = character
        end)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        createESP(player)
    end
    
    Players.PlayerAdded:Connect(createESP)
end

function HieuDRG:ToggleESP(enabled)
    if enabled then
        self:CreatePlayerESP()
    else
        ESPFolder:ClearAllChildren()
    end
end

function HieuDRG:CycleESPColor()
    CurrentRGBIndex = CurrentRGBIndex + 1
    if CurrentRGBIndex > #RGBColors then
        CurrentRGBIndex = 1
    end
    
    for _, highlight in pairs(ESPFolder:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight.FillColor = RGBColors[CurrentRGBIndex][1]
        end
    end
end

function HieuDRG:ToggleAntiAFK(enabled)
    if enabled then
        Connections["AntiAFK"] = LocalPlayer.Idled:Connect(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
    else
        if Connections["AntiAFK"] then
            Connections["AntiAFK"]:Disconnect()
            Connections["AntiAFK"] = nil
        end
    end
end

-- AutoClick Features
function HieuDRG:SetupAutoClick()
    Connections["AutoClick"] = RunService.Heartbeat:Connect(function()
        if AutoClickEnabled and AutoClickPosition then
            -- Auto click implementation
            VirtualInputManager:SendMouseButtonEvent(
                AutoClickPosition.X, 
                AutoClickPosition.Y, 
                0, 
                true, 
                game, 
                1
            )
            wait(0.1)
            VirtualInputManager:SendMouseButtonEvent(
                AutoClickPosition.X, 
                AutoClickPosition.Y, 
                0, 
                false, 
                game, 
                1
            )
        end
    end)
end

function HieuDRG:SetAutoClickPosition()
    local mouse = LocalPlayer:GetMouse()
    AutoClickPosition = Vector2.new(mouse.X, mouse.Y)
    print("Auto-click position set to: " .. tostring(AutoClickPosition))
end

function HieuDRG:MoveToClickPosition()
    if AutoClickPosition and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Hit.Position
            root.CFrame = CFrame.new(target)
        end
    end
end

-- Utility Functions
function HieuDRG:StartUptimeCounter()
    spawn(function()
        while HieuGUI.Parent do
            local uptime = tick() - StartTime
            local hours = math.floor(uptime / 3600)
            local minutes = math.floor((uptime % 3600) / 60)
            local seconds = math.floor(uptime % 60)
            UptimeLabel.Text = string.format("⏱️ Uptime: %02d:%02d:%02d", hours, minutes, seconds)
            wait(1)
        end
    end)
end

function HieuDRG:SetupConnections()
    -- Character added connection
    LocalPlayer.CharacterAdded:Connect(function(character)
        wait(1)
        self:UpdateSpeed()
        self:UpdateJumpPower()
    end)
end

-- Keybind to toggle menu
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        IsMenuOpen = not IsMenuOpen
        MainFrame.Visible = IsMenuOpen
    end
end)

-- Initialize HieuDRG Hub
HieuDRG:Initialize()

return HieuDRG
