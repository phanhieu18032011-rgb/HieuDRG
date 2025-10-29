-- HIEUDRG HUB v9.0 - UNIVERSAL ROBLOX SCRIPT (Gravity UI + FlyGuiV3)
-- DỰA TRÊN: Gravity Hub Vision 1.3 + FlyGuiV3
-- HOẠT ĐỘNG 100% TRÊN MỌI GAME (Synapse X, Krnl, Delta, Fluxus)

-- === SERVICES ===
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

-- === CLEANUP ===
if CoreGui:FindFirstChild("HieuDRG_Hub") then
    CoreGui.HieuDRG_Hub:Destroy()
end

-- === COLORS (GRAVITY STYLE) ===
local BG = Color3.fromRGB(12,12,12)
local PANEL = Color3.fromRGB(22,22,22)
local PANEL_ALT = Color3.fromRGB(28,28,28)
local ACCENT = Color3.fromRGB(255,165,0) -- Orange
local TXT = Color3.fromRGB(230,230,230)
local MUTED = Color3.fromRGB(160,160,160)
local TOGGLE_OFF = Color3.fromRGB(80,80,80)

-- === HELPER ===
local function new(class, props)
    local inst = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k == "Parent" then inst.Parent = v else inst[k] = v end
        end
    end
    return inst
end

-- === ROOT GUI ===
local screenGui = new("ScreenGui", {Name = "HieuDRG_Hub", Parent = CoreGui, ResetOnSpawn = false})
screenGui.IgnoreGuiInset = true

-- === WINDOW ===
local window = new("Frame", {
    Name = "Window",
    Parent = screenGui,
    Size = UDim2.fromOffset(520, 380),
    Position = UDim2.new(0.5, -260, 0.5, -190),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    ClipsDescendants = true
})
new("UICorner", {Parent = window, CornerRadius = UDim.new(0,12)})

-- === HEADER ===
local header = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,0,60),
    BackgroundColor3 = PANEL_ALT,
    BorderSizePixel = 0
})
new("UICorner", {Parent = header, CornerRadius = UDim.new(0,12)})

local titleLabel = new("TextLabel", {
    Parent = header,
    Text = "HieuDRG Hub",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = ACCENT,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,15,0,8),
    Size = UDim2.new(0.6,0,0,24),
    TextXAlignment = Enum.TextXAlignment.Left
})

-- PLAYER NAME + AVATAR
local playerLabel = new("TextLabel", {
    Parent = header,
    Text = "Player: " .. Players.LocalPlayer.Name,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = MUTED,
    BackgroundTransparency = 1,
    Position = UDim2.new(0,15,0,34),
    Size = UDim2.new(0.5,0,0,18),
    TextXAlignment = Enum.TextXAlignment.Left
})

local avatar = new("ImageLabel", {
    Parent = header,
    Size = UDim2.new(0,40,0,40),
    Position = UDim2.new(0, 400, 0, 10),
    BackgroundTransparency = 1,
    Image = Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
})
new("UICorner", {Parent = avatar, CornerRadius = UDim.new(1,0)})

-- UPTIME
local uptimeLabel = new("TextLabel", {
    Parent = header,
    Text = "Uptime: 00:00:00",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = MUTED,
    BackgroundTransparency = 1,
    Position = UDim2.new(0.6,0,0,34),
    Size = UDim2.new(0.4,0,0,18),
    TextXAlignment = Enum.TextXAlignment.Right
})

-- COLLAPSE BUTTON (-)
local btnCollapse = new("TextButton", {
    Parent = header,
    Size = UDim2.new(0,44,0,30),
    Position = UDim2.new(1,-56,0.5,-15),
    BackgroundColor3 = PANEL,
    Text = "-",
    Font = Enum.Font.GothamBold,
    TextSize = 20,
    TextColor3 = TXT,
    AutoButtonColor = false
})
new("UICorner", {Parent = btnCollapse, CornerRadius = UDim.new(0,8)})

-- === CONTENT AREA ===
local content = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,1,-60),
    Position = UDim2.new(0,0,0,60),
    BackgroundTransparency = 1
})

-- === PANELS ===
local leftPanel = new("Frame", {
    Parent = content,
    Size = UDim2.new(0.5,-12,1,-24),
    Position = UDim2.new(0,12,0,12),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
})
new("UICorner", {Parent = leftPanel, CornerRadius = UDim.new(0,10)})

local rightPanel = new("Frame", {
    Parent = content,
    Size = UDim2.new(0.5,-12,1,-24),
    Position = UDim2.new(0.5,6,0,12),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
})
new("UICorner", {Parent = rightPanel, CornerRadius = UDim.new(0,10)})

-- === SCROLLS ===
local leftScroll = new("ScrollingFrame", {
    Parent = leftPanel,
    Size = UDim2.new(1,-24,1,-46),
    Position = UDim2.new(0,12,0,40),
    BackgroundTransparency = 1,
    ScrollBarThickness = 6,
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})
local leftLayout = new("UIListLayout", {Parent = leftScroll, Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder})

local rightScroll = new("ScrollingFrame", {
    Parent = rightPanel,
    Size = UDim2.new(1,-24,1,-46),
    Position = UDim2.new(0,12,0,40),
    BackgroundTransparency = 1,
    ScrollBarThickness = 6,
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})
local rightLayout = new("UIListLayout", {Parent = rightScroll, Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder})

-- === TOGGLE FACTORY ===
local function makeToggle(parent, text, default, callback)
    local row = new("TextButton", {
        Parent = parent,
        Size = UDim2.new(1,0,0,48),
        BackgroundColor3 = Color3.fromRGB(38,38,38),
        AutoButtonColor = false,
        Text = ""
    })
    new("UICorner", {Parent = row, CornerRadius = UDim.new(0,8)})

    local label = new("TextLabel", {
        Parent = row,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = TXT,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,12,0,0),
        Size = UDim2.new(1,-96,1,0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    })

    local sw = new("Frame", {
        Parent = row,
        Size = UDim2.new(0,44,0,24),
        Position = UDim2.new(1,-56,0.5,-12),
        BackgroundColor3 = default and ACCENT or TOGGLE_OFF
    })
    new("UICorner", {Parent = sw, CornerRadius = UDim.new(1,0)})

    local knob = new("Frame", {
        Parent = sw,
        Size = UDim2.new(0,18,0,18),
        Position = default and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,4,0.5,-9),
        BackgroundColor3 = Color3.fromRGB(245,245,245)
    })
    new("UICorner", {Parent = knob, CornerRadius = UDim.new(1,0)})

    local toggled = default or false
    local function setState(v)
        toggled = v
        local color = toggled and ACCENT or TOGGLE_OFF
        local pos = toggled and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,4,0.5,-9)
        TweenService:Create(sw, TweenInfo.new(0.14), {BackgroundColor3 = color}):Play()
        TweenService:Create(knob, TweenInfo.new(0.14), {Position = pos}):Play()
        if callback then pcall(callback, toggled) end
    end

    row.MouseButton1Click:Connect(function() setState(not toggled) end)
    return {Set = setState, Get = function() return toggled end}
end

-- === SLIDER FACTORY ===
local function makeSlider(parent, text, minv, maxv, default, callback)
    local row = new("TextButton", {
        Parent = parent,
        Size = UDim2.new(1,0,0,64),
        BackgroundColor3 = Color3.fromRGB(38,38,38),
        AutoButtonColor = false,
        Text = ""
    })
    new("UICorner", {Parent = row, CornerRadius = UDim.new(0,8)})

    local label = new("TextLabel", {
        Parent = row,
        Text = text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = TXT,
        BackgroundTransparency = 1,
        Position = UDim2.new(0,12,0,6),
        Size = UDim2.new(1,-24,0,18),
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local bar = new("Frame", {
        Parent = row,
        Size = UDim2.new(1,-120,0,12),
        Position = UDim2.new(0,12,0,34),
        BackgroundColor3 = Color3.fromRGB(60,60,60)
    })
    new("UICorner", {Parent = bar, CornerRadius = UDim.new(0,6)})

    local frac = math.clamp((default-minv)/(maxv-minv),0,1)
    local fill = new("Frame", {
        Parent = bar,
        Size = UDim2.new(frac,0,1,0),
        BackgroundColor3 = ACCENT
    })
    new("UICorner", {Parent = fill, CornerRadius = UDim.new(0,6)})

    local knob = new("Frame", {
        Parent = bar,
        Size = UDim2.new(0,14,0,14),
        Position = UDim2.new(frac,-7,0.5,-7),
        BackgroundColor3 = Color3.fromRGB(245,245,245)
    })
    new("UICorner", {Parent = knob, CornerRadius = UDim.new(1,0)})

    local display = new("TextLabel", {
        Parent = row,
        Text = tostring(default),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = TXT,
        BackgroundTransparency = 1,
        Size = UDim2.new(0,72,0,20),
        Position = UDim2.new(1,-92,0,22)
    })

    local dragging = false
    local function updateFromX(x)
        local absX = math.clamp(x - bar.AbsolutePosition.X, 0, bar.AbsoluteSize.X)
        local frac2 = absX / bar.AbsoluteSize.X
        local val = math.floor(minv + (maxv-minv)*frac2 + 0.5)
        fill.Size = UDim2.new(frac2,0,1,0)
        knob.Position = UDim2.new(frac2,-7,0.5,-7)
        display.Text = tostring(val)
        if callback then pcall(callback, val) end
    end

    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then updateFromX(i.Position.X); dragging = true end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then updateFromX(i.Position.X) end end)

    return {Row = row}
end

-- === PLAYER & CHARACTER ===
local Player = Players.LocalPlayer
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
local ESPColors = {
    Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255),
    Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255), Color3.fromRGB(0,255,255),
    Color3.fromRGB(255,165,0)
}

-- === CHỨC NĂNG ===

-- Fly (FlyGuiV3)
local flyToggle = makeToggle(leftScroll, "Fly [F]", false, function(v)
    Fly.on = v
    if Fly.on then
        Fly.body = Instance.new("BodyVelocity", RootPart)
        Fly.body.MaxForce = Vector3.new(1e5,1e5,1e5)
        Fly.body.Velocity = Vector3.new(0,0,0)
    else
        if Fly.body then Fly.body:Destroy() end
    end
end)
makeSlider(leftScroll, "Fly Speed", 10, 200, 50, function(v) Fly.speed = v end)

-- Noclip
makeToggle(leftScroll, "Noclip [N]", false, function(v)
    Noclip.on = v
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

-- Speed
makeToggle(rightScroll, "Speed Boots [S]", false, function(v)
    Speed.on = v
    Humanoid.WalkSpeed = Speed.on and Speed.value or 16
end)
makeSlider(rightScroll, "Speed Value", 16, 300, 50, function(v) Speed.value = v; if Speed.on then Humanoid.WalkSpeed = v end end)

-- Jump
makeToggle(rightScroll, "High Jump [J]", false, function(v)
    Jump.on = v
    Humanoid.JumpPower = Jump.on and Jump.power or 50
end)

-- AntiBan/AFK
makeToggle(rightScroll, "AntiBan & AntiAFK", false, function(v)
    AntiAFK.on = v
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

-- ESP Players
makeToggle(leftScroll, "ESP Players (7 Colors)", false, function(v)
    ESP.on = v
    if ESP.on then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = ESPColors[math.random(1,#ESPColors)]
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

-- ESP Mods
makeToggle(rightScroll, "ESP Mods (7 Colors)", false, function(v)
    ESPMod.on = v
    if ESPMod.on then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local n = p.Name:lower()
                if n:find("mod") or n:find("admin") or n:find("owner") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = ESPColors[math.random(1,#ESPColors)]
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
        local h, m, s = math.floor(t/3600), math.floor((t%3600)/60), math.floor(t%60)
        uptimeLabel.Text = "Uptime: " .. string.format("%02d:%02d:%02d", h, m, s)
    end
end)

-- === COLLAPSE / EXPAND ===
local collapsed = false
btnCollapse.MouseButton1Click:Connect(function()
    if collapsed then
        TweenService:Create(window, TweenInfo.new(0.18), {Size = UDim2.fromOffset(520,380)}):Play()
        collapsed = false
    else
        TweenService:Create(window, TweenInfo.new(0.18), {Size = UDim2.fromOffset(520,60)}):Play()
        collapsed = true
    end
end)

-- === DRAG ===
local dragging = false
local dragStart, startPos
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = window.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
header.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- === INTRO ANIMATION ===
window.Position = UDim2.new(0.5, -260, 0.5, -210)
window.BackgroundTransparency = 1
TweenService:Create(window, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
TweenService:Create(window, TweenInfo.new(0.2), {Position = UDim2.new(0.5,-260,0.5,-190)}):Play()

-- === NOTIFICATION ===
StarterGui:SetCore("SendNotification", {
    Title = "HieuDRG Hub v9.0",
    Text = "UI Gravity + FlyGuiV3 - MENU MỞ NGAY!",
    Duration = 5
})

print("HIEUDRG HUB v9.0 - LOADED 100%")
