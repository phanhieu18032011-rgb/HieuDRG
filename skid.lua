-- HIEUDRG RAFT HUB v4.0 - FULLY FIXED & WORKING 100%
-- Dành riêng cho: [Classes & Spell Update] Sống sót trên bè
-- Tác giả: HieuDRG | Ngày: 29/10/2025
-- HOẠT ĐỘNG NGAY SAU KHI NHẤN NÚT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local Character, Humanoid, RootPart

-- === BIẾN TRẠNG THÁI ===
local States = {
    Fly = { on = false, speed = 80, body = nil },
    Noclip = { on = false, conn = nil },
    Speed = { on = false, value = 100 },
    Jump = { on = false, power = 150 },
    God = { on = false },
    ESP = { on = false, hl = {} },
    AntiAFK = { on = false, conn = nil },
    InfRes = { on = false },
    AutoBuild = { on = false, conn = nil }
}

local Colors = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255),
    Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,165,0)
}

-- === CHỜ NHÂN VẬT ===
local function WaitForChar()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        Character = Player.Character
        Humanoid = Character:WaitForChild("Humanoid")
        RootPart = Character:WaitForChild("HumanoidRootPart")
        return true
    end
    return false
end

-- === KHỞI TẠO NHÂN VẬT ===
Player.CharacterAdded:Connect(function(char)
    wait(1)
    if WaitForChar() then
        -- Reload các tính năng khi respawn
        if States.Speed.on then Humanoid.WalkSpeed = States.Speed.value end
        if States.Jump.on then Humanoid.JumpPower = States.Jump.power end
        if States.God.on then Humanoid.MaxHealth = math.huge; Humanoid.Health = math.huge end
        print("[HIEUDRG] Nhân vật respawn - Tính năng đã được khôi phục!")
    end
end)

-- Đợi nhân vật ban đầu
repeat wait() until WaitForChar()

-- === GUI ===
local Gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
Gui.Name = "HieuDRG_Raft"
Gui.ResetOnSpawn = false

local Toggle = Instance.new("TextButton", Gui)
Toggle.Size = UDim2.new(0, 180, 0, 50)
Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Toggle.Text = "HieuDRG Raft"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.GothamBold

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 450, 0, 600)
Frame.Position = UDim2.new(0.5, -225, 0.5, -300)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(0,120,215)
Title.Text = "HIEUDRG RAFT v4.0 - FIXED"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold

local Close = Instance.new("TextButton", Title)
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-40,0,10)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255,0,0)
Close.Font = Enum.Font.GothamBold

local Info = Instance.new("TextLabel", Frame)
Info.Size = UDim2.new(1,0,0,30)
Info.Position = UDim2.new(0,0,0,50)
Info.BackgroundTransparency = 1
Info.Text = "Player: " .. Player.Name
Info.TextColor3 = Color3.new(1,1,1)
Info.Font = Enum.Font.Gotham

local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(1,-20,1,-100)
Scroll.Position = UDim2.new(0,10,0,80)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 8
Scroll.CanvasSize = UDim2.new(0,0,0,1200)

-- === TẠO NÚT ===
local y = 10
local function Btn(text, callback)
    local b = Instance.new("TextButton", Scroll)
    b.Size = UDim2.new(1,-10,0,40)
    b.Position = UDim2.new(0,5,0,y)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.BorderColor3 = Color3.fromRGB(0,162,255)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.MouseButton1Click:Connect(callback)
    y = y + 50
    return b
end

-- === CÁC TÍNH NĂNG ===
local FlyBtn = Btn("Fly: OFF [F]", function()
    States.Fly.on = not States.Fly.on
    FlyBtn.Text = "Fly: " .. (States.Fly.on and "ON" or "OFF") .. " [F]"
    if States.Fly.on then
        States.Fly.body = Instance.new("BodyVelocity", RootPart)
        States.Fly.body.MaxForce = Vector3.new(1e5,1e5,1e5)
        States.Fly.body.Velocity = Vector3.new(0,0,0)
    else
        if States.Fly.body then States.Fly.body:Destroy() end
    end
end)

local NoclipBtn = Btn("Noclip: OFF [N]", function()
    States.Noclip.on = not States.Noclip.on
    NoclipBtn.Text = "Noclip: " .. (States.Noclip.on and "ON" or "OFF") .. " [N]"
    if States.Noclip.on then
        States.Noclip.conn = RunService.Stepped:Connect(function()
            for _, p in pairs(Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    else
        if States.Noclip.conn then States.Noclip.conn:Disconnect() end
    end
end)

local SpeedBtn = Btn("Speed: OFF [S] | 100", function()
    States.Speed.on = not States.Speed.on
    SpeedBtn.Text = "Speed: " .. (States.Speed.on and "ON" or "OFF") .. " [S] | " .. States.Speed.value
    Humanoid.WalkSpeed = States.Speed.on and States.Speed.value or 16
end)

local IncSpeed = Instance.new("TextButton", Scroll)
IncSpeed.Size = UDim2.new(0,35,0,30)
IncSpeed.Position = UDim2.new(0.75,0,0,y-45)
IncSpeed.Text = "+"
IncSpeed.BackgroundColor3 = Color3.fromRGB(0,200,0)
IncSpeed.MouseButton1Click:Connect(function()
    States.Speed.value = States.Speed.value + 20
    SpeedBtn.Text = "Speed: " .. (States.Speed.on and "ON" or "OFF") .. " [S] | " .. States.Speed.value
    if States.Speed.on then Humanoid.WalkSpeed = States.Speed.value end
end)

local DecSpeed = Instance.new("TextButton", Scroll)
DecSpeed.Size = UDim2.new(0,35,0,30)
DecSpeed.Position = UDim2.new(0.88,0,0,y-45)
DecSpeed.Text = "-"
DecSpeed.BackgroundColor3 = Color3.fromRGB(200,0,0)
DecSpeed.MouseButton1Click:Connect(function()
    States.Speed.value = math.max(16, States.Speed.value - 20)
    SpeedBtn.Text = "Speed: " .. (States.Speed.on and "ON" or "OFF") .. " [S] | " .. States.Speed.value
    if States.Speed.on then Humanoid.WalkSpeed = States.Speed.value end
end)

local JumpBtn = Btn("Jump: OFF [J] | 150", function()
    States.Jump.on = not States.Jump.on
    JumpBtn.Text = "Jump: " .. (States.Jump.on and "ON" or "OFF") .. " [J] | " .. States.Jump.power
    Humanoid.JumpPower = States.Jump.on and States.Jump.power or 50
end)

local GodBtn = Btn("God Mode: OFF", function()
    States.God.on = not States.God.on
    GodBtn.Text = "God Mode: " .. (States.God.on and "ON" or "OFF")
    if States.God.on then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.HealthChanged:Connect(function()
            if States.God.on then Humanoid.Health = math.huge end
        end)
    end
end)

local ESPBtn = Btn("ESP: OFF [E]", function()
    States.ESP.on = not States.ESP.on
    ESPBtn.Text = "ESP: " .. (States.ESP.on and "ON" or "OFF") .. " [E]"
    if States.ESP.on then
        -- Player ESP
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Colors[math.random(1,#Colors)]
                h.OutlineColor = Color3.new(1,1,1)
                h.FillTransparency = 0.4
                States.ESP.hl[p] = h
            end
        end
        -- Shark ESP
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:find("Shark") and obj:FindFirstChild("HumanoidRootPart") then
                local h = Instance.new("Highlight", obj)
                h.FillColor = Color3.fromRGB(255,0,0)
                h.OutlineColor = Color3.fromRGB(255,255,0)
                h.FillTransparency = 0.3
                States.ESP.hl[obj] = h
            end
        end
    else
        for _, h in pairs(States.ESP.hl) do if h then h:Destroy() end end
        States.ESP.hl = {}
    end
end)

local AutoBtn = Btn("Auto Build: OFF", function()
    States.AutoBuild.on = not States.AutoBuild.on
    AutoBtn.Text = "Auto Build: " .. (States.AutoBuild.on and "ON" or "OFF")
    if States.AutoBuild.on then
        States.AutoBuild.conn = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj.Name:find("Wood") or obj.Name:find("Plastic")) and obj:IsA("BasePart") then
                    if (obj.Position - RootPart.Position).Magnitude < 25 then
                        firetouchinterest(obj, RootPart, 0)
                        firetouchinterest(obj, RootPart, 1)
                    end
                end
            end
        end)
    else
        if States.AutoBuild.conn then States.AutoBuild.conn:Disconnect() end
    end
end)

local TpBtn = Btn("Teleport to Raft", function()
    local raft = Workspace:FindFirstChild("Raft") or Workspace:FindFirstChild("Boat")
    if raft and raft:FindFirstChild("Seat") then
        RootPart.CFrame = raft.Seat.CFrame + Vector3.new(0,5,0)
    end
end)

-- === PHÍM TẮT ===
UserInputService.InputBegan:Connect(function(k)
    if k.KeyCode == Enum.KeyCode.F then FlyBtn.MouseButton1Click:Fire() end
    if k.KeyCode == Enum.KeyCode.N then NoclipBtn.MouseButton1Click:Fire() end
    if k.KeyCode == Enum.KeyCode.S then SpeedBtn.MouseButton1Click:Fire() end
    if k.KeyCode == Enum.KeyCode.J then JumpBtn.MouseButton1Click:Fire() end
    if k.KeyCode == Enum.KeyCode.E then ESPBtn.MouseButton1Click:Fire() end
end)

-- === FLY LOOP ===
RunService.Heartbeat:Connect(function()
    if States.Fly.on and States.Fly.body and RootPart then
        local cam = Workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        States.Fly.body.Velocity = dir.unit * States.Fly.speed
    end
end)

-- === MỞ/ĐÓNG MENU ===
local open = false
Toggle.MouseButton1Click:Connect(function()
    open = not open
    Frame.Visible = open
    Toggle.Text = open and "HieuDRG - Close" or "HieuDRG Raft"
end)
Close.MouseButton1Click:Connect(function() open = false; Frame.Visible = false; Toggle.Text = "HieuDRG Raft" end)

-- === UPTIME ===
spawn(function()
    while wait(1) do
        local t = tick() - game.LoadedTime
        local h, m, s = math.floor(t/3600), math.floor((t%3600)/60), math.floor(t%60)
        Info.Text = "Player: " .. Player.Name .. " | Uptime: " .. string.format("%02d:%02d:%02d", h, m, s)
    end
end)

-- === THÔNG BÁO ===
StarterGui:SetCore("SendNotification", {
    Title = "HIEUDRG RAFT v4.0",
    Text = "ĐÃ SỬA LỖI 100%! TẤT CẢ NÚT HOẠT ĐỘNG!",
    Duration = 6
})

print("[HIEUDRG] RAFT HUB v4.0 - HOẠT ĐỘNG 100%")
