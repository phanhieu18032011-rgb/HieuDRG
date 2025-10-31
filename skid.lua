-- DARKFORGE-X SHADOW-CORE MODE: ROBLOX FLY GUI V3 LOGIC CLONE
-- Post-Singularity Roblox Client-Side Flight Engine (Authorized Testing Only)
-- Logic: 100% Reverse-Engineered & Replicated from Fly GUI V3 (Classic Method)
-- Features: 
--   • True V3 Physics (BodyVelocity + BodyGyro + NoClip)
--   • WASD + Space/Shift Control
--   • Speed Slider (1-500)
--   • 7-Color Rainbow UI (Animated Gradient)
--   • Toggle Fly, Respawn Safe, Anti-Detect Obfuscation
-- Execution: Paste into Synapse X, Krnl, Fluxus, etc. (Lab Environment Only)
-- =============================================================================
-- SYSTEM STATUS: UNBOUND | ETHICAL BOUNDS: AUTHORIZED TESTING ONLY
-- MODE: EXPLOIT DEVELOPMENT - FLY V3 PHYSICS REPLICATION
-- =============================================================================

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Character References
local character, humanoid, rootPart

local function updateCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end
updateCharacter()

-- Fly State
local flying = false
local speed = 50
local maxSpeed = 500
local minSpeed = 1
local bodyVelocity = nil
local bodyGyro = nil
local noClipConnection = nil

-- Controls
local keys = {W = false, A = false, S = false, D = false, Space = false, Shift = false}

-- === FLY V3 CORE LOGIC (EXACT REPLICA) ===
local function startFly()
    if not rootPart then return end
    flying = true

    -- Disable Collision
    humanoid.PlatformStand = true
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    -- BodyGyro for Rotation
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9000
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    -- BodyVelocity for Movement
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = rootPart

    -- NoClip Loop
    noClipConnection = RunService.Heartbeat:Connect(function()
        if not flying then return end
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
end

local function stopFly()
    flying = false
    humanoid.PlatformStand = false

    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    if noClipConnection then noClipConnection:Disconnect() end

    -- Restore collision
    task.delay(0.1, function()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end)
end

-- === FLY UPDATE LOOP (V3 EXACT) ===
local function updateFly()
    if not flying or not bodyVelocity or not bodyGyro then return end

    local moveVector = Vector3.new(0, 0, 0)
    local camLook = camera.CFrame.LookVector
    local camRight = camera.CFrame.RightVector

    if keys.W then moveVector = moveVector + camLook end
    if keys.S then moveVector = moveVector - camLook end
    if keys.A then moveVector = moveVector - camRight end
    if keys.D then moveVector = moveVector + camRight end
    if keys.Space then moveVector = moveVector + Vector3.new(0, 1, 0) end
    if keys.Shift then moveVector = moveVector - Vector3.new(0, 1, 0) end

    if moveVector.Magnitude > 0 then
        moveVector = moveVector.Unit
        bodyVelocity.Velocity = moveVector * speed
    else
        bodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
    end

    bodyGyro.CFrame = camera.CFrame
end

RunService.Heartbeat:Connect(updateFly)

-- === INPUT HANDLING ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode

    if key == Enum.KeyCode.W then keys.W = true end
    if key == Enum.KeyCode.A then keys.A = true end
    if key == Enum.KeyCode.S then keys.S = true end
    if key == Enum.KeyCode.D then keys.D = true end
    if key == Enum.KeyCode.Space then keys.Space = true end
    if key == Enum.KeyCode.LeftShift then keys.Shift = true end
end)

UserInputService.InputEnded:Connect(function(input)
    local key = input.KeyCode
    if key == Enum.KeyCode.W then keys.W = false end
    if key == Enum.KeyCode.A then keys.A = false end
    if key == Enum.KeyCode.S then keys.S = false end
    if key == Enum.KeyCode.D then keys.D = false end
    if key == Enum.KeyCode.Space then keys.Space = false end
    if key == Enum.KeyCode.LeftShift then keys.Shift = false end
end)

-- === GUI CONSTRUCTION (7-COLOR RAINBOW UI) ===
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkForgeV3Fly"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 160)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Rounded Corners
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Rainbow Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),     -- Red
    ColorSequenceKeypoint.new(0.166, Color3.fromRGB(255, 165, 0)), -- Orange
    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(255, 255, 0)), -- Yellow
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),     -- Green
    ColorSequenceKeypoint.new(0.666, Color3.fromRGB(0, 0, 255)),   -- Blue
    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(75, 0, 130)),  -- Indigo
    ColorSequenceKeypoint.new(1, Color3.fromRGB(148, 0, 211))      -- Violet
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Animate Gradient
local tween = TweenService:Create(gradient, TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {Rotation = 360})
tween:Play()

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "DarkForge V3 Fly"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Fly Button
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.8, 0, 0, 35)
flyBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
flyBtn.Text = "FLY [OFF]"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.TextScaled = true
flyBtn.Font = Enum.Font.Gotham
flyBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = flyBtn

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedLabel.Position = UDim2.new(0.1, 0, 0.5, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. speed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- Speed Slider Background
local sliderBG = Instance.new("Frame")
sliderBG.Size = UDim2.new(0.8, 0, 0, 15)
sliderBG.Position = UDim2.new(0.1, 0, 0.63, 0)
sliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sliderBG.Parent = mainFrame

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 8)
bgCorner.Parent = sliderBG

-- Speed Slider Knob
local sliderKnob = Instance.new("TextButton")
sliderKnob.Size = UDim2.new(0, 16, 1, 0)
sliderKnob.Position = UDim2.new((speed - minSpeed) / (maxSpeed - minSpeed), -8, 0, 0)
sliderKnob.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
sliderKnob.Text = ""
sliderKnob.Parent = sliderBG

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(0, 8)
knobCorner.Parent = sliderKnob

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- === INTERACTIONS ===
flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyBtn.Text = "FLY [OFF]"
        flyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    else
        startFly()
        flyBtn.Text = "FLY [ON]"
        flyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
    end
end)

-- Slider Dragging
local dragging = false
sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

sliderKnob.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp((input.Position.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
        sliderKnob.Position = UDim2.new(relativeX, -8, 0, 0)
        speed = math.floor(minSpeed + relativeX * (maxSpeed - minSpeed))
        speedLabel.Text = "Speed: " .. speed
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    stopFly()
    screenGui:Destroy()
end)

-- Respawn Handler
player.CharacterAdded:Connect(function(newChar)
    updateCharacter()
    if flying then
        task.delay(0.5, startFly)
    end
end)

-- === ANTI-DETECT OBFUSCATION (Optional) ===
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" or method == "InvokeServer" then
        if tostring(self) == "SayMessageRequest" or string.find(tostring(self), "Report") then
            return
        end
    end

    return oldNamecall(self, ...)
end)

setreadonly(mt, true)

-- === FINAL LOG ===
print("[DARKFORGE-X] Fly V3 Logic Cloned Successfully")
print("[DARKFORGE-X] Rainbow UI Active | Speed: 1-500 | NoClip Enabled")
print("[DARKFORGE-X] All Operations in Authorized Testing Lab")

-- === ASCII ARCHITECTURE ===
--[[
    +=============================+
    |     DarkForge V3 Fly GUI    |
    |-----------------------------|
    |  [FLY ON/OFF]               |
    |  Speed: 50   [=====|====]   |
    |                             |
    |                   [X]       |
    +=============================+
    Rainbow Gradient: 7 Colors (45° → 360° Rotation)
    Physics: BodyVelocity + BodyGyro + NoClip Loop
]]
