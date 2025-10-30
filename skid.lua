-- HieuDRG Hub Kaitun v1.0
-- Auto Farm Level 1 to Max for Blox Fruits
-- Based on provided source, with Fluent UI, RGB, Auto Buy, Anti Ban
-- Support HieuDRG Executor
-- WARNING: For private server testing only, risk of ban in public

-- Load Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Create Window
local Window = Fluent:CreateWindow({
    Title = "HieuDRG Hub Kaitun",
    SubTitle = "TRÙM IPA - Auto Farm Level 1 to Max",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.Insert
})

-- Tabs
local FarmTab = Window:AddTab({ Title = "Farm", Icon = "sword" })
local AutoBuyTab = Window:AddTab({ Title = "Auto Buy", Icon = "shopping-cart" })
local AntiTab = Window:AddTab({ Title = "Anti Ban", Icon = "shield" })
local StatsTab = Window:AddTab({ Title = "Stats", Icon = "user" })

-- RGB Animation Function
local function RGBAnimation(uiElement)
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.14, Color3.fromRGB(255, 165, 0)),
        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.56, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.84, Color3.fromRGB(75, 0, 130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    }
    UIGradient.Parent = uiElement

    task.spawn(function()
        while true do
            game:GetService("TweenService"):Create(UIGradient, TweenInfo.new(5, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1, 0)}):Play()
            wait(5)
            UIGradient.Offset = Vector2.new(1, 0)
        end
    end)
end

-- Apply RGB to Window (example on title bar or frame)
-- Assume Window has a Frame, apply to it
-- For simplicity, apply to a UIStroke or something

-- Global Variables
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF = Remotes.CommF_
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")

getgenv().team = "Pirates" -- From source

-- Anti Ban Variables
local AntiBanEnabled = false
local HopServerTime = 1800 -- 30 min
local StartTime = os.time()

-- Auto Farm Variables
local AutoFarmEnabled = false
local BringMobEnabled = true
local FastAttackEnabled = true

-- Auto Buy Variables
local AutoBuyEnabled = false

-- Stats Section
StatsTab:AddSection("Player Info")

local AvatarImage = StatsTab:AddImage("Avatar", {
    Image = game.Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420),
    Size = UDim2.new(0, 100, 0, 100)
})

local NameLabel = StatsTab:AddLabel("Name: " .. Player.Name)

local LevelLabel = StatsTab:AddLabel("Level: Loading...")

local MobLabel = StatsTab:AddLabel("Farming Mob: None")

local UptimeLabel = StatsTab:AddLabel("Uptime: 00:00:00")

local BeliLabel = StatsTab:AddLabel("Beli: Loading...")

local FragmentLabel = StatsTab:AddLabel("Fragment: Loading...")

local FightingStyleLabel = StatsTab:AddLabel("Fighting Style: Loading...")

local ClientLabel = StatsTab:AddLabel("Client: HieuDRG Executor")

local AntiStatusLabel = StatsTab:AddLabel("Anti Ban: Off")

-- Update Stats Loop
task.spawn(function()
    while true do
        LevelLabel:Update("Level: " .. Player.Data.Level.Value)
        BeliLabel:Update("Beli: " .. Player.Data.Beli.Value)
        FragmentLabel:Update("Fragment: " .. Player.Data.Fragments.Value)
        FightingStyleLabel:Update("Fighting Style: " .. Player.Data.FightingStyle.Value)
        local elapsed = os.time() - StartTime
        local h = math.floor(elapsed / 3600)
        local m = math.floor((elapsed % 3600) / 60)
        local s = elapsed % 60
        UptimeLabel:Update(string.format("Uptime: %02d:%02d:%02d", h, m, s))
        AntiStatusLabel:Update("Anti Ban: " .. (AntiBanEnabled and "On" or "Off"))
        wait(1)
    end
end)

-- Farm Tab
FarmTab:AddSection("Auto Farm Kaitun")

FarmTab:AddToggle("AutoFarm", { Title = "Auto Farm Level", Default = false }):OnChanged(function(value)
    AutoFarmEnabled = value
    if value then
        StartAutoFarm()
    end
end)

FarmTab:AddToggle("BringMob", { Title = "Gom Quái (Bring Mobs)", Default = true }):OnChanged(function(value)
    BringMobEnabled = value
end)

FarmTab:AddToggle("FastAttack", { Title = "Đánh Nhanh (Fast Attack)", Default = true }):OnChanged(function(value)
    FastAttackEnabled = value
end)

-- Auto Buy Tab
AutoBuyTab:AddSection("Auto Buy Items")

AutoBuyTab:AddToggle("AutoBuy", { Title = "Auto Buy Võ/Vật Phẩm", Default = false }):OnChanged(function(value)
    AutoBuyEnabled = value
    if value then
        StartAutoBuy()
    end
end)

-- Anti Tab
AntiTab:AddSection("Anti Ban/Kick/Reset")

AntiTab:AddToggle("AntiBan", { Title = "Anti Ban (Hop Server)", Default = false }):OnChanged(function(value)
    AntiBanEnabled = value
    if value then
        StartAntiBan()
    end
end)

AntiTab:AddSlider("HopTime", { Title = "Hop Server Sau (giây)", Min = 600, Max = 3600, Default = 1800, Rounding = 0 }):OnChanged(function(value)
    HopServerTime = value
end)

-- Functions from Source and Extended

-- Team Selection from Source
CommF:InvokeServer("SetTeam", getgenv().team)

-- Auto Farm Function
function StartAutoFarm()
    task.spawn(function()
        while AutoFarmEnabled do
            local level = Player.Data.Level.Value
            local quest, island, mob = GetCurrentQuest(level)
            if quest then
                -- Teleport to Island
                TeleportTo(island)
                -- Accept Quest
                AcceptQuest(quest)
                -- Farm Mobs
                FarmMobs(mob)
            end
            wait(1)
        end
    end)
end

-- Get Current Quest based on level (simplified, extend as needed)
function GetCurrentQuest(level)
    if level < 10 then
        return "Bandit Quest", "Starter Island", "Bandit"
    elseif level < 50 then
        return "Monkey Quest", "Jungle Island", "Monkey"
    -- Add more for all levels up to max (2550+)
    elseif level >= 2450 then
        return "Elite Hunter", "Sea 3", "Elite Boss"
    end
    return nil, nil, nil
end

-- Teleport Function from Source
function TeleportTo(position)
    local tweenInfo = TweenInfo.new((HumanoidRootPart.Position - position.Position).Magnitude / 300, Enum.EasingStyle.Linear)
    TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = position}):Play()
end

-- Accept Quest
function AcceptQuest(quest)
    CommF:InvokeServer("StartQuest", quest)
end

-- Farm Mobs
function FarmMobs(mobName)
    task.spawn(function()
        while AutoFarmEnabled do
            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if mob.Name:find(mobName) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    if BringMobEnabled then
                        BringMob(mob)
                    end
                    AttackMob(mob)
                end
            end
            wait(0.1)
        end
    end)
end

-- Bring Mob
function BringMob(mob)
    mob.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
end

-- Attack Mob
function AttackMob(mob)
    HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
    if FastAttackEnabled then
        VirtualUser:ClickButton1(Vector2.new())
    end
end

-- Auto Buy Function
function StartAutoBuy()
    task.spawn(function()
        while AutoBuyEnabled do
            local level = Player.Data.Level.Value
            local beli = Player.Data.Beli.Value
            local fragment = Player.Data.Fragments.Value
            -- Buy Fighting Styles
            if level >= 300 and beli >= 300000 then
                CommF:InvokeServer("BuyBlackLeg") -- Dark Step
            end
            if level >= 600 and beli >= 750000 then
                CommF:InvokeServer("BuyElectro") -- Electric
            end
            -- Add more: Water Kung Fu, Dragon Breath, Superhuman, Death Step, Sharkman Karate, Electric Claw, Dragon Talon, Godhuman
            -- Buy Swords
            if beli >= 25000 then
                CommF:InvokeServer("BuyKatana")
            end
            -- Add more: Cutlass, Dual Katana, Iron Mace, etc.
            -- Buy Accessories, Guns, etc.
            wait(5)
        end
    end)
end

-- Anti Ban Function (Hop Server from Source)
function StartAntiBan()
    task.spawn(function()
        while AntiBanEnabled do
            wait(HopServerTime)
            HopServer()
        end
    end)
end

-- Hop Server from Source
function HopServer()
    local PlaceID = game.PlaceId
    local AllIDs = {}
    local foundAnything = ""
    local actualHour = os.date("!*t").hour
    local Deleted = false
    local File = pcall(function()
        AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
    end)
    if not File then
        table.insert(AllIDs, actualHour)
        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
    end
    function TPReturner()
        local Site
        if foundAnything == "" then
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
        else
            Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
        end
        local ID = ""
        if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
            foundAnything = Site.nextPageCursor
        end
        local num = 0
        for i,v in pairs(Site.data) do
            local Possible = true
            ID = tostring(v.id)
            if tonumber(v.maxPlayers) > tonumber(v.playing) then
                for _,Existing in pairs(AllIDs) do
                    if num ~= 0 then
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    else
                        if tonumber(actualHour) ~= tonumber(Existing) then
                            local delFile = pcall(function()
                                delfile("NotSameServers.json")
                                AllIDs = {}
                                table.insert(AllIDs, actualHour)
                            end)
                        end
                    end
                    num = num + 1
                end
                if Possible == true then
                    table.insert(AllIDs, ID)
                    wait()
                    pcall(function()
                        writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                        wait()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end

    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end

-- Loading UI from Source
-- Add the loading screen code here
-- ... (paste the source UI code)

-- Initial Notification
Fluent:Notify({
    Title = "HieuDRG Hub Kaitun",
    Content = "Loaded! Press Insert to toggle UI.",
    Duration = 5
})

-- Apply RGB to some UI element (example)
-- RGBAnimation(Window.Frame) -- Assume Frame exists
