-- SHADOW CORE AI - DELTA OPTIMIZED CHEST FARMER
-- BYPASS ANTI-CHEAT + MEMORY OPTIMIZED

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local TS = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- DELTA STEALTH INIT
getgenv().SecureMode = true
local originalNamecall
local Detected = false

-- ANTI-DETECTION SYSTEM
local function DeltaStealth()
    if not originalNamecall then
        originalNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return nil
            end
            return originalNamecall(self, ...)
        end)
    end
    
    -- Fake environment
    getrenv().identifyexecutor = function() return "Microsoft Edge" end
    setupvalue(wait, 1, function() return true end)
end

-- CONFIGURATION
local Config = {
    Enabled = false,
    SearchRadius = 1000,
    ChestTypes = {"Common", "Uncommon", "Rare", "Legendary"},
    AutoHop = true,
    Webhook = "",
    HopAfter = 30, -- minutes
    StartTime = 0
}

local ChestCache = {}
local CurrentChest = nil
local Connection

-- CHEST DETECTION ENGINE
function ScanChests()
    local chests = {}
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return chests end
    
    local rootPart = character.HumanoidRootPart
    
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "Chest" and obj:IsA("Model") then
            local chest = obj
            local distance = (rootPart.Position - chest:GetPivot().Position).Magnitude
            
            if distance <= Config.SearchRadius then
                if not ChestCache[chest] then
                    table.insert(chests, {
                        Object = chest,
                        Position = chest:GetPivot().Position,
                        Distance = distance
                    })
                    ChestCache[chest] = true
                end
            end
        end
    end
    
    table.sort(chests, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return chests
end

-- PATHFINDING OPTIMIZED FOR DELTA
function MoveToPosition(position)
    local character = Player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- Simple movement for Delta compatibility
    local distance = (rootPart.Position - position).Magnitude
    local steps = math.floor(distance / 10)
    
    for i = 1, steps do
        if not Config.Enabled then break end
        
        local tween = TS:Create(
            rootPart,
            TweenInfo.new(0.1, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(rootPart.Position:Lerp(position, i/steps))}
        )
        tween:Play()
        task.wait(0.1)
    end
    
    rootPart.CFrame = CFrame.new(position)
    return true
end

-- CHEST INTERACTION
function OpenChest(chest)
    if not chest or not chest:FindFirstChild("ClickDetector") then return false end
    
    local clickDetector = chest.ClickDetector
    local humanoid = Player.Character:FindFirstChild("Humanoid")
    
    if humanoid then
        -- Simulate click
        fireclickdetector(clickDetector)
        task.wait(1)
        return true
    end
    
    return false
end

-- MAIN FARMING LOOP
function FarmLoop()
    while Config.Enabled and task.wait(0.5) do
        if Detected then
            warn("Anti-Cheat Detected! Stopping...")
            Config.Enabled = false
            break
        end
        
        local chests = ScanChests()
        
        if #chests > 0 then
            CurrentChest = chests[1]
            
            -- Move to chest
            local success = pcall(function()
                MoveToPosition(CurrentChest.Position + Vector3.new(0, 3, 0))
            end)
            
            if success then
                task.wait(0.5)
                OpenChest(CurrentChest.Object)
                task.wait(1) -- Cooldown between chests
            end
        else
            -- No chests found, random movement to avoid AFK
            local randomPos = Player.Character.HumanoidRootPart.Position + 
                            Vector3.new(
                                math.random(-50, 50),
                                0,
                                math.random(-50, 50)
                            )
            MoveToPosition(randomPos)
        end
        
        -- Auto server hop
        if Config.AutoHop and os.time() - Config.StartTime > (Config.HopAfter * 60) then
            ServerHop()
        end
    end
end

-- SERVER HOP FUNCTION
function ServerHop()
    local servers = {}
    local success, result = pcall(function()
        return game:GetService("HttpService"):JSONDecode(
            game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100")
        )
    end)
    
    if success and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
        
        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId,
                servers[math.random(1, #servers)]
            )
        end
    end
end

-- DELTA UI CREATION
local DeltaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = DeltaUI:MakeWindow({
    Name = "DELTA CHEST FARMER v3.0",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "DeltaChestFarmer",
    IntroEnabled = false
})

-- MAIN TAB
local MainTab = Window:MakeTab({
    Name = "🔄 Auto Farm",
    Icon = "rbxassetid://7733960981",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Kích Hoạt Auto Farm",
    Default = false,
    Callback = function(Value)
        Config.Enabled = Value
        if Value then
            Config.StartTime = os.time()
            DeltaStealth()
            FarmLoop()
        end
    end
})

MainTab:AddSlider({
    Name = "Bán Kính Tìm Kiếm",
    Min = 100,
    Max = 2000,
    Default = 1000,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 50,
    ValueName = "studs",
    Callback = function(Value)
        Config.SearchRadius = Value
    end
})

MainTab:AddToggle({
    Name = "Tự Động Đổi Server",
    Default = true,
    Callback = function(Value)
        Config.AutoHop = Value
    end
})

MainTab:AddSlider({
    Name = "Thời Gian Đổi Server",
    Min = 10,
    Max = 120,
    Default = 30,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 5,
    ValueName = "phút",
    Callback = function(Value)
        Config.HopAfter = Value
    end
})

-- SETTINGS TAB
local SettingsTab = Window:MakeTab({
    Name = "⚙️ Cài Đặt",
    Icon = "rbxassetid://7733674099",
    PremiumOnly = false
})

SettingsTab:AddButton({
    Name = "Kích Hoạt Stealth Mode",
    Callback = function()
        DeltaStealth()
        OrionLib:MakeNotification({
            Name = "STEALTH MODE",
            Content = "Đã kích hoạt chế độ ẩn!",
            Image = "rbxassetid://7733682681",
            Time = 5
        })
    end
})

SettingsTab:AddTextbox({
    Name = "Webhook URL",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        Config.Webhook = Value
    end
})

SettingsTab:AddButton({
    Name = "Server Hop Ngay",
    Callback = function()
        ServerHop()
    end
})

SettingsTab:AddButton({
    Name = "Dọn Cache Chest",
    Callback = function()
        ChestCache = {}
        OrionLib:MakeNotification({
            Name = "CACHE CLEARED",
            Content = "Đã xóa cache chest!",
            Image = "rbxassetid://7733682681",
            Time = 3
        })
    end
})

-- STATS TAB
local StatsTab = Window:MakeTab({
    Name = "📊 Thống Kê",
    Icon = "rbxassetid://7733960981",
    PremiumOnly = false
})

StatsTab:AddLabel("Trạng Thái: Đang chờ...")
StatsTab:AddLabel("Chest Found: 0")
StatsTab:AddLabel("Thời Gian: 00:00")

-- INITIALIZE
DeltaStealth()
OrionLib:Init()

-- AUTO-UPDATE STATS
RunService.Heartbeat:Connect(function()
    if Config.Enabled then
        local chests = ScanChests()
        local timeElapsed = os.time() - Config.StartTime
        local minutes = math.floor(timeElapsed / 60)
        local seconds = timeElapsed % 60
        
        pcall(function()
            Window:UpdateTab("📊 Thống Kê", {
                "Trạng Thái: Đang chạy...",
                "Chest Found: " .. #chests,
                "Thời Gian: " .. string.format("%02d:%02d", minutes, seconds)
            })
        end)
    end
end)

OrionLib:MakeNotification({
    Name = "DELTA CHEST FARMER",
    Content = "Đã sẵn sàng! Kích hoạt Stealth Mode trước khi farm!",
    Image = "rbxassetid://7733682681",
    Time = 5
})
