-- HIEUDRG FLY HUB - PREMIUM FLY SCRIPT
-- SHADOW CORE AI POWERED

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- CREATE EPIC WINDOW
local Window = Rayfield:CreateWindow({
   Name = "🛸 HIEUDRG FLY HUB",
   LoadingTitle = "HIEUDRG Premium Fly System",
   LoadingSubtitle = "Powered by Shadow Core AI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "HieuDRGConfig",
      FileName = "FlySettings"
   },
   Theme = {
      BackgroundColor = Color3.fromRGB(10, 10, 10),
      HeaderColor = Color3.fromRGB(40, 0, 80),
      TextColor = Color3.fromRGB(255, 255, 255),
      IconColor = Color3.fromRGB(255, 105, 180),
      ElementColor = Color3.fromRGB(20, 20, 20)
   }
})

-- FLY SYSTEM VARIABLES
local FlySettings = {
   Enabled = false,
   Speed = 50,
   VerticalSpeed = 50,
   NoClip = false,
   FlyKey = "F",
   Style = "Default"
}

local BodyVelocity
local BodyGyro
local FlyConnection

-- CREATE TABS
local Tabs = {
    Main = Window:CreateTab({ 
        Name = "🛸 FLY CONTROL", 
        Icon = "rbxassetid://7733716865"
    }),
    
    Settings = Window:CreateTab({ 
        Name = "⚙️ FLY SETTINGS", 
        Icon = "rbxassetid://7733716865" 
    }),
    
    Visuals = Window:CreateTab({ 
        Name = "🎨 VISUALS", 
        Icon = "rbxassetid://7733716865" 
    }),
    
    Player = Window:CreateTab({ 
        Name = "👤 PLAYER", 
        Icon = "rbxassetid://7733716865" 
    })
}

-- MAIN FLY CONTROL SECTION
local FlySection = Tabs.Main:CreateSection("🚀 FLY CONTROL SYSTEM")

Tabs.Main:AddToggle({
   Title = "🛸 ACTIVATE FLY",
   Description = "Bật/Tắt hệ thống bay",
   Default = false,
   Callback = function(Value)
        FlySettings.Enabled = Value
        if Value then
            ActivateFly()
            Rayfield:Notify({
               Title = "FLY ACTIVATED",
               Content = "Fly system enabled! Press " .. FlySettings.FlyKey .. " to fly",
               Duration = 5,
               Image = "rbxassetid://7733716865"
            })
        else
            DeactivateFly()
            Rayfield:Notify({
               Title = "FLY DEACTIVATED",
               Content = "Fly system disabled",
               Duration = 3,
               Image = "rbxassetid://7733716865"
            })
        end
   end
})

Tabs.Main:AddButton({
   Title = "🎯 QUICK FLY TOGGLE",
   Description = "Bật fly nhanh (giữ F)",
   Callback = function()
        Rayfield:Notify({
           Title = "QUICK FLY",
           Content = "Hold F to fly, release to stop",
           Duration = 4,
           Image = "rbxassetid://7733716865"
        })
        SetupQuickFly()
   end
})

Tabs.Main:AddButton({
   Title = "🌀 INFINITE FLY",
   Description = "Fly không giới hạn thời gian",
   Callback = function()
        FlySettings.Enabled = true
        ActivateFly()
        Rayfield:Notify({
           Title = "INFINITE FLY",
           Content = "Unlimited fly activated!",
           Duration = 4,
           Image = "rbxassetid://7733716865"
        })
   end
})

-- FLY STATS SECTION
local StatsSection = Tabs.Main:CreateSection("📊 FLY STATISTICS")

local SpeedDisplay = Tabs.Main:AddParagraph("CURRENT SPEED", "Horizontal: " .. FlySettings.Speed .. " | Vertical: " .. FlySettings.VerticalSpeed)
local StatusDisplay = Tabs.Main:AddParagraph("FLY STATUS", "🛑 DISABLED")

-- FLY SETTINGS TAB
local SpeedSection = Tabs.Settings:CreateSection("🎯 SPEED CONTROL")

Tabs.Settings:AddSlider({
   Title = "HORIZONTAL SPEED",
   Description = "Tốc độ bay ngang",
   Default = 50,
   Min = 1,
   Max = 200,
   Callback = function(Value)
        FlySettings.Speed = Value
        UpdateFlySpeed()
        SpeedDisplay:Set("CURRENT SPEED: Horizontal: " .. FlySettings.Speed .. " | Vertical: " .. FlySettings.VerticalSpeed)
   end
})

Tabs.Settings:AddSlider({
   Title = "VERTICAL SPEED",
   Description = "Tốc độ bay lên/xuống",
   Default = 50,
   Min = 1,
   Max = 100,
   Callback = function(Value)
        FlySettings.VerticalSpeed = Value
        UpdateFlySpeed()
        SpeedDisplay:Set("CURRENT SPEED: Horizontal: " .. FlySettings.Speed .. " | Vertical: " .. FlySettings.VerticalSpeed)
   end
})

local ControlSection = Tabs.Settings:CreateSection("🎮 CONTROL SETTINGS")

Tabs.Settings:AddDropdown({
   Title = "FLY STYLE",
   Description = "Chọn kiểu bay",
   Default = "Default",
   Options = {"Default", "Smooth", "Boost", "Drift", "Helicopter"},
   Callback = function(Value)
        FlySettings.Style = Value
        Rayfield:Notify({
           Title = "FLY STYLE CHANGED",
           Content = "Style: " .. Value,
           Duration = 3,
           Image = "rbxassetid://7733716865"
        })
   end
})

Tabs.Settings:AddKeybind({
   Title = "FLY TOGGLE KEY",
   Description = "Phím bật/tắt bay nhanh",
   Default = "F",
   Callback = function(Key)
        FlySettings.FlyKey = Key
        Rayfield:Notify({
           Title = "FLY KEY UPDATED",
           Content = "Press " .. Key .. " to toggle fly",
           Duration = 3,
           Image = "rbxassetid://7733716865"
        })
   end
})

Tabs.Settings:AddToggle({
   Title = "AUTO NO-CLIP",
   Description = "Tự động bật no-clip khi bay",
   Default = false,
   Callback = function(Value)
        FlySettings.NoClip = Value
        if FlySettings.Enabled then
            UpdateNoClip()
        end
   end
})

-- VISUALS TAB
local EffectsSection = Tabs.Visuals:CreateSection("✨ VISUAL EFFECTS")

Tabs.Visuals:AddToggle({
   Title = "TRAIL EFFECT",
   Description = "Hiệu ứng vệt đuôi khi bay",
   Default = false,
   Callback = function(Value)
        if Value then
            CreateFlyTrail()
        else
            RemoveFlyTrail()
        end
   end
})

Tabs.Visuals:AddToggle({
   Title = "SPARKLE EFFECT",
   Description = "Hiệu ứng tia lửa khi bay",
   Default = false,
   Callback = function(Value)
        if Value then
            CreateSparkleEffect()
        else
            RemoveSparkleEffect()
        end
   end
})

Tabs.Visuals:AddColorPicker({
   Title = "TRAIL COLOR",
   Description = "Chọn màu cho hiệu ứng bay",
   Default = Color3.fromRGB(255, 105, 180),
   Callback = function(Value)
        UpdateTrailColor(Value)
   end
})

local ThemeSection = Tabs.Visuals:CreateSection("🎨 UI THEME")

Tabs.Visuals:AddDropdown({
   Title = "THEME COLOR",
   Description = "Chọn màu chủ đề cho UI",
   Default = "Purple",
   Options = {"Purple", "Pink", "Blue", "Red", "Green", "Gold"},
   Callback = function(Value)
        ChangeThemeColor(Value)
   end
})

-- PLAYER TAB
local PlayerSection = Tabs.Player:CreateSection("👤 PLAYER SETTINGS")

Tabs.Player:AddSlider({
   Title = "WALKSPEED",
   Description = "Tốc độ chạy bộ",
   Default = 16,
   Min = 16,
   Max = 200,
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end
})

Tabs.Player:AddSlider({
   Title = "JUMP POWER",
   Description = "Lực nhảy",
   Default = 50,
   Min = 50,
   Max = 200,
   Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end
})

Tabs.Player:AddToggle({
   Title = "NO CLIP",
   Description = "Đi xuyên vật thể",
   Default = false,
   Callback = function(Value)
        if Value then
            EnableNoClip()
        else
            DisableNoClip()
        end
   end
})

-- FLY SYSTEM FUNCTIONS
function ActivateFly()
    local character = game.Players.LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Create BodyVelocity for movement
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    BodyVelocity.Parent = rootPart
    
    -- Create BodyGyro for stability
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    BodyGyro.P = 1000
    BodyGyro.D = 50
    BodyGyro.Parent = rootPart
    
    -- Enable no-clip if setting is on
    if FlySettings.NoClip then
        UpdateNoClip()
    end
    
    -- Start fly loop
    FlyConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not FlySettings.Enabled or not BodyVelocity or not BodyGyro then return end
        
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        local direction = Vector3.new()
        
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
            direction = direction - Vector3.new(0, 1, 0)
        end
        
        -- Apply speed based on style
        local horizontalSpeed = FlySettings.Speed
        local verticalSpeed = FlySettings.VerticalSpeed
        
        if FlySettings.Style == "Boost" then
            horizontalSpeed = horizontalSpeed * 1.5
        elseif FlySettings.Style == "Smooth" then
            horizontalSpeed = horizontalSpeed * 0.7
        end
        
        BodyVelocity.Velocity = direction.Unit * horizontalSpeed + Vector3.new(0, direction.Y * verticalSpeed, 0)
    end)
    
    StatusDisplay:Set("🟢 FLYING - Style: " .. FlySettings.Style)
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
    
    StatusDisplay:Set("🛑 DISABLED")
end

function UpdateFlySpeed()
    -- Speed updates automatically in the fly loop
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
    -- Sparkle effect implementation
end

function RemoveSparkleEffect()
    -- Remove sparkle effect implementation
end

function UpdateTrailColor(color)
    -- Update trail color implementation
end

function ChangeThemeColor(theme)
    local themeColors = {
        Purple = Color3.fromRGB(128, 0, 128),
        Pink = Color3.fromRGB(255, 105, 180),
        Blue = Color3.fromRGB(0, 120, 255),
        Red = Color3.fromRGB(255, 0, 0),
        Green = Color3.fromRGB(0, 255, 0),
        Gold = Color3.fromRGB(255, 215, 0)
    }
    
    -- Update UI theme colors here
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

-- INITIAL NOTIFICATION
Rayfield:Notify({
   Title = "🛸 HIEUDRG FLY HUB LOADED",
   Content = "Premium Fly System Activated!\nPress " .. FlySettings.FlyKey .. " to toggle fly",
   Duration = 8,
   Image = "rbxassetid://7733716865"
})

-- AUTO-UPDATE DISPLAY
task.spawn(function()
    while task.wait(1) do
        if FlySettings.Enabled then
            StatusDisplay:Set("🟢 FLYING - Style: " .. FlySettings.Style)
        else
            StatusDisplay:Set("🛑 DISABLED")
        end
    end
end)
