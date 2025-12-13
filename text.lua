--[[
    Tập lệnh 99 NIGHT IN THE FOREST - Chuyển đổi sang Redz UI
    Đã sửa lỗi không hiển thị UI do sai cấu trúc lệnh MakeTab.
    Toàn bộ logic chức năng được giữ nguyên. Chỉ thay đổi giao diện.
--]]

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/daucobonhi/UiRedzV5/refs/heads/main/DemoUi.lua"))();

-- Dịch vụ Roblox
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- === [ KHAI BÁO BIẾN GỐC ] ===

-- Combat
local killAuraToggle = false
local chopAuraToggle = false
local auraRadius = 50
local currentammount = 0 -- Biến này không được sử dụng trong logic gốc, giữ nguyên

local toolsDamageIDs = {
    ["Old Axe"] = "3_7367831688",
    ["Good Axe"] = "112_7367831688",
    ["Strong Axe"] = "116_7367831688",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

-- Auto Food
local autoFeedToggle = false
local selectedFood = "Carrot"
local hungerThreshold = 75
local alwaysFeedEnabledItems = {} -- Không được sử dụng trong logic gốc, giữ nguyên
local alimentos = {
    "Apple",
    "Berry",
    "Carrot",
    "Cake",
    "Chili",
    "Cooked Morsel",
    "Cooked Steak"
}

-- ESP
local ie = {
    "Bandage", "Bolt", "Broken Fan", "Broken Microwave", "Cake", "Carrot", "Chair", "Coal", "Coin Stack",
    "Cooked Morsel", "Cooked Steak", "Fuel Canister", "Glass", "Herb", "Large Rock", "Log", "Matches",
    "Medkit", "Nut", "Old Axe", "Old Rifle", "Old Sheet", "Old Tool", "Orange Bottle", "Plank", "Rock",
    "Rope", "Rotten Apple", "Rotten Berry", "Rope", "Small Rock", "Stick", "Strong Axe", "Water Bottle",
    "Wood"
}
local espEnabled = false
local espLoop = nil
local espRenderedItems = {}

-- Auto Loot/Interact & Auto Stun Deer
local instantInteractEnabled = false
local instantInteractConnection = nil
local originalHoldDurations = {}
local torchLoop = nil

-- === [ HÀM HỖ TRỢ GỐC ] ===

-- Combat
local function getTool()
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        if toolsDamageIDs[tool.Name] then
            return tool
        end
    end
    return nil
end

-- Auto Food
local function findFood(foodName)
    local backpack = LocalPlayer.Backpack
    local starterGear = LocalPlayer.StarterGear
    
    local item = backpack:FindFirstChild(foodName)
    if not item then
        item = starterGear:FindFirstChild(foodName)
    end
    
    if item and item:IsA("Tool") then
        return item
    end
    return nil
end

-- ESP
local function removeEspItem(part)
    if espRenderedItems[part] then
        espRenderedItems[part]:Destroy()
        espRenderedItems[part] = nil
    end
end

local function updateEspRender()
    for part, billboard in pairs(espRenderedItems) do
        if not part or not part.Parent then
            removeEspItem(part)
        end
    end
    
    local itemsFolder = Workspace:FindFirstChild("Items")
    if itemsFolder then
        for _, item in ipairs(itemsFolder:GetChildren()) do
            local itemName = item.Name
            
            -- Kiểm tra xem item có trong danh sách ESP và chưa được render không
            local isTargetItem = false
            for _, name in ipairs(ie) do
                if name == itemName then
                    isTargetItem = true
                    break
                end
            end
            
            if isTargetItem and not espRenderedItems[item] then
                -- Render ESP
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ItemESP"
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.Adornee = item
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextScaled = true
                textLabel.TextStrokeTransparency = 0
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                textLabel.Text = itemName .. " (" .. math.floor((LocalPlayer.Character.HumanoidRootPart.Position - item.Position).Magnitude) .. "m)"
                textLabel.Parent = billboard
                
                billboard.Parent = game.Workspace
                espRenderedItems[item] = billboard
            elseif not isTargetItem and espRenderedItems[item] then
                -- Nếu item không còn là mục tiêu nhưng đang được render (chỉ xảy ra nếu logic thay đổi), hãy xóa nó.
                removeEspItem(item)
            end
        end
    end
end

local function cleanUpEsp()
    for _, billboard in pairs(espRenderedItems) do
        billboard:Destroy()
    end
    espRenderedItems = {}
end

-- === [ THIẾT LẬP REDZ UI ] ===

local Windows = redzlib:MakeWindow({
    Title = "99 Night Hub",
    SubTitle = "Ported by Gemini (Redz UI)",
    SaveFolder = "99Night.lua" -- Tên tệp lưu cài đặt
})

Windows:AddMinimizeButton({
  Button = { Image = "rbxassetid://131151731604309", BackgroundTransparency = 0 },
  Corner = { CornerRadius = UDim.new(0, 6) }
})

-- SỬA LỖI: Tạo các Tab bằng cách truyền vào bảng (table)
local TabCombat = Windows:MakeTab({"Combat"})
local TabFood = Windows:MakeTab({"Food"})
local TabWorld = Windows:MakeTab({"World"})
local TabESP = Windows:MakeTab({"ESP"})

-- === [ TAB COMBAT (Chiến đấu) ] ===

-- LOGIC GỐC: Kill Aura Loop
local killLoop = nil
local function startKillAura()
    if killLoop then killLoop:Disconnect() end
    killLoop = RunService.Heartbeat:Connect(function()
        pcall(function()
            if not killAuraToggle then return end
            local tool = getTool()
            local remote = ReplicatedStorage:FindFirstChild("RemoteEvents") 
                and ReplicatedStorage.RemoteEvents:FindFirstChild("DamagePlayer")
            
            if tool and remote and LocalPlayer.Character and LocalPlayer.Character.Humanoid.Health > 0 then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character.Humanoid.Health > 0 then
                        local root = player.Character:FindFirstChild("HumanoidRootPart")
                        local myRoot = LocalPlayer.Character.HumanoidRootPart
                        if root and myRoot and (root.Position - myRoot.Position).Magnitude <= auraRadius then
                            remote:InvokeServer(player, toolsDamageIDs[tool.Name], tool:GetMass(), tool.Name)
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end)
end

-- LOGIC GỐC: Chop Aura Loop
local chopLoop = nil
local function startChopAura()
    if chopLoop then chopLoop:Disconnect() end
    chopLoop = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not chopAuraToggle then return end
            
            local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                and ReplicatedStorage.RemoteEvents:FindFirstChild("HitTree")
            local tool = getTool()
            
            if remote and tool and tool.Name ~= "Chainsaw" then
                local myRoot = LocalPlayer.Character.HumanoidRootPart
                for _, tree in ipairs(Workspace.Trees:GetChildren()) do
                    local wood = tree:FindFirstChild("Wood")
                    if wood and (wood.Position - myRoot.Position).Magnitude <= auraRadius then
                        remote:InvokeServer(tree.Name, toolsDamageIDs[tool.Name])
                    end
                end
            end
        end)
        task.wait(0.1)
    end)
end

-- 1. Toggle Kill Aura
TabCombat:AddToggle({
    Name = "Auto Kill Aura",
    Callback = function(state)
        killAuraToggle = state
        if state then
            startKillAura()
        else
            if killLoop then 
                killLoop:Disconnect() 
                killLoop = nil
            end
        end
    end
})

-- 2. Toggle Chop Aura
TabCombat:AddToggle({
    Name = "Auto Chop Aura",
    Callback = function(state)
        chopAuraToggle = state
        if state then
            startChopAura()
        else
            if chopLoop then 
                chopLoop:Disconnect() 
                chopLoop = nil
            end
        end
    end
})

-- 3. Slider Aura Radius
TabCombat:AddSlider({
    Name = "Aura Radius",
    Min = 5,
    Max = 100,
    Default = auraRadius,
    Rounding = 0,
    Callback = function(value)
        auraRadius = value
    end
})

-- === [ TAB FOOD (Thức ăn) ] ===

-- LOGIC GỐC: Auto Feed Loop
local autoFeedLoop = nil
local function startAutoFeed()
    if autoFeedLoop then autoFeedLoop:Disconnect() end
    autoFeedLoop = RunService.RenderStepped:Connect(function()
        pcall(function()
            if not autoFeedToggle then return end
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local hunger = humanoid:GetAttribute("Hunger") or 100
                if hunger <= hungerThreshold then
                    local foodTool = findFood(selectedFood)
                    if foodTool then
                        local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                            and ReplicatedStorage.RemoteEvents:FindFirstChild("UseFood")
                        if remote then
                            remote:InvokeServer(foodTool)
                            -- Logic gốc có task.wait(0.5) bên trong vòng lặp RenderStepped
                            task.wait(0.5)
                        end
                    end
                end
            end
        end)
    end)
end


-- 1. Toggle Auto Feed
TabFood:AddToggle({
    Name = "Auto Feed",
    Callback = function(state)
        autoFeedToggle = state
        if state then
            startAutoFeed()
        else
            if autoFeedLoop then 
                autoFeedLoop:Disconnect() 
                autoFeedLoop = nil
            end
        end
    end
})

-- 2. Dropdown Food Selector
TabFood:AddDropdown({
    Name = "Select Food",
    List = alimentos,
    Default = selectedFood,
    Callback = function(value)
        selectedFood = value
    end
})

-- 3. Slider Hunger Threshold
TabFood:AddSlider({
    Name = "Hunger Threshold",
    Min = 1,
    Max = 100,
    Default = hungerThreshold,
    Rounding = 0,
    Callback = function(value)
        hungerThreshold = value
    end
})


-- === [ TAB WORLD (Thế giới) ] ===

-- 1. Toggle Instant Interact
TabWorld:AddToggle({
    Name = "Instant Interact",
    Callback = function(state)
        instantInteractEnabled = state
        if state then
            -- LOGIC GỐC: Tắt HoldDuration
            local function disableHoldDuration()
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.HoldDuration > 0 and not originalHoldDurations[prompt] then
                        originalHoldDurations[prompt] = prompt.HoldDuration
                        prompt.HoldDuration = 0
                    end
                end
            end

            instantInteractConnection = RunService.RenderStepped:Connect(function()
                pcall(function()
                    disableHoldDuration()
                end)
                task.wait(0.5) -- Logic gốc có task.wait(0.5) bên trong vòng lặp RenderStepped
            end)
        else
            -- LOGIC GỐC: Khôi phục HoldDuration
            if instantInteractConnection then
                instantInteractConnection:Disconnect()
                instantInteractConnection = nil
            end
            for obj, value in pairs(originalHoldDurations) do
                if obj and obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = value
                end
            end
            originalHoldDurations = {}
        end
    end
})

-- 2. Toggle Auto Stun Deer
TabWorld:AddToggle({
    Name = "Auto Stun Deer",
    Callback = function(state)
        if state then
            -- LOGIC GỐC: Stun Deer Loop
            torchLoop = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                        and ReplicatedStorage.RemoteEvents:FindFirstChild("DeerHitByTorch")
                    local deer = workspace:FindFirstChild("Characters")
                        and workspace.Characters:FindFirstChild("Deer")
                    if remote and deer then
                        remote:InvokeServer(deer)
                    end
                end)
                task.wait(0.1) -- Logic gốc có task.wait(0.1) bên trong vòng lặp RenderStepped
            end)
        else
            if torchLoop then
                torchLoop:Disconnect()
                torchLoop = nil
            end
        end
    end
})


-- === [ TAB ESP (Visual) ] ===

-- 1. Toggle Item ESP
TabESP:AddToggle({
    Name = "Item ESP (All items in list)",
    Callback = function(state)
        espEnabled = state
        if state then
            -- LOGIC GỐC: Bật ESP Loop
            espLoop = RunService.RenderStepped:Connect(function()
                pcall(function()
                    updateEspRender()
                end)
            end)
        else
            -- LOGIC GỐC: Tắt ESP Loop và dọn dẹp
            if espLoop then
                espLoop:Disconnect()
                espLoop = nil
            end
            cleanUpEsp()
        end
    end
})

-- Thêm một Label đơn giản để hiển thị danh sách các items (chức năng không cần thay đổi)
TabESP:AddLabel("Items to track: "..table.concat(ie, ", "))


-- Khởi tạo ban đầu (chỉ dùng để đảm bảo các biến global có giá trị ban đầu nếu cần)
-- Logic gốc không có code khởi tạo nào khác ngoài việc định nghĩa biến và UI.
