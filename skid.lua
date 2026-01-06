--[[
    SHΔDØW CORE V99 - PROJECT FIRE
    CREDITS: HieuDRG
    HUB NAME: DRGTeam Hub (Redz Edition)
    STATUS: INTEGRATED UI & FUNCTIONS
]]

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/UiRedzV5/refs/heads/main/DemoUi.lua"))();

-- Khởi tạo Cửa sổ chính
local Windows = redzlib:MakeWindow({
    Title = "DRGTeam Hub",
    SubTitle = "Owner: HieuDRG",
    SaveFolder = "DRGTeam_Config.lua"
})

-- Nút thu nhỏ giao diện
Windows:AddMinimizeButton({
    Button = { Image = "rbxassetid://131151731604309", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 6) }
})

-- Tạo Tab chức năng
local MainTab = Windows:MakeTab({"Main", "rbxassetid://4483345998"})

-- Biến logic
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local plr = Players.LocalPlayer

local flying = false
local noclip = false
local speed = 50
local flyConn
local noclipConn

-- Tính năng Fly
MainTab:AddToggle({
    Name = "Bật Bay (Fly)",
    Description = "Nhấn Space để lên, Ctrl để xuống",
    Default = false,
    Callback = function(Value)
        flying = Value
        if flying then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")
            
            if not hrp or not hum then return end
            
            flyConn = RunService.Heartbeat:Connect(function(dt)
                if not flying or not hrp.Parent then 
                    if flyConn then flyConn:Disconnect() end
                    return 
                end
                
                hum.PlatformStand = true
                local moveDir = hum.MoveDirection
                local newCF = hrp.CFrame
                
                -- Di chuyển theo WASD/Joystick
                if moveDir.Magnitude > 0 then
                    newCF = newCF + (moveDir * speed * dt)
                end
                
                -- Bay lên / Xuống
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    newCF = newCF + Vector3.new(0, speed * dt, 0)
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    newCF = newCF + Vector3.new(0, -speed * dt, 0)
                end
                
                -- Cập nhật CFrame
                hrp.CFrame = CFrame.new(newCF.Position, newCF.Position + workspace.CurrentCamera.CFrame.LookVector)
                hrp.Velocity = Vector3.zero
            end)
        else
            if flyConn then flyConn:Disconnect() end
            pcall(function() plr.Character.Humanoid.PlatformStand = false end)
        end
    end
})

-- Tính năng Noclip
MainTab:AddToggle({
    Name = "Đi xuyên tường (Noclip)",
    Description = "Cho phép đi xuyên qua mọi vật thể",
    Default = false,
    Callback = function(Value)
        noclip = Value
        if noclip then
            noclipConn = RunService.Stepped:Connect(function()
                if not noclip then 
                    if noclipConn then noclipConn:Disconnect() end
                    return 
                end
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

-- Điều chỉnh tốc độ
MainTab:AddSlider({
    Name = "Tốc độ bay",
    Min = 10,
    Max = 500,
    Default = 50,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        speed = Value
    end
})

-- Thông báo hệ thống
redzlib:SetTheme("Dark") -- Thiết lập tông màu tối cho Shadow Mode
print("DRGTeam Hub: Redz Edition Loaded Successfully. Owner: HieuDRG")
