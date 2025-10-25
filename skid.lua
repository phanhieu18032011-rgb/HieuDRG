-- SHADOW CORE AI - PREMIUM HAMMER-STYLE UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- CREATE MAIN WINDOW
local Window = Rayfield:CreateWindow({
   Name = "🔮 SHADOW CORE PREMIUM",
   LoadingTitle = "Shadow Core AI Initializing...",
   LoadingSubtitle = "Powered by Advanced Intelligence",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ShadowCore",
      FileName = "PremiumConfig"
   },
   Discord = {
      Enabled = true,
      Invite = "shadowcore",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Shadow Core Access",
      Subtitle = "Enter Key",
      Note = "Join Discord for Key",
      FileName = "ShadowKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"SHADOWCORE2024"}
   }
})

-- CREATE MULTIPLE TABS WITH EPIC DESIGN
local Tabs = {
    Main0 = Window:CreateTab({ 
        Name = "⚡ MAIN HUB", 
        Icon = "rbxassetid://7733716865"
    }),
    
    Combat = Window:CreateTab({ 
        Name = "🔫 COMBAT", 
        Icon = "rbxassetid://7733716865" 
    }),
    
    Farm = Window:CreateTab({ 
        Name = "🌾 AUTO FARM", 
        Icon = "rbxassetid://7733716865" 
    }),
    
    Teleport = Window:CreateTab({ 
        Name = "📍 TELEPORT", 
        Icon = "rbxassetid://7733716865" 
    }),
    
    Player = Window:CreateTab({ 
        Name = "👤 PLAYER", 
        Icon = "rbxassetid://7733716865" 
    }),
    
    Scripts = Window:CreateTab({ 
        Name = "📜 SCRIPTS", 
        Icon = "rbxassetid://7733716865" 
    }),
    
    Settings = Window:CreateTab({ 
        Name = "⚙️ SETTINGS", 
        Icon = "rbxassetid://7733716865" 
    })
}

-- MAIN0 TAB CONTENT
local Main0Section1 = Tabs.Main0:CreateSection("🎯 CORE FEATURES")

Tabs.Main0:AddButton({
    Title = "🔥 ACTIVATE SHADOW MODE",
    Description = "Kích hoạt chế độ siêu cấp",
    Callback = function()
        Rayfield:Notify({
            Title = "SHADOW MODE ACTIVATED",
            Content = "Maximum performance enabled!",
            Duration = 6.5,
            Image = "rbxassetid://7733716865"
        })
        -- Add your activation code here
    end
})

Tabs.Main0:AddButton({
    Title = "🚀 LOAD UNIVERSAL SCRIPT",
    Description = "Tải script đa năng",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

Tabs.Main0:AddButton({
    Title = "💀 NUKE SERVER",
    Description = "Phá hủy server (ADMIN ONLY)",
    Callback = function()
        Rayfield:Notify({
            Title = "NUKE WARNING",
            Content = "This action cannot be undone!",
            Duration = 6.5,
            Image = "rbxassetid://7733716865",
            Actions = {
                Ignore = {
                    Name = "Cancel",
                    Callback = function()
                        print("Nuke cancelled")
                    end
                },
                Confirm = {
                    Name = "CONFIRM NUKE",
                    Callback = function()
                        -- Nuke code here
                        Rayfield:Notify({
                            Title = "SERVER NUKE INITIATED",
                            Content = "Destruction in progress...",
                            Duration = 6.5,
                            Image = "rbxassetid://7733716865"
                        })
                    end
                }
            }
        })
    end
})

local Main0Section2 = Tabs.Main0:CreateSection("📊 SERVER INFO")

Tabs.Main0:AddParagraph("SERVER STATUS", "Players: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers)

Tabs.Main0:AddButton({
    Title = "🔄 REFRESH SERVER INFO",
    Description = "Cập nhật thông tin server",
    Callback = function()
        Tabs.Main0:UpdateParagraph("SERVER STATUS", "Players: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers)
    end
})

-- COMBAT TAB
local CombatSection1 = Tabs.Combat:CreateSection("🎯 AIMBOT & COMBAT")

Tabs.Combat:AddToggle({
    Title = "AIMBOT ENABLED",
    Description = "Tự động ngắm bắn",
    Default = false,
    Callback = function(Value)
        getgenv().AimbotEnabled = Value
        Rayfield:Notify({
            Title = "AIMBOT " .. (Value and "ENABLED" or "DISABLED"),
            Content = "Combat system updated",
            Duration = 3,
            Image = "rbxassetid://7733716865"
        })
    end
})

Tabs.Combat:AddSlider({
    Title = "AIMBOT SMOOTHNESS",
    Description = "Độ mượt khi ngắm bắn",
    Default = 50,
    Min = 1,
    Max = 100,
    Callback = function(Value)
        getgenv().AimbotSmoothness = Value
    end
})

Tabs.Combat:AddToggle({
    Title = "WALLHACK ESP",
    Description = "Nhìn xuyên tường",
    Default = false,
    Callback = function(Value)
        getgenv().WallhackEnabled = Value
    end
})

-- AUTO FARM TAB
local FarmSection1 = Tabs.Farm:CreateSection("🌾 FARMING SYSTEMS")

Tabs.Farm:AddToggle({
    Title = "AUTO FARM LEVEL",
    Description = "Tự động farm level",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        if Value then
            Rayfield:Notify({
                Title = "AUTO FARM STARTED",
                Content = "Farming in progress...",
                Duration = 3,
                Image = "rbxassetid://7733716865"
            })
        end
    end
})

Tabs.Farm:AddDropdown({
    Title = "FARM MODE",
    Description = "Chọn chế độ farm",
    Default = "NPC",
    Options = {"NPC", "BOSS", "CHEST", "QUESTS"},
    Callback = function(Value)
        getgenv().FarmMode = Value
    end
})

Tabs.Farm:AddSlider({
    Title = "FARM RADIUS",
    Description = "Bán kính tìm mục tiêu",
    Default = 500,
    Min = 100,
    Max = 2000,
    Callback = function(Value)
        getgenv().FarmRadius = Value
    end
})

-- TELEPORT TAB
local TeleportSection1 = Tabs.Teleport:CreateSection("📍 LOCATIONS")

Tabs.Teleport:AddButton({
    Title = "🏝️ TELEPORT TO FIRST SEA",
    Description = "Dịch chuyển đến First Sea",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 100, 1000)
    end
})

Tabs.Teleport:AddButton({
    Title = "🌊 TELEPORT TO SECOND SEA", 
    Description = "Dịch chuyển đến Second Sea",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2000, 100, 2000)
    end
})

Tabs.Teleport:AddButton({
    Title = "⚓ TELEPORT TO THIRD SEA",
    Description = "Dịch chuyển đến Third Sea",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3000, 100, 3000)
    end
})

local TeleportSection2 = Tabs.Teleport:CreateSection("🎯 BOSS TELEPORT")

Tabs.Teleport:AddDropdown({
    Title = "SELECT BOSS",
    Description = "Chọn boss để teleport",
    Default = "Saber Expert",
    Options = {"Saber Expert", "The Saw", "Greybeard", "Darkbeard", "Order"},
    Callback = function(Value)
        getgenv().SelectedBoss = Value
    end
})

Tabs.Teleport:AddButton({
    Title = "🚀 TELEPORT TO BOSS",
    Description = "Dịch chuyển đến boss đã chọn",
    Callback = function()
        Rayfield:Notify({
            Title = "BOSS TELEPORT",
            Content = "Teleporting to " .. getgenv().SelectedBoss,
            Duration = 3,
            Image = "rbxassetid://7733716865"
        })
    end
})

-- PLAYER TAB
local PlayerSection1 = Tabs.Player:CreateSection("👤 PLAYER MODIFICATIONS")

Tabs.Player:AddSlider({
    Title = "WALKSPEED",
    Description = "Tốc độ di chuyển",
    Default = 16,
    Min = 16,
    Max = 200,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

Tabs.Player:AddSlider({
    Title = "JUMP POWER",
    Description = "Lực nhảy",
    Default = 50,
    Min = 50,
    Max = 200,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

Tabs.Player:AddToggle({
    Title = "NO CLIP",
    Description = "Đi xuyên vật thể",
    Default = false,
    Callback = function(Value)
        getgenv().NoClip = Value
    end
})

Tabs.Player:AddButton({
    Title = "🔄 REFRESH CHARACTER",
    Description = "Reset nhân vật",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

-- SCRIPTS TAB
local ScriptsSection1 = Tabs.Scripts:CreateSection("📜 SCRIPT LIBRARY")

Tabs.Scripts:AddButton({
    Title = "🌀 INFINITE YIELD",
    Description = "Admin commands FE",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

Tabs.Scripts:AddButton({
    Title = "⚡ DARK HUB",
    Description = "Multi-game exploits",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RandomAdamYT/DarkHub/master/Init"))()
    end
})

Tabs.Scripts:AddButton({
    Title = "💧 HYDROGEN",
    Description = "Modern UI hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gamerfeller/Hydrogen/main/loader.lua"))()
    end
})

local ScriptsSection2 = Tabs.Scripts:CreateSection("🎮 GAME SPECIFIC")

Tabs.Scripts:AddButton({
    Title = "🔪 BLOX FRUITS",
    Description = "Blox Fruits scripts",
    Callback = function()
        if game.PlaceId == 2753915549 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/xQuartyx/DonateMe/main/ScriptLoader"))()
        else
            Rayfield:Notify({
                Title = "WRONG GAME",
                Content = "This script is for Blox Fruits only!",
                Duration = 5,
                Image = "rbxassetid://7733716865"
            })
        end
    end
})

Tabs.Scripts:AddButton({
    Title = "🎯 ARSENAL",
    Description = "Arsenal hacks",
    Callback = function()
        if game.PlaceId == 286090429 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/lerkram/Arsenal-Universal-Aimbot-ESP/main/Aimbot"))()
        end
    end
})

-- SETTINGS TAB
local SettingsSection1 = Tabs.Settings:CreateSection("🎨 UI CUSTOMIZATION")

Tabs.Settings:AddDropdown({
    Title = "UI THEME",
    Description = "Chọn theme cho giao diện",
    Default = "Dark",
    Options = {"Dark", "Darker", "Light", "Blood", "Ocean"},
    Callback = function(Value)
        Rayfield:Notify({
            Title = "THEME CHANGED",
            Content = "UI Theme: " .. Value,
            Duration = 3,
            Image = "rbxassetid://7733716865"
        })
    end
})

Tabs.Settings:AddKeybind({
    Title = "UI TOGGLE KEYBIND",
    Description = "Phím tắt ẩn/hiện UI",
    Default = "RightShift",
    Callback = function(Key)
        getgenv().UIToggleKey = Key
    end
})

Tabs.Settings:AddToggle({
    Title = "WATERMARK",
    Description = "Hiển thị watermark",
    Default = true,
    Callback = function(Value)
        getgenv().ShowWatermark = Value
    end
})

local SettingsSection2 = Tabs.Settings:CreateSection("🔧 SYSTEM")

Tabs.Settings:AddButton({
    Title = "💾 SAVE CONFIG",
    Description = "Lưu cài đặt hiện tại",
    Callback = function()
        Rayfield:Notify({
            Title = "CONFIG SAVED",
            Content = "Settings have been saved!",
            Duration = 3,
            Image = "rbxassetid://7733716865"
        })
    end
})

Tabs.Settings:AddButton({
    Title = "🗑️ DESTROY UI",
    Description = "Xóa giao diện hiện tại",
    Callback = function()
        Rayfield:Destroy()
    end
})

Tabs.Settings:AddButton({
    Title = "🔄 RELOAD UI",
    Description = "Tải lại giao diện",
    Callback = function()
        Rayfield:Destroy()
        task.wait(1)
        -- Reload script here
    end
})

-- INITIAL NOTIFICATION
Rayfield:Notify({
    Title = "SHADOW CORE AI LOADED",
    Content = "Premium UI Activated Successfully!",
    Duration = 6.5,
    Image = "rbxassetid://7733716865"
})

-- AUTO-UPDATE PLAYER COUNT
task.spawn(function()
    while task.wait(5) do
        Tabs.Main0:UpdateParagraph("SERVER STATUS", "Players: " .. #game.Players:GetPlayers() .. "/" .. game.Players.MaxPlayers)
    end
end)
