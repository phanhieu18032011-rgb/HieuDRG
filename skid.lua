-- =============================================
-- HIEUDRG FLY HUB - MOBILE SUPPORT
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
local GuiService = game:GetService("GuiService")

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
local menuVisible = true

-- Kiểm tra thiết bị
local isMobile = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled)
local isDesktop = UserInputService.MouseEnabled

-- =============================================
-- BƯỚC 1: TẠO GIAO DIỆN NGƯỜI DÙNG (UI)
-- =============================================

-- Tạo ScreenGui (cửa sổ giao diện)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HieuDRGFlyHub"
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game.CoreGui

-- Tạo khung chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 280)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Bo góc cho khung
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

-- =============================================
-- BƯỚC 2: TẠO THANH TIÊU ĐỀ VÀ NÚT ĐÓNG
-- =============================================

-- Tạo thanh tiêu đề
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Bo góc cho thanh tiêu đề
local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 12)
titleBarCorner.Parent = titleBar

-- Tiêu đề
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🛸 HIEUDRG FLY HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Nút ẩn/hiện menu
local toggleMenuButton = Instance.new("TextButton")
toggleMenuButton.Size = UDim2.new(0, 35, 0, 35)
toggleMenuButton.Position = UDim2.new(1, -45, 0.5, -17.5)
toggleMenuButton.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
toggleMenuButton.Text = "─"
toggleMenuButton.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleMenuButton.TextSize = 18
toggleMenuButton.Font = Enum.Font.GothamBold
toggleMenuButton.Parent = titleBar

-- Bo góc nút toggle
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleMenuButton

-- =============================================
-- BƯỚC 3: NÚT TOGGLE MENU CHO MOBILE
-- =============================================

-- Nút hiện menu khi đang ẩn (chỉ hiện trên mobile)
local mobileToggleButton = Instance.new("TextButton")
mobileToggleButton.Size = UDim2.new(0, 60, 0, 60)
mobileToggleButton.Position = UDim2.new(1, -70, 0.5, -30)
mobileToggleButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
mobileToggleButton.Text = "📱"
mobileToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mobileToggleButton.TextSize = 20
mobileToggleButton.Font = Enum.Font.GothamBold
mobileToggleButton.Visible = false -- Ẩn ban đầu
mobileToggleButton.ZIndex = 10 -- Luôn trên cùng
mobileToggleButton.Parent = screenGui

-- Bo góc nút mobile
local mobileCorner = Instance.new("UICorner")
mobileCorner.CornerRadius = UDim.new(0, 30)
mobileCorner.Parent = mobileToggleButton

-- =============================================
-- BƯỚC 4: TẠO NÚT BẬT/TẮT FLY
-- =============================================

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.85, 0, 0, 50)
flyButton.Position = UDim2.new(0.075, 0, 0.2, 45)
flyButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
flyButton.Text = "🛸 BẬT FLY"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextSize = 16
flyButton.Font = Enum.Font.GothamBold
flyButton.Parent = mainFrame

-- Bo góc nút
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = flyButton

-- =============================================
-- BƯỚC 5: HIỂN THỊ VÀ ĐIỀU CHỈNH TỐC ĐỘ
-- =============================================

-- Hiển thị tốc độ
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.8, 0, 0, 25)
speedLabel.Position = UDim2.new(0.1, 0, 0.45, 45)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "🎯 Tốc độ: 50"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- Nút tăng tốc
local speedUp = Instance.new("TextButton")
speedUp.Size = UDim2.new(0.35, 0, 0, 35)
speedUp.Position = UDim2.new(0.1, 0, 0.6, 45)
speedUp.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
speedUp.Text = "📈 TĂNG"
speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
speedUp.TextSize = 12
speedUp.Parent = mainFrame

-- Nút giảm tốc
local speedDown = Instance.new("TextButton")
speedDown.Size = UDim2.new(0.35, 0, 0, 35)
speedDown.Position = UDim2.new(0.55, 0, 0.6, 45)
speedDown.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
speedDown.Text = "📉 GIẢM"
speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
speedDown.TextSize = 12
speedDown.Parent = mainFrame

-- Bo góc cho nút tốc độ
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedUp
speedCorner:Clone().Parent = speedDown

-- =============================================
-- BƯỚC 6: HƯỚNG DẪN ĐIỀU KHIỂN
-- =============================================

local controlsLabel = Instance.new("TextLabel")
controlsLabel.Size = UDim2.new(0.9, 0, 0, 60)
controlsLabel.Position = UDim2.new(0.05, 0, 0.75, 45)
controlsLabel.BackgroundTransparency = 1
controlsLabel.Text = "🎮 W/A/S/D + Space/Shift\n🎯 F: Bật/tắt Fly\n🎯 H: Ẩn/hiện Menu\n📱 Chạm icon để mở menu"
controlsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
controlsLabel.TextSize = 11
controlsLabel.Font = Enum.Font.Gotham
controlsLabel.TextWrapped = true
controlsLabel.Parent = mainFrame

-- =============================================
-- BƯỚC 7: HỆ THỐNG FLY
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
    bodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
    bodyVelocity.Parent = humanoidRootPart
    
    -- Tạo BodyGyro để ổn định hướng
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
    bodyGyro.P = 1000
    bodyGyro.D = 50
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
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    -- Thông báo
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🛸 HIEUDRG FLY",
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
        Title = "🛸 HIEUDRG FLY",
        Text = "Fly đã được TẮT!",
        Duration = 3
    })
end

-- =============================================
-- BƯỚC 8: HỆ THỐNG ẨN/HIỆN MENU CHO MOBILE
-- =============================================

-- Hàm ẩn menu
function hideMenu()
    mainFrame.Visible = false
    menuVisible = false
    toggleMenuButton.Text = "＋"
    
    -- Hiện nút mobile toggle nếu là mobile
    if isMobile then
        mobileToggleButton.Visible = true
    end
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎯 HIEUDRG MENU",
        Text = isMobile and "Menu đã ẩn - Chạm icon để hiện" or "Menu đã ẩn - Nhấn H để hiện",
        Duration = 3
    })
end

-- Hàm hiện menu
function showMenu()
    mainFrame.Visible = true
    menuVisible = true
    toggleMenuButton.Text = "─"
    
    -- Ẩn nút mobile toggle
    mobileToggleButton.Visible = false
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🎯 HIEUDRG MENU",
        Text = isMobile and "Menu đã hiện - Chạm icon để ẩn" or "Menu đã hiện - Nhấn H để ẩn",
        Duration = 3
    })
end

-- Hàm toggle menu
function toggleMenu()
    if menuVisible then
        hideMenu()
    else
        showMenu()
    end
end

-- =============================================
-- BƯỚC 9: KẾT NỐI SỰ KIỆN NÚT
-- =============================================

-- Sự kiện click nút bật/tắt fly
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    
    if flyEnabled then
        flyButton.Text = "🛸 TẮT FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
        startFlying()
    else
        flyButton.Text = "🛸 BẬT FLY"
        flyButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
        stopFlying()
    end
end)

-- Sự kiện tăng tốc độ
speedUp.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed + 10
    if currentSpeed > 200 then 
        currentSpeed = 200
    end
    speedLabel.Text = "🎯 Tốc độ: " .. currentSpeed
end)

-- Sự kiện giảm tốc độ
speedDown.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed - 10
    if currentSpeed < 20 then 
        currentSpeed = 20
    end
    speedLabel.Text = "🎯 Tốc độ: " .. currentSpeed
end)

-- Sự kiện nút toggle menu
toggleMenuButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

-- Sự kiện nút mobile toggle
mobileToggleButton.MouseButton1Click:Connect(function()
    toggleMenu()
end)

-- =============================================
-- BƯỚC 10: PHÍM TẮT (KEYBIND) VÀ TOUCH
-- =============================================

-- Sự kiện nhấn phím (cho desktop)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Bỏ qua nếu đang trong game (chat, menu, etc.)
    if gameProcessed then return end
    
    -- Phím F: Bật/tắt fly
    if input.KeyCode == Enum.KeyCode.F then
        flyEnabled = not flyEnabled
        
        if flyEnabled then
            flyButton.Text = "🛸 TẮT FLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
            startFlying()
        else
            flyButton.Text = "🛸 BẬT FLY"
            flyButton.BackgroundColor3 = Color3.fromRGB(65, 105, 225)
            stopFlying()
        end
    
    -- Phím H: Ẩn/hiện menu
    elseif input.KeyCode == Enum.KeyCode.H then
        toggleMenu()
    
    -- Phím RightShift: Ẩn/hiện menu (alternative)
    elseif input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- =============================================
-- BƯỚC 11: TỰ ĐỘNG ĐIỀU CHỈNH CHO MOBILE
-- =============================================

-- Điều chỉnh kích thước cho mobile
if isMobile then
    mainFrame.Size = UDim2.new(0, 280, 0, 320)
    flyButton.Size = UDim2.new(0.9, 0, 0, 60)
    speedUp.Size = UDim2.new(0.4, 0, 0, 40)
    speedDown.Size = UDim2.new(0.4, 0, 0, 40)
    controlsLabel.Text = "🎮 Dùng nút để điều khiển\n🎯 Fly: Bật/tắt bay\n📱 Chạm icon để ẩn/hiện menu"
    
    -- Đặt vị trí nút mobile
    mobileToggleButton.Position = UDim2.new(0, 20, 0, 20)
end

-- =============================================
-- BƯỚC 12: THÔNG BÁO HOÀN TẤT
-- =============================================

-- Thông báo khi load xong
local deviceType = isMobile and "Mobile 📱" or "Desktop 🖥️"
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "🎯 HIEUDRG FLY HUB - " .. deviceType,
    Text = isMobile and "Đã load! Chạm icon để điều khiển" or "Đã load! F: Fly | H: Menu",
    Duration = 6
})

-- In ra console
print("====================================")
print("🛸 HIEUDRG FLY HUB LOADED SUCCESS!")
print("📱 Device: " .. (isMobile and "Mobile" or "Desktop"))
print("🎮 Controls: W/A/S/D + Space/Shift")
print("🎯 F: Toggle Fly | H: Toggle Menu")
print("📱 Mobile: Tap icon to toggle menu")
print("📊 Current Speed: " .. currentSpeed)
print("====================================")

-- Kết thúc script
return "HieuDRG Fly Hub - Mobile Ready! 🚀"
