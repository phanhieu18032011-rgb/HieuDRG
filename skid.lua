-- HIEUDRG FLY HUB - FIXED UI WITH TOGGLE
-- Simple & Working Version

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

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
    FlySpeed = 50,
    WalkSpeed = 16,
    JumpPower = 50
}

-- SYSTEM VARIABLES
local BodyVelocity, BodyGyro, FlyConnection, NoClipConnection

-- CREATE MAIN UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HieuDRG_Hub"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

-- TOGGLE BUTTON (Hiện khi menu ẩn)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = RGBColors[1]
toggleButton.Text = "☰"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Visible = true
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

-- MAIN CONTAINER (Ẩn ban đầu)
local mainContainer = Instance.new("Frame")
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, 350, 0, 400)
mainContainer.Position = UDim2.new(0, 10, 0, 70)
mainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainContainer.BorderSizePixel = 0
mainContainer.Visible = false
mainContainer.Parent = screenGui

-- MODERN CORNERS AND BORDER
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = mainContainer

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = RGBColors[1]
containerStroke.Thickness = 2
containerStroke.Parent = mainContainer

-- HEADER
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Size = UDim2.new(1, 0, 0, 40)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = RGBColors[1]
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainContainer

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

-- TITLE
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0.05, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "HIEUDRG FLY HUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerFrame

-- CLOSE BUTTON
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(0.9, 0, 0.2, 0)
closeButton.BackgroundColor3 = RGBColors[1]
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- CONTENT FRAME
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -40)
contentFrame.Position = UDim2.new(0, 0, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainContainer

-- FLY SECTION
local flySection = Instance.new("Frame")
flySection.Name = "FlySection"
flySection.Size = UDim2.new(0.9, 0, 0, 100)
flySection.Position = UDim2.new(0.05, 0, 0.02, 0)
flySection.BackgroundColor3 = RGBColors[5]
flySection.Parent = contentFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flySection

local flyLabel = Instance.new("TextLabel")
flyLabel.Size = UDim2.new(1, 0, 0, 25)
flyLabel.BackgroundTransparency = 1
flyLabel.Text = "FLY SYSTEM"
flyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flyLabel.TextSize = 14
flyLabel.Font = Enum.Font.GothamBold
flyLabel.Parent = flySection

-- FLY TOGGLE BUTTON
local flyToggle = Instance.new("TextButton")
flyToggle.Name = "FlyToggle"
flyToggle.Size = UDim2.new(0.9, 0, 0, 30)
flyToggle.Position = UDim2.new(0.05, 0, 0.3, 0)
flyToggle.BackgroundColor3 = RGBColors[1]
flyToggle.Text = "FLY: TẮT"
flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
flyToggle.TextSize = 14
flyToggle.Font = Enum.Font.Gotham
flyToggle.Parent = flySection

local flyToggleCorner = Instance.new("UICorner")
flyToggleCorner.CornerRadius = UDim.new(0, 6)
flyToggleCorner.Parent = flyToggle

-- FLY SPEED
local flySpeedLabel = Instance.new("TextLabel")
flySpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
flySpeedLabel.Position = UDim2.new(0.05, 0, 0.65, 0)
flySpeedLabel.BackgroundTransparency = 1
flySpeedLabel.Text = "Tốc độ: 50"
flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
flySpeedLabel.TextSize = 12
flySpeedLabel.Font = Enum.Font.Gotham
flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
flySpeedLabel.Parent = flySection

local speedUp = Instance.new("TextButton")
speedUp.Name = "SpeedUp"
speedUp.Size = UDim2.new(0.4, 0, 0, 25)
speedUp.Position = UDim2.new(0.05, 0, 0.85, 0)
speedUp.BackgroundColor3 = RGBColors[3]
speedUp.Text = "TĂNG"
speedUp.TextColor3 = Color3.fromRGB(0, 0, 0)
speedUp.TextSize = 12
speedUp.Font = Enum.Font.GothamBold
speedUp.Parent = flySection

local speedDown = Instance.new("TextButton")
speedDown.Name = "SpeedDown"
speedDown.Size = UDim2.new(0.4, 0, 0, 25)
speedDown.Position = UDim2.new(0.5, 0, 0.85, 0)
speedDown.BackgroundColor3 = RGBColors[1]
speedDown.Text = "GIẢM"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextSize = 12
speedDown.Font = Enum.Font.GothamBold
speedDown.Parent = flySection

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedUp
speedCorner:Clone().Parent = speedDown

-- MOVEMENT SECTION
local movementSection = Instance.new("Frame")
movementSection.Name = "MovementSection"
movementSection.Size = UDim2.new(0.9, 0, 0, 120)
movementSection.Position = UDim2.new(0.05, 0, 0.3, 0)
movementSection.BackgroundColor3 = RGBColors[4]
movementSection.Parent = contentFrame

local movementCorner = Instance.new("UICorner")
movementCorner.CornerRadius = UDim.new(0, 8)
movementCorner.Parent = movementSection

local movementLabel = Instance.new("TextLabel")
movementLabel.Size = UDim2.new(1, 0, 0, 25)
movementLabel.BackgroundTransparency = 1
movementLabel.Text = "MOVEMENT"
movementLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
movementLabel.TextSize = 14
movementLabel.Font = Enum.Font.GothamBold
movementLabel.Parent = movementSection

-- SPEED HACK
local speedToggle = Instance.new("TextButton")
speedToggle.Name = "SpeedToggle"
speedToggle.Size = UDim2.new(0.9, 0, 0, 25)
speedToggle.Position = UDim2.new(0.05, 0, 0.25, 0)
speedToggle.BackgroundColor3 = RGBColors[1]
speedToggle.Text = "SPEED HACK: TẮT"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.TextSize = 12
speedToggle.Font = Enum.Font.Gotham
speedToggle.Parent = movementSection

-- NO CLIP
local noclipToggle = Instance.new("TextButton")
noclipToggle.Name = "NoClipToggle"
noclipToggle.Size = UDim2.new(0.9, 0, 0, 25)
noclipToggle.Position = UDim2.new(0.05, 0, 0.55, 0)
noclipToggle.BackgroundColor3 = RGBColors[1]
noclipToggle.Text = "NO CLIP: TẮT"
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.TextSize = 12
noclipToggle.Font = Enum.Font.Gotham
noclipToggle.Parent = movementSection

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = speedToggle
toggleCorner:Clone().Parent = noclipToggle

-- SERVER SECTION
local serverSection = Instance.new("Frame")
serverSection.Name = "ServerSection"
serverSection.Size = UDim2.new(0.9, 0, 0, 80)
serverSection.Position = UDim2.new(0.05, 0, 0.65, 0)
serverSection.BackgroundColor3 = RGBColors[6]
serverSection.Parent = contentFrame

local serverCorner = Instance.new("UICorner")
serverCorner.CornerRadius = UDim.new(0, 8)
serverCorner.Parent = serverSection

local serverLabel = Instance.new("TextLabel")
serverLabel.Size = UDim2.new(1, 0, 0, 25)
serverLabel.BackgroundTransparency = 1
serverLabel.Text = "SERVER"
serverLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
serverLabel.TextSize = 14
serverLabel.Font = Enum.Font.GothamBold
serverLabel.Parent = serverSection

local hopButton = Instance.new("TextButton")
hopButton.Name = "HopButton"
hopButton.Size = UDim2.new(0.9, 0, 0, 25)
hopButton.Position = UDim2.new(0.05, 0, 0.4, 0)
hopButton.BackgroundColor3 = RGBColors[2]
hopButton.Text = "HOP SERVER"
hopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hopButton.TextSize = 12
hopButton.Font = Enum.Font.GothamBold
hopButton.Parent = serverSection

local resetButton = Instance.new("TextButton")
resetButton.Name = "ResetButton"
resetButton.Size = UDim2.new(0.9, 0, 0, 25)
resetButton.Position = UDim2.new(0.05, 0, 0.75, 0)
resetButton.BackgroundColor3 = RGBColors[1]
resetButton.Text = "RESET CHARACTER"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextSize = 12
resetButton.Font = Enum.Font.GothamBold
resetButton.Parent = serverSection

local serverButtonCorner = Instance.new("UICorner")
serverButtonCorner.CornerRadius = UDim.new(0, 6)
serverButtonCorner.Parent = hopButton
serverButtonCorner:Clone().Parent = resetButton

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
    
    flyToggle.Text = "FLY: BẬT"
    flyToggle.BackgroundColor3 = RGBColors[4]
end

function DeactivateFly()
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    if FlyConnection then FlyConnection:Disconnect() end
    
    flyToggle.Text = "FLY: TẮT"
    flyToggle.BackgroundColor3 = RGBColors[1]
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
    
    noclipToggle.Text = "NO CLIP: BẬT"
    noclipToggle.BackgroundColor3 = RGBColors[4]
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
    
    noclipToggle.Text = "NO CLIP: TẮT"
    noclipToggle.BackgroundColor3 = RGBColors[1]
end

-- BUTTON EVENT HANDLERS
flyToggle.MouseButton1Click:Connect(function()
    Config.FlyEnabled = not Config.FlyEnabled
    if Config.FlyEnabled then
        ActivateFly()
    else
        DeactivateFly()
    end
end)

speedToggle.MouseButton1Click:Connect(function()
    Config.SpeedEnabled = not Config.SpeedEnabled
    if Config.SpeedEnabled then
        Player.Character.Humanoid.WalkSpeed = Config.WalkSpeed
        speedToggle.Text = "SPEED HACK: BẬT"
        speedToggle.BackgroundColor3 = RGBColors[4]
    else
        Player.Character.Humanoid.WalkSpeed = 16
        speedToggle.Text = "SPEED HACK: TẮT"
        speedToggle.BackgroundColor3 = RGBColors[1]
    end
end)

noclipToggle.MouseButton1Click:Connect(function()
    Config.NoClipEnabled = not Config.NoClipEnabled
    if Config.NoClipEnabled then
        EnableNoClip()
    else
        DisableNoClip()
    end
end)

speedUp.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.min(200, Config.FlySpeed + 10)
    flySpeedLabel.Text = "Tốc độ: " .. Config.FlySpeed
end)

speedDown.MouseButton1Click:Connect(function()
    Config.FlySpeed = math.max(20, Config.FlySpeed - 10)
    flySpeedLabel.Text = "Tốc độ: " .. Config.FlySpeed
end)

hopButton.MouseButton1Click:Connect(function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

resetButton.MouseButton1Click:Connect(function()
    Player.Character:BreakJoints()
end)

-- TOGGLE MENU FUNCTION
toggleButton.MouseButton1Click:Connect(function()
    mainContainer.Visible = not mainContainer.Visible
end)

closeButton.MouseButton1Click:Connect(function()
    mainContainer.Visible = false
end)

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

-- RAINBOW ANIMATION
local currentColorIndex = 1
spawn(function()
    while true do
        containerStroke.Color = RGBColors[currentColorIndex]
        headerFrame.BackgroundColor3 = RGBColors[currentColorIndex]
        toggleButton.BackgroundColor3 = RGBColors[currentColorIndex]
        
        currentColorIndex = currentColorIndex + 1
        if currentColorIndex > #RGBColors then
            currentColorIndex = 1
        end
        
        wait(0.8)
    end
end)

-- INITIAL NOTIFICATION
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "HIEUDRG FLY HUB",
    Text = "Menu đã load! Nhấn nút ☰ để mở",
    Duration = 5
})

print("HIEUDRG FLY HUB - Fixed Version Loaded!")
print("Nhấn nút ☰ góc trái để mở menu")
