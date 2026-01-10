-- UI REDZ
local redzlib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/daucobonhi/UiRedzV5/refs/heads/main/DemoUi.lua"
))()

local Window = redzlib:MakeWindow({
    Title = "Fly Hub",
    SubTitle = "Redz UI",
    SaveFolder = "FlyRedz"
})

Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://131151731604309" },
    Corner = { CornerRadius = UDim.new(0,6) }
})

local FlyTab = Window:MakeTab({"Fly",""})

-- =========================
-- FLY LOGIC
-- =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local flying = false
local speed = 2
local vertical = 0
local bv, bg, conn

local function getRoot(char)
	return char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("UpperTorso")
		or char:FindFirstChild("Torso")
end

local function startFly()
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	local root = getRoot(char)
	if not hum or not root then return end

	hum.PlatformStand = true
	flying = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e9,1e9,1e9)
	bv.Parent = root

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
	bg.P = 15000
	bg.Parent = root

	conn = RunService.RenderStepped:Connect(function()
		if not flying then return end

		bg.CFrame = camera.CFrame
		local dir = hum.MoveDirection
		local cam = camera.CFrame

		local move =
			(cam.LookVector * dir.Z) +
			(cam.RightVector * dir.X) +
			Vector3.new(0, vertical, 0)

		if move.Magnitude > 0 then
			bv.Velocity = move.Unit * (speed * 25)
		else
			bv.Velocity = Vector3.zero
		end
	end)
end

local function stopFly()
	flying = false
	vertical = 0

	if conn then conn:Disconnect() end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end

	local char = player.Character
	if char then
		local hum = char:FindFirstChildWhichIsA("Humanoid")
		if hum then hum.PlatformStand = false end
	end
end

player.CharacterAdded:Connect(stopFly)

-- =========================
-- UI CONTROLS
-- =========================

FlyTab:AddToggle({
	Name = "Fly",
	Default = false,
	Callback = function(v)
		if v then
			startFly()
		else
			stopFly()
		end
	end
})

FlyTab:AddSlider({
	Name = "Fly Speed",
	Min = 1,
	Max = 10,
	Default = 2,
	Callback = function(v)
		speed = v
	end
})

FlyTab:AddButton({
	Name = "UP",
	Callback = function()
		vertical = 1
	end
})

FlyTab:AddButton({
	Name = "STOP UP/DOWN",
	Callback = function()
		vertical = 0
	end
})

FlyTab:AddButton({
	Name = "DOWN",
	Callback = function()
		vertical = -1
	end
})

