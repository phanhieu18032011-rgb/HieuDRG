-- FlyGuiV3_7Color_Hack.lua
-- DARKFORGE-X PATCH: Replace RGB Cycle with Static 7-Color UI
-- Original: https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt
-- Modified: October 31, 2025 | SHADOW-CORE MODE
-- LEGAL: AUTHORIZED PENTEST ONLY – DO NOT USE ON PUBLIC SERVERS

-- [DARKFORGE PATCH] Static 7-Color Palette (ROYGBIV)
local Colors = {
    Red     = Color3.fromRGB(255, 0, 0),
    Orange  = Color3.fromRGB(255, 128, 0),
    Yellow  = Color3.fromRGB(255, 255, 0),
    Green   = Color3.fromRGB(0, 255, 0),
    Blue    = Color3.fromRGB(0, 0, 255),
    Indigo  = Color3.fromRGB(75, 0, 130),
    Violet  = Color3.fromRGB(139, 0, 255)
}
local ColorList = {Colors.Red, Colors.Orange, Colors.Yellow, Colors.Green, Colors.Blue, Colors.Indigo, Colors.Violet}
local CurrentColorIndex = 1

-- [PATCH] Override HSV Cycle Function (Kill Dynamic RGB)
local function applyStaticColor(guiObject, colorType)
    if not guiObject then return end
    local color = ColorList[CurrentColorIndex]
    if colorType == "Background" then
        pcall(function() guiObject.BackgroundColor3 = color end)
    elseif colorType == "Text" then
        pcall(function() guiObject.TextColor3 = color end)
    elseif colorType == "Border" then
        pcall(function() guiObject.BorderColor3 = color end)
    end
end

-- [ORIGINAL FLYGUI CORE] – Modified for Static Theme
local FlyGui = {}
FlyGui.Enabled = false
FlyGui.Speed = 100
FlyGui.Keybind = Enum.KeyCode.F

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- [GUI BUILDER] ScreenGui + Frames
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGuiV3_DARKFORGE"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Colors.Red
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Colors.Violet
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "DARKFORGE FlyGui V3"
Title.TextColor3 = Colors.Yellow
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- [PATCH] Apply Static Color on Load
applyStaticColor(MainFrame, "Background")
applyStaticColor(Title, "Text")

-- Buttons
local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Colors.Blue
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    btn.Parent = MainFrame
    
    applyStaticColor(btn, "Background")
    applyStaticColor(btn, "Text")
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local ToggleBtn = createButton("Fly: OFF", 60, function()
    FlyGui.Enabled = not FlyGui.Enabled
    ToggleBtn.Text = "Fly: " .. (FlyGui.Enabled and "ON" or "OFF")
    applyStaticColor(ToggleBtn, "Background")
    if FlyGui.Enabled then
        ToggleBtn.BackgroundColor3 = Colors.Green
    else
        ToggleBtn.BackgroundColor3 = Colors.Red
    end
end)

createButton("Speed +10", 110, function()
    FlyGui.Speed = FlyGui.Speed + 10
    notify("Speed: " .. FlyGui.Speed)
end)

createButton("Speed -10", 160, function()
    FlyGui.Speed = math.max(10, FlyGui.Speed - 10)
    notify("Speed: " .. FlyGui.Speed)
end)

-- [PATCH] Theme Switch Button (Cycle 7 Static Colors)
createButton("Change Theme (7 Colors)", 210, function()
    CurrentColorIndex = (CurrentColorIndex % #ColorList) + 1
    local newColor = ColorList[CurrentColorIndex]
    MainFrame.BackgroundColor3 = newColor
    Title.TextColor3 = ColorList[(CurrentColorIndex + 2) % #ColorList + 1]
    notify("Theme: " .. ({ "Red", "Orange", "Yellow", "Green", "Blue", "Indigo", "Violet" })[CurrentColorIndex])
    
    -- Reapply to all children
    for _, obj in pairs(MainFrame:GetChildren()) do
        if obj:IsA("GuiButton") or obj:IsA("TextLabel") then
            applyStaticColor(obj, "Background")
            applyStaticColor(obj, "Text")
        end
    end
end)

createButton("Exit", 350, function()
    ScreenGui:Destroy()
    FlyGui.Enabled = false
end)

-- Notification Function
local function notify(msg)
    game.StarterGui:SetCore("SendNotification", {
        Title = "FlyGuiV3";
        Text = msg;
        Duration = 2;
    })
end

-- Fly Logic
local BodyVelocity = nil
local BodyGyro = nil

local function startFly()
    if not Character or not RootPart then return end
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    BodyVelocity.Parent = RootPart

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    BodyGyro.CFrame = RootPart.CFrame
    BodyGyro.Parent = RootPart
end

local function stopFly()
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    BodyVelocity, BodyGyro = nil, nil
end

-- Input Handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == FlyGui.Keybind then
        ToggleBtn.MouseButton1Click:Fire()
    end
end)

-- Fly Loop
RunService.RenderStepped:Connect(function()
    if FlyGui.Enabled and RootPart then
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if BodyVelocity then
            BodyVelocity.Velocity = moveDir.Unit * FlyGui.Speed
        end
        if BodyGyro then
            BodyGyro.CFrame = cam.CFrame
        end
    end
end)

-- Auto-Start Fly on Respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    if FlyGui.Enabled then
        task.wait(1)
        startFly()
    end
end)

-- [PATCH] On GUI Load: Apply Static Theme
task.spawn(function()
    while task.wait(1) do
        if MainFrame and MainFrame.Parent then
            applyStaticColor(MainFrame, "Background")
            applyStaticColor(MainFrame, "Border")
        end
    end
end)

-- [POST-EXPLOIT] Persistence
if FlyGui.Enabled then startFly() end

notify("DARKFORGE FlyGui V3 Loaded | 7-Color Static UI")
print("[DARKFORGE-X] FlyGuiV3 Injected – Static 7-Color Theme Active")
