--// HieuDRG Hub V2 – grafted inside Gravity Hub Vision 1.3
--  |   keep ALL original Gravity code  |  inject HieuDRG features after
------------------------------------------------------------------------

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- cleanup old Gravity
if CoreGui:FindFirstChild("GravityHubPreview") then
    CoreGui.GravityHubPreview:Destroy()
end

-- colour pallete
local BG = Color3.fromRGB(12,12,12)
local PANEL = Color3.fromRGB(22,22,22)
local PANEL_ALT = Color3.fromRGB(28,28,28)
local ACCENT = Color3.fromRGB(255,165,0)
local TXT = Color3.fromRGB(230,230,230)
local MUTED = Color3.fromRGB(160,160,160)
local TOGGLE_OFF = Color3.fromRGB(80,80,80)

local function new(class,props)
    local i = Instance.new(class)
    if props then
        for k,v in pairs(props) do
            if k=="Parent" then i.Parent=v else i[k]=v end
        end
    end
    return i
end

------------------------------------------------------------------------
-- 1)  GRAVITY WINDOW  (500×320, draggable, collapse)
------------------------------------------------------------------------
local scr = new("ScreenGui",{Name="GravityHubPreview",Parent=CoreGui,ResetOnSpawn=false})
scr.IgnoreGuiInset = true

local win = new("Frame",{Name="Window",Parent=scr,Size=UDim2.fromOffset(500,320),Position=UDim2.new(0.5,-250,0.5,-160),BackgroundColor3=BG,BorderSizePixel=0,ClipsDescendants=true})
new("UICorner",{Parent=win,CornerRadius=UDim.new(0,12)})

local header = new("Frame",{Parent=win,Size=UDim2.new(1,0,0,48),BackgroundColor3=PANEL_ALT,BorderSizePixel=0})
new("UICorner",{Parent=header,CornerRadius=UDim.new(0,12)})
new("TextLabel",{Parent=header,Text="HieuDRG Hub",Font=Enum.Font.GothamBold,TextSize=18,TextColor3=ACCENT,BackgroundTransparency=1,Position=UDim2.new(0,12,0,6),Size=UDim2.new(0.7,0,0,20),TextXAlignment=Enum.TextXAlignment.Left})
new("TextLabel",{Parent=header,Text="Vision 2.0 – All Game",Font=Enum.Font.Gotham,TextSize=12,TextColor3=MUTED,BackgroundTransparency=1,Position=UDim2.new(0,12,0,26),Size=UDim2.new(0.7,0,0,16),TextXAlignment=Enum.TextXAlignment.Left})

local btnCollapse = new("TextButton",{Parent=header,Size=UDim2.new(0,44,0,30),Position=UDim2.new(1,-56,0.5,-15),BackgroundColor3=PANEL,Text="-",Font=Enum.Font.GothamBold,TextSize=20,TextColor3=TXT,AutoButtonColor=false})
new("UICorner",{Parent=btnCollapse,CornerRadius=UDim.new(0,8)})

-- Avatar + name + uptime
local Avatar = new("ImageLabel",{Parent=header,Size=UDim2.new(0,32,0,32),Position=UDim2.new(1,-92,0.5,-16),BackgroundTransparency=1,Image=game:GetService("Players"):GetUserThumbnailAsync(game.Players.LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420)})
local NameLb = new("TextLabel",{Parent=header,Size=UDim2.new(0,120,0,14),Position=UDim2.new(1,-150,0.5,-12),BackgroundTransparency=1,Text=game.Players.LocalPlayer.Name,Font=Enum.Font.GothamBold,TextSize=12,TextColor3=TXT,TextXAlignment=Enum.TextXAlignment.Right})
local Upt = new("TextLabel",{Parent=header,Size=UDim2.new(0,120,0,12),Position=UDim2.new(1,-150,0.5,2),BackgroundTransparency=1,Text="Uptime: 0s",Font=Enum.Font.Gotham,TextSize=10,TextColor3=MUTED,TextXAlignment=Enum.TextXAlignment.Right})
spawn(function()
    local st = tick()
    while true do
        Upt.Text = "Uptime: " .. math.floor(tick()-st) .. "s"
        wait(1)
    end
end)

-- Tab bar
local tabBar = new("Frame",{Parent=win,Size=UDim2.new(1,0,0,44),Position=UDim2.new(0,0,0,48),BackgroundColor3=PANEL,BorderSizePixel=0})
new("UICorner",{Parent=tabBar,CornerRadius=UDim.new(0,8)})
local tabScroller = new("ScrollingFrame",{Parent=tabBar,Size=UDim2.new(1,-24,1,0),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,ScrollBarThickness=6,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.X,HorizontalScrollBarInset=Enum.ScrollBarInset.Always})
local tabListLayout = new("UIListLayout",{Parent=tabScroller,FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,8),HorizontalAlignment=Enum.HorizontalAlignment.Left})

-- Content area
local content = new("Frame",{Parent=win,Size=UDim2.new(1,0,1,-92),Position=UDim2.new(0,0,0,92),BackgroundTransparency=1})

local function makePanel(parent, x)
    local p = new("Frame",{Parent=parent,Size=UDim2.new(0.5,-12,1,-24),Position=UDim2.new(x,x==0 and 12 or 6,0,12),BackgroundColor3=PANEL,BorderSizePixel=0})
    new("UICorner",{Parent=p,CornerRadius=UDim.new(0,10)})
    return p
end

-- Tab system
local TabNames = {"Main","Combat","Player","ESP","Misc"}
local TabButtons, TabPages, currentTab = {}, {}, nil
local function setActiveTab(name)
    currentTab = name
    for k,btn in pairs(TabButtons) do
        btn.BackgroundColor3 = (k==name and ACCENT or Color3.fromRGB(35,35,35))
        btn.TextColor3 = (k==name and Color3.new(0,0,0) or TXT)
    end
    for k,page in pairs(TabPages) do page.Visible = (k==name) end
end
for _,name in ipairs(TabNames) do
    local btn = new("TextButton",{Parent=tabScroller,Size=UDim2.new(0,120,0,32),BackgroundColor3=Color3.fromRGB(35,35,35),Text=name,Font=Enum.Font.GothamSemibold,TextSize=14,TextColor3=TXT,AutoButtonColor=false})
    new("UICorner",{Parent=btn,CornerRadius=UDim.new(0,8)})
    TabButtons[name] = btn
    local page = new("Frame",{Parent=content,Name=name,Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Visible=false})
    TabPages[name] = page
    btn.MouseButton1Click:Connect(function() setActiveTab(name) end)
end

------------------------------------------------------------------------
-- 2)  CORE UTILS  (fly, noclip, speed, jump, autoclick, antiban, esp)
------------------------------------------------------------------------
local Players = game:GetService("Players")
local Run = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- Load original FlyGuiV3  (UNCHANGED)
loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()

------------------------------------------------------------------------
-- 3)  UI HELPER  (toggle, slider, dropdown inside Gravity style)
------------------------------------------------------------------------
local function new(class,props)
    local i = Instance.new(class)
    if props then for k,v in pairs(props) do if k=="Parent" then i.Parent=v else i[k]=v end end end
    return i
end
local function makeToggle(parent,text,default,callback)
    local row = new("TextButton",{Parent=parent,Size=UDim2.new(1,0,0,42),BackgroundColor3=Color3.fromRGB(38,38,38),Text="",AutoButtonColor=false})
    new("UICorner",{Parent=row,CornerRadius=UDim.new(0,8)})
    new("TextLabel",{Parent=row,Text=text,Font=Enum.Font.Gotham,TextSize=14,TextColor3=Color3.fromRGB(230,230,230),BackgroundTransparency=1,Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-96,1,0),TextXAlignment=Enum.TextXAlignment.Left})
    local sw = new("Frame",{Parent=row,Size=UDim2.new(0,44,0,22),Position=UDim2.new(1,-56,0.5,-11),BackgroundColor3=default and ACCENT or Color3.fromRGB(80,80,80)})
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
local function makeSlider(parent,text,minv,maxv,def,callback)
    local row = new("TextButton",{Parent=parent,Size=UDim2.new(1,0,0,50),BackgroundColor3=Color3.fromRGB(38,38,38),Text="",AutoButtonColor=false})
    new("UICorner",{Parent=row,CornerRadius=UDim.new(0,8)})
    new("TextLabel",{Parent=row,Text=text,Font=Enum.Font.Gotham,TextSize=14,TextColor3=TXT,BackgroundTransparency=1,Position=UDim2.new(0,12,0,4),Size=UDim2.new(1,-24,0,16),TextXAlignment=Enum.TextXAlignment.Left})
    local bar = new("Frame",{Parent=row,Size=UDim2.new(1,-110,0,10),Position=UDim2.new(0,12,0,28),BackgroundColor3=Color3.fromRGB(60,60,60)})
    new("UICorner",{Parent=bar,CornerRadius=UDim.new(0,6)})
    local frac = math.clamp((def-minv)/(maxv-minv),0,1)
    local fill = new("Frame",{Parent=bar,Size=UDim2.new(frac,0,1,0),BackgroundColor3=ACCENT})
    new("UICorner",{Parent=fill,CornerRadius=UDim.new(0,6)})
    local knob = new("Frame",{Parent=bar,Size=UDim2.new(0,12,0,12),Position=UDim2.new(frac,-6,0.5,-6),BackgroundColor3=Color3.fromRGB(245,245,245)})
    new("UICorner",{Parent=knob,CornerRadius=UDim.new(1,0)})
    local valLb = new("TextLabel",{Parent=row,Text=tostring(def),Font=Enum.Font.GothamBold,TextSize=12,TextColor3=TXT,BackgroundTransparency=1,Size=UDim2.new(0,50,0,18),Position=UDim2.new(1,-60,0,24)})
    local dragging = false
    local function update(x)
        local rel = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,0,1)
        local v = math.floor(minv + (maxv-minv)*rel + 0.5)
        fill.Size = UDim2.new(rel,0,1,0)
        knob.Position = UDim2.new(rel,-6,0.5,-6)
        valLb.Text = tostring(v)
        if callback then callback(v) end
    end
    knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UIS.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i.Position.X) end end)
    update(bar.AbsolutePosition.X + bar.AbsoluteSize.X*frac)
    return row
end

------------------------------------------------------------------------
-- 4)  POPULATE TABS
------------------------------------------------------------------------
-- 4.1  MAIN  –  Fly, Noclip, Speed, Jump, AutoClick, AntiBan
local mainPage = TabPages.Main
local left = new("ScrollingFrame",{Parent=mainPage,Size=UDim2.new(0.5,-12,1,-12),Position=UDim2.new(0,6,0,6),BackgroundTransparency=1,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y})
local right = new("ScrollingFrame",{Parent=mainPage,Size=UDim2.new(0.5,-12,1,-12),Position=UDim2.new(0.5,6,0,6),BackgroundTransparency=1,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y})
local UIL = new("UIListLayout",{Parent=left,Padding=UDim.new(0,6)})
local UIR = new("UIListLayout",{Parent=right,Padding=UDim.new(0,6)})

-- FlyGuiV3 already loaded -> nothing to add
makeToggle(left,"Fly Gui (built-in)",true,function(v) -- dummy toggle to show status
    -- core fly v3 handles itself
end)

-- Noclip
local ncT = makeToggle(left,"Noclip",false,function(v)
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
makeSlider(left,"Speed Boost",16,200,16,function(v)
    spd = v
    hum.WalkSpeed = spd
end)

-- Jump
local jmp = 50
makeSlider(left,"Jump Height",50,300,50,function(v)
    jmp = v
    hum.JumpPower = jmp
end)

-- Auto-Click button (draggable)
local autoclick = false
local clickBtn = new("TextButton",{Parent=scr,Size=UDim2.new(0,90,0,90),Position=UDim2.new(0.5,-45,0.7,0),BackgroundColor3=ACCENT,Text="AUTO\nCLICK",Font=Enum.Font.GothamBold,TextColor3=Color3.new(1,1,1),TextScaled=true,Draggable=true})
clickBtn.MouseButton1Click:Connect(function()
    autoclick = not autoclick
    clickBtn.BackgroundColor3 = autoclick and Color3.new(0,1,0) or ACCENT
end)
Run.RenderStepped:Connect(function()
    if autoclick then
        local m = UIS:GetMouseLocation()
        local cam = workspace.CurrentCamera
        local ray = cam:ViewportPointToRay(m.X, m.Y)
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
makeToggle(left,"Anti Kick/Reset/AFK",false,function(v)
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
        -- AFK spin
        spawn(function() while true do UIS:SendKeyEvent(false,Enum.KeyCode.W,false,game) wait(120) end end)
    end
end)

-- 4.2  ESP  –  Player 7 màu + Mod 7 màu
local espPage = TabPages.ESP
local espLeft = new("ScrollingFrame",{Parent=espPage,Size=UDim2.new(0.5,-12,1,-12),Position=UDim2.new(0,6,0,6),BackgroundTransparency=1,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y})
local espRight = new("ScrollingFrame",{Parent=espPage,Size=UDim2.new(0.5,-12,1,-12),Position=UDim2.new(0.5,6,0,6),BackgroundTransparency=1,ScrollBarThickness=4,AutomaticCanvasSize=Enum.AutomaticSize.Y})
new("UIListLayout",{Parent=espLeft,Padding=UDim.new(0,6)})
new("UIListLayout",{Parent=espRight,Padding=UDim.new(0,6)})

local pCols = {Color3.new(1,0,0),Color3.new(1,0.5,0),Color3.new(0,1,0),Color3.new(0,1,1),Color3.new(0,0,1),Color3.new(0.5,0,1),Color3.new(1,0,1)}
local mCols = {Color3.new(1,1,0),Color3.new(0,1,1),Color3.new(1,0,1),Color3.new(0.5,1,0),Color3.new(0,0.5,1),Color3.new(1,0,0.5),Color3.new(1,0.5,0.5)}

makeToggle(espLeft,"ESP Player (7 màu)",false,function(v)
    if v then
        for _,pl in pairs(Players:GetPlayers()) do
            if pl~=lp and pl.Character then
                local col = pCols[((pl.UserId % #pCols)+1)]
                for _,part in pairs(pl.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = part; box.Size = part.Size; box.Color3 = col; box.AlwaysOnTop = true; box.ZIndex = 5; box.Parent = part
                    end
                end
            end
        end
    else
        for _,pl in pairs(Players:GetPlayers()) do
            if pl.Character then
                for _,part in pairs(pl.Character:GetChildren()) do
                    local b = part:FindFirstChildOfClass("BoxHandleAdornment")
                    if b then b:Destroy() end
                end
            end
        end
    end
end)

makeToggle(espRight,"ESP Mod (7 màu)",false,function(v)
    if v then
        for _,pl in pairs(Players:GetPlayers()) do
            if pl.UserId < 1000000 or pl:GetRankInGroup(4199740) > 0 then -- group roblox
                local col = mCols[((pl.UserId % #mCols)+1)]
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
        for _,pl in pairs(Players:GetPlayers()) do
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
-- 5)  DRAG + COLLAPSE  (giữ nguyên Gravity)
------------------------------------------------------------------------
local dragging = false
local dragStart, startPos
header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = win.Position
        i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local collapsed = false
btnCollapse.MouseButton1Click:Connect(function()
    collapsed = not collapsed
    if collapsed then
        for _,v in pairs(content:GetChildren()) do v.Visible = false end
        TweenService:Create(win,TweenInfo.new(0.12),{Size = UDim2.fromOffset(500,48)}):Play()
    else
        TweenService:Create(win,TweenInfo.new(0.14),{Size = UDim2.fromOffset(500,320)}):Play()
        wait(0.02)
        setActiveTab(currentTab or "Main")
    end
end)

------------------------------------------------------------------------
-- 6)  FINISH  –  intro tween
------------------------------------------------------------------------
win.Position = UDim2.new(0.5,-250,0.5,-180); win.BackgroundTransparency = 1
TweenService:Create(win,TweenInfo.new(0.18),{BackgroundTransparency = 0}):Play()
TweenService:Create(win,TweenInfo.new(0.18),{Position = UDim2.new(0.5,-250,0.5,-160)}):Play()

setActiveTab("Main")
print("HieuDRG Hub V2 – grafted into Gravity Hub – loaded.")
