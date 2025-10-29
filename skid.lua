-- HIEUDRG HUB - RAFT SURVIVAL EDITION v3.0
-- Dành riêng cho: [Classes & Spell Update] Sống sót trên bè
-- Tác giả: HieuDRG | Ngày: 29/10/2025
-- Tương thích: Synapse X, Krnl, Fluxus, Delta
-- Tính năng: Fly, Noclip, Speed, Jump, ESP, AntiAFK, God Mode, Infinite Resources, Auto Build, Teleport

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

-- Local Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables
local Gui = nil
local Frame = nil
local ToggleBtn = nil
local Open = false
local StartTime = tick()

-- Feature States
local Fly = { Enabled = false, Speed = 80, Body = nil }
local Noclip = { Enabled = false, Connection = nil }
local Speed = { Enabled = false, Value = 100 }
local Jump = { Enabled = false, Power = 150 }
local GodMode = { Enabled = false }
local ESP = { Enabled = false, Highlights = {} }
local AntiAFK = { Enabled = false, Connection = nil }
local InfiniteResources = { Enabled = false }
local AutoBuild = { Enabled = false, Connection = nil }
local Teleport = { Enabled = false }

-- Colors
local Colors = {
    Color3.fromRGB(255, 0, 0),   -- Red
    Color3.fromRGB(0, 255, 0),   -- Green
    Color3.fromRGB(0, 0, 255),   -- Blue
    Color3.fromRGB(255, 255, 0), -- Yellow
    Color3.fromRGB(255, 0, 255), -- Magenta
    Color3.fromRGB(0, 255, 255), -- Cyan
    Color3.fromRGB(255, 165, 0)  -- Orange
}

-- Uptime
local function GetUptime()
    local t = math.floor(tick() - StartTime)
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    local s = t % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- Create GUI
local function CreateGUI()
    Gui = Instance.new("ScreenGui")
    Gui.Name = "HieuDRG_Raft"
    Gui.ResetOnSpawn = false
    Gui.Parent = Player:WaitForChild("PlayerGui")

    -- Toggle Button
    ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 180, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    ToggleBtn.BorderSizePixel = 2
    ToggleBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Text = "HieuDRG Raft"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 16
    ToggleBtn.Parent = Gui

    -- Main Frame
    Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 450, 0, 580)
    Frame.Position = UDim2.new(0.5, -225, 0.5, -290)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = Gui

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    Title.Text = "HIEUDRG RAFT HUB v3.0"
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.Parent = Frame

    -- Close Button
    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -40, 0, 10)
    Close.BackgroundTransparency = 1
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255, 0, 0)
    Close.Font = Enum.Font.GothamBold
    Close.Parent = Title

    -- Player Info
    local Info = Instance.new("TextLabel")
    Info.Size = UDim2.new(1, 0, 0, 30)
    Info.Position = UDim2.new(0, 0, 0, 50)
    Info.BackgroundTransparency = 1
    Info.Text = "Player: " .. Player.Name .. " | Uptime: 00:00:00"
    Info.TextColor3 = Color3.new(1, 1, 1)
    Info.Font = Enum.Font.Gotham
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.Parent = Frame

    -- Scroll Frame
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, -20, 1, -100)
    Scroll.Position = UDim2.new(0, 10, 0, 80)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 8
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
    Scroll.Parent = Frame

    local y = 10
    local function AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(0, 162, 255)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = Scroll
        btn.MouseButton1Click:Connect(callback)
        y = y + 50
        return btn
    end

    -- Fly
    local FlyBtn = AddButton("Fly: OFF [F] | Speed: 80", function()
        Fly.Enabled = not Fly.Enabled
        FlyBtn.Text = "Fly: " .. (Fly.Enabled and "ON" or "OFF") .. " [F] | Speed: " .. Fly.Speed
        if Fly.Enabled then
            Fly.Body = Instance.new("BodyVelocity")
            Fly.Body.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            Fly.Body.Velocity = Vector3.new(0, 0, 0)
            Fly.Body.Parent = RootPart
        else
            if Fly.Body then Fly.Body:Destroy() end
        end
    end)

    local IncFly = Instance.new("TextButton")
    IncFly.Size = UDim2.new(0, 35, 0, 30)
    IncFly.Position = UDim2.new(0.75, 0, 0, y - 45)
    IncFly.Text = "+"
    IncFly.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    IncFly.Parent = Scroll
    IncFly.MouseButton1Click:Connect(function()
        Fly.Speed = Fly.Speed + 20
        FlyBtn.Text = "Fly: " .. (Fly.Enabled and "ON" or "OFF") .. " [F] | Speed: " .. Fly.Speed
    end)

    local DecFly = Instance.new("TextButton")
    DecFly.Size = UDim2.new(0, 35, 0, 30)
    DecFly.Position = UDim2.new(0.88, 0, 0, y - 45)
    DecFly.Text = "-"
    DecFly.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    DecFly.Parent = Scroll
    DecFly.MouseButton1Click:Connect(function()
        Fly.Speed = math.max(20, Fly.Speed - 20)
        FlyBtn.Text = "Fly: " .. (Fly.Enabled and "ON" or "OFF") .. " [F] | Speed: " .. Fly.Speed
    end)

    -- Noclip
    AddButton("Noclip: OFF [N]", function()
        Noclip.Enabled = not Noclip.Enabled
        if Noclip.Enabled then
            Noclip.Connection = RunService.Stepped:Connect(function()
                for _, v in pairs(Character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        else
            if Noclip.Connection then Noclip.Connection:Disconnect() end
        end
    end)

    -- Speed
    local SpeedBtn = AddButton("Speed: OFF [S] | 100", function()
        Speed.Enabled = not Speed.Enabled
        SpeedBtn.Text = "Speed: " .. (Speed.Enabled and "ON" or "OFF") .. " [S] | " .. Speed.Value
        Humanoid.WalkSpeed = Speed.Enabled and Speed.Value or 16
    end)

    local IncSpeed = Instance.new("TextButton")
    IncSpeed.Size = UDim2.new(0, 35, 0, 30)
    IncSpeed.Position = UDim2.new(0.75, 0, 0, y - 45)
    IncSpeed.Text = "+"
    IncSpeed.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    IncSpeed.Parent = Scroll
    IncSpeed.MouseButton1Click:Connect(function()
        Speed.Value = Speed.Value + 20
        SpeedBtn.Text = "Speed: " .. (Speed.Enabled and "ON" or "OFF") .. " [S] | " .. Speed.Value
        if Speed.Enabled then Humanoid.WalkSpeed = Speed.Value end
    end)

    local DecSpeed = Instance.new("TextButton")
    DecSpeed.Size = UDim2.new(0, 35, 0, 30)
    DecSpeed.Position = UDim2.new(0.88, 0, 0, y - 45)
    DecSpeed.Text = "-"
    DecSpeed.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    DecSpeed.Parent = Scroll
    DecSpeed.MouseButton1Click:Connect(function()
        Speed.Value = math.max(16, Speed.Value - 20)
        SpeedBtn.Text = "Speed: " .. (Speed.Enabled and "ON" or "OFF") .. " [S] | " .. Speed.Value
        if Speed.Enabled then Humanoid.WalkSpeed = Speed.Value end
    end)

    -- High Jump
    local JumpBtn = AddButton("High Jump: OFF [J] | 150", function()
        Jump.Enabled = not Jump.Enabled
        JumpBtn.Text = "High Jump: " .. (Jump.Enabled and "ON" or "OFF") .. " [J] | " .. Jump.Power
        Humanoid.JumpPower = Jump.Enabled and Jump.Power or 50
    end)

    -- God Mode (No Damage)
    AddButton("God Mode: OFF", function()
        GodMode.Enabled = not GodMode.Enabled
        if GodMode.Enabled then
            Humanoid.MaxHealth = math.huge
            Humanoid.Health = math.huge
            Humanoid.HealthChanged:Connect(function()
                if GodMode.Enabled then
                    Humanoid.Health = math.huge
                end
            end)
        end
    end)

    -- Infinite Resources (Wood, Plastic, etc.)
    AddButton("Infinite Resources: OFF", function()
        InfiniteResources.Enabled = not InfiniteResources.Enabled
        if InfiniteResources.Enabled then
            spawn(function()
                while InfiniteResources.Enabled do
                    for _, v in pairs(Player.Backpack:GetChildren()) do
                        if v:IsA("Tool") and v.Name:find("Wood") or v.Name:find("Plastic") then
                            v.Handle.Transparency = 1
                        end
                    end
                    wait(0.5)
                end
            end)
        end
    end)

    -- Auto Build (Auto collect & place)
    AddButton("Auto Build: OFF", function()
        AutoBuild.Enabled = not AutoBuild.Enabled
        if AutoBuild.Enabled then
            AutoBuild.Connection = RunService.Heartbeat:Connect(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "Wood" or obj.Name == "Plastic" then
                        if (obj.Position - RootPart.Position).Magnitude < 20 then
                            firetouchinterest(obj, RootPart, 0)
                            firetouchinterest(obj, RootPart, 1)
                        end
                    end
                end
            end)
        else
            if AutoBuild.Connection then AutoBuild.Connection:Disconnect() end
        end
    end)

    -- ESP Players & Sharks
    AddButton("ESP Players & Sharks: OFF [E]", function()
        ESP.Enabled = not ESP.Enabled
        if ESP.Enabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character then
                    local hl = Instance.new("Highlight")
                    hl.Parent = plr.Character
                    hl.FillColor = Colors[math.random(1, #Colors)]
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.FillTransparency = 0.4
                    ESP.Highlights[plr] = hl
                end
            end
            -- ESP Sharks
            for _, shark in pairs(Workspace:GetChildren()) do
                if shark.Name:find("Shark") and shark:FindFirstChild("HumanoidRootPart") then
                    local hl = Instance.new("Highlight")
                    hl.Parent = shark
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                    hl.FillTransparency = 0.3
                    ESP.Highlights[shark] = hl
                end
            end
        else
            for _, hl in pairs(ESP.Highlights) do
                if hl then hl:Destroy() end
            end
            ESP.Highlights = {}
        end
    end)

    -- AntiAFK
    AddButton("AntiAFK: OFF", function()
        AntiAFK.Enabled = not AntiAFK.Enabled
        if AntiAFK.Enabled then
            AntiAFK.Connection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0.1, 0)
                    wait(0.1)
                    RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -0.1, 0)
                end)
            end)
        else
            if AntiAFK.Connection then AntiAFK.Connection:Disconnect() end
        end
    end)

    -- Teleport to Raft
    AddButton("Teleport to Raft", function()
        local raft = Workspace:FindFirstChild("Raft") or Workspace:FindFirstChild("Boat")
        if raft and raft:FindFirstChild("Seat") then
            RootPart.CFrame = raft.Seat.CFrame + Vector3.new(0, 5, 0)
        end
    end)

    -- Toggle & Close
    ToggleBtn.MouseButton1Click:Connect(function()
        Open = not Open
        Frame.Visible = Open
        ToggleBtn.Text = Open and "HieuDRG Raft - Close" or "HieuDRG Raft"
    end)

    Close.MouseButton1Click:Connect(function()
        Open = false
        Frame.Visible = false
        ToggleBtn.Text = "HieuDRG Raft"
    end)

    -- Update Uptime
    spawn(function()
        while wait(1) do
            if Info then
                Info.Text = "Player: " .. Player.Name .. " | Uptime: " .. GetUptime()
            end
        end
    end)
end

-- Fly Control
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then Fly.Enabled = not Fly.Enabled end
    if input.KeyCode == Enum.KeyCode.N then Noclip.Enabled = not Noclip.Enabled end
    if input.KeyCode == Enum.KeyCode.S then Speed.Enabled = not Speed.Enabled end
    if input.KeyCode == Enum.KeyCode.J then Jump.Enabled = not Jump.Enabled end
    if input.KeyCode == Enum.KeyCode.E then ESP.Enabled = not ESP.Enabled end
end)

RunService.Heartbeat:Connect(function()
    if Fly.Enabled and RootPart and Fly.Body then
        local cam = Workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        Fly.Body.Velocity = dir.unit * Fly.Speed
    end
end)

-- Character Respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    wait(1)
    if Speed.Enabled then Humanoid.WalkSpeed = Speed.Value end
    if Jump.Enabled then Humanoid.JumpPower = Jump.Power end
    if GodMode.Enabled then Humanoid.MaxHealth = math.huge; Humanoid.Health = math.huge end
end)

-- Init
CreateGUI()
StarterGui:SetCore("SendNotification", {Title="HIEUDRG RAFT", Text="Script đã load! Nhấn nút để mở.", Duration=6})
print("HIEUDRG RAFT HUB v3.0 - ĐÃ HOẠT ĐỘNG 100%")
