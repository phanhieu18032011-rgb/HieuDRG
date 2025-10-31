-- Universal Fly GUI V3 by Grok (Inspired by community scripts, 2025)
-- Features: Toggle Fly, Speed Control, Draggable GUI, Mobile Support

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local flying = false
local speed = 50
local bodyVelocity = nil
local bodyAngularVelocity = nil
local connection = nil

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Active = true
mainFrame.Draggable = true -- Draggable GUI

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Stroke for style
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title Label
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Parent = mainFrame
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)
title.Font = Enum.Font.GothamBold
title.Text = "Fly GUI V3"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Parent = mainFrame
flyButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
flyButton.Position = UDim2.new(0.1, 0, 0.3, 0)
flyButton.Size = UDim2.new(0.8, 0, 0, 30)
flyButton.Font = Enum.Font.Gotham
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 14

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 5)
flyCorner.Parent = flyButton

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Parent = mainFrame
speedLabel.BackgroundTransparency = 1
speedLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
speedLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedLabel.Font = Enum.Font.Gotham
speedLabel.Text = "Speed: " .. speed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 12

-- Speed Up Button
local speedUp = Instance.new("TextButton")
speedUp.Name = "SpeedUp"
speedUp.Parent = mainFrame
speedUp.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
speedUp.Position = UDim2.new(0.1, 0, 0.75, 0)
speedUp.Size = UDim2.new(0.35, 0, 0, 25)
speedUp.Font = Enum.Font.Gotham
speedUp.Text = "+"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.TextSize = 18

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0, 5)
upCorner.Parent = speedUp

-- Speed Down Button
local speedDown = Instance.new("TextButton")
speedDown.Name = "SpeedDown"
speedDown.Parent = mainFrame
speedDown.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
speedDown.Position = UDim2.new(0.55, 0, 0.75, 0)
speedDown.Size = UDim2.new(0.35, 0, 0, 25)
speedDown.Font = Enum.Font.Gotham
speedDown.Text = "-"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextSize = 18

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0, 5)
downCorner.Parent = speedDown

-- Unload Button
local unloadButton = Instance.new("TextButton")
unloadButton.Name = "UnloadButton"
unloadButton.Parent = mainFrame
unloadButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
unloadButton.Position = UDim2.new(0.1, 0, 0.9, 0)
unloadButton.Size = UDim2.new(0.8, 0, 0, 25)
unloadButton.Font = Enum.Font.Gotham
unloadButton.Text = "Unload"
unloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
unloadButton.TextSize = 14

local unloadCorner = Instance.new("UICorner")
unloadCorner.CornerRadius = UDim.new(0, 5)
unloadCorner.Parent = unloadButton

-- Fly Function
local function startFly()
    if flying then return end
    flying = true
    flyButton.Text = "Fly: ON"
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    bodyAngularVelocity = Instance.new("BodyAngularVelocity")
    bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    bodyAngularVelocity.Parent = rootPart
    
    connection = RunService.Heartbeat:Connect(function()
        if not flying or not character or not rootPart then return end
        
        local camera = workspace.CurrentCamera
        local moveVector = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveVector * speed
    end)
end

local function stopFly()
    flying = false
    flyButton.Text = "Fly: OFF"
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyAngularVelocity then
        bodyAngularVelocity:Destroy()
        bodyAngularVelocity = nil
    end
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Events
flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
    else
        startFly()
    end
end)

speedUp.MouseButton1Click:Connect(function()
    speed = speed + 10
    if speed > 200 then speed = 200 end
    speedLabel.Text = "Speed: " .. speed
end)

speedDown.MouseButton1Click:Connect(function()
    speed = speed - 10
    if speed < 10 then speed = 10 end
    speedLabel.Text = "Speed: " .. speed
end)

unloadButton.MouseButton1Click:Connect(function()
    stopFly()
    screenGui:Destroy()
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if flying then
        startFly() -- Restart fly if was on
    end
end)

print("Fly GUI loaded! Use W/A/S/D/Space/Shift to control.")
