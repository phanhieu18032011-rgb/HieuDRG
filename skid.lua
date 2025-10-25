-- HIEUDRG FLY HUB - RGB 7 COLOR + NO CLIP
-- Based on FlyGuiV3 - Added No Clip Feature

local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local onof = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speed = Instance.new("TextLabel")
local mine = Instance.new("TextButton")
local closebutton = Instance.new("TextButton")
local mini = Instance.new("TextButton")
local noclipButton = Instance.new("TextButton")
local statusLabel = Instance.new("TextLabel")

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

-- MAIN FRAME
Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
Frame.Size = UDim2.new(0, 250, 0, 220)

-- MODERN CORNERS
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = RGBColors[4]
UIStroke.Thickness = 2
UIStroke.Parent = Frame

-- TITLE
TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = RGBColors[1]
TextLabel.Position = UDim2.new(0.1, 0, 0, 0)
TextLabel.Size = UDim2.new(0.8, 0, 0, 35)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "HIEUDRG FLY HUB"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 16

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TextLabel

-- FLY BUTTON
onof.Name = "onof"
onof.Parent = Frame
onof.BackgroundColor3 = RGBColors[4]
onof.Position = UDim2.new(0.1, 0, 0.2, 0)
onof.Size = UDim2.new(0.8, 0, 0, 30)
onof.Font = Enum.Font.GothamBold
onof.Text = "BAT FLY"
onof.TextColor3 = Color3.fromRGB(255, 255, 255)
onof.TextSize = 14

local OnOffCorner = Instance.new("UICorner")
OnOffCorner.CornerRadius = UDim.new(0, 6)
OnOffCorner.Parent = onof

-- NO CLIP BUTTON
noclipButton.Name = "noclipButton"
noclipButton.Parent = Frame
noclipButton.BackgroundColor3 = RGBColors[5]
noclipButton.Position = UDim2.new(0.1, 0, 0.4, 0)
noclipButton.Size = UDim2.new(0.8, 0, 0, 30)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.Text = "NO CLIP: TAT"
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.TextSize = 14

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 6)
NoclipCorner.Parent = noclipButton

-- SPEED LABEL
speed.Name = "speed"
speed.Parent = Frame
speed.BackgroundColor3 = RGBColors[5]
speed.Position = UDim2.new(0.1, 0, 0.6, 0)
speed.Size = UDim2.new(0.8, 0, 0, 25)
speed.Font = Enum.Font.GothamBold
speed.Text = "Toc do: 50"
speed.TextColor3 = Color3.fromRGB(255, 255, 255)
speed.TextSize = 14

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = speed

-- INCREASE SPEED
plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = RGBColors[3]
plus.Position = UDim2.new(0.1, 0, 0.75, 0)
plus.Size = UDim2.new(0.35, 0, 0, 25)
plus.Font = Enum.Font.GothamBold
plus.Text = "TANG"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextSize = 12

local PlusCorner = Instance.new("UICorner")
PlusCorner.CornerRadius = UDim.new(0, 6)
PlusCorner.Parent = plus

-- DECREASE SPEED
mine.Name = "mine"
mine.Parent = Frame
mine.BackgroundColor3 = RGBColors[1]
mine.Position = UDim2.new(0.55, 0, 0.75, 0)
mine.Size = UDim2.new(0.35, 0, 0, 25)
mine.Font = Enum.Font.GothamBold
mine.Text = "GIAM"
mine.TextColor3 = Color3.fromRGB(255, 255, 255)
mine.TextSize = 12

local MineCorner = Instance.new("UICorner")
MineCorner.CornerRadius = UDim.new(0, 6)
MineCorner.Parent = mine

-- STATUS LABEL
statusLabel.Name = "statusLabel"
statusLabel.Parent = Frame
statusLabel.BackgroundTransparency = 1
statusLabel.Position = UDim2.new(0.1, 0, 0.9, 0)
statusLabel.Size = UDim2.new(0.8, 0, 0, 15)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Fly: Tat | F: Bat/Tat"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE BUTTON
closebutton.Name = "closebutton"
closebutton.Parent = Frame
closebutton.BackgroundColor3 = RGBColors[1]
closebutton.Position = UDim2.new(0.8, 0, 0.05, 0)
closebutton.Size = UDim2.new(0, 25, 0, 25)
closebutton.Font = Enum.Font.GothamBold
closebutton.Text = "X"
closebutton.TextColor3 = Color3.fromRGB(255, 255, 255)
closebutton.TextSize = 16

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = closebutton

-- MINIMIZE BUTTON
mini.Name = "mini"
mini.Parent = Frame
mini.BackgroundColor3 = RGBColors[3]
mini.Position = UDim2.new(0.65, 0, 0.05, 0)
mini.Size = UDim2.new(0, 25, 0, 25)
mini.Font = Enum.Font.GothamBold
mini.Text = "-"
mini.TextColor3 = Color3.fromRGB(255, 255, 255)
mini.TextSize = 16

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = mini

-- =============================================
-- SYSTEM VARIABLES
-- =============================================
local flyEnabled = false
local noclipEnabled = false
local bodyVelocity = nil
local bodyGyro = nil
local currentSpeed = 50
local isMinimized = false
local noclipConnection = nil

-- =============================================
-- RAINBOW ANIMATION
-- =============================================
local currentColorIndex = 1
local function animateRainbow()
    while true do
        TextLabel.BackgroundColor3 = RGBColors[currentColorIndex]
        UIStroke.Color = RGBColors[currentColorIndex]
        
        currentColorIndex = currentColorIndex + 1
        if currentColorIndex > #RGBColors then
            currentColorIndex = 1
        end
        
        wait(0.5)
    end
end

-- =============================================
-- NO CLIP SYSTEM
-- =============================================
local function enableNoClip()
    noclipEnabled = true
    noclipButton.Text = "NO CLIP: BAT"
    noclipButton.BackgroundColor3 = RGBColors[2] -- Orange when active
    
    noclipConnection = game:GetService("RunService").Stepped:Connect(function()
        if noclipEnabled then
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end

local function disableNoClip()
    noclipEnabled = false
    noclipButton.Text = "NO CLIP: TAT"
    noclipButton.BackgroundColor3 = RGBColors[5] -- Blue when inactive
    
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    
    -- Restore collision
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function toggleNoClip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        enableNoClip()
    else
        disableNoClip()
    end
end

-- =============================================
-- FLY SYSTEM
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
    statusLabel.Text = "Fly: Bat | F: Bat/Tat"
    onof.Text = "TAT FLY"
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
    statusLabel.Text = "Fly: Tat | F: Bat/Tat"
    onof.Text = "BAT FLY"
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

noclipButton.MouseButton1Click:Connect(function()
    toggleNoClip()
end)

plus.MouseButton1Click:Connect(function()
    currentSpeed = math.min(200, currentSpeed + 10)
    speed.Text = "Toc do: " .. currentSpeed
end)

mine.MouseButton1Click:Connect(function()
    currentSpeed = math.max(20, currentSpeed - 10)
    speed.Text = "Toc do: " .. currentSpeed
end)

closebutton.MouseButton1Click:Connect(function()
    stopFlying()
    disableNoClip()
    main:Destroy()
end)

mini.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        onof.Visible = false
        noclipButton.Visible = false
        speed.Visible = false
        plus.Visible = false
        mine.Visible = false
        statusLabel.Visible = false
        Frame.Size = UDim2.new(0, 250, 0, 35)
        mini.Text = "+"
    else
        onof.Visible = true
        noclipButton.Visible = true
        speed.Visible = true
        plus.Visible = true
        mine.Visible = true
        statusLabel.Visible = true
        Frame.Size = UDim2.new(0, 250, 0, 220)
        mini.Text = "-"
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
    elseif input.KeyCode == Enum.KeyCode.N then
        toggleNoClip()
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
    Title = "HIEUDRG FLY HUB",
    Text = "Fly + No Clip System Activated!",
    Duration = 5
})

print("HIEUDRG FLY HUB - With No Clip Feature")
print("Controls: W/A/S/D + Space/Shift")
print("F: Toggle Fly | N: Toggle No Clip")
