local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/UiRedzV5/refs/heads/main/DemoUi.lua"))();

-- Khởi tạo Cửa sổ chính
local Windows = redzlib:MakeWindow({
    Title = "DRGTeam Hub",
    SubTitle = "Shadow Core V104 - HieuDRG",
    SaveFolder = "DRGTeam_V3.lua"
})

-- Nút thu nhỏ
Windows:AddMinimizeButton({
    Button = { Image = "rbxassetid://76314993516756", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 6) }
})

local MainTab = Windows:MakeTab({"Main", "rbxassetid://4483345998"})
local SpeedTab = Windows:MakeTab({"Speed", "rbxassetid://4483362458"})
local VisualTab = Windows:MakeTab({"Visual/ESP", "rbxassetid://4483362458"})
local CombatTab = Windows:MakeTab({"Combat", "rbxassetid://4483362458"})

-- Biến Logic Chung
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

-- Biến Combat
local hitboxEnabled = false
local hitboxSize = 10
local hitboxTransparency = 0.7
local lockAimEnabled = false
local lockTargetType = "Player" -- "Player" hoặc "Mob"

-- Biến ESP & Fly (giữ từ bản cũ)
local flying = false
local noclip = false
local flySpeeds = 1
local walkSpeedValue = 16
local tpwalking = false
local rainbowColor = Color3.new(1,1,1)

-- Cập nhật màu cầu vồng
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            rainbowColor = Color3.fromHSV(i, 1, 1)
            task.wait(0.05)
        end
    end
end)

-- ================= TAB COMBAT (HITBOX & AIM) =================

CombatTab:AddToggle({
    Name = "Bật Hitbox (Tầm đánh to)",
    Default = false,
    Callback = function(Value)
        hitboxEnabled = Value
    end
})

CombatTab:AddSlider({
    Name = "Kích thước Hitbox",
    Min = 1, Max = 30, Default = 10,
    Callback = function(Value) hitboxSize = Value end
})

CombatTab:AddSlider({
    Name = "Độ trong suốt Hitbox",
    Min = 0, Max = 10, Default = 7,
    Callback = function(Value) hitboxTransparency = Value / 10 end
})

CombatTab:AddSection({"Ghim Tâm (Aimbot)"})

CombatTab:AddToggle({
    Name = "Bật Ghim Tâm (Lock Aim)",
    Default = false,
    Callback = function(Value)
        lockAimEnabled = Value
    end
})

CombatTab:AddDropdown({
    Name = "Mục tiêu ghim",
    Options = {"Player", "Mob"},
    Default = "Player",
    Callback = function(Value)
        lockTargetType = Value
    end
})

-- Logic Hitbox & Lock Aim
RunService.RenderStepped:Connect(function()
    -- Xử lý Hitbox
    if hitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                p.Character.HumanoidRootPart.Transparency = hitboxTransparency
                p.Character.HumanoidRootPart.Color = Color3.new(1, 0, 0)
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
        -- Nếu chọn Mob cũng tăng Hitbox
        if lockTargetType == "Mob" then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                    local hrp = v:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                        hrp.Transparency = hitboxTransparency
                        hrp.CanCollide = false
                    end
                end
            end
        end
    end

    -- Xử lý Lock Aim (Ghim tâm)
    if lockAimEnabled then
        local target = nil
        local shortestDistance = math.huge

        local function checkTarget(obj)
            if obj and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChildOfClass("Humanoid").Health > 0 then
                local dist = (plr.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    target = obj
                end
            end
        end

        if lockTargetType == "Player" then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character then checkTarget(p.Character) end
            end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                    checkTarget(v)
                end
            end
        end

        if target then
            local cam = workspace.CurrentCamera
            cam.CFrame = CFrame.new(cam.CFrame.Position, target.HumanoidRootPart.Position)
        end
    end
end)

-- ================= CÁC TAB CŨ (GIỮ NGUYÊN) =================

-- Tab Main (Fly & Noclip)
MainTab:AddToggle({
    Name = "Kích hoạt FLY",
    Default = false,
    Callback = function(Value)
        flying = Value
        tpwalking = Value
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if flying then
            pcall(function()
                char.Animate.Disabled = true
                for _, v in next, hum:GetPlayingAnimationTracks() do v:AdjustSpeed(0) end
            end)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
            task.spawn(function()
                while tpwalking and RunService.Heartbeat:Wait() do
                    if hum.MoveDirection.Magnitude > 0 then
                        for i = 1, flySpeeds do char:TranslateBy(hum.MoveDirection) end
                    end
                end
            end)
            hum.PlatformStand = true
        else
            pcall(function()
                char.Animate.Disabled = false
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            end)
        end
    end
})

MainTab:AddButton({ Name = "UP", Callback = function() plr.Character.HumanoidRootPart.CFrame *= CFrame.new(0,5,0) end })
MainTab:AddButton({ Name = "DOWN", Callback = function() plr.Character.HumanoidRootPart.CFrame *= CFrame.new(0,-5,0) end })
MainTab:AddSlider({ Name = "Fly Speed", Min = 1, Max = 10, Default = 1, Callback = function(V) flySpeeds = V end })

-- Tab Speed
SpeedTab:AddToggle({
    Name = "Bật Speed Hack",
    Default = false,
    Callback = function(Value)
        _G.SpeedLoop = Value
        while _G.SpeedLoop do
            pcall(function() plr.Character.Humanoid.WalkSpeed = walkSpeedValue end)
            task.wait(0.1)
        end
    end
})
SpeedTab:AddSlider({ Name = "WalkSpeed", Min = 16, Max = 300, Default = 16, Callback = function(V) walkSpeedValue = V end })

-- Tab Visual (ESP)
local function CreateESP(object)
    if not object:FindFirstChild("DRG_ESP") then
        local highlight = Instance.new("Highlight", object)
        highlight.Name = "DRG_ESP"
        highlight.FillTransparency = 0.5
        task.spawn(function()
            while highlight.Parent do
                highlight.FillColor = rainbowColor
                highlight.OutlineColor = rainbowColor
                task.wait(0.1)
            end
        end)
    end
end

VisualTab:AddToggle({
    Name = "ESP Player",
    Default = false,
    Callback = function(Value)
        _G.ESPPlayer = Value
        while _G.ESPPlayer do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character then CreateESP(p.Character) end
            end
            task.wait(1)
        end
    end
})

VisualTab:AddToggle({
    Name = "ESP Mob",
    Default = false,
    Callback = function(Value)
        _G.ESPMob = Value
        while _G.ESPMob do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                    CreateESP(v)
                end
            end
            task.wait(2)
        end
    end
})

redzlib:SetTheme("Dark")
print("DRGTeam Hub: Hitbox & Lock Aim Updated. Owner: HieuDRG")
