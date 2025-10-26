-- HieuDRG FLY Hub (User-local script - intended for testing in development/private environments)
-- Features included:
--  • Polished RGB-cycling UI (7-color cycling)
--  • Fly (toggle + speed)
--  • Noclip (toggle)
--  • Speed slider
--  • High jump (jump power slider)
--  • Invincibility (best-effort client-side "godmode")
--  • Display player name + avatar thumbnail + uptime
--  • Locate players (adds a BillboardGui to players showing distance)
--  • Server-hop to another PUBLIC server (random low-pop) — DOES NOT attempt to join someone's private VIP server
--
-- IMPORTANT SAFETY NOTE (read before use):
-- I WILL NOT implement or include any functionality that (a) attempts to evade bans, (b) bypasses moderation or anti-cheat systems, (c) forcibly kicks or resets other players' sessions, or (d) automates joining someone else's PRIVATE/VIP server without an invite. Those requests are declined for ethical and policy reasons.
--
-- Usage: place this as a LocalScript inside StarterPlayerScripts for testing in a dev/local environment. Do NOT use in environments you do not have permission to modify.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- UI creation (simple, modern-ish) -------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HieuDRG_FLY_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0,360,0,480)
mainFrame.Position = UDim2.new(0,20,0,80)
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BackgroundColor3 = Color3.fromRGB(24,24,24)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = ScreenGui

local uiCorner = Instance.new("UICorner") uiCorner.CornerRadius = UDim.new(0,14) uiCorner.Parent = mainFrame
local uiPadding = Instance.new("UIPadding") uiPadding.PaddingTop = UDim.new(0,12) uiPadding.PaddingLeft = UDim.new(0,12) uiPadding.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -24, 0, 32)
title.BackgroundTransparency = 1
title.Parent = mainFrame
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "HieuDRG FLY Hub"
title.TextColor3 = Color3.fromRGB(255,255,255)

-- Header gradient (RGB 7-color cycling)
local headerBar = Instance.new("Frame")
headerBar.Size = UDim2.new(1, -24, 0, 6)
headerBar.Position = UDim2.new(0,0,0,40)
headerBar.BackgroundColor3 = Color3.fromRGB(255,0,0)
headerBar.BorderSizePixel = 0
headerBar.Parent = mainFrame
local headerCorner = Instance.new("UICorner") headerCorner.CornerRadius = UDim.new(0,6) headerCorner.Parent = headerBar

-- Left column controls
local leftCol = Instance.new("Frame")
leftCol.Size = UDim2.new(0.5, -12, 1, -64)
leftCol.Position = UDim2.new(0,0,0,64)
leftCol.BackgroundTransparency = 1
leftCol.Parent = mainFrame

-- Right column (info + locate)
local rightCol = Instance.new("Frame")
rightCol.Size = UDim2.new(0.5, -12, 1, -64)
rightCol.Position = UDim2.new(0.5, 12, 0,64)
rightCol.BackgroundTransparency = 1
rightCol.Parent = mainFrame

-- helper for element creation
local function makeToggle(parent, name, text, positionY)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 34)
	btn.Position = UDim2.new(0,0,0, positionY)
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

local function makeSlider(parent, name, labelText, positionY, min, max, default)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1,0,0,54)
	container.Position = UDim2.new(0,0,0,positionY)
	container.BackgroundTransparency = 1
	container.Parent = parent

	local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1,0,0,18) lbl.BackgroundTransparency = 1 lbl.Text = labelText lbl.Font = Enum.Font.Gotham lbl.TextSize = 12 lbl.TextColor3 = Color3.fromRGB(220,220,220) lbl.Parent = container

	local sliderBg = Instance.new("Frame") sliderBg.Size = UDim2.new(1,0,0,12) sliderBg.Position = UDim2.new(0,0,0,24) sliderBg.BackgroundTransparency = 0.12 sliderBg.BorderSizePixel = 0 sliderBg.Parent = container local cr = Instance.new("UICorner") cr.CornerRadius = UDim.new(0,6) cr.Parent = sliderBg

	local fill = Instance.new("Frame") fill.Size = UDim2.new((default-min)/(max-min),0,1,0) fill.BackgroundTransparency = 0.0 fill.BorderSizePixel = 0 fill.Parent = sliderBg local cr2 = Instance.new("UICorner") cr2.CornerRadius = UDim.new(0,6) cr2.Parent = fill

	local valueLbl = Instance.new("TextLabel") valueLbl.Size = UDim2.new(0,60,0,18) valueLbl.Position = UDim2.new(1,-64,0,0) valueLbl.BackgroundTransparency = 1 valueLbl.Text = tostring(default) valueLbl.Font = Enum.Font.Gotham valueLbl.TextSize = 12 valueLbl.TextColor3 = Color3.fromRGB(200,200,200) valueLbl.Parent = container

	return {container=container, fill=fill, valueLbl=valueLbl, min=min, max=max}
end

-- Controls
local flyToggle = makeToggle(leftCol, "FlyToggle", "Toggle Fly (F)", 0)
local noclipToggle = makeToggle(leftCol, "NoclipToggle", "Toggle Noclip (N)", 44)
local godToggle = makeToggle(leftCol, "GodToggle", "Toggle Invincibility", 88)
local serverHopBtn = makeToggle(leftCol, "HopBtn", "Server Hop (Public)", 132)

local speedSlider = makeSlider(leftCol, "SpeedSlider", "Walk Speed", 176, 8, 200, 16)
local jumpSlider = makeSlider(leftCol, "JumpSlider", "Jump Power", 240, 0, 300, 50)

-- Info panel
local infoTitle = Instance.new("TextLabel") infoTitle.Size = UDim2.new(1,0,0,18) infoTitle.BackgroundTransparency = 1 infoTitle.Text = "Player Info" infoTitle.Font = Enum.Font.GothamBold infoTitle.TextSize = 14 infoTitle.TextColor3 = Color3.fromRGB(240,240,240) infoTitle.Parent = rightCol

local avatar = Instance.new("ImageLabel") avatar.Size = UDim2.new(0,72,0,72) avatar.Position = UDim2.new(0,0,0,28) avatar.BackgroundTransparency = 1 avatar.Parent = rightCol
local nameLbl = Instance.new("TextLabel") nameLbl.Size = UDim2.new(1,0,0,20) nameLbl.Position = UDim2.new(0,80,0,28) nameLbl.BackgroundTransparency = 1 nameLbl.Font = Enum.Font.GothamBold nameLbl.TextSize = 14 nameLbl.TextColor3 = Color3.fromRGB(230,230,230) nameLbl.TextXAlignment = Enum.TextXAlignment.Left nameLbl.Parent = rightCol
local uptimeLbl = Instance.new("TextLabel") uptimeLbl.Size = UDim2.new(1,0,0,18) uptimeLbl.Position = UDim2.new(0,80,0,52) uptimeLbl.BackgroundTransparency = 1 uptimeLbl.Font = Enum.Font.Gotham nameLbl.TextSize = 12 uptimeLbl.TextColor3 = Color3.fromRGB(200,200,200) uptimeLbl.TextXAlignment = Enum.TextXAlignment.Left uptimeLbl.Parent = rightCol

-- Players locate area
local locateTitle = Instance.new("TextLabel") locateTitle.Size = UDim2.new(1,0,0,18) locateTitle.Position = UDim2.new(0,0,0,110) locateTitle.BackgroundTransparency = 1 locateTitle.Text = "Locate Players" locateTitle.Font = Enum.Font.GothamBold locateTitle.TextSize = 14 locateTitle.TextColor3 = Color3.fromRGB(240,240,240) locateTitle.Parent = rightCol
local playersList = Instance.new("ScrollingFrame") playersList.Size = UDim2.new(1,0,0,200) playersList.Position = UDim2.new(0,0,0,136) playersList.CanvasSize = UDim2.new(0,0,0,0) playersList.BackgroundTransparency = 1 playersList.Parent = rightCol

-- functionality -----------------------------------------------------------------
local state = {
	fly = false,
	noclip = false,
	god = false,
	flySpeed = 50,
	startTime = tick(),
}

-- RGB 7-color cycle helper
local colors = {
	Color3.fromRGB(255,0,0), -- red
	Color3.fromRGB(255,127,0), -- orange
	Color3.fromRGB(255,255,0), -- yellow
	Color3.fromRGB(0,255,0), -- green
	Color3.fromRGB(0,255,255), -- cyan
	Color3.fromRGB(0,0,255), -- blue
	Color3.fromRGB(139,0,255) -- violet
}
local colorIndex = 1
coroutine.wrap(function()
	while true do
		local from = colors[colorIndex]
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
	-- try to get headshot thumbnail (best-effort)
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

-- Fly implementation (client-side)
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

-- Noclip (client-side) - best effort: turns off CanCollide for character parts
local function setNoclip(enabled)
	local char = LocalPlayer.Character
	if not char then return end
	for _,part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not enabled
		end
	end
end

-- Godmode (client-side): continuously restore health and disable ragdoll-ish states
local function setGodMode(enabled)
	local char = LocalPlayer.Character
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	if enabled then
		humanoid.MaxHealth = math.huge
		humanoid.Health = math.huge
		-- keep resetting health if it changes
		spawn(function()
			while state.god do
				if humanoid and humanoid.Health ~= math.huge then
					humanoid.Health = math.huge
				end
				wait(0.5)
			end
		end)
	else
		-- restore to a reasonable default
		if humanoid then
			humanoid.MaxHealth = 100
			if humanoid.Health == math.huge then humanoid.Health = humanoid.MaxHealth end
		end
	end
end

-- Locate players: add BillboardGui for each player showing name + distance
local locateGuis = {}
local function makeLocateGuiForPlayer(target)
	if locateGuis[target] then return end
	local bg = Instance.new("BillboardGui")
	bg.Name = "HieuLocate"
	bg.AlwaysOnTop = true
	bg.Size = UDim2.new(0,140,0,40)
	bg.StudsOffset = Vector3.new(0,2,0)
	bg.MaxDistance = 200
	bg.Parent = target.Character and target.Character:FindFirstChild("Head") or workspace
	
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

-- rebuild players list UI
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
				-- toggle locate for this player
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

-- simple server hop to another public server (honest, best-effort):
-- This uses Roblox's public servers endpoint to find another server. This does NOT attempt to join someone else's private/vip server.
local function serverHopPublic()
	local placeId = game.PlaceId
	-- Using HttpService to query public servers (this call requires HttpEnabled in game settings when executed on Roblox servers.)
	local success, res = pcall(function()
		local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=10", placeId)
		local response = HttpService:GetAsync(url)
		return HttpService:JSONDecode(response)
	end)
	if success and type(res) == 'table' and res.data and #res.data>0 then
		-- pick a server with available slots
		for _,entry in ipairs(res.data) do
			if entry.playing < entry.maxPlayers then
				local serverId = entry.id
				-- Teleport to that server
				local TeleportService = game:GetService("TeleportService")
				pcall(function() TeleportService:TeleportToPrivateServer(placeId, serverId, {LocalPlayer}) end)
				return
			end
		end
	end
	StarterGui:SetCore("SendNotification", {Title="HOP", Text="No suitable public server found or Http disabled.",Duration=3})
end

-- Connections: GUI events and input
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

serverHopBtn.MouseButton1Click:Connect(function()
	serverHopPublic()
end)

-- slider interactions
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
			local move
			move = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					move:Disconnect()
				end
			end)
			local conn = RunService.Heartbeat:Connect(function()
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
local UserInputService = game:GetService("UserInputService")
local keys = {W=false, A=false, S=false, D=false}
UserInputService.InputBegan:Connect(function(inp, processed)
	if processed then return end
	if inp.KeyCode == Enum.KeyCode.F then
		flyToggle:CaptureFocus()
		state.fly = not state.fly
		if state.fly then startFly() else stopFly() end
	end
	if inp.KeyCode == Enum.KeyCode.N then
		noclipToggle:CaptureFocus()
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
	-- update locate labels distances
	for p,entry in pairs(locateGuis) do
		if p and p.Character and entry.label then
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				entry.label.Text = string.format("%s (%.1fm)", p.Name, dist)
			end
		end
	end

	-- fly movement
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
			-- vertical control
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec = moveVec - Vector3.new(0,1,0) end
			local speed = tonumber(speedSlider.valueLbl.Text) or 50
			flight.bv.Velocity = moveVec.Unit * math.clamp(moveVec.Magnitude,0,1) * speed
			flight.bg.CFrame = workspace.CurrentCamera.CFrame
		end
	end
	-- noclip continuous
	if state.noclip then setNoclip(true) end
end)

-- initial local character setup handlers
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

-- End of script
-- NOTE: This script intentionally avoids implementing features that would enable ban evasion, forcibly kicking or resetting other players' games, or joining someone's private VIP server without invite. If you need guidance for ethically-run administration tools, consider writing admin commands that require proper permissions and logging, or work with the game's developer to integrate server-side admin systems.
