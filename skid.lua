-- Fly GUI Script for Roblox (Educational Use Only - Use at Own Risk)
-- Author: Compiled from Community Examples (2025)
-- Features: Toggle with 'F', Speed Control, Draggable GUI
-- Warning: Violates ToS - May Result in Ban

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")  -- Works for R6/R15

-- Fly Variables
local Flying = false
local FlySpeed = 50
local MaxSpeed = 100
local MinSpeed = 10
local BodyVelocity = nil
local BodyGyro = nil
local Connection = nil

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGUI"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Active = true
MainFrame.Draggable = true  -- Draggable GUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Fly GUI v2025"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleFly"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)  -- Green for On
ToggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 30)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.Text = "Fly: OFF (Press F)"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(0, 4)
UICornerBtn.Parent = ToggleButton

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = MainFrame
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Position = UDim2.new(0.1, 0, 0.65, 0)
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 20)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Text = "Speed: " .. FlySpeed
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 12

local SpeedUpButton = Instance.new("TextButton")
SpeedUpButton.Name = "SpeedUp"
SpeedUpButton.Parent = MainFrame
SpeedUpButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SpeedUpButton.Position = UDim2.new(0.1, 0, 0.8, 0)
SpeedUpButton.Size = UDim2.new(0.35, 0, 0, 25)
SpeedUpButton.Font = Enum.Font.Gotham
SpeedUpButton.Text = "+"
SpeedUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedUpButton.TextSize = 18

local SpeedDownButton = Instance.new("TextButton")
SpeedDownButton.Name = "SpeedDown"
SpeedDownButton.Parent = MainFrame
SpeedDownButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
SpeedDownButton.Position = UDim2.new(0.55, 0, 0.8, 0)
SpeedDownButton.Size = UDim2.new(0.35, 0, 0, 25)
SpeedDownButton.Font = Enum.Font.Gotham
SpeedDownButton.Text = "-"
SpeedDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDownButton.TextSize = 18

-- Add corners to speed buttons
local UICornerUp = Instance.new("UICorner")
UICornerUp.CornerRadius = UDim.new(0, 4)
UICornerUp.Parent = SpeedUpButton

local UICornerDown = Instance.new("UICorner")
UICornerDown.CornerRadius = UDim.new(0, 4)
UICornerDown.Parent = SpeedDownButton

-- Functions
local function StartFly()
    if not Character or not RootPart then return end
    Flying = true
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = RootPart

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    BodyGyro.CFrame = RootPart.CFrame
    BodyGyro.Parent = RootPart

    Humanoid.PlatformStand = true

    ToggleButton.Text = "Fly: ON (Press F to Stop)"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)  -- Red for On

    Connection = RunService.Heartbeat:Connect(function()
        if not Flying or not RootPart then return end
        local Camera = workspace.CurrentCamera
        local MoveVector = Vector3.new(0, 0, 0)

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            MoveVector = MoveVector + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            MoveVector = MoveVector - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            MoveVector = MoveVector - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            MoveVector = MoveVector + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            MoveVector = MoveVector + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            MoveVector = MoveVector - Vector3.new(0, 1, 0)
        end

        BodyVelocity.Velocity = MoveVector * FlySpeed
        BodyGyro.CFrame = Camera.CFrame
    end)
end

local function StopFly()
    Flying = false
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    if Connection then Connection:Disconnect() end
    Humanoid.PlatformStand = false

    ToggleButton.Text = "Fly: OFF (Press F)"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
end

-- Key Bind (F to Toggle)
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    if GameProcessed then return end
    if Input.KeyCode == Enum.KeyCode.F then
        if Flying then
            StopFly()
        else
            StartFly()
        end
    end
end)

-- GUI Buttons
ToggleButton.MouseButton1Click:Connect(function()
    if Flying then
        StopFly()
    else
        StartFly()
    end
end)

SpeedUpButton.MouseButton1Click:Connect(function()
    FlySpeed = math.min(FlySpeed + 10, MaxSpeed)
    SpeedLabel.Text = "Speed: " .. FlySpeed
end)

SpeedDownButton.MouseButton1Click:Connect(function()
    FlySpeed = math.max(FlySpeed - 10, MinSpeed)
    SpeedLabel.Text = "Speed: " .. FlySpeed
end)

-- Handle Character Respawn
Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    if Flying then
        StartFly()  -- Restart fly if was on
    end
end)

print("Fly GUI Loaded! Press F to toggle. Use at your own risk.")
