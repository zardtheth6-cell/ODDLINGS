-- Free bats, cosmetic variants, server-authoritative swing + hit validation, knockback and stun.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Remotes = game.ReplicatedStorage.Remotes
local K = {}
local S, Data
local lastSwing = {}
local immuneUntil = {}

function K.Init(services) S = services Data = S.Data end

local function buildBat(batId)
	local b = Config.BatById[batId] or Config.BatById.Classic
	local tool = Instance.new("Tool")
	tool.Name = "Bat" tool.ToolTip = b.name tool.CanBeDropped = false tool.RequiresHandle = true
	tool:SetAttribute("BatId", b.id)
	local handle = Instance.new("Part") handle.Name = "Handle" handle.Size = Vector3.new(0.45, 1.6, 0.45) handle.Color = Color3.fromRGB(40, 35, 35) handle.Material = Enum.Material.Fabric
	handle.CanCollide = false handle.Massless = true handle.Parent = tool
	local function piece(size, offsetY, col, mat, shape)
		local p = Instance.new("Part") p.Size = size p.CanCollide = false p.Massless = true p.Color = col p.Material = Enum.Material[mat]
		if shape then p.Shape = shape end
		p.CFrame = handle.CFrame * CFrame.new(0, offsetY, 0) p.Parent = tool
		local w = Instance.new("WeldConstraint") w.Part0 = handle w.Part1 = p w.Parent = p
		return p
	end
	piece(Vector3.new(0.6, 0.18, 0.6), -0.85, Color3.fromRGB(40, 35, 35), "SmoothPlastic")
	local barrel = piece(Vector3.new(0.75, 2.6, 0.75), 2.0, b.color, b.material)
	piece(Vector3.new(0.6, 1.0, 0.6), 0.6, b.color:Lerp(Color3.new(0, 0, 0), 0.15), b.material)
	local cap = piece(Vector3.new(0.78, 0.78, 0.78), 3.3, b.color, b.material, Enum.PartType.Ball)
	if b.material == "Neon" or b.fx then
		local l = Instance.new("PointLight") l.Color = b.color l.Range = 8 l.Brightness = 1.5 l.Parent = barrel
	end
	if b.fx == "Thunder" then
		local e = Instance.new("ParticleEmitter") e.Texture = "rbxasset://textures/particles/sparkles_main.dds" e.Color = ColorSequence.new(Color3.fromRGB(150, 200, 255))
		e.Rate = 15 e.Size = NumberSequence.new(0.3) e.Lifetime = NumberRange.new(0.2, 0.4) e.Speed = NumberRange.new(3) e.LightEmission = 1 e.Parent = barrel
	end
	if b.id == "Golden" then
		local e = Instance.new("ParticleEmitter") e.Color = ColorSequence.new(Color3.fromRGB(255, 220, 80)) e.Rate = 6 e.Size = NumberSequence.new(0.25) e.Lifetime = NumberRange.new(0.6) e.Speed = NumberRange.new(0.5) e.LightEmission = 1 e.Parent = cap
	end
	local a0 = Instance.new("Attachment", barrel) a0.Position = Vector3.new(0, 1.2, 0)
	local a1 = Instance.new("Attachment", barrel) a1.Position = Vector3.new(0, -1.0, 0)
	local tr = Instance.new("Trail") tr.Name = "SwingTrail" tr.Attachment0 = a0 tr.Attachment1 = a1 tr.Lifetime = 0.18 tr.Enabled = false tr.LightEmission = 0.5
	tr.Color = ColorSequence.new(b.color) tr.Transparency = NumberSequence.new(0.3, 1) tr.Parent = barrel
	tool.Grip = CFrame.new(0, -0.6, 0) * CFrame.Angles(math.rad(-90), 0, 0)
	tool:SetAttribute("BaseGrip", tool.Grip)
	return tool
end

function K.GiveBat(player)
	local data = Data.Get(player)
	local batId = data and data.bat or "Classic"
	local bp = player:FindFirstChildOfClass("Backpack")
	local char = player.Character
	for _, c in ipairs({bp, char}) do
		if c then for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") and t.Name == "Bat" then t:Destroy() end end end
	end
	if bp then buildBat(batId).Parent = bp end
end

local function playAt(part, id, vol)
	local s = Instance.new("Sound") s.SoundId = Config.Sounds[id] s.Volume = vol or 0.8 s.RollOffMaxDistance = 80 s.Parent = part s:Play()
	game:GetService("Debris"):AddItem(s, 3)
end

local function onSwing(player)
	if not S.Anti.Allow(player, "swing", 3, 3) then return end
	local char = player.Character
	local tool = char and char:FindFirstChild("Bat")
	if not tool then return end
	local nowC = os.clock()
	if (lastSwing[player] or 0) + Config.Bat.cooldown > nowC then return end
	if (player:GetAttribute("StunUntil") or 0) > workspace:GetServerTimeNow() then return end
	lastSwing[player] = nowC
	local root = S.Anti.Root(player)
	if not root then return end
	-- visible swing for everyone: animate the grip + right arm on the server
	local base = tool:GetAttribute("BaseGrip")
	local trail = tool:FindFirstChild("SwingTrail", true)
	if trail then trail.Enabled = true end
	local t1 = TweenService:Create(tool, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Grip = base * CFrame.Angles(math.rad(80), 0, 0) * CFrame.Angles(0, 0, math.rad(-60))})
	t1:Play()
	playAt(tool.Handle, "Swing", 0.7)
	Remotes.Effect:FireAllClients("Swing", root.Position, player.UserId)
	task.delay(0.12, function()
		local t2 = TweenService:Create(tool, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Grip = base})
		t2:Play()
		if trail then task.delay(0.15, function() trail.Enabled = false end) end
	end)
	task.wait(Config.Bat.windup)
	root = S.Anti.Root(player)
	if not root or not tool.Parent or tool.Parent ~= player.Character then return end
	if S.Anti.InSafeZone(root.Position) then return end
	local look = root.CFrame.LookVector
	local hitAny = false
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then
			local orr = S.Anti.Root(other)
			if orr then
				local diff = orr.Position - root.Position
				local flat = Vector3.new(diff.X, 0, diff.Z)
				local dist = flat.Magnitude
				if dist <= Config.Bat.range and math.abs(diff.Y) < 6 and (dist < 2 or flat.Unit:Dot(look) >= Config.Bat.angleDot) then
					local t = workspace:GetServerTimeNow()
					if S.Anti.InSafeZone(orr.Position) then continue end
					if (other:GetAttribute("SpawnShieldUntil") or 0) > t then continue end
					if (immuneUntil[other] or 0) > os.clock() then continue end
					-- escape shield blocks one hit
					local od = Data.Get(other)
					local carrying = S.Creatures.CarryInfo(other)
					if carrying and od and (od.boosts.escape or 0) > os.time() then
						od.boosts.escape = nil
						S.Economy.ApplyStats(other)
						S.Notify(other, "🛡️ Escape Shield absorbed the hit!", "shield", "Shield")
						immuneUntil[other] = os.clock() + Config.Bat.immunity
						Data.Sync(other)
						continue
					end
					hitAny = true
					immuneUntil[other] = os.clock() + Config.Bat.immunity
					other:SetAttribute("StunUntil", t + Config.Bat.stun)
					local dir = (flat.Magnitude > 0.1 and flat.Unit or look)
					Remotes.Effect:FireClient(other, "Knockback", dir * Config.Bat.knockback + Vector3.new(0, 22, 0))
					Remotes.Effect:FireAllClients("Hit", orr.Position, player.UserId, other.UserId)
					playAt(orr, "Hit", 1)
					if carrying then
						S.Creatures.DropCarried(other, "bat")
						S.Notify(other, "💥 You got bonked and dropped the Oddling!", "fail", "Fail")
						S.Notify(player, "💥 Bonk! " .. other.DisplayName .. " dropped their Oddling!", "success", "Hit")
					end
				end
			end
		end
	end
end

function K.Start()
	Remotes.Swing.OnServerEvent:Connect(onSwing)
	Players.PlayerRemoving:Connect(function(p) lastSwing[p] = nil immuneUntil[p] = nil end)
end

return K
