-- MY_ORIGINAL_SCRIPT
print("hello world")

local LocalPlayer = game:GetService("Players").LocalPlayer
local Locations = workspace._WorldOrigin.Locations

-- UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/uwuware"))()

local Window = Library:CreateWindow("Chest Farm", {
    main_color = Color3.fromRGB(255, 0, 0),
    min_size = Vector2.new(500, 400),
    toggle_key = Enum.KeyCode.RightShift,
    can_resize = true
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Settings = Window:AddTab("Settings")
}

local FarmEnabled = false
local AutoTeamEnabled = false

-- Main Tab
local MainSection = Tabs.Main:AddSection("Farm Settings", {
    column = 1
})

local FarmToggle = MainSection:AddToggle("Enable Chest Farm", {
    flag = "farm_toggle",
    callback = function(value)
        FarmEnabled = value
        if value then
            startFarm()
        end
    end
})

local TeamSection = Tabs.Main:AddSection("Team Settings", {
    column = 2
})

local TeamToggle = TeamSection:AddToggle("Auto Join Marines", {
    flag = "team_toggle",
    callback = function(value)
        AutoTeamEnabled = value
    end
})

-- Settings Tab
local ThemeSection = Tabs.Settings:AddSection("UI Theme", {
    column = 1
})

local ColorPresets = {
    "Rainbow", "Red", "Orange", "Yellow", "Green", "Blue", "Purple", "Pink"
}

local ColorDropdown = ThemeSection:AddDropdown("Color Theme", {
    location = Library.flags,
    flag = "ui_theme",
    list = ColorPresets,
    callback = function(value)
        local colorMap = {
            Rainbow = Color3.fromRGB(255, 0, 0),
            Red = Color3.fromRGB(255, 0, 0),
            Orange = Color3.fromRGB(255, 165, 0),
            Yellow = Color3.fromRGB(255, 255, 0),
            Green = Color3.fromRGB(0, 255, 0),
            Blue = Color3.fromRGB(0, 0, 255),
            Purple = Color3.fromRGB(128, 0, 128),
            Pink = Color3.fromRGB(255, 192, 203)
        }
        Library:ChangeColor(colorMap[value] or Color3.fromRGB(255, 0, 0))
    end
})

ThemeSection:AddButton("Save Settings", function()
    Library:SaveConfig()
end)

ThemeSection:AddButton("Load Settings", function()
    Library:LoadConfig()
end)

-- Original functionality
local function getCharacter()
    if not LocalPlayer.Character then
        LocalPlayer.CharacterAdded:Wait()
    end
    LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    return LocalPlayer.Character
end

local function DistanceFromPlrSort(ObjectList: table)
    local RootPart = getCharacter().LowerTorso
    table.sort(ObjectList, function(ChestA, ChestB)
        local RootPos = RootPart.Position
        local DistanceA = (RootPos - ChestA.Position).Magnitude
        local DistanceB = (RootPos - ChestB.Position).Magnitude
        return DistanceA < DistanceB
    end
end

local UncheckedChests, FirstRun = {}, true
local function getChestsSorted()
    if FirstRun then
        FirstRun = false
        for _, Object in pairs(game:GetDescendants()) do
            if Object.Name:find("Chest") and Object.ClassName == "Part" then
                table.insert(UncheckedChests, Object)
            end
        end
    end
    local Chests = {}
    for _, Chest in pairs(UncheckedChests) do
        if Chest:FindFirstChild("TouchInterest") then
            table.insert(Chests, Chest)
        end
    end
    DistanceFromPlrSort(Chests)
    return Chests
end

local function toggleNoclip(Toggle: boolean)
    for _, v in pairs(getCharacter():GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = not Toggle
        end
    end
end

local function Teleport(Goal: CFrame)
    local RootPart = getCharacter().HumanoidRootPart
    toggleNoclip(true)
    RootPart.CFrame = Goal + Vector3.new(0, 3, 0)
    toggleNoclip(false)
end

local FarmConnection
local function startFarm()
    if FarmConnection then
        FarmConnection:Disconnect()
        FarmConnection = nil
    end
    
    FarmConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if FarmEnabled then
            local Chests = getChestsSorted()
            if #Chests > 0 then
                Teleport(Chests[1].CFrame)
            end
        end
    end)
end

-- Auto Team
local TeamConnection
local function startAutoTeam()
    if TeamConnection then
        TeamConnection:Disconnect()
        TeamConnection = nil
    end
    
    TeamConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if AutoTeamEnabled then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam","Marines")
            end)
        end
    end)
end

-- Initialize auto team
startAutoTeam()

-- Character handling
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if FarmEnabled then
        startFarm()
    end
end)

-- Load default theme
ColorDropdown:Set("Rainbow")

Library:Init()
