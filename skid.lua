-- HIEUDRG HUB UI | RGB 7 MÀU + TAB + BUTTON
-- Click button → Execute script tự động
-- Support ALL CLIENT

-- Load Fluent UI (đẹp nhất 2025)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Tạo Window
local Window = Fluent:CreateWindow({
    Title = "HieuDRG Hub",
    SubTitle = "TRÙM IPA - Tổng Hợp Script",
    TabWidth = 170,
    Size = UDim2.fromOffset(620, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.Insert
})

-- === RGB 7 MÀU CHO TOÀN BỘ UI ===
local function ApplyRGB(element)
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.14, Color3.fromRGB(255,165,0)),
        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.56, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.84, Color3.fromRGB(75,0,130)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
    }
    Gradient.Rotation = 90
    Gradient.Parent = element

    task.spawn(function()
        while task.wait(0.1) do
            Gradient.Rotation = (Gradient.Rotation + 2) % 360
        end
    end)
end

-- Áp dụng RGB cho Title
ApplyRGB(Window.Title)

-- === TABS ===
local MainTab = Window:AddTab({ Title = "Main", Icon = "home" })
local FarmTab = Window:AddTab({ Title = "Auto Farm", Icon = "zap" })
local CombatTab = Window:AddTab({ Title = "Combat", Icon = "sword" })
local UtilityTab = Window:AddTab({ Title = "Utility", Icon = "tool" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

-- === MAIN TAB - WELCOME ===
MainTab:AddParagraph({
    Title = "Chào mừng đến HieuDRG Hub!",
    Content = "Click vào tab để chọn script.\nMỗi button = 1 script mạnh nhất 2025.\nHỗ trợ tất cả executor."
})

MainTab:AddImage({
    Title = "Logo",
    Image = "rbxassetid://91881585928344",
    Size = UDim2.new(0, 150, 0, 150)
})

-- === FARM TAB - AUTO FARM SCRIPTS ===
FarmTab:AddSection("Auto Farm Kaitun")

FarmTab:AddButton({
    Title = "Kaitun Level 1 → Max",
    Description = "Auto farm full level, gom quái, mua võ",
    Callback = function()
        Fluent:Notify({Title = "HieuDRG", Content = "Đang load Kaitun..."})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hieudrg/script/main/kaitun.lua"))()
    end
})

FarmTab:AddButton({
    Title = "Auto Mirage + Factory",
    Description = "Tự động làm Mirage Island & Factory",
    Callback = function()
        Fluent:Notify({Title = "HieuDRG", Content = "Đang load Mirage + Factory..."})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hieudrg/script/main/mirage_factory.lua"))()
    end
})

-- === COMBAT TAB - COMBAT SCRIPTS ===
CombatTab:AddSection("Combat & PvP")

CombatTab:AddButton({
    Title = "Aimbot + Silent Aim",
    Description = "Bắn đâu trúng đó, không cần aim",
    Callback = function()
        Fluent:Notify({Title = "HieuDRG", Content = "Đang load Aimbot..."})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hieudrg/script/main/aimbot.lua"))()
    end
})

CombatTab:AddButton({
    Title = "God Mode + No Clip",
    Description = "Bất tử, xuyên tường, bay",
    Callback = function()
        Fluent:Notify({Title = "HieuDRG", Content = "Đang load God Mode..."})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hieudrg/script/main/godmode.lua"))()
    end
})

-- === UTILITY TAB - TIỆN ÍCH ===
UtilityTab:AddSection("Tiện Ích")

UtilityTab:AddButton({
    Title = "ESP + Player Tracker",
    Description = "Nhìn xuyên tường, theo dõi người chơi",
    Callback = function()
        Fluent:Notify({Title = "HieuDRG", Content = "Đang load ESP..."})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hieudrg/script/main/esp.lua"))()
    end
})

UtilityTab:AddButton({
    Title = "Auto Sea Event",
    Description = "Tự động làm Sea Beast, Leviathan",
    Callback = function()
        Fluent:Notify({Title = "HieuDRG", Content = "Đang load Sea Event..."})
        loadstring(game:HttpGet("https://raw.githubusercontent.com/hieudrg/script/main/sea_event.lua"))()
    end
})

-- === SETTINGS TAB ===
SettingsTab:AddSection("Cài Đặt")

SettingsTab:AddToggle("RGB", {Title = "RGB Animation", Default = true}):OnChanged(function(state)
    -- Có thể bật/tắt RGB
end)

SettingsTab:AddButton({
    Title = "Rejoin Server",
    Description = "Vào lại server hiện tại",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    end
})

SettingsTab:AddButton({
    Title = "Copy Discord",
    Description = "Copy link Discord hỗ trợ",
    Callback = function()
        setclipboard("https://discord.gg/hieudrg")
        Fluent:Notify({Title = "Copied!", Content = "Link Discord đã được copy!"})
    end
})

-- === THÔNG BÁO ===
Fluent:Notify({
    Title = "HieuDRG Hub",
    Content = "UI đã load xong! Click button để dùng script.",
    Duration = 6
})

print("HieuDRG Hub UI - Đã load thành công!")
