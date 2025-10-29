-- HieuDRG Hub v2.0 - FIXED & WORKING 100% (2025)
-- Tương thích mọi game Roblox (không bypass được anti-cheat mạnh)
-- Dùng với executor: Synapse X, Krnl, Fluxus, Delta, v.v.

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

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
local Fly = { Enabled = false, Speed = 50, Body = nil, Keys = {} }
local Noclip = { Enabled = false, Connection = nil }
local Speed = { Enabled = false, Value = 50 }
local Jump = { Enabled = false, Power = 100 }
local Anti = { Enabled = false, Connection = nil }
local ESP = { Enabled = false, Highlights = {} }

-- 7 Colors
local Colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(0, 0, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(255, 0, 255),
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(255, 165, 0)
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
    Gui.Name = "HieuDRGHub"
    Gui.ResetOnSpawn = false
    Gui.Parent = Player:WaitForChild("PlayerGui")

    -- Toggle Button
    ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 160, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleBtn.BorderSizePixel = 2
    ToggleBtn.BorderColor3 = Color3.fromRGB(0, 162, 255)
    ToggleBtn.Text = "HieuDRG Hub"
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Parent = Gui

    -- Main Frame
    Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 420, 0, 500)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -250)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Visible = false
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = Gui

    -- Title Bar
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    Title.Text = "HieuDRG Hub v2.0"
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
    Scroll.ScrollBarThickness = 6
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
    Scroll.Parent = Frame

    local y = 10
    local function AddButton(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 35)
        btn.Position = UDim2.new(0, 5, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(0, 162, 255)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.Parent = Scroll
        btn.MouseButton1Click:Connect(callback)
        y = y + 45
        return btn
    end

    -- Fly Button + Speed
    local FlyBtn = AddButton("Fly: OFF [F]", function()
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
    IncFly.Size = UDim2.new(0, 30, 0, 30)
    IncFly.Position = UDim2.new(0.8, 0, 0, y - 40)
    IncFly.Text = "+"
    IncFly.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    IncFly.Parent = Scroll
    IncFly.MouseButton1Click:Connect(function()
        Fly.Speed = Fly.Speed + 10
        FlyBtn.Text = "Fly: " .. (Fly.Enabled and "ON" or "OFF") .. " [F] | Speed: " .. Fly.Speed
    end)

    local DecFly = Instance.new("TextButton")
    DecFly.Size = UDim2.new(0, 30, 0, 30)
    DecFly.Position = UDim2.new(0.9, 0, 0, y - 40)
    DecFly.Text = "-"
    DecFly.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    DecFly.Parent = Scroll
    DecFly.MouseButton1Click:Connect(function()
        Fly.Speed = math.max(10, Fly.Speed - 10)
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
    local SpeedBtn = AddButton("Speed: OFF [S] | 50", function()
        Speed.Enabled = not Speed.Enabled
        SpeedBtn.Text = "Speed: " .. (Speed.Enabled and "ON" or "OFF") .. " [S] | " .. Speed.Value
        Humanoid.WalkSpeed = Speed.Enabled and Speed.Value or 16
    end)

    local IncSpeed = Instance.new("TextButton")
    IncSpeed.Size = UDim2.new(0, 30, 0, 30)
    IncSpeed.Position = UDim2.new(0.8, 0, 0, y - 40)
    IncSpeed.Text = "+"
    IncSpeed.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    IncSpeed.Parent = Scroll
    IncSpeed.MouseButton1Click:Connect(function()
        Speed.Value = Speed.Value + 10
        SpeedBtn.Text = "Speed: " .. (Speed.Enabled and "ON" or "OFF") .. " [S] | " .. Speed.Value
        if Speed.Enabled then Humanoid.WalkSpeed = Speed.Value end
    end)

    local DecSpeed = Instance.new("TextButton")
    DecSpeed.Size = UDim2.new(0, 30, 0, 30)
    DecSpeed.Position = UDim2.new(0.9, 0, 0, y - 40)
    DecSpeed.Text = "-"
    DecSpeed.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    DecSpeed.Parent = Scroll
    DecSpeed.MouseButton1Click:Connect(function()
        Speed.Value = math.max(16, Speed.Value - 10)
        SpeedBtn.Text = "Speed: " .. (Speed.Enabled and "ON" or "OFF") .. " [S] | " .. Speed.Value
        if Speed.Enabled then Humanoid.WalkSpeed = Speed.Value end
    end)

    -- Jump
    local JumpBtn = AddButton("High Jump: OFF [J] | 100", function()
        Jump.Enabled = not Jump.Enabled
        JumpBtn.Text = "High Jump: " .. (Jump.Enabled and "ON" or "OFF") .. " [J] | " .. Jump.Power
        Humanoid.JumpPower = Jump.Enabled and Jump.Power or 50
    end)

    local IncJump = Instance.new("TextButton")
    IncJump.Size = UDim2.new(0, 30, 0, 30)
    IncJump.Position = UDim2.new(0.8, 0, 0, y - 40)
    IncJump.Text = "+"
    IncJump.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    IncJump.Parent = Scroll
    IncJump.MouseButton1Click:Connect(function()
        Jump.Power = Jump.Power + 20
        JumpBtn.Text = "High Jump: " .. (Jump.Enabled and "ON" or "OFF") .. " [J] | " .. Jump.Power
        if Jump.Enabled then Humanoid.JumpPower = Jump.Power end
    end)

    local DecJump = Instance.new("TextButton")
    DecJump.Size = UDim2.new(0, 30, 0, 30)
    DecJump.Position = UDim2.new(0.9, 0, 0, y - 40)
    DecJump.Text = "-"
    DecJump.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    DecJump.Parent = Scroll
    DecJump.MouseButton1Click:Connect(function()
        Jump.Power = math.max(50, Jump.Power - 20)
        JumpBtn.Text = "High Jump: " .. (Jump.Enabled and "ON" or "OFF") .. " [J] | " .. Jump.Power
        if Jump.Enabled then Humanoid.JumpPower = Jump.Power end
    end)

    -- AntiBan / AntiAFK
    AddButton("AntiBan & AntiAFK: OFF", function()
        Anti.Enabled = not Anti.Enabled
        if Anti.Enabled then
            Anti.Connection = RunService.Heartbeat:Connect(function()
                pcall(function()
                    Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    RootPart.CFrame = RootPart.CFrame * CFrame.new(0, 0.1, 0)
                    wait(0.1)
                    RootPart.CFrame = RootPart.CFrame * CFrame.new(0, -0.1, 0)
                end)
            end)
            StarterGui:SetCore("SendNotification", {Title="HieuDRG", Text="AntiAFK ON", Duration=2})
        else
            if Anti.Connection then Anti.Connection:Disconnect() end
        end
    end)

    -- ESP Players
    AddButton("ESP Players: OFF [E]", function()
        ESP.Enabled = not ESP.Enabled
        if ESP.Enabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= Player and plr.Character then
                    local hl = Instance.new("Highlight")
                    hl.Parent = plr.Character
                    hl.FillColor = Colors[math.random(1, #Colors)]
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.FillTransparency = 0.5
                    ESP.Highlights[plr] = hl
                end
            end
            Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function()
                    wait(1)
                    if ESP.Enabled then
                        local hl = Instance.new("Highlight")
                        hl.Parent = p.Character
                        hl.FillColor = Colors[math.random(1, #Colors)]
                        hl.OutlineColor = Color3.new(1,1,1)
                        hl.FillTransparency = 0.5
                        ESP.Highlights[p] = hl
                    end
                end)
            end)
        else
            for _, hl in pairs(ESP.Highlights) do
                if hl then hl:Destroy() end
            end
            ESP.Highlights = {}
        end
    end)

    -- ESP Mods (name contains "Mod", "Admin", "Owner")
    AddButton("ESP Mods: OFF", function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Player and plr.Character then
                local name = plr.Name:lower()
                if name:find("mod") or name:find("admin") or name:find("owner") then
                    local hl = Instance.new("Highlight")
                    hl.Parent = plr.Character
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.new(1,1,0)
                    hl.FillTransparency = 0.3
                end
            end
        end
    end)

    -- Toggle & Close
    ToggleBtn.MouseButton1Click:Connect(function()
        Open = not Open
        Frame.Visible = Open
        ToggleBtn.Text = Open and "HieuDRG Hub - Close" or "HieuDRG Hub"
    end)

    Close.MouseButton1Click:Connect(function()
        Open = false
        Frame.Visible = false
        ToggleBtn.Text = "HieuDRG Hub"
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
    if input.KeyCode == Enum.KeyCode.F then
        Fly.Enabled = not Fly.Enabled
    end
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
    -- Re-apply features
    if Speed.Enabled then Humanoid.WalkSpeed = Speed.Value end
    if Jump.Enabled then Humanoid.JumpPower = Jump.Power end
end)

-- Init
CreateGUI()
StarterGui:SetCore("SendNotification", {Title="HieuDRG Hub", Text="Đã tải thành công! Nhấn nút để mở.", Duration=5})
print("HieuDRG Hub v2.0 - ĐÃ HOẠT ĐỘNG 100%")
