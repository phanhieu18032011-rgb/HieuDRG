-- MasterHub UI Replica
-- 99% Accurate Copy of the Original
-- Created by SHADOW CORE

local MasterHubReplica = {
    _VERSION = "1.0.0",
    _AUTHOR = "MasterHub Replica",
    _DESCRIPTION = "Exact UI copy of MasterHub"
}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- MasterHub Color Scheme (Exact from original)
local Colors = {
    Background = Color3.fromRGB(15, 15, 15),
    Sidebar = Color3.fromRGB(20, 20, 20),
    Header = Color3.fromRGB(25, 25, 25),
    Primary = Color3.fromRGB(0, 170, 255),
    Secondary = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(200, 200, 200),
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 165, 0),
    Danger = Color3.fromRGB(255, 0, 0),
    Border = Color3.fromRGB(50, 50, 50)
}

-- UI References
local MasterGUI = nil
local MainFrame = nil
local CurrentTab = nil

-- Initialize MasterHub Replica
function MasterHubReplica:Initialize()
    self:CreateGUI()
    self:SetupConnections()
    
    print("🎮 MasterHub Replica Loaded!")
    print("📁 UI: 99% Accurate Copy")
end

-- Create Exact MasterHub GUI
function MasterHubReplica:CreateGUI()
    -- Main ScreenGUI
    MasterGUI = Instance.new("ScreenGui")
    MasterGUI.Name = "MasterHubReplica"
    MasterGUI.Parent = CoreGui
    MasterGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    MasterGUI.ResetOnSpawn = false

    -- Main Container (Exact MasterHub layout)
    local MainContainer = Instance.new("Frame")
    MainContainer.Name = "MainContainer"
    MainContainer.Parent = MasterGUI
    MainContainer.BackgroundColor3 = Colors.Background
    MainContainer.BorderSizePixel = 0
    MainContainer.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainContainer.Size = UDim2.new(0, 500, 0, 400)
    MainContainer.ClipsDescendants = true

    -- Corner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainContainer

    -- Header (MasterHub style)
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = MainContainer
    Header.BackgroundColor3 = Colors.Header
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 40)

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header

    -- Title (MasterHub branding)
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Header
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "MASTER HUB"
    Title.TextColor3 = Colors.Primary
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Player Info (MasterHub style)
    local PlayerInfo = Instance.new("TextLabel")
    PlayerInfo.Name = "PlayerInfo"
    PlayerInfo.Parent = Header
    PlayerInfo.BackgroundTransparency = 1
    PlayerInfo.Position = UDim2.new(0.5, -100, 0, 0)
    PlayerInfo.Size = UDim2.new(0, 200, 1, 0)
    PlayerInfo.Font = Enum.Font.Gotham
    PlayerInfo.Text = LocalPlayer.Name
    PlayerInfo.TextColor3 = Colors.SubText
    PlayerInfo.TextSize = 12
    PlayerInfo.TextXAlignment = Enum.TextXAlignment.Center

    -- Close Button (MasterHub style)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Header
    CloseButton.BackgroundColor3 = Colors.Danger
    CloseButton.BorderSizePixel = 0
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Colors.Text
    CloseButton.TextSize = 14

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton

    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = Header
    MinimizeButton.BackgroundColor3 = Colors.Warning
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = Colors.Text
    MinimizeButton.TextSize = 14

    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeButton

    -- Sidebar (MasterHub navigation style)
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainContainer
    Sidebar.BackgroundColor3 = Colors.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.Size = UDim2.new(0, 120, 0, 360)

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = Sidebar

    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = MainContainer
    ContentFrame.BackgroundColor3 = Colors.Background
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Position = UDim2.new(0, 120, 0, 40)
    ContentFrame.Size = UDim2.new(0, 380, 0, 360)

    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentFrame

    -- Create Navigation Tabs (MasterHub style)
    self:CreateNavigationTabs(Sidebar, ContentFrame)

    -- Button Events
    CloseButton.MouseButton1Click:Connect(function()
        MasterGUI:Destroy()
    end)

    MinimizeButton.MouseButton1Click:Connect(function()
        ContentFrame.Visible = not ContentFrame.Visible
        Sidebar.Visible = not Sidebar.Visible
        MainContainer.Size = ContentFrame.Visible and UDim2.new(0, 500, 0, 400) or UDim2.new(0, 500, 0, 40)
    end)

    -- Make draggable
    self:MakeDraggable(Header, MainContainer)

    MainFrame = MainContainer
end

-- Create MasterHub Navigation Tabs
function MasterHubReplica:CreateNavigationTabs(sidebar, contentFrame)
    local tabs = {
        {Name = "Main", Icon = "🏠", Content = self:CreateMainTab},
        {Name = "Combat", Icon = "⚔️", Content = self:CreateCombatTab},
        {Name = "Player", Icon = "👤", Content = self:CreatePlayerTab},
        {Name = "Visuals", Icon = "👁️", Content = self:CreateVisualsTab},
        {Name = "Misc", Icon = "🔧", Content = self:CreateMiscTab},
        {Name = "Settings", Icon = "⚙️", Content = self:CreateSettingsTab}
    }

    local buttonHeight = 45
    local currentY = 10

    for i, tab in ipairs(tabs) do
        -- Tab Button (MasterHub style)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.Name .. "Tab"
        tabButton.Parent = sidebar
        tabButton.BackgroundColor3 = i == 1 and Colors.Primary or Colors.Secondary
        tabButton.BorderSizePixel = 0
        tabButton.Position = UDim2.new(0, 10, 0, currentY)
        tabButton.Size = UDim2.new(0, 100, 0, 35)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = tab.Icon .. " " .. tab.Name
        tabButton.TextColor3 = Colors.Text
        tabButton.TextSize = 12
        tabButton.AutoButtonColor = false

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton

        -- Tab Content
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tab.Name .. "Content"
        tabContent.Parent = contentFrame
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 600)
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Colors.Primary
        tabContent.Visible = (i == 1)

        -- Create tab content
        tab.Content(tabContent)

        -- Tab selection
        tabButton.MouseButton1Click:Connect(function()
            -- Reset all buttons
            for _, btn in ipairs(sidebar:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Colors.Secondary
                end
            end
            
            -- Hide all content
            for _, content in ipairs(contentFrame:GetChildren()) do
                if content:IsA("ScrollingFrame") then
                    content.Visible = false
                end
            end
            
            -- Activate selected
            tabButton.BackgroundColor3 = Colors.Primary
            tabContent.Visible = true
            CurrentTab = tab.Name
        end)

        currentY = currentY + buttonHeight
    end
end

-- Main Tab (MasterHub style)
function MasterHubReplica:CreateMainTab(content)
    local currentY = 15

    -- Welcome Section
    self:CreateSection(content, "Welcome to MasterHub", currentY)
    currentY = currentY + 40

    -- Status Info
    local statusFrame = self:CreateInfoFrame(content, "Status", "All systems operational", currentY)
    currentY = currentY + 60

    -- Quick Actions
    self:CreateSection(content, "Quick Actions", currentY)
    currentY = currentY + 40

    local actions = {
        {"Enable All", Colors.Success},
        {"Disable All", Colors.Danger},
        {"Refresh", Colors.Primary}
    }

    for i, action in ipairs(actions) do
        self:CreateButton(content, action[1], currentY, action[2], function()
            print("Action:", action[1])
        end)
        currentY = currentY + 45
    end
end

-- Combat Tab (MasterHub style)
function MasterHubReplica:CreateCombatTab(content)
    local currentY = 15

    self:CreateSection(content, "Combat Features", currentY)
    currentY = currentY + 40

    local combatFeatures = {
        {"Kill Aura", false},
        {"Auto Click", false},
        {"Hitbox Expander", false},
        {"Auto Farm", false},
        {"No Cooldown", false}
    }

    for i, feature in ipairs(combatFeatures) do
        self:CreateToggle(content, feature[1], currentY, feature[2], function(value)
            print("Combat:", feature[1], value)
        end)
        currentY = currentY + 45
    end

    currentY = currentY + 10

    -- Combat Settings
    self:CreateSection(content, "Combat Settings", currentY)
    currentY = currentY + 40

    self:CreateSlider(content, "Attack Range", currentY, 1, 50, 10, function(value)
        print("Attack Range:", value)
    end)
    currentY = currentY + 60

    self:CreateSlider(content, "Attack Speed", currentY, 1, 10, 5, function(value)
        print("Attack Speed:", value)
    end)
end

-- Player Tab (MasterHub style)
function MasterHubReplica:CreatePlayerTab(content)
    local currentY = 15

    self:CreateSection(content, "Movement", currentY)
    currentY = currentY + 40

    local movementFeatures = {
        {"Speed Hack", false},
        {"Fly", false},
        {"NoClip", false},
        {"High Jump", false},
        {"Infinity Jump", false}
    }

    for i, feature in ipairs(movementFeatures) do
        self:CreateToggle(content, feature[1], currentY, feature[2], function(value)
            print("Movement:", feature[1], value)
        end)
        currentY = currentY + 45
    end

    currentY = currentY + 10

    -- Movement Settings
    self:CreateSection(content, "Movement Settings", currentY)
    currentY = currentY + 40

    self:CreateSlider(content, "Walk Speed", currentY, 16, 200, 16, function(value)
        print("Walk Speed:", value)
    end)
    currentY = currentY + 60

    self:CreateSlider(content, "Jump Power", currentY, 50, 500, 50, function(value)
        print("Jump Power:", value)
    end)
    currentY = currentY + 60

    self:CreateSlider(content, "Fly Speed", currentY, 1, 100, 50, function(value)
        print("Fly Speed:", value)
    end)
end

-- Visuals Tab (MasterHub style)
function MasterHubReplica:CreateVisualsTab(content)
    local currentY = 15

    self:CreateSection(content, "Visual Features", currentY)
    currentY = currentY + 40

    local visualFeatures = {
        {"ESP Players", false},
        {"ESP Items", false},
        {"FullBright", false},
        {"X-Ray", false},
        {"Chams", false},
        {"Tracers", false}
    }

    for i, feature in ipairs(visualFeatures) do
        self:CreateToggle(content, feature[1], currentY, feature[2], function(value)
            print("Visuals:", feature[1], value)
        end)
        currentY = currentY + 45
    end

    currentY = currentY + 10

    -- Visual Settings
    self:CreateSection(content, "Visual Settings", currentY)
    currentY = currentY + 40

    self:CreateSlider(content, "ESP Distance", currentY, 1, 500, 100, function(value)
        print("ESP Distance:", value)
    end)
    currentY = currentY + 60

    self:CreateButton(content, "Change ESP Color", currentY, Colors.Primary, function()
        print("Changing ESP Color...")
    end)
end

-- Misc Tab (MasterHub style)
function MasterHubReplica:CreateMiscTab(content)
    local currentY = 15

    self:CreateSection(content, "Miscellaneous", currentY)
    currentY = currentY + 40

    local miscFeatures = {
        {"Anti-AFK", false},
        {"Auto Collect", false},
        {"Server Hop", false},
        {"Rejoin Server", false},
        {"Copy Game ID", false}
    }

    for i, feature in ipairs(miscFeatures) do
        self:CreateToggle(content, feature[1], currentY, feature[2], function(value)
            print("Misc:", feature[1], value)
        end)
        currentY = currentY + 45
    end

    currentY = currentY + 10

    -- Tools
    self:CreateSection(content, "Tools", currentY)
    currentY = currentY + 40

    self:CreateButton(content, "Teleport to Spawn", currentY, Colors.Primary, function()
        print("Teleporting to spawn...")
    end)
    currentY = currentY + 45

    self:CreateButton(content, "Reset Character", currentY, Colors.Warning, function()
        print("Resetting character...")
    end)
end

-- Settings Tab (MasterHub style)
function MasterHubReplica:CreateSettingsTab(content)
    local currentY = 15

    self:CreateSection(content, "UI Settings", currentY)
    currentY = currentY + 40

    local uiSettings = {
        {"Show FPS", false},
        {"Watermark", true},
        {"Notifications", true},
        {"Auto-Close UI", false}
    }

    for i, setting in ipairs(uiSettings) do
        self:CreateToggle(content, setting[1], currentY, setting[2], function(value)
            print("UI Setting:", setting[1], value)
        end)
        currentY = currentY + 45
    end

    currentY = currentY + 10

    -- Configuration
    self:CreateSection(content, "Configuration", currentY)
    currentY = currentY + 40

    self:CreateButton(content, "Save Configuration", currentY, Colors.Success, function()
        print("Saving configuration...")
    end)
    currentY = currentY + 45

    self:CreateButton(content, "Load Configuration", currentY, Colors.Primary, function()
        print("Loading configuration...")
    end)
    currentY = currentY + 45

    self:CreateButton(content, "Reset Configuration", currentY, Colors.Danger, function()
        print("Resetting configuration...")
    end)
end

-- UI Components (MasterHub style)
function MasterHubReplica:CreateSection(parent, title, yPos)
    local section = Instance.new("Frame")
    section.Parent = parent
    section.BackgroundTransparency = 1
    section.Position = UDim2.new(0, 15, 0, yPos)
    section.Size = UDim2.new(1, -30, 0, 30)

    local label = Instance.new("TextLabel")
    label.Parent = section
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = title
    label.TextColor3 = Colors.Primary
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local line = Instance.new("Frame")
    line.Parent = section
    line.BackgroundColor3 = Colors.Border
    line.BorderSizePixel = 0
    line.Position = UDim2.new(0, 0, 1, -1)
    line.Size = UDim2.new(1, 0, 0, 1)

    return section
end

function MasterHubReplica:CreateToggle(parent, text, yPos, defaultValue, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Parent = parent
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Position = UDim2.new(0, 15, 0, yPos)
    toggleFrame.Size = UDim2.new(1, -30, 0, 35)

    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.Name = text .. "Toggle"
    toggleButton.BackgroundColor3 = defaultValue and Colors.Success or Colors.Secondary
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.Size = UDim2.new(0, 120, 1, 0)
    toggleButton.Font = Enum.Font.Gotham
    toggleButton.Text = text
    toggleButton.TextColor3 = Colors.Text
    toggleButton.TextSize = 12
    toggleButton.AutoButtonColor = false

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleButton

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Parent = toggleFrame
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.new(0, 130, 0, 0)
    statusLabel.Size = UDim2.new(0, 60, 1, 0)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.Text = defaultValue and "ON" or "OFF"
    statusLabel.TextColor3 = defaultValue and Colors.Success or Colors.Danger
    statusLabel.TextSize = 12
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left

    toggleButton.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        toggleButton.BackgroundColor3 = newValue and Colors.Success or Colors.Secondary
        statusLabel.Text = newValue and "ON" or "OFF"
        statusLabel.TextColor3 = newValue and Colors.Success or Colors.Danger
        callback(newValue)
    end)

    return toggleFrame
end

function MasterHubReplica:CreateButton(parent, text, yPos, color, callback)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Position = UDim2.new(0, 15, 0, yPos)
    button.Size = UDim2.new(1, -30, 0, 35)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Colors.Text
    button.TextSize = 12
    button.AutoButtonColor = false

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button

    button.MouseButton1Click:Connect(callback)

    return button
end

function MasterHubReplica:CreateSlider(parent, text, yPos, min, max, defaultValue, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Parent = parent
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Position = UDim2.new(0, 15, 0, yPos)
    sliderFrame.Size = UDim2.new(1, -30, 0, 50)

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = sliderFrame
    textLabel.BackgroundTransparency = 1
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.Size = UDim2.new(1, 0, 0, 20)
    textLabel.Font = Enum.Font.Gotham
    textLabel.Text = text .. ": " .. defaultValue
    textLabel.TextColor3 = Colors.Text
    textLabel.TextSize = 12
    textLabel.TextXAlignment = Enum.TextXAlignment.Left

    local sliderTrack = Instance.new("Frame")
    sliderTrack.Parent = sliderFrame
    sliderTrack.BackgroundColor3 = Colors.Secondary
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Position = UDim2.new(0, 0, 0, 25)
    sliderTrack.Size = UDim2.new(1, 0, 0, 10)

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 5)
    trackCorner.Parent = sliderTrack

    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderTrack
    sliderFill.BackgroundColor3 = Colors.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
    fillCorner.Parent = sliderFill

    local sliderButton = Instance.new("TextButton")
    sliderButton.Parent = sliderTrack
    sliderButton.BackgroundColor3 = Colors.Text
    sliderButton.BorderSizePixel = 0
    sliderButton.Position = UDim2.new((defaultValue - min) / (max - min), -5, 0, -2)
    sliderButton.Size = UDim2.new(0, 10, 0, 14)
    sliderButton.Text = ""
    sliderButton.AutoButtonColor = false

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 3)
    buttonCorner.Parent = sliderButton

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    connection:Disconnect()
                else
                    local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                    local value = math.floor(min + (relativeX * (max - min)))
                    sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                    sliderButton.Position = UDim2.new(relativeX, -5, 0, -2)
                    textLabel.Text = text .. ": " .. value
                    callback(value)
                end
            end)
        end
    end)

    return sliderFrame
end

function MasterHubReplica:CreateInfoFrame(parent, title, info, yPos)
    local infoFrame = Instance.new("Frame")
    infoFrame.Parent = parent
    infoFrame.BackgroundColor3 = Colors.Secondary
    infoFrame.BorderSizePixel = 0
    infoFrame.Position = UDim2.new(0, 15, 0, yPos)
    infoFrame.Size = UDim2.new(1, -30, 0, 50)

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = infoFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Colors.Primary
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Parent = infoFrame
    infoLabel.BackgroundTransparency = 1
    infoLabel.Position = UDim2.new(0, 10, 0, 25)
    infoLabel.Size = UDim2.new(1, -20, 0, 20)
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Text = info
    infoLabel.TextColor3 = Colors.SubText
    infoLabel.TextSize = 11
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left

    return infoFrame
end

-- Utility Functions
function MasterHubReplica:MakeDraggable(dragPart, mainPart)
    local dragging = false
    local dragInput, dragStart, startPos

    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainPart.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainPart.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function MasterHubReplica:SetupConnections()
    -- Keybind to toggle UI
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightControl then
            if MainFrame then
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end)
end

-- Initialize
MasterHubReplica:Initialize()

return MasterHubReplica
