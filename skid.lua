-- Fly GUI V3 Simple (Universal - Works on most games 2025)
-- Author: Inspired by ozoneYT & community scripts
-- Load: Paste into executor like Krnl/Synapse

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local flying = false
local speed = 50
local bodyVelocity = nil
local bodyGyro = nil
local connection = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "Fly GUI V3"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, -20, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 40)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.Text = "Toggle Fly (F)"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Parent = frame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. speed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Parent = frame

local speedUpButton = Instance.new("TextButton")
speedUpButton.Size = UDim2.new(0.45, 0, 0, 25)
speedUpButton.Position = UDim2.new(0, 10, 0, 105)
speedUpButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
speedUpButton.Text = "+"
speedUpButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedUpButton.TextScaled = true
speedUpButton.Parent = frame

local speedDownButton = Instance.new("TextButton")
speedDownButton.Size = UDim2.new(0.45, 0, 0, 25)
speedDownButton.Position = UDim2.new(0.55, 0, 0, 105)
speedDownButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedDownButton.Text = "-"
speedDownButton.TextColor3 = Color3.fromRGB(0, 0, 0)
speedDownButton.TextScaled = true
speedDownButton.Parent = frame

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "Fly GUI Loaded";
    Text = "Press F to toggle, +/- for speed";
    Duration = 5;
})

-- Fly Function
local function startFly()
    if flying then return end
    flying = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart
    
    connection = RunService.Heartbeat:Connect(function()
        if not flying or not character or not humanoidRootPart then return end
        
        local camera = workspace.CurrentCamera
        local moveVector = humanoid.MoveDirection
        
        if moveVector.Magnitude > 0 then
            bodyVelocity.Velocity = (camera.CFrame.LookVector * moveVector.Z + camera.CFrame.RightVector * moveVector.X) * speed + Vector3.new(0, moveVector.Y * speed, 0)
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        bodyGyro.CFrame = camera.CFrame
    end)
    
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
end

local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    if connection then connection:Disconnect() end
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end

-- Events
toggleButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

speedUpButton.MouseButton1Click:Connect(function()
    speed = speed + 10
    speedLabel.Text = "Speed: " .. speed
end)

speedDownButton.MouseButton1Click:Connect(function()
    speed = math.max(10, speed - 10)
    speedLabel.Text = "Speed: " .. speed
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        if flying then stopFly() else startFly() end
    end
end)

-- Auto-reload on respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
    if flying then startFly() end
end)
