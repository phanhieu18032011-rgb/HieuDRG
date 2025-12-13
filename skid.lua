--[[
    Tập lệnh GUI bay (Fly GUI Script)
    Được thiết kế để chạy trên các trình thực thi Roblox (như Delta).
    Đã sửa lỗi hỗ trợ di chuyển ngang trên thiết bị di động (joystick ảo).
    Thêm nút LÊN/XUỐNG cho điều khiển độ cao trên mobile.
    Cảnh báo: Việc sử dụng script này có thể vi phạm Điều khoản dịch vụ của Roblox.
--]]

-- Khai báo các biến Firebase toàn cục (Không cần thiết nhưng giữ lại)
local appId = typeof(__app_id) ~= 'undefined' and __app_id or 'default-app-id'

-- Dịch vụ
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Thiết lập người chơi hiện tại
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Cấu hình
local IsFlying = false
local FlySpeed = 30 -- Tốc độ bay
local LastPosition = RootPart.CFrame -- Lưu vị trí cuối cùng trước khi bay

-- === [ Thiết lập GUI Mới ] ===

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Tăng kích thước khung để chứa các nút Lên/Xuống
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 145) 
MainFrame.Position = UDim2.new(0.05, 0, 0.1, 0) -- Đặt ở góc trên bên trái
MainFrame.BackgroundColor3 = Color3.fromRGB(27, 29, 33)
MainFrame.BorderColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 1
MainFrame.Parent = ScreenGui

-- Thêm góc bo tròn
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Thiết lập Shadow (Bóng)
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(13, 145, 255)
UIStroke.Transparency = 0.5
UIStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 28)
TitleLabel.Text = "✈️ FLY SCRIPT - Delta"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.BackgroundColor3 = Color3.fromRGB(40, 44, 52) 
TitleLabel.Parent = MainFrame

local InstructionLabel = Instance.new("TextLabel")
InstructionLabel.Size = UDim2.new(1, 0, 0, 15)
InstructionLabel.Position = UDim2.new(0, 0, 0, 30)
InstructionLabel.Text = "PC: WASD/Space/Ctrl | MOBILE: Joystick/Buttons"
InstructionLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
InstructionLabel.Font = Enum.Font.SourceSans
InstructionLabel.TextSize = 12
InstructionLabel.BackgroundTransparency = 1
InstructionLabel.Parent = MainFrame


local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.85, 0, 0, 35)
FlyButton.Position = UDim2.new(0.5, -93.5, 0, 50)
FlyButton.Text = "BẬT BAY (Disabled)"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.SourceSansBold
FlyButton.TextSize = 16
FlyButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Màu xanh lá cây (Tắt)
FlyButton.Parent = MainFrame

-- Thêm góc bo tròn cho nút chính
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = FlyButton

-- Container cho nút LÊN/XUỐNG
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 0, 35)
ButtonContainer.Position = UDim2.new(0, 0, 0, 95)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainFrame

local UpButton = Instance.new("TextButton")
UpButton.Name = "UpButton"
UpButton.Size = UDim2.new(0.4, 0, 1, 0)
UpButton.Position = UDim2.new(0.05, 0, 0, 0)
UpButton.Text = "LÊN (↑)"
UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpButton.Font = Enum.Font.SourceSansBold
UpButton.TextSize = 15
UpButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219) -- Màu xanh dương
UpButton.Parent = ButtonContainer

local DownButton = Instance.new("TextButton")
DownButton.Name = "DownButton"
DownButton.Size = UDim2.new(0.4, 0, 1, 0)
DownButton.Position = UDim2.new(0.55, 0, 0, 0)
DownButton.Text = "XUỐNG (↓)"
DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DownButton.Font = Enum.Font.SourceSansBold
DownButton.TextSize = 15
DownButton.BackgroundColor3 = Color3.fromRGB(155, 89, 182) -- Màu tím
DownButton.Parent = ButtonContainer

-- Thêm góc bo tròn cho nút LÊN/XUỐNG
local UpCorner = Instance.new("UICorner")
UpCorner.CornerRadius = UDim.new(0, 6)
UpCorner.Parent = UpButton

local DownCorner = Instance.new("UICorner")
DownCorner.CornerRadius = UDim.new(0, 6)
DownCorner.Parent = DownButton

-- === [ Logic Bay đã sửa lỗi và thêm hỗ trợ Mobile ] ===

local function ToggleFly(state)
    IsFlying = state
    
    -- Vô hiệu hóa trọng lực và ngăn di chuyển mặc định
    Humanoid.PlatformStand = state 
    Humanoid.WalkSpeed = state and 0 or 16 -- Tắt tốc độ đi bộ khi bay

    if IsFlying then
        LastPosition = RootPart.CFrame -- Lưu vị trí khi bắt đầu bay
        
        FlyButton.Text = "TẮT BAY (Enabled)"
        FlyButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60) -- Màu đỏ (Bật)
    else
        RootPart.CFrame = LastPosition -- Quay về vị trí cuối cùng khi tắt
        
        FlyButton.Text = "BẬT BAY (Disabled)"
        FlyButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Màu xanh lá cây (Tắt)
    end
end

FlyButton.MouseButton1Click:Connect(function()
    ToggleFly(not IsFlying)
end)

-- Biến lưu trữ hướng di chuyển (Dùng chung cho PC Space/Ctrl và Mobile Up/Down)
local MovementVector = Vector3.new(0, 0, 0)

-- Xử lý đầu vào PC (WASD và Space/Ctrl)
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Vẫn xử lý input cho PC, bỏ qua nếu đang tương tác với GUI
    if gameProcessedEvent then return end
    
    local key = input.KeyCode
    if key == Enum.KeyCode.W then MovementVector = MovementVector + Vector3.new(0, 0, -1) end
    if key == Enum.KeyCode.S then MovementVector = MovementVector + Vector3.new(0, 0, 1) end
    if key == Enum.KeyCode.A then MovementVector = MovementVector + Vector3.new(-1, 0, 0) end
    if key == Enum.KeyCode.D then MovementVector = MovementVector + Vector3.new(1, 0, 0) end
    if key == Enum.KeyCode.Space then MovementVector = MovementVector + Vector3.new(0, 1, 0) end
    if key == Enum.KeyCode.LeftControl then MovementVector = MovementVector + Vector3.new(0, -1, 0) end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    local key = input.KeyCode
    if key == Enum.KeyCode.W then MovementVector = MovementVector - Vector3.new(0, 0, -1) end
    if key == Enum.KeyCode.S then MovementVector = MovementVector - Vector3.new(0, 0, 1) end
    if key == Enum.KeyCode.A then MovementVector = MovementVector - Vector3.new(-1, 0, 0) end
    if key == Enum.KeyCode.D then MovementVector = MovementVector - Vector3.new(1, 0, 0) end
    if key == Enum.KeyCode.Space then MovementVector = MovementVector - Vector3.new(0, 1, 0) end
    if key == Enum.KeyCode.LeftControl then MovementVector = MovementVector - Vector3.new(0, -1, 0) end
end)


-- Mobile Up/Down Control Logic (Touch/Click)
local function handleVerticalInput(isDown, direction)
    if IsFlying then
        if isDown then
            MovementVector = MovementVector + Vector3.new(0, direction, 0)
        else
            MovementVector = MovementVector - Vector3.new(0, direction, 0)
        end
    end
end

UpButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        handleVerticalInput(true, 1)
    end
end)
UpButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        handleVerticalInput(false, 1)
    end
end)

DownButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        handleVerticalInput(true, -1)
    end
end)
DownButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        handleVerticalInput(false, -1)
    end
end)


-- Vòng lặp bay (Chạy trên mỗi khung hình)
RunService.Stepped:Connect(function(_, deltaTime)
    if IsFlying and RootPart and RootPart.Parent and Humanoid.Health > 0 then
        -- Vô hiệu hóa vận tốc và trọng lực
        RootPart.Velocity = Vector3.new(0, 0, 0)
        RootPart.RotationalVelocity = Vector3.new(0, 0, 0)
        Humanoid.Sit = false

        -- Kiểm tra xem có input di chuyển nào không (PC WASD, Mobile Joystick, hoặc Mobile Buttons)
        local hasHorizontalInput = Vector2.new(MovementVector.X, MovementVector.Z).Magnitude > 0 or Humanoid.MoveDirection.Magnitude > 0
        local hasVerticalInput = MovementVector.Y ~= 0

        if hasHorizontalInput or hasVerticalInput then
            local CameraCFrame = workspace.CurrentCamera.CFrame
            local DirectionVector = Vector3.new(0, 0, 0)

            -- 1. Xử lý di chuyển ngang (Horizontal Movement)
            if MovementVector.X ~= 0 or MovementVector.Z ~= 0 then
                -- Input PC (WASD)
                DirectionVector = DirectionVector + (CameraCFrame.RightVector * MovementVector.X)
                DirectionVector = DirectionVector + (CameraCFrame.LookVector * -MovementVector.Z) 
            elseif Humanoid.MoveDirection.Magnitude > 0 then
                -- Input Mobile (Joystick) - Đây là phần sửa lỗi cho mobile
                DirectionVector = DirectionVector + Humanoid.MoveDirection
            end

            -- Chiếu vector ngang xuống mặt phẳng XZ (loại bỏ độ nghiêng của camera khi bay)
            DirectionVector = DirectionVector * Vector3.new(1, 0, 1)

            -- 2. Xử lý di chuyển dọc (Vertical Movement)
            DirectionVector = DirectionVector + Vector3.new(0, MovementVector.Y, 0) -- Dùng chung cho PC Space/Ctrl và Mobile Buttons

            
            if DirectionVector.Magnitude > 0 then
                local NewVelocity = DirectionVector.unit * FlySpeed * deltaTime
                RootPart.CFrame = RootPart.CFrame + NewVelocity
                
                LastPosition = RootPart.CFrame
            end
        end
    end
end)

-- Đảm bảo HumanoidRootPart luôn không bị neo
Character.ChildAdded:Connect(function(child)
    if child == RootPart then
        RootPart.Anchored = false
    end
end)

if RootPart then
    RootPart.Anchored = false
end
