-- Check Executor 
local executor = getexecutorname() or identifyexecutor()

if executor then
    local supportedExecutors = {
        "Velocity",
        "Wave",
        "Arceus",
        "Swift",
        "AWP",
        "Macsploit",
        "Delta",
        "Fluxus",
        "CodeX",
        "Krnl",
        "Trigon",
        "Evon",
        "Cryptic",
        "SynapeX",
        "Potassium",
        "Argon",
        "Xeno",
        "Nezur",
        "Revelix",
        "Cubix",
        "Solara",
        "Dynamic",
        "Nebula",
        "Ronix",
        "Atlantis",
        "JJsploit",
        "Frostware" -- thêm vào thì tùy ae
    }

    local isExecutorSupported = false
    for _, name in ipairs(supportedExecutors) do
        if string.find(executor, name) then
            isExecutorSupported = true
            break
        end
    end

    if isExecutorSupported then
        print("Supported Executor!")
    else
        game.Players.LocalPlayer:Kick("Not supported TNG Skid executor!") -- kick nếu exec ko support
    end
end

repeat
    wait()
until game:IsLoaded() and game.Players.LocalPlayer

print("Whitelist success!")
wait(.5)
game.StarterGui:SetCore("SendNotification", {
     Title = "HieuDRG Hub";
     Text = "Loading";
     Icon = "";
     Duration = "2";
})

wait(.1)


----------------------------------------ToogleUi----------------------------------------

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local ImageLabel = Instance.new("ImageLabel")
local UICorner = Instance.new("UICorner")
local TextButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")  
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.AnchorPoint = Vector2.new(0.1, 0.1)
Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame.BackgroundTransparency = 0
Frame.BorderColor3 = Color3.fromRGB(27, 42, 53)
Frame.BorderSizePixel = 1
Frame.Position = UDim2.new(0, 20, 0.1, -6)  
Frame.Size = UDim2.new(0, 50, 0, 50)
Frame.Name = "dut dit"

ImageLabel.Parent = Frame
ImageLabel.Name = "Banana Test"
ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
ImageLabel.Size = UDim2.new(0, 40, 0, 40)
ImageLabel.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
ImageLabel.BackgroundTransparency = 1
ImageLabel.BorderSizePixel = 1
ImageLabel.BorderColor3 = Color3.fromRGB(27, 42, 53)
ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
ImageLabel.Image = "http://www.roblox.com/asset/?id=94439769761633" -- Thay 5009915795 Bằng ảnh của anh em

UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Frame

TextButton.Name = "TextButton"
TextButton.Parent = Frame
TextButton.AnchorPoint = Vector2.new(0, 0)
TextButton.Position = UDim2.new(0, 0, 0, 0)
TextButton.Size = UDim2.new(1, 0, 1, 0)
TextButton.BackgroundColor3 = Color3.fromRGB(163, 162, 165)
TextButton.BackgroundTransparency = 1
TextButton.BorderSizePixel = 1
TextButton.BorderColor3 = Color3.fromRGB(27, 42, 53)
TextButton.TextColor3 = Color3.fromRGB(27, 42, 53)
TextButton.Text = ""
TextButton.Font = Enum.Font.SourceSans
TextButton.TextSize = 8
TextButton.TextTransparency = 0

local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local zoomedIn = false
local originalSize = UDim2.new(0, 40, 0, 40)
local zoomedSize = UDim2.new(0, 30, 0, 30)
local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local faded = false
local fadeInTween = TweenService:Create(Frame, tweenInfo, {BackgroundTransparency = 0.25})
local fadeOutTween = TweenService:Create(Frame, tweenInfo, {BackgroundTransparency = 0})

TextButton.MouseButton1Down:Connect(function()

    if zoomedIn then
        TweenService:Create(ImageLabel, tweenInfo, {Size = originalSize}):Play()
    else
        TweenService:Create(ImageLabel, tweenInfo, {Size = zoomedSize}):Play()
    end
    zoomedIn = not zoomedIn

    if faded then
        fadeOutTween:Play()
    else
        fadeInTween:Play()
    end
    faded = not faded

    VirtualInputManager:SendKeyEvent(true, "LeftControl", false, game)
end)

print("Loading Main Ui")
wait(.1)
game.StarterGui:SetCore("SendNotification", {
     Title = "HieuDRG Hub";
     Text = "Loading Main Ui";
     Icon = "";
     Duration = "2";
})
wait(.1)

----------------------------------------Fluent----------------------------------------
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "HieuDRG Hub tổng hợp",
    SubTitle = "UPDATE V1",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = true, 
    Theme = "Light",
    MinimizeKey = Enum.KeyCode.LeftControl
})
----------------------------------------Tab----------------------------------------
local Tabs = {
    Tab1 = Window:AddTab({ Title = "Client", Icon = "" }),
    Tab2 = Window:AddTab({ Title = "Blox Fruit", Icon = "" }),
    Tab3 = Window:AddTab({ Title = "Grow a Garden", Icon = "" }),
    Tab4 = Window:AddTab({ Title = "Steal a Brainrot", Icon = "" }),
    Tab5 = Window:AddTab({ Title = "99 Night In The Forest ", Icon = "" }),
    Tab6 = Window:AddTab({ Title = "Hunte Zombie", Icon = "" }),
    Tab7 = Window:AddTab({ Title = "Settings", Icon = "" }),
    Tab8 = Window:AddTab({ Title = "Info", Icon = "" }),
}
----------------------------------------clien----------------------------------------
print("Client Tab Loading")
wait(1)
    Tabs.Tab1:AddButton({
        Title = "SynapseX",
        Description = "Can Run Script But Use Your Executor's Api",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/LongHip2012/ScriptBloxFruit/refs/heads/main/SynapsexUi.lua"))()
        end
    })
    
    Tabs.Tab1:AddButton({
        Title = "ArceusX",
        Description = "Can Run Script But Use Your Executor's Api",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/chillz-workshop/main/Arceus%20X%20V3"))()
        end
    })
    
    Tabs.Tab1:AddButton({
        Title = "KRNL",
        Description = "Can Run Script But Use Your Executor's Api",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/LongHip2012/Lonely-Hub/refs/heads/main/KRNL%20UI%20Remake.lua.txt"))()
        end
    })
    
----------------------------------------blox fruit----------------------------------------
print("blox fruit Tab Loading")
wait(1)
Tabs.Tab2:AddButton({
        Title = "Hiru Hub",
        Description = "NO KEY",
        Callback = function()
            getgenv().Settings = {
    JoinTeam = true,
    Team = "Marines"
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/kiddohiru/Source/main/BloxFruits.lua"))()
        end
    })
    
Tabs.Tab2:AddButton({
        Title = "Quantum Hub",
        Description = "NO KEY",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
        end
    })
  
Tabs.Tab2:AddButton({
        Title = "Blue X Hub",
        Description = "",
        Callback = function()
            getgenv().Config = {
    ["Misc"] = {
        ["RandomFruits"] = true,
        ["BlackScreen"] = false,
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/FindFruits.lua"))()
        end
    })
----------------------------------------grow a gaden----------------------------------------
print("Loading grow a gaden Tab")
wait(1)
Tabs.Tab3:AddParagraph({
        Title = "grow a gaden tab",
        Content = "click rồi đợi 5s"
    })
    
Tabs.Tab3:AddButton({
        Title = "H4x Hub",
        Description = "NO KEY",
        Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/autofidner', true))()
        end
    })
----------------------------------------steal a branrot----------------------------------------
print("Loading Script Tab")
wait(1)
print("Loading steal brainrot Script")
wait(.1)

Tabs.Tab4:AddParagraph({
        Title = "steal brainrot tab",
        Content = "click rồi đợi 5s"
    })
wait(5)
Tabs.Tab4:AddButton({
        Title = "Chilli Hub",
        Description = "NO KEY",  
        Callback = function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))() 
        end
    })
    
    Tabs.BF:AddButton({
        Title = "Makal Hub",
        Description = "NO KEY",  
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/DoliScriptz/loader/refs/heads/main/main.lua",true))()
        end
    })
    
 
----------------------------------------99 night----------------------------------------
print("Loading 99 night Tab")
wait(1)
Tabs.Blr:AddParagraph({
        Title = "99 night Tab",
        Content = "click rồi đợi 5s"
    })
    
Tabs.Blr:AddButton({
        Title = "Voidware Hub",
        Description = "NO KEY",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/nightsintheforest.lua", true))()
        end
    })
    
    Tabs.Blr:AddButton({
        Title = "Kenniel Hub",
        Description = "NO KEY",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenniel123/99-Nights-in-the-Forest/refs/heads/main/99%20Nights%20in%20the%20Forest"))()
        end
    })
    

----------------------------------------hunte zombie----------------------------------------
print("Loading hunte zombie Script")
wait(.5)
Tabs.Shrimp:AddParagraph({
        Title = "hunte zombie tab"
        Content = "click rồi đợi 5s"
    })
Tabs.Shrimp:AddButton({
        Title = "Combo Wick Hub",
        Description = "NO KEY",
        Callback = function()
            loadstring(game:HttpGet("https://v0-supabase-secure-storage.vercel.app/api/script/2ca1518801a95abf0dceb898774fa182"))()
        end
    })
    
    Tabs.Shrimp:AddButton({
        Title = "Tora Hub",
        Description = "NO KEY",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/gumanba/Scripts/main/HuntyZombie"))()
        end
    })
----------------------------------------settings----------------------------------------
print("Load setting Script")
wait(.5)
Tabs.AD:AddParagraph({
        Title = "settings tab",
        Content = "click rồi đợi 5s"
    })
    
Tabs.AD:AddButton({
        Title = "Soul Hub",
        Description = "key",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/GoblinKun009/Script/refs/heads/main/soulhub", true))()
        end
    })
    
    Tabs.AD:AddButton({
        Title = "TxZ Hub",
        Description = "key",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/DrTxZ/Mercure-Hub/refs/heads/main/Mercure%20Hub.lua"))()
        end
    })
----------------------------------------info----------------------------------------
print("Loading Server Tab")
wait(.5)
print("Loading Info Tab")
wait(.1)
Tabs.If:AddParagraph({
        Title = "Player",
        Content = "Thank "..game.Players.LocalPlayer.Name.." for use script!"
    })

    Tabs.If:AddParagraph({
        Title = "những người đã đóng góp script",
        Content = "not"
    })
    
    Tabs.If:AddParagraph({
        Title = "Deverloper",
        Content = "HieuDRG"
    })
    
    Tabs.If:AddButton({
        Title = "TIKTOK",
        Description = "INFO",
        Callback = function()
            setclipboard("NOT")
        end
    })
        
    Tabs.If:AddButton({
        Title = "YOUTOBE",
        Description = "INFO",
        Callback = function()
            setclipboard("NOT")
        end
    })
 
    wait(.1)

----------------------------------------LoadedNotify----------------------------------------
    game.StarterGui:SetCore("SendNotification", {
     Title = "HieuDRG Hub";
     Text = "Loaded!";
     Icon = "";
     Duration = "2";
})
wait(.1) 
print("Loaded! thành công")
wait(.1)
warn("script tổng hợp mới nhất")
