-- =============================================
-- HIEUDRG FLY HUB - WORKING VERSION
-- COPY TOÀN BỘ CODE NÀY - KHÔNG SỬA GÌ CẢ
-- =============================================

-- Kiểm tra xem script có chạy trong Roblox không
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Lấy các service cần thiết
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Lấy người chơi hiện tại
local Player = Players.LocalPlayer

-- Đợi nhân vật spawn
if not Player.Character then
    Player.CharacterAdded:Wait()
end

-- Biến cho hệ thống fly
local flyEnabled = false
local bodyVelocity = nil
local bodyGyro = nil
local currentSpeed = 50

-- =============================================
-- BƯỚC 1: TẠO GIAO DIỆN NGƯỜI DÙNG (UI)
-- =============================================

-- Tạo ScreenGui (cửa sổ giao diện)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HieuDRGFlyHub"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game.CoreGui -- Hiển thị lên màn hình

-- Tạo khung chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 220) -- Rộng 280, cao 220 pixel
mainFrame.Position = UDim2.new(0, 20, 0, 20) -- Vị trí góc trái
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Màu nền tối
mainFrame.BorderSizePixel = 0 -- Không viền
mainFrame.Parent = screenGui

-- Bo góc cho khung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- Tạo tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45) -- Chiếm full chiều rộng, cao 45
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Màu hồng
title.Text = "HIEUDRG FLY HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255) -- Chữ trắng
title.TextSize = 18 -- Cỡ chữ
title.Font = Enum.Font.GothamBold -- Font chữ
title.Parent = mainFrame

-- Bo góc tiêu đề
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- =============================================
-- BƯỚC 2: TẠO NÚT BẬT/TẮT FLY
-- =============================================

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.85, 0, 0, 45) -- 85% chiều rộng, cao 45
flyButton.Position = UDim2.new(0.075, 0, 0.25, 0) -- Cách lề 7.5%
flyButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225) -- Màu xanh
flyButton.Text = " BẬT FLY"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = mainFrame

-- Bo góc nút
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = flyButton

-- =============================================
-- BƯỚC 3: HIỂN THỊ TỐC ĐỘ
-- =============================================

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.8, 0, 0, 25)
speedLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
speedLabel.BackgroundTransparency = 1 -- Trong suốt
speedLabel.Text = " Tốc độ: 50"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- =============================================
-- BƯỚC 4: NÚT ĐIỀU CHỈNH TỐC ĐỘ
-- =============================================

-- Nút tăng tốc
local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.35, 0, 0, 32)
speedUp.Position = UDim2.new(0.1, 0, 0.7, 0)
speedUp.BackgroundColor3 = Color3.fromRGB(85, 170, 85) -- Xanh lá
speedUp.Text = "TĂNG TỐC"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.TextSize = 12
speedUp.Parent = mainFrame

-- Nút giảm tốc
local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.35, 0, 0, 32)
speedDown.Position = UDim2.new(0.55, 0, 0.7, 0)
speedDown.BackgroundColor3 = Color3.fromRGB(220, 80, 80) -- Đỏ
speedDown.Text = "GIẢM TỐC"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextSize = 12
speedDown.Parent = mainFrame

-- Bo góc cho nút tốc độ
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedUp
speedCorner:Clone().Parent = speedDown

-- =============================================
-- BƯỚC 5: HƯỚNG DẪN ĐIỀU KHIỂN
-- =============================================

local controlsLabel = Instance.new("TextLabel")
controlsLabel.Size = UDim2.new(0.9, 0, 0, 40)
controlsLabel.Position = UDim2.new(0.05, 0, 0.85, 0)
controlsLabel.BackgroundTransparency = 1
controlsLabel.Text = " W/A/S/D + Space/Shift\n Nhấn F để bật/tắt nhanh"
controlsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
controlsLabel.TextSize = 11
controlsLabel.Font = Enum.Font.Gotham
controlsLabel.TextWrapped = true -- Tự động xuống dòng
controlsLabel.Parent = mainFrame

-- =============================================
-- BƯỚC 6: HỆ THỐNG FLY
-- =============================================

-- Hàm bật fly
function startFlying()
    local character = Player.Character
    if not character then
        warn("Không tìm thấy nhân vật!")
        return
    end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        warn("Không tìm thấy HumanoidRootPart!")
        return
    end
    
    -- Tạo BodyVelocity để di chuyển
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000) -- Lực tối đa
    bodyVelocity.Parent = humanoidRootPart
    
    -- Tạo BodyGyro để ổn định hướng
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.P = 1000 -- Độ nhạy
    bodyGyro.D = 50   -- Giảm dao động
    bodyGyro.Parent = humanoidRootPart
    
    -- Kết nối sự kiện bay mỗi khung hình
    RunService.Heartbeat:Connect(function()
        if not flyEnabled or not bodyVelocity or not bodyGyro then 
            return 
        end
        
        -- Luôn giữ hướng theo camera
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        
        -- Tính toán hướng di chuyển
        local direction = Vector3.new(0, 0, 0)
        
        -- Kiểm tra phím và cộng hướng
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
        
        -- Áp dụng tốc độ nếu đang di chuyển
        if direction.Magnitude > 0 then
            bodyVelocity.Velocity = direction.Unit * currentSpeed
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0) -- Dừng nếu không bấm phím
        end
    end)
    
    -- Thông báo
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = " HIEUDRG FLY",
        Text = "Fly đã được BẬT!",
        Duration = 3
    })
end

-- Hàm tắt fly
function stopFlying()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    -- Thông báo
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = " HIEUDRG FLY",
        Text = "Fly đã được TẮT!",
        Duration = 3
    })
end

-- =============================================
-- BƯỚC 7: KẾT NỐI SỰ KIỆN NÚT
-- =============================================

-- Sự kiện click nút bật/tắt fly
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled -- Đảo trạng thái
    
    if flyEnabled then
        flyButton.Text = " TẮT FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80) -- Đổi màu đỏ
        startFlying()
    else
        flyButton.Text = " BẬT FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225) -- Đổi màu xanh
        stopFlying()
    end
end)

-- Sự kiện tăng tốc độ
speedUp.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed + 10
    if currentSpeed > 200 then 
        currentSpeed = 200 -- Giới hạn tối đa
    end
    speedLabel.Text = " Tốc độ: " .. currentSpeed
end)

-- Sự kiện giảm tốc độ
speedDown.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed - 10
    if currentSpeed < 20 then 
        currentSpeed = 20 -- Giới hạn tối thiểu
    end
    speedLabel.Text = " Tốc độ: " .. currentSpeed
end)

-- =============================================
-- BƯỚC 8: PHÍM TẮT (KEYBIND)
-- =============================================

-- Sự kiện nhấn phím
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Bỏ qua nếu đang trong game (chat, menu, etc.)
    if gameProcessed then return end
    
    -- Kiểm tra nếu nhấn phím F
    if input.KeyCode == Enum.KeyCode.F then
        flyEnabled = not flyEnabled
        
        if flyEnabled then
            flyButton.Text = " TẮT FLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
            startFlying()
        else
            flyButton.Text = " BẬT FLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
            stopFlying()
        end
    end
end)

-- =============================================
-- BƯỚC 9: THÔNG BÁO HOÀN TẤT
-- =============================================

-- Thông báo khi load xong
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = " HIEUDRG FLY HUB",
    Text = "Đã load thành công!",
    Duration = 6
})

-- In ra console
print("====================================")
print(" HIEUDRG FLY HUB LOADED SUCCESS!")
print(" Controls: W/A/S/D + Space/Shift")
print(" Press F to toggle fly quickly")
print(" Current Speed: " .. currentSpeed)
print("====================================")

-- Kết thúc script
return "HieuDRG Fly Hub - Ready to Fly! "
