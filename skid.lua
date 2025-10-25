-- SHADOW CORE AI - 99 NIGHTS IN THE FOREST
-- ADVANCED ITEM FARMING & COLLECTION SYSTEM

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- CONFIGURATION
local Config = {
    Enabled = false,
    FarmRadius = 500,
    ItemWhitelist = {"Wood", "Stone", "Berry", "Mushroom", "Flower", "Herb"},
    PriorityItems = {"Berry", "Mushroom"}, -- Items to target first
    AutoAvoidEnemies = true,
    NightRetreat = true,
    SaveInventory = true,
    WebhookURL = "" -- Discord webhook for notifications
}

-- ITEM DATABASE
local ItemDatabase = {
    Wood = {
        Name = "Wood",
        Type = "Resource",
        Priority = 2,
        Models = {"Log", "Wood", "Tree"},
        Value = 1
    },
    Stone = {
        Name = "Stone", 
        Type = "Resource",
        Priority = 2,
        Models = {"Rock", "Stone", "Boulder"},
        Value = 1
    },
    Berry = {
        Name = "Berry",
        Type = "Food",
        Priority = 1,
        Models = {"Berry", "Bush", "BerryBush"},
        Value = 2
    },
    Mushroom = {
        Name = "Mushroom",
        Type = "Food", 
        Priority = 1,
        Models = {"Mushroom", "Fungus"},
        Value = 3
    },
    Flower = {
        Name = "Flower",
        Type = "Crafting",
        Priority = 3,
        Models = {"Flower", "Rose", "Daisy"},
        Value = 2
    },
    Herb = {
        Name = "Herb",
        Type = "Healing",
        Priority = 2,
        Models = {"Herb", "Leaf", "Plant"},
        Value = 3
    }
}

-- GAME STATE TRACKING
local GameState = {
    CurrentNight = 1,
    IsNight = false,
    PlayerHealth = 100,
    Inventory = {},
    Enemies = {},
    SafeZone = nil
}

-- ITEM CACHE
local ItemCache = {}
local CollectedItems = 0
local StartTime = os.time()

-- ENEMY DETECTION
function ScanEnemies()
    local enemies = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
            if obj:FindFirstChild("Head") and obj.Name ~= Player.Character.Name then
                local isEnemy = string.find(obj.Name:lower(), "enemy") or 
                               string.find(obj.Name:lower(), "monster") or
                               string.find(obj.Name:lower(), "creature") or
                               obj:FindFirstChild("EnemyTag")
                
                if isEnemy then
                    table.insert(enemies, {
                        Object = obj,
                        Position = obj.PrimaryPart.Position,
                        Distance = (Player.Character.HumanoidRootPart.Position - obj.PrimaryPart.Position).Magnitude
                    })
                end
            end
        end
    end
    
    return enemies
end

-- SMART ITEM SCANNING WITH PRIORITY SYSTEM
function ScanItems()
    local items = {}
    local character = Player.Character
    if not character then return items end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return items end

    -- Scan for collectible items
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("UnionOperation") then
            local distance = (rootPart.Position - obj.Position).Magnitude
            
            if distance <= Config.FarmRadius then
                -- Check if object matches item database
                for itemName, itemData in pairs(ItemDatabase) do
                    for _, modelName in pairs(itemData.Models) do
                        if string.find(obj.Name:lower(), modelName:lower()) or 
                           string.find(obj.Parent.Name:lower(), modelName:lower()) then
                            
                            if not ItemCache[obj] then
                                table.insert(items, {
                                    Object = obj,
                                    Type = itemName,
                                    Position = obj.Position,
                                    Distance = distance,
                                    Priority = itemData.Priority,
                                    Value = itemData.Value
                                })
                                ItemCache[obj] = true
                            end
                        end
                    end
                end
                
                -- Check for click detectors (interactive items)
                if obj:FindFirstChild("ClickDetector") and distance < 20 then
                    if not ItemCache[obj] then
                        table.insert(items, {
                            Object = obj,
                            Type = "Interactive",
                            Position = obj.Position,
                            Distance = distance,
                            Priority = 1,
                            Value = 1
                        })
                        ItemCache[obj] = true
                    end
                end
            end
        end
    end
    
    -- Sort by priority and distance
    table.sort(items, function(a, b)
        if a.Priority == b.Priority then
            return a.Distance < b.Distance
        end
        return a.Priority > b.Priority
    end)
    
    return items
end

-- INTELLIGENT MOVEMENT SYSTEM
function MoveToPosition(position, avoidEnemies)
    local character = Player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    
    if avoidEnemies and Config.AutoAvoidEnemies then
        local enemies = ScanEnemies()
        for _, enemy in pairs(enemies) do
            if enemy.Distance < 30 then
                -- Avoid enemy by moving away
                local awayDirection = (rootPart.Position - enemy.Position).Unit
                local safePosition = rootPart.Position + (awayDirection * 50)
                humanoid:MoveTo(safePosition)
                task.wait(2)
                return false
            end
        end
    end
    
    -- Smooth movement with pathfinding
    humanoid:MoveTo(position)
    
    -- Wait for arrival with timeout
    local startWait = os.time()
    while (rootPart.Position - position).Magnitude > 10 do
        if os.time() - startWait > 10 then -- 10 second timeout
            return false
        end
        task.wait(0.1)
    end
    
    return true
end

-- ITEM COLLECTION ENGINE
function CollectItem(item)
    local character = Player.Character
    if not character then return false end
    
    -- Move to item
    local success = MoveToPosition(item.Position, true)
    if not success then return false end
    
    task.wait(0.5) -- Stabilize
    
    -- Collection methods based on item type
    if item.Object:FindFirstChild("ClickDetector") then
        -- Use click detector
        fireclickdetector(item.Object.ClickDetector)
        CollectedItems = CollectedItems + 1
        
    elseif item.Object:FindFirstChild("ProximityPrompt") then
        -- Use proximity prompt
        fireproximityprompt(item.Object.ProximityPrompt)
        CollectedItems = CollectedItems + 1
        
    else
        -- Try tool interaction
        local backpack = Player:FindFirstChild("Backpack")
        local characterTools = character:GetChildren()
        
        -- Find an appropriate tool
        local tool = nil
        for _, item in pairs(characterTools) do
            if item:IsA("Tool") then
                tool = item
                break
            end
        end
        
        if not tool and backpack then
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    tool = item
                    break
                end
            end
        end
        
        if tool then
            -- Equip and use tool
            tool.Parent = character
            task.wait(0.2)
            
            -- Simulate tool use
            if tool:FindFirstChild("Handle") then
                tool.Handle.CFrame = item.Object.CFrame
                VirtualInput:SendKeyEvent(true, "E", false, game)
                task.wait(0.1)
                VirtualInput:SendKeyEvent(false, "E", false, game)
                CollectedItems = CollectedItems + 1
            end
        else
            -- Last resort: click on object
            Mouse.TargetFilter = item.Object
            Mouse.Target = item.Object
            VirtualInput:SendMouseButtonEvent(
                item.Object.Position.X,
                item.Object.Position.Y,
                0, -- Left mouse button
                true, -- Down
                game,
                1
            )
            task.wait(0.1)
            VirtualInput:SendMouseButtonEvent(
                item.Object.Position.X,
                item.Object.Position.Y,
                0, -- Left mouse button
                false, -- Up
                game,
                1
            )
            CollectedItems = CollectedItems + 1
        end
    end
    
    -- Remove from cache
    ItemCache[item.Object] = nil
    
    -- Update inventory tracking
    GameState.Inventory[item.Type] = (GameState.Inventory[item.Type] or 0) + 1
    
    task.wait(0.5) -- Collection cooldown
    return true
end

-- NIGHT TIME SAFETY SYSTEM
function CheckNightTime()
    local lighting = Workspace:FindFirstChildOfClass("Lighting")
    if lighting then
        -- Check if it's night based on lighting
        local currentTime = lighting:GetAttribute("Time") or lighting.ClockTime or 12
        GameState.IsNight = currentTime < 6 or currentTime > 18
        
        if GameState.IsNight and Config.NightRetreat then
            -- Find safe zone (campfire, base, etc.)
            if not GameState.SafeZone then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "Campfire" or obj.Name == "Base" or obj.Name == "SafeZone" then
                        GameState.SafeZone = obj
                        break
                    end
                end
            end
            
            -- Return to safe zone at night
            if GameState.SafeZone then
                MoveToPosition(GameState.SafeZone.Position, false)
                return true
            end
        end
    end
    return false
end

-- MAIN FARMING LOOP
function FarmingLoop()
    while Config.Enabled do
        -- Check game state
        if not Player.Character or Player.Character.Humanoid.Health <= 0 then
            task.wait(5)
            continue
        end
        
        -- Night time check
        if CheckNightTime() then
            task.wait(10) -- Wait at safe zone
            continue
        end
        
        -- Scan for items
        local items = ScanItems()
        
        if #items > 0 then
            -- Collect highest priority item
            local targetItem = items[1]
            
            if Config.ItemWhitelist then
                for _, allowedItem in pairs(Config.ItemWhitelist) do
                    if targetItem.Type == allowedItem then
                        CollectItem(targetItem)
                        break
                    end
                end
            else
                CollectItem(targetItem)
            end
            
            task.wait(1) -- Cooldown between collections
        else
            -- No items found, explore randomly
            local randomDirection = Vector3.new(
                math.random(-Config.FarmRadius, Config.FarmRadius),
                0,
                math.random(-Config.FarmRadius, Config.FarmRadius)
            )
            local explorePosition = Player.Character.HumanoidRootPart.Position + randomDirection
            
            MoveToPosition(explorePosition, true)
            task.wait(3)
        end
        
        -- Clear cache periodically
        if os.time() % 30 == 0 then
            ItemCache = {}
        end
        
        task.wait(0.1)
    end
end

-- DISCORD WEBHOOK NOTIFICATIONS
function SendNotification(message)
    if Config.WebhookURL ~= "" then
        local success, result = pcall(function()
            local data = {
                ["content"] = message,
                ["embeds"] = {{
                    ["title"] = "99 Nights Farmer",
                    ["description"] = "Item Collection Report",
                    ["color"] = 65280,
                    ["fields"] = {
                        {
                            ["name"] = "Items Collected",
                            ["value"] = CollectedItems,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Session Time",
                            ["value"] = os.time() - StartTime .. " seconds",
                            ["inline"] = true
                        }
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            }
            
            return game:HttpGet(Config.WebhookURL, {
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = game:GetService("HttpService"):JSONEncode(data)
            })
        end)
        
        if not success then
            warn("Failed to send Discord notification: " .. result)
        end
    end
end

-- ADVANCED UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()
local Window = Library:CreateWindow("99 Nights Farmer", "Shadow Core AI")

local MainTab = Window:CreateTab("Main Controls")
local ItemsTab = Window:CreateTab("Item Settings")
local SafetyTab = Window:CreateTab("Safety Settings")

-- MAIN CONTROLS
MainTab:CreateToggle("Enable Auto Farm", false, function(State)
    Config.Enabled = State
    if State then
        StartTime = os.time()
        CollectedItems = 0
        FarmingLoop()
        Library:CreateNotification("Farm", "Auto Farming Started!", 5)
    else
        Library:CreateNotification("Farm", "Auto Farming Stopped!", 5)
        SendNotification("Farming session ended. Collected " .. CollectedItems .. " items.")
    end
end)

MainTab:CreateSlider("Farm Radius", 100, 1000, 500, true, function(Value)
    Config.FarmRadius = Value
end)

MainTab:CreateToggle("Save Inventory Data", true, function(State)
    Config.SaveInventory = State
end)

-- ITEM SETTINGS
for itemName, itemData in pairs(ItemDatabase) do
    ItemsTab:CreateToggle("Collect " .. itemName, true, function(State)
        if State then
            if not table.find(Config.ItemWhitelist, itemName) then
                table.insert(Config.ItemWhitelist, itemName)
            end
        else
            local index = table.find(Config.ItemWhitelist, itemName)
            if index then
                table.remove(Config.ItemWhitelist, index)
            end
        end
    end)
end

-- SAFETY SETTINGS
SafetyTab:CreateToggle("Auto Avoid Enemies", true, function(State)
    Config.AutoAvoidEnemies = State
end)

SafetyTab:CreateToggle("Retreat at Night", true, function(State)
    Config.NightRetreat = State
end)

SafetyTab:CreateButton("Return to Safe Zone", function()
    CheckNightTime()
    if GameState.SafeZone then
        MoveToPosition(GameState.SafeZone.Position, false)
    end
end)

-- STATS DISPLAY
local StatsTab = Window:CreateTab("Statistics")
StatsTab:CreateLabel("Items Collected: 0")
StatsTab:CreateLabel("Session Time: 0s")
StatsTab:CreateLabel("Current Night: 1")

-- AUTO UPDATE STATS
RunService.Heartbeat:Connect(function()
    if Config.Enabled then
        pcall(function()
            Window:UpdateTab("Statistics", {
                "Items Collected: " .. CollectedItems,
                "Session Time: " .. (os.time() - StartTime) .. "s",
                "Current Night: " .. GameState.CurrentNight
            })
        end)
    end
end)

Library:Init()

-- INITIAL MESSAGE
Library:CreateNotification("99 Nights Farmer", "Shadow Core AI Loaded Successfully!", 5)
