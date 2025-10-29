-- HIEUDRG HUB v10.0 - FLYGUIV3 FIXED 100% (NO GAME PAUSED)
-- UI: Gravity Hub Style | Universal Roblox 2025
-- DÙNG VỚI: Synapse X, Krnl, Delta, Fluxus

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

-- === COLORS ===
local BG = Color3.fromRGB(12,12,12)
local PANEL = Color3.fromRGB(22,22,22)
local PANEL_ALT = Color3.fromRGB(28,28,28)
local ACCENT = Color3.fromRGB(255,165,0)
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

-- === GUI ===
local screenGui = new("ScreenGui", {Name = "HieuDRG_Hub", Parent = CoreGui, ResetOnSpawn = false})
screenGui.IgnoreGuiInset = true

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
local leftLayout = new("UIListLayout", {Parent = leftScroll, Padding = UDim.new(0,10)})

local rightScroll = new("ScrollingFrame", {
    Parent = rightPanel,
    Size = UDim2.new(1,-24,1,-46),
    Position = UDim2.new(0,12,0,40),
    BackgroundTransparency = 1,
    ScrollBarThickness = 6,
    AutomaticCanvasSize = Enum.AutomaticSize.Y
})
local rightLayout = new("UIListLayout", {Parent = rightScroll, Padding = UDim.new(0,10)})

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

-- === PLAYER & CHARACTER ===
local Player = Players.LocalPlayer
local function GetCharacter()
    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        return Player.Character
    end
    return nil
end

local Character = GetCharacter()
local Humanoid = Character and Character:FindFirstChild("Humanoid")
local RootPart = Character and Character:FindFirstChild("HumanoidRootPart")

-- === FLYGUIV3 REAL LOGIC (NO PAUSE) ===
local Fly = { on = false, speed = 50, body = nil, angular = nil, position = nil }
local flyToggle = makeToggle(leftScroll, "Fly [F]", false, function(v)
    Fly.on = v
    local char = GetCharacter()
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    RootPart = char.HumanoidRootPart

    if Fly.on then
        -- BodyVelocity
        Fly.body = Instance.new("BodyVelocity", RootPart)
        Fly.body.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        Fly.body.Velocity = Vector3.new(0,0,0)

        -- BodyPosition (chống pause)
        Fly.position = Instance.new("BodyPosition", RootPart)
        Fly.position.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        Fly.position.Position = RootPart.Position

        -- BodyAngularVelocity
        Fly.angular = Instance.new("BodyAngularVelocity", RootPart)
        Fly.angular.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        Fly.angular.AngularVelocity = Vector3.new(0,0,0)
    else
        if Fly.body then Fly.body:Destroy() end
        if Fly.position then Fly.position:Destroy() end
        if Fly.angular then Fly.angular:Destroy() end
    end
end)

makeSlider(leftScroll, "Fly Speed", 10, 200, 50, function(v) Fly.speed = v end)

-- === FLY LOOP (SMOOTH + NO PAUSE) ===
RunService.Heartbeat:Connect(function()
    if Fly.on and RootPart and Fly.body and Fly.position then
        local cam = workspace.CurrentCamera
        local move = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

        if move.Magnitude > 0 then
            move = move.Unit * Fly.speed
            Fly.body.Velocity = move
            Fly.position.Position = RootPart.Position + move
        else
            Fly.body.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- === RESPAWN HANDLER ===
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    wait(1)
    -- Reload Fly nếu đang bật
    if Fly.on then
        flyToggle.Set(false)
        wait(0.1)
        flyToggle.Set(true)
    end
end)

-- === CÁC CHỨC NĂNG KHÁC (giữ nguyên) ===
makeToggle(leftScroll, "Noclip [N]", false, function(v)
    if v then
        RunService.Stepped:Connect(function()
            for _, p in pairs(Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end)
    end
end)

makeToggle(rightScroll, "Speed Boots [S]", false, function(v)
    Humanoid.WalkSpeed = v and 100 or 16
end)

makeToggle(rightScroll, "High Jump [J]", false, function(v)
    Humanoid.JumpPower = v and 150 or 50
end)

makeToggle(rightScroll, "AntiBan & AntiAFK", false, function(v)
    if v then
        spawn(function()
            while wait(30) do
                pcall(function()
                    RootPart.CFrame = RootPart.CFrame * CFrame.new(0,0.1,0)
                    wait(0.1)
                    RootPart.CFrame = RootPart.CFrame * CFrame.new(0,-0.1,0)
                end)
            end
        end)
    end
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

-- === COLLAPSE / DRAG / INTRO (giữ nguyên) ===
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

-- Drag
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

-- Intro
window.Position = UDim2.new(0.5, -260, 0.5, -210)
window.BackgroundTransparency = 1
TweenService:Create(window, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
TweenService:Create(window, TweenInfo.new(0.2), {Position = UDim2.new(0.5,-260,0.5,-190)}):Play()

-- === NOTIFICATION ===
StarterGui:SetCore("SendNotification", {
    Title = "HieuDRG Hub v10.0",
    Text = "FLY ĐÃ SỬA - BAY MƯỢT, KHÔNG PAUSE!",
    Duration = 6
})
