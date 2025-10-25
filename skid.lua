-- HIEUDRG FLY HUB - RGB 7 COLOR THEME
-- REDESIGNED WITH EPIC RAINBOW UI

local main = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local ContentFrame = Instance.new("Frame")
local FlyButton = Instance.new("TextButton")
local UpButton = Instance.new("TextButton")
local DownButton = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")
local IncreaseSpeed = Instance.new("TextButton")
local DecreaseSpeed = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

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

-- MAIN GUI
main.Name = "HieuDRGFlyHub"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- MAIN FRAME WITH GRADIENT BACKGROUND
MainFrame.Name = "MainFrame"
MainFrame.Parent = main
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.ClipsDescendants = true

-- ADD GRADIENT EFFECT
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = RGBColors[4] -- Green border
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- TITLE BAR WITH RAINBOW GRADIENT
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = RGBColors[1] -- Red start
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 40)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

-- ANIMATED RAINBOW TITLE
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "🌈 HIEUDRG FLY HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.BackgroundColor3 = RGBColors[1] -- Red
CloseButton.Position = UDim2.new(0.85, 0, 0.15, 0)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- MINIMIZE BUTTON
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.BackgroundColor3 = RGBColors[3] -- Yellow
MinimizeButton.Position = UDim2.new(0.75, 0, 0.15, 0)
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "–"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 0)
MinimizeCorner.Parent = MinimizeButton

-- CONTENT FRAME
ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 45)
ContentFrame.Size = UDim2.new(1, 0, 1, -45)

-- FLY BUTTON (RAINBOW STYLE)
FlyButton.Name = "FlyButton"
FlyButton.Parent = ContentFrame
FlyButton.BackgroundColor3 = RGBColors[4] -- Green
FlyButton.Position = UDim2.new(0.1, 0, 0.05, 0)
FlyButton.Size = UDim2.new(0.8, 0, 0, 50)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.Text = "🛸 BẬT FLY"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextSize = 16

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 10)
FlyCorner.Parent = FlyButton

local FlyStroke = Instance.new("UIStroke")
FlyStroke.Color = RGBColors[5] -- Blue border
FlyStroke.Thickness = 2
FlyStroke.Parent = FlyButton

-- UP BUTTON
UpButton.Name = "UpButton"
UpButton.Parent = ContentFrame
UpButton.BackgroundColor3 = RGBColors[2] -- Orange
UpButton.Position = UDim2.new(0.1, 0, 0.25, 0)
UpButton.Size = UDim2.new(0.35, 0, 0, 40)
UpButton.Font = Enum.Font.GothamBold
UpButton.Text = "⬆️ UP"
UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpButton.TextSize = 14

local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 8)
UpCorner.Parent = UpButton

-- DOWN BUTTON
DownButton.Name = "DownButton"
DownButton.Parent = ContentFrame
DownButton.BackgroundColor3 = RGBColors[6] -- Indigo
DownButton.Position = UDim2.new(0.55, 0, 0.25, 0)
DownButton.Size = UDim2.new(0.35, 0, 0, 40)
DownButton.Font = Enum.Font.GothamBold
DownButton.Text = "⬇️ DOWN"
DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DownButton.TextSize = 14

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 8)
DownCorner.Parent = DownButton

-- SPEED LABEL
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = ContentFrame
SpeedLabel.BackgroundColor3 = RGBColors[5] -- Blue
SpeedLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 35)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.Text = "🎯 TỐC ĐỘ: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 14

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedLabel

-- INCREASE SPEED BUTTON
IncreaseSpeed.Name = "IncreaseSpeed"
IncreaseSpeed.Parent = ContentFrame
IncreaseSpeed.BackgroundColor3 = RGBColors[3] -- Yellow
IncreaseSpeed.Position = UDim2.new(0.1, 0, 0.6, 0)
IncreaseSpeed.Size = UDim2.new(0.35, 0, 0, 35)
IncreaseSpeed.Font = Enum.Font.GothamBold
IncreaseSpeed.Text = "📈 TĂNG"
IncreaseSpeed.TextColor3 = Color3.fromRGB(0, 0, 0)
IncreaseSpeed.TextSize = 14

local IncreaseCorner = Instance.new("UICorner")
IncreaseCorner.CornerRadius = UDim.new(0, 8)
IncreaseCorner.Parent = IncreaseSpeed

-- DECREASE SPEED BUTTON
DecreaseSpeed.Name = "DecreaseSpeed"
DecreaseSpeed.Parent = ContentFrame
DecreaseSpeed.BackgroundColor3 = RGBColors[1] -- Red
DecreaseSpeed.Position = UDim2.new(0.55, 0, 0.6, 0)
DecreaseSpeed.Size = UDim2.new(0.35, 0, 0, 35)
DecreaseSpeed.Font = Enum.Font.GothamBold
DecreaseSpeed.Text = "📉 GIẢM"
DecreaseSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
DecreaseSpeed.TextSize = 14

local DecreaseCorner = Instance.new("UICorner")
DecreaseCorner.CornerRadius = UDim.new(0, 8)
DecreaseCorner.Parent = DecreaseSpeed

-- STATUS LABEL
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = ContentFrame
StatusLabel.BackgroundColor3 = RGBColors[7] -- Violet
StatusLabel.Position = UDim2.new(0.1, 0, 0.8, 0)
StatusLabel.Size = UDim2.new(0.8, 0, 0, 40)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "🔴 FLY: TẮT\n🎮 F: Bật/Tắt Fly"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 12
StatusLabel.TextWrapped = true

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusLabel

-- =============================================
-- FLY SYSTEM VARIABLES
-- =============================================
local flyEnabled = false
local bodyVelocity = nil
local bodyGyro = nil
local currentSpeed = 50
local isMinimized = false

-- =============================================
-- RAINBOW ANIMATION FUNCTION
-- =============================================
local currentColorIndex = 1
local function animateRainbow()
    while true do
        -- Animate title bar
        TitleBar.BackgroundColor3 = RGBColors[currentColorIndex]
        
        -- Animate border
        UIStroke.Color = RGBColors[currentColorIndex]
        
        currentColorIndex = currentColorIndex + 1
        if currentColorIndex > #RGBColors then
            currentColorIndex = 1
        end
        
        wait(0.5) -- Change color every 0.5 seconds
    end
end

-- =============================================
-- FLY SYSTEM FUNCTIONS
-- =============================================
local function startFlying()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Create BodyVelocity and BodyGyro
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVelocity.Parent = humanoidRootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.P = 1000
    bodyGyro.D = 50
    bodyGyro.Parent = humanoidRootPart
    
    -- Fly loop
    game:GetService("RunService").Heartbeat:Connect(function()
        if not flyEnabled or not bodyVelocity or not bodyGyro then return end
        
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        local direction = Vector3.new(0, 0, 0)
        
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
            direction = direction + workspace.CurrentCamera.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
            direction = direction - workspace.CurrentCamera.CFrame.LookVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
            direction = direction - workspace.CurrentCamera.CFrame.RightVector
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
            direction = direction + workspace.CurrentCamera.CFrame.RightVector
        end
        
        if direction.Magnitude > 0 then
            bodyVelocity.Velocity = direction.Unit * currentSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    StatusLabel.Text = "🟢 FLY: BẬT\n🎮 F: Bật/Tắt Fly\n⬆️ Space: Bay lên\n⬇️ Shift: Bay xuống"
    FlyButton.Text = "🛸 TẮT FLY"
    FlyButton.BackgroundColor3 = RGBColors[1] -- Red when active
end

local function stopFlying()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    StatusLabel.Text = "🔴 FLY: TẮT\n🎮 F: Bật/Tắt Fly"
    FlyButton.Text = "🛸 BẬT FLY"
    FlyButton.BackgroundColor3 = RGBColors[4] -- Green when inactive
end

-- =============================================
-- BUTTON EVENT HANDLERS
-- =============================================
FlyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        startFlying()
    else
        stopFlying()
    end
end)

UpButton.MouseButton1Click:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and flyEnabled then
        character.HumanoidRootPart.Position = character.HumanoidRootPart.Position + Vector3.new(0, 10, 0)
    end
end)

DownButton.MouseButton1Click:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character and flyEnabled then
        character.HumanoidRootPart.Position = character.HumanoidRootPart.Position + Vector3.new(0, -10, 0)
    end
end)

IncreaseSpeed.MouseButton1Click:Connect(function()
    currentSpeed = math.min(200, currentSpeed + 10)
    SpeedLabel.Text = "🎯 TỐC ĐỘ: " .. currentSpeed
end)

DecreaseSpeed.MouseButton1Click:Connect(function()
    currentSpeed = math.max(20, currentSpeed - 10)
    SpeedLabel.Text = "🎯 TỐC ĐỘ: " .. currentSpeed
end)

CloseButton.MouseButton1Click:Connect(function()
    stopFlying()
    main:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        ContentFrame.Visible = false
        MainFrame.Size = UDim2.new(0, 300, 0, 40)
        MinimizeButton.Text = "+"
    else
        ContentFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 300, 0, 350)
        MinimizeButton.Text = "–"
    end
end)

-- =============================================
-- KEYBIND SYSTEM
-- =============================================
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        flyEnabled = not flyEnabled
        if flyEnabled then
            startFlying()
        else
            stopFlying()
        end
    end
end)

-- =============================================
-- DRAGGABLE UI
-- =============================================
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- =============================================
-- INITIALIZE
-- =============================================
-- Start rainbow animation
spawn(animateRainbow)

-- Initial notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🌈 HIEUDRG FLY HUB",
    Text = "RGB Fly System Activated!\nPress F to toggle fly",
    Duration = 5
})

print("🌈 HIEUDRG FLY HUB - RGB Edition Loaded!")
