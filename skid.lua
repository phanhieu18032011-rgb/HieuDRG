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
    Title = "TBoy Roblox Get Key System",
    SubTitle = "Custom Key Verifier",
    TabWidth = 157,
    Size = UDim2.fromOffset(450, 300),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.End
})

local Tabs = {
    Main = Window:AddTab({ Title = "Get Key" }),
}

local keyLink = ""
local scriptCode = ""
local userKey = ""

Tabs.Main:AddInput({
    Title = "GetKey Link",
    Description = "Paste RAW link (e.g., Pastebin raw containing the correct key)",
    Callback = function(value)
        keyLink = value
    end
})

Tabs.Main:AddInput({
    Title = "Script to Load",
    Description = "Paste the loadstring script that needs key (e.g., loadstring(game:HttpGet('...'))())",
    Callback = function(value)
        scriptCode = value
    end
})

Tabs.Main:AddInput({
    Title = "Enter Key",
    Description = "Paste or enter the key here",
    Callback = function(value)
        userKey = value
    end
})

Tabs.Main:AddButton({
    Title = "Verify & Execute",
    Description = "Check key and load script if correct",
    Callback = function()
        if keyLink == "" or scriptCode == "" or userKey == "" then
            Fluent:Notify({Title="Error", Content="Please fill all fields!"})
            return
        end
        
        local success, correctKey = pcall(function()
            return game:HttpGet(keyLink):gsub("%s+", "")  -- Get key from link, trim whitespace
        end)
        
        if not success then
            Fluent:Notify({Title="Error", Content="Failed to fetch key from link!"})
            return
        end
        
        if userKey:gsub("%s+", "") == correctKey then
            Fluent:Notify({Title="Success", Content="Key correct! Loading script..."})
            loadstring(scriptCode)()
        else
            Fluent:Notify({Title="Error", Content="Incorrect key!"})
        end
    end
})
