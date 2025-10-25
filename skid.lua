getgenv().team = "Pirates" -- Marines

repeat wait() until game:IsLoaded() and game.Players.LocalPlayer:FindFirstChild("DataLoaded")

-- Tự động chọn team với phương pháp đáng tin cậy hơn
if game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)") then
    repeat
        wait()
        local l_Remotes_0 = game.ReplicatedStorage:WaitForChild("Remotes")
        l_Remotes_0.CommF_:InvokeServer("SetTeam", getgenv().team)
        task.wait(3)
    until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("Main (minimal)")
end

-- Tiếp tục đợi GUI chính tải
repeat task.wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")
	
-- >>> HIEUDRG HUB KAITUN UI <
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HieuDRG_Hub_UI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Tạo hiệu ứng blur full màn hình
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 24
blurEffect.Parent = game:GetService("Lighting")

-- Frame chứa toàn bộ UI
local containerFrame = Instance.new("Frame")
containerFrame.Size = UDim2.new(1, 0, 1, 0)
containerFrame.Position = UDim2.new(0, 0, 1, 0) -- bắt đầu từ dưới màn hình
containerFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
containerFrame.BackgroundTransparency = 0.15
containerFrame.BorderSizePixel = 0
containerFrame.Parent = screenGui

-- Hình ảnh ở giữa màn hình
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(0, 170, 0, 170)
imageLabel.Position = UDim2.new(0.5, -85, 0.5, -120)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://91881585928344"
imageLabel.Parent = containerFrame

-- Hiệu ứng xoay logo
task.spawn(function()
    while imageLabel.Parent do
        imageLabel.Rotation = imageLabel.Rotation + 0.5
        task.wait(0.02)
    end
end)

-- HieuDRG Hub Main Title
local hubLabel = Instance.new("TextLabel")
hubLabel.Size = UDim2.new(0, 320, 0, 40)
hubLabel.Position = UDim2.new(0.5, -160, 0.5, -200)
hubLabel.BackgroundTransparency = 1
hubLabel.TextColor3 = Color3.new(1, 1, 1)
hubLabel.TextScaled = true
hubLabel.Font = Enum.Font.GothamBlack
hubLabel.Text = "HIEUDRG HUB | KAITUN"
hubLabel.TextStrokeTransparency = 0.7
hubLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
hubLabel.Parent = containerFrame

-- Premium Badge
local premiumLabel = Instance.new("TextLabel")
premiumLabel.Size = UDim2.new(0, 100, 0, 20)
premiumLabel.Position = UDim2.new(0.5, 130, 0.5, -200)
premiumLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.3)
premiumLabel.BackgroundTransparency = 0.3
premiumLabel.TextColor3 = Color3.new(1, 1, 1)
premiumLabel.TextScaled = true
premiumLabel.Font = Enum.Font.GothamBold
premiumLabel.Text = "[FREE]"
premiumLabel.Parent = containerFrame

-- Bo góc cho premium badge
local premiumCorner = Instance.new("UICorner")
premiumCorner.CornerRadius = UDim.new(0, 6)
premiumCorner.Parent = premiumLabel

-- Label hiển thị thời gian
local timeLabel = Instance.new("TextLabel")
timeLabel.Size = UDim2.new(0, 280, 0, 25)
timeLabel.Position = UDim2.new(0.5, -140, 0.5, 155)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = Color3.new(1, 1, 1)
timeLabel.TextScaled = true
timeLabel.Font = Enum.Font.GothamBold
timeLabel.Text = "00 Hour (h) 00 Minute (m) 00 Second (s)"
timeLabel.TextStrokeTransparency = 0.7
timeLabel.Parent = containerFrame

-- Discord link label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0, 200, 0, 15)
discordLabel.Position = UDim2.new(0.5, -100, 0.5, 185)
discordLabel.BackgroundTransparency = 1
discordLabel.TextColor3 = Color3.new(0.7, 0.7, 1)
discordLabel.TextScaled = true
discordLabel.Font = Enum.Font.Gotham
discordLabel.Text = "discord.gg/3EwNuXTNCU"
discordLabel.Parent = containerFrame

-- Hiển thị tên người chơi
local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Size = UDim2.new(0, 200, 0, 15)
playerNameLabel.Position = UDim2.new(0.5, -100, 0, 10)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.TextColor3 = Color3.new(1, 1, 1)
playerNameLabel.TextScaled = true
playerNameLabel.Font = Enum.Font.Gotham
playerNameLabel.Text = "Player: " .. player.Name
playerNameLabel.Parent = containerFrame

-- Status indicator
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 200, 0, 20)
statusLabel.Position = UDim2.new(0.5, -100, 0, 30)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.GothamBold
statusLabel.Text = "🟢 STATUS: ACTIVE"
statusLabel.Parent = containerFrame

-- RGB Color System
local rgbColors = {
    Color3.fromRGB(255, 0, 0),      -- Red
    Color3.fromRGB(255, 127, 0),    -- Orange
    Color3.fromRGB(255, 255, 0),    -- Yellow
    Color3.fromRGB(0, 255, 0),      -- Green
    Color3.fromRGB(0, 0, 255),      -- Blue
    Color3.fromRGB(75, 0, 130),     -- Indigo
    Color3.fromRGB(148, 0, 211)     -- Violet
}

-- Function to apply RGB effect
local function applyRGBEffect(label)
    local currentIndex = 1
    task.spawn(function()
        while label and label.Parent do
            label.TextColor3 = rgbColors[currentIndex]
            currentIndex = currentIndex + 1
            if currentIndex > #rgbColors then
                currentIndex = 1
            end
            task.wait(0.3) -- Change color every 0.3 seconds
        end
    end)
end

-- Apply RGB effects to main labels
applyRGBEffect(hubLabel)
applyRGBEffect(timeLabel)
applyRGBEffect(premiumLabel)
applyRGBEffect(statusLabel)

-- Tween container từ dưới lên
local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local goal = { Position = UDim2.new(0, 0, 0, 0) }
local tween = TweenService:Create(containerFrame, tweenInfo, goal)
tween:Play()

-- Bắt đầu đếm thời gian sau tween
local startTime = tick()
tween.Completed:Connect(function()
    -- Bắt đầu cập nhật thời gian sau khi tween hoàn tất
    task.spawn(function()
        while screenGui.Parent do
            local elapsed = math.floor(tick() - startTime)
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = elapsed % 60
            timeLabel.Text = string.format("%02d Hour (h) %02d Minute (m) %02d Second (s)", hours, minutes, seconds)
            task.wait(1)
        end
    end)
end)

-- MAIN FRUIT FARMING CODE
local a = game.Players.LocalPlayer
local b = a.Character or a.CharacterAdded:Wait()
local c = game.TweenService

-- Wait for character if needed
if not a.Character then
    a.CharacterAdded:Wait()
    b = a.Character
end

local d = Instance.new("BodyVelocity")
d.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
d.Velocity = Vector3.new()
d.Name = "bV"

local e = Instance.new("BodyAngularVelocity")
e.AngularVelocity = Vector3.new()
e.MaxTorque = Vector3.new(1 / 0, 1 / 0, 1 / 0)
e.Name = "bAV"

-- Fruit farming function
local function farmFruits()
    while screenGui.Parent do
        for f, fruit in next, workspace:GetChildren() do
            if fruit.Name:find("Fruit") and (fruit:IsA("Tool") or fruit:IsA("Model")) and fruit:FindFirstChild("Handle") then
                repeat
                    local bodyVelocity = d:Clone()
                    local bodyAngular = e:Clone()
                    bodyVelocity.Parent = b.HumanoidRootPart
                    bodyAngular.Parent = b.HumanoidRootPart
                    
                    local distance = (b.HumanoidRootPart.Position - fruit.Handle.Position).Magnitude
                    local tweenTime = math.max(0.5, (distance - 50) / 250)
                    
                    local tween = c:Create(
                        b.HumanoidRootPart,
                        TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
                        {CFrame = fruit.Handle.CFrame + Vector3.new(0, fruit.Handle.Size.Y + 3, 0)}
                    )
                    tween:Play()
                    tween.Completed:Wait()
                    
                    bodyVelocity:Destroy()
                    bodyAngular:Destroy()
                    wait(0.5)
                until fruit.Parent ~= workspace or not fruit:FindFirstChild("Handle")
                
                wait(1)
                local foundFruit = b:FindFirstChildOfClass("Tool") 
                if foundFruit and foundFruit.Name:find("Fruit") then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                        "StoreFruit",
                        foundFruit:GetAttribute("OriginalName") or foundFruit.Name,
                        foundFruit
                    )
                else
                    for _, tool in pairs(a.Backpack:GetChildren()) do
                        if tool.Name:find("Fruit") then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                                "StoreFruit",
                                tool:GetAttribute("OriginalName") or tool.Name,
                                tool
                            )
                            break
                        end
                    end
                end
            end
        end
        wait(2)
    end
end

-- Start fruit farming
task.spawn(farmFruits)

-- Server hop system (optimized)
local function serverHop()
    local placeId = game.PlaceId
    local servers = {}
    local cursor = ""
    local attempted = {}
    
    while screenGui.Parent do
        local success, result = pcall(function()
            local url
            if cursor == "" then
                url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"
            else
                url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor
            end
            
            local response = game:HttpGet(url)
            return game:GetService("HttpService"):JSONDecode(response)
        end)
        
        if success and result.data then
            for _, server in pairs(result.data) do
                if tonumber(server.playing) < tonumber(server.maxPlayers) and not attempted[tostring(server.id)] then
                    attempted[tostring(server.id)] = true
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, tostring(server.id), a)
                    end)
                    wait(5)
                end
            end
            
            if result.nextPageCursor and result.nextPageCursor ~= "null" then
                cursor = result.nextPageCursor
            else
                break
            end
        end
        wait(10)
    end
end

-- Auto server hop every 30 minutes
task.spawn(function()
    while screenGui.Parent do
        wait(1800) -- 30 minutes
        serverHop()
    end
end)

-- Character respawn handler
a.CharacterAdded:Connect(function(character)
    b = character
    wait(2) -- Wait for character to fully load
end)

statusLabel.Text = "🟢 STATUS: FRUIT FARMING ACTIVE"

print("HieuDRG Hub Kaitun - Fruit Farming Activated!")
print("Player: " .. player.Name)
print("UI Loaded Successfully with RGB Effects")
[file content end]
