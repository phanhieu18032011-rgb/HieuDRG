-- HIEUDRG FLY - SIMPLE WORKING VERSION
-- COPY & PASTE - CHẠY NGAY LẬP TỨC

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- TẠO UI ĐƠN GIẢN NHẤT
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HieuDRGFlyHub"
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
title.Text = "🛸 HIEUDRG FLY HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- FLY TOGGLE BUTTON
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.8, 0, 0, 40)
flyButton.Position = UDim2.new(0.1, 0, 0.3, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
flyButton.Text = "🛸 BẬT FLY"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 14
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = flyButton

-- SPEED DISPLAY
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.8, 0, 0, 25)
speedLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Tốc độ: 50"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- SPEED CONTROLS
local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.35, 0, 0, 30)
speedUp.Position = UDim2.new(0.1, 0, 0.75, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
speedUp.Text = "TĂNG TỐC"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.TextSize = 12
speedUp.Parent = mainFrame

local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.35, 0, 0, 30)
speedDown.Position = UDim2.new(0.55, 0, 0.75, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(225, 65, 65)
speedDown.Text = "GIẢM TỐC"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextSize = 12
speedDown.Parent = mainFrame

-- FLY SYSTEM
local flyEnabled = false
local bodyVelocity
local bodyGyro
local currentSpeed = 50

-- BẬT/TẮT FLY
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        flyButton.Text = "🛸 TẮT FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(170, 85, 85)
        startFlying()
    else
        flyButton.Text = "🛸 BẬT FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
        stopFlying()
    end
end)

-- ĐIỀU CHỈNH TỐC ĐỘ
speedUp.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed + 10
    if currentSpeed > 200 then currentSpeed = 200 end
    speedLabel.Text = "Tốc độ: " .. currentSpeed
end)

speedDown.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed - 10
    if currentSpeed < 20 then currentSpeed = 20 end
    speedLabel.Text = "Tốc độ: " .. currentSpeed
end)

-- HÀM BẮT ĐẦU BAY
function startFlying()
    local character = Player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Tạo BodyVelocity và BodyGyro
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVelocity.Parent = humanoidRootPart
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.P = 1000
    bodyGyro.D = 50
    bodyGyro.Parent = humanoidRootPart
    
    -- KẾT NỐI VÒNG LẶP BAY
    RunService.Heartbeat:Connect(function()
        if not flyEnabled or not bodyVelocity or not bodyGyro then return end
        
        -- Cập nhật hướng theo camera
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        -- Tính hướng di chuyển
        local direction = Vector3.new(0, 0, 0)
        
        -- Di chuyển theo phím
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction = direction + workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction = direction - workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction = direction - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction = direction + workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction = direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            direction = direction + Vector3.new(0, -1, 0)
        end
        
        -- Áp dụng tốc độ
        if direction.Magnitude > 0 then
            bodyVelocity.Velocity = direction.Unit * currentSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- THÔNG BÁO
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HIEUDRG FLY",
        Text = "Fly đã được BẬT!",
        Duration = 3
    })
end

-- HÀM DỪNG BAY
function stopFlying()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    -- THÔNG BÁO
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "HIEUDRG FLY",
        Text = "Fly đã được TẮT!",
        Duration = 3
    })
end

-- KEYBIND: NHẤN F ĐỂ BẬT/TẮT NHANH
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        flyEnabled = not flyEnabled
        
        if flyEnabled then
            flyButton.Text = "🛸 TẮT FLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(170, 85, 85)
            startFlying()
        else
            flyButton.Text = "🛸 BẬT FLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
            stopFlying()
        end
    end
end)

-- THÔNG BÁO KHI LOAD XONG
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "HIEUDRG FLY HUB",
    Text = "Đã load thành công! Nhấn F để bay",
    Duration = 5
})

print("🎯 HIEUDRG FLY HUB LOADED SUCCESSFULLY!")
print("🛸 Controls: W/A/S/D + Space/Shift")
print("🎮 Press F to toggle fly quickly")
