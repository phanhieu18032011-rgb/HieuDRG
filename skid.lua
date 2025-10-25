local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- Anti-ban system
local AntiBanEnabled = false
local LastAntiBanCheck = tick()

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HieuDRG_FLY_Hub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Container với background đẹp
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Rotation = 45
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 30))
})
Gradient.Parent = MainFrame

-- Corner radius
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Stroke effect
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(60, 60, 100)
Stroke.Thickness = 2
Stroke.Parent = MainFrame

-- Header với RGB effect
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Title với RGB
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 300, 0, 30)
Title.Position = UDim2.new(0.5, -150, 0, 15)
Title.BackgroundTransparency = 1
Title.Text = "HIEUDRG FLY HUB v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack
Title.TextStrokeTransparency = 0.7
Title.Parent = Header

-- Subtitle với user info
local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(0, 300, 0, 20)
SubTitle.Position = UDim2.new(0.5, -150, 0, 40)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "User: " .. Player.Name
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.Parent = Header

-- Uptime display
local UptimeLabel = Instance.new("TextLabel")
UptimeLabel.Name = "UptimeLabel"
UptimeLabel.Size = UDim2.new(0, 200, 0, 15)
UptimeLabel.Position = UDim2.new(0.5, -100, 1, -20)
UptimeLabel.BackgroundTransparency = 1
UptimeLabel.Text = "UPTIME: 00:00:00"
UptimeLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
UptimeLabel.TextSize = 11
UptimeLabel.Font = Enum.Font.Gotham
UptimeLabel.Parent = Header

-- Close button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseButton.BackgroundTransparency = 0.3
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Text = "X"
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Content area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -80)
ContentFrame.Position = UDim2.new(0, 10, 0, 70)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Scrolling frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
ScrollingFrame.Parent = ContentFrame

-- UIListLayout for buttons
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

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

-- Apply RGB effect to elements
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
            task.wait(0.5)
        end
    end)
end

-- Apply RGB to main elements
ApplyRGBEffect(Title)
ApplyRGBEffect(UptimeLabel)

-- Create control buttons
local function CreateControlButton(text, layoutOrder)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = text .. "Frame"
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
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

    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(1, -20, 1, -8)
    Button.Position = UDim2.new(0, 10, 0, 4)
    Button.BackgroundTransparency = 1
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = ButtonFrame

    ApplyRGBEffect(ButtonStroke)

    return Button
end

-- Create toggle buttons
local function CreateToggleButton(text, layoutOrder)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
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

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = text .. "Label"
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.GothamBold
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = text .. "Toggle"
    ToggleButton.Size = UDim2.new(0, 60, 0, 30)
    ToggleButton.Position = UDim2.new(1, -70, 0.5, -15)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    ToggleButton.Text = "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.Parent = ToggleFrame

    local ToggleCorner2 = Instance.new("UICorner")
    ToggleCorner2.CornerRadius = UDim.new(0, 6)
    ToggleCorner2.Parent = ToggleButton

    ApplyRGBEffect(ToggleStroke)
    ApplyRGBEffect(ToggleLabel)

    return ToggleButton
end

-- Create buttons
local FlyButton = CreateToggleButton("FLY ENABLED", 1)
local NoclipButton = CreateToggleButton("NOCLIP ENABLED", 2)
local AntiBanButton = CreateToggleButton("ANTI-BAN SYSTEM", 3)
local SpeedButton = CreateControlButton("SPEED CONTROL", 4)
local ResetButton = CreateControlButton("RESET CHARACTER", 5)

-- Uptime counter
local StartTime = tick()
task.spawn(function()
    while ScreenGui.Parent do
        local elapsed = os.time() - StartTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        UptimeLabel.Text = string.format("UPTIME: %02d:%02d:%02d", hours, minutes, seconds)
        task.wait(1)
    end
end)

-- Fly system
local FlyEnabled = false
local FlySpeed = 50
local BodyVelocity

FlyButton.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    
    if FlyEnabled then
        FlyButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        FlyButton.Text = "ON"
        
        -- Create fly body velocity
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
        BodyVelocity.Parent = HumanoidRootPart
        
        -- Fly control connection
        local FlyConnection
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not FlyEnabled then
                FlyConnection:Disconnect()
                if BodyVelocity then
                    BodyVelocity:Destroy()
                    BodyVelocity = nil
                end
                return
            end
            
            if BodyVelocity and HumanoidRootPart then
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                
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
                    BodyVelocity.Velocity = Direction.Unit * FlySpeed
                else
                    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    else
        FlyButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        FlyButton.Text = "OFF"
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
    end
end)

-- Noclip system
local NoclipEnabled = false
local NoclipConnection

NoclipButton.MouseButton1Click:Connect(function()
    NoclipEnabled = not NoclipEnabled
    
    if NoclipEnabled then
        NoclipButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        NoclipButton.Text = "ON"
        
        local Character = Player.Character
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        
        NoclipConnection = RunService.Stepped:Connect(function()
            if not NoclipEnabled then
                NoclipConnection:Disconnect()
                return
            end
            
            local Character = Player.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        NoclipButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        NoclipButton.Text = "OFF"
        if NoclipConnection then
            NoclipConnection:Disconnect()
        end
    end
end)

-- Anti-ban system
AntiBanButton.MouseButton1Click:Connect(function()
    AntiBanEnabled = not AntiBanEnabled
    
    if AntiBanEnabled then
        AntiBanButton.BackgroundColor3 = Color3.fromRGB(60, 255, 60)
        AntiBanButton.Text = "ON"
        
        -- Anti-detection measures
        task.spawn(function()
            while AntiBanEnabled and ScreenGui.Parent do
                -- Randomize execution patterns
                task.wait(math.random(5, 15))
                
                -- Clear logs periodically
                pcall(function()
                    game:GetService("LogService"):ClearOutput()
                end)
                
                -- Change GUI properties randomly
                pcall(function()
                    ScreenGui.Enabled = not ScreenGui.Enabled
                    task.wait(0.1)
                    ScreenGui.Enabled = true
                end)
                
                LastAntiBanCheck = tick()
            end
        end)
    else
        AntiBanButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        AntiBanButton.Text = "OFF"
    end
end)

-- Speed control
SpeedButton.MouseButton1Click:Connect(function()
    local Character = Player.Character
    if Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = 50
    end
end)

-- Reset character
ResetButton.MouseButton1Click:Connect(function()
    local Character = Player.Character
    if Character then
        Character:BreakJoints()
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Make window draggable
local Dragging = false
local DragInput, DragStart, StartPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
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

-- Auto-adjust scrolling frame
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

print("HIEUDRG FLY HUB v3.0 - LOADED SUCCESSFULLY!")
print("User: " .. Player.Name)
print("Features: FLY, NOCLIP, ANTI-BAN, SPEED CONTROL")
