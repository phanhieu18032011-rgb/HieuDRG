-- SHADOW CORE AI - BLOX FRUITS LEVEL FARMER
-- ADVANCED NPC & BOSS FARMING SYSTEM

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualInput = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- CONFIGURATION
local Config = {
    Enabled = false,
    FarmMode = "NPC", -- "NPC" or "BOSS"
    SelectedBoss = "Saber Expert",
    AutoQuest = true,
    AutoSellFruits = true,
    AutoStoreFruits = true,
    HopIfLowPlayer = true,
    AntiAFK = true,
    WebhookURL = ""
}

-- NPC DATABASE BY SEA
local NPCDatabase = {
    ["First Sea"] = {
        {Name = "Bandit", Level = 5, Quest = "BanditQuest1"},
        {Name = "Monkey", Level = 10, Quest = "JungleQuest"},
        {Name = "Gorilla", Level = 15, Quest = "JungleQuest"},
        {Name = "Pirate", Level = 20, Quest = "BuggyQuest1"},
        {Name = "Brute", Level = 30, Quest = "BuggyQuest2"},
        {Name = "Desert Bandit", Level = 40, Quest = "DesertQuest"},
        {Name = "Desert Officer", Level = 50, Quest = "DesertQuest"},
        {Name = "Snow Bandit", Level = 60, Quest = "SnowQuest"},
        {Name = "Snowman", Level = 70, Quest = "SnowQuest"},
        {Name = "Chief Petty Officer", Level = 80, Quest = "MarineQuest2"},
        {Name = "Sky Bandit", Level = 90, Quest = "SkyQuest"},
        {Name = "Dark Master", Level = 100, Quest = "SkyQuest"}
    },
    ["Second Sea"] = {
        {Name = "Pirate Millionaire", Level = 150, Quest = "PiratePortQuest"},
        {Name = "Dragon Crew Warrior", Level = 175, Quest = "AmazonQuest1"},
        {Name = "Dragon Crew Archer", Level = 190, Quest = "AmazonQuest1"},
        {Name = "Female Islander", Level = 200, Quest = "AmazonQuest2"},
        {Name = "Giant Islander", Level = 210, Quest = "AmazonQuest2"},
        {Name = "Marine Captain", Level = 225, Quest = "MarineTreeQuest"},
        {Name = "Galley Pirate", Level = 240, Quest = "DeepForestQuest1"}
    },
    ["Third Sea"] = {
        {Name = "Mercenary", Level = 300, Quest = "Area1Quest"},
        {Name = "Swan Pirate", Level = 350, Quest = "Area2Quest"},
        {Name = "Factory Staff", Level = 400, Quest = "FishmanQuest"},
        {Name = "Marine Lieutenant", Level = 450, Quest = "MarineQuest3"}
    }
}

-- BOSS DATABASE
local BossDatabase = {
    "Saber Expert",
    "The Saw", 
    "Greybeard",
    "Darkbeard",
    "Order",
    "Cursed Captain",
    "Beautiful Pirate",
    "Stone",
    "Island Empress",
    "Kilo Admiral",
    "Captain Elephant"
}

-- GAME STATE
local GameState = {
    CurrentSea = "First Sea",
    PlayerLevel = 1,
    CurrentNPC = nil,
    IsBusy = false,
    QuestActive = false
}

-- TARGET CACHE
local TargetCache = {}
local KillCount = 0
local StartTime = os.time()

-- DETECT CURRENT SEA
function GetCurrentSea()
    local map = Workspace:FindFirstChild("Map")
    if map then
        if map:FindFirstChild("IceCastle") then
            return "First Sea"
        elseif map:FindFirstChild("Mansion") then
            return "Second Sea" 
        elseif map:FindFirstChild("Hydra") then
            return "Third Sea"
        end
    end
    return "First Sea"
end

-- GET PLAYER LEVEL
function GetPlayerLevel()
    local leaderstats = Player:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild("Level") then
        return leaderstats.Level.Value
    end
    return 1
end

-- FIND OPTIMAL NPC
function FindOptimalNPC()
    local currentLevel = GetPlayerLevel()
    local currentSea = GetCurrentSea()
    local availableNPCs = NPCDatabase[currentSea] or NPCDatabase["First Sea"]
    
    local optimalNPC = nil
    for _, npcData in pairs(availableNPCs) do
        if npcData.Level <= currentLevel + 50 then
            if optimalNPC == nil or npcData.Level > optimalNPC.Level then
                optimalNPC = npcData
            end
        end
    end
    
    return optimalNPC or availableNPCs[1]
end

-- SCAN FOR ENEMIES
function ScanEnemies(targetName)
    local enemies = {}
    
    -- Check workspace enemies
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                if string.find(enemy.Name:lower(), targetName:lower()) then
                    table.insert(enemies, {
                        Object = enemy,
                        Position = enemy:FindFirstChild("HumanoidRootPart").Position,
                        Distance = (Player.Character.HumanoidRootPart.Position - enemy:FindFirstChild("HumanoidRootPart").Position).Magnitude
                    })
                end
            end
        end
    end
    
    -- Check NPCs in workspace
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            if string.find(npc.Name:lower(), targetName:lower()) then
                table.insert(enemies, {
                    Object = npc,
                    Position = npc:FindFirstChild("HumanoidRootPart").Position,
                    Distance = (Player.Character.HumanoidRootPart.Position - npc:FindFirstChild("HumanoidRootPart").Position).Magnitude
                })
            end
        end
    end
    
    -- Sort by distance
    table.sort(enemies, function(a, b)
        return a.Distance < b.Distance
    end)
    
    return enemies
end

-- SMART MOVEMENT SYSTEM
function MoveToPosition(position)
    local character = Player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    -- Use pathfinding or direct movement
    humanoid:MoveTo(position)
    
    -- Wait for arrival with timeout
    local startTime = os.time()
    while (rootPart.Position - position).Magnitude > 15 do
        if os.time() - startTime > 10 then
            return false
        end
        task.wait(0.1)
    end
    
    return true
end

-- AUTO ATTACK SYSTEM
function AttackTarget(target)
    local character = Player.Character
    if not character then return false end
    
    -- Move to attack range
    local attackPosition = target.Position + (target.Position - character.HumanoidRootPart.Position).Unit * 10
    MoveToPosition(attackPosition)
    
    -- Spam attack keys
    local attackKeys = {"X", "Z", "C", "V", "F"}
    for _, key in pairs(attackKeys) do
        VirtualInput:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VirtualInput:SendKeyEvent(false, key, false, game)
    end
    
    return true
end

-- QUEST AUTOMATION
function AcceptQuest(questName)
    local npc = FindNPCForQuest(questName)
    if npc then
        MoveToPosition(npc.HumanoidRootPart.Position)
        task.wait(1)
        
        -- Click on NPC to accept quest
        fireclickdetector(npc:FindFirstChild("ClickDetector"))
        return true
    end
    return false
end

function FindNPCForQuest(questName)
    for _, npc in pairs(Workspace:GetChildren()) do
        if npc:FindFirstChild("ClickDetector") then
            if string.find(npc.Name:lower(), questName:lower()) then
                return npc
            end
        end
    end
    return nil
end

-- MAIN FARMING LOOP
function FarmingLoop()
    while Config.Enabled do
        if not Player.Character or Player.Character.Humanoid.Health <= 0 then
            task.wait(5)
            continue
        end
        
        GameState.PlayerLevel = GetPlayerLevel()
        GameState.CurrentSea = GetCurrentSea()
        
        if Config.FarmMode == "NPC" then
            -- NPC FARMING MODE
            local targetNPC = FindOptimalNPC()
            GameState.CurrentNPC = targetNPC
            
            -- Accept quest if needed
            if Config.AutoQuest and not GameState.QuestActive then
                AcceptQuest(targetNPC.Quest)
                task.wait(2)
            end
            
            -- Find and attack enemies
            local enemies = ScanEnemies(targetNPC.Name)
            
            if #enemies > 0 then
                local target = enemies[1]
                AttackTarget(target)
                
                -- Wait for enemy death
                local startWait = os.time()
                while target.Object and target.Object:FindFirstChild("Humanoid") and target.Object.Humanoid.Health > 0 do
                    if os.time() - startWait > 30 then
                        break -- Timeout
                    end
                    AttackTarget(target)
                    task.wait(0.5)
                end
                
                KillCount = KillCount + 1
            else
                -- No enemies found, explore
                local randomPos = Player.Character.HumanoidRootPart.Position + Vector3.new(
                    math.random(-100, 100),
                    0,
                    math.random(-100, 100)
                )
                MoveToPosition(randomPos)
            end
            
        else
            -- BOSS FARMING MODE
            local bosses = ScanEnemies(Config.SelectedBoss)
            
            if #bosses > 0 then
                local boss = bosses[1]
                AttackTarget(boss)
            else
                -- Boss not found, wait or change position
                task.wait(5)
            end
        end
        
        task.wait(0.5)
    end
end

-- ANTI-AFK SYSTEM
function SetupAntiAFK()
    while true do
        if Config.AntiAFK and Config.Enabled then
            VirtualInput:SendKeyEvent(true, "W", false, game)
            task.wait(1)
            VirtualInput:SendKeyEvent(false, "W", false, game)
            VirtualInput:SendKeyEvent(true, "S", false, game)
            task.wait(1)
            VirtualInput:SendKeyEvent(false, "S", false, game)
        end
        task.wait(30)
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

-- ADVANCED UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Shadow Core - Blox Fruits Farmer", "DarkTheme")

-- MAIN TAB
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Auto Farm Controls")

MainSection:NewToggle("Enable Auto Farm", "Start/Stop Auto Farming", function(state)
    Config.Enabled = state
    if state then
        StartTime = os.time()
        KillCount = 0
        FarmingLoop()
        Library:Notify("Auto Farm", "Started Auto Farming!", "ok")
    else
        Library:Notify("Auto Farm", "Stopped Auto Farming!", "ok")
    end
end)

MainSection:NewDropdown("Farm Mode", {"NPC", "BOSS"}, function(mode)
    Config.FarmMode = mode
end)

MainSection:NewDropdown("Select Boss", BossDatabase, function(boss)
    Config.SelectedBoss = boss
end)

-- SETTINGS TAB
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("Farm Settings")

SettingsSection:NewToggle("Auto Accept Quest", "Auto accept quests", function(state)
    Config.AutoQuest = state
end)

SettingsSection:NewToggle("Auto Sell Fruits", "Auto sell fruits", function(state)
    Config.AutoSellFruits = state
end)

SettingsSection:NewToggle("Anti AFK", "Prevent AFK detection", function(state)
    Config.AntiAFK = state
end)

-- STATS TAB
local StatsTab = Window:NewTab("Statistics")
StatsSection = StatsTab:NewSection("Farming Stats")

StatsSection:NewLabel("Kills: 0")
StatsSection:NewLabel("Time: 0s")
StatsSection:NewLabel("Current NPC: None")
StatsSection:NewLabel("Player Level: 1")

-- AUTO UPDATE STATS
RunService.Heartbeat:Connect(function()
    if Config.Enabled then
        local timeElapsed = os.time() - StartTime
        local minutes = math.floor(timeElapsed / 60)
        local seconds = timeElapsed % 60
        
        pcall(function()
            StatsTab:UpdateSection("Farming Stats", {
                "Kills: " .. KillCount,
                "Time: " .. string.format("%02d:%02d", minutes, seconds),
                "Current NPC: " .. (GameState.CurrentNPC and GameState.CurrentNPC.Name or "None"),
                "Player Level: " .. GameState.PlayerLevel
            })
        end)
    end
end)

-- START ANTI-AFK
task.spawn(SetupAntiAFK)

-- INITIALIZE
Library:Notify("Shadow Core AI", "Blox Fruits Farmer Loaded!", "ok")
