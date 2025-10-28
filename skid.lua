--// HieuDRG Hub – Pure V3 Fixed | Fly Toggle Visible | Core Không Đụng
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")
local Run = game:GetService("RunService")
local TS = game:GetService("TweenService")
local Players = game:GetService("Players")

if CoreGui:FindFirstChild("HieuDRGHub") then CoreGui.HieuDRGHub:Destroy() end

local BG = Color3.fromRGB(14,14,14)
local PANEL = Color3.fromRGB(24,24,24)
local ACCENT = Color3.fromRGB(255,165,0)
local TXT = Color3.fromRGB(230,230,230)

local function new(class,props)
    local i = Instance.new(class)
    if props then for k,v in pairs(props) do if k=="Parent" then i.Parent=v else i[k]=v end end end
    return i
end

------------------------------------------------------------------------
-- 1)  UI SHELL
------------------------------------------------------------------------
local Hub = new("ScreenGui",{Name="HieuDRGHub",Parent=CoreGui,ResetOnSpawn=false})
local Main = new("Frame",{Parent=Hub,Size=UDim2.fromOffset(320,420),Position=UDim2.new(1,-340,0.5,-210),BackgroundColor3=BG,BorderSizePixel=0,Active=true,Draggable=true})
new("UICorner",{Parent=Main,CornerRadius=UDim.new(0,12)})

local Header = new("Frame",{Parent=Main,Size=UDim2.new(1,0,0,50),BackgroundColor3=PANEL,BorderSizePixel=0})
new("UICorner",{Parent=Header,CornerRadius=UDim.new(0,12)})
new("TextLabel",{Parent=Header,Text="HieuDRG Hub",Font=Enum.Font.GothamBold,TextSize=18,TextColor3=ACCENT,BackgroundTransparency=1,Position=UDim2.new(0,12,0,6),Size=UDim2.new(0.7,0,0,20),TextXAlignment=Enum.TextXAlignment.Left})
new("TextLabel",{Parent=Header,Text=Players.LocalPlayer.Name,Font=Enum.Font.Gotham,TextSize=12,TextColor3=TXT,BackgroundTransparency=1,Position=UDim2.new(0,12,0,26),Size=UDim2.new(0.7,0,0,16),TextXAlignment=Enum.TextXAlignment.Left})
local Avatar = new("ImageLabel",{Parent=Header,Size=UDim2.new(0,32,0,32),Position=UDim2.new(1,-44,0.5,-16),BackgroundTransparency=1,Image=Players:GetUserThumbnailAsync(Players.LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)})
local Upt = new("TextLabel",{Parent=Header,Size=UDim2.new(0,80,0,12),Position=UDim2.new(1,-100,0.5,2),BackgroundTransparency=1,Text="Uptime: 0s",Font=Enum.Font.Gotham,TextSize=10,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Right})
spawn(function()
    local st = tick()
    while true do Upt.Text = "Uptime: " .. math.floor(tick()-st) .. "s"; wait(1) end
end)
local CloseBtn = new("TextButton",{Parent=Header,Size=UDim2.new(0,30,0,30),Position=UDim2.new(1,-36,0.5,-15),BackgroundColor3=ACCENT,Text="X",Font=Enum.Font.GothamBold,TextSize=16,TextColor3=Color3.new(1,1,1),AutoButtonColor=false})
new("UICorner",{Parent=CloseBtn,CornerRadius=UDim.new(0,8)})
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Content = new("ScrollingFrame",{Parent=Main,Size=UDim2.new(1,-12,1,-62),Position=UDim2.new(0,6,0,56),BackgroundTransparency=1,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y})
local UIL = new("UIListLayout",{Parent=Content,Padding=UDim.new(0,6)})

local function makeToggle(text,default,callback)
    local row = new("TextButton",{Parent=Content,Size=UDim2.new(1,0,0,42),BackgroundColor3=PANEL,Text="",AutoButtonColor=false})
    new("UICorner",{Parent=row,CornerRadius=UDim.new(0,8)})
    new("TextLabel",{Parent=row,Text=text,Font=Enum.Font.Gotham,TextSize=14,TextColor3=TXT,BackgroundTransparency=1,Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-60,1,0),TextXAlignment=Enum.TextXAlignment.Left})
    local sw = new("Frame",{Parent=row,Size=UDim2.new(0,40,0,20),Position=UDim2.new(1,-50,0.5,-10),BackgroundColor3=default and ACCENT or Color3.fromRGB(80,80,80)})
    new("UICorner",{Parent=sw,CornerRadius=UDim.new(1,0)})
    local knob = new("Frame",{Parent=sw,Size=UDim2.new(0,16,0,16),Position=default and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8),BackgroundColor3=Color3.fromRGB(245,245,245)})
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    local toggled = default
    local function set(v)
        toggled = v
        TS:Create(sw,TweenInfo.new(0.14),{BackgroundColor3 = v and ACCENT or Color3.fromRGB(80,80,80)}):Play()
        TS:Create(knob,TweenInfo.new(0.14),{Position = v and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
        if callback then callback(v) end
    end
    row.MouseButton1Click:Connect(function() set(not toggled) end)
    return {Set=set,Get=function() return toggled end}
end

local function makeSlider(text,minv,maxv,def,callback)
    local row = new("TextButton",{Parent=Content,Size=UDim2.new(1,0,0,50),BackgroundColor3=PANEL,Text="",AutoButtonColor=false})
    new("UICorner",{Parent=row,CornerRadius=UDim.new(0,8)})
    new("TextLabel",{Parent=row,Text=text,Font=Enum.Font.Gotham,TextSize=14,TextColor3=TXT,BackgroundTransparency=1,Position=UDim2.new(0,12,0,4),Size=UDim2.new(1,-60,0,16),TextXAlignment=Enum.TextXAlignment.Left})
    local bar = new("Frame",{Parent=row,Size=UDim2.new(1,-100,0,10),Position=UDim2.new(0,12,0,28),BackgroundColor3=Color3.fromRGB(60,60,60)})
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(0,6)})
    local frac = math.clamp((def-minv)/(maxv-minv),0,1)
    local fill = new("Frame",{Parent=bar,Size=UDim2.new(frac,0,1,0),BackgroundColor3=ACCENT})
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(0,6)})
    local knob = new("Frame",{Parent=bar,Size=UDim2.new(0,12,0,12),Position=UDim2.new(frac,-6,0.5,-6),BackgroundColor3=Color3.fromRGB(245,245,245)})
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    local valLb = new("TextLabel",{Parent=row,Text=tostring(def),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=TXT,BackgroundTransparency=1,Size=UDim2.new(0,40,0,16),Position=UDim2.new(1,-48,0,24)})
    local dragging = false
    local function updateFromX(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,0,1)
        local v = math.floor(minv + (maxv-minv)*rel + 0.5)
        fill.Size = UDim2.new(rel,0,1,0)
        knob.Position = UDim2.new(rel,-6,0.5,-6)
        valLb.Text = tostring(v)
        if callback then callback(v) end
    end
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then updateFromX(i.Position.X) end end)
    return row
end

------------------------------------------------------------------------
-- 2)  LOAD PURE FlyGuiV3  (nguyên thủy)
------------------------------------------------------------------------
loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

------------------------------------------------------------------------
-- 3)  FEATURES  –  ko đụng fly
------------------------------------------------------------------------
-- Noclip
makeToggle("Noclip",false,function(v)
    if v then
        _G.ncConn = Run.Stepped:Connect(function()
            for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end)
    else
        if _G.ncConn then _G.ncConn:Disconnect() end
    end
end)

-- Speed
local spd = 16
makeSlider("Speed Boost",16,200,16,function(v)
    spd = v
    hum.WalkSpeed = spd
end)

-- Jump
local jmp = 50
makeSlider("Jump Height",50,300,50,function(v)
    jmp = v
    hum.JumpPower = jmp
end)

-- Auto-Click (draggable button)
local autoclick = false
local clickBtn = new("TextButton",{Parent=Hub,Size=UDim2.new(0,80,0,80),Position=UDim2.new(0.5,-40,0.7,0),BackgroundColor3=ACCENT,Text="AUTO\nCLICK",Font=Enum.Font.GothamBold,TextColor3=Color3.new(1,1,1),TextScaled=true,Draggable=true})
clickBtn.MouseButton1Click:Connect(function()
    autoclick = not autoclick
    clickBtn.BackgroundColor3 = autoclick and Color3.new(0,1,0) or ACCENT
end)
Run.RenderStepped:Connect(function()
    if autoclick then
        local m = UIS:GetMouseLocation()
        local cam = workspace.CurrentCamera
        local ray = cam:ViewportPointToRay(m.X,m.Y)
        local t = workspace:FindPartOnRay(ray,char)
        if t then
            for _,v in pairs(t:GetDescendants()) do
                if v:IsA("ClickDetector") then fireclickdetector(v) end
                if v:IsA("ProximityPrompt") then fireproximityprompt(v,1) end
            end
        end
    end
end)

-- AntiBan
makeToggle("Anti Kick/Reset/AFK",false,function(v)
    if v then
        local mt = getrawmetatable(game)
        setreadonly(mt,false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self,...)
            local method = getnamecallmethod()
            if method:lower()=="kick" then return wait(9e9) end
            return old(self,...)
        end)
        lp.CharacterAdded:Connect(function(c)
            c:WaitForChild("Humanoid").BreakJointsOnDeath = false
        end)
        spawn(function() while true do UIS:SendKeyEvent(false,Enum.KeyCode.W,false,game) wait(120) end end)
    end
end)

-- ESP Player 7 màu
makeToggle("ESP Player (7 màu)",false,function(v)
    if v then
        for _,pl in pairs(game:GetService("Players"):GetPlayers()) do
            if pl~=lp and pl.Character then
                local col = Color3.fromHSV((pl.UserId%7)/7,1,1)
                for _,part in pairs(pl.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = part; box.Size = part.Size; box.Color3 = col; box.AlwaysOnTop = true; box.ZIndex = 5; box.Parent = part
                    end
                end
            end
        end
    else
        for _,pl in pairs(game:GetService("Players"):GetPlayers()) do
            if pl.Character then
                for _,part in pairs(pl.Character:GetChildren()) do
                    local b = part:FindFirstChildOfClass("BoxHandleAdornment")
                    if b then b:Destroy() end
                end
            end
        end
    end
end)

-- ESP Mod 7 màu
makeToggle("ESP Mod (7 màu)",false,function(v)
    if v then
        for _,pl in pairs(game:GetService("Players"):GetPlayers()) do
            if pl.UserId < 1000000 or pl:GetRankInGroup(4199740) > 0 then
                local col = Color3.fromHSV(((pl.UserId+3)%7)/7,1,1)
                if pl.Character then
                    for _,part in pairs(pl.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Adornee = part; box.Size = part.Size; box.Color3 = col; box.AlwaysOnTop = true; box.ZIndex = 5; box.Parent = part
                        end
                    end
                end
            end
        end
    else
        for _,pl in pairs(game:GetService("Players"):GetPlayers()) do
            if pl.Character then
                for _,part in pairs(pl.Character:GetChildren()) do
                    local b = part:FindFirstChildOfClass("BoxHandleAdornment")
                    if b then b:Destroy() end
                end
            end
        end
    end
end)

------------------------------------------------------------------------
-- 4)  FINISH
------------------------------------------------------------------------
Main.Position = UDim2.new(1,-340,0.5,-230); Main.BackgroundTransparency = 1
TS:Create(Main,TweenInfo.new(0.2),{BackgroundTransparency = 0}):Play()
TS:Create(Main,TweenInfo.new(0.2),{Position = UDim2.new(1,-340,0.5,-210)}):Play()
print("HieuDRG Hub – Pure V3 Fixed – loaded. Nhớ E / PageUp / PageDown để bay nhé con dâm.")
