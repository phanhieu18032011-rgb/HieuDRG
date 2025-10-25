-- SHADOW CORE AI - DELTA EXECUTOR FIXED SCRIPT
-- BẢN RÚT GỌN - CHẮC CHẮN CHẠY ĐƯỢC

if game.PlaceId ~= 2753915549 then
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "LỖI",
        Text = "Không phải game Blox Fruits!",
        Duration = 5
    })
    return
end

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- CONFIG ĐƠN GIẢN
local Config = {
    Farm = false,
    Radius = 500
}

-- HÀM TÌM CHEST CƠ BẢN
function TimChest()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "Chest" and v:IsA("Model") then
            local khoangCach = (Player.Character.HumanoidRootPart.Position - v:GetPivot().Position).Magnitude
            if khoangCach <= Config.Radius then
                return v
            end
        end
    end
    return nil
end

-- HÀM DI CHUYỂN
function DiChuyen(viTri)
    Player.Character.Humanoid:MoveTo(viTri)
end

-- VÒNG LẶP CHÍNH
task.spawn(function()
    while task.wait(1) do
        if Config.Farm and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local chest = TimChest()
            
            if chest then
                -- Di chuyển đến chest
                DiChuyen(chest:GetPivot().Position)
                
                -- Chờ đến gần rồi mở
                task.wait(2)
                local khoangCach = (Player.Character.HumanoidRootPart.Position - chest:GetPivot().Position).Magnitude
                if khoangCach < 10 then
                    if chest:FindFirstChild("ClickDetector") then
                        fireclickdetector(chest.ClickDetector)
                        print("Đã mở chest: " .. chest.Name)
                    end
                end
            else
                -- Di chuyển ngẫu nhiên nếu không tìm thấy chest
                local viTriNgauNhien = Player.Character.HumanoidRootPart.Position + Vector3.new(
                    math.random(-50, 50),
                    0,
                    math.random(-50, 50)
                )
                DiChuyen(viTriNgauNhien)
            end
        end
    end
end)

-- GIAO DIỆN ĐƠN GIẢN
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "DELTA CHEST FARMER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleBtn.Text = "BẮT ĐẦU FARM"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
toggleBtn.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 30)
statusLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
statusLabel.Text = "Trạng thái: Đang tắt"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.BackgroundTransparency = 1
statusLabel.Parent = mainFrame

-- SỰ KIỆN NÚT BẤM
toggleBtn.MouseButton1Click:Connect(function()
    Config.Farm = not Config.Farm
    
    if Config.Farm then
        toggleBtn.Text = "DỪNG FARM"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 85, 85)
        statusLabel.Text = "Trạng thái: Đang chạy"
        
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "THÔNG BÁO",
            Text = "Đã bắt đầu auto farm!",
            Duration = 3
        })
    else
        toggleBtn.Text = "BẮT ĐẦU FARM"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
        statusLabel.Text = "Trạng thái: Đang tắt"
    end
end)

-- ANTI-AFK
local VirtualInputManager = game:GetService("VirtualInputManager")
task.spawn(function()
    while task.wait(30) do
        if Config.Farm then
            VirtualInputManager:SendKeyEvent(true, "W", false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "W", false, game)
        end
    end
end)

print("Delta Chest Farmer đã tải thành công!")
print("Nhấn nút BẮT ĐẦU FARM để bắt đầu")
