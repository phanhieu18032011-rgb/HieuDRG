local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/UiRedzV5/refs/heads/main/DemoUi.lua"))();

-- Khởi tạo Cửa sổ chính
local Windows = redzlib:MakeWindow({
    Title = "DRGTeam Hub",
    SubTitle = "Shadow Core V103 - HieuDRG",
    SaveFolder = "DRGTeam_V3.lua"
})

-- Nút thu nhỏ
Windows:AddMinimizeButton({
    Button = { Image = "rbxassetid://76314993516756", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 6) }
})

local MainTab = Windows:MakeTab({"Fly V3", "rbxassetid://4483345998"})
local SpeedTab = Windows:MakeTab({"Speed", "rbxassetid://4483362458"})
local VisualTab = Windows:MakeTab({"Visual/ESP", "rbxassetid://4483362458"})

-- Biến Logic
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local flying = false
local noclip = false
local flySpeeds = 1
local walkSpeedValue = 16
local tpwalking = false
local flyConn
local walkConn

-- Biến ESP
local espPlayerEnabled = false
local espMobEnabled = false
local rainbowColor = Color3.new(1,1,1)

-- Cập nhật màu cầu vồng (7 màu)
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            rainbowColor = Color3.fromHSV(i, 1, 1)
            task.wait(0.05)
        end
    end
end)

-- Hàm Reset Trạng thái Humanoid
local function ResetStates(state)
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local states = {
        Enum.HumanoidStateType.Climbing, Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Flying, Enum.HumanoidStateType.Freefall,
        Enum.HumanoidStateType.GettingUp, Enum.HumanoidStateType.Jumping,
        Enum.HumanoidStateType.Landed, Enum.HumanoidStateType.Physics,
        Enum.HumanoidStateType.PlatformStanding, Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Running, Enum.HumanoidStateType.RunningNoPhysics,
        Enum.HumanoidStateType.Seated, Enum.HumanoidStateType.StrafingNoPhysics,
        Enum.HumanoidStateType.Swimming
    }
    for _, s in pairs(states) do
        hum:SetStateEnabled(s, state)
    end
end

-- ================= TAB FLY & NOCLIP =================

MainTab:AddToggle({
    Name = "Kích hoạt FLY (V3 Logic)",
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
            ResetStates(false)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
            task.spawn(function()
                while tpwalking and RunService.Heartbeat:Wait() do
                    if hum.MoveDirection.Magnitude > 0 then
                        for i = 1, flySpeeds do char:TranslateBy(hum.MoveDirection) end
                    end
                end
            end)
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            if root then
                local bg = Instance.new("BodyGyro", root)
                bg.Name = "DRG_Gyro"
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = root.CFrame
                local bv = Instance.new("BodyVelocity", root)
                bv.Name = "DRG_Velocity"
                bv.velocity = Vector3.new(0, 0.1, 0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                hum.PlatformStand = true
                flyConn = RunService.RenderStepped:Connect(function()
                    if not flying then return end
                    bg.cframe = workspace.CurrentCamera.CFrame
                    bv.velocity = Vector3.new(0,0,0)
                end)
            end
        else
            if flyConn then flyConn:Disconnect() end
            pcall(function()
                char.Animate.Disabled = false
                hum.PlatformStand = false
                ResetStates(true)
                hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                if root:FindFirstChild("DRG_Gyro") then root.DRG_Gyro:Destroy() end
                if root:FindFirstChild("DRG_Velocity") then root.DRG_Velocity:Destroy() end
            end)
        end
    end
})

MainTab:AddButton({
    Name = "Lên Cao (UP)",
    Callback = function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
    end
})

MainTab:AddButton({
    Name = "Xuống Thấp (DOWN)",
    Callback = function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, -5, 0)
        end
    end
})

MainTab:AddSlider({
    Name = "Cấp độ Speed Fly",
    Min = 1, Max = 10, Default = 1,
    Callback = function(Value) flySpeeds = Value end
})

MainTab:AddToggle({
    Name = "Noclip (Xuyên tường)",
    Default = false,
    Callback = function(Value)
        noclip = Value
        if noclip then
            noclipConn = RunService.Stepped:Connect(function()
                if not noclip then noclipConn:Disconnect() return end
                pcall(function()
                    for _, v in pairs(plr.Character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end)
            end)
        else
            if noclipConn then noclipConn:Disconnect() end
        end
    end
})

-- ================= TAB SPEED =================

local SpeedToggle = false
SpeedTab:AddToggle({
    Name = "Bật Speed Hack",
    Default = false,
    Callback = function(Value)
        SpeedToggle = Value
        if SpeedToggle then
            walkConn = RunService.Heartbeat:Connect(function()
                if not SpeedToggle then walkConn:Disconnect() return end
                pcall(function()
                    if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                        plr.Character.Humanoid.WalkSpeed = walkSpeedValue
                    end
                end)
            end)
        else
            if walkConn then walkConn:Disconnect() end
            pcall(function() plr.Character.Humanoid.WalkSpeed = 16 end)
        end
    end
})

SpeedTab:AddSlider({
    Name = "Chỉnh Tốc độ chạy",
    Min = 16, Max = 300, Default = 16,
    Callback = function(Value) walkSpeedValue = Value end
})

-- ================= TAB VISUAL (ESP PLAYER & MOB) =================

-- Hàm tạo Highlight ESP
local function CreateESP(object, isPlayer)
    if not object:FindFirstChild("DRG_ESP") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "DRG_ESP"
        highlight.Parent = object
        highlight.Adornee = object
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        -- Billboard hiển thị Tên và Máu
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "DRG_Info"
        billboard.Adornee = object:FindFirstChild("Head") or object:FindFirstChildWhichIsA("BasePart")
        billboard.Size = UDim2.new(0, 100, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = object
        
        local label = Instance.new("TextLabel")
        label.Parent = billboard
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        
        task.spawn(function()
            while object and object.Parent and highlight.Parent do
                highlight.FillColor = rainbowColor
                highlight.OutlineColor = rainbowColor
                
                local hum = object:FindFirstChildOfClass("Humanoid")
                if hum then
                    local dist = math.floor((plr.Character.HumanoidRootPart.Position - (object:FindFirstChild("HumanoidRootPart") and object.HumanoidRootPart.Position or Vector3.zero)).Magnitude)
                    label.Text = string.format("%s\nHP: %d/%d\n[%d m]", object.Name, math.floor(hum.Health), math.floor(hum.MaxHealth), dist)
                    label.TextColor3 = rainbowColor
                end
                task.wait(0.1)
            end
        end)
    end
end

local function RemoveESP(object)
    if object:FindFirstChild("DRG_ESP") then object.DRG_ESP:Destroy() end
    if object:FindFirstChild("DRG_Info") then object.DRG_Info:Destroy() end
end

VisualTab:AddToggle({
    Name = "ESP Player (7 Màu + Tên + Máu)",
    Default = false,
    Callback = function(Value)
        espPlayerEnabled = Value
        if not espPlayerEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= plr and p.Character then RemoveESP(p.Character) end
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "ESP Mob/NPC (7 Màu)",
    Default = false,
    Callback = function(Value)
        espMobEnabled = Value
        if not espMobEnabled then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then
                    RemoveESP(v)
                end
            end
        end
    end
})

-- Vòng lặp quét ESP
RunService.RenderStepped:Connect(function()
    if espPlayerEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                CreateESP(p.Character, true)
            end
        end
    end
    
    if espMobEnabled then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v ~= plr.Character and not Players:GetPlayerFromCharacter(v) then
                if v:FindFirstChild("HumanoidRootPart") then
                    CreateESP(v, false)
                end
            end
        end
    end
end)

redzlib:SetTheme("Dark")
print("DRGTeam Hub: Visual & ESP Updated. Owner: HieuDRG")
