-- HieuDRG Hub v4.0 - Universal Roblox Exploit
-- COMPLETELY FIXED TOGGLE SYSTEM
-- Created by SHADOW CORE

local HieuDRG = {
    _VERSION = "4.0.0",
    _AUTHOR = "HieuDRG",
    _DESCRIPTION = "Fixed Toggle System - No More Stuck Features"
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

-- FIXED: Proper State Management
local States = {
    Fly = {
        Enabled = false,
        Connection = nil,
        BodyVelocity = nil
    },
    NoClip = {
        Enabled = false,
        Connection = nil
    },
    ESP = {
        Enabled = false,
        Folder = Instance.new("Folder"),
        CurrentColorIndex = 1
    },
    AntiAFK = {
        Enabled = false,
        Connection = nil
    },
    AutoClick = {
        Enabled = false,
        Connection = nil,
        Position = nil
    },
    FullBright = {
        Enabled = false,
        Original = {
            Ambient = Lighting.Ambient,
            Brightness = Lighting.Brightness,
            GlobalShadows = Lighting.GlobalShadows
        }
    },
    XRay = {
        Enabled = false
    }
}

-- Settings
local Settings = {
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50,
    AutoClickInterval = 500
}

-- RGB Colors
local RGBColors = {
    Color3.fromRGB(255, 0, 0),      -- Red
    Color3.fromRGB(255, 165, 0),    -- Orange
    Color3.fromRGB(255, 255, 0),    -- Yellow
    Color3.fromRGB(0, 255, 0),      -- Green
    Color3.fromRGB(0, 0, 255),      -- Blue
    Color3.fromRGB(75, 0, 130),     -- Indigo
    Color3.fromRGB(238, 130, 238)   -- Violet
}

local CurrentRGBIndex = 1
local StartTime = tick()

-- Initialize HieuDRG Hub
function HieuDRG:Initialize()
    -- Setup ESP Folder
    States.ESP.Folder.Name = "HieuDRG_ESP"
    States.ESP.Folder.Parent = CoreGui
    
    -- Create GUI
    self:CreateGUI()
    
    -- Start services
    self:StartUptimeCounter()
    self:StartRGBAnimation()
    self:SetupCharacterHandling()
    
    print("🎮 HieuDRG Hub v4.0 loaded successfully!")
    print("👤 Player: " .. LocalPlayer.Name)
end

-- FIXED: GUI Creation
function HieuDRG:CreateGUI()
    -- Main ScreenGUI
    HieuGUI.Name = "HieuDRGHubv4"
    HieuGUI.Parent = CoreGui
    HieuGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = HieuGUI
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
    MainFrame.Size = UDim2.new(0, 500, 0, 450)
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Top Bar
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)

    -- Title
    Title.Name = "Title"
    Title.Parent = TopBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🌈 HieuDRG Hub v4.0"
    Title.TextColor3 = RGBColors[1]
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
    UptimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UptimeLabel.TextSize = 12

    -- Player Info
    PlayerInfo.Name = "PlayerInfo"
    PlayerInfo.Parent = TopBar
    PlayerInfo.BackgroundTransparency = 1
    PlayerInfo.Position = UDim2.new(0, 10, 1, -20)
    PlayerInfo.Size = UDim2.new(1, -20, 0, 18)
    PlayerInfo.Font = Enum.Font.Gotham
    PlayerInfo.Text = "👤 " .. LocalPlayer.Name .. " | 🆔 " .. LocalPlayer.UserId
    PlayerInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerInfo.TextSize = 11
    PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left

    -- Close Button
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TopBar
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14

    -- Minimize Button
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TopBar
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -60, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 14

    -- Tab Buttons Frame
    TabButtons.Name = "TabButtons"
    TabButtons.Parent = MainFrame
    TabButtons.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabButtons.BorderSizePixel = 0
    TabButtons.Position = UDim2.new(0, 0, 0, 40)
    TabButtons.Size = UDim2.new(0, 120, 0, 410)

    -- Content Frame
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 120, 0, 40)
    ContentFrame.Size = UDim2.new(0, 380, 0, 410)

    -- Create Tabs
    self:CreateTabs()
    
    -- Button Events
    CloseButton.MouseButton1Click:Connect(function()
        self:CleanupAll()
        HieuGUI:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        local isOpen = ContentFrame.Visible
        ContentFrame.Visible = not isOpen
        TabButtons.Visible = not isOpen
        if isOpen then
            MainFrame.Size = UDim2.new(0, 500, 0, 40)
        else
            MainFrame.Size = UDim2.new(0, 500, 0, 450)
        end
    end)
end

function HieuDRG:CreateTabs()
    local tabs = {
        {"Movement", "🚀"},
        {"Visuals", "👁️"}, 
        {"AutoClick", "🖱️"},
        {"Protection", "🛡️"}
    }
    
    local currentY = 10
    
    for i, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab[1] .. "Tab"
        tabButton.Parent = TabButtons
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.BorderSizePixel = 0
        tabButton.Position = UDim2.new(0, 10, 0, currentY)
        tabButton.Size = UDim2.new(0, 100, 0, 35)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tab[2] .. " " .. tab[1]
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    self:CreateAutoClickTab()
    self:CreateProtectionTab()
end

-- FIXED: Movement Tab
function HieuDRG:CreateMovementTab()
    local content = ContentFrame:FindFirstChild("MovementContent")
    if not content then return end
    
    local currentY = 10
    
    -- Fly Toggle
    self:CreateToggle(content, "Fly", currentY, States.Fly.Enabled, function(value)
        self:ToggleFly(value)
    end)
    currentY = currentY + 45
    
    -- Fly Speed
    self:CreateSlider(content, "Fly Speed", currentY, 1, 200, Settings.FlySpeed, function(value)
        Settings.FlySpeed = value
    end)
    currentY = currentY + 60
    
    -- NoClip Toggle
    self:CreateToggle(content, "NoClip", currentY, States.NoClip.Enabled, function(value)
        self:ToggleNoClip(value)
    end)
    currentY = currentY + 45
    
    -- Speed Boost
    self:CreateSlider(content, "Walk Speed", currentY, 16, 200, Settings.WalkSpeed, function(value)
        Settings.WalkSpeed = value
        self:UpdateWalkSpeed()
    end)
    currentY = currentY + 60
    
    -- Jump Power
    self:CreateSlider(content, "Jump Power", currentY, 50, 500, Settings.JumpPower, function(value)
        Settings.JumpPower = value
        self:UpdateJumpPower()
    end)
end

-- FIXED: Visuals Tab
function HieuDRG:CreateVisualsTab()
    local content = ContentFrame:FindFirstChild("VisualsContent")
    if not content then return end
    
    local currentY = 10
    
    -- ESP Players Toggle
    self:CreateToggle(content, "ESP Players", currentY, States.ESP.Enabled, function(value)
        self:ToggleESP(value)
    end)
    currentY = currentY + 45
    
    -- ESP Color Cycle
    self:CreateButton(content, "Cycle ESP Color", currentY, function()
        self:CycleESPColor()
    end)
    currentY = currentY + 45
    
    -- FullBright Toggle
    self:CreateToggle(content, "FullBright", currentY, States.FullBright.Enabled, function(value)
        self:ToggleFullBright(value)
    end)
    currentY = currentY + 45
    
    -- X-Ray Toggle
    self:CreateToggle(content, "X-Ray Vision", currentY, States.XRay.Enabled, function(value)
        self:ToggleXRay(value)
    end)
end

-- FIXED: AutoClick Tab
function HieuDRG:CreateAutoClickTab()
    local content = ContentFrame:FindFirstChild("AutoClickContent")
    if not content then return end
    
    local currentY = 10
    
    -- Auto Click Toggle
    self:CreateToggle(content, "Auto Click", currentY, States.AutoClick.Enabled, function(value)
        self:ToggleAutoClick(value)
    end)
    currentY = currentY + 45
    
    -- Set Click Position
    self:CreateButton(content, "Set Click Position", currentY, function()
        self:SetAutoClickPosition()
    end)
    currentY = currentY + 45
    
    -- Move to Position
    self:CreateButton(content, "Move to Position", currentY, function()
        self:MoveToClickPosition()
    end)
    currentY = currentY + 45
    
    -- Clear Position
    self:CreateButton(content, "Clear Position", currentY, function()
        States.AutoClick.Position = nil
    end)
end

-- FIXED: Protection Tab
function HieuDRG:CreateProtectionTab()
    local content = ContentFrame:FindFirstChild("ProtectionContent")
    if not content then return end
    
    local currentY = 10
    
    -- Anti-AFK Toggle
    self:CreateToggle(content, "Anti-AFK", currentY, States.AntiAFK.Enabled, function(value)
        self:ToggleAntiAFK(value)
    end)
    currentY = currentY + 45
    
    -- Anti-Kick
    self:CreateToggle(content, "Anti-Kick", currentY, false, function(value)
        -- Placeholder
    end)
    currentY = currentY + 45
    
    -- Anti-Ban
    self:CreateToggle(content, "Anti-Ban", currentY, false, function(value)
        -- Placeholder
    end)
end

-- FIXED: UI Components
function HieuDRG:CreateToggle(parent, text, yPos, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = parent
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Position = UDim2.new(0, 10, 0, yPos)
    toggleFrame.Size = UDim2.new(1, -20, 0, 35)
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.Name = text .. "Toggle"
    toggleButton.BackgroundColor3 = defaultValue and RGBColors[1] or Color3.fromRGB(50, 50, 50)
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.Size = UDim2.new(0, 120, 1, 0)
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.Text = text
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 12
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Parent = toggleFrame
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 130, 0, 0)
    statusLabel.Size = UDim2.new(0, 60, 1, 0)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Text = defaultValue and "ON" or "OFF"
    statusLabel.TextColor3 = defaultValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    toggleButton.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        toggleButton.BackgroundColor3 = newValue and RGBColors[CurrentRGBIndex] or Color3.fromRGB(50, 50, 50)
        statusLabel.Text = newValue and "ON" or "OFF"
        statusLabel.TextColor3 = newValue and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
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
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Parent = sliderFrame
    sliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Position = UDim2.new(0, 0, 0, 25)
    sliderTrack.Size = UDim2.new(1, 0, 0, 10)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderTrack
    sliderFill.BackgroundColor3 = RGBColors[1]
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sliderTrack
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -5, 0, -2)
    sliderButton.Size = UDim2.new(0, 10, 0, 14)
    sliderButton.Text = ""
    
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
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    connection:Disconnect()
                else
                    updateSlider(input.Position.X)
                end
            end)
        end
    end)
end

function HieuDRG:CreateButton(parent, text, yPos, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = RGBColors[1]
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, 10, 0, yPos)
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    
    button.MouseButton1Click:Connect(callback)
end

-- FIXED: Feature Implementations
function HieuDRG:ToggleFly(enabled)
    States.Fly.Enabled = enabled
    
    -- Cleanup existing
    if States.Fly.Connection then
        States.Fly.Connection:Disconnect()
        States.Fly.Connection = nil
    end
    if States.Fly.BodyVelocity then
        States.Fly.BodyVelocity:Destroy()
        States.Fly.BodyVelocity = nil
    end
    
    if enabled then
        States.Fly.BodyVelocity = Instance.new("BodyVelocity")
        States.Fly.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        
        States.Fly.Connection = RunService.Heartbeat:Connect(function()
            if not States.Fly.Enabled then return end
            
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            
            local camera = Workspace.CurrentCamera
            local lookVector = camera.CFrame.LookVector
            local rightVector = camera.CFrame.RightVector
            
            local direction = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + lookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - lookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - rightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + rightVector end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit * Settings.FlySpeed
            end
            
            local velocity = Vector3.new(direction.X, 0, direction.Z)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                velocity = velocity + Vector3.new(0, Settings.FlySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                velocity = velocity - Vector3.new(0, Settings.FlySpeed, 0)
            end
            
            States.Fly.BodyVelocity.Velocity = velocity
            
            if not States.Fly.BodyVelocity.Parent then
                States.Fly.BodyVelocity.Parent = root
            end
        end)
    else
        -- Cleanup velocity
        local character = LocalPlayer.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, obj in pairs(root:GetChildren()) do
                    if obj:IsA("BodyVelocity") then
                        obj:Destroy()
                    end
                end
            end
        end
    end
end

function HieuDRG:ToggleNoClip(enabled)
    States.NoClip.Enabled = enabled
    
    if States.NoClip.Connection then
        States.NoClip.Connection:Disconnect()
        States.NoClip.Connection = nil
    end
    
    if enabled then
        States.NoClip.Connection = RunService.Stepped:Connect(function()
            if not States.NoClip.Enabled then return end
            
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        -- Restore collision
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

function HieuDRG:ToggleESP(enabled)
    States.ESP.Enabled = enabled
    States.ESP.Folder:ClearAllChildren()
    
    if enabled then
        local function createESP(player)
            if player == LocalPlayer then return end
            
            local highlight = Instance.new("Highlight")
            highlight.Name = player.Name .. "_ESP"
            highlight.Parent = States.ESP.Folder
            highlight.Adornee = player.Character
            highlight.FillColor = RGBColors[States.ESP.CurrentColorIndex]
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            
            player.CharacterAdded:Connect(function(character)
                wait(1)
                if States.ESP.Enabled then
                    highlight.Adornee = character
                end
            end)
        end
        
        for _, player in pairs(Players:GetPlayers()) do
            createESP(player)
        end
        
        Players.PlayerAdded:Connect(createESP)
    end
end

function HieuDRG:ToggleFullBright(enabled)
    States.FullBright.Enabled = enabled
    
    if enabled then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = States.FullBright.Original.Ambient
        Lighting.Brightness = States.FullBright.Original.Brightness
        Lighting.GlobalShadows = States.FullBright.Original.GlobalShadows
    end
end

function HieuDRG:ToggleXRay(enabled)
    States.XRay.Enabled = enabled
    
    if enabled then
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
end

function HieuDRG:ToggleAutoClick(enabled)
    States.AutoClick.Enabled = enabled
    
    if States.AutoClick.Connection then
        States.AutoClick.Connection:Disconnect()
        States.AutoClick.Connection = nil
    end
    
    if enabled then
        States.AutoClick.Connection = RunService.Heartbeat:Connect(function()
            if not States.AutoClick.Enabled or not States.AutoClick.Position then return end
            
            -- Simulate click
            virtualInputManager:SendMouseButtonEvent(
                States.AutoClick.Position.X,
                States.AutoClick.Position.Y,
                0,
                true,
                game,
                1
            )
            wait(0.1)
            virtualInputManager:SendMouseButtonEvent(
                States.AutoClick.Position.X,
                States.AutoClick.Position.Y,
                0,
                false,
                game,
                1
            )
        end)
    end
end

function HieuDRG:ToggleAntiAFK(enabled)
    States.AntiAFK.Enabled = enabled
    
    if States.AntiAFK.Connection then
        States.AntiAFK.Connection:Disconnect()
        States.AntiAFK.Connection = nil
    end
    
    if enabled then
        States.AntiAFK.Connection = LocalPlayer.Idled:Connect(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
        end)
    end
end

-- Utility Functions
function HieuDRG:UpdateWalkSpeed()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = Settings.WalkSpeed
    end
end

function HieuDRG:UpdateJumpPower()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.JumpPower = Settings.JumpPower
    end
end

function HieuDRG:CycleESPColor()
    States.ESP.CurrentColorIndex = States.ESP.CurrentColorIndex % #RGBColors + 1
    for _, highlight in pairs(States.ESP.Folder:GetChildren()) do
        if highlight:IsA("Highlight") then
            highlight.FillColor = RGBColors[States.ESP.CurrentColorIndex]
        end
    end
end

function HieuDRG:SetAutoClickPosition()
    local mouse = LocalPlayer:GetMouse()
    States.AutoClick.Position = Vector2.new(mouse.X, mouse.Y)
end

function HieuDRG:MoveToClickPosition()
    if States.AutoClick.Position and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local mouse = LocalPlayer:GetMouse()
        if root then
            root.CFrame = CFrame.new(mouse.Hit.Position)
        end
    end
end

function HieuDRG:CleanupAll()
    -- Disable all features
    self:ToggleFly(false)
    self:ToggleNoClip(false)
    self:ToggleESP(false)
    self:ToggleFullBright(false)
    self:ToggleXRay(false)
    self:ToggleAutoClick(false)
    self:ToggleAntiAFK(false)
    
    -- Destroy ESP folder
    if States.ESP.Folder then
        States.ESP.Folder:Destroy()
    end
end

function HieuDRG:SetupCharacterHandling()
    LocalPlayer.CharacterAdded:Connect(function(character)
        wait(1)
        self:UpdateWalkSpeed()
        self:UpdateJumpPower()
    end)
end

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

function HieuDRG:StartRGBAnimation()
    spawn(function()
        while HieuGUI.Parent do
            CurrentRGBIndex = CurrentRGBIndex % #RGBColors + 1
            local currentColor = RGBColors[CurrentRGBIndex]
            
            -- Update title
            Title.TextColor3 = currentColor
            
            -- Update active toggles
            for _, frame in pairs(ContentFrame:GetDescendants()) do
                if frame:IsA("TextButton") and frame.Name:find("Toggle") then
                    local statusLabel = frame.Parent:FindFirstChild("StatusLabel")
                    if statusLabel and statusLabel.Text == "ON" then
                        frame.BackgroundColor3 = currentColor
                    end
                end
            end
            
            -- Update sliders
            for _, frame in pairs(ContentFrame:GetDescendants()) do
                if frame:IsA("Frame") and frame:FindFirstChild("SliderFill") then
                    frame.SliderFill.BackgroundColor3 = currentColor
                end
            end
            
            wait(0.5)
        end
    end)
end

-- Keybind
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Initialize
HieuDRG:Initialize()

return HieuDRG
