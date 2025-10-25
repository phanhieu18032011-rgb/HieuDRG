-- HIEUDRG FLY HUB - WORKING VERSION
-- SIMPLE UI WITH FLY SYSTEM

-- Sử dụng library đơn giản hơn
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()

local Window = Library:CreateWindow("🛸 HIEUDRG FLY HUB", "Premium Fly System")

-- FLY SETTINGS
local FlySettings = {
    Enabled = false,
    Speed = 50,
    VerticalSpeed = 50,
    FlyKey = "F"
}

local BodyVelocity, BodyGyro, FlyConnection

-- TẠO TABS
local MainTab = Window:CreateTab("🚀 Fly Control")
local SettingsTab = Window:CreateTab("⚙️ Settings")
local VisualsTab = Window:CreateTab("🎨 Visuals")

-- MAIN TAB CONTENT
MainTab:CreateSection("Fly System")

MainTab:CreateToggle("🛸 Enable Fly", false, function(State)
    FlySettings.Enabled = State
    if State then
        ActivateFly()
        Library:CreateNotification("Fly", "Fly Activated! Press " .. FlySettings.FlyKey, 5)
    else
        DeactivateFly()
        Library:CreateNotification("Fly", "Fly Deactivated", 3)
    end
end)

MainTab:CreateButton("🎯 Quick Fly Toggle", function()
    Library:CreateNotification("Quick Fly", "Hold " .. FlySettings.FlyKey .. " to fly", 4)
    SetupQuickFly()
end)

MainTab:CreateButton("🌀 Infinite Fly", function()
    FlySettings.Enabled = true
    ActivateFly()
    Library:CreateNotification("Infinite Fly", "Unlimited fly activated!", 4)
end)

-- SETTINGS TAB
SettingsTab:CreateSection("Speed Control")

SettingsTab:CreateSlider("Horizontal Speed", 1, 200, 50, true, function(Value)
    FlySettings.Speed = Value
end)

SettingsTab:CreateSlider("Vertical Speed", 1, 100, 50, true, function(Value)
    FlySettings.VerticalSpeed = Value
end)

SettingsTab:CreateSection("Controls")

SettingsTab:CreateDropdown("Fly Style", {"Default", "Smooth", "Boost", "Drift"}, "Default", function(Value)
    FlySettings.Style = Value
end)

SettingsTab:CreateKeybind("Fly Key", "F", function(Key)
    FlySettings.FlyKey = Key
    Library:CreateNotification("Key Updated", "Fly key: " .. Key, 3)
end)

SettingsTab:CreateToggle("Auto No-Clip", false, function(State)
    FlySettings.NoClip = State
end)

-- VISUALS TAB
VisualsTab:CreateSection("Effects")

VisualsTab:CreateToggle("Trail Effect", false, function(State)
    if State then
        CreateFlyTrail()
    else
        RemoveFlyTrail()
    end
end)

VisualsTab:CreateToggle("Sparkle Effect", false, function(State)
    if State then
        CreateSparkleEffect()
    else
        RemoveSparkleEffect()
    end
end)

VisualsTab:CreateColorpicker("Trail Color", Color3.fromRGB(255, 105, 180), function(Color)
    UpdateTrailColor(Color)
end)

-- FLY SYSTEM FUNCTIONS
function ActivateFly()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Tạo BodyVelocity
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    BodyVelocity.Parent = rootPart
    
    -- Tạo BodyGyro
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    BodyGyro.P = 1000
    BodyGyro.D = 50
    BodyGyro.Parent = rootPart
    
    -- Bật no-clip nếu được enable
    if FlySettings.NoClip then
        UpdateNoClip()
    end
    
    -- Vòng lặp bay
    FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not FlySettings.Enabled or not BodyVelocity or not BodyGyro then return end
        
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        local direction = Vector3.new()
        
        -- Di chuyển ngang
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
        
        -- Di chuyển dọc
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        -- Áp dụng tốc độ
        BodyVelocity.Velocity = direction.Unit * FlySettings.Speed + Vector3.new(0, direction.Y * FlySettings.VerticalSpeed, 0)
    end)
end

function DeactivateFly()
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    if BodyGyro then
        BodyGyro:Destroy()
        BodyGyro = nil
    end
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    DisableNoClip()
    RemoveFlyTrail()
    RemoveSparkleEffect()
end

function UpdateNoClip()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not FlySettings.NoClip
        end
    end
end

function EnableNoClip()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

function DisableNoClip()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
end

function CreateFlyTrail()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local trail = Instance.new("Trail")
    trail.Attachment0 = Instance.new("Attachment", rootPart)
    trail.Attachment1 = Instance.new("Attachment", rootPart)
    trail.Attachment1.Position = Vector3.new(0, 0, -2)
    trail.Color = ColorSequence.new(Color3.fromRGB(255, 105, 180))
    trail.Lifetime = 0.5
    trail.Parent = rootPart
end

function RemoveFlyTrail()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    for _, child in pairs(rootPart:GetChildren()) do
        if child:IsA("Trail") then
            child:Destroy()
        end
    end
end

function CreateSparkleEffect()
    -- Thêm hiệu ứng sparkle ở đây
end

function RemoveSparkleEffect()
    -- Xóa hiệu ứng sparkle ở đây
end

function UpdateTrailColor(color)
    -- Cập nhật màu trail ở đây
end

function SetupQuickFly()
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode[FlySettings.FlyKey] then
            FlySettings.Enabled = true
            ActivateFly()
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode[FlySettings.FlyKey] then
            FlySettings.Enabled = false
            DeactivateFly()
        end
    end)
end

-- KEYBIND SYSTEM
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode[FlySettings.FlyKey] then
        FlySettings.Enabled = not FlySettings.Enabled
        if FlySettings.Enabled then
            ActivateFly()
        else
            DeactivateFly()
        end
    end
end)

-- Khởi tạo UI
Library:Init()

-- Thông báo khởi động
Library:CreateNotification("HIEUDRG FLY HUB", "Fly System Loaded! Press " .. FlySettings.FlyKey, 6)
