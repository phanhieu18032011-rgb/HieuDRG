-- HIEUDRG HUB v13.0 - RAFT SURVIVAL HACK (Sống sót trên bè)
-- Game: https://www.roblox.com/games/14682928991/Classes-Spell-Update-Song-sot-tren-be
-- Features: Auto Teleport + Collect Chests, Kill Aura (Shark/Mobs), Infinite Health + Energy
-- UI: FILE Style - Universal 2025

-- === SERVICES ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- === VARIABLES ===
local HubGui, MainFrame, ToggleButton, IsMenuOpen = nil, nil, nil, false
local StartTime = tick()

-- === FEATURE STATES ===
local AutoTPCollect = { on = false, conn = nil }
local KillAura = { on = false, conn = nil, range = 25 }
local InfiniteHealth = { on = false }
local InfiniteEnergy = { on = false }

-- === UPTIME ===
local function GetUptime()
    local t = tick() - StartTime
    local h, m, s = math.floor(t/3600), math.floor((t%3600)/60), math.floor(t%60)
    return string.format("%02d:%02d:%02d", h, m, s)
end

-- === AUTO TELEPORT + COLLECT CHESTS/RƯƠNG/HÒM ===
local function ToggleAutoTPCollect()
    AutoTPCollect.on = not AutoTPCollect.on
    if AutoTPCollect.on then
        AutoTPCollect.conn = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                local name = obj.Name:lower()
                if name:find("chest") or name:find("rương") or name:find("box") or name:find("treasure") or name:find("debris") then
                    if obj:IsA("BasePart") and obj.Parent and (obj.Position - RootPart.Position).Magnitude > 8 then
                        -- Teleport to chest
                        RootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 5, 0))
                        wait(0.6)
                    end
                    if (obj.Position - RootPart.Position).Magnitude < 12 then
                        -- Auto collect
                        firetouchinterest(obj, RootPart, 0)
                        firetouchinterest(obj, RootPart, 1)
                        wait(0.1)
                    end
                end
            end
        end)
    else
        if AutoTPCollect.conn then AutoTPCollect.conn:Disconnect() end
    end
end

-- === KILL AURA (Shark + Mobs) ===
local function ToggleKillAura()
    KillAura.on = not KillAura.on
    if KillAura.on then
        KillAura.conn = RunService.Heartbeat:Connect(function()
            for _, mob in pairs(Workspace:GetDescendants()) do
                if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob ~= Character then
                    local dist = (mob.HumanoidRootPart.Position - RootPart.Position).Magnitude
                    if dist <= KillAura.range then
                        mob.Humanoid:TakeDamage(15)  -- Damage per tick
                    end
                end
            end
        end)
    else
        if KillAura.conn then KillAura.conn:Disconnect() end
    end
end

-- === INFINITE HEALTH ===
local function ToggleInfiniteHealth()
    InfiniteHealth.on = not InfiniteHealth.on
    if InfiniteHealth.on then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.HealthChanged:Connect(function()
            if InfiniteHealth.on then
                Humanoid.Health = math.huge
            end
        end)
    end
end

-- === INFINITE ENERGY (Stamina/Hunger/Thirst) ===
local function ToggleInfiniteEnergy()
    InfiniteEnergy.on = not InfiniteEnergy.on
    if InfiniteEnergy.on then
        spawn(function()
            while InfiniteEnergy.on and wait(0.5) do
                pcall(function()
                    -- Reset hunger, thirst, stamina
                    local stats = LocalPlayer:FindFirstChild("PlayerStats") or LocalPlayer:FindFirstChild("Stats")
                    if stats then
                        if stats:FindFirstChild("Hunger") then stats.Hunger.Value = 100 end
                        if stats:FindFirstChild("Thirst") then stats.Thirst.Value = 100 end
                        if stats:FindFirstChild("Stamina") then stats.Stamina.Value = 100 end
                    end
                    Humanoid.WalkSpeed = 20  -- No fatigue
                end)
            end
        end)
    end
end

-- === CREATE UI (FILE STYLE) ===
local function CreateUI()
    HubGui = Instance.new("ScreenGui")
    HubGui.Name = "HieuDRGHub"
    HubGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    HubGui.ResetOnSpawn = false

    -- Toggle Button
    ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = HubGui
    ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    ToggleButton.Position = UDim2.new(0, 10, 0, 10)
    ToggleButton.Size = UDim2.new(0, 160, 0, 50)
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Text = "HieuDRG Hub"
    ToggleButton.TextColor3 = Color3.new(1,1,1)
    ToggleButton.TextSize = 16
    ToggleButton.ZIndex = 1000

    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Parent = HubGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    MainFrame.Position = UDim2.new(0.5, -210, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 420, 0, 400)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ZIndex = 999

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Parent = MainFrame
    Title.BackgroundColor3 = Color3.fromRGB(0,120,215)
    Title.Size = UDim2.new(1,0,0,50)
    Title.Text = "HIEUDRG HUB v13.0"
    Title.TextColor3 = Color3.new(1,1,1)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18

    -- Player + Avatar
    local PlayerInfo = Instance.new("TextLabel")
    PlayerInfo.Parent = MainFrame
    PlayerInfo.BackgroundTransparency = 1
    PlayerInfo.Position = UDim2.new(0,0,0,50)
    PlayerInfo.Size = UDim2.new(1,0,0,30)
    PlayerInfo.Text = "Player: " .. LocalPlayer.Name
    PlayerInfo.TextColor3 = Color3.new(1,1,1)
    PlayerInfo.Font = Enum.Font.Gotham
    PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left

    local Avatar = Instance.new("ImageLabel")
    Avatar.Parent = MainFrame
    Avatar.BackgroundTransparency = 1
    Avatar.Position = UDim2.new(0, 360, 0, 5)
    Avatar.Size = UDim2.new(0,40,0,40)
    Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)

    -- Uptime
    local Uptime = Instance.new("TextLabel")
    Uptime.Parent = MainFrame
    Uptime.BackgroundTransparency = 1
    Uptime.Position = UDim2.new(0.6,0,0,50)
    Uptime.Size = UDim2.new(0.4,0,0,30)
    Uptime.Text = "Uptime: 00:00:00"
    Uptime.TextColor3 = Color3.new(1,1,1)
    Uptime.Font = Enum.Font.Gotham
    Uptime.TextXAlignment = Enum.TextXAlignment.Right

    -- Close Button
    local Close = Instance.new("TextButton")
    Close.Parent = Title
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(1,-40,0,10)
    Close.Size = UDim2.new(0,30,0,30)
    Close.Text = "X"
    Close.TextColor3 = Color3.fromRGB(255,0,0)
    Close.Font = Enum.Font.GothamBold
    Close.ZIndex = 1001

    -- Scroll
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Parent = MainFrame
    Scroll.BackgroundTransparency = 1
    Scroll.Position = UDim2.new(0,10,0,80)
    Scroll.Size = UDim2.new(1,-20,1,-100)
    Scroll.ScrollBarThickness = 6
    Scroll.CanvasSize = UDim2.new(0,0,0,400)

    local y = 10
    local function Btn(text, callback)
        local b = Instance.new("TextButton")
        b.Parent = Scroll
        b.Size = UDim2.new(1,-10,0,35)
        b.Position = UDim2.new(0,5,0,y)
        b.BackgroundColor3 = Color3.fromRGB(45,45,45)
        b.BorderColor3 = Color3.fromRGB(0,162,255)
        b.Text = text
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = Enum.Font.Gotham
        b.ZIndex = 999
        b.MouseButton1Click:Connect(callback)
        y = y + 45
        return b
    end

    -- === TOGGLE BUTTONS ===
    local tpBtn = Btn("Auto TP + Collect Chests: OFF", function()
        ToggleAutoTPCollect()
        tpBtn.Text = "Auto TP + Collect Chests: " .. (AutoTPCollect.on and "ON" or "OFF")
    end)

    local auraBtn = Btn("Kill Aura (Shark/Mobs): OFF", function()
        ToggleKillAura()
        auraBtn.Text = "Kill Aura (Shark/Mobs): " .. (KillAura.on and "ON" or "OFF")
    end)

    local healthBtn = Btn("Infinite Health: OFF", function()
        ToggleInfiniteHealth()
        healthBtn.Text = "Infinite Health: " .. (InfiniteHealth.on and "ON" or "OFF")
    end)

    local energyBtn = Btn("Infinite Energy: OFF", function()
        ToggleInfiniteEnergy()
        energyBtn.Text = "Infinite Energy: " .. (InfiniteEnergy.on and "ON" or "OFF")
    end)

    -- === MENU TOGGLE ===
    ToggleButton.MouseButton1Click:Connect(function()
        IsMenuOpen = not IsMenuOpen
        MainFrame.Visible = IsMenuOpen
        ToggleButton.Text = IsMenuOpen and "HieuDRG - Close" or "HieuDRG Hub"
    end)

    Close.MouseButton1Click:Connect(function()
        IsMenuOpen = false
        MainFrame.Visible = false
        ToggleButton.Text = "HieuDRG Hub"
    end)

    -- === UPTIME LOOP ===
    spawn(function()
        while wait(1) do
            Uptime.Text = "Uptime: " .. GetUptime()
        end
    end)

    -- === RESPAWN ===
    LocalPlayer.CharacterAdded:Connect(function(char)
        Character = char
        Humanoid = char:WaitForChild("Humanoid")
        RootPart = char:WaitForChild("HumanoidRootPart")
        wait(1)
        if InfiniteHealth.on then ToggleInfiniteHealth() end
        if InfiniteEnergy.on then ToggleInfiniteEnergy() end
    end)
end

-- === INIT ===
CreateUI()

StarterGui:SetCore("SendNotification", {
    Title = "HIEUDRG HUB v13.0",
    Text = "RAFT SURVIVAL HACK READY! Auto Collect + Kill Shark!",
    Duration = 6
})

print("HIEUDRG HUB v13.0 - RAFT SURVIVAL LOADED 100%")
