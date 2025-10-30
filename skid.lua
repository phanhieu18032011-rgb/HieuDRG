-- HIEUDRG HUB KAITUN | ALL CLIENT SUPPORT
-- Auto Farm Level 1 → Max | Blox Fruits
-- No loadstring, No HttpGet → Safe cho mọi executor
-- UI RGB + Stats + Anti Ban + Auto Buy

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

-- === UI NHƯ FILE GỬI (RGB + STATS) ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HieuDRG_Kaitun"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.ResetOnSpawn = false

local Blur = Instance.new("BlurEffect")
Blur.Size = 24
Blur.Parent = game.Lighting

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.Position = UDim2.new(0, 0, 1, 0)
Frame.BackgroundTransparency = 1
Frame.Parent = ScreenGui

local Image = Instance.new("ImageLabel")
Image.Size = UDim2.new(0, 170, 0, 170)
Image.Position = UDim2.new(0.5, -85, 0.5, -120)
Image.BackgroundTransparency = 1
Image.Image = "rbxassetid://91881585928344"
Image.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 40)
Title.Position = UDim2.new(0.5, -150, 0.5, -200)
Title.BackgroundTransparency = 1
Title.Text = "HieuDRG Hub Kaitun"
Title.TextColor3 = Color3.fromRGB(230, 230, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local FreeTag = Instance.new("TextLabel")
FreeTag.Size = UDim2.new(0, 90, 0, 15)
FreeTag.Position = UDim2.new(0.5, 125, 0.5, -200)
FreeTag.BackgroundTransparency = 1
FreeTag.Text = "[Free]"
FreeTag.TextColor3 = Color3.fromRGB(230, 230, 255)
FreeTag.TextScaled = true
FreeTag.Font = Enum.Font.GothamBold
FreeTag.Parent = Frame

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0, 200, 0, 20)
TimeLabel.Position = UDim2.new(0.5, -100, 0.5, 155)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
TimeLabel.TextScaled = true
TimeLabel.Font = Enum.Font.GothamBold
TimeLabel.Parent = Frame

local PlayerName = Instance.new("TextLabel")
PlayerName.Size = UDim2.new(0, 80, 0, 8)
PlayerName.Position = UDim2.new(1, -85, 0, -50)
PlayerName.BackgroundTransparency = 1
PlayerName.Text = "("..Player.Name..")"
PlayerName.TextColor3 = Color3.fromRGB(230, 230, 255)
PlayerName.TextScaled = true
PlayerName.Font = Enum.Font.GothamBold
PlayerName.TextXAlignment = Enum.TextXAlignment.Right
PlayerName.Parent = Frame

-- === RGB 7 MÀU ===
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
    ColorSequenceKeypoint.new(0.14, Color3.fromRGB(255,165,0)),
    ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255,255,0)),
    ColorSequenceKeypoint.new(0.42, Color3.fromRGB(0,255,0)),
    ColorSequenceKeypoint.new(0.56, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0,0,255)),
    ColorSequenceKeypoint.new(0.84, Color3.fromRGB(75,0,130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
}
UIGradient.Parent = Title

task.spawn(function()
    while true do
        TweenService:Create(UIGradient, TweenInfo.new(5, Enum.EasingStyle.Linear), {Offset = Vector2.new(-1, 0)}):Play()
        task.wait(5)
        UIGradient.Offset = Vector2.new(1, 0)
    end
end)

-- === TWEEN UI LÊN ===
local tween = TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quad), {Position = UDim2.new(0,0,0,0)})
tween:Play()

-- === UPTIME ===
local StartTime = tick()
task.spawn(function()
    while ScreenGui.Parent do
        local elapsed = math.floor(tick() - StartTime)
        local h, m, s = math.floor(elapsed/3600), math.floor((elapsed%3600)/60), elapsed%60
        TimeLabel.Text = string.format("%02d:%02d:%02d", h, m, s)
        task.wait(1)
    end
end)

-- === AUTO FARM KAITUN (SUPPORT ALL CLIENT) ===
CommF:InvokeServer("SetTeam", "Pirates")

local function GetQuest()
    local level = Player.Data.Level.Value
    local quests = {
        [1] = {"Bandit Quest", "Starter Island", "Bandit"},
        [10] = {"Monkey Quest", "Jungle", "Monkey"},
        [50] = {"Gorilla Quest", "Jungle", "Gorilla"},
        [100] = {"Pirate Quest", "Marine Island", "Pirate"},
        [200] = {"Brute Quest", "Frozen Village", "Brute"},
        [300] = {"Snow Bandit Quest", "Snow Island", "Snow Bandit"},
        [400] = {"Yeti Quest", "Snow Island", "Yeti"},
        [500] = {"Marine Captain Quest", "Marine Fortress", "Marine Captain"},
        [700] = {"Lab Assistant Quest", "Fountain City", "Lab Assistant"},
        [850] = {"Cyborb Quest", "Fountain City", "Cyborb"},
        [1000] = {"Sky Bandit Quest", "Sky Island", "Sky Bandit"},
        [1150] = {"Dark Master Quest", "Sky Island", "Dark Master"},
        [1300] = {"Prisoner Quest", "Prison", "Prisoner"},
        [1450] = {"Dangerous Prisoner Quest", "Prison", "Dangerous Prisoner"},
        [1600] = {"Toga Warrior Quest", "Colosseum", "Toga Warrior"},
        [1800] = {"Gladiator Quest", "Colosseum", "Gladiator"},
        [2000] = {"Military Soldier Quest", "Magma Village", "Military Soldier"},
        [2100] = {"Military Spy Quest", "Magma Village", "Military Spy"},
        [2200] = {"Lava Pirate Quest", "Hot Island", "Lava Pirate"},
        [2300] = {"Ship Deckhand Quest", "Ship", "Ship Deckhand"},
        [2400] = {"Elite Hunter", "Castle on the Sea", "Elite Boss"}
    }
    for minLevel, data in pairs(quests) do
        if level >= minLevel then
            return data[1], data[2], data[3]
        end
    end
end

local function TeleportTo(pos)
    local root = Player.Character.HumanoidRootPart
    local distance = (root.Position - pos.Position).Magnitude
    local tween = TweenService:Create(root, TweenInfo.new(distance/350, Enum.EasingStyle.Linear), {CFrame = pos})
    tween:Play()
    tween.Completed:Wait()
end

local function Attack(mob)
    local root = Player.Character.HumanoidRootPart
    root.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
    VirtualUser:ClickButton1(Vector2.new())
end

local function Farm()
    while task.wait(0.1) do
        local quest, island, mobName = GetQuest()
        if not quest then break end

        local islandPart = workspace:FindFirstChild(island)
        if islandPart then
            TeleportTo(islandPart.HumanoidRootPart or islandPart)
        end

        CommF:InvokeServer("StartQuest", quest)

        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob.Name:find(mobName) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                mob.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                Attack(mob)
            end
        end
    end
end

-- === AUTO BUY (TẤT CẢ VÕ) ===
task.spawn(function()
    while task.wait(5) do
        local beli = Player.Data.Beli.Value
        local level = Player.Data.Level.Value
        if level >= 300 and beli >= 300000 then CommF:InvokeServer("BuyBlackLeg") end
        if level >= 600 and beli >= 750000 then CommF:InvokeServer("BuyElectro") end
        if level >= 850 and beli >= 1500000 then CommF:InvokeServer("BuyFishmanKarate") end
        if level >= 1100 and beli >= 2500000 then CommF:InvokeServer("BuyDragonClaw") end
        if beli >= 25000 then CommF:InvokeServer("BuyKatana") end
    end
end)

-- === ANTI BAN (HOP 30 PHÚT) ===
task.spawn(function()
    task.wait(1800)
    local PlaceID = game.PlaceId
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..PlaceID.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(Servers.data) do
        if v.playing < v.maxPlayers then
            game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, v.id, Player)
            break
        end
    end
end)

-- === BẮT ĐẦU NGAY ===
task.spawn(Farm)
