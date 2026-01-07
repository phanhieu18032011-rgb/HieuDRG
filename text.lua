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

local MainTab = Windows:MakeTab({"Main/Fly", "rbxassetid://4483345998"})
local SpeedTab = Windows:MakeTab({"Speed", "rbxassetid://4483362458"})
local VisualTab = Windows:MakeTab({"Visual/ESP", "rbxassetid://4483362458"})
local CombatTab = Windows:MakeTab({"Combat", "rbxassetid://4483362458"})

-- Biến Logic Chung
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local plr = Players.LocalPlayer

-- Biến Fly Logic (Từ XNEO V3)
local nowe = false
local flySpeeds = 1
local tpwalking = false
local tis, dis -- Biến giữ cho UP/DOWN

-- Biến Combat & ESP
local hitboxEnabled = false
local hitboxSize = 10
local hitboxTransparency = 0.7
local lockAimEnabled = false
local lockTargetType = "Player"
local rainbowColor = Color3.new(1,1,1)

-- Biến Kill Aura
local killAuraEnabled = false
local killAuraRange = 20

-- Cập nhật màu cầu vồng
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            rainbowColor = Color3.fromHSV(i, 1, 1)
            task.wait(0.05)
        end
    end
end)

-- Hàm quản lý trạng thái Humanoid (Logic V3)
local function SetHumanoidStates(state)
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

-- ================= TAB MAIN (FLY LOGIC V3) =================

MainTab:AddToggle({
    Name = "Kích hoạt FLY (XNEO Logic)",
    Default = false,
    Callback = function(Value)
        nowe = Value
        local char = plr.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if nowe then
            -- Tắt Animate
            if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
            for _, v in next, hum:GetPlayingAnimationTracks() do v:AdjustSpeed(0) end
            
            SetHumanoidStates(false)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
            
            -- Logic TP Walking
            task.spawn(function()
                tpwalking = true
                while tpwalking and RunService.Heartbeat:Wait() do
                    if hum.MoveDirection.Magnitude > 0 then
                        for i = 1, flySpeeds do
                            char:TranslateBy(hum.MoveDirection)
                        end
                    end
                end
            end)
            
            -- Logic BodyGyro & Velocity (Hỗ trợ R6/R15)
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            if root then
                local bg = Instance.new("BodyGyro", root)
                bg.Name = "DRG_FlyGyro"
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = root.CFrame
                
                local bv = Instance.new("BodyVelocity", root)
                bv.Name = "DRG_FlyVelocity"
                bv.velocity = Vector3.new(0, 0.1, 0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                
                hum.PlatformStand = true
                
                task.spawn(function()
                    while nowe do
                        RunService.RenderStepped:Wait()
                        bg.cframe = workspace.CurrentCamera.CFrame
                        bv.velocity = Vector3.new(0,0,0)
                    end
                    bg:Destroy()
                    bv:Destroy()
                end)
            end
        else
            tpwalking = false
            if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
            hum.PlatformStand = false
            SetHumanoidStates(true)
            hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    end
})

MainTab:AddButton({
    Name = "UP (Giữ để lên cao)",
    Callback = function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame *= CFrame.new(0, 2, 0)
        end
    end
})

MainTab:AddButton({
    Name = "DOWN (Giữ để xuống thấp)",
    Callback = function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame *= CFrame.new(0, -2, 0)
        end
    end
})

MainTab:AddSlider({
    Name = "Tốc độ Bay (Fly Speed)",
    Min = 1, Max = 20, Default = 1,
    Callback = function(Value) flySpeeds = Value end
})

MainTab:AddToggle({
    Name = "Noclip (Xuyên tường)",
    Default = false,
    Callback = function(Value)
        _G.Noclip = Value
        RunService.Stepped:Connect(function()
            if _G.Noclip and plr.Character then
                for _, v in pairs(plr.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    end
})

-- ================= TAB COMBAT (HITBOX, AIM & KILLAURA) =================

CombatTab:AddToggle({
    Name = "Bật Hitbox (Tầm đánh to)",
    Default = false,
    Callback = function(Value) hitboxEnabled = Value end
})

CombatTab:AddSlider({
    Name = "Kích thước Hitbox",
    Min = 1, Max = 30, Default = 10,
    Callback = function(Value) hitboxSize = Value end
})

CombatTab:AddSection({"Kill Aura (Tự động đánh)"})

CombatTab:AddToggle({
    Name = "Kích hoạt Kill Aura",
    Default = false,
    Callback = function(Value)
        killAuraEnabled = Value
    end
})

CombatTab:AddSlider({
    Name = "Tầm đánh Kill Aura",
    Min = 5, Max = 50, Default = 20,
    Callback = function(Value)
        killAuraRange = Value
    end
})

CombatTab:AddSection({"Ghim Tâm (Lock Aim)"})

CombatTab:AddToggle({
    Name = "Bật Ghim Tâm (Lock Aim)",
    Default = false,
    Callback = function(Value) lockAimEnabled = Value end
})

CombatTab:AddDropdown({
    Name = "Mục tiêu ghim",
    Options = {"Player", "Mob"},
    Default = "Player",
    Callback = function(Value) lockTargetType = Value end
})

-- ================= TAB SPEED & VISUAL (GIỮ NGUYÊN) =================

SpeedTab:AddToggle({
    Name = "Bật Speed Hack",
    Default = false,
    Callback = function(Value)
        _G.SpeedLoop = Value
        task.spawn(function()
            while _G.SpeedLoop do
                pcall(function() plr.Character.Humanoid.WalkSpeed = walkSpeedValue end)
                task.wait(0.1)
            end
            pcall(function() plr.Character.Humanoid.WalkSpeed = 16 end)
        end)
    end
})

local walkSpeedValue = 16
SpeedTab:AddSlider({ Name = "WalkSpeed", Min = 16, Max = 300, Default = 16, Callback = function(V) walkSpeedValue = V end })

-- ESP Player & Mob
local function CreateESP(object)
    if not object:FindFirstChild("DRG_ESP") then
        local highlight = Instance.new("Highlight", object)
        highlight.Name = "DRG_ESP"
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

-- Logic Kill Aura Loop
task.spawn(function()
    while true do
        if killAuraEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and v ~= plr.Character and v.Humanoid.Health > 0 then
                        -- Không đánh Player nếu đang để chế độ farm quái (tùy game, mặc định quét mob)
                        if not Players:GetPlayerFromCharacter(v) then
                            local root = v:FindFirstChild("HumanoidRootPart")
                            if root then
                                local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
                                if dist <= killAuraRange then
                                    -- Giả lập nhấn chuột trái (M1)
                                    VirtualUser:CaptureController()
                                    VirtualUser:Button1Down(Vector2.new(1280, 672))
                                end
                            end
                        end
                    end
                end
            end)
        end
        task.wait(0.1) -- Tốc độ đánh
    end
end)

-- Loop xử lý Hitbox & Aim
RunService.RenderStepped:Connect(function()
    if hitboxEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= plr and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                p.Character.HumanoidRootPart.Transparency = 0.7
                p.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
    
    if lockAimEnabled then
        local target = nil
        local shortestDistance = math.huge
        local function checkTarget(obj)
            if obj and obj:FindFirstChild("HumanoidRootPart") and obj:FindFirstChildOfClass("Humanoid") and obj.Humanoid.Health > 0 then
                local dist = (plr.Character.HumanoidRootPart.Position - obj.HumanoidRootPart.Position).Magnitude
                if dist < shortestDistance then shortestDistance = dist; target = obj end
            end
        end
        if lockTargetType == "Player" then
            for _, p in pairs(Players:GetPlayers()) do if p ~= plr and p.Character then checkTarget(p.Character) end end
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v:FindFirstChildOfClass("Humanoid") and not Players:GetPlayerFromCharacter(v) then checkTarget(v) end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.HumanoidRootPart.Position)
        end
    end
end)

redzlib:SetTheme("Dark")
game:GetService("StarterGui"):SetCore("SendNotification", { Title = "DRGTeam Hub", Text = "Kill Aura & Combat Loaded!", Duration = 5 })
