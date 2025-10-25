-- HieuDRG FLY Hub - Universal Compact Version
-- Supports both Mobile and PC

local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local ContextActionService = game:GetService("ContextActionService")

-- Settings
getgenv().Fly = false
getgenv().FlySpeed = 50
getgenv().Noclip = false
getgenv().AntiBan = false

-- UI States
local MenuVisible = true
local IsMobile = UserInputService.TouchEnabled

-- RGB Color System
local RGBColors = {
    Color3.fromRGB(255, 0, 0),      -- Red
    Color3.fromRGB(255, 127, 0),    -- Orange
    Color3.fromRGB(255, 255, 0),    -- Yellow
    Color3.fromRGB(0, 255, 0),      -- Green
    Color3.fromRGB(0, 0, 255),      -- Blue
    Color3.fromRGB(75, 0, 130),     -- Indigo
    Color3.fromRGB(148, 0, 211)     -- Violet
}

-- Apply RGB effect
local function ApplyRGBEffect(element)
    local currentIndex = 1
    task.spawn(function()
        while element and element.Parent do
            if element:IsA("TextLabel") or element:IsA("TextButton") then
                element.TextColor3 = RGBColors[currentIndex]
            elseif element:IsA("Frame") then
                element.BackgroundColor3 = RGBColors[currentIndex]
            elseif element:IsA("UIStroke") then
                element.Color = RGBColors[currentIndex]
            end
            currentIndex = currentIndex + 1
            if currentIndex > #RGBColors then currentIndex = 1 end
            task.wait(0.4)
        end
    end
end

-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HieuDRG_FLY_Hub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Adjust sizes based on platform
local ButtonSize = IsMobile and UDim2.new(0, 60, 0, 60) or UDim2.new(0, 45, 0, 45)
local MenuSize = IsMobile and UDim2.new(0, 320, 0, 380) or UDim2.new(0, 280, 0, 320)

-- Toggle Button (Universal)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = ButtonSize
ToggleButton.Position = IsMobile and UDim2.new(0, 20, 0.1, 0) or UDim2.new(0, 15, 0.5, -22.5)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
ToggleButton.BackgroundTransparency = 0.1
ToggleButton.Text = "☰"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = IsMobile and 20 or 16
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.ZIndex = 10
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(100, 100, 150)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleButton

ApplyRGBEffect(ToggleStroke)

-- Compact Main Menu
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = MenuSize
MainFrame.Position = IsMobile and UDim2.new(0.5, -160, 0.5, -190) or UDim2.new(0, 70, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 100)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

ApplyRGBEffect(MainStroke)

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, IsMobile and 45 or 35)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, IsMobile and 200 or 180, 0, IsMobile and 22 or 18)
Title.Position = UDim2.new(0.5, IsMobile and -100 or -90, 0, IsMobile and 10 or 8)
Title.BackgroundTransparency = 1
Title.Text = "HIEUDRG FLY HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = IsMobile and 14 or 12
Title.Font = Enum.Font.GothamBlack
Title.TextStrokeTransparency = 0.7
Title.Parent = Header

ApplyRGBEffect(Title)

-- User Info
local UserLabel = Instance.new("TextLabel")
UserLabel.Name = "UserLabel"
UserLabel.Size = UDim2.new(0, IsMobile and 220 or 200, 0, IsMobile and 14 or 12)
UserLabel.Position = UDim2.new(0.5, IsMobile and -110 or -100, 0, IsMobile and 25 or 20)
UserLabel.BackgroundTransparency = 1
UserLabel.Text = "User: " .. Player.Name
UserLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
UserLabel.TextSize = IsMobile and 10 or 9
UserLabel.Font = Enum.Font.Gotham
UserLabel.Parent = Header

-- Uptime Label
local UptimeLabel = Instance.new("TextLabel")
UptimeLabel.Name = "UptimeLabel"
UptimeLabel.Size = UDim2.new(0, IsMobile and 120 or 100, 0, IsMobile and 12 or 10)
UptimeLabel.Position = UDim2.new(0, 10, 1, IsMobile and -14 or -12)
UptimeLabel.BackgroundTransparency = 1
UptimeLabel.Text = "00:00:00"
UptimeLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
UptimeLabel.TextSize = IsMobile and 9 or 8
UptimeLabel.Font = Enum.Font.Gotham
UptimeLabel.Parent = Header

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18)
CloseButton.Position = UDim2.new(1, IsMobile and -27 or -23, 0, IsMobile and 10 or 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BackgroundTransparency = 0.3
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.TextSize = IsMobile and 12 or 10
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, IsMobile and -65 or -55)
ContentFrame.Position = UDim2.new(0, 10, 0, IsMobile and 55 or 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Scrolling Frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = IsMobile and 4 : 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
ScrollingFrame.Parent = ContentFrame

-- UIListLayout
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, IsMobile and 8 : 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- Create compact toggle button
local function CreateCompactToggle(text, layoutOrder)
    local buttonHeight = IsMobile and 38 or 32
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "Frame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, buttonHeight)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleFrame.BackgroundTransparency = 0.2
    ToggleFrame.LayoutOrder = layoutOrder
    ToggleFrame.Parent = ScrollingFrame

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(80, 80, 120)
    ToggleStroke.Thickness = 1
    ToggleStroke.Parent = ToggleFrame

    ApplyRGBEffect(ToggleStroke)

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = text .. "Label"
    ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, IsMobile and 12 or 8, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = IsMobile and 13 or 11
    ToggleLabel.Font = Enum.Font.GothamBold
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    ApplyRGBEffect(ToggleLabel)

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = text .. "Toggle"
    ToggleButton.Size = UDim2.new(0, IsMobile and 55 or 45, 0, IsMobile and 26 or 22)
    ToggleButton.Position = UDim2.new(1, IsMobile and -60 or -50, 0.5, IsMobile and -13 or -11)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = IsMobile and 11 or 9
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ToggleFrame

    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 6)
    ToggleBtnCorner.Parent = ToggleButton

    return ToggleButton
end

-- Create action button
local function CreateActionButton(text, layoutOrder)
    local buttonHeight = IsMobile and 35 or 30
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = text .. "Frame"
    ButtonFrame.Size = UDim2.new(1, 0, 0, buttonHeight)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    ButtonFrame.BackgroundTransparency = 0.2
    ButtonFrame.LayoutOrder = layoutOrder
    ButtonFrame.Parent = ScrollingFrame

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(80, 80, 120)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = ButtonFrame

    ApplyRGBEffect(ButtonStroke)

    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(1, -20, 1, -8)
    Button.Position = UDim2.new(0, 10, 0, 4)
    Button.BackgroundTransparency = 1
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = IsMobile and 12 or 10
    Button.Font = Enum.Font.GothamBold
    Button.Parent = ButtonFrame

    ApplyRGBEffect(Button)

    return Button
end

-- Create all buttons
local FlyToggle = CreateCompactToggle("FLY", 1)
local NoclipToggle = CreateCompactToggle("NOCLIP", 2)
local AntiBanToggle = CreateCompactToggle("ANTI-BAN", 3)
local SpeedButton = CreateActionButton("SPEED +", 4)
local SpeedDownButton = CreateActionButton("SPEED -", 5)
local ResetButton = CreateActionButton("RESET CHARACTER", 6)

-- Uptime Counter
local StartTime = tick()
task.spawn(function()
    while ScreenGui.Parent do
        local elapsed = os.time() - StartTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        UptimeLabel.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        task.wait(1)
    end
end)

-- Toggle Menu Visibility
ToggleButton.MouseButton1Click:Connect(function()
    MenuVisible = not MenuVisible
    MainFrame.Visible = MenuVisible
end)

CloseButton.MouseButton1Click:Connect(function()
    MenuVisible = false
    MainFrame.Visible = false
end)

-- Fly System
local BGV
local FlyConnection

local function UpdateFly()
    if not getgenv().Fly then return end
    
    if BGV and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        BGV.Velocity = Vector3.new(0, 0, 0)
        BGV.MaxForce = Vector3.new(40000, 40000, 40000)
        
        local Camera = workspace.CurrentCamera
        local LookVector = Camera.CFrame.LookVector
        local RightVector = Camera.CFrame.RightVector
        
        local Direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            Direction = Direction + LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            Direction = Direction - LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            Direction = Direction + RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            Direction = Direction - RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Direction = Direction + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            Direction = Direction + Vector3.new(0, -1, 0)
        end
        
        if Direction.Magnitude > 0 then
            BGV.Velocity = Direction.Unit * getgenv().FlySpeed
        end
    end
end

FlyToggle.MouseButton1Click:Connect(function()
    getgenv().Fly = not getgenv().Fly
    
    if getgenv().Fly then
        FlyToggle.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        FlyToggle.Text = "ON"
        
        BGV = Instance.new("BodyVelocity")
        BGV.Velocity = Vector3.new(0, 0, 0)
        BGV.MaxForce = Vector3.new(0, 0, 0)
        
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        BGV.Parent = HumanoidRootPart
        
        FlyConnection = RunService.Heartbeat:Connect(UpdateFly)
    else
        FlyToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        FlyToggle.Text = "OFF"
        if FlyConnection then
            FlyConnection:Disconnect()
        end
        if BGV then
            BGV:Destroy()
            BGV = nil
        end
    end
end)

-- Noclip System
local NoclipConnection

NoclipToggle.MouseButton1Click:Connect(function()
    getgenv().Noclip = not getgenv().Noclip
    
    if getgenv().Noclip then
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        NoclipToggle.Text = "ON"
        
        local function NoclipLoop()
            if not getgenv().Noclip then return end
            local Character = Player.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
        
        NoclipConnection = RunService.Stepped:Connect(NoclipLoop)
    else
        NoclipToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        NoclipToggle.Text = "OFF"
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
    end
end)

-- Anti-Ban System
AntiBanToggle.MouseButton1Click:Connect(function()
    getgenv().AntiBan = not getgenv().AntiBan
    
    if getgenv().AntiBan then
        AntiBanToggle.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        AntiBanToggle.Text = "ON"
        
        -- Simple anti-ban measures
        task.spawn(function()
            while getgenv().AntiBan and ScreenGui.Parent do
                -- Random delays to avoid pattern detection
                task.wait(math.random(10, 30))
                pcall(function()
                    -- Clear logs occasionally
                    game:GetService("LogService"):ClearOutput()
                end)
            end
        end)
    else
        AntiBanToggle.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        AntiBanToggle.Text = "OFF"
    end
end)

-- Speed Controls
SpeedButton.MouseButton1Click:Connect(function()
    getgenv().FlySpeed = math.min(200, getgenv().FlySpeed + 10)
end)

SpeedDownButton.MouseButton1Click:Connect(function()
    getgenv().FlySpeed = math.max(10, getgenv().FlySpeed - 10)
end)

-- Reset Character
ResetButton.MouseButton1Click:Connect(function()
    local Character = Player.Character
    if Character then
        Character:BreakJoints()
    end
end)

-- Auto-adjust scrolling frame
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- Mobile touch support
if IsMobile then
    -- Make window draggable on mobile
    local Dragging = false
    local DragInput, DragStart, StartPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            MainFrame.Position = UDim2.new(
                StartPos.X.Scale,
                StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale,
                StartPos.Y.Offset + Delta.Y
            )
        end
    end)
end

print("HIEUDRG FLY HUB v3.0 - LOADED SUCCESSFULLY!")
print("Platform: " .. (IsMobile and "Mobile" or "PC"))
print("User: " .. Player.Name)
