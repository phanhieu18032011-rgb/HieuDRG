-- HIEUDRG FLY - SIMPLE VERSION
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- TẠO UI ĐƠN GIẢN
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
Title.Text = "🛸 HIEUDRG FLY HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- NÚT BẬT FLY
local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(0.8, 0, 0, 40)
FlyToggle.Position = UDim2.new(0.1, 0, 0.1, 40)
FlyToggle.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
FlyToggle.Text = "🛸 BẬT FLY"
FlyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyToggle.TextSize = 14
FlyToggle.Parent = MainFrame

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 30)
SpeedLabel.Position = UDim2.new(0.1, 0, 0.3, 40)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Tốc độ: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Parent = MainFrame

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Size = UDim2.new(0.8, 0, 0, 30)
SpeedSlider.Position = UDim2.new(0.1, 0, 0.4, 40)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
SpeedSlider.Text = "TĂNG TỐC ĐỘ"
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.Parent = MainFrame

-- FLY SYSTEM
local FlyEnabled = false
local BodyVelocity, BodyGyro

FlyToggle.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        FlyToggle.Text = "🛸 TẮT FLY"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(170, 85, 85)
        ActivateFly()
    else
        FlyToggle.Text = "🛸 BẬT FLY"
        FlyToggle.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
        DeactivateFly()
    end
end)

local CurrentSpeed = 50
SpeedSlider.MouseButton1Click:Connect(function()
    CurrentSpeed = CurrentSpeed + 10
    if CurrentSpeed > 100 then CurrentSpeed = 20 end
    SpeedLabel.Text = "Tốc độ: " .. CurrentSpeed
end)

function ActivateFly()
    local character = Player.Character
    if not character then return end
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    BodyVelocity.Parent = character.HumanoidRootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    BodyGyro.Parent = character.HumanoidRootPart
    
    game:GetService("RunService").Heartbeat:Connect(function()
        if not FlyEnabled then return end
        
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        local direction = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + Vector3.new(0, 0, -1) end
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction + Vector3.new(0, 0, 1) end
        if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction + Vector3.new(-1, 0, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + Vector3.new(1, 0, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction + Vector3.new(0, -1, 0) end
        
        BodyVelocity.Velocity = direction * CurrentSpeed
    end)
end

function DeactivateFly()
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
end

-- THÔNG BÁO
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "HIEUDRG FLY HUB",
    Text = "Đã load thành công! Nhấn nút để bay",
    Duration = 5
})
