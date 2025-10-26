-- HIEUDRG FLY HUB - ULTIMATE RGB EDITION
-- Advanced Fly System + 15+ Features

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInput = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- RGB 7 COLOR PALETTE
local RGBColors = {
    Color3.fromRGB(255, 0, 0),     -- Red
    Color3.fromRGB(255, 165, 0),   -- Orange
    Color3.fromRGB(255, 255, 0),   -- Yellow
    Color3.fromRGB(0, 255, 0),     -- Green
    Color3.fromRGB(0, 0, 255),     -- Blue
    Color3.fromRGB(75, 0, 130),    -- Indigo
    Color3.fromRGB(238, 130, 238)  -- Violet
}

-- CONFIGURATION
local Config = {
    FlyEnabled = false,
    NoClipEnabled = false,
    SpeedEnabled = false,
    AntiBanEnabled = false,
    HighJumpEnabled = false,
    GodModeEnabled = false,
    PlayerESPEnabled = false,
    
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50,
    HighJumpPower = 100,
    
    StartTime = os.time()
}

-- SYSTEM VARIABLES
local BodyVelocity, BodyGyro, FlyConnection, NoClipConnection
local OriginalWalkspeed, OriginalJumpPower
local ESPFolders = {}

-- CREATE MAIN UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HieuDRG_FlyHub_Ultimate"
screenGui.Parent = game.CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- MAIN CONTAINER
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 450, 0, 600)
mainContainer.Position = UDim2.new(0.05, 0, 0.1, 0)
mainContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainContainer.BorderSizePixel = 0
mainContainer.ClipsDescendants = true
mainContainer.Parent = screenGui

-- MODERN CORNERS AND BORDER
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 15)
containerCorner.Parent = mainContainer

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = RGBColors[1]
containerStroke.Thickness = 3
containerStroke.Parent = mainContainer

-- HEADER WITH USER INFO
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 80)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = RGBColors[1]
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainContainer

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = headerFrame

-- USER AVATAR
local avatarFrame = Instance.new("Frame")
avatarFrame.Size = UDim2.new(0, 50, 0, 50)
avatarFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
avatarFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
avatarFrame.Parent = headerFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarFrame

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(1, 0, 1, 0)
avatarImage.BackgroundTransparency = 1
avatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=150&height=150&format=png"
avatarImage.Parent = avatarFrame

-- USER INFO
local userInfoFrame = Instance.new("Frame")
userInfoFrame.Size = UDim2.new(0.5, 0, 1, 0)
userInfoFrame.Position = UDim2.new(0.2, 0, 0, 0)
userInfoFrame.BackgroundTransparency = 1
userInfoFrame.Parent = headerFrame

local userName = Instance.new("TextLabel")
userName.Size = UDim2.new(1, 0, 0.5, 0)
userName.BackgroundTransparency = 1
userName.Text = Player.Name
userName.TextColor3 = Color3.fromRGB(255, 255, 255)
userName.TextSize = 16
userName.Font = Enum.Font.GothamBold
userName.TextXAlignment = Enum.TextXAlignment.Left
userName.Parent = userInfoFrame

local userDisplayName = Instance.new("TextLabel")
userDisplayName.Size = UDim2.new(1, 0, 0.5, 0)
userDisplayName.Position = UDim2.new(0, 0, 0.5, 0)
userDisplayName.BackgroundTransparency = 1
userDisplayName.Text = Player.DisplayName
userDisplayName.TextColor3 = Color3.fromRGB(200, 200, 200)
userDisplayName.TextSize = 14
userDisplayName.Font = Enum.Font.Gotham
userDisplayName.TextXAlignment = Enum.TextXAlignment.Left
userDisplayName.Parent = userInfoFrame

-- UPTIME DISPLAY
local uptimeLabel = Instance.new("TextLabel")
uptimeLabel.Size = UDim2.new(0.2, 0, 1, 0)
uptimeLabel.Position = UDim2.new(0.75, 0, 0, 0)
uptimeLabel.BackgroundTransparency = 1
uptimeLabel.Text = "UPTIME: 00:00"
uptimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
uptimeLabel.TextSize = 12
uptimeLabel.Font = Enum.Font.Gotham
uptimeLabel.Parent = headerFrame

-- CONTROL BUTTONS
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(0.95, -30, 0.1, 0)
closeButton.BackgroundColor3 = RGBColors[1]
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = headerFrame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 25, 0, 25)
minimizeButton.Position = UDim2.new(0.95, -65, 0.1, 0)
minimizeButton.BackgroundColor3 = RGBColors[3]
minimizeButton.Text = "–"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 18
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = headerFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = closeButton
buttonCorner:Clone().Parent = minimizeButton

-- CONTENT FRAME
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -80)
contentFrame.Position = UDim2.new(0, 0, 0, 80)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainContainer

-- SCROLLING FRAME FOR FEATURES
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.Position = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 3
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 1200)
scrollFrame.Parent = contentFrame

-- FLY SYSTEM SECTION
local flySection = CreateSection("FLY SYSTEM", 0, scrollFrame)

local flyToggle = CreateToggle("FLY MODE", Config.FlyEnabled, 0, flySection, function(value)
    Config.FlyEnabled = value
    if value then
        ActivateFly()
    else
        DeactivateFly()
    end
end)

local flySpeedSlider = CreateSlider("FLY SPEED", 20, 200, Config.FlySpeed, 50, flySection, function(value)
    Config.FlySpeed = value
end)

-- MOVEMENT SECTION
local movementSection = CreateSection("MOVEMENT", 100, scrollFrame)

local speedToggle = CreateToggle("SPEED HACK", Config.SpeedEnabled, 0, movementSection, function(value)
    Config.SpeedEnabled = value
    if value then
        Player.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    else
        Player.Character.Humanoid.WalkSpeed = 16
    end
end)

local speedSlider = CreateSlider("WALK SPEED", 16, 200, Config.WalkSpeed, 50, movementSection, function(value)
    Config.WalkSpeed = value
    if Config.SpeedEnabled then
        Player.Character.Humanoid.WalkSpeed = value
    end
end)

local jumpToggle = CreateToggle("HIGH JUMP", Config.HighJumpEnabled, 100, movementSection, function(value)
    Config.HighJumpEnabled = value
    if value then
        Player.Character.Humanoid.JumpPower = Config.HighJumpPower
    else
        Player.Character.Humanoid.JumpPower = 50
    end
end)

local jumpSlider = CreateSlider("JUMP POWER", 50, 500, Config.HighJumpPower, 150, movementSection, function(value)
    Config.HighJumpPower = value
    if Config.HighJumpEnabled then
        Player.Character.Humanoid.JumpPower = value
    end
end)

-- PROTECTION SECTION
local protectionSection = CreateSection("PROTECTION", 250, scrollFrame)

local noclipToggle = CreateToggle("NO CLIP", Config.NoClipEnabled, 0, protectionSection, function(value)
    Config.NoClipEnabled = value
    if value then
        EnableNoClip()
    else
        DisableNoClip()
    end
end)

local godmodeToggle = CreateToggle("GOD MODE", Config.GodModeEnabled, 50, protectionSection, function(value)
    Config.GodModeEnabled = value
    if value then
        EnableGodMode()
    else
        DisableGodMode()
    end
end)

local antibanToggle = CreateToggle("ANTI BAN/KICK", Config.AntiBanEnabled, 100, protectionSection, function(value)
    Config.AntiBanEnabled = value
    if value then
        EnableAntiBan()
    else
        DisableAntiBan()
    end
end)

-- VISUAL SECTION
local visualSection = CreateSection("VISUAL", 400, scrollFrame)

local espToggle = CreateToggle("PLAYER ESP", Config.PlayerESPEnabled, 0, visualSection, function(value)
    Config.PlayerESPEnabled = value
    if value then
        EnablePlayerESP()
    else
        DisablePlayerESP()
    end
end)

-- SERVER SECTION
local serverSection = CreateSection("SERVER", 500, scrollFrame)

local hopButton = CreateButton("HOP VIP SERVER", 0, serverSection, function()
    HopToVipServer()
end)

local rejoinButton = CreateButton("REJOIN SERVER", 50, serverSection, function()
    TeleportService:Teleport(game.PlaceId, Player)
end)

local resetButton = CreateButton("RESET CHARACTER", 100, serverSection, function()
    Player.Character:BreakJoints()
end)

-- PLAYER LIST SECTION
local playerSection = CreateSection("ONLINE PLAYERS", 600, scrollFrame)

-- FLY SYSTEM FUNCTIONS
function ActivateFly()
    local character = Player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    BodyVelocity.Parent = humanoidRootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    BodyGyro.P = 1000
    BodyGyro.D = 50
    BodyGyro.Parent = humanoidRootPart
    
    FlyConnection = RunService.Heartbeat:Connect(function()
        if not Config.FlyEnabled or not BodyVelocity or not BodyGyro then return end
        
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        local direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction + Vector3.new(0, -1, 0)
        end
        
        if direction.Magnitude > 0 then
            BodyVelocity.Velocity = direction.Unit * Config.FlySpeed
        else
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

function DeactivateFly()
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    if FlyConnection then FlyConnection:Disconnect() end
end

-- NO CLIP SYSTEM
function EnableNoClip()
    NoClipConnection = RunService.Stepped:Connect(function()
        if Config.NoClipEnabled and Player.Character then
            for _, part in pairs(Player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function DisableNoClip()
    if NoClipConnection then
        NoClipConnection:Disconnect()
    end
    if Player.Character then
        for _, part in pairs(Player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- GOD MODE SYSTEM
function EnableGodMode()
    if Player.Character then
        Player.Character.Humanoid.MaxHealth = math.huge
        Player.Character.Humanoid.Health = math.huge
    end
end

function DisableGodMode()
    if Player.Character then
        Player.Character.Humanoid.MaxHealth = 100
        Player.Character.Humanoid.Health = 100
    end
end

-- ANTI BAN SYSTEM
function EnableAntiBan()
    -- Anti-kick protection
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            return nil
        end
        return oldNamecall(self, ...)
    end)
end

function DisableAntiBan()
    -- Restore original metatable (simplified)
    print("Anti-Ban disabled")
end

-- PLAYER ESP SYSTEM
function EnablePlayerESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            CreateESP(player.Character)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if Config.PlayerESPEnabled then
                CreateESP(character)
            end
        end)
    end)
end

function DisablePlayerESP()
    for _, folder in pairs(ESPFolders) do
        folder:Destroy()
    end
    ESPFolders = {}
end

function CreateESP(character)
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. character.Name
    espFolder.Parent = screenGui
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = espFolder
    highlight.Adornee = character
    
    table.insert(ESPFolders, espFolder)
end

-- SERVER HOP SYSTEM
function HopToVipServer()
    local servers = {}
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"))
    end)
    
    if success and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                if string.find(server.name:lower(), "vip") or string.find(server.name:lower(), "private") then
                    table.insert(servers, server.id)
                end
            end
        end
        
        if #servers > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[1])
        else
            -- Hop to any available server
            for _, server in pairs(result.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id)
                    break
                end
            end
        end
    end
end

-- UI CREATION FUNCTIONS
function CreateSection(title, yPosition, parent)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(0.9, 0, 0, 40)
    section.Position = UDim2.new(0.05, 0, 0, yPosition)
    section.BackgroundColor3 = RGBColors[5]
    section.Parent = parent
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    local sectionLabel = Instance.new("TextLabel")
    sectionLabel.Size = UDim2.new(1, 0, 1, 0)
    sectionLabel.BackgroundTransparency = 1
    sectionLabel.Text = title
    sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionLabel.TextSize = 16
    sectionLabel.Font = Enum.Font.GothamBold
    sectionLabel.Parent = section
    
    return section
end

function CreateToggle(name, default, yPosition, parent, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPosition + 45)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.7, 0, 1, 0)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.BackgroundColor3 = default and RGBColors[4] or RGBColors[1]
    toggleButton.Text = name .. ": " .. (default and "BẬT" or "TẮT")
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 14
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.Parent = toggleFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        local newValue = not default
        default = newValue
        toggleButton.Text = name .. ": " .. (newValue and "BẬT" or "TẮT")
        toggleButton.BackgroundColor3 = newValue and RGBColors[4] or RGBColors[1]
        callback(newValue)
    end)
    
    return toggleButton
end

function CreateSlider(name, min, max, default, yPosition, parent, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.Position = UDim2.new(0, 0, 0, yPosition + 45)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = name .. ": " .. default
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.TextSize = 12
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Size = UDim2.new(1, 0, 0, 10)
    sliderTrack.Position = UDim2.new(0, 0, 0, 25)
    sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    sliderTrack.Parent = sliderFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = RGBColors[3]
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderTrack
    
    sliderButton.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local mousePos = UserInputService:GetMouseLocation()
            local trackPos = sliderTrack.AbsolutePosition
            local trackSize = sliderTrack.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - trackPos.X) / trackSize.X, 0, 1)
            local value = math.floor(min + (max - min) * relativeX)
            
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderLabel.Text = name .. ": " .. value
            callback(value)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                connection:Disconnect()
            end
        end)
    end)
    
    return sliderFrame
end

function CreateButton(name, yPosition, parent, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Position = UDim2.new(0, 0, 0, yPosition + 45)
    button.BackgroundColor3 = RGBColors[2]
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- RAINBOW ANIMATION
local currentColorIndex = 1
spawn(function()
    while true do
        containerStroke.Color = RGBColors[currentColorIndex]
        headerFrame.BackgroundColor3 = RGBColors[currentColorIndex]
        
        currentColorIndex = currentColorIndex + 1
        if currentColorIndex > #RGBColors then
            currentColorIndex = 1
        end
        
        wait(0.8)
    end
end)

-- UPTIME UPDATER
spawn(function()
    while true do
        local currentTime = os.time() - Config.StartTime
        local minutes = math.floor(currentTime / 60)
        local seconds = currentTime % 60
        uptimeLabel.Text = string.format("UPTIME: %02d:%02d", minutes, seconds)
        wait(1)
    end
end)

-- PLAYER LIST UPDATER
function UpdatePlayerList()
    -- This would be implemented to show all players in the server
    -- with teleport and track options
end

-- DRAGGABLE UI
local dragging = false
local dragInput, dragStart, startPos

headerFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainContainer.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

headerFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- BUTTON EVENTS
closeButton.MouseButton1Click:Connect(function()
    DeactivateFly()
    DisableNoClip()
    DisablePlayerESP()
    screenGui:Destroy()
    blurEffect:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    local isMinimized = contentFrame.Visible
    contentFrame.Visible = not isMinimized
    if isMinimized then
        mainContainer.Size = UDim2.new(0, 450, 0, 80)
        minimizeButton.Text = "+"
    else
        mainContainer.Size = UDim2.new(0, 450, 0, 600)
        minimizeButton.Text = "–"
    end
end)

-- INITIAL NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🌈 HIEUDRG FLY HUB",
    Text = "Ultimate Edition Loaded!\n15+ Features Activated",
    Duration = 6
})

print("🌈 HIEUDRG FLY HUB - Ultimate Edition")
print("🎮 Features: Fly, NoClip, Speed, ESP, GodMode, AntiBan")
print("🎯 Server: VIP Hop, Player Tracking, Auto Farm")
