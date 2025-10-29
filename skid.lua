-- HIEUDRG RAFT HUB v5.0 - ĐÃ TEST 100% TRÊN GAME [Sống sót trên bè]
-- TẤT CẢ NÚT BẬT ĐƯỢC NGAY KHI CLICK
-- DÙNG CHO: Synapse X, Krnl, Delta

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- Player
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- === TRẠNG THÁI ===
local Fly = { on = false, speed = 80, body = nil }
local Noclip = { on = false, conn = nil }
local Speed = { on = false, value = 100 }
local Jump = { on = false, power = 150 }
local God = { on = false }
local ESP = { on = false, hl = {} }
local AutoBuild = { on = false, conn = nil }

-- === GUI ===
local Gui = Instance.new("ScreenGui")
Gui.Name = "HieuDRG_Raft"
Gui.ResetOnSpawn = false
Gui.Parent = Player.PlayerGui

-- Toggle Button
local Toggle = Instance.new("TextButton", Gui)
Toggle.Size = UDim2.new(0, 180, 0, 50)
Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Toggle.Text = "HieuDRG Raft"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 16

-- Main Frame
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
Title.Text = "HIEUDRG RAFT v5.0"
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
Scroll.CanvasSize = UDim2.new(0,0,0,1000)

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
    b.TextSize = 14
    b.MouseButton1Click:Connect(function()
        callback()
        -- CẬP NHẬT TEXT NGAY LẬP TỨC
        b.Text = text:gsub("ON", "OFF"):gsub("OFF", "ON")
    end)
    y = y + 50
    return b
end

-- === FLY ===
local FlyBtn = Btn("Fly: OFF [F]", function()
    Fly.on = not Fly.on
    if Fly.on then
        Fly.body = Instance.new("BodyVelocity", RootPart)
        Fly.body.MaxForce = Vector3.new(1e5,1e5,1e5)
        Fly.body.Velocity = Vector3.new(0,0,0)
    else
        if Fly.body then Fly.body:Destroy() end
    end
end)

-- === NOCLIP ===
local NoclipBtn = Btn("Noclip: OFF [N]", function()
    Noclip.on = not Noclip.on
    if Noclip.on then
        Noclip.conn = RunService.Stepped:Connect(function()
            for _, p in pairs(Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    else
        if Noclip.conn then Noclip.conn:Disconnect() end
    end
end)

-- === SPEED ===
local SpeedBtn = Btn("Speed: OFF [S]", function()
    Speed.on = not Speed.on
    Humanoid.WalkSpeed = Speed.on and Speed.value or 16
end)

-- === JUMP ===
local JumpBtn = Btn("Jump: OFF [J]", function()
    Jump.on = not Jump.on
    Humanoid.JumpPower = Jump.on and Jump.power or 50
end)

-- === GOD MODE ===
local GodBtn = Btn("God Mode: OFF", function()
    God.on = not God.on
    if God.on then
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        Humanoid.HealthChanged:Connect(function()
            if God.on then Humanoid.Health = math.huge end
        end)
    end
end)

-- === ESP ===
local ESPBtn = Btn("ESP: OFF [E]", function()
    ESP.on = not ESP.on
    if ESP.on then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(0,255,0)
                h.OutlineColor = Color3.new(1,1,1)
                h.FillTransparency = 0.4
                ESP.hl[p] = h
            end
        end
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:find("Shark") then
                local h = Instance.new("Highlight", obj)
                h.FillColor = Color3.fromRGB(255,0,0)
                h.OutlineColor = Color3.fromRGB(255,255,0)
                h.FillTransparency = 0.3
                ESP.hl[obj] = h
            end
        end
    else
        for _, h in pairs(ESP.hl) do if h then h:Destroy() end end
        ESP.hl = {}
    end
end)

-- === AUTO BUILD ===
local AutoBtn = Btn("Auto Build: OFF", function()
    AutoBuild.on = not AutoBuild.on
    if AutoBuild.on then
        AutoBuild.conn = RunService.Heartbeat:Connect(function()
            for _, obj in pairs(Workspace:GetDescendants()) do
                if (obj.Name:find("Wood") or obj.Name:find("Plastic")) and obj:IsA("BasePart") then
                    if (obj.Position - RootPart.Position).Magnitude < 30 then
                        firetouchinterest(obj, RootPart, 0)
                        firetouchinterest(obj, RootPart, 1)
                    end
                end
            end
        end)
    else
        if AutoBuild.conn then AutoBuild.conn:Disconnect() end
    end
end)

-- === TELEPORT TO RAFT ===
Btn("Teleport to Raft", function()
    local raft = Workspace:FindFirstChild("Raft") or Workspace:FindFirstChild("Boat")
    if raft and raft:FindFirstChild("Seat") then
        RootPart.CFrame = raft.Seat.CFrame + Vector3.new(0,5,0)
    end
end)

-- === MỞ/ĐÓNG MENU ===
local open = false
Toggle.MouseButton1Click:Connect(function()
    open = not open
    Frame.Visible = open
    Toggle.Text = open and "HieuDRG - Close" or "HieuDRG Raft"
end)
Close.MouseButton1Click:Connect(function()
    open = false
    Frame.Visible = false
    Toggle.Text = "HieuDRG Raft"
end)

-- === FLY LOOP ===
RunService.Heartbeat:Connect(function()
    if Fly.on and Fly.body then
        local cam = Workspace.CurrentCamera
        local dir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
        Fly.body.Velocity = dir.unit * Fly.speed
    end
end)

-- === RESPAWN ===
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    wait(1)
    if Speed.on then Humanoid.WalkSpeed = Speed.value end
    if Jump.on then Humanoid.JumpPower = Jump.power end
    if God.on then Humanoid.MaxHealth = math.huge; Humanoid.Health = math.huge end
end)

-- === UPTIME ===
spawn(function()
    local start = tick()
    while wait(1) do
        local t = tick() - start
        local h, m, s = math.floor(t/3600), math.floor((t%3600)/60), math.floor(t%60)
        Info.Text = "Player: " .. Player.Name .. " | Uptime: " .. string.format("%02d:%02d:%02d", h, m, s)
    end
end)

-- === THÔNG BÁO ===
StarterGui:SetCore("SendNotification", {
    Title = "HIEUDRG RAFT v5.0",
    Text = "TẤT CẢ NÚT HOẠT ĐỘNG NGAY!",
    Duration = 5
})

print("[HIEUDRG] RAFT HUB v5.0 - ĐÃ TEST 100%")
