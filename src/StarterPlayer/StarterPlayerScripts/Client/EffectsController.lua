-- Procedural creature & guardian animation, world decor animation, prompt visibility, territory lighting and VFX.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Remotes = game.ReplicatedStorage.Remotes
local State = require(script.Parent.State)
local player = Players.LocalPlayer
local E = {}
local H, K
local animated = {}  -- [model] = {joint, base, style, seed, spins}
local guardians = {}
local spinDecor = {}
local lowGfx = false

-- Animation styles return a CFrame offset for the BodyJoint
local styles = {
	Bounce = function(t, s) local b = math.abs(math.sin(t * 4 + s)) return CFrame.new(0, b * 0.6, 0) end,
	Waddle = function(t, s) return CFrame.Angles(0, 0, math.sin(t * 5 + s) * 0.14) * CFrame.new(0, math.abs(math.sin(t * 5 + s)) * 0.15, 0) end,
	Hop = function(t, s) local p = (t * 0.9 + s) % 2 local y = p < 0.5 and math.sin(p / 0.5 * math.pi) * 1.4 or 0 return CFrame.new(0, y, 0) end,
	Wiggle = function(t, s) return CFrame.Angles(0, math.sin(t * 3 + s) * 0.35, 0) * CFrame.new(0, math.sin(t * 6 + s) * 0.1, 0) end,
	Slide = function(t, s) return CFrame.new(0, 0, math.sin(t * 1.5 + s) * 0.4) * CFrame.Angles(0, math.sin(t * 0.8 + s) * 0.3, 0) end,
	Sway = function(t, s) return CFrame.Angles(math.sin(t * 1.6 + s) * 0.05, math.sin(t * 0.7 + s) * 0.25, math.sin(t * 2 + s) * 0.06) end,
	Glitch = function(t, s) if math.random() < 0.08 then return CFrame.new((math.random() - 0.5) * 0.4, (math.random() - 0.5) * 0.2, 0) end return CFrame.new(0, math.sin(t * 3 + s) * 0.1, 0) end,
	Stomp = function(t, s) return CFrame.new(0, math.abs(math.sin(t * 2.4 + s)) * 0.25, 0) * CFrame.Angles(math.sin(t * 2.4 + s) * 0.05, 0, math.sin(t * 1.2 + s) * 0.05) end,
	Float = function(t, s) return CFrame.new(0, 1.2 + math.sin(t * 1.5 + s) * 0.6, 0) * CFrame.Angles(0, t * 0.3 + s, 0) end,
	Scuttle = function(t, s) return CFrame.new(math.sin(t * 14 + s) * 0.06, 0, math.sin(t * 0.9 + s) * 0.6) * CFrame.Angles(0, math.sin(t * 0.9 + s) * 0.5, 0) end,
}
local carriedStyle = function(t, s) return CFrame.Angles(math.sin(t * 9 + s) * 0.15, 0, math.sin(t * 7 + s) * 0.2) end

local function register(m)
	if animated[m] then return end
	local root = m:WaitForChild("Root", 5) or m.PrimaryPart
	local joint = root and root:FindFirstChild("BodyJoint")
	if not joint then return end
	local spins = {}
	for _, d in ipairs(m:GetDescendants()) do
		if d:IsA("Motor6D") and d.Name == "SpinJoint" then table.insert(spins, {j = d, base = d.C0, rate = d.Part1:GetAttribute("Spin") or 1, axis = d.Part1:GetAttribute("SpinAxis") or "Y"}) end
	end
	animated[m] = {joint = joint, base = joint.C0, style = styles[m:GetAttribute("Anim") or "Sway"] or styles.Sway, seed = math.random() * 10, spins = spins, root = root}
end
local function registerGuardian(m)
	local root = m:WaitForChild("HumanoidRootPart", 5)
	local joint = root and root:FindFirstChild("BodyJoint")
	if not joint then return end
	local bb = Instance.new("BillboardGui") bb.Size = UDim2.fromOffset(70, 70) bb.StudsOffset = Vector3.new(0, (m:GetAttribute("Height") or 5) * 0.6 + 2, 0) bb.AlwaysOnTop = true bb.MaxDistance = 120 bb.Adornee = root bb.Parent = m
	local l = Instance.new("TextLabel") l.BackgroundTransparency = 1 l.Size = UDim2.fromScale(1, 1) l.Font = Enum.Font.FredokaOne l.TextScaled = true l.TextStrokeTransparency = 0 l.Text = "" l.Parent = bb
	local spins = {}
	for _, d in ipairs(m:GetDescendants()) do if d:IsA("Motor6D") and d.Name == "SpinJoint" then table.insert(spins, {j = d, base = d.C0, rate = d.Part1:GetAttribute("Spin") or 1, axis = "Y"}) end end
	guardians[m] = {joint = joint, base = joint.C0, root = root, label = l, seed = math.random() * 10, spins = spins}
	local function upd()
		local st = m:GetAttribute("State")
		l.Text = st == "Chase" and "❗" or st == "Alert" and "❓" or ""
		l.TextColor3 = st == "Chase" and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(255, 220, 60)
		if st == "Chase" and m:IsDescendantOf(workspace) then
			local root2 = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root2 and (root2.Position - root.Position).Magnitude < 80 and player:GetAttribute("Carrying") then
				H.Notify("❗ A guardian is chasing you! SPRINT!", "warn") H.Flash(Color3.fromRGB(255, 60, 60), 0.75, 0.4)
			end
		end
	end
	m:GetAttributeChangedSignal("State"):Connect(upd)
end

-- Prompt visibility filtering (server still validates every interaction)
local function filterPrompt(pp)
	local function apply()
		local only = pp:GetAttribute("OwnerOnly")
		local notOwner = pp:GetAttribute("NotOwner")
		local enabled = true
		if only and only ~= player.UserId then enabled = false end
		if notOwner and notOwner == player.UserId then enabled = false end
		pp.Enabled = enabled
	end
	apply()
	pp:GetAttributeChangedSignal("OwnerOnly"):Connect(apply)
	pp:GetAttributeChangedSignal("NotOwner"):Connect(apply)
end

-- Territory gates are solid until unlocked (server also enforces)
local function refreshBarriers()
	local d = State.data
	for _, bar in ipairs(CollectionService:GetTagged("TerritoryBarrier")) do
		local un = d and d.territories[bar:GetAttribute("Territory")]
		bar.CanCollide = not un
		bar.Transparency = un and 1 or 0.2
		local pp = bar:FindFirstChildOfClass("ProximityPrompt") if pp then pp.Enabled = not un end
		local req = bar.Parent:FindFirstChild("ReqSign") if req then req.Transparency = un and 1 or 0 for _, g in ipairs(req:GetChildren()) do if g:IsA("SurfaceGui") then g.Enabled = not un end end end
	end
end

-- Territory ambience
local cc = Lighting:WaitForChild("BaseCC")
local atm = Lighting:FindFirstChildOfClass("Atmosphere")
local looks = {
	default = {tint = Color3.fromRGB(255, 255, 255), sat = 0.18, atmo = Color3.fromRGB(200, 220, 255), dens = 0.28},
	Mushroom = {tint = Color3.fromRGB(240, 255, 235), sat = 0.25, atmo = Color3.fromRGB(190, 240, 200), dens = 0.32},
	Frostbite = {tint = Color3.fromRGB(215, 235, 255), sat = 0.05, atmo = Color3.fromRGB(220, 240, 255), dens = 0.4},
	Molten = {tint = Color3.fromRGB(255, 205, 170), sat = 0.25, atmo = Color3.fromRGB(255, 140, 90), dens = 0.42},
	Cosmic = {tint = Color3.fromRGB(205, 170, 255), sat = 0.3, atmo = Color3.fromRGB(110, 70, 200), dens = 0.38},
}
local function ambience()
	local t = player:GetAttribute("Territory")
	local l = looks[t] or looks.default
	TweenService:Create(cc, TweenInfo.new(1.5), {TintColor = l.tint, Saturation = l.sat}):Play()
	if atm then TweenService:Create(atm, TweenInfo.new(1.5), {Color = l.atmo, Density = l.dens}):Play() end
end

local function burst(pos, color, count, size, speed)
	local p = Instance.new("Part") p.Anchored = true p.CanCollide = false p.CanQuery = false p.Transparency = 1 p.Size = Vector3.one p.Position = pos p.Parent = workspace.CurrentCamera
	local e = Instance.new("ParticleEmitter") e.Texture = "rbxasset://textures/particles/sparkles_main.dds" e.Color = ColorSequence.new(color) e.Size = NumberSequence.new(size or 0.6, 0)
	e.Speed = NumberRange.new(speed or 12) e.SpreadAngle = Vector2.new(180, 180) e.Lifetime = NumberRange.new(0.5, 1) e.LightEmission = 1 e.Rate = 0 e.Parent = p
	e:Emit(lowGfx and math.floor(count / 3) or count)
	game:GetService("Debris"):AddItem(p, 2)
end
local function floatText(pos, text, color)
	local p = Instance.new("Part") p.Anchored = true p.CanCollide = false p.Transparency = 1 p.Size = Vector3.one p.Position = pos p.Parent = workspace.CurrentCamera
	local bb = Instance.new("BillboardGui") bb.Size = UDim2.fromOffset(200, 50) bb.AlwaysOnTop = true bb.Parent = p
	local l = Instance.new("TextLabel") l.BackgroundTransparency = 1 l.Size = UDim2.fromScale(1, 1) l.Font = Enum.Font.FredokaOne l.TextScaled = true l.Text = text l.TextColor3 = color l.TextStrokeTransparency = 0 l.Parent = bb
	TweenService:Create(p, TweenInfo.new(1.2), {Position = pos + Vector3.new(0, 6, 0)}):Play()
	TweenService:Create(l, TweenInfo.new(1.2), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
	game:GetService("Debris"):AddItem(p, 1.3)
end

local fx = {}
fx.Pickup = function(pos, uid, id) burst(pos, Color3.fromRGB(255, 255, 160), 25, 0.6, 10) end
fx.Deliver = function(pos, uid, id)
	burst(pos + Vector3.new(0, 2, 0), Color3.fromRGB(120, 255, 150), 50, 0.8, 18)
	burst(pos + Vector3.new(0, 2, 0), Color3.fromRGB(255, 120, 220), 30, 0.6, 14)
	if uid == player.UserId then H.PlaySound("Success", 0.8) floatText(pos + Vector3.new(0, 4, 0), "COLLECTED!", Color3.fromRGB(120, 255, 150)) end
end
fx.Capture = function(pos, uid)
	if pos then burst(pos, Color3.fromRGB(200, 200, 255), 40, 1, 14) end
	if uid == player.UserId then
		H.Flash(Color3.fromRGB(0, 0, 0), 0.2, 2.5)
		K.Shake(1.5, 0.6)
		H.PlaySound("Capture", 1)
	end
end
fx.Hit = function(pos, attacker, victim)
	burst(pos, Color3.fromRGB(255, 240, 120), 30, 0.8, 20)
	floatText(pos + Vector3.new(0, 3, 0), "BONK!", Color3.fromRGB(255, 220, 60))
	if attacker == player.UserId then K.Shake(0.4, 0.15) end
end
fx.Snatch = function(pos) burst(pos, Color3.fromRGB(255, 120, 220), 30, 0.7, 15) floatText(pos + Vector3.new(0, 3, 0), "SNATCH!", Color3.fromRGB(255, 120, 220)) end
fx.Swing = function() end
fx.Knockback = function(vel) K.Knockback(vel) end
fx.CashPop = function(pos, amount) floatText(pos + Vector3.new(0, 3, 0), "+$" .. Config.FormatNumber(amount), Color3.fromRGB(120, 255, 140)) H.PlaySound("Cash", 0.6) end
fx.LevelUp = function()
	local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if r then burst(r.Position, Color3.fromRGB(255, 220, 80), 60, 0.8, 16) end
	H.Flash(Color3.fromRGB(255, 230, 120), 0.6, 0.8)
end
fx.Rebirth = function()
	local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if r then burst(r.Position, Color3.fromRGB(190, 120, 255), 120, 1, 25) end
	H.Flash(Color3.fromRGB(200, 150, 255), 0.2, 1.5)
end
fx.Unlock = function() H.Flash(Color3.fromRGB(150, 255, 180), 0.5, 1) H.PlaySound("Success", 1) end
fx.Portal = function() H.Flash(Color3.fromRGB(170, 100, 255), 0.1, 1) H.PlaySound("Flash", 0.8) end
fx.OpenUI = function(name) E.openPanel(name) end

function E.Init(hud, combat, openPanel)
	H, K = hud, combat
	E.openPanel = openPanel
	for _, m in ipairs(CollectionService:GetTagged("Oddling")) do task.spawn(register, m) end
	CollectionService:GetInstanceAddedSignal("Oddling"):Connect(function(m) task.spawn(register, m) end)
	CollectionService:GetInstanceRemovedSignal("Oddling"):Connect(function(m) animated[m] = nil end)
	for _, m in ipairs(CollectionService:GetTagged("Guardian")) do task.spawn(registerGuardian, m) end
	CollectionService:GetInstanceAddedSignal("Guardian"):Connect(function(m) task.spawn(registerGuardian, m) end)
	CollectionService:GetInstanceRemovedSignal("Guardian"):Connect(function(m) guardians[m] = nil end)
	local function addSpin(o) spinDecor[o] = o:IsA("Model") and o:GetPivot() or o.CFrame end
	for _, o in ipairs(CollectionService:GetTagged("SpinDecor")) do addSpin(o) end
	CollectionService:GetInstanceAddedSignal("SpinDecor"):Connect(addSpin)
	CollectionService:GetInstanceRemovedSignal("SpinDecor"):Connect(function(o) spinDecor[o] = nil end)
	for _, d in ipairs(workspace:GetDescendants()) do if d:IsA("ProximityPrompt") then filterPrompt(d) end end
	workspace.DescendantAdded:Connect(function(d)
		if d:IsA("ProximityPrompt") then filterPrompt(d)
		elseif d:IsA("TextLabel") and d:GetAttribute("Rainbow") then
			task.spawn(function() while d.Parent do d.TextColor3 = Color3.fromHSV((os.clock() * 0.3) % 1, 0.7, 1) task.wait(0.05) end end)
		elseif lowGfx and d:IsA("ParticleEmitter") then d.Enabled = false end
	end)
	State.Changed:Connect(refreshBarriers)
	CollectionService:GetInstanceAddedSignal("TerritoryBarrier"):Connect(function() task.defer(refreshBarriers) end)
	player:GetAttributeChangedSignal("Territory"):Connect(ambience)
	Remotes.Effect.OnClientEvent:Connect(function(name, ...)
		local f = fx[name] if f then f(...) end
	end)
	RunService.RenderStepped:Connect(function()
		local t = os.clock()
		local cam = workspace.CurrentCamera.CFrame.Position
		for m, a in pairs(animated) do
			if not m.Parent then animated[m] = nil
			elseif not m:GetAttribute("NoIdle") and a.root.Parent and (a.root.Position - cam).Magnitude < 140 then
				local style = (m.Parent and m.Parent:FindFirstChildOfClass("Humanoid")) and carriedStyle or a.style
				a.joint.C0 = a.base * style(t, a.seed)
				for _, s in ipairs(a.spins) do
					if s.axis == "G" then s.j.C0 = s.base * (math.random() < 0.15 and CFrame.new((math.random() - 0.5) * 0.3, (math.random() - 0.5) * 0.3, 0) or CFrame.identity)
					else s.j.C0 = s.base * CFrame.Angles(0, -t * s.rate, 0) end
				end
			end
		end
		for m, g in pairs(guardians) do
			if not m.Parent then guardians[m] = nil
			elseif (g.root.Position - cam).Magnitude < 160 then
				local v = g.root.AssemblyLinearVelocity.Magnitude
				local speedK = math.clamp(v / 12, 0, 1.5)
				local st = m:GetAttribute("State")
				local shake = st == "Alert" and CFrame.new((math.random() - 0.5) * 0.3, 0, 0) or CFrame.identity
				g.joint.C0 = g.base * shake * CFrame.new(0, math.abs(math.sin(t * 8 * math.max(speedK, 0.3) + g.seed)) * 0.5 * speedK, 0) * CFrame.Angles(0, 0, math.sin(t * 4 + g.seed) * 0.06 * speedK)
				for _, s in ipairs(g.spins) do s.j.C0 = s.base * CFrame.Angles(0, -t * s.rate, 0) end
			end
		end
		for o, base in pairs(spinDecor) do
			if not o.Parent then spinDecor[o] = nil else
				local r = o:GetAttribute("Spin") or 0.2
				local cf = base * CFrame.Angles(0, t * r, 0) * CFrame.new(0, math.sin(t + base.X) * 0.4, 0)
				if o:IsA("Model") then o:PivotTo(cf) else o.CFrame = cf end
			end
		end
	end)
	ambience()
end

function E.SetLowGfx(on)
	lowGfx = on
	for _, d in ipairs(workspace:GetDescendants()) do if d:IsA("ParticleEmitter") then d.Enabled = not on end end
	Lighting.GlobalShadows = not on
end

return E
