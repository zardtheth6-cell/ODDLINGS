-- Wild spawning, guardians AI, carrying, wild/player theft, base raids and atomic ownership transfer.
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Builder = require(game.ReplicatedStorage.Shared.CreatureBuilder)
local Remotes = game.ReplicatedStorage.Remotes
local C = {}
local S, Data

local points = {}      -- [territory] = {{part=, model=nil}}
local wild = {}        -- [model] = {id, golden, territory, point, state, eventTag}
local carried = {}     -- [player] = entry
local locked = {}      -- [uid] = raid
local raids = {}       -- [ownerPlayer] = raid
local guardians = {}   -- list
local snatchCD = {}    -- [player] = clock
local raidStamp = {}   -- [thief] = {last=, pairs={[ownerId]={times}}}
local defenseUntil = {}-- [owner] = os.time
local captureLock = {} -- [player] = true while being respawned

local function serverNow() return workspace:GetServerTimeNow() end
local function root(p) return S.Anti.Root(p) end
local function sound(parent, id, vol)
	local s = Instance.new("Sound") s.SoundId = Config.Sounds[id] s.Volume = vol or 0.7 s.RollOffMaxDistance = 100 s.Parent = parent s:Play()
	game:GetService("Debris"):AddItem(s, 5)
end

function C.Init(services) S = services Data = S.Data end
function C.IsLocked(uid) return uid ~= nil and locked[uid] ~= nil end
function C.IsBaseRaided(owner) return raids[owner] ~= nil end
function C.IsRaidThief(p, owner) local r = raids[owner] return r ~= nil and r.carrier == p end
function C.IsBusy(p) return carried[p] ~= nil or raids[p] ~= nil end
function C.CarryInfo(p)
	local e = carried[p] if not e then return nil end
	local def = Config.CreatureById[e.id]
	return {name = def.name, rarity = def.rarity, kind = e.kind, golden = e.golden}
end

-- Carry attach / release -------------------------------------------------------------
local function setArms(char, up)
	for _, pair in ipairs({{"RightUpperArm", "RightShoulder", 1}, {"LeftUpperArm", "LeftShoulder", -1}, {"Torso", "Right Shoulder", 1}, {"Torso", "Left Shoulder", -1}}) do
		local part = char:FindFirstChild(pair[1])
		local m = part and part:FindFirstChild(pair[2])
		if m and m:IsA("Motor6D") then
			if up then
				if not m:GetAttribute("OrigC0") then m:SetAttribute("OrigC0", m.C0) end
				local axis = pair[1] == "Torso" and CFrame.Angles(0, 0, pair[3] * math.rad(170)) or CFrame.Angles(math.rad(170), 0, 0)
				m.C0 = m:GetAttribute("OrigC0") * axis
			elseif m:GetAttribute("OrigC0") then
				m.C0 = m:GetAttribute("OrigC0")
			end
		end
	end
end

local function sendCarry(p)
	local e = carried[p]
	if not e then Remotes.CarryState:FireClient(p, nil) return end
	local def = Config.CreatureById[e.id]
	local plot = S.Bases.GetPlot(p)
	Remotes.CarryState:FireClient(p, {id = e.id, name = def.name, rarity = def.rarity, golden = e.golden, kind = e.kind,
		penalty = p:GetAttribute("CarryPenalty"), owner = e.owner and e.owner.DisplayName or nil,
		dest = plot and plot.DropZone.Position or nil, endT = e.raid and e.raid.endT or nil})
end

local function attach(p, entry)
	local char = p.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local model = entry.model
	local h = model:GetAttribute("Height") or 3
	local scale = math.min(1, 3.6 / h)
	if scale < 1 then model:ScaleTo(scale) end
	local rp = model.PrimaryPart
	for _, d in ipairs(model:GetDescendants()) do if d:IsA("BasePart") then d.Anchored = false d.Massless = true d.CanCollide = false d.CanQuery = false end end
	local info = model:FindFirstChild("Info") if info then info:Destroy() end
	for _, pp in ipairs(model:GetDescendants()) do if pp:IsA("ProximityPrompt") then pp:Destroy() end end
	model.Parent = char
	local w = Instance.new("Weld") w.Name = "CarryWeld" w.Part0 = hrp w.Part1 = rp
	w.C0 = CFrame.new(0, 2.9 + (h * scale) / 2, 0.4) w.Parent = rp
	rp:SetNetworkOwner(p)
	setArms(char, true)
	local def = Config.CreatureById[entry.id]
	local relief = p:GetAttribute("CarryRelief") or 0
	p:SetAttribute("CarryPenalty", Config.CarryPenalty[def.size] * (1 - relief))
	p:SetAttribute("Carrying", def.name)
	p:SetAttribute("CarryRarity", def.rarity)
	-- snatch prompt for other players
	local pp = Instance.new("ProximityPrompt") pp.Name = "SnatchPrompt" pp.ActionText = "Snatch" pp.ObjectText = def.name
	pp.HoldDuration = 0.35 pp.MaxActivationDistance = 9 pp.RequiresLineOfSight = false pp.KeyboardKeyCode = Enum.KeyCode.R pp.GamepadKeyCode = Enum.KeyCode.ButtonY
	pp:SetAttribute("NotOwner", p.UserId) pp.Parent = hrp
	pp.Triggered:Connect(function(snatcher) C.TrySnatch(snatcher, p) end)
	entry.carrier = p
	carried[p] = entry
	sendCarry(p)
	return true
end

local function release(p)
	local e = carried[p]
	if not e then return nil end
	carried[p] = nil
	if p.Character then
		setArms(p.Character, false)
		local hrp = p.Character:FindFirstChild("HumanoidRootPart")
		local pp = hrp and hrp:FindFirstChild("SnatchPrompt") if pp then pp:Destroy() end
	end
	p:SetAttribute("CarryPenalty", 0) p:SetAttribute("Carrying", nil) p:SetAttribute("CarryRarity", nil)
	if e.model and e.model.Parent then e.model:Destroy() end
	e.model = nil
	e.carrier = nil
	sendCarry(p)
	return e
end

-- Spawning -----------------------------------------------------------------------
local function rollCreature(territory, luck)
	local pool = {}
	for _, c in ipairs(Config.Creatures) do
		if table.find(c.territories, territory) then table.insert(pool, c) end
	end
	local total, weights = 0, {}
	for i, c in ipairs(pool) do
		local r = Config.RarityById[c.rarity]
		local w = r.weight * (1 + luck * (r.order - 1) / 3)
		weights[i] = w total += w
	end
	local x = math.random() * total
	for i, w in ipairs(weights) do x -= w if x <= 0 then return pool[i].id end end
	return pool[#pool].id
end

local function territoryLuck(territory)
	local best = 0
	for _, p in ipairs(Players:GetPlayers()) do
		local rt = root(p)
		if rt and C.TerritoryAt(rt.Position) == territory then best = math.max(best, S.Economy.Luck(p)) end
	end
	return best
end

function C.TerritoryAt(pos)
	if pos.X < -250 and pos.Y > 35 then return "Cosmic" end
	if (Vector3.new(pos.X, 0, pos.Z) - Vector3.new(0, 0, -330)).Magnitude < 165 then return "Mushroom" end
	if (Vector3.new(pos.X, 0, pos.Z) - Vector3.new(330, 0, 0)).Magnitude < 165 then return "Frostbite" end
	if (Vector3.new(pos.X, 0, pos.Z) - Vector3.new(0, 0, 330)).Magnitude < 165 then return "Molten" end
	if (Vector3.new(pos.X, 0, pos.Z)).Magnitude < 80 then return "Plaza" end
	return nil
end

local function makeWild(id, golden, cf, territory)
	local model = Builder.BuildCreature(id, {golden = golden})
	model:PivotTo(cf)
	model:SetAttribute("Wild", true)
	model:SetAttribute("Territory", territory)
	local def = Config.CreatureById[id]
	S.Bases.Billboard(model, def, def.income * (golden and Config.GoldenIncomeMult or 1), golden)
	local pp = Instance.new("ProximityPrompt") pp.Name = "StealPrompt" pp.ActionText = "Steal" pp.ObjectText = (golden and "Golden " or "") .. def.name
	pp.HoldDuration = 0.6 pp.MaxActivationDistance = 11 pp.RequiresLineOfSight = false pp.Parent = model.PrimaryPart
	pp.Triggered:Connect(function(p) C.TryWildSteal(p, model) end)
	model.Parent = workspace.ActiveCreatures
	return model
end

function C.SpawnAtPoint(territory, pt, opts)
	opts = opts or {}
	local id = opts.id or rollCreature(territory, territoryLuck(territory))
	local cf = CFrame.new(pt.part.Position + Vector3.new(0, -0.4, 0)) * CFrame.Angles(0, math.random() * math.pi * 2, 0)
	local model = makeWild(id, opts.golden, cf, territory)
	pt.model = model
	wild[model] = {id = id, golden = opts.golden, territory = territory, point = pt, state = "idle", eventTag = opts.eventTag}
	return model
end

function C.SpawnEventCreature(cf, id, golden, tag, territoryForGuardian)
	local model = makeWild(id, golden, cf, territoryForGuardian or "Event")
	wild[model] = {id = id, golden = golden, territory = territoryForGuardian or "Event", point = nil, state = "idle", eventTag = tag, home = cf}
	return model
end
function C.RemoveEventCreature(model)
	local w = wild[model]
	if w and w.state == "idle" then wild[model] = nil model:Destroy() end
end

function C.RollCreature(t, luck) return rollCreature(t, luck or 0) end
function C.FreePoint(territory)
	local free = {}
	for _, pt in ipairs(points[territory] or {}) do if not pt.model and not pt.pending then table.insert(free, pt) end end
	if #free == 0 then return nil end
	return free[math.random(1, #free)]
end

local function scheduleRespawn(pt, territory)
	if not pt then return end
	pt.pending = true
	task.delay(math.random(6, 12), function()
		pt.pending = nil
		if not pt.model then C.SpawnAtPoint(territory, pt) end
	end)
end

-- Returns a carried wild creature to where it came from.
local function returnWild(entry)
	if entry.point then
		local pt = entry.point
		local cf = CFrame.new(pt.part.Position + Vector3.new(0, -0.4, 0)) * CFrame.Angles(0, math.random() * 6.28, 0)
		local model = makeWild(entry.id, entry.golden, cf, entry.territory)
		pt.model = model
		wild[model] = {id = entry.id, golden = entry.golden, territory = entry.territory, point = pt, state = "idle", eventTag = entry.eventTag}
	elseif entry.home and entry.eventTag and S.Events.IsActive(entry.eventTag) then
		C.SpawnEventCreature(entry.home, entry.id, entry.golden, entry.eventTag, entry.territory)
	end
	sound(workspace.ActiveCreatures, "Return", 0.4)
end

-- Guardians -------------------------------------------------------------------------
local function makeGuardian(territory, gtype, home, theme)
	local m = Builder.BuildGuardian(theme or territory, gtype)
	local rp = m.PrimaryPart
	rp.Name = "HumanoidRootPart"
	rp.Anchored = false rp.CanCollide = false rp.Massless = false
	local hum = Instance.new("Humanoid")
	hum.HipHeight = 0.6
	hum.WalkSpeed = Config.GuardianTypes[gtype].speed
	hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
	hum.BreakJointsOnDeath = false
	hum.RequiresNeck = false
	hum.MaxHealth = math.huge hum.Health = math.huge
	hum.Parent = m
	m:PivotTo(CFrame.new(home + Vector3.new(0, 1, 0)))
	m.Parent = workspace.ActiveGuardians
	rp:SetNetworkOwner(nil)
	local g = {model = m, hum = hum, root = rp, type = gtype, cfg = Config.GuardianTypes[gtype], territory = territory, home = home, state = "Idle", nextWander = 0, wanderRadius = (territory == "Cosmic") and 10 or 22}
	m:SetAttribute("State", "Idle")
	table.insert(guardians, g)
	return g
end
function C.AddEventGuardian(territory, gtype, home, theme) return makeGuardian(territory, gtype, home, theme) end
function C.RemoveGuardian(g)
	local i = table.find(guardians, g) if i then table.remove(guardians, i) end
	if g.model then g.model:Destroy() end
end

local groundParams = RaycastParams.new()
groundParams.FilterType = Enum.RaycastFilterType.Include
groundParams.FilterDescendantsInstances = {workspace.Terrain, workspace.Map}

local function setState(g, st)
	if g.state ~= st then
		g.state = st
		g.model:SetAttribute("State", st)
		if st == "Chase" or st == "Alert" then sound(g.root, "Guardian", 0.9) end
	end
end

local function alertGuardian(entry, p)
	local best, bd
	for _, g in ipairs(guardians) do
		if g.territory == entry.territory then
			local rt = root(p)
			local d = rt and (g.root.Position - rt.Position).Magnitude or math.huge
			if d < (bd or math.huge) then best, bd = g, d end
		end
	end
	if best and bd < best.cfg.detect * 2 and best.state ~= "Chase" then
		best.target = p
		best.chaseStart = os.clock()
		if best.cfg.windup then setState(best, "Alert") best.windupUntil = os.clock() + best.cfg.windup else setState(best, "Chase") end
	end
end

-- Capture ------------------------------------------------------------------------
function C.Capture(p, g)
	if captureLock[p] then return end
	local entry = carried[p]
	if not entry then return end
	local data = Data.Get(p)
	if data and (data.boosts.escape or 0) > os.time() then
		data.boosts.escape = nil
		S.Economy.ApplyStats(p)
		S.Notify(p, "🛡️ Your Escape Shield blocked the capture!", "shield", "Shield")
		if g then setState(g, "Return") g.target = nil end
		Data.Sync(p)
		return
	end
	captureLock[p] = true
	local rt = root(p)
	Remotes.Effect:FireAllClients("Capture", rt and rt.Position, p.UserId)
	C.DropCarried(p, "caught")
	if data then data.stats.captures += 1 end
	if g then setState(g, "Return") g.target = nil end
	S.Notify(p, "😵 Caught by a Guardian! The Oddling ran home. You keep everything else.", "fail", "Capture")
	p:SetAttribute("StunUntil", serverNow() + Config.CaptureRespawnDelay)
	task.delay(Config.CaptureRespawnDelay, function()
		captureLock[p] = nil
		if p.Parent then
			S.Anti.Teleport(p, S.Bases.SpawnCFrame(p))
			p:SetAttribute("SpawnShieldUntil", serverNow() + Config.SpawnShieldTime)
		end
	end)
end

-- Drops whatever the player carries and sends it back to its rightful owner/source.
function C.DropCarried(p, reason)
	local entry = carried[p]
	if not entry then return false end
	if entry.kind == "raid" then
		C.FailRaid(entry.raid, reason)
	else
		release(p)
		returnWild(entry)
	end
	return true
end

-- Wild theft --------------------------------------------------------------------------
function C.TryWildSteal(p, model)
	local w = wild[model]
	if not w or w.state ~= "idle" then return end
	if carried[p] or captureLock[p] then return end
	if not Data.IsLoaded(p) then return end
	if (p:GetAttribute("StunUntil") or 0) > serverNow() then return end
	local rt = root(p)
	if not rt or (rt.Position - model.PrimaryPart.Position).Magnitude > 14 then return end
	local data = Data.Get(p)
	if Config.TerritoryById[w.territory] and not data.territories[w.territory] then
		S.Notify(p, "🔒 Unlock " .. Config.TerritoryById[w.territory].name .. " first!", "warn", "Fail") return
	end
	w.state = "carried"
	wild[model] = nil
	if w.point then w.point.model = nil end
	local entry = {kind = "wild", id = w.id, golden = w.golden, territory = w.territory, point = w.point, model = model, eventTag = w.eventTag, home = w.home}
	if not attach(p, entry) then
		w.state = "idle" wild[model] = w if w.point then w.point.model = model end return
	end
	sound(model.PrimaryPart, "Pickup", 0.8)
	Remotes.Effect:FireAllClients("Pickup", model.PrimaryPart.Position, p.UserId, w.id)
	S.Economy.Discover(p, w.id)
	data.stats.steals += 1
	S.Notify(p, "🏃 You grabbed " .. Config.CreatureById[w.id].name .. "! Run to your base!", "carry", "Pickup")
	alertGuardian(entry, p)
	S.Events.OnSteal(p, entry)
end

-- Player-to-player snatch -------------------------------------------------------------
function C.TrySnatch(snatcher, victim)
	if snatcher == victim then return end
	local entry = carried[victim]
	if not entry or carried[snatcher] or captureLock[snatcher] or captureLock[victim] then return end
	if not Data.IsLoaded(snatcher) then return end
	local nowC = os.clock()
	if (snatchCD[snatcher] or 0) > nowC then S.Notify(snatcher, "⏳ Snatch on cooldown", "warn") return end
	if (entry.protectedUntil or 0) > nowC then S.Notify(snatcher, "🛡️ Too soon - they just grabbed it!", "warn") return end
	if (snatcher:GetAttribute("StunUntil") or 0) > serverNow() then return end
	local a, b = root(snatcher), root(victim)
	if not a or not b or (a.Position - b.Position).Magnitude > 11 then return end
	if S.Anti.InSafeZone(b.Position) then S.Notify(snatcher, "🕊️ No stealing in the plaza safe zone", "warn") return end
	snatchCD[snatcher] = nowC + 4
	-- owner recovering their own creature ends the raid immediately
	if entry.kind == "raid" and entry.owner == snatcher then
		C.FailRaid(entry.raid, "recovered")
		return
	end
	local id, golden = entry.id, entry.golden
	release(victim) -- destroys old model
	entry.model = Builder.BuildCreature(id, {golden = golden})
	entry.protectedUntil = nowC + 3
	if not attach(snatcher, entry) then
		-- failed to attach: return to source safely
		if entry.kind == "raid" then C.FailRaid(entry.raid, "error") else returnWild(entry) end
		return
	end
	if entry.raid then entry.raid.carrier = snatcher end
	Remotes.Effect:FireAllClients("Snatch", b.Position, snatcher.UserId, victim.UserId)
	S.Notify(victim, "😱 " .. snatcher.DisplayName .. " snatched your Oddling!", "fail", "Fail")
	S.Notify(snatcher, "😈 You snatched " .. Config.CreatureById[id].name .. "!", "carry", "Pickup")
	if entry.kind == "wild" then alertGuardian(entry, snatcher) end
	if entry.raid then
		Remotes.Raid:FireClient(snatcher, {role = "raider", owner = entry.owner.DisplayName, creature = Config.CreatureById[id].name, endT = entry.raid.endT})
		Remotes.Raid:FireClient(victim, {role = "none"})
	end
end

-- Raids --------------------------------------------------------------------------------
function C.CanRaid(thief, owner)
	if thief == owner then return false, "That's your base!" end
	local td, od = Data.Get(thief), Data.Get(owner)
	if not td or not od then return false, "That base is still loading" end
	if not S.Bases.GetPlot(owner) then return false, "No base" end
	if S.Bases.IsShielded(owner) then return false, "🛡️ This base is shielded!" end
	if raids[owner] then return false, "This base is already being raided" end
	local R = Config.Raid
	local t = os.time()
	if (os.time() - (owner:GetAttribute("JoinTime") or 0)) < 20 then return false, "That player just arrived" end
	if (t - od.firstJoin < R.beginnerSeconds and #od.creatures < R.beginnerCreatures) or (#od.creatures < R.beginnerCreatures and od.level < 3) then
		return false, "🐣 This player has beginner protection"
	end
	if (defenseUntil[owner] or 0) > t then return false, ("🛡️ Base protected after a defense (%ds)"):format(defenseUntil[owner] - t) end
	local st = raidStamp[thief]
	if st then
		if st.last and t - st.last < R.thiefCooldown then return false, ("⏳ Raid cooldown (%ds)"):format(R.thiefCooldown - (t - st.last)) end
		local hist = st.pairs[owner.UserId]
		if hist then
			local recent = 0
			for _, ts in ipairs(hist) do if t - ts < R.repeatWindow then recent += 1 end end
			local last = hist[#hist]
			if recent >= R.repeatLimit and t - last < R.repeatLockout then return false, "⏳ You've raided this player too often. Try someone else!" end
			if last and t - last < R.sameTargetCooldown then return false, ("⏳ Wait %ds before raiding this player again"):format(R.sameTargetCooldown - (t - last)) end
		end
	end
	return true
end

function C.TryRaidSteal(thief, owner, uid)
	if carried[thief] or captureLock[thief] then return end
	if not owner.Parent then return end
	local ok, why = C.CanRaid(thief, owner)
	if not ok then S.Notify(thief, why, "warn", "Fail") return end
	if locked[uid] then return end
	local od = Data.Get(owner)
	local rec
	for _, c in ipairs(od.creatures) do if c.u == uid then rec = c break end end
	if not rec then return end
	local plot = S.Bases.GetPlot(owner)
	local rt = root(thief)
	local disp = S.Bases.GetDisplayModel(owner, uid)
	if not rt or not disp or (rt.Position - disp.PrimaryPart.Position).Magnitude > 13 or not S.Bases.InPlot(plot, rt.Position) then return end
	if (thief:GetAttribute("StunUntil") or 0) > serverNow() then return end
	local raid = {owner = owner, ownerId = owner.UserId, uid = uid, id = rec.id, golden = rec.g, startedBy = thief, endT = serverNow() + Config.Raid.window}
	locked[uid] = raid
	raids[owner] = raid
	local entry = {kind = "raid", id = rec.id, golden = rec.g, uid = uid, owner = owner, raid = raid, model = Builder.BuildCreature(rec.id, {golden = rec.g})}
	raid.entry = entry
	S.Bases.RefreshDisplay(owner)
	if not attach(thief, entry) then locked[uid] = nil raids[owner] = nil S.Bases.RefreshDisplay(owner) return end
	raid.carrier = thief
	local t = os.time()
	raidStamp[thief] = raidStamp[thief] or {pairs = {}}
	raidStamp[thief].last = t
	raidStamp[thief].pairs[owner.UserId] = raidStamp[thief].pairs[owner.UserId] or {}
	table.insert(raidStamp[thief].pairs[owner.UserId], t)
	local name = Config.CreatureById[rec.id].name
	S.Bases.TriggerAlarm(plot, thief, "raid")
	S.Notify(owner, "🚨 YOUR BASE IS BEING RAIDED! " .. thief.DisplayName .. " took " .. name .. "!", "raid", "Alarm")
	S.Notify(thief, "🏴 RAID! Get " .. name .. " to your base before time runs out!", "raid", "Pickup")
	Remotes.Raid:FireClient(owner, {role = "defender", thief = thief.DisplayName, thiefId = thief.UserId, creature = name, endT = raid.endT})
	Remotes.Raid:FireClient(thief, {role = "raider", owner = owner.DisplayName, creature = name, endT = raid.endT})
	S.Data.Sync(owner)
end

local function endRaidUI(raid)
	if raid.owner.Parent then Remotes.Raid:FireClient(raid.owner, {role = "none"}) end
	if raid.carrier and raid.carrier.Parent then Remotes.Raid:FireClient(raid.carrier, {role = "none"}) end
	if raid.startedBy and raid.startedBy.Parent and raid.startedBy ~= raid.carrier then Remotes.Raid:FireClient(raid.startedBy, {role = "none"}) end
end

function C.FailRaid(raid, reason)
	if not raid or raid.done then return end
	raid.done = true
	local carrier = raid.carrier
	if carrier and carried[carrier] and carried[carrier].raid == raid then release(carrier) end
	locked[raid.uid] = nil
	if raids[raid.owner] == raid then raids[raid.owner] = nil end
	endRaidUI(raid)
	local owner = raid.owner
	local name = Config.CreatureById[raid.id].name
	if owner.Parent then
		S.Bases.RefreshDisplay(owner)
		if reason ~= "owner left" and reason ~= "shutdown" then
			local od = Data.Get(owner)
			if od then od.stats.raidsDefended += 1 end
			defenseUntil[owner] = os.time() + Config.Raid.defenseProtection
			S.Notify(owner, "🛡️ RAID DEFENDED! " .. name .. " is back home.", "success", "Success")
			S.Economy.CheckTitles(owner)
			Data.Sync(owner)
		end
	end
	if carrier and carrier.Parent then
		local msg = ({timeout = "⏰ Time's up! The raid failed.", bat = "💥 You got bonked! The raid failed.", caught = "😵 Caught! The raid failed.", recovered = "😤 The owner took it back!"})[reason] or "The raid failed."
		S.Notify(carrier, msg, "fail", "Fail")
		if reason == "timeout" then S.Anti.Teleport(carrier, S.Bases.SpawnCFrame(carrier)) end
	end
end

local function freeSlot(data, cap)
	local used = {}
	for _, c in ipairs(data.creatures) do if c.s then used[c.s] = true end end
	for i = 1, cap do if not used[i] then return i end end
	return nil
end

-- Atomic (single-threaded, no yields) ownership transfer, then persistence.
function C.SucceedRaid(raid, carrier)
	local owner = raid.owner
	local od, cd = Data.Get(owner), Data.Get(carrier)
	if not od or not cd then C.FailRaid(raid, "error") return end
	local cap = S.Economy.Capacity(carrier, cd)
	local slot = freeSlot(cd, cap)
	if not slot or #cd.creatures >= cap then
		S.Notify(carrier, "📦 Your base is full! Sell or expand to keep it.", "warn", "Fail") return
	end
	local idx
	for i, c in ipairs(od.creatures) do if c.u == raid.uid then idx = i break end end
	if not idx then C.FailRaid(raid, "error") return end
	-- transfer (no yields between remove and insert)
	local rec = table.remove(od.creatures, idx)
	rec.s = slot
	table.insert(cd.creatures, rec)
	raid.done = true
	locked[raid.uid] = nil
	raids[owner] = nil
	release(carrier)
	endRaidUI(raid)
	local def = Config.CreatureById[rec.id]
	cd.stats.raidsWon += 1
	if Config.RarityById[def.rarity].order >= 3 then cd.stats.rares += 1 end
	S.Economy.MarkCollected(carrier, rec.id)
	S.Economy.AddXP(carrier, 100 + Config.RarityById[def.rarity].xp)
	S.Bases.RefreshDisplay(owner)
	S.Bases.RefreshDisplay(carrier)
	S.Notify(carrier, "🏆 RAID SUCCESS! " .. def.name .. " is now yours!", "success", "Success")
	S.Notify(owner, "💔 " .. carrier.DisplayName .. " stole your " .. def.name .. ".", "fail", "Fail")
	Remotes.Effect:FireAllClients("Deliver", S.Bases.GetPlot(carrier).DropZone.Position, carrier.UserId, rec.id)
	S.Economy.CheckTitles(carrier)
	Data.Sync(owner) Data.Sync(carrier)
	-- persist: remove from the victim first so a crash can never duplicate the creature
	task.spawn(function() Data.Save(owner, false) Data.Save(carrier, false) end)
end

-- Delivery ---------------------------------------------------------------------------------
function C.Deliver(p)
	local entry = carried[p]
	if not entry then return end
	if entry.kind == "raid" then C.SucceedRaid(entry.raid, p) return end
	local data = Data.Get(p)
	local cap = S.Economy.Capacity(p, data)
	local slot = freeSlot(data, cap)
	if not slot or #data.creatures >= cap then
		if (entry.fullWarn or 0) < os.clock() then entry.fullWarn = os.clock() + 4 S.Notify(p, "📦 Your base is full! Sell an Oddling or expand your base.", "warn", "Fail") end
		return
	end
	release(p)
	local rec = {u = HttpService:GenerateGUID(false), id = entry.id, g = entry.golden or nil, s = slot}
	table.insert(data.creatures, rec)
	local def = Config.CreatureById[entry.id]
	if Config.RarityById[def.rarity].order >= 3 then data.stats.rares += 1 end
	S.Economy.MarkCollected(p, entry.id)
	S.Economy.AddXP(p, Config.RarityById[def.rarity].xp)
	S.Bases.RefreshDisplay(p)
	S.Notify(p, ("✅ %s%s added to your base! +$%s/s"):format(entry.golden and "Golden " or "", def.name, Config.FormatNumber(S.Economy.CreatureIncome(rec) * S.Economy.IncomeMultiplier(p, data))), "success", "Success")
	Remotes.Effect:FireAllClients("Deliver", S.Bases.GetPlot(p).DropZone.Position, p.UserId, entry.id)
	if entry.point then scheduleRespawn(entry.point, entry.territory) end
	S.Economy.CheckTitles(p)
	Data.Sync(p)
end

-- Lifecycle -----------------------------------------------------------------------------
function C.OnPlayerLeaving(p)
	if carried[p] then C.DropCarried(p, "disconnect") end
	if raids[p] then C.FailRaid(raids[p], "owner left") end
	snatchCD[p] = nil captureLock[p] = nil defenseUntil[p] = nil
end
function C.OnCharacterRemoving(p) if carried[p] then C.DropCarried(p, "died") end end
function C.ForSave(p, data) return data end
function C.ShutdownAll()
	for p, _ in pairs(carried) do pcall(C.DropCarried, p, "shutdown") end
	for _, r in pairs(raids) do pcall(C.FailRaid, r, "shutdown") end
end

function C.Start()
	-- spawn points
	for _, sp in ipairs(workspace.CreatureSpawns:GetChildren()) do
		local t = sp:GetAttribute("Territory")
		points[t] = points[t] or {}
		table.insert(points[t], {part = sp})
	end
	for _, t in ipairs(Config.Territories) do
		local list = points[t.id] or {}
		for i = 1, math.min(t.maxActive, #list) do
			local pt = C.FreePoint(t.id) if pt then C.SpawnAtPoint(t.id, pt) end
		end
		-- guardians: spread homes across the spawn points
		local layout = Config.GuardianLayout[t.id]
		for i, gtype in ipairs(layout) do
			local pt = list[math.floor((i - 1) * #list / #layout) + 1]
			if pt then makeGuardian(t.id, gtype, pt.part.Position + Vector3.new(6, 0, 6)) end
		end
	end
	-- top up territories periodically
	task.spawn(function()
		while true do
			task.wait(5)
			for _, t in ipairs(Config.Territories) do
				local active = 0
				for _, pt in ipairs(points[t.id] or {}) do if pt.model or pt.pending then active += 1 end end
				for _ = active + 1, t.maxActive do
					local pt = C.FreePoint(t.id)
					if pt then C.SpawnAtPoint(t.id, pt) end
				end
			end
		end
	end)
	-- Guardian AI (central loop, 10 Hz)
	task.spawn(function()
		while true do
			task.wait(0.1)
			local nowC = os.clock()
			for _, g in ipairs(guardians) do
				local gp = g.root.Position
				if gp.Y < g.home.Y - 25 then g.model:PivotTo(CFrame.new(g.home + Vector3.new(0, 4, 0))) g.root.AssemblyLinearVelocity = Vector3.zero setState(g, "Idle") g.target = nil end
				if g.state == "Idle" then
					-- detection
					local best, bd
					for p, e in pairs(carried) do
						local rt = root(p)
						if rt and (e.territory == g.territory or C.TerritoryAt(rt.Position) == g.territory) and e.kind == "wild" then
							local d = (rt.Position - gp).Magnitude
							if d < g.cfg.detect and d < (bd or math.huge) and not captureLock[p] then best, bd = p, d end
						end
					end
					if best then
						g.target = best g.chaseStart = nowC
						if g.cfg.windup then setState(g, "Alert") g.windupUntil = nowC + g.cfg.windup else setState(g, "Chase") end
					elseif nowC > g.nextWander then
						g.nextWander = nowC + math.random(4, 7)
						local a = math.random() * math.pi * 2
						local target = g.home + Vector3.new(math.cos(a), 0, math.sin(a)) * math.random(6, g.wanderRadius or 22)
						local hit = workspace:Raycast(target + Vector3.new(0, 30, 0), Vector3.new(0, -60, 0), groundParams)
						if hit and math.abs(hit.Position.Y - g.home.Y) < 8 and hit.Material ~= Enum.Material.Water and hit.Material ~= Enum.Material.CrackedLava then
							g.hum.WalkSpeed = g.cfg.speed * 0.45
							g.hum:MoveTo(hit.Position)
						end
					end
				elseif g.state == "Alert" then
					g.hum:MoveTo(gp)
					if nowC >= (g.windupUntil or 0) then setState(g, "Chase") g.chaseStart = nowC end
				elseif g.state == "Chase" then
					local p = g.target
					local rt = p and root(p)
					if not rt or not carried[p] or captureLock[p] then
						setState(g, "Return") g.target = nil
					else
						g.hum.WalkSpeed = g.cfg.speed
						g.hum:MoveTo(rt.Position)
						local d = (rt.Position - gp).Magnitude
						if d <= g.cfg.capture + 1.5 then
							C.Capture(p, g)
						elseif (gp - g.home).Magnitude > g.cfg.leash or nowC - g.chaseStart > g.cfg.chaseTime or S.Anti.InSafeZone(rt.Position) then
							setState(g, "Return") g.target = nil
						end
					end
				elseif g.state == "Return" then
					g.hum.WalkSpeed = g.cfg.speed * 0.8
					g.hum:MoveTo(g.home)
					if (gp - g.home).Magnitude < 8 then setState(g, "Idle") end
				end
			end
		end
	end)
	-- Delivery + raid timers + territory enforcement (5 Hz)
	task.spawn(function()
		while true do
			task.wait(0.2)
			local t = serverNow()
			for p, e in pairs(carried) do
				local rt = root(p)
				local plot = S.Bases.GetPlot(p)
				if rt and plot then
					local dz = plot.DropZone.Position
					if Vector3.new(rt.Position.X - dz.X, 0, rt.Position.Z - dz.Z).Magnitude < 7.5 and math.abs(rt.Position.Y - dz.Y) < 8 then C.Deliver(p) end
				end
			end
			for _, r in pairs(raids) do
				if not r.done and t >= r.endT then C.FailRaid(r, "timeout") end
			end
		end
	end)
end

return C
