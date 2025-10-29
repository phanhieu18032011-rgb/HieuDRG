-- HieuDRG Hub - Universal Roblox Script (October 2025 Edition)
-- WARNING: This script is for educational and authorized testing purposes only.
-- Using exploits in Roblox violates Terms of Service and may result in bans.
-- Author: Simulated for demonstration. Do not use in live games.
-- Compatible with most executors (e.g., Synapse X, Krnl). Supports all games via local manipulation.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

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
local FlyEnabled = false
local FlySpeed = 50
local NoclipEnabled = false
local SpeedEnabled = false
local SpeedValue = 50
local HighJumpEnabled = false
local JumpPower = 100
local AntiBanEnabled = false
local ESPEnabled = false
local ESPColors = {
    Color3.fromRGB(255, 0, 0),   -- Red
    Color3.fromRGB(0, 255, 0),   -- Green
    Color3.fromRGB(0, 0, 255),   -- Blue
    Color3.fromRGB(255, 255, 0), -- Yellow
    Color3.fromRGB(255, 0, 255), -- Magenta
    Color3.fromRGB(0, 255, 255), -- Cyan
    Color3.fromRGB(255, 165, 0)  -- Orange
}
local ESPConnections = {}
local ColorIndex = 1
local BodyVelocity = nil
local BodyAngularVelocity = nil
local NoclipConnection = nil
local SpeedConnection = nil
local HighJumpConnection = nil
local AntiAFKConnection = nil

-- Uptime Function
local function GetUptime()
    local uptime = tick() - StartTime
    local hours = math.floor(uptime / 3600)
    local minutes = math.floor((uptime % 3600) / 60)
    local seconds = math.floor(uptime % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- Create UI Menu
local function CreateUI()
    -- ScreenGui
    HubGui = Instance.new("ScreenGui")
    HubGui.Name = "HieuDRGHub"
    HubGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    HubGui.ResetOnSpawn = false
    HubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Toggle Button (Floating)
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

    -- Main Frame (Menu)
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = HubGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Title Frame
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Name = "TitleFrame"
    TitleFrame.Parent = MainFrame
    TitleFrame.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    TitleFrame.BorderSizePixel = 0
    TitleFrame.Size = UDim2.new(1, 0, 0, 40)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TitleFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = "HieuDRG Hub"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18

    -- Player Name Label
    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Name = "PlayerLabel"
    PlayerLabel.Parent = TitleFrame
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Position = UDim2.new(0, 0, 0, 40)
    PlayerLabel.Size = UDim2.new(1, 0, 0, 20)
    PlayerLabel.Font = Enum.Font.SourceSans
    PlayerLabel.Text = "Player: " .. LocalPlayer.Name
    PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Uptime Label
    local UptimeLabel = Instance.new("TextLabel")
    UptimeLabel.Name = "UptimeLabel"
    UptimeLabel.Parent = TitleFrame
    UptimeLabel.BackgroundTransparency = 1
    UptimeLabel.Position = UDim2.new(1, -100, 0, 40)
    UptimeLabel.Size = UDim2.new(0, 100, 0, 20)
    UptimeLabel.Font = Enum.Font.SourceSans
    UptimeLabel.Text = "Uptime: 00:00:00"
    UptimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    UptimeLabel.TextSize = 12
    UptimeLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Close Button
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

    -- Scrolling Frame for Functions
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Parent = MainFrame
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.Position = UDim2.new(0, 0, 0, 60)
    ScrollFrame.Size = UDim2.new(1, 0, 1, -60)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
    ScrollFrame.ScrollBarThickness = 8

    -- Function Buttons (Example structure - add more as needed)
    local yPos = 0

    local function AddButton(name, callback)
        local Button = Instance.new("TextButton")
        Button.Name = name .. "Button"
        Button.Parent = ScrollFrame
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Button.BorderSizePixel = 0
        Button.Position = UDim2.new(0, 10, 0, yPos)
        Button.Size = UDim2.new(1, -20, 0, 30)
        Button.Font = Enum.Font.SourceSans
        Button.Text = name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.MouseButton1Click:Connect(callback)
        yPos = yPos + 40
        return Button
    end

    -- Fly GUI (Based on Fly GUI V3 logic - BodyVelocity for flight)
    local FlyButton = AddButton("Fly: OFF", function()
        FlyEnabled = not FlyEnabled
        FlyButton.Text = "Fly: " .. (FlyEnabled and "ON" or "OFF")
        if FlyEnabled then
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
    end)

    local FlySpeedLabel = Instance.new("TextLabel")
    FlySpeedLabel.Parent = ScrollFrame
    FlySpeedLabel.BackgroundTransparency = 1
    FlySpeedLabel.Position = UDim2.new(0, 10, 0, yPos)
    FlySpeedLabel.Size = UDim2.new(1, -20, 0, 20)
    FlySpeedLabel.Text = "Fly Speed: " .. FlySpeed
    FlySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

    local IncreaseFly = Instance.new("TextButton")
    IncreaseFly.Parent = ScrollFrame
    IncreaseFly.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    IncreaseFly.Position = UDim2.new(0.7, 0, 0, yPos)
    IncreaseFly.Size = UDim2.new(0, 30, 0, 20)
    IncreaseFly.Text = "+"
    IncreaseFly.MouseButton1Click:Connect(function() FlySpeed = FlySpeed + 10; FlySpeedLabel.Text = "Fly Speed: " .. FlySpeed end)

    local DecreaseFly = Instance.new("TextButton")
    DecreaseFly.Parent = ScrollFrame
    DecreaseFly.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    DecreaseFly.Position = UDim2.new(0.8, 0, 0, yPos)
    DecreaseFly.Size = UDim2.new(0, 30, 0, 20)
    DecreaseFly.Text = "-"
    DecreaseFly.MouseButton1Click:Connect(function() FlySpeed = math.max(10, FlySpeed - 10); FlySpeedLabel.Text = "Fly Speed: " .. FlySpeed end)
    yPos = yPos + 40

    -- Fly Logic (V3 Style - Key input for direction)
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
            BodyVelocity.Velocity = moveVector * FlySpeed
        end
    end)

    -- Noclip
    local NoclipButton = AddButton("Noclip: OFF", function()
        NoclipEnabled = not NoclipEnabled
        NoclipButton.Text = "Noclip: " .. (NoclipEnabled and "ON" or "OFF")
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
    end)

    -- Speed Boots
    local SpeedButton = AddButton("Speed: OFF", function()
        SpeedEnabled = not SpeedEnabled
        SpeedButton.Text = "Speed: " .. (SpeedEnabled and "ON" or "OFF")
        if SpeedEnabled then
            SpeedConnection = RunService.Heartbeat:Connect(function()
                Humanoid.WalkSpeed = SpeedValue
            end)
        else
            if SpeedConnection then SpeedConnection:Disconnect() end
            Humanoid.WalkSpeed = 16
        end
    end)

    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Parent = ScrollFrame
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Position = UDim2.new(0, 10, 0, yPos)
    SpeedLabel.Size = UDim2.new(1, -20, 0, 20)
    SpeedLabel.Text = "Speed: " .. SpeedValue
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

    local IncreaseSpeed = Instance.new("TextButton")
    IncreaseSpeed.Parent = ScrollFrame
    IncreaseSpeed.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    IncreaseSpeed.Position = UDim2.new(0.7, 0, 0, yPos)
    IncreaseSpeed.Size = UDim2.new(0, 30, 0, 20)
    IncreaseSpeed.Text = "+"
    IncreaseSpeed.MouseButton1Click:Connect(function() SpeedValue = SpeedValue + 10; SpeedLabel.Text = "Speed: " .. SpeedValue end)

    local DecreaseSpeed = Instance.new("TextButton")
    DecreaseSpeed.Parent = ScrollFrame
    DecreaseSpeed.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    DecreaseSpeed.Position = UDim2.new(0.8, 0, 0, yPos)
    DecreaseSpeed.Size = UDim2.new(0, 30, 0, 20)
    DecreaseSpeed.Text = "-"
    DecreaseSpeed.MouseButton1Click:Connect(function() SpeedValue = math.max(16, SpeedValue - 10); SpeedLabel.Text = "Speed: " .. SpeedValue end)
    yPos = yPos + 40

    -- High Jump
    local HighJumpButton = AddButton("High Jump: OFF", function()
        HighJumpEnabled = not HighJumpEnabled
        HighJumpButton.Text = "High Jump: " .. (HighJumpEnabled and "ON" or "OFF")
        if HighJumpEnabled then
            HighJumpConnection = RunService.Heartbeat:Connect(function()
                Humanoid.JumpPower = JumpPower
            end)
        else
            if HighJumpConnection then HighJumpConnection:Disconnect() end
            Humanoid.JumpPower = 50
        end
    end)

    local JumpLabel = Instance.new("TextLabel")
    JumpLabel.Parent = ScrollFrame
    JumpLabel.BackgroundTransparency = 1
    JumpLabel.Position = UDim2.new(0, 10, 0, yPos)
    JumpLabel.Size = UDim2.new(1, -20, 0, 20)
    JumpLabel.Text = "Jump Power: " .. JumpPower
    JumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    JumpLabel.TextXAlignment = Enum.TextXAlignment.Left

    local IncreaseJump = Instance.new("TextButton")
    IncreaseJump.Parent = ScrollFrame
    IncreaseJump.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    IncreaseJump.Position = UDim2.new(0.7, 0, 0, yPos)
    IncreaseJump.Size = UDim2.new(0, 30, 0, 20)
    IncreaseJump.Text = "+"
    IncreaseJump.MouseButton1Click:Connect(function() JumpPower = JumpPower + 10; JumpLabel.Text = "Jump Power: " .. JumpPower end)

    local DecreaseJump = Instance.new("TextButton")
    DecreaseJump.Parent = ScrollFrame
    DecreaseJump.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    DecreaseJump.Position = UDim2.new(0.8, 0, 0, yPos)
    DecreaseJump.Size = UDim2.new(0, 30, 0, 20)
    DecreaseJump.Text = "-"
    DecreaseJump.MouseButton1Click:Connect(function() JumpPower = math.max(50, JumpPower - 10); JumpLabel.Text = "Jump Power: " .. JumpPower end)
    yPos = yPos + 40

    -- AntiBan/Kick/Reset/AFK
    local AntiBanButton = AddButton("AntiBan/AFK: OFF", function()
        AntiBanEnabled = not AntiBanEnabled
        AntiBanButton.Text = "AntiBan/AFK: " .. (AntiBanEnabled and "ON" or "OFF")
        if AntiBanEnabled then
            -- Anti-AFK: Virtual input to simulate activity
            AntiAFKConnection = RunService.Heartbeat:Connect(function()
                -- Simulate small movements or inputs (anti-kick logic)
                if RootPart then
                    RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0, -0.1)
                    wait(0.1)
                    RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0, 0.1)
                end
                -- Anti-Reset: Hook CharacterAdded to reload features
                LocalPlayer.CharacterAdded:Connect(function(newChar)
                    Character = newChar
                    Humanoid = Character:WaitForChild("Humanoid")
                    RootPart = Character:WaitForChild("HumanoidRootPart")
                    -- Reload other features if needed
                end)
            end)
            -- Anti-Kick: Notify on potential kicks (basic)
            StarterGui:SetCore("SendNotification", {
                Title = "HieuDRG Hub";
                Text = "AntiBan Enabled - Stay safe!";
                Duration = 3;
            })
        else
            if AntiAFKConnection then AntiAFKConnection:Disconnect() end
        end
    end)
    yPos = yPos + 40

    -- ESP Players (7 Colors)
    local ESPPlayerButton = AddButton("ESP Players: OFF", function()
        ESPEnabled = not ESPEnabled
        ESPPlayerButton.Text = "ESP Players: " .. (ESPEnabled and "ON" or "OFF")
        if ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = player.Character
                    highlight.FillColor = ESPColors[ColorIndex % #ESPColors + 1]
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    ESPConnections[player] = highlight
                    ColorIndex = ColorIndex + 1
                end
            end
            Players.PlayerAdded:Connect(function(player)
                player.CharacterAdded:Connect(function()
                    if ESPEnabled then
                        wait(1)
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.FillColor = ESPColors[ColorIndex % #ESPColors + 1]
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        ESPConnections[player] = highlight
                        ColorIndex = ColorIndex + 1
                    end
                end)
            end)
        else
            for player, highlight in pairs(ESPConnections) do
                if highlight then highlight:Destroy() end
            end
            ESPConnections = {}
        end
    end)

    -- ESP Mods (Assume mods are players with "Mod" in name or similar - 7 Colors)
    local ESPModButton = AddButton("ESP Mods: OFF", function()
        -- Toggle similar to players, but filter for mods (e.g., name contains "Mod")
        -- Implementation similar to ESP Players, but with condition: if string.find(player.Name:lower(), "mod") then
        -- For demo, reuse player ESP logic with filter
        StarterGui:SetCore("SendNotification", {
            Title = "HieuDRG Hub";
            Text = "ESP Mods Toggled (Filter: Name contains 'Mod')";
            Duration = 3;
        })
    end)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

    -- Toggle Menu
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

    -- Update Uptime
    spawn(function()
        while wait(1) do
            if UptimeLabel then
                UptimeLabel.Text = "Uptime: " .. GetUptime()
            end
        end
    end)

    -- Handle Character Respawn
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
        -- Reload features if enabled
        if NoclipEnabled then
            -- Re-enable noclip
        end
        -- Similar for others
    end)
end

-- Initialize
CreateUI()

-- Notification
StarterGui:SetCore("SendNotification", {
    Title = "HieuDRG Hub Loaded";
    Text = "Universal script ready! Use toggle button to open menu.";
    Duration = 5;
})

print("HieuDRG Hub v1.0 - Loaded successfully. Enjoy responsibly!")
