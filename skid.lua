------------------------------------------------------------------------
--  PURE FLY LOGIC  –  FlyGuiV3 Core Only
--  E : toggle fly
--  PageUp / PageDown : tăng/giảm tốc độ
------------------------------------------------------------------------
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local flying = false
local speed = 50
local deltaLimit = 1.2
local bobFreq, bobAmp = 1.5, 0.15
local conn
local keys = {} -- W A S D Space Shift

local function getMoveVector()
    local v = Vector3.new(0,0,0)
    if keys.W then v = v + Vector3.new(0,0,-1) end
    if keys.S then v = v + Vector3.new(0,0,1) end
    if keys.A then v = v + Vector3.new(-1,0,0) end
    if keys.D then v = v + Vector3.new(1,0,0) end
    if keys.Space then v = v + Vector3.new(0,1,0) end
    if keys.LeftShift then v = v + Vector3.new(0,-1,0) end
    return v
end

local function flyStep()
    if not flying then return end
    local cam = workspace.CurrentCamera
    local look = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    local up = Vector3.new(0,1,0)

    local move = getMoveVector()
    local dir = (look * move.Z + right * move.X + up * move.Y).Unit
    if move.Magnitude == 0 then dir = Vector3.new(0,0,0) end

    local bob = math.sin(tick() * bobFreq) * bobAmp
    local target = root.CFrame + dir * math.min(speed * 0.016, deltaLimit) + Vector3.new(0,bob,0)
    root.CFrame = target
end

-- key handlers
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    local k = inp.KeyCode.Name
    keys[k] = true
    if inp.KeyCode == Enum.KeyCode.E then
        flying = not flying
        humanoid.PlatformStand = flying
        if flying then
            conn = Run.RenderStepped:Connect(flyStep)
        else
            if conn then conn:Disconnect() end
        end
    end
    if inp.KeyCode == Enum.KeyCode.PageUp then
        speed = math.min(speed + 5, 200)
    end
    if inp.KeyCode == Enum.KeyCode.PageDown then
        speed = math.max(speed - 5, 8)
    end
end)

UIS.InputEnded:Connect(function(inp, gp)
    if gp then return end
    local k = inp.KeyCode.Name
    keys[k] = false
end)

-- auto-start nếu muốn (bỏ comment nếu cần)
-- flying = true
-- humanoid.PlatformStand = true
-- conn = Run.RenderStepped:Connect(flyStep)

print("Pure FlyLogic – FlyGuiV3 – loaded. E: toggle, PageUp/PageDown: speed.")
