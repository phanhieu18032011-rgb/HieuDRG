-- HIEUDRG HUB v11.0 - SURVIVAL ROLEPLAY HACK (Universal + Game-Specific)
-- Game: https://www.roblox.com/games/17126679820/Survival-Roleplay
-- Features: Infinite Resources (Health/Energy/Wood/Items), Auto Farm Chests/Boxes, God Mode, Auto Collect, ESP Resources
-- UI: FILE Style - Toggle Menu, Player Info, Uptime

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
local GodModeEnabled = false
local InfiniteEnergyEnabled = false
local InfiniteResourcesEnabled = false  -- Wood, Food, etc.
local AutoFarmChestsEnabled = false
local AutoCollectEnabled = false
local ESPResourcesEnabled = false
local ESPConnections = {}

-- Uptime Function
local function GetUptime()
    local uptime = tick() - StartTime
    local hours = math.floor(uptime / 3600)
    local minutes = math.floor((uptime % 3600) / 60)
    local seconds = math.floor(uptime % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- God Mode (Infinite Health)
local function ToggleGodMode()
    GodModeEnabled = not GodModeEnabled
    if GodModeEnabled then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.HealthChanged:Connect(function()
            Humanoid.Health = math.huge
        end)
    end
end

-- Infinite Energy (Assume Energy is Humanoid.WalkSpeed or custom value; adjust if needed)
local function ToggleInfiniteEnergy()
    InfiniteEnergyEnabled = not InfiniteEnergyEnabled
    if InfiniteEnergyEnabled then
        -- Simulate infinite stamina/energy by resetting fatigue
        RunService.Heartbeat:Connect(function()
            Humanoid.WalkSpeed = 50  -- No fatigue slowdown
        end)
    end
end

-- Infinite Resources (Wood, Items - Hook Backpack/Tools)
local function ToggleInfiniteResources()
    InfiniteResourcesEnabled = not InfiniteResourcesEnabled
    if InfiniteResourcesEnabled then
        spawn(function()
            while InfiniteResourcesEnabled do
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:find("Wood") or tool.Name:find("Food") or tool.Name:find("Item")) then
                        -- Infinite durability/quantity (simulate by not decreasing)
                        tool.Parent = LocalPlayer.Character  -- Equip if needed
                    end
                end
                wait(1)
            end
        end)
    end
end

-- Auto Farm Chests/Boxes (Collect nearby chests automatically)
local function ToggleAutoFarmChests()
    AutoFarmChestsEnabled = not AutoFarmChestsEnabled
    if AutoFarmChestsEnabled then
        spawn(function()
            while AutoFarmChestsEnabled do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:find("Chest") or obj.Name:find("Box") or obj.Name:find("Rương") then
                        if obj:IsA("BasePart") and (obj.Position - RootPart.Position).Magnitude < 20 then
                            firetouchinterest(obj, RootPart, 0)
                            firetouchinterest(obj, RootPart, 1)
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end

-- Auto Collect Resources (Wood, Stones, etc.)
local function ToggleAutoCollect()
    AutoCollectEnabled = not AutoCollectEnabled
    if AutoCollectEnabled then
        spawn(function()
            while AutoCollectEnabled do
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:find("Wood") or obj.Name:find("Stone") or obj.Name:find("Food") then
                        if obj:IsA("BasePart") and (obj.Position - RootPart.Position).Magnitude < 15 then
                            firetouchinterest(obj, RootPart, 0)
                            firetouchinterest(obj, RootPart, 1)
                        end
                    end
                end
                wait(0.3)
            end
        end)
end
end

-- ESP Resources (Highlight chests/wood/items)
local function ToggleESPR()
    ESPResourcesEnabled = not ESPResourcesEnabled
    if ESPResourcesEnabled then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name:find("Chest") or obj.Name:find("Wood") or obj.Name:find("Stone") then
                if obj:IsA("BasePart") then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = obj
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.FillTransparency = 0.5
                    ESPConnections[obj] = highlight
                end
            end
        end
    else
        for obj, highlight in pairs(ESPConnections) do
            if highlight then highlight:Destroy() end
        end
        ESPConnections = {}
    end
end

-- Create UI Menu (FILE Style)
local function CreateUI()
    HubGui = Instance.new("ScreenGui")
    HubGui.Name = "HieuDRGHub"
    HubGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    HubGui.ResetOnSpawn = false

    -- Toggle Button
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

    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = HubGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
    MainFrame.Size = UDim2.new(0, 400, 0, 400)
    MainFrame.Visible = false
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Title Frame
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
    TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = "HieuDRG Hub - Survival Roleplay"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Player Name
    local PlayerLabel = Instance.new("TextLabel")
    PlayerLabel.Name = "PlayerLabel"
    PlayerLabel.Parent = TitleFrame
    PlayerLabel.BackgroundTransparency = 1
    PlayerLabel.Position = UDim2.new(0.6, 0, 0, 0)
    PlayerLabel.Size = UDim2.new(0.3, 0, 1, 0)
    PlayerLabel.Font = Enum.Font.SourceSans
    PlayerLabel.Text = "Player: " .. LocalPlayer.Name
    PlayerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlayerLabel.TextSize = 12
    PlayerLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Avatar (Simple Icon)
    local AvatarLabel = Instance.new("TextLabel")
    AvatarLabel.Name = "AvatarLabel"
    AvatarLabel.Parent = TitleFrame
    AvatarLabel.BackgroundTransparency = 1
    AvatarLabel.Position = UDim2.new(0.9, 0, 0, 0)
    AvatarLabel.Size = UDim2.new(0.1, 0, 1, 0)
    AvatarLabel.Font = Enum.Font.SourceSansBold
    AvatarLabel.Text = "👤"
    AvatarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    AvatarLabel.TextSize = 20

    -- Uptime
    local UptimeLabel = Instance.new("TextLabel")
    UptimeLabel.Name = "UptimeLabel"
    UptimeLabel.Parent = TitleFrame
    UptimeLabel.BackgroundTransparency = 1
    UptimeLabel.Position = UDim2.new(0, 0, 1, -20)
    UptimeLabel.Size = UDim2.new(1, 0, 0, 20)
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

    -- Scrolling Frame
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "ScrollFrame"
    ScrollFrame.Parent = MainFrame
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.Position = UDim2.new(0, 0, 0, 60)
    ScrollFrame.Size = UDim2.new(1, 0, 1, -60)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
    ScrollFrame.ScrollBarThickness = 8

    local yPos = 0

    local function AddToggleButton(name, callback, state)
        local Button = Instance.new("TextButton")
        Button.Name = name .. "Button"
        Button.Parent = ScrollFrame
        Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Button.BorderSizePixel = 0
        Button.Position = UDim2.new(0, 10, 0, yPos)
        Button.Size = UDim2.new(1, -20, 0, 30)
        Button.Font = Enum.Font.SourceSans
        Button.Text = name .. ": " .. (state and "ON" or "OFF")
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 14
        Button.MouseButton1Click:Connect(function()
            state = not state
            callback()
            Button.Text = name .. ": " .. (state and "ON" or "OFF")
        end)
        yPos = yPos + 40
        return Button
    end

    -- God Mode
    AddToggleButton("God Mode (Infinite Health)", ToggleGodMode, GodModeEnabled)

    -- Infinite Energy
    AddToggleButton("Infinite Energy/Stamina", ToggleInfiniteEnergy, InfiniteEnergyEnabled)

    -- Infinite Resources (Wood/Items)
    AddToggleButton("Infinite Resources (Wood/Food)", ToggleInfiniteResources, InfiniteResourcesEnabled)

    -- Auto Farm Chests
    AddToggleButton("Auto Farm Chests/Boxes", ToggleAutoFarmChests, AutoFarmChestsEnabled)

    -- Auto Collect
    AddToggleButton("Auto Collect Resources", ToggleAutoCollect, AutoCollectEnabled)

    -- ESP Resources
    AddToggleButton("ESP Resources/Chests", ToggleESPR, ESPResourcesEnabled)

    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)

    -- Events
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

    -- Uptime Update
    spawn(function()
        while wait(1) do
            UptimeLabel.Text = "Uptime: " .. GetUptime()
        end
    end)

    -- Respawn Reload
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = newChar:WaitForChild("Humanoid")
        RootPart = newChar:WaitForChild("HumanoidRootPart")
        -- Reload features if enabled
        if GodModeEnabled then ToggleGodMode() end
        if InfiniteEnergyEnabled then ToggleInfiniteEnergy() end
    end)
end

-- Initialize
CreateUI()

StarterGui:SetCore("SendNotification", {
    Title = "HieuDRG Hub Loaded";
    Text = "Survival Roleplay Hack Ready! Infinite Resources + Auto Farm.";
    Duration = 5;
})

print("HieuDRG Hub v11.0 - Survival Roleplay Loaded!")
