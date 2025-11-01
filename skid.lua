local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

local Window = redzlib:MakeWindow({
  Title = " Roblox Tổng Hợp Hubs 2025",
  SubTitle = "by  - Multi-Game Loader (Bandishare Edition)",
  SaveFolder = "Redz | redz lib v5.lua"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://83190276951914", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(0, 5) },
})

local Tab = Window:MakeTab({"Discord", "info"})

local Tab2 = Window:MakeTab({"Blox Fruits", "home"})

local Tab3 = Window:MakeTab({"Grow a Garden", "swords"})

local Tab4 = Window:MakeTab({"Steal a Brainrot", "locate"})

local Tab5 = Window:MakeTab({"99 Nights in the Forest", "signal"})

local Tab6 = Window:MakeTab({"Hunt Zombie", "shoppingCart"})

local Tab7 = Window:MakeTab({"Linh Tinh", "user"})

local Tab8 = Window:MakeTab({"Khác", "settings"})

Tab:AddButton({
    Title="Discord TBoy",
    Description="Community Link",
    Callback=function()
        setclipboard("https://discord.gg/tboyroblox-community-1253927333920899153")
        redzlib:Notify({Title="Copied!", Content="Discord link copied!"})
    end
})

Tab:AddButton({
    Title="YouTube TBoy Roblox",
    Description="Channel 1",
    Callback=function()
        setclipboard("https://www.youtube.com/@TBoyRoblox08")
        redzlib:Notify({Title="Copied!", Content="YouTube link copied!"})
    end
})

Tab:AddButton({
    Title="YouTube TBoy Gamer",
    Description="Channel 2",
    Callback=function()
        setclipboard("https://www.youtube.com/@TBoyGamer08")
        redzlib:Notify({Title="Copied!", Content="YouTube link copied!"})
    end
})

Tab2:AddButton({
    Title="Redz Hub Blox Fruits",
    Description="NO KEY - Auto Farm/Boss/Raid Update 28 (Bandishare)",
    Callback=function()
        local Settings = { JoinTeam = "Pirates", Translator = true }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
    end
})

Tab2:AddButton({
    Title="GreenZ Hub Blox Fruits",
    Description="NO KEY - Farm Fruit/Chest Update 28 (Bandishare)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/LuaAnarchist/GreenZ-Hub/refs/heads/main/KaitunDoughKing.lua"))()
    end
})

Tab2:AddButton({
    Title="Netna Hub Blox Fruits",
    Description="KEY - Auto Farm Candy Update 28 (Bandishare)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NetnaHub/BloxFruits/main/NetnaHub.lua"))()
    end
})

Tab2:AddButton({
    Title="Fluxus Blox Fruits V50",
    Description="NO KEY - Mobile Farm APK Update 24 (Bandishare)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FluxusHub/BloxFruits/main/FluxusV50.lua"))()
    end
})

Tab2:AddButton({
    Title="Hydrogen Blox Fruits Update 24",
    Description="NO KEY - Raid/Boss Update 24 (Bandishare APK)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HydrogenHack/BloxFruits/main/HydrogenUpdate24.lua"))()
    end
})

Tab2:AddButton({
    Title="HoHo Hub Blox Fruits",
    Description="NO KEY - Full Auto Update 28 (Bandishare)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_Hub/main/Loading_UI"))()
    end
})

Tab2:AddButton({
    Title="Thunder Z Blox Fruits",
    Description="KEY - Auto Race V4 Update 20 (Bandishare)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ThunderZ/BloxFruits/main/ThunderZ.lua"))()
    end
})

Tab2:AddButton({
    Title="Powered V2 Blox Fruits",
    Description="NO KEY - Farm Chest/Fruit Update 19 (Bandishare)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/PoweredV2/BloxFruits/main/PoweredV2.lua"))()
    end
})

Tab2:AddButton({
    Title="Dough King Blox Fruits",
    Description="NO KEY - Auto Dough Update 19 (Bandishare)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DoughKingHub/BloxFruits/main/Dough.lua"))()
    end
})

Tab2:AddButton({
    Title="Quantum Onyx Blox Fruits",
    Description="NO KEY - Farm Update 28 (Bandishare GitHub)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
    end
})

Tab2:AddButton({
    Title="VNG Blox Fruits Hack",
    Description="NO KEY - Auto Farm VNG Update 24 (Bandishare APK)",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VNGHack/BloxFruits/main/VNG.lua"))()
    end
})

Tab3:AddButton({
    Title="Garden Farm Hub",
    Description="NO KEY - Auto Plant/Harvest",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/GardenHub/GrowAGarden/main/Farm.lua"))()
    end
})

Tab3:AddButton({
    Title="Bucket Eyes Grow Hub",
    Description="NO KEY - Auto Grow Bucket",
    Callback=function()
        loadstring(game:HttpGet("https://pastebin.com/raw/gardenbucket2025"))()
    end
})

Tab3:AddButton({
    Title="Auto Garden Pro",
    Description="KEY - Multi-Plant Farm",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/AutoGardenPro/main/GrowGarden.lua"))()
    end
})

Tab3:AddButton({
    Title="Simple Garden ESP",
    Description="NO KEY - Item ESP",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SimpleGarden/ESP/main/GardenESP.lua"))()
    end
})

Tab3:AddButton({
    Title="Garden Speed Hub",
    Description="NO KEY - Speed Grow",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SpeedGarden/main/Speed.lua"))()
    end
})

Tab3:AddButton({
    Title="Grow Teleport Hub",
    Description="NO KEY - TP Plants",
    Callback=function()
        loadstring(game:HttpGet("https://pastebin.com/raw/growtp"))()
    end
})

Tab4:AddButton({
    Title="Brainrot Steal Hub",
    Description="NO KEY - Auto Steal Items",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/BrainrotHub/Steal/main/StealBrainrot.lua"))()
    end
})

Tab4:AddButton({
    Title="Steal Rot Pro",
    Description="KEY - ESP + Teleport",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/StealRotPro/main/Rot.lua"))()
    end
})

Tab4:AddButton({
    Title="Brainrot Farm Hub",
    Description="NO KEY - Auto Farm Rot",
    Callback=function()
        loadstring(game:HttpGet("https://pastebin.com/raw/brainrotfarm"))()
    end
})

Tab4:AddButton({
    Title="Steal ESP Hub",
    Description="NO KEY - Item ESP",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ESPHub/Steal/main/ESP.lua"))()
    end
})

Tab4:AddButton({
    Title="Brainrot Speed Hub",
    Description="NO KEY - Speed Hack",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SpeedBrainrot/main/Speed.lua"))()
    end
})

Tab5:AddButton({
    Title="99 Nights Aura Hub",
    Description="NO KEY - Kill/Chop Aura",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qiwikox12/stubrawl/refs/heads/main/99Night.txt"))()
    end
})

Tab5:AddButton({
    Title="Forest ESP Pro",
    Description="KEY - Item/Mob ESP",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ForestESP/main/ESP.lua"))()
    end
})

Tab5:AddButton({
    Title="Night Fly Hub",
    Description="NO KEY - Fly + Speed",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/NightFlyHub/main/Fly.lua"))()
    end
})

Tab5:AddButton({
    Title="Forest Auto Cook",
    Description="NO KEY - Auto Food",
    Callback=function()
        loadstring(game:HttpGet("https://pastebin.com/raw/forestcook"))()
    end
})

Tab6:AddButton({
    Title="Zombie Hunt Aura",
    Description="NO KEY - Auto Kill Zombies",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ZombieAuraHub/main/Hunt.lua"))()
    end
})

Tab6:AddButton({
    Title="Hunt ESP Hub",
    Description="NO KEY - Zombie ESP",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/HuntESPHub/main/ESP.lua"))()
    end
})

Tab6:AddButton({
    Title="Zombie Farm Pro",
    Description="KEY - Auto Farm",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FarmZombiePro/main/ZHunt.lua"))()
    end
})

Tab6:AddButton({
    Title="Hunt Speed Hub",
    Description="NO KEY - Speed + Jump",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/SpeedHunt/main/HuntSpeed.lua"))()
    end
})

Tab6:AddButton({
    Title="Zombie Teleport Hub",
    Description="NO KEY - TP Zombies",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TPZombie/main/Teleport.lua"))()
    end
})

Tab6:AddButton({
    Title="Hunt Noclip Hub",
    Description="NO KEY - Noclip",
    Callback=function()
        loadstring(game:HttpGet("https://pastebin.com/raw/huntnoclip"))()
    end
})

Tab7:AddButton({
    Title="Universal Fly Script",
    Description="NO KEY - Fly cho mọi game",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/UniversalFly/main/Fly.lua"))()
    end
})

Tab7:AddButton({
    Title="Universal ESP Script",
    Description="NO KEY - Item ESP mọi game",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ESPUniversal/main/ESP.lua"))()
    end
})

Tab7:AddButton({
    Title="Speed Hack Universal",
    Description="NO KEY - WalkSpeed x16 mọi game",
    Callback=function()
        loadstring(game:HttpGet("https://pastebin.com/raw/universalspeed"))()
    end
})

Tab7:AddButton({
    Title="Infinite Jump Universal",
    Description="NO KEY - Jump mọi game",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/InfJumpHub/main/Jump.lua"))()
    end
})

Tab7:AddButton({
    Title="Teleport Universal",
    Description="NO KEY - TP Script mọi game",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/TPUniversal/main/Teleport.lua"))()
    end
})

Tab8:AddButton({
    Title="Text Button Test",
    Description="Test Loadstring 99 Nights",
    Callback=function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Qiwikox12/stubrawl/refs/heads/main/99Night.txt"))()
    end
})
