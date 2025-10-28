--// HieuDRG Hub V1 – built on top of FlyGuiV3 (unaltered)
local FGv3 = game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")
loadstring(FGv3)()   -- fly core giữ nguyên, không sửa 1 bit

--// Ổ chứa Hub riêng
local Core = {} do
    Core.gui   = game:GetService("CoreGui")
    Core.players = game:GetService("Players")
    Core.run   = game:GetService("RunService")
    Core.uis   = game:GetService("UserInputService")
    Core.tween = game:GetService("TweenService")
    Core.lp    = Core.players.LocalPlayer
    Core.char  = Core.lp.Character or Core.lp.CharacterAdded:Wait()
    Core.root  = Core.char:WaitForChild("HumanoidRootPart")
    Core.hum   = Core.char:WaitForChild("Humanoid")
end

--// UI Menu – FILE style
local Hub = Instance.new("ScreenGui", Core.gui)
Hub.Name = "HieuDRG_Hub"

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 420)
Main.Position = UDim2.new(1, -320, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = Hub

--// Title bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "HieuDRG Hub"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Parent = Main

--// Avatar + name
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 50, 0, 50)
Avatar.Position = UDim2.new(0, 10, 0, 35)
Avatar.BackgroundTransparency = 1
Avatar.Image = Core.players:GetUserThumbnailAsync(Core.lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Avatar.Parent = Main

local NameLb = Instance.new("TextLabel")
NameLb.Size = UDim2.new(0, 220, 0, 25)
NameLb.Position = UDim2.new(0, 70, 0, 40)
NameLb.BackgroundTransparency = 1
NameLb.Text = Core.lp.Name
NameLb.Font = Enum.Font.Gotham
NameLb.TextColor3 = Color3.new(1, 1, 1)
NameLb.TextXAlignment = Enum.TextXAlignment.Left
NameLb.Parent = Main

--// Uptime
local Upt = Instance.new("TextLabel")
Upt.Size = UDim2.new(0, 220, 0, 20)
Upt.Position = UDim2.new(0, 70, 0, 65)
Upt.BackgroundTransparency = 1
Upt.Text = "Uptime: 0s"
Upt.Font = Enum.Font.Gotham
Upt.TextColor3 = Color3.new(0.7, 0.7, 0.7)
Upt.TextXAlignment = Enum.TextXAlignment.Left
Upt.Parent = Main
spawn(function()
    local st = tick()
    while true do
        Upt.Text = "Uptime: " .. math.floor(tick() - st) .. "s"
        wait(1)
    end
end)

--// Nút đóng/mở
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.new(1, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Main
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--// Khung chức năng
local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1, -10, 1, -100)
List.Position = UDim2.new(0, 5, 0, 95)
List.BackgroundTransparency = 1
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new(0, 0, 0, 600)
List.Parent = Main

local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = List

--// Hàm tạo nút nhanh
local function addBtn(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = List
    btn.MouseButton1Click:Connect(callback)
end

--// 1) Noclip
local noclip = false
local ncConn
addBtn("Noclip (ON/OFF)", function()
    noclip = not noclip
    if noclip then
        ncConn = Core.run.Stepped:Connect(function()
            for _, v in pairs(Core.char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end)
    else
        if ncConn then ncConn:Disconnect() end
    end
end)

--// 2) Speed Boots
local spd = 16
addBtn("Speed +10", function()
    spd = spd + 10
    Core.hum.WalkSpeed = spd
end)
addBtn("Speed -10", function()
    spd = math.max(spd - 10, 16)
    Core.hum.WalkSpeed = spd
end)

--// 3) Jump Height
local jmp = 50
addBtn("Jump +20", function()
    jmp = jmp + 20
    Core.hum.JumpPower = jmp
end)

--// 4) Auto-Click (draggable button)
local autoclick = false
local clickBtn = Instance.new("TextButton")
clickBtn.Size = UDim2.new(0, 90, 0, 90)
clickBtn.Position = UDim2.new(0.5, -45, 0.5, 100)
clickBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
clickBtn.Text = "AUTO\nCLICK"
clickBtn.TextColor3 = Color3.new(1, 1, 1)
clickBtn.Font = Enum.Font.GothamBold
clickBtn.TextScaled = true
clickBtn.Draggable = true
clickBtn.Parent = Hub
clickBtn.MouseButton1Click:Connect(function()
    autoclick = not autoclick
    clickBtn.BackgroundColor3 = autoclick and Color3.new(0, 1, 0) or Color3.new(1, 0, 255)
end)
Core.run.RenderStepped:Connect(function()
    if autoclick then
        local cd = Core.uis:GetMouseLocation()
        local cam = workspace.CurrentCamera
        local ray = cam:ViewportPointToRay(cd.X, cd.Y)
        local target = workspace:FindPartOnRay(ray, Core.char)
        if target then
            for _, v in pairs(target:GetDescendants()) do
                if v:IsA("ClickDetector") then fireclickdetector(v) end
                if v:IsA("ProximityPrompt") then fireproximityprompt(v, 1) end
            end
        end
    end
end)

--// 5) AntiBan bundle
addBtn("Anti-Kick/Reset/AFK", function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return wait(9e9) end
        return old(self, ...)
    end)
    Core.lp.CharacterAdded:Connect(function(c)
        c:WaitForChild("Humanoid").BreakJointsOnDeath = false
    end)
    -- AFK spin
    spawn(function()
        while true do
            Core.uis:SendKeyEvent(false, Enum.KeyCode.W, false, game) wait(120)
        end
    end)
end)

--// 6) ESP Player 7 màu
local pEsp = false
local pCols = {Color3.new(1,0,0), Color3.new(1,0.5,0), Color3.new(0,1,0), Color3.new(0,1,1), Color3.new(0,0,1), Color3.new(0.5,0,1), Color3.new(1,0,1)}
addBtn("ESP Player (7 màu)", function()
    pEsp = not pEsp
    if pEsp then
        for _, pl in pairs(Core.players:GetPlayers()) do
            if pl ~= Core.lp and pl.Character then
                local col = pCols[((pl.UserId % #pCols) + 1)]
                for _, v in pairs(pl.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = v; box.Size = v.Size; box.Color3 = col; box.AlwaysOnTop = true; box.ZIndex = 5; box.Parent = v
                    end
                end
            end
        end
    else
        for _, pl in pairs(Core.players:GetPlayers()) do
            if pl.Character then
                for _, v in pairs(pl.Character:GetChildren()) do
                    v:FindFirstChildOfClass("BoxHandleAdornment"):Destroy()
                end
            end
        end
    end
end)

--// 7) ESP Mod (người có quyền) – 7 màu khác
local mEsp = false
local mCols = {Color3.new(1,1,0), Color3.new(0,1,1), Color3.new(1,0,1), Color3.new(0.5,1,0), Color3.new(0,0.5,1), Color3.new(1,0,0.5), Color3.new(1,0.5,0.5)}
addBtn("ESP Mod (7 màu)", function()
    mEsp = not mEsp
    if mEsp then
        for _, pl in pairs(Core.players:GetPlayers()) do
            if pl.UserId < 1000000 or pl:GetRankInGroup(4199740) > 0 then -- group Roblox
                local col = mCols[((pl.UserId % #mCols) + 1)]
                if pl.Character then
                    for _, v in pairs(pl.Character:GetChildren()) do
                        if v:IsA("BasePart") then
                            local box = Instance.new("BoxHandleAdornment")
                            box.Adornee = v; box.Size = v.Size; box.Color3 = col; box.AlwaysOnTop = true; box.ZIndex = 5; box.Parent = v
                        end
                    end
                end
            end
        end
    else
        for _, pl in pairs(Core.players:GetPlayers()) do
            if pl.Character then
                for _, v in pairs(pl.Character:GetChildren()) do
                    v:FindFirstChildOfClass("BoxHandleAdornment"):Destroy()
                end
            end
        end
    end
end)

--// Done – con chó đã giao
