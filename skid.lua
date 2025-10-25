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
    Title = "HieuDRG Hub Tổng Hợp",
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
  
------- blox fruit -------

Tabs.Main1:AddButton({
    Title="Hiru Hub",
    Description="NO KEY",
    Callback=function()
	  getgenv().Settings = {
    JoinTeam = true,
    Team = "Marines"
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/kiddohiru/Source/main/BloxFruits.lua"))()
  end
})

Tabs.Main1:AddButton({
    Title="Quantum Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
  end
})

Tabs.Main1:AddButton({
    Title="Blue X Hub",
    Description="NO KEY",
    Callback=function()
	  getgenv().Config = {
    ["Misc"] = {
        ["RandomFruits"] = true,
        ["BlackScreen"] = false,
    }
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-BlueX/BlueX-Hub/refs/heads/main/FindFruits.lua"))()
  end
})

Tabs.Main1:AddButton({
    Title="Zinner Hub",
    Description="NO KEY",
    Callback=function()
	  getgenv().Team = "Pirates"
loadstring(game:HttpGet("https://raw.githubusercontent.com/HoangNguyenk8/Roblox/refs/heads/main/BF-Main.luau"))()
  end
})

Tabs.Main1:AddButton({
    Title="Banana Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Chiriku2013/BananaCatHub/refs/heads/main/BananaCatHub.lua"))()
  end
})

Tabs.Main1:AddButton({
    Title="Arceney Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game.HttpGet(game,'https://raw.githubusercontent.com/Yumiara/Python/refs/heads/main/BloxFruit-XYZ.lua'))()
  end
})

Tabs.Main1:AddButton({
    Title="StarryMoon Hub",
    Description="NO KEY",
    Callback=function()
	  repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players
repeat task.wait() until game.Players.LocalPlayer
getgenv().Team = "Marines" -- Can change Marines => Pirates
loadstring(game:HttpGet("https://power-clock-api.vercel.app/api/clockbloxfruits", true))()
  end
})

Tabs.Main1:AddButton({
    Title="Shinichi Hub",
    Description="NO KEY",
    Callback=function()
	  repeat wait() until game:IsLoaded()
loadstring(game:HttpGet("https://raw.githubusercontent.com/shinichi-dz/phucshinsayhi/refs/heads/main/ShinichiHub.lua"))()
  end
})

Tabs.Main1:AddButton({
    Title="Yuri Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Jadelly261/BloxFruits/main/YuriMain", true))()
  end
})

Tabs.Main1:AddButton({
    Title="Volcano Hub V3",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/indexeduu/BF-NewVer/refs/heads/main/V3New.lua"))()
  end
})

Tabs.Main1:AddButton({
    Title="Vxeze Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Dex-Bear/Vxezehub/refs/heads/main/VxezeHubMain"))()
  end
})

Tabs.Main1:AddButton({
    Title="Muxus Hub",
    Description="NO KEY",
    Callback=function()
	  getgenv().Team = "Pirates"
loadstring(game:HttpGet("https://raw.githubusercontent.com/MuxusTL/BloxFruits/main/MuxusHub.lua"))()
  end
})

Tabs.Main1:AddButton({
    Title="Omg Hub",
    Description="GET KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua"))()
  end
})

---- GROW A GADEN-----

Tabs.Main2:AddButton({
    Title="H4x Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet('https://raw.githubusercontent.com/H4xScripts/Scripts/refs/heads/main/autofidner', true))()
  end
})

Tabs.Main2:AddButton({
    Title="Kenniel Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Kenniel123/Grow-a-garden/refs/heads/main/Grow%20A%20Garden"))()
  end
})

Tabs.Main2:AddButton({
    Title="Lunacy Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/1c1979f776d3e81869cf5f49f91900a7.lua"))()
  end
})

Tabs.Main2:AddButton({
    Title="Kiwii Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/KiwiiHub/KiwiiHub/refs/heads/main/aac03d64-6a28-47bc-ab5c-da025a50c4d6-1182317416202641449.lua"))()
  end
})

Tabs.Main2:AddButton({
    Title="UB Hub",
    Description="NO KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://gitlab.com/r_soft/main/-/raw/main/LoadUB.lua"))()
  end
})

Tabs.Main2:AddButton({
    Title="Pet Spawner Hub",
    Description="GET KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/sudaisontopxd/PanScriptXSudaisScript/refs/heads/main/PhantFluxReal.lua"))()
  end
})

Tabs.Main2:AddButton({
    Title="Mercenaries Hub",
    Description="GET KEY",
    Callback=function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/kosowa/asd/refs/heads/main/GaG.lua"))()
  end
})

Tabs.Main2:AddButton({
    Title="Bonk Hub",
    Description="GET KEY",
    Callback=function()
	  
  end
})
