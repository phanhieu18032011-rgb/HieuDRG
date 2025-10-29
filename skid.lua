-- HIEUDRG HUB v8.0 - UNIVERSAL + FLYGUIV3 - MENU MỞ NGAY 100%
-- HOẠT ĐỘNG TRÊN MỌI GAME ROBLOX (2025)
-- DÙNG VỚI: Synapse X, Krnl, Delta, Fluxus

-- === SERVICES ===
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

-- === PLAYER ===
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui", 10)
if not PlayerGui then error("PlayerGui not found!") end

-- Đợi Character
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- === TRẠNG THÁI ===
local Fly = { on = false, speed = 50, body = nil }
local Noclip = { on = false, conn = nil }
local Speed = { on = false, value = 50 }
local Jump = { on = false, power = 100 }
local AntiAFK = { on = false, conn = nil }
local ESP = { on = false, hl = {} }
local ESPMod = { on = false, hl = {} }

-- 7 MÀU ESP
local Colors = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255),
    Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,165,0)
}

-- === GUI ===
local Gui = Instance.new("ScreenGui")
Gui.Name = "HieuDRG_Hub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

-- NÚT TOGGLE (LUÔN Ở TRÊN)
local Toggle = Instance.new("TextButton", Gui)
Toggle.Size = UDim2.new(0, 160, 0, 50)
Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
Toggle.BorderSizePixel = 0
Toggle.Text = "HieuDRG Hub"
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 16
Toggle.ZIndex = 1000

-- MENU CHÍNH
local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 420, 0, 500)
Frame.Position = UDim2.new(0.5, -210, 0.5, -250)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Active = true
Frame.Draggable = true
Frame.ZIndex = 999

-- TITLE
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1,0,0,50)
Title.BackgroundColor3 = Color3.fromRGB(0,120,215)
Title.Text = "HIEUDRG HUB v8.0"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- PLAYER + AVATAR
local PlayerInfo = Instance.new("TextLabel", Frame)
PlayerInfo.Size = UDim2.new(1,0,0,30)
PlayerInfo.Position = UDim2.new(0,0,0,50)
PlayerInfo.BackgroundTransparency = 1
PlayerInfo.Text = "Player: " .. Player.Name
PlayerInfo.TextColor3 = Color3.new(1,1,1)
PlayerInfo.Font = Enum.Font.Gotham
PlayerInfo.TextXAlignment = Enum.TextXAlignment.Left

local Avatar = Instance.new("ImageLabel", Frame)
Avatar.Size = UDim2.new(0,40,0,40)
Avatar.Position = UDim2.new(0, 360, 0, 5)
Avatar.BackgroundTransparency = 1
Avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)

-- UPTIME
local Uptime = Instance.new("TextLabel", Frame)
Uptime.Size = UDim2.new(0.4,0,0,30)
Uptime.Position = UDim2.new(0.6,0,0,50)
Uptime.BackgroundTransparency = 1
Uptime.Text = "Uptime: 00:00:00"
Uptime.TextColor3 = Color3.new(1,1,1)
Uptime.Font = Enum.Font.Gotham
Uptime.TextXAlignment = Enum.TextXAlignment.Right

-- NÚT ĐÓNG
local Close = Instance.new("TextButton", Title)
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-40,0,10)
Close.BackgroundTransparency = 1
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255,0,0)
Close.Font = Enum.Font.GothamBold
Close.ZIndex = 1001

-- SCROLL
local Scroll = Instance.new("ScrollingFrame", Frame)
Scroll.Size = UDim2.new(1,-20,1,-100)
Scroll.Position = UDim2.new(0,10,0,80)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 6
Scroll.CanvasSize = UDim2.new(0,0,0,800)
Scroll.ZIndex = 998

local y = 10
local function Btn(text, callback)
    local b = Instance.new("TextButton", Scroll)
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

-- === FLY (FLYGUIV3) ===
local FlyBtn = Btn("Fly: OFF [F] | Speed: 50", function()
    Fly.on = not Fly.on
    FlyBtn.Text = "Fly: " .. (Fly.on and "ON" or "OFF") .. " [F] | Speed: " .. Fly.speed
    if Fly.on then
        Fly.body = Instance.new("BodyVelocity", RootPart)
        Fly.body.MaxForce = Vector3.new(1e5,1e5,1e5)
        Fly.body.Velocity = Vector3.new(0,0,0)
    else
        if Fly.body then Fly.body:Destroy() end
    end
end)

local IncFly = Instance.new("TextButton", Scroll)
IncFly.Size = UDim2.new(0,30,0,30); IncFly.Position = UDim2.new(0.75,0,0,y-40)
IncFly.Text = "+"; IncFly.BackgroundColor3 = Color3.fromRGB(0,200,0)
IncFly.MouseButton1Click:Connect(function()
    Fly.speed = Fly.speed + 10
    FlyBtn.Text = "Fly: " .. (Fly.on and "ON" or "OFF") .. " [F] | Speed: " .. Fly.speed
end)

local DecFly = Instance.new("TextButton", Scroll)
DecFly.Size = UDim2.new(0,30,0,30); DecFly.Position = UDim2.new(0.86,0,0,y-40)
DecFly.Text = "-"; DecFly.BackgroundColor3 = Color3.fromRGB(200,0,0)
DecFly.MouseButton1Click:Connect(function()
    Fly.speed = math.max(10, Fly.speed - 10)
    FlyBtn.Text = "Fly: " .. (Fly.on and "ON" or "OFF") .. " [F] | Speed: " .. Fly.speed
end)

-- === NOCLIP ===
Btn("Noclip: OFF [N]", function()
    Noclip.on = not Noclip.on
    if Noclip.on then
        Noclip.conn = RunService.Stepped:Connect(function()
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    else
        if Noclip.conn then Noclip.conn:Disconnect() end
    end
end)

-- === SPEED ===
local SpeedBtn = Btn("Speed: OFF [S] | 50", function()
    Speed.on = not Speed.on
    SpeedBtn.Text = "Speed: " .. (Speed.on and "ON" or "OFF") .. " [S] | " .. Speed.value
    Humanoid.WalkSpeed = Speed.on and Speed.value or 16
end)

local IncSpeed = Instance.new("TextButton", Scroll)
IncSpeed.Size = UDim2.new(0,30,0,30); IncSpeed.Position = UDim2.new(0.75,0,0,y-40)
IncSpeed.Text = "+"; IncSpeed.BackgroundColor3 = Color3.fromRGB(0,200,0)
IncSpeed.MouseButton1Click:Connect(function()
    Speed.value = Speed.value + 10
    SpeedBtn.Text = "Speed: " .. (Speed.on and "ON" or "OFF") .. " [S] | " .. Speed.value
    if Speed.on then Humanoid.WalkSpeed = Speed.value end
end)

-- === JUMP ===
local JumpBtn = Btn("High Jump: OFF [J] | 100", function()
    Jump.on = not Jump.on
    JumpBtn.Text = "High Jump: " .. (Jump.on and "ON" or "OFF") .. " [J] | " .. Jump.power
    Humanoid.JumpPower = Jump.on and Jump.power or 50
end)

-- === ANTIBAN/AFK ===
Btn("AntiBan & AntiAFK: OFF", function()
    AntiAFK.on = not AntiAFK.on
    if AntiAFK.on then
        AntiAFK.conn = RunService.Heartbeat:Connect(function()
            pcall(function()
                RootPart.CFrame = RootPart.CFrame * CFrame.new(0,0.1,0)
                wait(0.1)
                RootPart.CFrame = RootPart.CFrame * CFrame.new(0,-0.1,0)
            end)
        end)
    else
        if AntiAFK.conn then AntiAFK.conn:Disconnect() end
    end
end)

-- === ESP PLAYERS ===
Btn("ESP Players: OFF [E]", function()
    ESP.on = not ESP.on
    if ESP.on then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Colors[math.random(1,#Colors)]
                h.OutlineColor = Color3.new(1,1,1)
                h.FillTransparency = 0.5
                ESP.hl[p] = h
            end
        end
    else
        for _, h in pairs(ESP.hl) do if h then h:Destroy() end end
        ESP.hl = {}
    end
end)

-- === ESP MODS ===
Btn("ESP Mods: OFF", function()
    ESPMod.on = not ESPMod.on
    if ESPMod.on then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local n = p.Name:lower()
                if n:find("mod") or n:find("admin") or n:find("owner") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Colors[math.random(1,#Colors)]
                    h.OutlineColor = Color3.fromRGB(255,255,0)
                    h.FillTransparency = 0.3
                    ESPMod.hl[p] = h
                end
            end
        end
    else
        for _, h in pairs(ESPMod.hl) do if h then h:Destroy() end end
        ESPMod.hl = {}
    end
end)

-- === MỞ/ĐÓNG MENU ===
local open = false
Toggle.MouseButton1Click:Connect(function()
    open = not open
    Frame.Visible = open
    Toggle.Text = open and "HieuDRG - Close" or "HieuDRG Hub"
end)

Close.MouseButton1Click:Connect(function()
    open = false
    Frame.Visible = false
    Toggle.Text = "HieuDRG Hub"
end)

-- === FLY LOOP ===
RunService.Heartbeat:Connect(function()
    if Fly.on and Fly.body then
        local cam = workspace.CurrentCamera
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
end)

-- === UPTIME ===
spawn(function()
    local start = tick()
    while wait(1) do
        local t = tick() - start
        local h, m, s = math.floor(t/3600), math.floor((t%3600)/60), t%60
        Uptime.Text = "Uptime: " .. string.format("%02d:%02d:%02d", h, m, s)
    end
end)

-- === THÔNG BÁO ===
StarterGui:SetCore("SendNotification", {
    Title = "HIEUDRG HUB v8.0",
    Text = "MENU MỞ NGAY KHI CLICK NÚT!",
    Duration = 5
})
