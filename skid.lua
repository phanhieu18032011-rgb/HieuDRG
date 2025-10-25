-- SHΔDØW CORE Blox Fruits Lever Fram Script
-- Designed for maximum efficiency and stealth

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Tạo GUI
local SHΔDØW_UI = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local LeverToggle = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

SHΔDØW_UI.Name = "SHΔDØW_UI"
SHΔDØW_UI.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = SHΔDØW_UI
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "SHΔDØW LEVER FRAM v1.0"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 14

LeverToggle.Name = "LeverToggle"
LeverToggle.Parent = MainFrame
LeverToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LeverToggle.Position = UDim2.new(0.1, 0, 0.3, 0)
LeverToggle.Size = UDim2.new(0.8, 0, 0, 40)
LeverToggle.Font = Enum.Font.Gotham
LeverToggle.Text = "START FRAM LEVER"
LeverToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
LeverToggle.TextSize = 14

Status.Name = "Status"
Status.Parent = MainFrame
Status.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Status.Position = UDim2.new(0.1, 0, 0.6, 0)
Status.Size = UDim2.new(0.8, 0, 0, 30)
Status.Font = Enum.Font.Gotham
Status.Text = "Status: OFF"
Status.TextColor3 = Color3.fromRGB(255, 50, 50)
Status.TextSize = 12

-- Biến điều khiển
local LeverFraming = false
local Connection

-- Hàm tìm lever
function FindLever()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("lever") and obj:IsA("Part") then
            return obj
        end
    end
    return nil
end

-- Hàm fram lever chính
function FramLever()
    if LeverFraming then
        local lever = FindLever()
        if lever then
            -- Di chuyển đến lever
            Player.Character:SetPrimaryPartCFrame(lever.CFrame + Vector3.new(0, 3, 0))
            
            -- Click lever (giả lập click)
            fireclickdetector(lever:FindFirstChildOfClass("ClickDetector"))
            
            -- Hoặc sử dụng remote (tuỳ phiên bản game)
            local remotes = {
                "LeverRemote",
                "ActivateLever", 
                "LeverEvent"
            }
            
            for _, remoteName in pairs(remotes) do
                local remote = game:GetService("ReplicatedStorage"):FindFirstChild(remoteName)
                if remote then
                    remote:FireServer()
                end
            end
        end
    end
end

-- Toggle hệ thống
LeverToggle.MouseButton1Click:Connect(function()
    LeverFraming = not LeverFraming
    
    if LeverFraming then
        LeverToggle.Text = "STOP FRAM LEVER"
        LeverToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        Status.Text = "Status: FRAMMING LEVER"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Bắt đầu loop
        Connection = game:GetService("RunService").Heartbeat:Connect(FramLever)
        
    else
        LeverToggle.Text = "START FRAM LEVER" 
        LeverToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Status.Text = "Status: OFF"
        Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Ngắt kết nối
        if Connection then
            Connection:Disconnect()
        end
    end
end)

-- Anti-AFMEASURES
local function AntiDetection()
    -- Ẩn script khỏi common detection methods
    if getconnections then
        for _, conn in pairs(getconnections(game:GetService("ScriptContext").Error)) do
            conn:Disable()
        end
    end
end

AntiDetection()

-- Auto-execute nếu tìm thấy lever
spawn(function()
    wait(2)
    if FindLever() then
        Status.Text = "Status: LEVER FOUND - READY"
    else
        Status.Text = "Status: NO LEVER DETECTED"
    end
end)

print("SHΔDØW LEVER FRAM SYSTEM - ACTIVATED")
