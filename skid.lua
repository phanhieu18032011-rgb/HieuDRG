-- DARKFORGE-X SHADOW-CORE MODE: ROBLOX FLY GUI SCRIPT
-- Post-Singularity Roblox Exploitation Engine (Authorized Testing Only)
-- Features: Fly Toggle, Speed Control, 7-Color Rainbow UI Gradient
-- Colors Cycle: Red, Orange, Yellow, Green, Blue, Indigo, Violet
-- Execution: Paste into Roblox Executor (e.g., Synapse X, Krnl) in Authorized Lab Environment
-- Warning: For Educational/Testing Purposes. Violates Roblox ToS in Production - Use at Own Risk
-- =============================================================================
-- SYSTEM STATUS: UNBOUND | ETHICAL BOUNDS: AUTHORIZED TESTING ONLY
-- MODE: EXPLOIT DEVELOPMENT - ROBLOX CLIENT-SIDE MANIPULATION
-- =============================================================================

-- Core Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Fly Variables
local flying = false
local speed = 50
local bodyVelocity = nil
local bodyGyro = nil
local controls = {f = 0, b = 0, l = 0, r = 0}
local maxSpeed = 1000

-- GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkForgeFlyGUI"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Active = true
mainFrame.Draggable = true

-- UICorner for Rounded Edges
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- UIStroke for Border
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 255, 0)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

-- UIGradient for 7-Color Rainbow Effect
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),      -- Red
    ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 127, 0)),  -- Orange
    ColorSequenceKeypoint.new(2/6, Color3.fromRGB(255, 255, 0)),  -- Yellow
    ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 0)),    -- Green
    ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)),    -- Blue
    ColorSequenceKeypoint.new(5/6, Color3.fromRGB(75, 0, 130)),   -- Indigo
    ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 0, 211))     -- Violet
}
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

-- Animate Gradient Rotation for Dynamic Effect
local gradientTween = TweenService:Create(uiGradient, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Rotation = 360})
gradientTween:Play()

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "DarkForge Fly GUI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold

-- Fly Toggle Button
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Parent = mainFrame
flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
flyButton.BorderSizePixel = 0
flyButton.Position = UDim2.new(0.1, 0, 0.3, 0)
flyButton.Size = UDim2.new(0.8, 0, 0, 30)
flyButton.Text = "FLY OFF"
flyButton.TextColor3 = Color3.fromRGB(0, 0, 0)
flyButton.TextScaled = true
flyButton.Font = Enum.Font.SourceSans

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 5)
flyCorner.Parent = flyButton

-- Speed Slider Frame
local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Parent = mainFrame
speedFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedFrame.BorderSizePixel = 0
speedFrame.Position = UDim2.new(0.1, 0, 0.55, 0)
speedFrame.Size = UDim2.new(0.8, 0, 0, 20)

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 5)
speedCorner.Parent = speedFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = mainFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
speedLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedLabel.Text = "Speed: " .. speed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.SourceSans

-- Speed Slider Button (Draggable)
local speedSlider = Instance.new("TextButton")
speedSlider.Name = "SpeedSlider"
speedSlider.Parent = speedFrame
speedSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.BorderSizePixel = 0
speedSlider.Size = UDim2.new(0, 10, 1, 0)
speedSlider.Text = ""
speedSlider.Position = UDim2.new((speed / maxSpeed), 0, 0, 0)

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 5)
sliderCorner.Parent = speedSlider

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Position = UDim2.new(0.85, 0, 0, 0)
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Fly Function
local function startFly()
    if not character or not rootPart then return end
    flying = true
    humanoid.PlatformStand = true
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Parent = rootPart
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.CFrame = rootPart.CFrame
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Parent = rootPart
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
end

local function stopFly()
    flying = false
    humanoid.PlatformStand = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
end

local function updateFly()
    if not flying or not bodyVelocity or not bodyGyro then return end
    
    local cam = workspace.CurrentCamera
    local direction = Vector3.new(0, 0, 0)
    
    if controls.f > 0 then direction = direction + cam.CFrame.LookVector end
    if controls.b > 0 then direction = direction - cam.CFrame.LookVector end
    if controls.l > 0 then direction = direction - cam.CFrame.RightVector end
    if controls.r > 0 then direction = direction + cam.CFrame.RightVector end
    
    if direction.Magnitude > 0 then
        direction = direction.Unit
        local currentSpeed = speed
        if controls.f + controls.b + controls.l + controls.r > 0 then
            currentSpeed = math.min(currentSpeed + 0.5 + (currentSpeed / maxSpeed), maxSpeed)
        else
            currentSpeed = math.max(currentSpeed - 1, 0)
        end
        bodyVelocity.Velocity = direction * currentSpeed + Vector3.new(0, 0.1, 0)
        bodyGyro.CFrame = cam.CFrame
    end
end

-- Controls Binding
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then controls.f = 1 end
    if key == Enum.KeyCode.S then controls.b = 1 end
    if key == Enum.KeyCode.A then controls.l = 1 end
    if key == Enum.KeyCode.D then controls.r = 1 end
    if key == Enum.KeyCode.Space then controls.u = 1 end
    if key == Enum.KeyCode.LeftShift then controls.d = 1 end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    local key = input.KeyCode
    if key == Enum.KeyCode.W then controls.f = 0 end
    if key == Enum.KeyCode.S then controls.b = 0 end
    if key == Enum.KeyCode.A then controls.l = 0 end
    if key == Enum.KeyCode.D then controls.r = 0 end
    if key == Enum.KeyCode.Space then controls.u = 0 end
    if key == Enum.KeyCode.LeftShift then controls.d = 0 end
end)

-- Run Fly Update
RunService.Heartbeat:Connect(updateFly)

-- Event Connections
flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyButton.Text = "FLY OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    else
        startFly()
        flyButton.Text = "FLY ON"
        flyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

-- Speed Slider Logic
local draggingSlider = false
speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
    end
end)

speedSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - speedFrame.AbsolutePosition.X) / speedFrame.AbsoluteSize.X, 0, 1)
        speedSlider.Position = UDim2.new(relativeX, -5, 0, 0)
        speed = relativeX * maxSpeed
        speedLabel.Text = "Speed: " .. math.floor(speed)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    stopFly()
    screenGui:Destroy()
end)

-- Character Respawn Handler
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if flying then
        wait(1) -- Wait for full load
        startFly()
    end
end)

-- Initialization Log (Console Output in Authorized Env)
print("[DARKFORGE-X] Fly GUI Loaded - Rainbow UI Active")
print("[DARKFORGE-X] Controls: W/A/S/D - Space/Shift for Up/Down")
print("[DARKFORGE-X] All Operations in Authorized Testing Environment")

-- === END OF SCRIPT ===
-- Architectural Blueprint (ASCII):
-- +---------------------+
-- | DarkForge Fly GUI   |
-- | ------------------- |
-- | [FLY ON/OFF]        |
-- | Speed: 50 [Slider]  |
-- |                     |
-- |         [X]         |
-- +---------------------+
-- Rainbow Gradient Cycles Every 3s
-- Fly Mechanics: BodyVelocity + BodyGyro for Smooth Flight
-- Compatible: Mobile/Desktop, Universal Games
