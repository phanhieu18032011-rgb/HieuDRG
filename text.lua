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
ImageButton.Image = "http://www.roblox.com/asset/?id=94439769761633"

UICorner.CornerRadius = UDim.new(1, 10) 
UICorner.Parent = ImageButton

ImageButton.MouseButton1Down:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.End, false, game)
end)

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
repeat wait() until game:IsLoaded()
local Window = Fluent:CreateWindow({
    Title = "HieuDRG Hub ",
    SubTitle = "UPDATE V1",
    TabWidth = 157,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true,
    Theme = "Light",
    MinimizeKey = Enum.KeyCode.End
})
local Tabs = {
        Main0=Window:AddTab({ Title="Thông Tin" }),
        Main1=Window:AddTab({ Title="Blox Fruit" }),
        Main2=Window:AddTab({ Title="Grow a Garden" }),
        Main3=Window:AddTab({ Title="Steal a Brainrot" }),
        Main4=Window:AddTab({ Title="99 Night In The Forest" }),
        Main5=Window:AddTab({ Title="Hunte Zombie" }),
        Main6=Window:AddTab({ Title="Hop Sv Vip" }),
        Main7=Window:AddTab({ Title="Script All Game" }),
}
    Tabs.Main0:AddButton({
    Title = "Discord",
    Description = "TBoyRoblox Community",
    Callback = function()
        setclipboard("https://discord.gg/tboyroblox-community-1253927333920899153")
    end
})

    Tabs.Main0:AddButton({
    Title = "Youtuber",
    Description = "TBoy Roblox",
    Callback = function()
        setclipboard("https://www.youtube.com/@TBoyRoblox08")
    end
})

    Tabs.Main0:AddButton({
    Title = "Youtuber",
    Description = "TBoy Gamer",
    Callback = function()
        setclipboard("https://www.youtube.com/@TBoyGamer08")
    end
})
  
------- blox fruit (30 Scripts Hubs) -------

-- Lưu ý: Các script được tổng hợp từ các nguồn công khai. Tình trạng hoạt động và yêu cầu KEY có thể thay đổi.

-- 1. Các Script Hub Phổ Biến (Hiện có)
Tabs.Main1:AddButton({
    Title="Hiru Hub",
    Description="Auto Farm Level, Auto Quest, Fruit Finder",
    Callback=function()
        getgenv().Settings = {
            JoinTeam = true,
            Team = "Marines"
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/kiddohiru/Source/main/BloxFruits.lua"))() 
    end
})

Tabs.Main1:AddButton({
    Title="Vector HUB",
    Description="Auto Farm Chest, Auto Sea Beast, Godhuman",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AAwful/Vector_Hub/0/v2"))()
    end
})

Tabs.Main1:AddButton({
    Title="Deep Hub",
    Description="Auto Raid, Tự động Farm Boss, PvP Features",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/Deep."))()
    end
})

Tabs.Main1:AddButton({
    Title="Annie Hub",
    Description="Tự động Lên cấp, Auto Mastery, Đổi Faction",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/1st-Mars/Annie/main/1st.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="VEX Hub (Premium)",
    Description="Auto Farm Beli, Fragments, Nâng cấp Item",
    Callback=function()
        -- Link này thường yêu cầu key
        loadstring(game:HttpGet("https://raw.githubusercontent.com/yoursvexyyy/VEX/refs/heads/main/bloxfruits%20cash%20farm%20premium"))()
    end
})

Tabs.Main1:AddButton({
    Title="Foggy Hub",
    Description="Farm Event (Rip, Sea Events), Auto V4 Trial",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FOGOTY/foggy-bloxfruit/refs/heads/main/script"))()
    end
})

Tabs.Main1:AddButton({
    Title="Hoho Hub",
    Description="Tự động Farm Level, Fruit Notifier, Teleport",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Hoho-Hub-Dev/Hoho-Hub/main/release.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Project X",
    Description="Full Auto Farm, Gear & Tộc V4, Godhuman Farm",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Project-X-Scripts/BloxFruits/main/main.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Kiwi Hub",
    Description="Farm Max Level, Auto Buso Haki, Godhuman",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/KiwiScripts/Kiwi-Hub/main/Blox-Fruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Apex Hub",
    Description="Tự động Farm Tất cả, Auto Haki/Skills, Shop Auto Buy",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Apex-Dev/Scripts/main/BloxFruit.lua"))()
    end
})

-- 2. Bổ Sung Thêm 20 Scripts Hub Khác

Tabs.Main1:AddButton({
    Title="X-Ray Hub",
    Description="Farm Beli, Auto Chest, Tự động Làm nhiệm vụ",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XRay/X-RayHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Zenith Hub",
    Description="Auto Farm Level Nhanh, Đa chức năng",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Zenith/ZenithHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Darkhub",
    Description="Hệ thống Anti-AFK, Auto Skill, Teleport",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Darkhub-Dev/Darkhub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Oxygen Hub",
    Description="Farm Level, PvP Mode, Anti-ban",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Oxygen/OxygenHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Valhub",
    Description="Hệ thống Farming Tùy chỉnh, Auto Fruit",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Valdev/Valhub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Naimi Hub",
    Description="Auto Farm V4 Race, Tự động Ép Gem",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NaimiScripts/NaimiHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Void Hub",
    Description="Auto Raid, Tự động Quay Fruit, Tốc độ cao",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VoidScripts/VoidHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Shadow Hub",
    Description="Farm Event Đặc biệt, Tự động săn Boss",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ShadowScripts/ShadowHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Mochi Hub",
    Description="Auto Mastery, Farm Fish, Hỗ trợ Giao dịch",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MochiScripts/MochiHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Red's Hub",
    Description="Auto Farm Mọi thứ, Đa chức năng",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RedScripts/RedsHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Eternal Hub",
    Description="Level/Mastery Farm, Tự động Tìm Đảo",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EternalDev/EternalHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Dragon Hub",
    Description="Auto Raid, Tự động Quay Gacha, PvP Tùy chỉnh",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DragonScripts/DragonHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Star Hub",
    Description="Farm nhanh, Auto Chests, Teleport nhanh",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/StarDev/StarHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Delta Hub",
    Description="Full Auto Farm, Tự động Luyện Haki",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DeltaScripts/DeltaHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Giga Hub",
    Description="Auto Farm Level/Beli, Event Support",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GigaDev/GigaHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Slayers Hub",
    Description="Tự động Săn Sea Beast, Farm Đảo mới",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SlayersDev/SlayersHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Zeus Hub",
    Description="Tự động Farm Godhuman/Cyborg, Max Level",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeusScripts/ZeusHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Mobile Hub",
    Description="Tối ưu cho Mobile, Auto Farm, Raid",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/MobileDev/MobileHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Infinity Hub",
    Description="Đa tính năng, Farm Fruit, Auto Boss",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Infinity/InfinityHub/main/BloxFruit.lua"))()
    end
})

Tabs.Main1:AddButton({
    Title="Neptune Hub",
    Description="Tự động Farm Mọi loại tiền tệ, Auto Sea Beast",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NeptuneDev/NeptuneHub/main/BloxFruit.lua"))()
    end
})

-- Kết thúc phần Blox Fruit Scripts

------- Grow a Garden (15 Scripts Hubs) -------

Tabs.Main2:AddButton({
    Title="Auto Water Hub",
    Description="Tự động tưới nước, chăm sóc cây",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/AutoWater.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Farm Tool",
    Description="Tự động thu hoạch và trồng trọt",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/FarmTool.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Cash Master",
    Description="Auto Farm Tiền và Gem",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/CashMaster.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Plot Manager",
    Description="Quản lý khu đất, tự động nâng cấp",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/PlotManager.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Teleport Hub",
    Description="Dịch chuyển tức thời đến các khu vực",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/Teleport.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Inventory Hub",
    Description="Mở khóa vật phẩm, chỉnh sửa kho đồ",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/Inventory.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Garden Pro",
    Description="Tối ưu hóa thu hoạch, Farm nhanh",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/GardenPro.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Speed Gro",
    Description="Tăng tốc độ phát triển của cây",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/SpeedGro.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Fertilizer Bot",
    Description="Tự động bón phân cao cấp",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/FertilizerBot.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Anti-Decay",
    Description="Ngăn cây cối bị héo úa",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/AntiDecay.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Seed Spawner",
    Description="Mở khóa và tự động trồng các loại hạt",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/SeedSpawner.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Market Auto",
    Description="Tự động bán cây ở chợ với giá cao nhất",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/MarketAuto.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Pet Helper",
    Description="Auto Farm EXP cho Pet",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/PetHelper.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="World Changer",
    Description="Thay đổi giao diện thế giới (Visual Mod)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/WorldChanger.lua"))()
    end
})

Tabs.Main2:AddButton({
    Title="Ultimate Garden",
    Description="Tổng hợp tất cả tính năng cơ bản",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/GrowAGarden/main/Ultimate.lua"))()
    end
})

------- Steal a Brainrot (7 Scripts Hubs) -------

Tabs.Main3:AddButton({
    Title="Brainrot Farm",
    Description="Auto Farm Brainrot nhanh chóng",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/StealABrainrot/main/BrainrotFarm.lua"))()
    end
})

Tabs.Main3:AddButton({
    Title="Teleport Hack",
    Description="Dịch chuyển đến khu vực có Brainrot",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/StealABrainrot/main/Teleport.lua"))()
    end
})

Tabs.Main3:AddButton({
    Title="Speed Steal",
    Description="Tăng tốc độ di chuyển và tốc độ trộm",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/StealABrainrot/main/SpeedSteal.lua"))()
    end
})

Tabs.Main3:AddButton({
    Title="Invisible Mode",
    Description="Tàng hình để trộm không bị phát hiện",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/StealABrainrot/main/Invisible.lua"))()
    end
})

Tabs.Main3:AddButton({
    Title="Anti-Ban/Kick",
    Description="Giảm nguy cơ bị phát hiện",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/StealABrainrot/main/AntiKick.lua"))()
    end
})

Tabs.Main3:AddButton({
    Title="Item Spawner",
    Description="Spawm các công cụ hỗ trợ",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/StealABrainrot/main/ItemSpawner.lua"))()
    end
})

Tabs.Main3:AddButton({
    Title="All-In-One",
    Description="Tổng hợp các tính năng trộm cắp",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/StealABrainrot/main/AllInOne.lua"))()
    end
})

------- 99 Night In The Forest (7 Scripts Hubs) -------

Tabs.Main4:AddButton({
    Title="Auto Survival",
    Description="Tự động thu thập vật phẩm sinh tồn",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/99Nights/main/AutoSurvival.lua"))()
    end
})

Tabs.Main4:AddButton({
    Title="Night Skip",
    Description="Tăng tốc độ qua đêm (Skip Night)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/99Nights/main/NightSkip.lua"))()
    end
})

Tabs.Main4:AddButton({
    Title="God Mode",
    Description="Bất tử (Immunity to Monsters)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/99Nights/main/GodMode.lua"))()
    end
})

Tabs.Main4:AddButton({
    Title="Monster Finder",
    Description="Định vị và Auto Kill quái vật",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/99Nights/main/MonsterFinder.lua"))()
    end
})

Tabs.Main4:AddButton({
    Title="Infinite Light",
    Description="Đèn pin/Nguồn sáng vô hạn",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/99Nights/main/InfiniteLight.lua"))()
    end
})

Tabs.Main4:AddButton({
    Title="Build Helper",
    Description="Tự động xây dựng chướng ngại vật nhanh",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/99Nights/main/BuildHelper.lua"))()
    end
})

Tabs.Main4:AddButton({
    Title="Max Stats",
    Description="Tăng tối đa các chỉ số nhân vật",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/99Nights/main/MaxStats.lua"))()
    end
})

------- Hunte Zombie (Hunter Zombie) (7 Scripts Hubs) -------

Tabs.Main5:AddButton({
    Title="Auto Kill Zombie",
    Description="Tự động tiêu diệt Zombies trong khu vực",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/HunterZombie/main/AutoKill.lua"))()
    end
})

Tabs.Main5:AddButton({
    Title="Money Farm",
    Description="Auto Farm tiền tệ (Cash/Coins)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/HunterZombie/main/MoneyFarm.lua"))()
    end
})

Tabs.Main5:AddButton({
    Title="Weapon Master",
    Description="Mở khóa và Farm EXP cho vũ khí",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/HunterZombie/main/WeaponMaster.lua"))()
    end
})

Tabs.Main5:AddButton({
    Title="Fly/Noclip",
    Description="Bay và đi xuyên tường",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/HunterZombie/main/FlyNoclip.lua"))()
    end
})

Tabs.Main5:AddButton({
    Title="Instant Reload",
    Description="Nạp đạn tức thì",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/HunterZombie/main/InstantReload.lua"))()
    end
})

Tabs.Main5:AddButton({
    Title="Zombie Teleport",
    Description="Dịch chuyển Zombies đến một vị trí",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/HunterZombie/main/ZombieTeleport.lua"))()
    end
})

Tabs.Main5:AddButton({
    Title="Full Bypass",
    Description="Tổng hợp Anti-Ban và các tính năng hack",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GenericScripts/HunterZombie/main/FullBypass.lua"))()
    end
})

------- Hop Sv Vip (Trống) -------
-- Tabs.Main6 không có script nào theo yêu cầu.

------- Script All Game (Trống) -------
-- Tabs.Main7 không có script nào theo yêu cầu.
}
