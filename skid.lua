-- HIEUDRG FLY HUB - RGB 7 COLOR EDITION
-- Based on FlyGuiV3 - Removed Up/Down Buttons

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local mini2 = Instance.new("TextButton")

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

main.Name = "HieuDRGFlyHub"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- MAIN FRAME WITH RGB GRADIENT BACKGROUND
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 250, 0, 180)
Frame.ClipsDescendants = true

-- ADD MODERN CORNERS AND BORDER
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = RGBColors[4] -- Green border
UIStroke.Thickness = 2
UIStroke.Parent = Frame

-- TITLE LABEL WITH RAINBOW EFFECT
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = RGBColors[1] -- Red start
TextLabel.Position = UDim2.new(0.1, 0, 0, 0)
TextLabel.Size = UDim2.new(0.8, 0, 0, 35)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "🌈 HIEUDRG FLY HUB"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 16

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TextLabel

-- FLY TOGGLE BUTTON
onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = RGBColors[4] -- Green
onof.Position = UDim2.new(0.1, 0, 0.25, 0)
onof.Size = UDim2.new(0.8, 0, 0, 40)
onof.Font = Enum.Font.GothamBold
onof.Text = "🛸 BẬT FLY"
onof.TextColor3 = Color3.fromRGB(255, 255, 255)
onof.TextSize = 14

local OnOffCorner = Instance.new("UICorner")
OnOffCorner.CornerRadius = UDim.new(0, 8)
OnOffCorner.Parent = onof

local OnOffStroke = Instance.new("UIStroke")
OnOffStroke.Color = RGBColors[5] -- Blue border
OnOffStroke.Thickness = 2
OnOffStroke.Parent = onof

-- SPEED LABEL
speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = RGBColors[5] -- Blue
speed.Position = UDim2.new(0.1, 0, 0.5, 0)
speed.Size = UDim2.new(0.8, 0, 0, 30)
speed.Font = Enum.Font.GothamBold
speed.Text = "🎯 Tốc độ: 50"
speed.TextColor3 = Color3.fromRGB(255, 255, 255)
speed.TextSize = 14

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = speed

-- INCREASE SPEED BUTTON
plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = RGBColors[3] -- Yellow
plus.Position = UDim2.new(0.1, 0, 0.7, 0)
plus.Size = UDim2.new(0.35, 0, 0, 30)
plus.Font = Enum.Font.GothamBold
plus.Text = "📈 TĂNG"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextSize = 12

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 6)
PlusCorner.Parent = plus

-- DECREASE SPEED BUTTON
mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = RGBColors[1] -- Red
mine.Position = UDim2.new(0.55, 0, 0.7, 0)
mine.Size = UDim2.new(0.35, 0, 0, 30)
mine.Font = Enum.Font.GothamBold
mine.Text = "📉 GIẢM"
mine.TextColor3 = Color3.fromRGB(255, 255, 255)
mine.TextSize = 12

local MineCorner = Instance.new("UICorner")
MineCorner.CornerRadius = UDim.new(0, 6)
MineCorner.Parent = mine

-- CLOSE BUTTON
closebutton.Name = "closebutton"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = RGBColors[1] -- Red
closebutton.Position = UDim2.new(0.8, 0, 0.05, 0)
closebutton.Size = UDim2.new(0, 25, 0, 25)
closebutton.Font = Enum.Font.GothamBold
closebutton.Text = "×"
closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)
closebutton.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = closebutton

-- MINIMIZE BUTTON
mini.Name = "mini"
mini.Parent = Frame
mini.BackgroundColor3 = RGBColors[3] -- Yellow
mini.Position = UDim2.new(0.65, 0, 0.05, 0)
mini.Size = UDim2.new(0, 25, 0, 25)
mini.Font = Enum.Font.GothamBold
mini.Text = "–"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.TextSize = 16

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = mini

-- STATUS LABEL
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "statusLabel"
statusLabel.Parent = Frame
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
statusLabel.Size = UDim2.new(0.8, 0, 0, 20)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "🔴 Đang tắt | F: Bật/Tắt"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

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
        -- Animate title
        TextLabel.BackgroundColor3 = RGBColors[currentColorIndex]
        
        -- Animate border
        UIStroke.Color = RGBColors[currentColorIndex]
        
        currentColorIndex = currentColorIndex + 1
        if currentColorIndex > #RGBColors then
            currentColorIndex = 1
        end
        
        wait(0.5)
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
        
        -- Horizontal movement
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
        
        -- Vertical movement
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction + Vector3.new(0, -1, 0)
        end
        
        -- Apply speed
        if direction.Magnitude > 0 then
            bodyVelocity.Velocity = direction.Unit * currentSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Update UI
    statusLabel.Text = "🟢 Đang bật | F: Bật/Tắt"
    onof.Text = "🛸 TẮT FLY"
    onof.BackgroundColor3 = RGBColors[1] -- Red when active
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
    
    -- Update UI
    statusLabel.Text = "🔴 Đang tắt | F: Bật/Tắt"
    onof.Text = "🛸 BẬT FLY"
    onof.BackgroundColor3 = RGBColors[4] -- Green when inactive
end

-- =============================================
-- BUTTON EVENT HANDLERS
-- =============================================
onof.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        startFlying()
    else
        stopFlying()
    end
end)

plus.MouseButton1Click:Connect(function()
    currentSpeed = math.min(200, currentSpeed + 10)
    speed.Text = "🎯 Tốc độ: " .. currentSpeed
end)

mine.MouseButton1Click:Connect(function()
    currentSpeed = math.max(20, currentSpeed - 10)
    speed.Text = "🎯 Tốc độ: " .. currentSpeed
end)

closebutton.MouseButton1Click:Connect(function()
    stopFlying()
    main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        onof.Visible = false
        speed.Visible = false
        plus.Visible = false
        mine.Visible = false
        statusLabel.Visible = false
        Frame.Size = UDim2.new(0, 250, 0, 35)
        mini.Text = "+"
    else
        onof.Visible = true
        speed.Visible = true
        plus.Visible = true
        mine.Visible = true
        statusLabel.Visible = true
        Frame.Size = UDim2.new(0, 250, 0, 180)
        mini.Text = "–"
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
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TextLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TextLabel.InputChanged:Connect(function(input)
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
    Text = "Fly System Activated!\nPress F to toggle fly",
    Duration = 5
})

print("🌈 HIEUDRG FLY HUB - Based on FlyGuiV3")
print("🎮 Controls: W/A/S/D + Space/Shift")
print("🎯 Press F to toggle fly quickly")
