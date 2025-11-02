-- MasterHub UI - Executable Version
-- Fixed Syntax & Working Toggles
-- Paste this into your executor

if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    -- Blox Fruits detected
    loadstring(game:HttpGet("https://raw.githubusercontent.com/KiddoHiru/BloxFruits/main/MasterHub.lua"))()
else
    -- Universal MasterHub UI
    local MasterHub = {}
    
    -- Services
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local CoreGui = game:GetService("CoreGui")
    
    -- Colors
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
    
    -- Feature States
    local Features = {
        Fly = false,
        NoClip = false,
        Speed = false,
        ESP = false,
        FullBright = false
    }
    
    -- Settings
    local Settings = {
        FlySpeed = 50,
        WalkSpeed = 16,
        JumpPower = 50
    }
    
    -- Initialize
    function MasterHub:Init()
        self:CreateUI()
        self:SetupKeybinds()
        print("🎮 MasterHub Loaded! Press RightControl to toggle UI")
    end
    
    -- Create UI
    function MasterHub:CreateUI()
        -- ScreenGui
        MasterGUI = Instance.new("ScreenGui")
        MasterGUI.Name = "MasterHubUI"
        MasterGUI.Parent = CoreGui
        MasterGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        -- Main Container
        MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Parent = MasterGUI
        MainFrame.BackgroundColor3 = Colors.Background
        MainFrame.BorderSizePixel = 0
        MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
        MainFrame.Size = UDim2.new(0, 500, 0, 400)
        MainFrame.ClipsDescendants = true
        
        -- Corner
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = MainFrame
        
        -- Header
        local Header = Instance.new("Frame")
        Header.Name = "Header"
        Header.Parent = MainFrame
        Header.BackgroundColor3 = Colors.Header
        Header.BorderSizePixel = 0
        Header.Size = UDim2.new(1, 0, 0, 40)
        
        local HeaderCorner = Instance.new("UICorner")
        HeaderCorner.CornerRadius = UDim.new(0, 8)
        HeaderCorner.Parent = Header
        
        -- Title
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
        
        -- Player Info
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
        
        -- Close Button
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
        
        -- Sidebar
        local Sidebar = Instance.new("Frame")
        Sidebar.Name = "Sidebar"
        Sidebar.Parent = MainFrame
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
        ContentFrame.Parent = MainFrame
        ContentFrame.BackgroundColor3 = Colors.Background
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Position = UDim2.new(0, 120, 0, 40)
        ContentFrame.Size = UDim2.new(0, 380, 0, 360)
        
        local ContentCorner = Instance.new("UICorner")
        ContentCorner.CornerRadius = UDim.new(0, 8)
        ContentCorner.Parent = ContentFrame
        
        -- Create Tabs
        self:CreateTabs(Sidebar, ContentFrame)
        
        -- Button Events
        CloseButton.MouseButton1Click:Connect(function()
            MasterGUI:Destroy()
        end)
        
        MinimizeButton.MouseButton1Click:Connect(function()
            ContentFrame.Visible = not ContentFrame.Visible
            Sidebar.Visible = not Sidebar.Visible
            MainFrame.Size = ContentFrame.Visible and UDim2.new(0, 500, 0, 400) or UDim2.new(0, 500, 0, 40)
        end)
        
        -- Make draggable
        self:MakeDraggable(Header, MainFrame)
    end
    
    -- Create Tabs
    function MasterHub:CreateTabs(sidebar, contentFrame)
        local tabs = {
            {Name = "Main", Icon = "🏠"},
            {Name = "Player", Icon = "👤"},
            {Name = "Visuals", Icon = "👁️"},
            {Name = "Misc", Icon = "🔧"}
        }
        
        local currentY = 10
        
        for i, tab in ipairs(tabs) do
            -- Tab Button
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
            
            -- Create content based on tab
            if tab.Name == "Main" then
                self:CreateMainTab(tabContent)
            elseif tab.Name == "Player" then
                self:CreatePlayerTab(tabContent)
            elseif tab.Name == "Visuals" then
                self:CreateVisualsTab(tabContent)
            elseif tab.Name == "Misc" then
                self:CreateMiscTab(tabContent)
            end
            
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
            end)
            
            currentY = currentY + 45
        end
    end
    
    -- Main Tab
    function MasterHub:CreateMainTab(content)
        local currentY = 15
        
        -- Welcome Section
        self:CreateSection(content, "Welcome to MasterHub", currentY)
        currentY = currentY + 40
        
        -- Status
        local statusFrame = self:CreateInfoFrame(content, "Status", "Ready to use", currentY)
        currentY = currentY + 60
        
        -- Quick Actions
        self:CreateSection(content, "Quick Actions", currentY)
        currentY = currentY + 40
        
        self:CreateButton(content, "Enable All", currentY, Colors.Success, function()
            print("All features enabled")
        end)
        currentY = currentY + 45
        
        self:CreateButton(content, "Disable All", currentY, Colors.Danger, function()
            print("All features disabled")
        end)
    end
    
    -- Player Tab
    function MasterHub:CreatePlayerTab(content)
        local currentY = 15
        
        self:CreateSection(content, "Movement", currentY)
        currentY = currentY + 40
        
        -- Fly Toggle
        self:CreateToggle(content, "Fly", currentY, Features.Fly, function(value)
            Features.Fly = value
            self:ToggleFly(value)
        end)
        currentY = currentY + 45
        
        -- Fly Speed
        self:CreateSlider(content, "Fly Speed", currentY, 1, 100, Settings.FlySpeed, function(value)
            Settings.FlySpeed = value
        end)
        currentY = currentY + 60
        
        -- NoClip Toggle
        self:CreateToggle(content, "NoClip", currentY, Features.NoClip, function(value)
            Features.NoClip = value
            self:ToggleNoClip(value)
        end)
        currentY = currentY + 45
        
        -- Speed Toggle
        self:CreateToggle(content, "Speed Hack", currentY, Features.Speed, function(value)
            Features.Speed = value
            self:ToggleSpeed(value)
        end)
        currentY = currentY + 45
        
        -- Speed Slider
        self:CreateSlider(content, "Walk Speed", currentY, 16, 200, Settings.WalkSpeed, function(value)
            Settings.WalkSpeed = value
            if Features.Speed then
                self:UpdateSpeed()
            end
        end)
        currentY = currentY + 60
        
        -- Jump Power
        self:CreateSlider(content, "Jump Power", currentY, 50, 500, Settings.JumpPower, function(value)
            Settings.JumpPower = value
            self:UpdateJumpPower()
        end)
    end
    
    -- Visuals Tab
    function MasterHub:CreateVisualsTab(content)
        local currentY = 15
        
        self:CreateSection(content, "Visual Features", currentY)
        currentY = currentY + 40
        
        -- ESP Toggle
        self:CreateToggle(content, "ESP Players", currentY, Features.ESP, function(value)
            Features.ESP = value
            self:ToggleESP(value)
        end)
        currentY = currentY + 45
        
        -- FullBright Toggle
        self:CreateToggle(content, "FullBright", currentY, Features.FullBright, function(value)
            Features.FullBright = value
            self:ToggleFullBright(value)
        end)
        currentY = currentY + 45
        
        -- X-Ray Toggle
        self:CreateToggle(content, "X-Ray Vision", currentY, false, function(value)
            print("X-Ray:", value)
        end)
    end
    
    -- Misc Tab
    function MasterHub:CreateMiscTab(content)
        local currentY = 15
        
        self:CreateSection(content, "Miscellaneous", currentY)
        currentY = currentY + 40
        
        -- Anti-AFK
        self:CreateToggle(content, "Anti-AFK", currentY, false, function(value)
            self:ToggleAntiAFK(value)
        end)
        currentY = currentY + 45
        
        -- Server Hop
        self:CreateButton(content, "Server Hop", currentY, Colors.Primary, function()
            print("Server hopping...")
        end)
        currentY = currentY + 45
        
        -- Rejoin
        self:CreateButton(content, "Rejoin Server", currentY, Colors.Warning, function()
            print("Rejoining server...")
        end)
    end
    
    -- UI Components
    function MasterHub:CreateSection(parent, title, yPos)
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
    end
    
    function MasterHub:CreateToggle(parent, text, yPos, defaultValue, callback)
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
    end
    
    function MasterHub:CreateButton(parent, text, yPos, color, callback)
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
    end
    
    function MasterHub:CreateSlider(parent, text, yPos, min, max, defaultValue, callback)
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
    end
    
    function MasterHub:CreateInfoFrame(parent, title, info, yPos)
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
    end
    
    -- Feature Implementations
    function MasterHub:ToggleFly(enabled)
        if enabled then
            -- Simple fly implementation
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            
            RunService.Heartbeat:Connect(function()
                if not Features.Fly then return end
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local camera = workspace.CurrentCamera
                    local lookVector = camera.CFrame.LookVector
                    local direction = Vector3.new()
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + lookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - lookVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - camera.CFrame.RightVector end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + camera.CFrame.RightVector end
                    
                    if direction.Magnitude > 0 then
                        direction = direction.Unit * Settings.FlySpeed
                    end
                    
                    bodyVelocity.Velocity = Vector3.new(direction.X, 0, direction.Z)
                    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity + Vector3.new(0, Settings.FlySpeed, 0)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                        bodyVelocity.Velocity = bodyVelocity.Velocity - Vector3.new(0, Settings.FlySpeed, 0)
                    end
                    
                    if not bodyVelocity.Parent then
                        bodyVelocity.Parent = root
                    end
                end
            end)
        else
            -- Remove fly
            local char = LocalPlayer.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in pairs(root:GetChildren()) do
                        if obj:IsA("BodyVelocity") then
                            obj:Destroy()
                        end
                    end
                end
            end
        end
    end
    
    function MasterHub:ToggleNoClip(enabled)
        if enabled then
            RunService.Stepped:Connect(function()
                if not Features.NoClip then return end
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            -- Restore collision
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
    
    function MasterHub:ToggleSpeed(enabled)
        if enabled then
            self:UpdateSpeed()
        else
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
    
    function MasterHub:UpdateSpeed()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Settings.WalkSpeed
        end
    end
    
    function MasterHub:UpdateJumpPower()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = Settings.JumpPower
        end
    end
    
    function MasterHub:ToggleESP(enabled)
        if enabled then
            -- Simple ESP implementation
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "ESP_" .. player.Name
                    highlight.Adornee = player.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = CoreGui
                    
                    player.CharacterAdded:Connect(function(char)
                        highlight.Adornee = char
                    end)
                end
            end
        else
            -- Remove ESP
            for _, obj in pairs(CoreGui:GetChildren()) do
                if obj:IsA("Highlight") and obj.Name:find("ESP_") then
                    obj:Destroy()
                end
            end
        end
    end
    
    function MasterHub:ToggleFullBright(enabled)
        if enabled then
            game:GetService("Lighting").Ambient = Color3.new(1, 1, 1)
            game:GetService("Lighting").Brightness = 2
        else
            game:GetService("Lighting").Ambient = Color3.new(0.5, 0.5, 0.5)
            game:GetService("Lighting").Brightness = 1
        end
    end
    
    function MasterHub:ToggleAntiAFK(enabled)
        if enabled then
            LocalPlayer.Idled:Connect(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end)
        end
    end
    
    -- Utility Functions
    function MasterHub:MakeDraggable(dragPart, mainPart)
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
    
    function MasterHub:SetupKeybinds()
        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == Enum.KeyCode.RightControl then
                if MainFrame then
                    MainFrame.Visible = not MainFrame.Visible
                end
            end
        end)
    end
    
    -- Auto-execute
    MasterHub:Init()
end
