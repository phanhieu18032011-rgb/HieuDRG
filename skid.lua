-- [TBoy Roblox Tổng Hợp Hubs - 2025 Edition]
-- Author: STELLAR (Dựa trên Bandishare + GitHub/V3rmillion)
-- UI: Fluent (Tương thích Mobile/PC)

local ScreenGui = Instance.new("ScreenGui")
local ImageButton = Instance.new("ImageButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ImageButton.Parent = ScreenGui
ImageButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ImageButton.BorderSizePixel = 0
ImageButton.Position = UDim2.new(0.10615778, 0, 0.16217947, 0)
ImageButton.Size = UDim2.new(0, 40, 0, 40)
ImageButton.Draggable = true
ImageButton.Image = "http://www.roblox.com/asset/?id=83190276951914"

UICorner.CornerRadius = UDim.new(1, 10) 
UICorner.Parent = ImageButton

ImageButton.MouseButton1Down:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.End, false, game)
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
repeat wait() until game:IsLoaded()
local Window = Fluent:CreateWindow({
    Title = "TBoy Roblox Tổng Hợp Hubs 2025",
    SubTitle = "Multi-Game Loader",
    TabWidth = 157,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.End
})

local Tabs = {
    Main0 = Window:AddTab({ Title = "Thông Tin" }),
    BloxFruits = Window:AddTab({ Title = "Blox Fruits" }),
    GrowGarden = Window:AddTab({ Title = "Grow a Garden" }),
    StealBrainrot = Window:AddTab({ Title = "Steal a Brainrot" }),
    NightForest = Window:AddTab({ Title = "99 Nights in the Forest" }),
    HuntZombie = Window:AddTab({ Title = "Hunt Zombie" }),
    Misc = Window:AddTab({ Title = "Linh Tinh" }),
}

-- [TAB THÔNG TIN]
Tabs.Main0:AddButton({
    Title = "Discord TBoy",
    Description = "Community",
    Callback = function()
        setclipboard("https://discord.gg/tboyroblox-community-1253927333920899153")
        Fluent:Notify({Title="Copied!", Content="Discord link copied!"})
    end
})

Tabs.Main0:AddButton({
    Title = "YouTube TBoy Roblox",
    Description = "Channel 1",
    Callback = function()
        setclipboard("https://www.youtube.com/@TBoyRoblox08")
        Fluent:Notify({Title="Copied!", Content="YouTube link copied!"})
    end
})

Tabs.Main0:AddButton({
    Title = "YouTube TBoy Gamer",
    Description = "Channel 2",
    Callback = function()
        setclipboard("https://www.youtube.com/@TBoyGamer08")
        Fluent:Notify({Title="Copied!", Content="YouTube link copied!"})
    end
})

-- [TAB BLOX FRUITS - 10+ Hubs từ Bandishare/GitHub]
Tabs.BloxFruits:AddButton({
    Title = "Redz Hub Blox Fruits",
    Description = "NO KEY - Auto Farm/Boss/Raid (Bandishare Update 24)",
    Callback = function()
        local Settings = { JoinTeam = "Pirates", Translator = true }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
    end
})

Tabs.BloxFruits:AddButton({
    Title = "GreenZ Hub Blox Fruits",
    Description = "NO KEY - Farm Fruit/Chest (GitHub 2025)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaAnarchist/GreenZ-Hub/refs/heads/main/KaitunDoughKing.lua"))()
    end
})

Tabs.BloxFruits:AddButton({
    Title = "Quantum Onyx Hub",
    Description = "NO KEY - Full Auto Farm Update 28",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
    end
})

Tabs.BloxFruits:AddButton({
    Title = "Netna Hub Blox Fruits",
    Description = "KEY - Auto Farm Candy Update 19 (Bandishare)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NetnaHub/BloxFruits/main/NetnaHub.lua"))()
    end
})

Tabs.BloxFruits:AddButton({
    Title = "Fluxus Blox Fruits Script",
    Description = "NO KEY - Mobile Farm (Bandishare V12)",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/abc123fluxusbf"))()  -- Placeholder từ Bandishare hướng dẫn
    end
})

Tabs.BloxFruits:AddButton({
    Title = "Hydrogen Blox Fruits",
    Description = "NO KEY - Update 20 Raid/Boss",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HydrogenHub/BloxFruits/main/Hydrogen.lua"))()
    end
})

Tabs.BloxFruits:AddButton({
    Title = "Thunder Z Hub",
    Description = "KEY - Auto Race V4 (Bandishare Update 19)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ThunderZ/BloxFruits/main/ThunderZ.lua"))()
    end
})

Tabs.BloxFruits:AddButton({
    Title = "Powered V2 Blox Fruits",
    Description = "NO KEY - Farm Chest/Fruit",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/PoweredV2/BloxFruits/main/Powered.lua"))()
    end
})

Tabs.BloxFruits:AddButton({
    Title = "HoHo Hub Blox Fruits",
    Description = "NO KEY - Full Script Update 28",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_Hub/main/Loading_UI"))()
    end
})

Tabs.BloxFruits:AddButton({
    Title = "Dough Hub Blox Fruits",
    Description = "NO KEY - Auto Dough King",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NetnaHub/BloxFruits/main/NetnaHub.lua"))()
    end
})

-- [TAB GROW A GARDEN - 5+ Hubs từ GitHub (Không có trên Bandishare)]
Tabs.GrowGarden:AddButton({
    Title = "Garden Farm Hub",
    Description = "NO KEY - Auto Plant/Harvest",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GardenHub/GrowAGarden/main/Farm.lua"))()
    end
})

Tabs.GrowGarden:AddButton({
    Title = "Bucket Eyes Grow",
    Description = "NO KEY - Auto Grow Bucket",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/gardenbucket2025"))()
    end
})

Tabs.GrowGarden:AddButton({
    Title = "Auto Garden Pro",
    Description = "KEY - Multi-Plant Farm",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AutoGardenPro/main/GrowGarden.lua"))()
    end
})

Tabs.GrowGarden:AddButton({
    Title = "Simple Garden ESP",
    Description = "NO KEY - Item ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SimpleGarden/ESP/main/GardenESP.lua"))()
    end
})

Tabs.GrowGarden:AddButton({
    Title = "Garden Speed Hub",
    Description = "NO KEY - Speed Grow",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/gardenspeed"))()
    end
})

-- [TAB STEAL A BRAINROT - 4 Hubs (Ít script, từ V3rmillion/GitHub)]
Tabs.StealBrainrot:AddButton({
    Title = "Brainrot Steal Hub",
    Description = "NO KEY - Auto Steal Items",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BrainrotHub/Steal/main/StealBrainrot.lua"))()
    end
})

Tabs.StealBrainrot:AddButton({
    Title = "Steal Rot Pro",
    Description = "KEY - ESP + Teleport",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/stealrotpro"))()
    end
})

Tabs.StealBrainrot:AddButton({
    Title = "Brainrot Farm",
    Description = "NO KEY - Auto Farm Rot",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FarmBrainrot/main/Farm.lua"))()
    end
})

Tabs.StealBrainrot:AddButton({
    Title = "Steal ESP Hub",
    Description = "NO KEY - Item ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ESPHub/Steal/main/ESP.lua"))()
    end
})

-- [TAB 99 NIGHTS IN THE FOREST - 3 Hubs từ GitHub (Không có trên Bandishare)]
Tabs.NightForest:AddButton({
    Title = "99 Nights Aura Hub",
    Description = "NO KEY - Kill/Chop Aura",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qiwikox12/stubrawl/refs/heads/main/99Night.txt"))()
    end
})

Tabs.NightForest:AddButton({
    Title = "Forest ESP Pro",
    Description = "KEY - Item/Mob ESP",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/forestesp"))()
    end
})

Tabs.NightForest:AddButton({
    Title = "Night Fly Hub",
    Description = "NO KEY - Fly + Speed",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ForestFly/main/NightFly.lua"))()
    end
})

-- [TAB HUNT ZOMBIE - 5 Hubs từ GitHub (Không có trên Bandishare)]
Tabs.HuntZombie:AddButton({
    Title = "Zombie Hunt Aura",
    Description = "NO KEY - Auto Kill Zombies",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZombieAuraHub/main/Hunt.lua"))()
    end
})

Tabs.HuntZombie:AddButton({
    Title = "Hunt ESP Hub",
    Description = "NO KEY - Zombie ESP",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/huntesp"))()
    end
})

Tabs.HuntZombie:AddButton({
    Title = "Zombie Farm Pro",
    Description = "KEY - Auto Farm",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FarmZombiePro/main/ZHunt.lua"))()
    end
})

Tabs.HuntZombie:AddButton({
    Title = "Hunt Speed Hub",
    Description = "NO KEY - Speed + Jump",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SpeedHunt/main/HuntSpeed.lua"))()
    end
})

Tabs.HuntZombie:AddButton({
    Title = "Zombie Teleport",
    Description = "NO KEY - TP to Zombies",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/zombietp"))()
    end
})

-- [TAB LINH TÍNH - Thêm 3 Hubs chung]
Tabs.Misc:AddButton({
    Title = "Universal Fly Script",
    Description = "NO KEY - Fly cho mọi game",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/UniversalFly/main/Fly.lua"))()
    end
})

Tabs.Misc:AddButton({
    Title = "ESP Universal",
    Description = "NO KEY - Item ESP",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ESPUniversal/main/ESP.lua"))()
    end
})

Tabs.Misc:AddButton({
    Title = "Speed Hack All Games",
    Description = "NO KEY - WalkSpeed x16",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/universalspeed"))()
    end
})

print("TBoy Roblox Tổng Hợp Loaded! - 25+ Hubs Ready (NO/KEY Marked)")
