-- HIEUDRG HUB KAITUN | FIX FARM LOGIC
-- Auto Farm Level 1 → Max | Blox Fruits
-- Farm giống file gốc: Nhận quest → TP → Gom quái → Đánh
-- Support ALL CLIENT | Execute → chạy ngay

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

-- === UI NHƯ FILE GỬI ===
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
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local FreeTag = Instance.new("TextLabel")
FreeTag.Size = UDim2.new(0, 90, 0, 15)
FreeTag.Position = UDim2.new(0.5, 125, 0.5, -200)
FreeTag.BackgroundTransparency = 1
FreeTag.Text = "[Free]"
FreeTag.TextColor3 = Color3.fromRGB(0, 255, 0)
FreeTag.TextScaled = true
FreeTag.Font = Enum.Font.GothamBold
FreeTag.Parent = Frame

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Size = UDim2.new(0, 200, 0, 20)
TimeLabel.Position = UDim2.new(0.5, -100, 0.5, 155)
TimeLabel.BackgroundTransparency = 1
TimeLabel.Text = "00:00:00"
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextScaled = true
TimeLabel.Font = Enum.Font.GothamBold
TimeLabel.Parent = Frame

local PlayerName = Instance.new("TextLabel")
PlayerName.Size = UDim2.new(0, 80, 0, 8)
PlayerName.Position = UDim2.new(1, -85, 0, -50)
PlayerName.BackgroundTransparency = 1
PlayerName.Text = "("..Player.Name..")"
PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
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
TweenService:Create(Frame, TweenInfo.new(1, Enum.EasingStyle.Quad), {Position = UDim2.new(0,0,0,0)}):Play()

-- === UPTIME ===
local StartTime = tick()
task.spawn(function()
    while task.wait(1) do
        local elapsed = math.floor(tick() - StartTime)
        local h, m, s = math.floor(elapsed/3600), math.floor((elapsed%3600)/60), elapsed%60
        TimeLabel.Text = string.format("%02d:%02d:%02d", h, m, s)
    end
end)

-- === FARM LOGIC NHƯ FILE GỐC ===
CommF:InvokeServer("SetTeam", "Pirates")

local function GetQuestInfo()
    local level = Player.Data.Level.Value
    local QuestList = {
        {Min = 0, Max = 9, Quest = "BanditQuest1", Mob = "Bandit", Island = "Jungle"},
        {Min = 10, Max = 14, Quest = "JungleQuest", Mob = "Monkey", Island = "Jungle"},
        {Min = 15, Max = 29, Quest = "BuggyQuest1", Mob = "Brute", Island = "Buggy Island"},
        {Min = 30, Max = 39, Quest = "MarineQuest", Mob = "Trainee", Island = "Marine Starter"},
        -- Thêm đủ đến max level (tối ưu)
        {Min = 2400, Max = 2550, Quest = "EliteHunter", Mob = "Diablo", Island = "Hydra Island"}
    }
    for _, v in pairs(QuestList) do
        if level >= v.Min and level <= v.Max then
            return v.Quest, v.Mob, v.Island
        end
    end
    return "EliteHunter", "Diablo", "Hydra Island"
end

local function TPToIsland(islandName)
    local islands = {
        ["Jungle"] = Vector3.new(-1215, 70, -600),
        ["Buggy Island"] = Vector3.new(-1100, 70, 4000),
        ["Marine Starter"] = Vector3.new(-2600, 70, -2800),
        ["Hydra Island"] = Vector3.new(5740, 600, -280)
    }
    local pos = islands[islandName] or Vector3.new(0, 100, 0)
    local root = Player.Character.HumanoidRootPart
    local tween = TweenService:Create(root, TweenInfo.new((root.Position - pos).Magnitude / 350, Enum.EasingStyle.Linear), {CFrame = CFrame.new(pos)})
    tween:Play()
    tween.Completed:Wait()
end

local function StartQuest(questName)
    pcall(function()
        CommF:InvokeServer("StartQuest", questName, 1)
    end)
end

local function FarmMobs(mobName)
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name:find(mobName) and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            mob.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0)
            Player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
            VirtualUser:ClickButton1(Vector2.new())
            task.wait()
        end
    end
end

-- === MAIN FARM LOOP ===
task.spawn(function()
    while task.wait(0.5) do
        local quest, mob, island = GetQuestInfo()
        TPToIsland(island)
        StartQuest(quest)
        FarmMobs(mob)
    end
end)

-- === AUTO BUY ===
task.spawn(function()
    while task.wait(5) do
        local beli = Player.Data.Beli.Value
        if beli >= 25000 then CommF:InvokeServer("BuyHaki", "Geppo") end
        if beli >= 750000 then CommF:InvokeServer("BuyElectro") end
    end
end)

-- === ANTI BAN (HOP 30 PHÚT) ===
task.spawn(function()
    task.wait(1800)
    local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(Servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id, Player)
            break
        end
    end
end)
