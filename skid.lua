-- HieuDRG Hub v7.0 - Universal Roblox Script with FlyGuiV3 Integration
-- Supports ALL Games (October 2025 Edition)
-- Features: Fly (FlyGuiV3 Logic), Noclip, Speed, High Jump, AntiBan/AFK, ESP Players/Mods (7 Colors)
-- WARNING: For educational/authorized testing only. Violates Roblox ToS - Use test accounts.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables
local HubGui = nil
local MainFrame = nil
local ToggleButton = nil
local IsMenuOpen = false
local StartTime = tick()

-- Feature States
local FlyEnabled = false
local FlySpeed = 50  -- Default from FlyGuiV3
local BodyVelocity = nil
local BodyAngularVelocity = nil
local NoclipEnabled = false
local NoclipConnection = nil
local SpeedEnabled = false
local SpeedValue = 50
local SpeedConnection = nil
local HighJumpEnabled = false
local JumpPower = 100
local JumpConnection = nil
local AntiBanEnabled = false
local AntiAFKConnection = nil
local ESPEnabled = false
local ESPConnections = {}
local ColorIndex = 1
local ESPModEnabled = false
local ESPModConnections = {}

-- 7 Colors for ESP
local ESPColors = {
    Color3.fromRGB(255, 0, 0),   -- Red
    Color3.fromRGB(0, 255, 0),   -- Green
    Color3.fromRGB(0, 0, 255),   -- Blue
    Color3.fromRGB(255, 255, 0), -- Yellow
    Color3.fromRGB(255, 0, 255), -- Magenta
    Color3.fromRGB(0, 255, 255), -- Cyan
    Color3.fromRGB(255, 165, 0)  -- Orange
}

-- Uptime Function
local function GetUptime()
    local uptime = tick() - StartTime
    local hours = math.floor(uptime / 3600)
    local minutes = math.floor((uptime % 3600) / 60)
    local seconds = math.floor(uptime % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- FlyGuiV3 Logic (Integrated - BodyVelocity with WASD/Space/Shift Controls)
local function ToggleFly()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        -- Create BodyVelocity and BodyAngularVelocity (Core of FlyGuiV3)
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = RootPart

        BodyAngularVelocity = Instance.new("BodyAngularVelocity")
        BodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
        BodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
        BodyAngularVelocity.Parent = RootPart
    else
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyAngularVelocity then BodyAngularVelocity:Destroy() end
    end
end

-- Fly Movement Loop (FlyGuiV3 Style)
RunService.Heartbeat:Connect(function()
    if FlyEnabled and RootPart and BodyVelocity then
        local cam = workspace.CurrentCamera
        local moveVector = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector = moveVector + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVector = moveVector - Vector3.new(0, 1, 0) end
        BodyVelocity.Velocity = moveVector.Unit * FlySpeed
    end
end)

-- Noclip Toggle
local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
    if NoclipEnabled then
        NoclipConnection = RunService.Stepped:Connect(function()
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    else
        if NoclipConnection then NoclipConnection:Disconnect() end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Speed Toggle
local function ToggleSpeed()
    SpeedEnabled = not SpeedEnabled
    if SpeedEnabled then
        SpeedConnection = RunService.Heartbeat:Connect(function()
            Humanoid.WalkSpeed = SpeedValue
        end)
    else
        if SpeedConnection then SpeedConnection:Disconnect() end
        Humanoid.WalkSpeed = 16
    end
end

-- High Jump Toggle
local function ToggleHighJump()
    HighJumpEnabled = not HighJumpEnabled
    if HighJumpEnabled then
        JumpConnection = RunService.Heartbeat:Connect(function()
            Humanoid.JumpPower = JumpPower
        end)
    else
        if JumpConnection then JumpConnection:Disconnect() end
        Humanoid.JumpPower = 50
    end
end

-- AntiBan/AFK Toggle (Simulate activity, prevent kick/reset)
local function ToggleAntiBan()
    AntiBanEnabled = not AntiBanEnabled
    if AntiBanEnabled then
        AntiAFKConnection = RunService.Heartbeat:Connect(function()
            -- Simulate small movements to prevent AFK kick
            if RootPart then
                RootPart.CFrame = RootPart.CFrame * CFrame.new(math.random(-1,1)/10, 0, math.random(-1,1)/10)
            end
            -- Anti-Reset: Reload on CharacterAdded
            LocalPlayer.CharacterAdded:Connect(function(newChar)
                Character = newChar
                Humanoid = newChar:WaitForChild("Humanoid")
                RootPart = newChar:WaitForChild("HumanoidRootPart")
                -- Reload features
                if FlyEnabled then ToggleFly() ToggleFly() end  -- Toggle twice to re-enable
                if NoclipEnabled then ToggleNoclip() end
                if SpeedEnabled then ToggleSpeed() end
                if HighJumpEnabled then ToggleHighJump() end
            end)
        end)
    else
        if AntiAFKConnection then AntiAFKConnection:Disconnect() end
    end
end

-- ESP Players Toggle (7 Colors, Random per Player)
local function ToggleESPP()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = ESPColors[math.random(1, #ESPColors)]
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                ESPConnections[player] = highlight
            end
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(1)
                if ESPEnabled then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = ESPColors[math.random(1, #ESPColors)]
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    ESPConnections[player] = highlight
                end
            end)
        end)
    else
        for player, highlight in pairs(ESPConnections) do
            if highlight then highlight:Destroy() end
        end
        ESPConnections = {}
    end
end

-- ESP Mods Toggle (7 Colors, Filter for "Mod/Admin" in Name)
local function ToggleESPM()
    ESPModEnabled = not ESPModEnabled
    if ESPModEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local nameLower = player.Name:lower()
                if string.find(nameLower, "mod") or string.find(nameLower, "admin") or string.find(nameLower, "owner") then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = ESPColors[math.random(1, #ESPColors)]
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.3
                    highlight.OutlineTransparency = 0
                    ESPModConnections[player] = highlight
                end
            end
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(1)
                if ESPModEnabled then
                    local nameLower = player.Name:lower()
                    if string.find(nameLower, "mod") or string.find(nameLower, "admin") or string.find(nameLower, "owner") then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.FillColor = ESPColors[math.random(1, #ESPColors)]
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.FillTransparency = 0.3
                        highlight.OutlineTransparency = 0
                        ESPModConnections[player] = highlight
                    end
                end
            end)
        end)
    else
        for player, highlight in pairs(ESPModConnections) do
            if highlight then highlight:Destroy() end
        end
        ESPModConnections = {}
    end
end

-- Create UI Menu (FILE Style)
local function CreateUI()
    -- ScreenGui
    HubGui = Instance.new("ScreenGui")
    HubGui.Name = "HieuDRGHub"
    HubGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    HubGui.ResetOnSpawn = false
    HubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Toggle Button (Floating - Open/Close Menu)
    ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Parent = HubGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(0, 10, 0, 10)
    ToggleButton.Size = UDim2.new(0, 150, 0, 50)
    ToggleButton.Font = Enum.Font.SourceSansBold
    ToggleButton.Text = "HieuDRG Hub - Open"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 14

    -- Main Frame (Draggable Menu)
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = HubGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 400, 0, 350)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Title Frame (FILE Style)
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Name = "TitleFrame"
    TitleFrame.Parent = MainFrame
    TitleFrame.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    TitleFrame.BorderSizePixel = 0
    TitleFrame.Size = UDim2.new(1, 0, 0, 60)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TitleFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -30, 0, 30)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = "HieuDRG Hub"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Player Name/Avatar Label
    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Name = "PlayerLabel"
    PlayerLabel.Parent = TitleFrame
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Position = UDim2.new(0, 10, 0, 30)
    PlayerLabel.Size = UDim2.new(0.5, 0, 0, 20)
    PlayerLabel.Font = Enum.Font.SourceSans
    PlayerLabel.Text = "Player: " .. LocalPlayer.Name
    PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Avatar Image (Simple - Use Player Icon if available)
    local AvatarImage = Instance.new("ImageLabel")
    AvatarImage.Name = "AvatarImage"
    AvatarImage.Parent = TitleFrame
    AvatarImage.BackgroundTransparency = 1
    AvatarImage.Position = UDim2.new(0.5, 0, 0, 5)
    AvatarImage.Size = UDim2.new(0, 40, 0, 40)
    AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48).content

    -- Uptime Label
    local UptimeLabel = Instance.new("TextLabel")
    UptimeLabel.Name = "UptimeLabel"
    UptimeLabel.Parent = TitleFrame
    UptimeLabel.BackgroundTransparency = 1
    UptimeLabel.Position = UDim2.new(0.6, 0, 0, 30)
    UptimeLabel.Size = UDim2.new(0.4, 0, 0, 20)
    UptimeLabel.Font = Enum.Font.SourceSans
    UptimeLabel.Text = "Uptime: 00:00:00"
    UptimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UptimeLabel.TextSize = 12
    UptimeLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Close Button (X to Close Menu)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleFrame
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 5)
    CloseButton.Size = UDim2.new(0, 25, 0, 25)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.TextSize = 16

    -- Scrolling Frame for Features
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Parent = MainFrame
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.Position = UDim2.new(0, 0, 0, 60)
    ScrollFrame.Size = UDim2.new(1, 0, 1, -60)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    ScrollFrame.ScrollBarThickness = 8

    local yPos = 0

    local function AddToggleButton(name, callback, isOn)
        local Button = Instance.new("TextButton")
        Button.Name = name .. "Button"
        Button.Parent = ScrollFrame
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Button.BorderSizePixel = 0
        Button.Position = UDim2.new(0, 10, 0, yPos)
        Button.Size = UDim2.new(1, -20, 0, 30)
        Button.Font = Enum.Font.SourceSans
        Button.Text = name .. ": " .. (isOn and "ON" or "OFF")
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.MouseButton1Click:Connect(function()
            callback()
            Button.Text = name .. ": " .. (not isOn and "ON" or "OFF")
            isOn = not isOn
        end)
        yPos = yPos + 40
        return Button
    end

    -- Fly Toggle + Speed Adjust (FlyGuiV3)
    local FlyButton = AddToggleButton("Fly", ToggleFly, FlyEnabled)
    local FlySpeedLabel = Instance.new("TextLabel")
    FlySpeedLabel.Parent = ScrollFrame
    FlySpeedLabel.BackgroundTransparency = 1
    FlySpeedLabel.Position = UDim2.new(0, 10, 0, yPos)
    FlySpeedLabel.Size = UDim2.new(1, -20, 0, 20)
    FlySpeedLabel.Text = "Fly Speed: " .. FlySpeed
    FlySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    yPos = yPos + 25

    local IncreaseFly = Instance.new("TextButton")
    IncreaseFly.Parent = ScrollFrame
    IncreaseFly.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    IncreaseFly.Position = UDim2.new(0.7, 0, 0, yPos)
    IncreaseFly.Size = UDim2.new(0, 30, 0, 20)
    IncreaseFly.Text = "+"
    IncreaseFly.TextColor3 = Color3.fromRGB(255, 255, 255)
    IncreaseFly.MouseButton1Click:Connect(function()
        FlySpeed = FlySpeed + 10
        FlySpeedLabel.Text = "Fly Speed: " .. FlySpeed
    end)

    local DecreaseFly = Instance.new("TextButton")
    DecreaseFly.Parent = ScrollFrame
    DecreaseFly.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    DecreaseFly.Position = UDim2.new(0.8, 0, 0, yPos)
    DecreaseFly.Size = UDim2.new(0, 30, 0, 20)
    DecreaseFly.Text = "-"
    DecreaseFly.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecreaseFly.MouseButton1Click:Connect(function()
        FlySpeed = math.max(10, FlySpeed - 10)
        FlySpeedLabel.Text = "Fly Speed: " .. FlySpeed
    end)
    yPos = yPos + 40

    -- Noclip
    AddToggleButton("Noclip", ToggleNoclip, NoclipEnabled)

    -- Speed Boots + Adjust
    local SpeedButton = AddToggleButton("Speed Boots", ToggleSpeed, SpeedEnabled)
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Parent = ScrollFrame
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Position = UDim2.new(0, 10, 0, yPos)
    SpeedLabel.Size = UDim2.new(1, -20, 0, 20)
    SpeedLabel.Text = "Speed: " .. SpeedValue
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    yPos = yPos + 25

    local IncreaseSpeed = Instance.new("TextButton")
    IncreaseSpeed.Parent = ScrollFrame
    IncreaseSpeed.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    IncreaseSpeed.Position = UDim2.new(0.7, 0, 0, yPos)
    IncreaseSpeed.Size = UDim2.new(0, 30, 0, 20)
    IncreaseSpeed.Text = "+"
    IncreaseSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
    IncreaseSpeed.MouseButton1Click:Connect(function()
        SpeedValue = SpeedValue + 10
        SpeedLabel.Text = "Speed: " .. SpeedValue
    end)

    local DecreaseSpeed = Instance.new("TextButton")
    DecreaseSpeed.Parent = ScrollFrame
    DecreaseSpeed.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    DecreaseSpeed.Position = UDim2.new(0.8, 0, 0, yPos)
    DecreaseSpeed.Size = UDim2.new(0, 30, 0, 20)
    DecreaseSpeed.Text = "-"
    DecreaseSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
    DecreaseSpeed.MouseButton1Click:Connect(function()
        SpeedValue = math.max(16, SpeedValue - 10)
        SpeedLabel.Text = "Speed: " .. SpeedValue
    end)
    yPos = yPos + 40

    -- High Jump
    AddToggleButton("High Jump", ToggleHighJump, HighJumpEnabled)

    -- AntiBan/AFK
    AddToggleButton("AntiBan/AFK", ToggleAntiBan, AntiBanEnabled)
    yPos = yPos + 40

    -- ESP Players
    AddToggleButton("ESP Players (7 Colors)", ToggleESPP, ESPEnabled)

    -- ESP Mods
    AddToggleButton("ESP Mods (7 Colors)", ToggleESPM, ESPModEnabled)

    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

    -- Toggle Menu Events
    ToggleButton.MouseButton1Click:Connect(function()
        IsMenuOpen = not IsMenuOpen
        MainFrame.Visible = IsMenuOpen
        ToggleButton.Text = "HieuDRG Hub - " .. (IsMenuOpen and "Close" or "Open")
    end)

    CloseButton.MouseButton1Click:Connect(function()
        IsMenuOpen = false
        MainFrame.Visible = false
        ToggleButton.Text = "HieuDRG Hub - Open"
    end)

    -- Update Uptime Loop
    spawn(function()
        while wait(1) do
            if UptimeLabel then
                UptimeLabel.Text = "Uptime: " .. GetUptime()
            end
        end
    end)

    -- Handle Respawn (Reload Features)
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = newChar:WaitForChild("Humanoid")
        RootPart = newChar:WaitForChild("HumanoidRootPart")
        wait(1)
        -- Reload enabled features
        if NoclipEnabled then ToggleNoclip() end
        if SpeedEnabled then ToggleSpeed() end
        if HighJumpEnabled then ToggleHighJump() end
        if FlyEnabled then ToggleFly() end
    end)
end

-- Initialize UI
CreateUI()

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "HieuDRG Hub Loaded";
    Text = "Universal script with FlyGuiV3 ready! Toggle menu to start.";
    Duration = 5;
})

print("HieuDRG Hub v7.0 - Loaded successfully. Fly with WASD/Space/Shift!")
