-- HieuDRG Hub - Universal Roblox Exploit
-- Version: 2.0 | Support All Games
-- Created by SHADOW CORE

local HieuDRG = {
    _VERSION = "2.0.0",
    _AUTHOR = "HieuDRG",
    _DESCRIPTION = "Universal Roblox Exploit with Advanced Features"
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
local FlyEnabled = false
local NoClipEnabled = false
local ESPEnabled = false
local AntiAFKEnabled = false

-- Color Scheme
local Colors = {
    Background = Color3.fromRGB(25, 25, 25),
    Header = Color3.fromRGB(45, 45, 45),
    Primary = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 165, 0),
    Danger = Color3.fromRGB(255, 0, 0)
}

-- Initialize HieuDRG Hub
function HieuDRG:Initialize()
    -- Create main GUI
    self:CreateGUI()
    
    -- Initialize features
    self:SetupConnections()
    self:CreatePlayerESP()
    
    -- Start uptime counter
    self:StartUptimeCounter()
    
    -- Anti-AFK
    self:EnableAntiAFK()
    
    print("🎮 HieuDRG Hub loaded successfully!")
    print("👤 Player: " .. LocalPlayer.Name)
    print("🆔 User ID: " .. LocalPlayer.UserId)
end

-- Create Main GUI
function HieuDRG:CreateGUI()
    -- Main ScreenGUI
    HieuGUI.Name = "HieuDRGHub"
    HieuGUI.Parent = CoreGui
    HieuGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = HieuGUI
    MainFrame.BackgroundColor3 = Colors.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 450, 0, 400)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Colors.Header
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)

    -- Title
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🚀 HieuDRG Hub v2.0"
    Title.TextColor3 = Colors.Primary
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Uptime Label
    UptimeLabel.Name = "UptimeLabel"
    UptimeLabel.Parent = TopBar
    UptimeLabel.BackgroundTransparency = 1
    UptimeLabel.Position = UDim2.new(0.5, -100, 0, 0)
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
    TabButtons.Size = UDim2.new(0, 120, 0, 360)

    -- Content Frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Colors.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 120, 0, 40)
    ContentFrame.Size = UDim2.new(0, 330, 0, 360)

    -- Create Tabs
    self:CreateTabs()
    
    -- Button Events
    CloseButton.MouseButton1Click:Connect(function()
        HieuGUI:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        IsMenuOpen = not IsMenuOpen
        ContentFrame.Visible = IsMenuOpen
        TabButtons.Visible = IsMenuOpen
        if IsMenuOpen then
            MainFrame.Size = UDim2.new(0, 450, 0, 400)
        else
            MainFrame.Size = UDim2.new(0, 450, 0, 40)
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
        {"Misc", "🔧"}
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
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 500)
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
    self:CreateMiscTab()
end

-- Movement Tab
function HieuDRG:CreateMovementTab()
    local content = ContentFrame:FindFirstChild("MovementContent")
    if not content then return end
    
    local currentY = 10
    
    -- Fly Toggle
    self:CreateToggle(content, "Fly", currentY, FlyEnabled, function(value)
        FlyEnabled = value
        self:ToggleFly(value)
    end)
    currentY = currentY + 45
    
    -- Fly Speed
    self:CreateSlider(content, "Fly Speed", currentY, 1, 100, FlySpeed, function(value)
        FlySpeed = value
    end)
    currentY = currentY + 60
    
    -- NoClip Toggle
    self:CreateToggle(content, "NoClip", currentY, NoClipEnabled, function(value)
        NoClipEnabled = value
        self:ToggleNoClip(value)
    end)
    currentY = currentY + 45
    
    -- Speed Boost
    self:CreateSlider(content, "Speed Boost", currentY, 16, 100, SpeedValue, function(value)
        SpeedValue = value
        self:UpdateSpeed()
    end)
    currentY = currentY + 60
    
    -- Jump Power
    self:CreateSlider(content, "Jump Power", currentY, 50, 200, 50, function(value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
end

-- Visuals Tab
function HieuDRG:CreateVisualsTab()
    local content = ContentFrame:FindFirstChild("VisualsContent")
    if not content then return end
    
    local currentY = 10
    
    -- ESP Players Toggle
    self:CreateToggle(content, "ESP Players", currentY, ESPEnabled, function(value)
        ESPEnabled = value
        self:ToggleESP(value)
    end)
    currentY = currentY + 45
    
    -- ESP Mode
    self:CreateButton(content, "ESP Mode: Box", currentY, function()
        -- Cycle through ESP modes
    end)
    currentY = currentY + 45
    
    -- FullBright
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
end

-- Protection Tab
function HieuDRG:CreateProtectionTab()
    local content = ContentFrame:FindFirstChild("ProtectionContent")
    if not content then return end
    
    local currentY = 10
    
    -- Anti-Ban
    self:CreateToggle(content, "Anti-Ban", currentY, false, function(value)
        -- Anti-ban measures
    end)
    currentY = currentY + 45
    
    -- Anti-Kick
    self:CreateToggle(content, "Anti-Kick", currentY, false, function(value)
        -- Anti-kick measures
    end)
    currentY = currentY + 45
    
    -- Anti-AFK
    self:CreateToggle(content, "Anti-AFK", currentY, AntiAFKEnabled, function(value)
        AntiAFKEnabled = value
        self:ToggleAntiAFK(value)
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
    
    -- Auto Clicker
    self:CreateToggle(content, "Auto Clicker", currentY, false, function(value)
        -- Auto clicker functionality
    end)
end

-- Misc Tab
function HieuDRG:CreateMiscTab()
    local content = ContentFrame:FindFirstChild("MiscContent")
    if not content then return end
    
    local currentY = 10
    
    -- Server Hop
    self:CreateButton(content, "Server Hop", currentY, function()
        -- Server hop functionality
    end)
    currentY = currentY + 45
    
    -- Rejoin Server
    self:CreateButton(content, "Rejoin Server", currentY, function()
        -- Rejoin functionality
    end)
    currentY = currentY + 45
    
    -- Copy Game ID
    self:CreateButton(content, "Copy Game ID", currentY, function()
        -- Copy game ID to clipboard
    end)
end

-- UI Creation Helpers
function HieuDRG:CreateToggle(parent, text, yPos, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = parent
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.BackgroundColor3 = defaultValue and Colors.Success or Colors.Secondary
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.Size = UDim2.new(0, 80, 1, 0)
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.Text = text
    toggleButton.TextColor3 = Colors.Text
    toggleButton.TextSize = 12
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Parent = toggleFrame
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 90, 0, 0)
    statusLabel.Size = UDim2.new(0, 100, 1, 0)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Text = defaultValue and "ON" or "OFF"
    statusLabel.TextColor3 = defaultValue and Colors.Success or Colors.Danger
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    toggleButton.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        toggleButton.BackgroundColor3 = newValue and Colors.Success or Colors.Secondary
        statusLabel.Text = newValue and "ON" or "OFF"
        statusLabel.TextColor3 = newValue and Colors.Success or Colors.Danger
        callback(newValue)
    end)
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
    
    local function updateSlider(input)
        local pos = UDim2.new(
            math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1),
            0, 0, 0
        )
        local value = math.floor(min + (pos.X.Scale * (max - min)))
        sliderFill.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
        sliderButton.Position = UDim2.new(pos.X.Scale, -5, 0, -2)
        textLabel.Text = text .. ": " .. value
        callback(value)
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    connection:Disconnect()
                else
                    updateSlider(input)
                end
            end)
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

-- Feature Implementations
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
    end
end

function HieuDRG:UpdateSpeed()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
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
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        
        player.CharacterAdded:Connect(function(character)
            highlight.Adornee = character
        end)
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        createESP(player)
    end
    
    Players.PlayerAdded:Connect(createESP)
end

function HieuDRG:ToggleESP(enabled)
    ESPFolder:ClearAllChildren()
    
    if enabled then
        self:CreatePlayerESP()
    end
end

function HieuDRG:ToggleAntiAFK(enabled)
    if enabled then
        -- Anti-AFK implementation
        Connections["AntiAFK"] = RunService.Heartbeat:Connect(function()
            -- Simulate activity
            LocalPlayer.Idled:Connect(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        end)
    else
        if Connections["AntiAFK"] then
            Connections["AntiAFK"]:Disconnect()
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
    -- Character added connection for speed
    LocalPlayer.CharacterAdded:Connect(function(character)
        wait(1) -- Wait for character to load
        self:UpdateSpeed()
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
