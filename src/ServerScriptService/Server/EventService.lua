-- Server-scheduled world events with announcements, effects, rewards and cleanup.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local CollectionService = game:GetService("CollectionService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Builder = require(game.ReplicatedStorage.Shared.CreatureBuilder)
local Remotes = game.ReplicatedStorage.Remotes
local Ev = {}
local S
local active = nil -- {id, endT, cleanup = fn, folder}

function Ev.Init(services) S = services end
function Ev.IsActive(tag) return active ~= nil and active.id == tag end
function Ev.OnSteal(p, entry)
	if entry.golden and active and active.id == "Golden" then
		Remotes.WorldEvent:FireAllClients({id = "Info", text = "✨ " .. p.DisplayName .. " grabbed the Golden Oddling! Stop them!"})
	end
end

local function screen(text)
	local es = workspace.Map.Plaza.IslandSign:FindFirstChild("EventScreen")
	if not es then return end
	for _, sg in ipairs(es:GetChildren()) do
		local l = sg:FindFirstChild("Label", true) if l then l.Text = text end
	end
end
local function sfx(parent, id, vol)
	local s = Instance.new("Sound") s.SoundId = Config.Sounds[id] s.Volume = vol or 1 s.RollOffMaxDistance = 400 s.Parent = parent s:Play()
	game:GetService("Debris"):AddItem(s, 6)
end
local function randomMeadow(radius)
	for _ = 1, 30 do
		local a = math.random() * math.pi * 2
		local x, z = math.cos(a) * radius, math.sin(a) * radius
		local r = workspace:Raycast(Vector3.new(x, 200, z), Vector3.new(0, -400, 0))
		if r and r.Instance == workspace.Terrain and r.Material ~= Enum.Material.Water and not S.Bases.PlotAt(r.Position) then return r.Position end
	end
	return Vector3.new(0, 1, 100)
end

local handlers = {}

handlers.Golden = function(ev)
	local terrs = {"Mushroom", "Mushroom", "Frostbite", "Molten", "Cosmic"}
	local t = terrs[math.random(1, #terrs)]
	local pts = {}
	for _, sp in ipairs(workspace.CreatureSpawns:GetChildren()) do if sp:GetAttribute("Territory") == t then table.insert(pts, sp) end end
	local sp = pts[math.random(1, #pts)]
	local cf = CFrame.new(sp.Position + Vector3.new(5, -0.4, 5))
	local id = S.Creatures.RollCreature(t, 1)
	local model = S.Creatures.SpawnEventCreature(cf, id, true, "Golden", t)
	ev.desc = "A Golden " .. Config.CreatureById[id].name .. " appeared in " .. Config.TerritoryById[t].name .. "! 5x income!"
	ev.cleanup = function() if model.Parent then S.Creatures.RemoveEventCreature(model) end
		for _, m in ipairs(workspace.ActiveCreatures:GetChildren()) do if m:GetAttribute("Golden") and m:GetAttribute("Territory") == t then S.Creatures.RemoveEventCreature(m) end end end
	ev.pos = cf.Position
end

handlers.Stampede = function(ev)
	local folder = Instance.new("Folder") folder.Name = "Stampede" folder.Parent = workspace.WorldEvents
	local runners = {}
	for i = 1, 12 do
		local id = Config.Creatures[math.random(1, 9)].id
		local m = Builder.BuildCreature(id)
		local lane = (i - 6.5) * 9
		local dir = (i % 2 == 0) and 1 or -1
		local startP = Vector3.new(-110 * dir, 0.4, lane)
		m:PivotTo(CFrame.lookAt(startP, startP + Vector3.new(dir, 0, 0)))
		m:SetAttribute("NoIdle", true) m:SetAttribute("Stampede", true)
		m.Parent = folder
		table.insert(runners, {m = m, dir = dir, x = -110 * dir - dir * i * 12, lane = lane, touched = {}})
	end
	local claims = {}
	local running = true
	task.spawn(function()
		while running and folder.Parent do
			local dt = task.wait(0.05)
			for _, r in ipairs(runners) do
				r.x += r.dir * 22 * dt
				if math.abs(r.x) > 120 then r.x = -120 * r.dir end
				local hop = math.abs(math.sin(os.clock() * 10 + r.lane)) * 1.2
				local pos = Vector3.new(r.x, 0.4 + hop, r.lane)
				r.m:PivotTo(CFrame.lookAt(pos, pos + Vector3.new(r.dir, 0, 0)))
				for _, p in ipairs(Players:GetPlayers()) do
					local rt = S.Anti.Root(p)
					if rt and not r.touched[p] and (rt.Position - pos).Magnitude < 5 and (claims[p] or 0) < 6 then
						r.touched[p] = true
						claims[p] = (claims[p] or 0) + 1
						local data = S.Data.Get(p)
						local reward = math.max(150, math.floor((data and S.Economy.TotalIncome(p, data) or 0) * 12))
						S.Economy.AddCash(p, reward, true)
						Remotes.Effect:FireClient(p, "CashPop", pos, reward)
					end
				end
			end
		end
	end)
	ev.cleanup = function() running = false folder:Destroy() end
	ev.pos = Vector3.new(0, 0, 0)
end

handlers.Meteor = function(ev)
	local folder = Instance.new("Folder") folder.Name = "Meteor" folder.Parent = workspace.WorldEvents
	local a = math.random() * math.pi * 2
	local target = Vector3.new(-380 + math.cos(a) * 35, 0, math.sin(a) * 35)
	local hit = workspace:Raycast(target + Vector3.new(0, 200, 0), Vector3.new(0, -300, 0))
	target = hit and hit.Position or Vector3.new(-380, 70, 0)
	local rock = Instance.new("Part") rock.Shape = Enum.PartType.Ball rock.Size = Vector3.new(10, 10, 10) rock.Material = Enum.Material.CrackedLava rock.Color = Color3.fromRGB(255, 120, 40)
	rock.Anchored = true rock.CanCollide = false rock.Position = target + Vector3.new(120, 260, 40) rock.Parent = folder
	local fire = Instance.new("Fire") fire.Size = 18 fire.Heat = 20 fire.Parent = rock
	local l = Instance.new("PointLight") l.Range = 60 l.Brightness = 4 l.Color = Color3.fromRGB(255, 150, 60) l.Parent = rock
	sfx(rock, "Rebirth", 1)
	local tw = TweenService:Create(rock, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = target + Vector3.new(0, 3, 0)})
	tw:Play()
	tw.Completed:Connect(function()
		if not folder.Parent then return end
		local ex = Instance.new("Explosion") ex.Position = target ex.BlastPressure = 0 ex.DestroyJointRadiusPercent = 0 ex.BlastRadius = 0 ex.Parent = folder
		sfx(rock, "Event", 1)
		fire.Size = 8 rock.Size = Vector3.new(7, 7, 7) rock.Position = target + Vector3.new(0, 1, 0)
		for i = 1, 8 do
			local b = i / 8 * math.pi * 2
			local gem = Instance.new("Part") gem.Size = Vector3.new(1.4, 3, 1.4) gem.Material = Enum.Material.Neon gem.Color = Color3.fromRGB(120, 220, 255)
			gem.Anchored = true gem.CanCollide = false gem.CFrame = CFrame.new(target + Vector3.new(math.cos(b) * 7, 1.6, math.sin(b) * 7)) * CFrame.Angles(0.3, b, 0.2)
			gem.Name = "SpaceGem" gem.Parent = folder
			local pp = Instance.new("ProximityPrompt") pp.ActionText = "Collect" pp.ObjectText = "Space Gem" pp.HoldDuration = 0.5 pp.RequiresLineOfSight = false pp.Parent = gem
			pp.Triggered:Connect(function(p)
				if not gem.Parent then return end
				local data = S.Data.Get(p)
				local rt = S.Anti.Root(p)
				if not data or not rt or (rt.Position - gem.Position).Magnitude > 14 then return end
				gem:Destroy()
				S.Economy.AddGems(p, 15)
				S.Notify(p, "☄️ +15 Gems from the meteor!", "reward", "Cash")
				S.Data.Sync(p)
			end)
		end
	end)
	ev.cleanup = function() folder:Destroy() end
	ev.pos = target
end

handlers.Blackout = function(ev)
	local folder = Instance.new("Folder") folder.Name = "Blackout" folder.Parent = workspace.WorldEvents
	local orig = Lighting.ClockTime
	TweenService:Create(Lighting, TweenInfo.new(3), {ClockTime = 0.5}):Play()
	local lamps = CollectionService:GetTagged("PlazaLight")
	for _, lamp in ipairs(lamps) do
		local b = lamp:FindFirstChild("Bulb")
		if b then b:SetAttribute("OrigColor", b.Color) b.Color = Color3.fromRGB(40, 40, 50) b.Material = Enum.Material.SmoothPlastic local pl = b:FindFirstChildOfClass("PointLight") if pl then pl.Enabled = false end end
	end
	for i = 1, 16 do
		local a = math.random() * math.pi * 2
		local r = math.random(10, 72)
		local coin = Instance.new("Part") coin.Shape = Enum.PartType.Cylinder coin.Size = Vector3.new(0.4, 2.4, 2.4) coin.Material = Enum.Material.Neon coin.Color = Color3.fromRGB(255, 210, 60)
		coin.Anchored = true coin.CanCollide = false coin.CFrame = CFrame.new(math.cos(a) * r, 2, math.sin(a) * r) * CFrame.Angles(0, a, math.rad(90))
		coin.Name = "GlowCoin" coin:SetAttribute("Spin", 2) coin:AddTag("SpinDecor") coin.Parent = folder
		local pl = Instance.new("PointLight") pl.Color = coin.Color pl.Range = 10 pl.Parent = coin
		coin.Touched:Connect(function(hit)
			local p = Players:GetPlayerFromCharacter(hit.Parent)
			if p and coin.Parent and S.Data.Get(p) then
				coin:Destroy()
				local reward = math.max(250, math.floor(S.Economy.TotalIncome(p, S.Data.Get(p)) * 20))
				S.Economy.AddCash(p, reward, true)
				Remotes.Effect:FireClient(p, "CashPop", coin.Position, reward)
			end
		end)
	end
	ev.cleanup = function()
		folder:Destroy()
		TweenService:Create(Lighting, TweenInfo.new(3), {ClockTime = orig}):Play()
		for _, lamp in ipairs(lamps) do
			local b = lamp:FindFirstChild("Bulb")
			if b and b:GetAttribute("OrigColor") then b.Color = b:GetAttribute("OrigColor") b.Material = Enum.Material.Neon local pl = b:FindFirstChildOfClass("PointLight") if pl then pl.Enabled = true end end
		end
	end
	ev.pos = Vector3.new(0, 0, 0)
end

handlers.Visitor = function(ev)
	local pool = {}
	for _, c in ipairs(Config.Creatures) do if c.rarity == "Legendary" or c.rarity == "Mythic" or c.rarity == "Epic" then table.insert(pool, c.id) end end
	local id = pool[math.random(1, #pool)]
	local pos = randomMeadow(130)
	local model = S.Creatures.SpawnEventCreature(CFrame.new(pos), id, false, "Visitor", "Visitor")
	local g = S.Creatures.AddEventGuardian("Visitor", "Persistent", pos + Vector3.new(6, 0, 6), "Cosmic")
	ev.desc = "A rare " .. Config.CreatureById[id].name .. " is visiting near the plaza! Steal it before it leaves!"
	ev.cleanup = function()
		for _, m in ipairs(workspace.ActiveCreatures:GetChildren()) do if m:GetAttribute("Territory") == "Visitor" then S.Creatures.RemoveEventCreature(m) end end
		S.Creatures.RemoveGuardian(g)
	end
	ev.pos = pos
end

function Ev.Run(id)
	if active then return false end
	local def
	for _, e in ipairs(Config.Events.list) do if e.id == id then def = e end end
	if not def then return false end
	local ev = {id = id, desc = def.desc}
	active = ev
	local ok, err = pcall(handlers[id], ev)
	if not ok then warn("[Events] failed to start", id, err) active = nil return false end
	ev.endT = workspace:GetServerTimeNow() + def.duration
	screen("⚡ " .. def.name .. " ⚡")
	sfx(workspace.Map.Plaza.Fountain.Spout, "Event", 1)
	Remotes.WorldEvent:FireAllClients({id = id, name = def.name, desc = ev.desc, endT = ev.endT, pos = ev.pos})
	task.delay(def.duration, function()
		if active == ev then
			pcall(ev.cleanup)
			active = nil
			screen("STEAL • ESCAPE • COLLECT • EARN • PROTECT")
			Remotes.WorldEvent:FireAllClients({id = "End", name = def.name})
		end
	end)
	return true
end

function Ev.Start()
	task.spawn(function()
		local last
		task.wait(90)
		while true do
			local list = Config.Events.list
			local pick
			repeat pick = list[math.random(1, #list)].id until pick ~= last or #list == 1
			last = pick
			Ev.Run(pick)
			task.wait(math.random(Config.Events.interval[1], Config.Events.interval[2]))
		end
	end)
	Players.PlayerAdded:Connect(function(p)
		task.wait(5)
		if active and p.Parent then
			for _, e in ipairs(Config.Events.list) do
				if e.id == active.id then Remotes.WorldEvent:FireClient(p, {id = e.id, name = e.name, desc = active.desc, endT = active.endT, pos = active.pos}) end
			end
		end
	end)
end

return Ev
