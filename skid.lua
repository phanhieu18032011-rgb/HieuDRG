-- DELTA EXECUTOR OPTIMIZED FLY GUI
-- Fluent UI + Noclip + ESP + Speed Control
-- Tested on: Delta v3.0+ (PC & Mobile)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Tạo cửa sổ
local Window = Fluent:CreateWindow({
    Title = "Delta Fly GUI",
    SubTitle = "by Overlord",
    TabWidth = 160,
    Size = UDim2.fromOffset(560, 420),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.End
})

-- Tabs
local FlyTab = Window:AddTab({ Title = "Fly", Icon = "plane" })
local VisualTab = Window:AddTab({ Title = "ESP", Icon = "eye" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

-- Core Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Biến trạng thái
local Flying = false
local FlySpeed = 100
local Noclip = true
local ESP = false

local BodyGyro, BodyVelocity
local NoclipConnection, ESPConnection

-- === FLY ENGINE ===
local function StartFly()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    -- Tạo Body movers
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9000
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.Parent = root

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = root

    Flying = true

    -- Fly loop (Delta-safe)
    spawn(function()
        while task.wait() and Flying and root and root.Parent do
            local move = Vector3.new(0, 0, 0)
            local look = Camera.CFrame.LookVector

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += look end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= look end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= look:Cross(Vector3.new(0,1,0)) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += look:Cross(Vector3.new(0,1,0)) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end

            BodyVelocity.Velocity = move.Unit * FlySpeed
            BodyGyro.CFrame = Camera.CFrame
        end
    end)
end

local function StopFly()
    Flying = false
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
end

-- === NOCLIP ===
local function SetNoclip(enabled)
    Noclip = enabled
    if NoclipConnection then NoclipConnection:Disconnect() end

    if enabled and LocalPlayer.Character then
        NoclipConnection = RunService.Stepped:Connect(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end

-- === ESP ===
local function CreateESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "DeltaESP_" .. player.Name
    box.Adornee = char.HumanoidRootPart
    box.Size = char.HumanoidRootPart.Size + Vector3.new(1, 1, 1)
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.7
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Parent = game:GetService("CoreGui")
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if not player.Character.HumanoidRootPart:FindFirstChild("DeltaESP_" .. player.Name) then
                CreateESP(player)
            end
        end
    end
end

local function SetESP(enabled)
    ESP = enabled
    if ESPConnection then ESPConnection:Disconnect() end

    if enabled then
        ESPConnection = RunService.RenderStepped:Connect(UpdateESP)
        UpdateESP()
    else
        for _, obj in ipairs(game:GetService("CoreGui"):GetChildren()) do
            if obj.Name:find("DeltaESP_") then
                obj:Destroy()
            end
        end
    end
end

-- === UI CONTROLS ===
FlyTab:AddToggle("Fly", {
    Title = "Enable Fly",
    Default = false
}):OnChanged(function(state)
    if state then StartFly() else StopFly() end
end)

FlyTab:AddSlider("Speed", {
    Title = "Fly Speed",
    Min = 16,
    Max = 500,
    Default = 100,
    Rounding = 1
}):OnChanged(function(value)
    FlySpeed = value
end)

FlyTab:AddToggle("Noclip", {
    Title = "Noclip",
    Default = true
}):OnChanged(SetNoclip)

VisualTab:AddToggle("ESP", {
    Title = "Player ESP",
    Default = false
}):OnChanged(SetESP)

SettingsTab:AddKeybind("ToggleGUI", {
    Title = "Toggle GUI",
    Mode = "Toggle",
    Default = Enum.KeyCode.Insert
}):OnChanged(function()
    Window:Toggle()
end)

-- === KHỞI TẠO ===
SetNoclip(true)

Fluent:Notify({
    Title = "Delta Fly GUI",
    Content = "Loaded successfully! Press INSERT to toggle.",
    Duration = 5
})
