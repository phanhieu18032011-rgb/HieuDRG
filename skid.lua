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

-- Đợi UI load xong rồi mới start farm
task.wait(2)

-- MAIN FRUIT FARMING CODE
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Đảm bảo character tồn tại
local function waitForCharacter()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    return LocalPlayer.Character
end

local Character = waitForCharacter()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Fruit farming function
local function farmFruits()
    while screenGui and screenGui.Parent do
        pcall(function()
            for _, obj in pairs(workspace:GetChildren()) do
                if obj and (obj:IsA("Tool") or obj:IsA("Model")) and obj.Name:find("Fruit") then
                    local handle = obj:FindFirstChild("Handle")
                    if handle then
                        statusLabel.Text = "🟡 STATUS: GOING TO FRUIT"
                        
                        -- Di chuyển đến fruit
                        local tweenInfo = TweenInfo.new(
                            (HumanoidRootPart.Position - handle.Position).Magnitude / 100, 
                            Enum.EasingStyle.Linear
                        )
                        local tween = TweenService:Create(
                            HumanoidRootPart,
                            tweenInfo,
                            {CFrame = handle.CFrame + Vector3.new(0, 3, 0)}
                        )
                        tween:Play()
                        tween.Completed:Wait()
                        
                        -- Chờ pickup fruit
                        task.wait(1)
                        
                        -- Tìm fruit trong backpack hoặc character
                        local foundFruit
                        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                            if tool.Name:find("Fruit") then
                                foundFruit = tool
                                break
                            end
                        end
                        
                        if not foundFruit then
                            for _, tool in pairs(Character:GetChildren()) do
                                if tool:IsA("Tool") and tool.Name:find("Fruit") then
                                    foundFruit = tool
                                    break
                                end
                            end
                        end
                        
                        -- Store fruit
                        if foundFruit then
                            statusLabel.Text = "🔵 STATUS: STORING FRUIT"
                            local fruitName = foundFruit:GetAttribute("OriginalName") or foundFruit.Name
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(
                                "StoreFruit",
                                fruitName,
                                foundFruit
                            )
                            task.wait(1)
                        end
                    end
                end
            end
        end)
        
        statusLabel.Text = "🟢 STATUS: SEARCHING FRUITS"
        task.wait(3) -- Chờ 3 giây trước khi scan lại
    end
end

-- Start fruit farming
task.spawn(farmFruits)

-- Server hop system (đơn giản hóa)
local function simpleServerHop()
    local placeId = game.PlaceId
    
    while screenGui and screenGui.Parent do
        task.wait(1800) -- Chờ 30 phút
        
        pcall(function()
            statusLabel.Text = "🟠 STATUS: SERVER HOPPING"
            
            local servers = {}
            local cursor = ""
            
            for i = 1, 3 do -- Thử 3 lần
                local url
                if cursor == "" then
                    url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=25"
                else
                    url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=25&cursor=" .. cursor
                end
                
                local response = game:HttpGet(url)
                local data = game:GetService("HttpService"):JSONDecode(response)
                
                if data and data.data then
                    for _, server in pairs(data.data) do
                        if tonumber(server.playing) < tonumber(server.maxPlayers) - 2 then
                            table.insert(servers, tostring(server.id))
                        end
                    end
                    
                    if data.nextPageCursor and data.nextPageCursor ~= "null" then
                        cursor = data.nextPageCursor
                    else
                        break
                    end
                end
                
                task.wait(1)
            end
            
            -- Thử teleport đến server
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, randomServer, LocalPlayer)
            end
        end)
    end
end

-- Start server hop
task.spawn(simpleServerHop)

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(character)
    Character = character
    HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
    task.wait(2) -- Wait for character to fully load
    statusLabel.Text = "🟢 STATUS: CHARACTER RESPAWNED"
end)

-- Anti AFK
local VirtualInputManager = game:GetService("VirtualInputManager")
task.spawn(function()
    while screenGui and screenGui.Parent do
        VirtualInputManager:SendKeyEvent(true, "Space", false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, "Space", false, game)
        task.wait(29) -- Mỗi 30 giây
    end
end)

print("========================================")
print("HIEUDRG HUB KAITUN - ACTIVATED SUCCESS!")
print("Player: " .. player.Name)
print("RGB UI: ENABLED")
print("Fruit Farm: ENABLED")
print("Server Hop: ENABLED")
print("========================================")
[file content end]
