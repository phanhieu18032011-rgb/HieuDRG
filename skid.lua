-- HieuDRG FLY Hub (User-local script - intended for testing in development/private environments)
-- Updated: draggable + collapse/expand menu + automatic sizing to fit controls
-- See previous notes about safety (no antiban/kick/reset other players etc.)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- UI creation (modern, draggable, collapsible, autosize) -------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HieuDRG_FLY_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0,380,0,60) -- initial compact
mainFrame.Position = UDim2.new(0,20,0,80)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BackgroundColor3 = Color3.fromRGB(24,24,24)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.Active = true -- needed for dragging
mainFrame.Parent = ScreenGui

local uiCorner = Instance.new("UICorner") uiCorner.CornerRadius = UDim.new(0,14) uiCorner.Parent = mainFrame
local uiPadding = Instance.new("UIPadding") uiPadding.PaddingTop = UDim.new(0,10) uiPadding.PaddingLeft = UDim.new(0,10) uiPadding.PaddingRight = UDim.new(0,10) uiPadding.PaddingBottom = UDim.new(0,10) uiPadding.Parent = mainFrame

-- Top bar (title + collapse + drag area)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1,0,0,36)
topBar.BackgroundTransparency = 1
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Parent = topBar
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "HieuDRG FLY Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)

local collapseBtn = Instance.new("TextButton")
collapseBtn.Name = "CollapseBtn"
collapseBtn.Size = UDim2.new(0,28,0,28)
collapseBtn.Position = UDim2.new(1,-28,0,4)
collapseBtn.AnchorPoint = Vector2.new(0,0)
collapseBtn.BackgroundTransparency = 0.12
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 18
collapseBtn.Text = "–"
collapseBtn.TextColor3 = Color3.fromRGB(230,230,230)
collapseBtn.BorderSizePixel = 0
collapseBtn.Parent = topBar
local collapseCorner = Instance.new("UICorner") collapseCorner.CornerRadius = UDim.new(0,6) collapseCorner.Parent = collapseBtn

-- Header gradient (RGB 7-color cycling)
local headerBar = Instance.new("Frame")
headerBar.Size = UDim2.new(1,0,0,6)
headerBar.Position = UDim2.new(0,0,0,40)
headerBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
headerBar.BorderSizePixel = 0
headerBar.Parent = mainFrame
local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0,6) headerCorner.Parent = headerBar

-- Content container (will be shown/hidden by collapse)
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1,0,0,320)
content.Position = UDim2.new(0,0,0,52)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local contentPadding = Instance.new("UIPadding") contentPadding.PaddingTop = UDim.new(0,8) contentPadding.PaddingLeft = UDim.new(0,8) contentPadding.PaddingRight = UDim.new(0,8) contentPadding.Parent = content

-- Two-column layout inside content
local columns = Instance.new("Frame")
columns.Size = UDim2.new(1,0,1,0)
columns.BackgroundTransparency = 1
columns.Parent = content

local leftCol = Instance.new("Frame")
leftCol.Size = UDim2.new(0.5,-8,1,0)
leftCol.Position = UDim2.new(0,0,0,0)
leftCol.BackgroundTransparency = 1
leftCol.Parent = columns

local rightCol = Instance.new("Frame")
rightCol.Size = UDim2.new(0.5,-8,1,0)
rightCol.Position = UDim2.new(0.5,8,0,0)
rightCol.BackgroundTransparency = 1
rightCol.Parent = columns

-- Use UIListLayout inside columns so we can auto-size based on children
local leftLayout = Instance.new("UIListLayout") leftLayout.SortOrder = Enum.SortOrder.LayoutOrder leftLayout.Padding = UDim.new(0,8) leftLayout.Parent = leftCol
local rightLayout = Instance.new("UIListLayout") rightLayout.SortOrder = Enum.SortOrder.LayoutOrder rightLayout.Padding = UDim.new(0,8) rightLayout.Parent = rightCol

-- helper for element creation
local function makeToggle(parent, name, text)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1,0,0,36)
	btn.BackgroundTransparency = 0.12
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(230,230,230)
	btn.BorderSizePixel = 0
	btn.Parent = parent
	local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,8) cr.Parent = btn
	return btn
end

local function makeSlider(parent, name, labelText, min, max, default)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,0,0,64)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1,0,0,18) lbl.BackgroundTransparency = 1 lbl.Text = labelText lbl.Font = Enum.Font.Gotham lbl.TextSize = 12 lbl.TextColor3 = Color3.fromRGB(220,220,220) lbl.Parent = container

	local sliderBg = Instance.new("Frame") sliderBg.Size = UDim2.new(1,0,0,12) sliderBg.Position = UDim2.new(0,0,0,28) sliderBg.BackgroundTransparency = 0.12 sliderBg.BorderSizePixel = 0 sliderBg.Parent = container local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,6) cr.Parent = sliderBg

	local fill = Instance.new("Frame") fill.Size = UDim2.new((default-min)/(max-min),0,1,0) fill.BackgroundTransparency = 0.0 fill.BorderSizePixel = 0 fill.Parent = sliderBg local cr2 = Instance.new("UICorner") cr2.CornerRadius = UDim.new(0,6) cr2.Parent = fill

	local valueLbl = Instance.new("TextLabel") valueLbl.Size = UDim2.new(0,60,0,18) valueLbl.Position = UDim2.new(1,-64,0,0) valueLbl.BackgroundTransparency = 1 valueLbl.Text = tostring(default) valueLbl.Font = Enum.Font.Gotham valueLbl.TextSize = 12 valueLbl.TextColor3 = Color3.fromRGB(200,200,200) valueLbl.Parent = container

	return {container=container, fill=fill, valueLbl=valueLbl, min=min, max=max}
end

-- Controls
local flyToggle = makeToggle(leftCol, "FlyToggle", "Toggle Fly (F)")
local noclipToggle = makeToggle(leftCol, "NoclipToggle", "Toggle Noclip (N)")
local godToggle = makeToggle(leftCol, "GodToggle", "Toggle Invincibility")
local serverHopBtn = makeToggle(leftCol, "HopBtn", "Server Hop (Public)")

local speedSlider = makeSlider(leftCol, "SpeedSlider", "Walk Speed", 8, 200, 16)
local jumpSlider = makeSlider(leftCol, "JumpSlider", "Jump Power", 0, 300, 50)

-- Info panel (right)
local infoTitle = Instance.new("TextLabel") infoTitle.Size = UDim2.new(1,0,0,20) infoTitle.BackgroundTransparency = 1 infoTitle.Text = "Player Info" infoTitle.Font = Enum.Font.GothamBold infoTitle.TextSize = 14 infoTitle.TextColor3 = Color3.fromRGB(240,240,240) infoTitle.LayoutOrder = 1 infoTitle.Parent = rightCol

local avatar = Instance.new("ImageLabel") avatar.Size = UDim2.new(0,72,0,72) avatar.BackgroundTransparency = 1 avatar.LayoutOrder = 2 avatar.Parent = rightCol
local nameLbl = Instance.new("TextLabel") nameLbl.Size = UDim2.new(1,0,0,20) nameLbl.BackgroundTransparency = 1 nameLbl.Font = Enum.Font.GothamBold nameLbl.TextSize = 14 nameLbl.TextColor3 = Color3.fromRGB(230,230,230) nameLbl.TextXAlignment = Enum.TextXAlignment.Left nameLbl.LayoutOrder = 3 nameLbl.Parent = rightCol
local uptimeLbl = Instance.new("TextLabel") uptimeLbl.Size = UDim2.new(1,0,0,18) uptimeLbl.BackgroundTransparency = 1 uptimeLbl.Font = Enum.Font.Gotham uptimeLbl.TextSize = 12 uptimeLbl.TextColor3 = Color3.fromRGB(200,200,200) uptimeLbl.TextXAlignment = Enum.TextXAlignment.Left uptimeLbl.LayoutOrder = 4 uptimeLbl.Parent = rightCol

-- Locate players area
local locateTitle = Instance.new("TextLabel") locateTitle.Size = UDim2.new(1,0,0,18) locateTitle.BackgroundTransparency = 1 locateTitle.Text = "Locate Players" locateTitle.Font = Enum.Font.GothamBold locateTitle.TextSize = 14 locateTitle.TextColor3 = Color3.fromRGB(240,240,240) locateTitle.LayoutOrder = 5 locateTitle.Parent = rightCol
local playersList = Instance.new("ScrollingFrame") playersList.Size = UDim2.new(1,0,0,180) playersList.CanvasSize = UDim2.new(0,0,0,0) playersList.BackgroundTransparency = 1 playersList.LayoutOrder = 6 playersList.Parent = rightCol

-- functionality (same as previous, adapted) ------------------------------------
local state = {fly=false, noclip=false, god=false, startTime = tick()}

-- RGB 7-color cycle helper
local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(255,127,0), Color3.fromRGB(255,255,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,255,255), Color3.fromRGB(0,0,255), Color3.fromRGB(139,0,255)}
local colorIndex = 1
coroutine.wrap(function()
	while true do
		local to = colors[(colorIndex % #colors) + 1]
		local tween = TweenService:Create(headerBar, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundColor3 = to})
		tween:Play()
		colorIndex = (colorIndex % #colors) + 1
		wait(2)
	end
end)()

-- Update avatar and name
local function updatePlayerInfo()
	local p = LocalPlayer
	nameLbl.Text = p.Name
	local success, thumb = pcall(function()
		return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
	end)
	if success and thumb then
		avatar.Image = thumb
	else
		avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..tostring(p.UserId).."&w=420&h=420"
	end
end
updatePlayerInfo()

-- Uptime
spawn(function()
	while true do
		local diff = math.floor(tick() - state.startTime)
		local h = math.floor(diff/3600)
		local m = math.floor((diff%3600)/60)
		local s = diff%60
		uptimeLbl.Text = string.format("Uptime: %02d:%02d:%02d", h,m,s)
		wait(1)
	end
end)

-- Fly, Noclip, Godmode, Locate (kept same logic) -------------------------------
local flight = {bv=nil, bg=nil}
local function startFly()
	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart
	flight.bv = Instance.new("BodyVelocity")
	flight.bv.MaxForce = Vector3.new(9e9,9e9,9e9)
	flight.bv.Velocity = Vector3.new(0,0,0)
	flight.bv.Parent = hrp

	flight.bg = Instance.new("BodyGyro")
	flight.bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
	flight.bg.P = 9e4
	flight.bg.Parent = hrp
end
local function stopFly()
	if flight.bv then flight.bv:Destroy() flight.bv = nil end
	if flight.bg then flight.bg:Destroy() flight.bg = nil end
end

local function setNoclip(enabled)
	local char = LocalPlayer.Character
	if not char then return end
	for _,part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not enabled
		end
	end
end

local function setGodMode(enabled)
	local char = LocalPlayer.Character
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	if enabled then
		humanoid.MaxHealth = math.huge
		humanoid.Health = math.huge
		spawn(function()
			while state.god do
				if humanoid and humanoid.Health ~= math.huge then
					humanoid.Health = math.huge
				end
				wait(0.5)
			end
		end)
	else
		if humanoid then
			humanoid.MaxHealth = 100
			if humanoid.Health == math.huge then humanoid.Health = humanoid.MaxHealth end
		end
	end
end

-- Locate players UI
local locateGuis = {}
local function makeLocateGuiForPlayer(target)
	if locateGuis[target] then return end
	if not target.Character or not target.Character:FindFirstChild("Head") then return end
	local bg = Instance.new("BillboardGui")
	bg.Name = "HieuLocate"
	bg.AlwaysOnTop = true
	bg.Size = UDim2.new(0,140,0,40)
	bg.StudsOffset = Vector3.new(0,2,0)
	bg.MaxDistance = 200
	bg.Parent = target.Character.Head
	local fr = Instance.new("Frame") fr.Size = UDim2.new(1,0,1,0) fr.BackgroundTransparency = 0.2 fr.BorderSizePixel = 0 fr.Parent = bg local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,6) cr.Parent = fr
	local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1,0,1,0) lbl.BackgroundTransparency = 1 lbl.Font = Enum.Font.Gotham lbl.TextSize = 12 lbl.TextColor3 = Color3.new(1,1,1) lbl.Text = target.Name lbl.Parent = fr
	locateGuis[target] = {gui=bg, label=lbl}
end
local function removeLocateGui(target)
	if locateGuis[target] then
		if locateGuis[target].gui then locateGuis[target].gui:Destroy() end
		locateGuis[target] = nil
	end
end

local function rebuildPlayersList()
	for _,v in ipairs(playersList:GetChildren()) do
		v:Destroy()
	end
	local y = 0
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton") btn.Size = UDim2.new(1,0,0,28) btn.Position = UDim2.new(0,0,0,y) btn.BackgroundTransparency = 0.12 btn.Text = p.Name btn.Font = Enum.Font.Gotham btn.TextSize = 13 btn.TextColor3 = Color3.new(1,1,1) btn.Parent = playersList
			local locBtn = Instance.new("TextButton") locBtn.Size = UDim2.new(0,80,1,0) locBtn.AnchorPoint = Vector2.new(1,0) locBtn.Position = UDim2.new(1,-8,0,0) locBtn.BackgroundTransparency = 0.2 locBtn.Text = "Locate" locBtn.Font = Enum.Font.Gotham locBtn.TextSize = 12 locBtn.Parent = btn
			local pRef = p
			locBtn.MouseButton1Click:Connect(function()
				if locateGuis[pRef] then removeLocateGui(pRef) else makeLocateGuiForPlayer(pRef) end
			end)
			y = y + 32
		end
	end
	playersList.CanvasSize = UDim2.new(0,0,0,math.max(0,y))
end

Players.PlayerAdded:Connect(function() rebuildPlayersList() end)
Players.PlayerRemoving:Connect(function(p) removeLocateGui(p) rebuildPlayersList() end)
rebuildPlayersList()

-- Server hop (public) - same best-effort
local function serverHopPublic()
	local placeId = game.PlaceId
	local success, res = pcall(function()
		local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=10", placeId)
		local response = HttpService:GetAsync(url)
		return HttpService:JSONDecode(response)
	end)
	if success and type(res) == 'table' and res.data and #res.data>0 then
		for _,entry in ipairs(res.data) do
			if entry.playing < entry.maxPlayers then
				local serverId = entry.id
				local TeleportService = game:GetService("TeleportService")
				pcall(function() TeleportService:TeleportToPrivateServer(placeId, serverId, {LocalPlayer}) end)
				return
			end
		end
	end
	StarterGui:SetCore("SendNotification", {Title="HOP", Text="No suitable public server found or Http disabled.",Duration=3})
end

-- GUI events
flyToggle.MouseButton1Click:Connect(function()
	state.fly = not state.fly
	if state.fly then
		startFly()
		flyToggle.Text = "Fly: ON (F)"
	else
		stopFly()
		flyToggle.Text = "Fly: OFF (F)"
	end
end)

noclipToggle.MouseButton1Click:Connect(function()
	state.noclip = not state.noclip
	setNoclip(state.noclip)
	noclipToggle.Text = state.noclip and "Noclip: ON (N)" or "Noclip: OFF (N)"
end)

godToggle.MouseButton1Click:Connect(function()
	state.god = not state.god
	setGodMode(state.god)
	godToggle.Text = state.god and "Invincible: ON" or "Invincible: OFF"
end)

serverHopBtn.MouseButton1Click:Connect(function() serverHopPublic() end)

-- slider interactions (same hookup function)
local UserInputService = game:GetService("UserInputService")
local function hookupSlider(slider, onChange)
	slider.container.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local function update(pos)
				local abs = slider.fill.Parent.AbsoluteSize.X
				local x = math.clamp(pos.X - slider.fill.Parent.AbsolutePosition.X, 0, abs)
				local frac = x/abs
				local value = math.floor(slider.min + (slider.max - slider.min)*frac + 0.5)
				slider.fill.Size = UDim2.new(frac,0,1,0)
				slider.valueLbl.Text = tostring(value)
				onChange(value)
			end
			local conn
			conn = RunService.Heartbeat:Connect(function()
				local mouse = game.Players.LocalPlayer:GetMouse()
				update(Vector2.new(mouse.X, mouse.Y))
			end)
			input.Changed:Wait()
			conn:Disconnect()
		end
	end)
end

hookupSlider(speedSlider, function(v)
	local char = LocalPlayer.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid").WalkSpeed = v
	end
end)
hookupSlider(jumpSlider, function(v)
	local char = LocalPlayer.Character
	if char and char:FindFirstChildOfClass("Humanoid") then
		char:FindFirstChildOfClass("Humanoid").JumpPower = v
	end
end)

-- input handlers for fly control
local keys = {W=false, A=false, S=false, D=false}
UserInputService.InputBegan:Connect(function(inp, processed)
	if processed then return end
	if inp.KeyCode == Enum.KeyCode.F then
		state.fly = not state.fly
		if state.fly then startFly() else stopFly() end
	end
	if inp.KeyCode == Enum.KeyCode.N then
		state.noclip = not state.noclip
		setNoclip(state.noclip)
	end
	if inp.KeyCode == Enum.KeyCode.W then keys.W=true end
	if inp.KeyCode == Enum.KeyCode.S then keys.S=true end
	if inp.KeyCode == Enum.KeyCode.A then keys.A=true end
	if inp.KeyCode == Enum.KeyCode.D then keys.D=true end
end)
UserInputService.InputEnded:Connect(function(inp, processed)
	if inp.KeyCode == Enum.KeyCode.W then keys.W=false end
	if inp.KeyCode == Enum.KeyCode.S then keys.S=false end
	if inp.KeyCode == Enum.KeyCode.A then keys.A=false end
	if inp.KeyCode == Enum.KeyCode.D then keys.D=false end
end)

-- flight update loop
RunService.Heartbeat:Connect(function(dt)
	for p,entry in pairs(locateGuis) do
		if p and p.Character and entry.label then
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				entry.label.Text = string.format("%s (%.1fm)", p.Name, dist)
			end
		end
	end

	if state.fly and flight.bv then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			local hrp = char.HumanoidRootPart
			local cam = workspace.CurrentCamera
			local moveVec = Vector3.new(0,0,0)
			if keys.W then moveVec = moveVec + (cam.CFrame.LookVector) end
			if keys.S then moveVec = moveVec - (cam.CFrame.LookVector) end
			if keys.A then moveVec = moveVec - (cam.CFrame.RightVector) end
			if keys.D then moveVec = moveVec + (cam.CFrame.RightVector) end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec = moveVec - Vector3.new(0,1,0) end
			local speed = tonumber(speedSlider.valueLbl.Text) or 50
			flight.bv.Velocity = moveVec.Unit * math.clamp(moveVec.Magnitude,0,1) * speed
			flight.bg.CFrame = workspace.CurrentCamera.CFrame
		end
	end
	if state.noclip then setNoclip(true) end
end)

-- character setup
local function onCharacterAdded(char)
	wait(0.5)
	updatePlayerInfo()
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = tonumber(speedSlider.valueLbl.Text) or 16
		hum.JumpPower = tonumber(jumpSlider.valueLbl.Text) or 50
	end
end
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then onCharacterAdded(LocalPlayer.Character) end

-- --- New: collapsible behavior & auto-resize -----------------------------------
local expanded = true
local function updateAutoSize()
	-- measure tallest column (using AbsoluteContentSize) then set content size + header
	local leftSize = leftLayout.AbsoluteContentSize.Y
	local rightSize = rightLayout.AbsoluteContentSize.Y
	local contentHeight = math.max(leftSize, rightSize)
	local total = 52 + contentHeight + 20 -- header + content + padding
	mainFrame.Size = UDim2.new(0,380,0, math.clamp(total, 56, 800))
end

-- connect to layout changes
leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateAutoSize)
rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateAutoSize)

collapseBtn.MouseButton1Click:Connect(function()
	expanded = not expanded
	if expanded then
		collapseBtn.Text = "–"
		content.Visible = true
		updateAutoSize()
	else
		collapseBtn.Text = "+"
		content.Visible = false
		mainFrame.Size = UDim2.new(0,380,0,52)
	end
end)

-- initial autosize after short wait
spawn(function() wait(0.2) updateAutoSize() end)

-- --- New: draggable mainFrame -------------------------------------------------
local dragging = false
local dragStart = nil
local startPos = nil
local function clampPosition(x,y)
	local screenW = math.max(1, ScreenGui.AbsoluteSize.X)
	local screenH = math.max(1, ScreenGui.AbsoluteSize.Y)
	local fw = mainFrame.AbsoluteSize.X
	local fh = mainFrame.AbsoluteSize.Y
	local nx = math.clamp(x, 0, screenW - fw)
	local ny = math.clamp(y, 0, screenH - fh)
	return nx, ny
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		local newX = startPos.X.Offset + delta.X
		local newY = startPos.Y.Offset + delta.Y
		local nx, ny = clampPosition(newX, newY)
		mainFrame.Position = UDim2.new(0, nx, 0, ny)
	end
end)

-- Also allow double-click topBar to toggle collapse
local lastClick = 0
topBar.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		local now = tick()
		if now - lastClick < 0.35 then
			-- double click
			collapseBtn.MouseButton1Click:Fire()
		end
		lastClick = now
	end
end)

-- Done: draggable, collapsible, and auto-resizing UI
-- Reminder: script is meant for local testing / personal use. Do not use to bypass protections or to attack other players.
