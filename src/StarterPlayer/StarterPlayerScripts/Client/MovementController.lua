-- Sprint, stamina, carrying penalty, dash, slide, stun and laser slow. Works on keyboard, gamepad and touch.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local player = Players.LocalPlayer
local M = {}
local MV = Config.Movement
local H
local stamina = MV.stamina
local sprintHeld, sprintToggle = false, false
local lastSprintEnd = 0
local lastDash, lastSlide = 0, 0
local sliding = false

local function char() return player.Character end
local function hum() local c = char() return c and c:FindFirstChildOfClass("Humanoid") end
local function root() local c = char() return c and c:FindFirstChild("HumanoidRootPart") end
local function stunned() return (player:GetAttribute("StunUntil") or 0) > workspace:GetServerTimeNow() end

function M.SetSprint(on) sprintToggle = on end
function M.IsSprinting() return (sprintHeld or sprintToggle) end

function M.Dash()
	local r, h = root(), hum()
	if not r or not h or stunned() or h.Health <= 0 then return end
	local cd = player:GetAttribute("DashCD") or MV.dashCooldown
	if os.clock() - lastDash < cd then return end
	local infinite = (player:GetAttribute("InfStaminaUntil") or 0) > os.time()
	if stamina < MV.dashCost and not infinite then H.Notify("😮‍💨 Not enough stamina to dash", "warn") return end
	lastDash = os.clock()
	if not infinite then stamina -= MV.dashCost end
	local dir = h.MoveDirection.Magnitude > 0.1 and h.MoveDirection or r.CFrame.LookVector
	local power = MV.dashPower * (1 - (player:GetAttribute("CarryPenalty") or 0) * 0.5)
	r.AssemblyLinearVelocity = Vector3.new(dir.X * power, math.max(r.AssemblyLinearVelocity.Y, 8), dir.Z * power)
	H.PlaySound("Jump", 0.5)
	local cam = workspace.CurrentCamera
	TweenService:Create(cam, TweenInfo.new(0.1), {FieldOfView = 85}):Play()
	task.delay(0.15, function() TweenService:Create(cam, TweenInfo.new(0.3), {FieldOfView = 70}):Play() end)
	M.Trail(0.35)
end

function M.Slide()
	local r, h = root(), hum()
	if not r or not h or stunned() or sliding then return end
	if os.clock() - lastSlide < MV.slideCooldown then return end
	if h.FloorMaterial == Enum.Material.Air or h.MoveDirection.Magnitude < 0.1 then return end
	lastSlide = os.clock()
	sliding = true
	local dir = h.MoveDirection
	local t0 = os.clock()
	h.CameraOffset = Vector3.new(0, -1.5, 0)
	local lower = char():FindFirstChild("LowerTorso")
	local rj = lower and lower:FindFirstChild("Root")
	local orig = rj and rj.C0
	if rj then rj.C0 = orig * CFrame.new(0, -1.2, 0) * CFrame.Angles(math.rad(-55), 0, 0) end
	M.Trail(MV.slideTime)
	H.PlaySound("Splash", 0.25)
	local conn
	conn = RunService.Heartbeat:Connect(function()
		local k = (os.clock() - t0) / MV.slideTime
		if k >= 1 or not r.Parent then
			conn:Disconnect() sliding = false
			if h.Parent then h.CameraOffset = Vector3.zero end
			if rj and rj.Parent then rj.C0 = orig end
			return
		end
		local sp = MV.slidePower * (1 - k * 0.6) * (1 - (player:GetAttribute("CarryPenalty") or 0))
		r.AssemblyLinearVelocity = Vector3.new(dir.X * sp, r.AssemblyLinearVelocity.Y, dir.Z * sp)
	end)
end

function M.Trail(t)
	local r = root() if not r then return end
	local a0 = Instance.new("Attachment", r) a0.Position = Vector3.new(0, 1.2, 0)
	local a1 = Instance.new("Attachment", r) a1.Position = Vector3.new(0, -1.6, 0)
	local tr = Instance.new("Trail") tr.Attachment0 = a0 tr.Attachment1 = a1 tr.Lifetime = 0.25 tr.LightEmission = 0.7
	tr.Color = ColorSequence.new(Color3.fromRGB(150, 230, 255), Color3.fromRGB(255, 255, 255)) tr.Transparency = NumberSequence.new(0.4, 1) tr.Parent = r
	task.delay(t + 0.3, function() tr:Destroy() a0:Destroy() a1:Destroy() end)
end

function M.Init(hud)
	H = hud
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then sprintHeld = true
		elseif input.KeyCode == Enum.KeyCode.ButtonL3 then sprintToggle = not sprintToggle
		elseif input.KeyCode == Enum.KeyCode.Q or input.KeyCode == Enum.KeyCode.ButtonX then M.Dash()
		elseif input.KeyCode == Enum.KeyCode.C or input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.ButtonB then M.Slide() end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then sprintHeld = false end
	end)
	RunService.RenderStepped:Connect(function(dt)
		local h = hum()
		if not h then return end
		local t = workspace:GetServerTimeNow()
		local maxSt = player:GetAttribute("StaminaMax") or MV.stamina
		local walk = player:GetAttribute("WalkBase") or MV.walk
		local penalty = player:GetAttribute("CarryPenalty") or 0
		walk *= (1 - penalty)
		if (player:GetAttribute("SlowUntil") or 0) > t then walk *= (1 - (player:GetAttribute("SlowAmount") or 0)) end
		local moving = h.MoveDirection.Magnitude > 0.1
		local infinite = (player:GetAttribute("InfStaminaUntil") or 0) > os.time()
		local sprinting = M.IsSprinting() and moving and stamina > 0.5
		if sprinting then
			walk *= (player:GetAttribute("SprintMult") or MV.sprintMult)
			if not infinite then stamina -= MV.drain * (penalty > 0 and MV.carryDrainMult or 1) * dt end
			lastSprintEnd = os.clock()
		elseif os.clock() - lastSprintEnd > MV.regenDelay then
			stamina += (player:GetAttribute("Regen") or MV.regen) * dt
		end
		if infinite then stamina = maxSt end
		stamina = math.clamp(stamina, 0, maxSt)
		if stunned() then h.WalkSpeed = 0 h.JumpPower = 0 h.JumpHeight = 0
		else h.WalkSpeed = walk h.JumpHeight = penalty > 0 and 5.5 or 7.2 end
		-- HUD
		local k = stamina / maxSt
		H.staminaFill.Size = UDim2.new(math.max(k, 0.001), -8 * k, 1, -8)
		local dashLeft = math.max(0, (player:GetAttribute("DashCD") or MV.dashCooldown) - (os.clock() - lastDash))
		H.staminaText.Text = (infinite and "♾️ INFINITE STAMINA" or ("⚡ %d / %d"):format(stamina, maxSt)) .. (dashLeft > 0 and ("   •   Dash %.1fs"):format(dashLeft) or "   •   Dash ready")
		H.staminaFrame.BackgroundColor3 = sprinting and Color3.fromRGB(70, 60, 130) or Color3.fromRGB(28, 24, 52)
		if stunned() then H.hint.Text = "💫 STUNNED!" elseif penalty > 0 then H.hint.Text = "Shift: Sprint  •  Q: Dash  •  C: Slide  →  get to your base!" else H.hint.Text = "" end
	end)
	player.CharacterAdded:Connect(function() stamina = player:GetAttribute("StaminaMax") or MV.stamina sliding = false end)
end

return M
