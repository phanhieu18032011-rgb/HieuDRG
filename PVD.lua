local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Safe Parent GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PVD_Premium_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local success, _ = pcall(function()
    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = CoreGui
    else
        ScreenGui.Parent = CoreGui
    end
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Variables
local States = {
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    Aimbot = false,
    AimbotTarget = "Player",
    ESP = false,
    ESPTarget = "All",       -- "Player" / "Mob" / "All"
    HitBox = false,
    HitBoxSize = 5,
    HitBoxTarget = "All",  -- "Player" / "Mob" / "All"
}

-- Fly internals
local flyBodyVelocity = nil
local flyBodyGyro = nil

-- ESP internals
local espFolder = Instance.new("Folder")
espFolder.Name = "PVD_ESP"
espFolder.Parent = ScreenGui

-- HitBox internals
local originalHitboxSizes = {}
setmetatable(originalHitboxSizes, {__mode = "k"}) -- Prevent memory leaks when parts are destroyed

\n-- ============================================================
-- MOONLIGHT HUB FARM SCRIPT - CONFIG + GaG2 FUNCTIONS
-- ============================================================
getgenv().Config = {\n    ["Auto Steal"] = false,\n    ["Auto Collect Drops"] = false,
    ["Max Plant Fruit"] = 200,
    ["Buy Expand Plot"] = true,
    ["Buy Slot Pet"] = true,
    ["Pet"] = {
        ["Auto Buy"] = {
            ["Enable"] = true,
            ["Pet"] = {
                ["IceSerpent"]      = true,
                ["Raccoon"]         = true,
                ["Unicorn"]         = true,
                ["GoldenDragonfly"] = true,
                ["BlackDragon"]     = true,
                ["Monkey"]          = true,
                ["Bee"]             = true,
                ["Robin"]           = true,
                ["Deer"]            = false,
                ["Owl"]             = false,
                ["Bunny"]           = false,
                ["Frog"]            = false,
            },
        },
    },
    ["Mail"] = {
        ["Enable"]      = false,
        ["Username"]    = "",
        ["Note"]        = "auto-shipped from main",
        ["IntervalSec"] = 30,
        ["Pet"] = {
            ["IceSerpent"]      = false,
            ["Raccoon"]         = false,
            ["Unicorn"]         = false,
            ["GoldenDragonfly"] = false,
            ["BlackDragon"]     = false,
            ["Monkey"]          = false,
            ["Bee"]             = false,
            ["Robin"]           = false,
            ["Deer"]            = false,
            ["Owl"]             = false,
            ["Bunny"]           = false,
            ["Frog"]            = false,
        },
        ["Seed"] = {
            ["Rainbow"] = false,
            ["Gold"]    = false,
        },
    },
    ["Plant Seed"] = {
        ["Enable"] = true,
        ["Mode"]   = "Random In Plot", -- "Random In Plot" hoặc "Under Player"
        ["Seed"] = {
            ["Bamboo"]          = true,
            ["Blueberry"]       = true,
            ["Tulip"]           = true,
            ["Apple"]           = true,
            ["Tomato"]          = true,
            ["Banana"]          = true,
            ["Sunflower"]       = true,
            ["Corn"]            = true,
            ["Mushroom"]        = true,
            ["Cherry"]          = true,
            ["Mango"]           = true,
            ["Grape"]           = true,
            ["Coconut"]         = true,
            ["Cactus"]          = true,
            ["Baby Cactus"]     = true,
            ["Pomegranate"]     = true,
            ["Pineapple"]       = true,
            ["Dragon Fruit"]    = true,
            ["Poison Apple"]    = true,
            ["Moon Bloom"]      = true,
            ["Poison Ivy"]      = true,
            ["Ghost Pepper"]    = true,
            ["Venus Fly Trap"]  = true,
            ["Dragon's Breath"] = true,
        },
    },
    ["Harvest"] = {
        ["Enable"] = true,
        ["All"]    = true,  -- true = thu hoạch tất cả, false = chỉ thu theo danh sách Fruit
        ["Fruit"]  = {},    -- ví dụ: {["Apple"] = true, ["Grape"] = true}
        ["Only Mutation"]   = false,
        ["Ignore Mutation"] = false,
        ["Select Mutation Harvest"] = {},  -- ví dụ: {["Gold"] = true}
        ["Select Mutation Ignore"]  = {},
        ["Weather Filter"]         = false,
        ["Only During Weather"]    = false,
        ["Select Weather"]         = {},   -- ví dụ: {["Night"] = true}
    },
    ["Sell"] = {
        ["Enable"]    = false,
        ["When Full"] = true,
    },
    ["Buy Seed"] = {
        ["Enable"] = true,
        ["Seed"] = {
            ["Bamboo"]          = true,
            ["Blueberry"]       = true,
            ["Tulip"]           = true,
            ["Apple"]           = true,
            ["Tomato"]          = true,
            ["Banana"]          = true,
            ["Sunflower"]       = true,
            ["Corn"]            = true,
            ["Mushroom"]        = true,
            ["Cherry"]          = true,
            ["Mango"]           = true,
            ["Grape"]           = true,
            ["Coconut"]         = true,
            ["Cactus"]          = true,
            ["Baby Cactus"]     = true,
            ["Pomegranate"]     = true,
            ["Pineapple"]       = true,
            ["Dragon Fruit"]    = true,
            ["Poison Apple"]    = true,
            ["Moon Bloom"]      = true,
            ["Poison Ivy"]      = true,
            ["Ghost Pepper"]    = true,
            ["Venus Fly Trap"]  = true,
            ["Dragon's Breath"] = true,
        },
    },
    ["Buy Gear"] = {
        ["Enable"] = false,
        ["Gear"] = {
            ["Common Watering Can"]  = true,
            ["Super Watering Can"]   = true,
            ["Common Sprinkler"]     = true,
            ["Uncommon Sprinkler"]   = true,
            ["Rare Sprinkler"]       = true,
            ["Legendary Sprinkler"]  = true,
            ["Super Sprinkler"]      = true,
        },
    },
    ["Buy Crate"] = {
        ["Enable"] = false,
        ["Crate"] = {
            ["Ladder Crate"] = false,
            ["Bench Crate"]  = false,
        },
    },
    ["Destroy Plant"] = {
        ["By Name"]   = false,
        ["By Rarity"] = false,
        ["Name"]   = {},  -- ví dụ: {["All"] = true} hoặc {["Carrot"] = true}
        ["Rarity"] = {},  -- ví dụ: {["Common"] = true}
    },
    ["Seed Pack"] = {
        ["Enable"] = false,
    },
    ["Pet Spawn"] = {
        ["Enable"] = false,
    },
    ["Webhook"] = {
        ["Enable"]   = false,
        ["URL"]      = "",
        ["Username"] = "Moonlight Hub",
        ["OnRarePet"]  = true,
        ["OnRareSeed"] = true,
        ["PetMinPrice"] = 0,
        ["PetRarity"] = {
            ["Common"]    = false,
            ["Uncommon"]  = false,
            ["Rare"]      = false,
            ["Legendary"] = true,
            ["Mythic"]    = true,
            ["Super"]     = true,
            ["Divine"]    = true,
            ["Prismatic"] = true,
        },
    },
    ["Stand Center"] = {
        ["Enable"] = true,   -- tự động đứng giữa khu vườn của mình
        ["Height"] = 3,      -- độ cao so với mặt đất (studs)
        ["Interval"] = 2,    -- kiểm tra lại mỗi N giây
    },
    ["Settings"] = {
        ["Move Mode"]    = "TP",      -- "TP" hoặc "Tween"
        ["Tween Speed"]  = 350,
        ["Anti AFK"]     = true,
        ["Plant Delay"]  = 0.2,
        ["Harvest Delay"]= 0.05,
        ["Sell Delay"]   = 0.2,
        ["Shovel Delay"] = 0.2,
    },
}

-- ============================================================
local Config = getgenv().Config
local Modules = {}

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local PPS = game:GetService("ProximityPromptService")
PPS.MaxPromptsVisible = 100

-- ========== REMOTES (từ GaG2 - đã xác minh đúng) ==========
local Networking = require(RS:WaitForChild("SharedModules"):WaitForChild("Networking"))
local Packet = RS.SharedModules.Packet.RemoteEvent
local hide = LP:FindFirstChild("HideCollectProximityPrompts")

-- ========== DỮ LIỆU GAME ==========
local rarityMap = {}
local successRarity = pcall(function()
    local SD = require(RS:WaitForChild("SharedModules"):WaitForChild("SeedData"))
    for _, data in ipairs(SD) do
        if data.SeedName and data.Rarity then rarityMap[data.SeedName] = data.Rarity end
    end
end)
if not successRarity or next(rarityMap) == nil then
    rarityMap = {
        Carrot="Common",Strawberry="Common",Blueberry="Common",Tulip="Uncommon",Tomato="Uncommon",
        Apple="Uncommon",Bamboo="Rare",Corn="Rare",Cactus="Rare",Pineapple="Rare",Mushroom="Epic",
        ["Green Bean"]="Epic",Banana="Epic",Grape="Epic",Coconut="Epic",Mango="Epic",
        ["Dragon Fruit"]="Legendary",Acorn="Legendary",Cherry="Legendary",Sunflower="Legendary",
        ["Venus Fly Trap"]="Mythic",Pomegranate="Mythic",["Poison Apple"]="Mythic",
        ["Moon Bloom"]="Super",["Dragon's Breath"]="Super",["Ghost Pepper"]="Mythic",
        ["Poison Ivy"]="Legendary",["Baby Cactus"]="Rare",["Glow Mushroom"]="Epic",
        Romanesco="Mythic",["Horned Melon"]="Rare",Gold="Legendary",Rainbow="Mythic"
    }
end

-- ========== LOGGING ==========
getgenv().EnableLog = true
local _logNotifCooldown = {}
function logAction(mainAction, subAction)
    local msg = subAction and ("[Log] " .. mainAction .. " | " .. subAction) or ("[Log] " .. mainAction)
    print(msg)
end

-- ========== UTILS (từ GaG2) ==========
function Modules.FirePrompt(prompt)
    if fireproximityprompt then
        fireproximityprompt(prompt)
    else
        prompt:InputHoldBegin()
        task.wait(0.01)
        prompt:InputHoldEnd()
    end
end

function Modules.getModel(instance)
    if not instance then return nil end
    return instance:FindFirstAncestorOfClass("Model")
end

function Modules.isWeatherActive(name)
    local obj = RS:FindFirstChild(name)
    if obj and obj:IsA("BoolValue") then return obj.Value == true end
    return false
end

function Modules.modelHasMutation(model, mutationTable)
    local mutation = model:GetAttribute("Mutation")
    if not mutation then return false end
    for name, selected in pairs(mutationTable) do
        if selected and mutation == name then return true end
    end
    return false
end

-- ========== MOVEMENT (từ GaG2) ==========
function Modules.tweenTo(position)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local speed = Config.Settings["Tween Speed"] or 350
    local dist = (hrp.Position - position).Magnitude
    local duration = math.max(dist / speed, 0.05)
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.zero; bv.MaxForce = Vector3.new(1e9,1e9,1e9); bv.Parent = hrp
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)})
    tween:Play(); tween.Completed:Wait(); bv:Destroy()
end

function Modules.teleportTo(position)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(position)
end

function Modules.moveTo(position)
    if Config.Settings["Move Mode"] == "Tween" then
        Modules.tweenTo(position)
    else
        Modules.teleportTo(position)
    end
end

function Modules.returnToHomePlot()
    local plotId = LP:GetAttribute("PlotId")
    if plotId then
        local plot = workspace.Gardens and workspace.Gardens:FindFirstChild("Plot" .. tostring(plotId))
        if plot then
            local ref = plot:FindFirstChild("PlotSizeReference")
            if ref then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(ref.Position + Vector3.new(0,5,0)); return end
            end
            Modules.moveTo(plot:GetPivot().Position + Vector3.new(0,5,0))
            return
        end
    end
    Modules.moveTo(Vector3.new(0,10,0))
end


-- ========== AUTO STEAL & COLLECT (Goodluck Integration) ==========
function Modules.isNightTime()
    local Lighting = game:GetService("Lighting")
    return Lighting.ClockTime >= 18 or Lighting.ClockTime <= 6
end

function Modules.autoStealLoop()
    while true do
        if Config["Auto Steal"] and Modules.isNightTime() then
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local plots = workspace:FindFirstChild("Gardens") or workspace:FindFirstChild("Plots")
                if plots then
                    local plotId = LP:GetAttribute("PlotId")
                    for _, plot in pairs(plots:GetChildren()) do
                        if plot.Name ~= "Plot" .. tostring(plotId) then
                            for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
                                if prompt:IsDescendantOf(plot) and prompt.Enabled then
                                    local parent = prompt.Parent
                                    if parent and parent:IsA("BasePart") then
                                        root.CFrame = parent.CFrame * CFrame.new(0, 3, 0)
                                        task.wait(0.2)
                                        Modules.FirePrompt(prompt)
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait(2)
    end
end

function Modules.autoCollectDropsLoop()
    while true do
        if Config["Auto Collect Drops"] then
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, item in pairs(workspace:GetChildren()) do
                    if item:IsA("Tool") or (item:IsA("Part") and item:FindFirstChild("TouchInterest")) then
                        local name = string.lower(item.Name)
                        if string.find(name, "fruit") or string.find(name, "apple") or string.find(name, "berry") or string.find(name, "seed") then
                            if item:IsA("Tool") and item:FindFirstChild("Handle") then
                                root.CFrame = item.Handle.CFrame
                            elseif item:IsA("Part") then
                                root.CFrame = item.CFrame
                            end
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end
\n-- ========== HARVEST (từ GaG2 - logic đầy đủ) ==========
function Modules.shouldHarvestModel(model)
    local cfg = Config.Harvest

    -- Lọc mutation chỉ thu hoạch
    if cfg["Only Mutation"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Mutation Harvest"]) do if v then anySelected = true break end end
        if not anySelected then return false end
        if not Modules.modelHasMutation(model, cfg["Select Mutation Harvest"]) then return false end
    end

    -- Lọc mutation bỏ qua
    if cfg["Ignore Mutation"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Mutation Ignore"]) do if v then anySelected = true break end end
        if anySelected then
            if Modules.modelHasMutation(model, cfg["Select Mutation Ignore"]) then return false end
        end
    end

    -- Lọc không thu hoạch khi thời tiết
    if cfg["Weather Filter"] then
        local anySelected = false
        for _, v in pairs(cfg["Select Weather"]) do if v then anySelected = true break end end
        if anySelected then
            for name, selected in pairs(cfg["Select Weather"]) do
                if selected and Modules.isWeatherActive(name) then return false end
            end
        end
    end

    -- Lọc chỉ thu hoạch khi thời tiết
    if cfg["Only During Weather"] then
        local anySelected, anyActive = false, false
        for name, selected in pairs(cfg["Select Weather"]) do
            if selected then
                anySelected = true
                if Modules.isWeatherActive(name) then anyActive = true end
            end
        end
        if anySelected and not anyActive then return false end
    end

    return true
end

local processingPrompts = {}
function Modules.harvestPrompt(prompt)
    if processingPrompts[prompt] then return end
    local model = Modules.getModel(prompt)
    if not model then return end
    local plantId = model:GetAttribute("PlantId")
    local fruitId = model:GetAttribute("FruitId") or ""
    local plantName = model:GetAttribute("CorePartName") or model:GetAttribute("SeedName") or fruitId

    local shouldHarvest = false
    if Config.Harvest.All then
        shouldHarvest = true
    elseif Config.Harvest.Fruit[plantName] then
        shouldHarvest = true
    end

    if shouldHarvest then shouldHarvest = Modules.shouldHarvestModel(model) end

    if plantId and shouldHarvest then
        processingPrompts[prompt] = true
        task.spawn(function()
            local oldDist = prompt.MaxActivationDistance
            prompt.MaxActivationDistance = math.huge
            prompt:InputHoldBegin()
            task.wait(0.01)
            prompt:InputHoldEnd()
            -- Remote đúng từ GaG2
            Networking.Garden.CollectFruit:Fire(plantId, fruitId)
            prompt.MaxActivationDistance = oldDist
            task.wait(0.2)
            processingPrompts[prompt] = nil
        end)
    end
end

function Modules.harvestLoop()
    while true do
        if Config.Harvest.Enable and (not hide or not hide.Value) then
            for _, prompt in ipairs(CollectionService:GetTagged("HarvestPrompt")) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    task.spawn(Modules.harvestPrompt, prompt)
                end
            end
        end
        task.wait(Config.Settings["Harvest Delay"] or 0.05)
    end
end

-- ========== SELL (remote đúng từ GaG2) ==========
function Modules.sellLoop()
    while true do
        if Config.Sell.Enable then
            logAction("Auto Sell", "Sold all")
            Networking.NPCS.SellAll:Fire()
        end
        task.wait(Config.Settings["Sell Delay"] or 0.2)
    end
end

function Modules.sellFullLoop()
    while true do
        if Config.Sell["When Full"] then
            local ok, result = pcall(function()
                return LP.PlayerGui.BackpackGui.Backpack.Inventory.FruitInventory.Text
            end)
            if ok and result then
                local current, max = result:match("(%d+)/(%d+)")
                if current and max and tonumber(current) >= tonumber(max) then
                    logAction("Auto Sell Full", "Backpack full")
                    Networking.NPCS.SellAll:Fire()
                end
            end
        end
        task.wait(Config.Settings["Sell Delay"] or 0.2)
    end
end

-- ========== SHOP (Packet ID đúng từ GaG2) ==========
function Modules.shopLoop()
    while true do
        -- Mua Seed: Packet 103
        if Config["Buy Seed"].Enable then
            for name, enabled in pairs(Config["Buy Seed"].Seed) do
                if enabled then
                    logAction("Buy Seed", name)
                    Packet:FireServer(103, name)
                    task.wait(0.2)
                end
            end
        end
        -- Mua Gear: Packet 107
        if Config["Buy Gear"].Enable then
            for name, enabled in pairs(Config["Buy Gear"].Gear) do
                if enabled then
                    logAction("Buy Gear", name)
                    Packet:FireServer(107, name)
                    task.wait(0.2)
                end
            end
        end
        -- Mua Crate: Packet 103
        if Config["Buy Crate"].Enable then
            for name, enabled in pairs(Config["Buy Crate"].Crate) do
                if enabled then
                    logAction("Buy Crate", name)
                    Packet:FireServer(103, name)
                    task.wait(0.2)
                end
            end
        end
        task.wait(0.2)
    end
end

-- ========== PLANT (từ GaG2 - logic đầy đủ) ==========
function Modules.getPlantAreaGround(position)
    local rayOrigin = position + Vector3.new(0,5,0)
    local rayDirection = Vector3.new(0,-20,0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {workspace.Gardens}
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    if result then return result.Position + Vector3.new(0,0.1,0) end
    return nil
end

function Modules.plantSeedAtPosition(position)
    if not Config["Plant Seed"].Enable then return false end

    -- Lấy danh sách seed đã bật trong Config
    local selectedSeeds = {}
    for name, enabled in pairs(Config["Plant Seed"].Seed) do
        if enabled then table.insert(selectedSeeds, name) end
    end
    if #selectedSeeds == 0 then return false end

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return false end

    -- Tìm tool trong backpack khớp với seed đã chọn (từ GaG2)
    local seedTool = nil
    for _, name in ipairs(selectedSeeds) do
        for _, tool in backpack:GetChildren() do
            if tool:IsA("Tool") and tool.Name == name and tool:GetAttribute("SeedTool") then
                seedTool = tool
                break
            end
        end
        if seedTool then break end
    end

    if not seedTool then return false end
    logAction("Auto Plant", seedTool.Name)
    -- Remote đúng từ GaG2
    Networking.Plant.PlantSeed:Fire(position, seedTool:GetAttribute("SeedTool"), seedTool)
    return true
end

function Modules.autoPlantLoop()
    while true do
        if Config["Plant Seed"].Enable then
            local plotId = LP:GetAttribute("PlotId")
            local plot = plotId and workspace:FindFirstChild("Gardens") and workspace.Gardens:FindFirstChild("Plot" .. plotId)
            if plot then
                local targetPos
                local mode = Config["Plant Seed"].Mode or "Random In Plot"

                if mode == "Under Player" then
                    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local groundPos = Modules.getPlantAreaGround(hrp.Position)
                        if groundPos then targetPos = groundPos end
                    end
                else
                    -- Random In Plot (từ GaG2)
                    local plantAreas = CollectionService:GetTagged("PlantArea")
                    local plotPlantAreas = {}
                    for _, area in ipairs(plantAreas) do
                        if area:IsDescendantOf(plot) then table.insert(plotPlantAreas, area) end
                    end
                    if #plotPlantAreas > 0 then
                        local area = plotPlantAreas[math.random(1, #plotPlantAreas)]
                        local pos = area.Position
                        local size = area.Size
                        targetPos = Vector3.new(
                            pos.X + (math.random()-0.5)*size.X,
                            pos.Y + size.Y/2 + 0.1,
                            pos.Z + (math.random()-0.5)*size.Z
                        )
                    end
                end

                if targetPos then Modules.plantSeedAtPosition(targetPos) end
            end
        end
        task.wait(Config.Settings["Plant Delay"] or 0.2)
    end
end

-- ========== SHOVEL / DESTROY (từ GaG2) ==========
function Modules.equipShovel()
    local char = LP.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local alreadyEquipped = char:FindFirstChild("Shovel")
    if alreadyEquipped and alreadyEquipped:IsA("Tool") and alreadyEquipped:GetAttribute("Shovel") then
        return alreadyEquipped
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return nil end
    for _, tool in backpack:GetChildren() do
        if tool:IsA("Tool") and tool.Name == "Shovel" and tool:GetAttribute("Shovel") then
            humanoid:EquipTool(tool)
            task.wait(0.1)
            return tool
        end
    end
    return nil
end

function Modules.plantMatchesDestroy(seedName)
    local cfg = Config["Destroy Plant"]
    local matchName = false
    local matchRarity = false

    if cfg["By Name"] then
        local anySelected = false
        for _, v in pairs(cfg.Name) do if v then anySelected = true break end end
        if anySelected then
            if cfg.Name["All"] then matchName = true
            elseif cfg.Name[seedName] then matchName = true end
        end
    end

    if cfg["By Rarity"] then
        local anySelected = false
        for _, v in pairs(cfg.Rarity) do if v then anySelected = true break end end
        if anySelected then
            local plantRarity = rarityMap[seedName] or "Common"
            if cfg.Rarity["All"] then matchRarity = true
            elseif cfg.Rarity[plantRarity] then matchRarity = true end
        end
    end

    return matchName or matchRarity
end

function Modules.autoShovelLoop()
    while true do
        local cfg = Config["Destroy Plant"]
        if cfg["By Name"] or cfg["By Rarity"] then
            local plotId = LP:GetAttribute("PlotId")
            if plotId then
                local gardens = workspace:FindFirstChild("Gardens")
                local plot = gardens and gardens:FindFirstChild("Plot" .. tostring(plotId))
                if plot then
                    local plantsFolder = plot:FindFirstChild("Plants")
                    if plantsFolder then
                        local candidates = {}
                        for _, plant in ipairs(plantsFolder:GetChildren()) do
                            if plant:IsA("Model") then
                                local seedName = plant:GetAttribute("SeedName")
                                if seedName and Modules.plantMatchesDestroy(seedName) then
                                    table.insert(candidates, plant)
                                end
                            end
                        end
                        if #candidates > 0 then
                            local shovelTool = Modules.equipShovel()
                            if shovelTool then
                                local shovelType = shovelTool:GetAttribute("Shovel")
                                for _, plant in ipairs(candidates) do
                                    if not cfg["By Name"] and not cfg["By Rarity"] then break end
                                    if not plant or not plant.Parent then
                                        task.wait(Config.Settings["Shovel Delay"] or 0.2)
                                        continue
                                    end
                                    local plantId = plant:GetAttribute("PlantId")
                                    local seedName = plant:GetAttribute("SeedName") or "plant"
                                    if plantId and shovelType then
                                        -- Remote đúng từ GaG2
                                        pcall(function() Networking.Shovel.UseShovel:Fire(plantId, "", shovelType, shovelTool) end)
                                        logAction("Auto Destroy", seedName)
                                    end
                                    task.wait(Config.Settings["Shovel Delay"] or 0.2)
                                end
                            else
                                print("[Moonlight Hub] Shovel not found in backpack!")
                            end
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end

-- ========== SEED PACKS (từ GaG2) ==========
local function getSeedLocations()
    local seeds = {}
    local map = workspace:FindFirstChild("Map")
    if map then
        local serverLocs = map:FindFirstChild("SeedPackSpawnServerLocations")
        if serverLocs then
            for _, part in ipairs(serverLocs:GetChildren()) do
                if part:IsA("BasePart") then
                    local prompt = part:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt and prompt.Enabled then
                        table.insert(seeds, {model=part, pos=part.Position + Vector3.new(0, part.Size.Y/2+3, 0)})
                    end
                end
            end
        end
    end
    if #seeds == 0 then
        for _, tag in ipairs({"SeedPrompt","CollectSeed","SeedPackPrompt"}) do
            for _, prompt in ipairs(CollectionService:GetTagged(tag)) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    local parent = prompt.Parent
                    if parent:IsA("BasePart") then
                        table.insert(seeds, {model=parent, pos=parent.Position + Vector3.new(0, parent.Size.Y/2+3, 0)})
                    end
                end
            end
        end
    end
    if #seeds == 0 then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.Enabled and
                (obj.Name:lower():find("seed") or obj.Name:lower():find("pickup")) then
                local parent = obj.Parent
                if parent:IsA("BasePart") then
                    table.insert(seeds, {model=parent, pos=parent.Position + Vector3.new(0, parent.Size.Y/2+3, 0)})
                end
            end
        end
    end
    return seeds
end

local function tpAndFireSeedPrompt(seed)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(seed.pos)
    task.wait(0.15)
    local prompt = seed.model:FindFirstChildWhichIsA("ProximityPrompt")
    if not prompt then return end
    local old = prompt.MaxActivationDistance
    prompt.MaxActivationDistance = 100
    Modules.FirePrompt(prompt)
    prompt.MaxActivationDistance = old
end

function Modules.autoCollectSeedPacksLoop()
    while true do
        if Config["Seed Pack"].Enable then
            local seeds = getSeedLocations()
            if #seeds > 0 then
                for _, seed in ipairs(seeds) do
                    if not Config["Seed Pack"].Enable then break end
                    tpAndFireSeedPrompt(seed)
                    logAction("Seed Pack", "Collected")
                    task.wait(0.3)
                end
                Modules.returnToHomePlot()
            end
        end
        task.wait(1)
    end
end

-- ========== PET SPAWN (từ GaG2) ==========
function Modules.autoBuyPetSpawnLoop()
    while true do
        if Config["Pet Spawn"].Enable then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local wildPetSpawns = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WildPetSpawns")
                if wildPetSpawns then
                    for _, spawnObj in ipairs(wildPetSpawns:GetChildren()) do
                        if not Config["Pet Spawn"].Enable then break end
                        local spawnPos
                        if spawnObj:IsA("BasePart") then
                            spawnPos = spawnObj.Position + Vector3.new(0,3,0)
                        elseif spawnObj:IsA("Model") then
                            spawnPos = spawnObj:GetPivot().Position + Vector3.new(0,3,0)
                        end
                        if not spawnPos then continue end
                        hrp.CFrame = CFrame.new(spawnPos)
                        task.wait(0.15)
                        local bestPrompt, bestDist = nil, math.huge
                        local checkPos = hrp.Position
                        for _, desc in ipairs(spawnObj:GetDescendants()) do
                            if desc:IsA("ProximityPrompt") and desc.Enabled then
                                local part = desc.Parent
                                if part and part:IsA("BasePart") then
                                    local d = (part.Position - checkPos).Magnitude
                                    if d < bestDist then bestDist = d; bestPrompt = desc end
                                end
                            end
                        end
                        if not bestPrompt then
                            for _, desc in ipairs(wildPetSpawns:GetDescendants()) do
                                if desc:IsA("ProximityPrompt") and desc.Enabled then
                                    local part = desc.Parent
                                    if part and part:IsA("BasePart") then
                                        local d = (part.Position - checkPos).Magnitude
                                        if d < bestDist then bestDist = d; bestPrompt = desc end
                                    end
                                end
                            end
                        end
                        if bestPrompt then
                            local old = bestPrompt.MaxActivationDistance
                            bestPrompt.MaxActivationDistance = 100
                            Modules.FirePrompt(bestPrompt)
                            bestPrompt.MaxActivationDistance = old
                            logAction("Pet Spawn", spawnObj.Name)
                            task.wait(0.3)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end

-- ========== WEBHOOK ==========
local function sendWebhook(content)
    if not Config.Webhook.Enable or Config.Webhook.URL == "" then return end
    local httpFn = syn and syn.request or http_request or request
    pcall(function()
        httpFn({
            Url = Config.Webhook.URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                content = content,
                username = Config.Webhook.Username or "Moonlight Hub",
            })
        })
    end)
end

-- ========== ANTI AFK (từ GaG2) ==========
function Modules.antiAfkLoop()
    while true do
        if Config.Settings["Anti AFK"] then
            pcall(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
            logAction("Anti AFK", "OK")
        end
        task.wait(300)
    end
end

-- ========== STAND CENTER (đứng giữa khu vườn) ==========
function Modules.getPlotCenter()
    local plotId = LP:GetAttribute("PlotId")
    if not plotId then return nil end
    local gardens = workspace:FindFirstChild("Gardens")
    if not gardens then return nil end
    local plot = gardens:FindFirstChild("Plot" .. tostring(plotId))
    if not plot then return nil end

    -- Ưu tiên 1: dùng PlotSizeReference (chính xác nhất, từ GaG2)
    local ref = plot:FindFirstChild("PlotSizeReference")
    if ref and ref:IsA("BasePart") then
        return ref.Position + Vector3.new(0, Config["Stand Center"].Height or 3, 0)
    end

    -- Ưu tiên 2: tính trung bình tất cả PlantArea trong plot
    local plantAreas = CollectionService:GetTagged("PlantArea")
    local sumX, sumY, sumZ, count = 0, 0, 0, 0
    for _, area in ipairs(plantAreas) do
        if area:IsDescendantOf(plot) and area:IsA("BasePart") then
            sumX += area.Position.X
            sumY += area.Position.Y
            sumZ += area.Position.Z
            count += 1
        end
    end
    if count > 0 then
        return Vector3.new(sumX/count, sumY/count + (Config["Stand Center"].Height or 3), sumZ/count)
    end

    -- Ưu tiên 3: dùng pivot của plot
    local ok, pivot = pcall(function() return plot:GetPivot() end)
    if ok and pivot then
        return pivot.Position + Vector3.new(0, Config["Stand Center"].Height or 3, 0)
    end

    return nil
end

function Modules.standCenterLoop()
    while true do
        if Config["Stand Center"].Enable then
            local center = Modules.getPlotCenter()
            if center then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                -- Chỉ teleport nếu đã lệch khỏi trung tâm quá 2 studs
                if hrp and (hrp.Position - center).Magnitude > 2 then
                    hrp.CFrame = CFrame.new(center)
                    logAction("Stand Center", "Moved to plot center")
                end
            end
        end
        task.wait(Config["Stand Center"].Interval or 2)
    end
end

\n-- ===========================
-- PREMIUM THEME
-- ===========================
local Theme = {
    Background = Color3.fromRGB(12, 12, 16),
    Surface = Color3.fromRGB(18, 18, 24),
    SurfaceHover = Color3.fromRGB(24, 24, 32),
    Card = Color3.fromRGB(22, 22, 30),
    CardHover = Color3.fromRGB(28, 28, 38),
    AccentPrimary = Color3.fromRGB(124, 58, 237),
    AccentSecondary = Color3.fromRGB(79, 70, 229),
    AccentGlow = Color3.fromRGB(139, 92, 246),
    AccentSoft = Color3.fromRGB(124, 58, 237),
    Success = Color3.fromRGB(34, 197, 94),
    Danger = Color3.fromRGB(239, 68, 68),
    Warning = Color3.fromRGB(251, 191, 36),
    Text = Color3.fromRGB(245, 245, 250),
    TextSecondary = Color3.fromRGB(160, 160, 180),
    TextMuted = Color3.fromRGB(100, 100, 120),
    Border = Color3.fromRGB(35, 35, 48),
    BorderAccent = Color3.fromRGB(60, 50, 90),
    Shadow = Color3.fromRGB(0, 0, 0),
}

-- ===========================
-- UTILITIES
-- ===========================
local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function AddPadding(parent, t, b, l, r)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, t or 0)
    pad.PaddingBottom = UDim.new(0, b or 0)
    pad.PaddingLeft = UDim.new(0, l or 0)
    pad.PaddingRight = UDim.new(0, r or 0)
    pad.Parent = parent
    return pad
end

local function AddGradient(parent, colorStart, colorEnd, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, colorStart),
        ColorSequenceKeypoint.new(1, colorEnd)
    }
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function MakeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local dragEndConn
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            if dragEndConn then dragEndConn:Disconnect() end
            dragEndConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if dragEndConn then dragEndConn:Disconnect(); dragEndConn = nil end
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ===========================
-- DROP SHADOW
-- ===========================
local ShadowHolder = Instance.new("Frame")
ShadowHolder.Name = "ShadowHolder"
ShadowHolder.Parent = ScreenGui
ShadowHolder.BackgroundTransparency = 1
ShadowHolder.Position = UDim2.new(0.5, -260, 0.5, -200)
ShadowHolder.Size = UDim2.new(0, 520, 0, 400)

for i = 1, 4 do
    local shadow = Instance.new("Frame")
    shadow.Parent = ShadowHolder
    shadow.BackgroundColor3 = Theme.Shadow
    shadow.BackgroundTransparency = 0.75 + (i * 0.05)
    shadow.Position = UDim2.new(0, -i * 4, 0, -i * 2 + i * 3)
    shadow.Size = UDim2.new(1, i * 8, 1, i * 6)
    shadow.ZIndex = 0
    AddCorner(shadow, 12 + i * 2)
end

-- ===========================
-- MAIN FRAME
-- ===========================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
MainFrame.Size = UDim2.new(0, 500, 0, 380)
MainFrame.Active = true
MainFrame.ClipsDescendants = true
AddCorner(MainFrame, 10)
AddStroke(MainFrame, Theme.Border, 1)

MakeDraggable(MainFrame)

-- ===========================
-- GRADIENT ACCENT BAR
-- ===========================
local AccentBar = Instance.new("Frame")
AccentBar.Parent = MainFrame
AccentBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AccentBar.Position = UDim2.new(0, 0, 0, 0)
AccentBar.Size = UDim2.new(1, 0, 0, 3)
AccentBar.BorderSizePixel = 0
AccentBar.ZIndex = 10

AddGradient(AccentBar, Theme.AccentPrimary, Color3.fromRGB(236, 72, 153), 90)

local AccentGlow = Instance.new("Frame")
AccentGlow.Parent = MainFrame
AccentGlow.BackgroundColor3 = Theme.AccentPrimary
AccentGlow.BackgroundTransparency = 0.85
AccentGlow.Position = UDim2.new(0, 0, 0, 3)
AccentGlow.Size = UDim2.new(1, 0, 0, 20)
AccentGlow.BorderSizePixel = 0
AccentGlow.ZIndex = 2

AddGradient(AccentGlow, Theme.AccentPrimary, Color3.fromRGB(236, 72, 153), 90)

-- ===========================
-- TOP BAR
-- ===========================
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundTransparency = 1
TopBar.Position = UDim2.new(0, 0, 0, 3)
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.ZIndex = 5

local LogoIcon = Instance.new("TextLabel")
LogoIcon.Parent = TopBar
LogoIcon.BackgroundColor3 = Theme.AccentPrimary
LogoIcon.BackgroundTransparency = 0.85
LogoIcon.Position = UDim2.new(0, 14, 0.5, -13)
LogoIcon.Size = UDim2.new(0, 26, 0, 26)
LogoIcon.Font = Enum.Font.GothamBold
LogoIcon.Text = "P"
LogoIcon.TextColor3 = Theme.AccentGlow
LogoIcon.TextSize = 14
LogoIcon.ZIndex = 6
AddCorner(LogoIcon, 6)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 48, 0, 0)
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "PVD HUB"
Title.TextColor3 = Theme.Text
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 6

local VersionBadge = Instance.new("TextLabel")
VersionBadge.Parent = TopBar
VersionBadge.BackgroundColor3 = Theme.AccentPrimary
VersionBadge.BackgroundTransparency = 0.8
VersionBadge.Position = UDim2.new(0, 150, 0.5, -10)
VersionBadge.Size = UDim2.new(0, 38, 0, 20)
VersionBadge.Font = Enum.Font.GothamMedium
VersionBadge.Text = "v2.1"
VersionBadge.TextColor3 = Theme.AccentGlow
VersionBadge.TextSize = 11
VersionBadge.ZIndex = 6
AddCorner(VersionBadge, 4)

local Divider = Instance.new("Frame")
Divider.Parent = MainFrame
Divider.BackgroundColor3 = Theme.Border
Divider.Position = UDim2.new(0, 0, 0, 45)
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.BorderSizePixel = 0
Divider.ZIndex = 5

-- Window Controls
local function CreateWindowBtn(text, posOffset, hoverColor)
    local btn = Instance.new("TextButton")
    btn.Parent = TopBar
    btn.BackgroundColor3 = Theme.Surface
    btn.BackgroundTransparency = 1
    btn.Position = UDim2.new(1, posOffset, 0.5, -14)
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Font = Enum.Font.GothamBold
    btn.Text = text
    btn.TextColor3 = Theme.TextMuted
    btn.TextSize = 14
    btn.ZIndex = 6
    AddCorner(btn, 6)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3, BackgroundColor3 = hoverColor, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextColor3 = Theme.TextMuted}):Play()
    end)
    return btn
end

local MinimizeBtn = CreateWindowBtn("-", -70, Theme.AccentPrimary)
local CloseBtn = CreateWindowBtn("X", -36, Theme.Danger)

-- ===========================
-- FLOATING OPEN ICON
-- ===========================
local OpenIcon = Instance.new("TextButton")
OpenIcon.Parent = ScreenGui
OpenIcon.BackgroundColor3 = Theme.Background
OpenIcon.Position = UDim2.new(0, 20, 0.5, -28)
OpenIcon.Size = UDim2.new(0, 56, 0, 56)
OpenIcon.Font = Enum.Font.GothamBold
OpenIcon.Text = ""
OpenIcon.TextColor3 = Theme.AccentGlow
OpenIcon.TextSize = 14
OpenIcon.Visible = false
OpenIcon.AutoButtonColor = false
AddCorner(OpenIcon, 28)
AddStroke(OpenIcon, Theme.AccentPrimary, 2, 0.3)

local IconGlow = Instance.new("Frame")
IconGlow.Parent = OpenIcon
IconGlow.BackgroundColor3 = Theme.AccentPrimary
IconGlow.BackgroundTransparency = 0.85
IconGlow.Size = UDim2.new(1, -6, 1, -6)
IconGlow.Position = UDim2.new(0, 3, 0, 3)
AddCorner(IconGlow, 25)

local IconText = Instance.new("TextLabel")
IconText.Parent = OpenIcon
IconText.BackgroundTransparency = 1
IconText.Size = UDim2.new(1, 0, 1, 0)
IconText.Font = Enum.Font.GothamBold
IconText.Text = "P"
IconText.TextColor3 = Theme.AccentGlow
IconText.TextSize = 22

-- Pulse animation
do
    local stroke = OpenIcon:FindFirstChildOfClass("UIStroke")
    if stroke then
        local pulseTween = TweenService:Create(
            stroke,
            TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Transparency = 0}
        )
        OpenIcon:GetPropertyChangedSignal("Visible"):Connect(function()
            if OpenIcon.Visible then
                pulseTween:Play()
            else
                pulseTween:Pause()
            end
        end)
    end
end

MakeDraggable(OpenIcon)

-- Close / Open logic
local function hideUI()
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 480, 0, 360),
        BackgroundTransparency = 0.3
    }):Play()
    wait(0.25)
    MainFrame.Visible = false
    ShadowHolder.Visible = false
    MainFrame.Size = UDim2.new(0, 500, 0, 380)
    MainFrame.BackgroundTransparency = 0

    OpenIcon.Visible = true
    OpenIcon.Size = UDim2.new(0, 0, 0, 0)
    OpenIcon.Position = UDim2.new(0, 48, 0.5, 0)
    TweenService:Create(OpenIcon, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 56, 0, 56),
        Position = UDim2.new(0, 20, 0.5, -28)
    }):Play()
end

CloseBtn.MouseButton1Click:Connect(hideUI)
MinimizeBtn.MouseButton1Click:Connect(hideUI)

OpenIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShadowHolder.Visible = true
    OpenIcon.Visible = false

    MainFrame.Size = UDim2.new(0, 480, 0, 360)
    MainFrame.BackgroundTransparency = 0.1
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 500, 0, 380),
        BackgroundTransparency = 0
    }):Play()
end)

-- ===========================
-- SIDEBAR
-- ===========================
local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Theme.Surface
Sidebar.Position = UDim2.new(0, 0, 0, 46)
Sidebar.Size = UDim2.new(0, 140, 1, -84)
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 3
Sidebar.ClipsDescendants = true

local SidebarBottom = Instance.new("Frame")
SidebarBottom.Parent = MainFrame
SidebarBottom.BackgroundColor3 = Theme.Surface
SidebarBottom.Position = UDim2.new(0, 0, 1, -38)
SidebarBottom.Size = UDim2.new(0, 140, 0, 38)
SidebarBottom.BorderSizePixel = 0
SidebarBottom.ZIndex = 3

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Parent = MainFrame
SidebarDivider.BackgroundColor3 = Theme.Border
SidebarDivider.Position = UDim2.new(0, 140, 0, 46)
SidebarDivider.Size = UDim2.new(0, 1, 1, -46)
SidebarDivider.BorderSizePixel = 0
SidebarDivider.ZIndex = 5

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = Sidebar
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 4)

AddPadding(Sidebar, 12, 12, 10, 10)

-- ===========================
-- USER INFO (Bottom sidebar)
-- ===========================
local UserInfo = Instance.new("Frame")
UserInfo.Parent = SidebarBottom
UserInfo.BackgroundTransparency = 1
UserInfo.Position = UDim2.new(0, 0, 0, 4)
UserInfo.Size = UDim2.new(1, 0, 1, -4)
UserInfo.ZIndex = 4

local UserDot = Instance.new("Frame")
UserDot.Parent = UserInfo
UserDot.BackgroundColor3 = Theme.Success
UserDot.Position = UDim2.new(0, 14, 0.5, -4)
UserDot.Size = UDim2.new(0, 8, 0, 8)
UserDot.ZIndex = 5
AddCorner(UserDot, 4)

local UserName = Instance.new("TextLabel")
UserName.Parent = UserInfo
UserName.BackgroundTransparency = 1
UserName.Position = UDim2.new(0, 28, 0, 0)
UserName.Size = UDim2.new(1, -32, 1, 0)
UserName.Font = Enum.Font.GothamMedium
UserName.Text = LocalPlayer.Name
UserName.TextColor3 = Theme.TextSecondary
UserName.TextSize = 11
UserName.TextXAlignment = Enum.TextXAlignment.Left
UserName.TextTruncate = Enum.TextTruncate.AtEnd
UserName.ZIndex = 5

-- ===========================
-- STATUS BAR
-- ===========================
local StatusBar = Instance.new("Frame")
StatusBar.Parent = MainFrame
StatusBar.BackgroundColor3 = Theme.Surface
StatusBar.Position = UDim2.new(0, 140, 1, -30)
StatusBar.Size = UDim2.new(1, -140, 0, 30)
StatusBar.BorderSizePixel = 0
StatusBar.ZIndex = 5

-- Cleaned up redundant StatusBarInner and StatusBarCover

local StatusDivider = Instance.new("Frame")
StatusDivider.Parent = MainFrame
StatusDivider.BackgroundColor3 = Theme.Border
StatusDivider.Position = UDim2.new(0, 141, 1, -30)
StatusDivider.Size = UDim2.new(1, -141, 0, 1)
StatusDivider.BorderSizePixel = 0
StatusDivider.ZIndex = 6

local StatusText = Instance.new("TextLabel")
StatusText.Parent = StatusBar
StatusText.BackgroundTransparency = 1
StatusText.Position = UDim2.new(0, 12, 0, 0)
StatusText.Size = UDim2.new(0.6, 0, 1, 0)
StatusText.Font = Enum.Font.Gotham
StatusText.Text = "> Ready"
StatusText.TextColor3 = Theme.TextMuted
StatusText.TextSize = 11
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.ZIndex = 6

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Parent = StatusBar
FPSLabel.BackgroundTransparency = 1
FPSLabel.Position = UDim2.new(0.7, 0, 0, 0)
FPSLabel.Size = UDim2.new(0.3, -10, 1, 0)
FPSLabel.Font = Enum.Font.Gotham
FPSLabel.Text = "-- FPS"
FPSLabel.TextColor3 = Theme.TextMuted
FPSLabel.TextSize = 11
FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
FPSLabel.ZIndex = 6

local fpsCount = 0
local lastFpsUpdate = tick()

-- ===========================
-- PAGE CONTAINER
-- ===========================
local PageContainer = Instance.new("Frame")
PageContainer.Parent = MainFrame
PageContainer.BackgroundTransparency = 1
PageContainer.Position = UDim2.new(0, 141, 0, 46)
PageContainer.Size = UDim2.new(1, -141, 1, -76)
PageContainer.ZIndex = 3

local Pages = {}
local TabButtons = {}

-- ===========================
-- TAB CREATION
-- ===========================
local TabIcons = {
    Main = "#",
    Combat = "!",
    ESP = "o",
}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = Sidebar
    TabBtn.BackgroundColor3 = Theme.SurfaceHover
    TabBtn.BackgroundTransparency = 1
    TabBtn.Size = UDim2.new(1, 0, 0, 36)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.Text = ""
    TabBtn.TextColor3 = Theme.TextMuted
    TabBtn.TextSize = 13
    TabBtn.AutoButtonColor = false
    TabBtn.ZIndex = 4
    AddCorner(TabBtn, 6)

    local Indicator = Instance.new("Frame")
    Indicator.Parent = TabBtn
    Indicator.BackgroundColor3 = Theme.AccentPrimary
    Indicator.Position = UDim2.new(0, 0, 0.2, 0)
    Indicator.Size = UDim2.new(0, 3, 0.6, 0)
    Indicator.ZIndex = 5
    Indicator.BackgroundTransparency = 1
    AddCorner(Indicator, 2)

    local Icon = Instance.new("TextLabel")
    Icon.Parent = TabBtn
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(0, 10, 0, 0)
    Icon.Size = UDim2.new(0, 20, 1, 0)
    Icon.Font = Enum.Font.Gotham
    Icon.Text = TabIcons[name] or ">"
    Icon.TextColor3 = Theme.TextMuted
    Icon.TextSize = 14
    Icon.ZIndex = 5

    local Label = Instance.new("TextLabel")
    Label.Parent = TabBtn
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 32, 0, 0)
    Label.Size = UDim2.new(1, -36, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = name
    Label.TextColor3 = Theme.TextMuted
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5

    local Page = Instance.new("ScrollingFrame")
    Page.Parent = PageContainer
    Page.BackgroundTransparency = 1
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.AccentPrimary
    Page.ScrollBarImageTransparency = 0.5
    Page.Visible = false
    Page.BorderSizePixel = 0
    Page.ZIndex = 4
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)

    local PageList = Instance.new("UIListLayout")
    PageList.Parent = Page
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Padding = UDim.new(0, 8)

    AddPadding(Page, 12, 12, 14, 14)

    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 24)
    end)

    table.insert(Pages, Page)
    table.insert(TabButtons, {Btn = TabBtn, Icon = Icon, Label = Label, Indicator = Indicator})

    TabBtn.MouseEnter:Connect(function()
        if not Page.Visible then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.6}):Play()
            TweenService:Create(Label, TweenInfo.new(0.15), {TextColor3 = Theme.TextSecondary}):Play()
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if not Page.Visible then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Label, TweenInfo.new(0.15), {TextColor3 = Theme.TextMuted}):Play()
        end
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        for _, data in pairs(TabButtons) do
            TweenService:Create(data.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            TweenService:Create(data.Label, TweenInfo.new(0.2), {TextColor3 = Theme.TextMuted}):Play()
            TweenService:Create(data.Icon, TweenInfo.new(0.2), {TextColor3 = Theme.TextMuted}):Play()
            TweenService:Create(data.Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        end

        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        TweenService:Create(Label, TweenInfo.new(0.2), {TextColor3 = Theme.AccentGlow}):Play()
        TweenService:Create(Icon, TweenInfo.new(0.2), {TextColor3 = Theme.AccentGlow}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()

        StatusText.Text = "> " .. name
    end)

    if #Pages == 1 then
        Page.Visible = true
        TabBtn.BackgroundTransparency = 0.5
        Label.TextColor3 = Theme.AccentGlow
        Icon.TextColor3 = Theme.AccentGlow
        Indicator.BackgroundTransparency = 0
    end

    return Page
end

-- ===========================
-- SECTION HEADER
-- ===========================
local function CreateSection(page, text)
    local Section = Instance.new("Frame")
    Section.Parent = page
    Section.BackgroundTransparency = 1
    Section.Size = UDim2.new(1, 0, 0, 24)
    Section.ZIndex = 4

    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Parent = Section
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Position = UDim2.new(0, 2, 0, 0)
    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Text = string.upper(text)
    SectionLabel.TextColor3 = Theme.TextMuted
    SectionLabel.TextSize = 11
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.ZIndex = 5

    local SectionLine = Instance.new("Frame")
    SectionLine.Parent = Section
    SectionLine.BackgroundColor3 = Theme.Border
    SectionLine.Position = UDim2.new(0, 0, 1, -1)
    SectionLine.Size = UDim2.new(1, 0, 0, 1)
    SectionLine.ZIndex = 5
end

-- ===========================
-- PREMIUM TOGGLE
-- ===========================
local function CreateToggle(page, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = page
    ToggleFrame.BackgroundColor3 = Theme.Card
    ToggleFrame.Size = UDim2.new(1, 0, 0, 48)
    ToggleFrame.ZIndex = 4
    AddCorner(ToggleFrame, 8)
    local toggleStroke = AddStroke(ToggleFrame, Theme.Border, 1)

    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 16, 0, 0)
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5

    local StatusDot = Instance.new("Frame")
    StatusDot.Parent = ToggleFrame
    StatusDot.BackgroundColor3 = Theme.TextMuted
    StatusDot.Position = UDim2.new(1, -70, 0.5, -4)
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.ZIndex = 5
    AddCorner(StatusDot, 4)

    local SwitchBg = Instance.new("Frame")
    SwitchBg.Parent = ToggleFrame
    SwitchBg.BackgroundColor3 = Theme.Background
    SwitchBg.Position = UDim2.new(1, -52, 0.5, -11)
    SwitchBg.Size = UDim2.new(0, 38, 0, 22)
    SwitchBg.ZIndex = 5
    AddCorner(SwitchBg, 11)
    AddStroke(SwitchBg, Theme.Border, 1)

    local SwitchKnob = Instance.new("Frame")
    SwitchKnob.Parent = SwitchBg
    SwitchKnob.BackgroundColor3 = Theme.TextMuted
    SwitchKnob.Position = UDim2.new(0, 2, 0.5, -9)
    SwitchKnob.Size = UDim2.new(0, 18, 0, 18)
    SwitchKnob.ZIndex = 6
    AddCorner(SwitchKnob, 9)

    local Btn = Instance.new("TextButton")
    Btn.Parent = ToggleFrame
    Btn.BackgroundTransparency = 1
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.Text = ""
    Btn.ZIndex = 7

    Btn.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardHover}):Play()
        TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Color = Theme.BorderAccent}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Card}):Play()
        TweenService:Create(toggleStroke, TweenInfo.new(0.15), {Color = Theme.Border}):Play()
    end)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        callback(state)

        if state then
            TweenService:Create(SwitchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = Theme.AccentPrimary}):Play()
            TweenService:Create(SwitchKnob, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Position = UDim2.new(1, -20, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(StatusDot, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Success}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = Theme.AccentPrimary}):Play()
        else
            TweenService:Create(SwitchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {BackgroundColor3 = Theme.Background}):Play()
            TweenService:Create(SwitchKnob, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Theme.TextMuted
            }):Play()
            TweenService:Create(StatusDot, TweenInfo.new(0.2), {BackgroundColor3 = Theme.TextMuted}):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = Theme.Border}):Play()
        end
    end)

    return {Frame = ToggleFrame, SetState = function(s)
        state = s
        callback(s)
        if s then
            SwitchBg.BackgroundColor3 = Theme.AccentPrimary
            SwitchKnob.Position = UDim2.new(1, -20, 0.5, -9)
            SwitchKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            StatusDot.BackgroundColor3 = Theme.Success
        else
            SwitchBg.BackgroundColor3 = Theme.Background
            SwitchKnob.Position = UDim2.new(0, 2, 0.5, -9)
            SwitchKnob.BackgroundColor3 = Theme.TextMuted
            StatusDot.BackgroundColor3 = Theme.TextMuted
        end
    end}
end

-- ===========================
-- PREMIUM BUTTON
-- ===========================
local function CreateButton(page, text, callback)
    local BtnFrame = Instance.new("Frame")
    BtnFrame.Parent = page
    BtnFrame.BackgroundColor3 = Theme.Card
    BtnFrame.Size = UDim2.new(1, 0, 0, 42)
    BtnFrame.ZIndex = 4
    AddCorner(BtnFrame, 8)
    local btnStroke = AddStroke(BtnFrame, Theme.Border, 1)

    local Btn = Instance.new("TextButton")
    Btn.Parent = BtnFrame
    Btn.BackgroundTransparency = 1
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.Font = Enum.Font.GothamMedium
    Btn.Text = text
    Btn.TextColor3 = Theme.Text
    Btn.TextSize = 13
    Btn.ZIndex = 5

    Btn.MouseEnter:Connect(function()
        TweenService:Create(BtnFrame, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardHover}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Color = Theme.AccentPrimary}):Play()
        TweenService:Create(Btn, TweenInfo.new(0.15), {TextColor3 = Theme.AccentGlow}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(BtnFrame, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Card}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.15), {Color = Theme.Border}):Play()
        TweenService:Create(Btn, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        local ripple = Instance.new("Frame")
        ripple.Parent = BtnFrame
        ripple.BackgroundColor3 = Theme.AccentPrimary
        ripple.BackgroundTransparency = 0.6
        ripple.Size = UDim2.new(1, 0, 1, 0)
        ripple.ZIndex = 5
        AddCorner(ripple, 8)

        TweenService:Create(ripple, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
        game.Debris:AddItem(ripple, 0.35)

        callback(Btn)
    end)

    return Btn
end

-- ===========================
-- PREMIUM SLIDER (NEW)
-- ===========================
local function CreateSlider(page, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = page
    SliderFrame.BackgroundColor3 = Theme.Card
    SliderFrame.Size = UDim2.new(1, 0, 0, 65)
    SliderFrame.ZIndex = 4
    AddCorner(SliderFrame, 8)
    local sliderStroke = AddStroke(SliderFrame, Theme.Border, 1)

    -- Label
    local Label = Instance.new("TextLabel")
    Label.Parent = SliderFrame
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 16, 0, 6)
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.Font = Enum.Font.GothamMedium
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 5

    -- Value display
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundColor3 = Theme.AccentPrimary
    ValueLabel.BackgroundTransparency = 0.8
    ValueLabel.Position = UDim2.new(1, -55, 0, 6)
    ValueLabel.Size = UDim2.new(0, 40, 0, 20)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Theme.AccentGlow
    ValueLabel.TextSize = 12
    ValueLabel.ZIndex = 5
    AddCorner(ValueLabel, 4)

    -- Track background
    local TrackBg = Instance.new("Frame")
    TrackBg.Parent = SliderFrame
    TrackBg.BackgroundColor3 = Theme.Background
    TrackBg.Position = UDim2.new(0, 16, 0, 38)
    TrackBg.Size = UDim2.new(1, -32, 0, 8)
    TrackBg.ZIndex = 5
    AddCorner(TrackBg, 4)
    AddStroke(TrackBg, Theme.Border, 1)

    -- Track fill
    local TrackFill = Instance.new("Frame")
    TrackFill.Parent = TrackBg
    TrackFill.BackgroundColor3 = Theme.AccentPrimary
    TrackFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    TrackFill.ZIndex = 6
    AddCorner(TrackFill, 4)

    -- Knob
    local Knob = Instance.new("Frame")
    Knob.Parent = TrackBg
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.ZIndex = 7
    AddCorner(Knob, 8)
    AddStroke(Knob, Theme.AccentPrimary, 2)

    -- Knob glow
    local KnobGlow = Instance.new("Frame")
    KnobGlow.Parent = Knob
    KnobGlow.BackgroundColor3 = Theme.AccentPrimary
    KnobGlow.BackgroundTransparency = 0.7
    KnobGlow.Size = UDim2.new(1, 6, 1, 6)
    KnobGlow.Position = UDim2.new(0, -3, 0, -3)
    KnobGlow.ZIndex = 6
    KnobGlow.Visible = false
    AddCorner(KnobGlow, 11)

    -- Slide interaction
    local sliding = false
    local clickBtn = Instance.new("TextButton")
    clickBtn.Parent = TrackBg
    clickBtn.BackgroundTransparency = 1
    clickBtn.Size = UDim2.new(1, 0, 1, 16)
    clickBtn.Position = UDim2.new(0, 0, 0, -8)
    clickBtn.Text = ""
    clickBtn.ZIndex = 8

    local function updateSlider(inputX)
        local trackAbsPos = TrackBg.AbsolutePosition.X
        local trackAbsSize = TrackBg.AbsoluteSize.X
        local relative = math.clamp((inputX - trackAbsPos) / trackAbsSize, 0, 1)
        local value = math.floor(min + (max - min) * relative + 0.5)
        relative = (value - min) / (max - min)

        TrackFill.Size = UDim2.new(relative, 0, 1, 0)
        Knob.Position = UDim2.new(relative, -8, 0.5, -8)
        ValueLabel.Text = tostring(value)
        callback(value)
    end

    clickBtn.MouseButton1Down:Connect(function()
        sliding = true
        KnobGlow.Visible = true
        local mousePos = UserInputService:GetMouseLocation()
        updateSlider(mousePos.X)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
            KnobGlow.Visible = false
        end
    end)

    -- Hover on frame
    clickBtn.MouseEnter:Connect(function()
        TweenService:Create(SliderFrame, TweenInfo.new(0.15), {BackgroundColor3 = Theme.CardHover}):Play()
        TweenService:Create(sliderStroke, TweenInfo.new(0.15), {Color = Theme.BorderAccent}):Play()
    end)
    clickBtn.MouseLeave:Connect(function()
        if not sliding then
            TweenService:Create(SliderFrame, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Card}):Play()
            TweenService:Create(sliderStroke, TweenInfo.new(0.15), {Color = Theme.Border}):Play()
        end
    end)

    return ValueLabel
end

\n
-- ===========================
-- PREMIUM LABEL (STATS)
-- ===========================
local function CreateLabel(page, text, defaultVal)
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Parent = page
    LabelFrame.BackgroundColor3 = Theme.Card
    LabelFrame.Size = UDim2.new(1, 0, 0, 36)
    LabelFrame.ZIndex = 4
    AddCorner(LabelFrame, 8)
    AddStroke(LabelFrame, Theme.Border, 1)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = LabelFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 16, 0, 0)
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.Text = text
    TitleLabel.TextColor3 = Theme.TextMuted
    TitleLabel.TextSize = 13
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 5

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = LabelFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(0.5, 0, 0, 0)
    ValueLabel.Size = UDim2.new(0.5, -16, 1, 0)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(defaultVal)
    ValueLabel.TextColor3 = Theme.Text
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.ZIndex = 5

    local function setValue(val)
        if ValueLabel.Text ~= tostring(val) then
            ValueLabel.Text = tostring(val)
            -- Small pop animation
            TweenService:Create(ValueLabel, TweenInfo.new(0.1), {TextSize = 14, TextColor3 = Theme.AccentPrimary}):Play()
            task.delay(0.1, function()
                TweenService:Create(ValueLabel, TweenInfo.new(0.15), {TextSize = 13, TextColor3 = Theme.Text}):Play()
            end)
        end
    end

    return setValue
end
\n
-- =============================
-- == FARM TAB (MOONLIGHT) ==
-- =============================
local FarmTab = CreateTab("Farm")
local ShopTab = CreateTab("Shop")
local StatsTab = CreateTab("Stats")
local SettingsTab = CreateTab("Settings")

-- =============================
-- FARM
-- =============================
CreateSection(FarmTab, "Farming")

CreateToggle(FarmTab, "Auto Plant Seed", function(state)
    Config["Plant Seed"].Enable = state
end)

CreateToggle(FarmTab, "Auto Harvest", function(state)
    Config.Harvest.Enable = state
end)

CreateToggle(FarmTab, "Auto Sell All", function(state)
    Config.Sell.Enable = state
end)

CreateToggle(FarmTab, "Auto Sell When Full", function(state)
    Config.Sell["When Full"] = state
end)

CreateSection(FarmTab, "Utility")

CreateToggle(FarmTab, "Stand Center (Plot)", function(state)
    Config["Stand Center"].Enable = state
end)

CreateToggle(FarmTab, "Auto Shovel/Destroy", function(state)
    Config["Destroy Plant"]["By Name"] = state
    Config["Destroy Plant"]["By Rarity"] = state
end)

CreateToggle(FarmTab, "Auto Collect Seed Packs", function(state)
    Config["Seed Pack"].Enable = state
end)

-- =============================
-- SHOP
-- =============================
CreateSection(ShopTab, "Auto Buy")

CreateToggle(ShopTab, "Buy Seed", function(state)
    Config["Buy Seed"].Enable = state
end)

CreateToggle(ShopTab, "Buy Gear", function(state)
    Config["Buy Gear"].Enable = state
end)

CreateToggle(ShopTab, "Buy Crate", function(state)
    Config["Buy Crate"].Enable = state
end)

CreateToggle(ShopTab, "Auto Pet Spawn", function(state)
    Config["Pet Spawn"].Enable = state
end)

-- =============================
-- SETTINGS
-- =============================
CreateSection(SettingsTab, "Delays & Performance")

CreateSlider(SettingsTab, "Plant Delay (x100 ms)", 1, 20, math.floor(Config.Settings["Plant Delay"] * 10), function(val)
    Config.Settings["Plant Delay"] = val / 10
end)

CreateSlider(SettingsTab, "Harvest Delay (x100 ms)", 1, 20, math.floor(Config.Settings["Harvest Delay"] * 10), function(val)
    Config.Settings["Harvest Delay"] = val / 10
end)

CreateSlider(SettingsTab, "Sell Delay (x100 ms)", 1, 20, math.floor(Config.Settings["Sell Delay"] * 10), function(val)
    Config.Settings["Sell Delay"] = val / 10
end)

CreateToggle(SettingsTab, "Anti AFK", function(state)
    Config.Settings["Anti AFK"] = state
end)

-- =============================
-- STATS UI
-- =============================
CreateSection(StatsTab, "Player")
local setSheckles = CreateLabel(StatsTab, "Sheckles", "$0")
local setFruit = CreateLabel(StatsTab, "Fruit", "0/200")
local setPets = CreateLabel(StatsTab, "Pets", "0/0")
local setTotalSeeds = CreateLabel(StatsTab, "Seeds", "0 total")
local setPlot = CreateLabel(StatsTab, "Plot", "N/A")

CreateSection(StatsTab, "Garden")
local setPlants = CreateLabel(StatsTab, "Plants", "0/200")
local setSprinklers = CreateLabel(StatsTab, "Sprinklers", "0")
local setDecaying = CreateLabel(StatsTab, "Decaying", "0")

CreateSection(StatsTab, "Session")
local setUptime = CreateLabel(StatsTab, "Uptime", "00:00:00")
local setEarned = CreateLabel(StatsTab, "Earned", "$0")
local setRate = CreateLabel(StatsTab, "Rate", "$0/s")
local setHarvested = CreateLabel(StatsTab, "Harvested", "0")
local setPlanted = CreateLabel(StatsTab, "Planted", "0")
local setSold = CreateLabel(StatsTab, "Sold", "0 times")
local setShovels = CreateLabel(StatsTab, "Shovels", "0")
\n
local LabelMap = {
    ["Sheckles"] = setSheckles,
    ["Fruit"] = setFruit,
    ["Pets"] = setPets,
    ["Seeds"] = setTotalSeeds,
    ["Plot"] = setPlot,
    ["Plants"] = setPlants,
    ["Sprinklers"] = setSprinklers,
    ["Decaying"] = setDecaying,
    ["Uptime"] = setUptime,
    ["Earned"] = setEarned,
    ["Rate"] = setRate,
    ["Harvested"] = setHarvested,
    ["Planted"] = setPlanted,
    ["Sold"] = setSold,
    ["Shovels"] = setShovels,
}
local function SetValue(key, value)
    if LabelMap[key] then
        LabelMap[key](value)
    end
end
\n
-- ============================================================

-- Bộ đếm session
local _sessionStart   = tick()
local _sessionEarned  = 0
local _sessionHarvest = 0
local _sessionPlant   = 0
local _sessionSell    = 0
local _sessionShovel  = 0
local _sessionSeeds   = 0

-- Hook các hàm để đếm session
local _origHarvestPrompt = Modules.harvestPrompt
function Modules.harvestPrompt(prompt)
    local before = _sessionHarvest
    _origHarvestPrompt(prompt)
    -- nếu không bị return sớm thì đã harvest
    _sessionHarvest = _sessionHarvest + 1
    SetValue("Harvested", tostring(_sessionHarvest))
    SetValue("Last", "Harvested")
end

local _origPlantSeed = Modules.plantSeedAtPosition
function Modules.plantSeedAtPosition(pos)
    local result = _origPlantSeed(pos)
    if result then
        _sessionPlant += 1
        SetValue("Planted", tostring(_sessionPlant))
        SetValue("Last", "Planted seed")
    end
    return result
end

local _origShovel = Modules.autoShovelLoop  -- đếm qua log sẽ không chính xác
-- Đếm shovel trực tiếp trong loop, ta patch Networking.Shovel.UseShovel
local _origUseShovel = Networking.Shovel.UseShovel.Fire
Networking.Shovel.UseShovel.Fire = function(self, ...)
    _sessionShovel += 1
    SetValue("Shovels", tostring(_sessionShovel))
    SetValue("Last", "Shoveled plant")
    return _origUseShovel(self, ...)
end

local _origSellAll = Networking.NPCS.SellAll.Fire
Networking.NPCS.SellAll.Fire = function(self, ...)
    _sessionSell += 1
    SetValue("Sold", _sessionSell .. " times")
    SetValue("Last", "Sold fruits")
    return _origSellAll(self, ...)
end

local _origSeedPack = Modules.autoCollectSeedPacksLoop  -- đếm qua biến riêng
local _sessionSeedPacks = 0

-- ========== HÀM ĐỌC DỮ LIỆU GAME ==========
local function fmtMoney(n)
    if n >= 1e9 then return ("$%.1fB"):format(n/1e9)
    elseif n >= 1e6 then return ("$%.1fM"):format(n/1e6)
    elseif n >= 1e3 then return ("$%.1fK"):format(n/1e3)
    else return "$" .. tostring(n) end
end

local function fmtTime(s)
    local h = math.floor(s/3600)
    local m = math.floor((s%3600)/60)
    local sec = math.floor(s%60)
    return ("%02d:%02d:%02d"):format(h, m, sec)
end

local function getPlayerData()
    -- Sheckles / tiền
    local money = 0
    pcall(function()
        money = LP.leaderstats.Sheckles.Value
    end)
    if money == 0 then pcall(function()
        money = LP:FindFirstChild("leaderstats"):FindFirstChild("Sheckles").Value
    end) end

    -- Fruit (backpack)
    local fruitCurrent, fruitMax = 0, 200
    pcall(function()
        local txt = LP.PlayerGui.BackpackGui.Backpack.Inventory.FruitInventory.Text
        local c, m = txt:match("(%d+)/(%d+)")
        if c then fruitCurrent = tonumber(c); fruitMax = tonumber(m) end
    end)

    -- Pets
    local petCurrent, petMax = 0, 0
    pcall(function()
        local petFolder = LP:FindFirstChild("Pets") or LP:FindFirstChild("OwnedPets")
        if petFolder then petCurrent = #petFolder:GetChildren() end
        petMax = LP:GetAttribute("MaxPets") or petMax
    end)

    return money, fruitCurrent, fruitMax, petCurrent, petMax
end

local function getSeedCounts()
    local backpack = LP:FindFirstChildOfClass("Backpack")
    local char     = LP.Character
    local counts   = {}
    local total    = 0
    for _, seedName in ipairs(SEED_NAMES) do counts[seedName] = 0 end
    local function scan(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            local display = SEED_TOOL_MAP[item.Name]
            if display and counts[display] ~= nil then
                counts[display] += 1
                total += 1
            end
        end
    end
    scan(backpack)
    scan(char)
    return counts, total
end

local function getGardenData()
    local plantCount, plantMax, sprinklerCount, decayCount = 0, Config["Max Plant Fruit"] or 200, 0, 0
    local plotId = LP:GetAttribute("PlotId")
    if plotId then
        local gardens = workspace:FindFirstChild("Gardens")
        local plot = gardens and gardens:FindFirstChild("Plot" .. tostring(plotId))
        if plot then
            local plantsFolder = plot:FindFirstChild("Plants")
            if plantsFolder then
                for _, plant in ipairs(plantsFolder:GetChildren()) do
                    if plant:IsA("Model") then
                        plantCount += 1
                        if plant:GetAttribute("Decaying") then decayCount += 1 end
                    end
                end
            end
            for _, obj in ipairs(plot:GetDescendants()) do
                if obj:IsA("Tool") and obj:GetAttribute("Sprinkler") then
                    sprinklerCount += 1
                end
            end
        end
    end
    return plantCount, plantMax, sprinklerCount, decayCount
end

-- ========== STATS LOOP ==========
task.spawn(function()
    local prevMoney = nil
    local earnRate  = 0
    local rateHistory = {}

    while true do
        task.wait(2)

        -- Player stats
        local money, fruitC, fruitM, petC, petM = getPlayerData()
        SetValue("Sheckles", fmtMoney(money))
        SetValue("Fruit",    fruitC .. "/" .. fruitM)
        SetValue("Pets",     petC .. "/" .. petM)
        SetValue("Plot",     tostring(LP:GetAttribute("PlotId") or "N/A"))

        -- Tính rate kiếm tiền
        if prevMoney then
            local diff = money - prevMoney
            if diff > 0 then
                table.insert(rateHistory, diff / 2)
                if #rateHistory > 5 then table.remove(rateHistory, 1) end
                local sum = 0
                for _, v in ipairs(rateHistory) do sum += v end
                earnRate = sum / #rateHistory
                _sessionEarned += diff
            end
        end
        prevMoney = money
        SetValue("Earned", fmtMoney(_sessionEarned))
        SetValue("Rate",   fmtMoney(math.floor(earnRate)) .. "/s")

        -- Seeds
        local counts, total = getSeedCounts()
        SetValue("Seeds", total .. " total")
        for seedName, n in pairs(counts) do
            SetValue(seedName, tostring(n))
        end

        -- Garden
        local pC, pM, sC, dC = getGardenData()
        SetValue("Plants",     pC .. "/" .. pM)
        SetValue("Sprinklers", tostring(sC))
        SetValue("Decaying",   tostring(dC))

        -- Session
        local elapsed = tick() - _sessionStart
        SetValue("Uptime", fmtTime(elapsed))

        -- Stand Center status
        SetValue("Stand Center", Config["Stand Center"].Enable and "ON" or "OFF")
    end
end)

-- Watch backpack changes → cập nhật seed ngay
local function watchContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(item)
        if SEED_TOOL_MAP[item.Name] then
            task.wait(0.05)
            local counts, total = getSeedCounts()
            SetValue("Seeds", total .. " total")
            for k, n in pairs(counts) do SetValue(k, tostring(n)) end
        end
    end)
    container.ChildRemoved:Connect(function(item)
        if SEED_TOOL_MAP[item.Name] then
            task.wait(0.05)
            local counts, total = getSeedCounts()
            SetValue("Seeds", total .. " total")
            for k, n in pairs(counts) do SetValue(k, tostring(n)) end
        end
    end)
end

watchContainer(LP:FindFirstChildOfClass("Backpack"))
LP.CharacterAdded:Connect(function(char)
    watchContainer(char)
    watchContainer(LP:FindFirstChildOfClass("Backpack"))
end)

\n
-- ===========================
-- UI RENDER LOOP
-- ===========================
RunService.RenderStepped:Connect(function(deltaTime)
    -- Shadow sync
    ShadowHolder.Position = UDim2.new(
        MainFrame.Position.X.Scale,
        MainFrame.Position.X.Offset - 10,
        MainFrame.Position.Y.Scale,
        MainFrame.Position.Y.Offset - 6
    )
    ShadowHolder.Size = UDim2.new(
        MainFrame.Size.X.Scale,
        MainFrame.Size.X.Offset + 20,
        MainFrame.Size.Y.Scale,
        MainFrame.Size.Y.Offset + 20
    )
    ShadowHolder.Visible = MainFrame.Visible

    -- FPS Counter
    fpsCount = fpsCount + 1
    if tick() - lastFpsUpdate >= 1 then
        FPSLabel.Text = tostring(fpsCount) .. " FPS"
        fpsCount = 0
        lastFpsUpdate = tick()
    end
end)
\n
-- ============================================================
-- KHỞI CHẠY LOOPS
-- ============================================================

-- ============================================================
task.spawn(Modules.harvestLoop)
task.spawn(Modules.sellLoop)
task.spawn(Modules.sellFullLoop)
task.spawn(Modules.shopLoop)
task.spawn(Modules.autoPlantLoop)
task.spawn(Modules.autoShovelLoop)
task.spawn(Modules.autoCollectSeedPacksLoop)
task.spawn(Modules.autoBuyPetSpawnLoop)
task.spawn(Modules.antiAfkLoop)\ntask.spawn(Modules.autoStealLoop)\ntask.spawn(Modules.autoCollectDropsLoop)
task.spawn(Modules.standCenterLoop)

print("Moonlight Hub - Config + GaG2 + UI loaded!")
\n-- ===========================
-- ENTRY ANIMATION
-- ===========================
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.BackgroundTransparency = 1

wait(0.1)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 500, 0, 380),
    BackgroundTransparency = 0
}):Play()