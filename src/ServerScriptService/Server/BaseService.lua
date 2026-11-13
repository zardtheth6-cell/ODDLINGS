-- Plot assignment, creature displays, and all base security (door, alarm, lasers, shield, detection).
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Builder = require(game.ReplicatedStorage.Shared.CreatureBuilder)
local Remotes = game.ReplicatedStorage.Remotes
local B = {}
local S, Data
local plotOf = {}          -- [player] = plot model
local ownerOf = {}         -- [plot] = player
local displays = {}        -- [player] = {[uid] = model}
local shield = {}          -- [player] = {untilT, readyAt}
local intruders = {}       -- [plot] = {[player] = enteredAt}
local laserHit = {}        -- [player] = {[plot] = lastHit}
local doorOpenUntil = {}   -- [plot] = t
local alarmUntil = {}      -- [plot] = t
local SEC = Config.Security

function B.Init(services) S = services Data = S.Data end

local function sign(part, text)
	local sg = part:FindFirstChildOfClass("SurfaceGui")
	if sg then local l = sg:FindFirstChild("Label", true) if l then l.Text = text end end
end
local function playSound(parent, id, vol, speed)
	local s = Instance.new("Sound") s.SoundId = Config.Sounds[id] s.Volume = vol or 0.6 s.PlaybackSpeed = speed or 1 s.RollOffMaxDistance = 120 s.Parent = parent
	s:Play() game:GetService("Debris"):AddItem(s, 6)
end

function B.GetPlot(player) return plotOf[player] end
function B.OwnerOfPlot(plot) return ownerOf[plot] end
function B.ShieldUntil(player) local s = shield[player] return s and s.untilT or 0 end
function B.ShieldReadyAt(player) local s = shield[player] return s and s.readyAt or 0 end
function B.IsShielded(player) return B.ShieldUntil(player) > os.time() end
function B.LocalPos(plot, pos) return plot.Floor.CFrame:PointToObjectSpace(pos) end
function B.InPlot(plot, pos, extra)
	local lp = B.LocalPos(plot, pos)
	local r = 43 + (extra or 0)
	return math.abs(lp.X) <= r and math.abs(lp.Z) <= r and lp.Y > -5 and lp.Y < 40
end
function B.PlotAt(pos) for _, p in ipairs(workspace.Bases:GetChildren()) do if B.InPlot(p, pos) then return p end end end
function B.SpawnCFrame(player)
	local plot = plotOf[player]
	if plot then return plot.SpawnPad.CFrame * CFrame.new(0, 3.5, 0) end
	return CFrame.new(0, 5, 40)
end
function B.OutsideDoorCFrame(plot) return plot.Floor.CFrame * CFrame.new(0, 4, -50) * CFrame.Angles(0, math.pi, 0) end

-- Security visuals --------------------------------------------------------------
local function doorVisual(plot, level)
	local door = plot.Door
	local f = plot:FindFirstChild("DoorDecor") if f then f:Destroy() end
	f = Instance.new("Folder") f.Name = "DoorDecor" f.Parent = plot
	local styles = {
		{mat = "WoodPlanks", col = Color3.fromRGB(150, 100, 60), tr = 0},
		{mat = "Metal", col = Color3.fromRGB(150, 155, 165), tr = 0},
		{mat = "DiamondPlate", col = Color3.fromRGB(80, 85, 95), tr = 0},
		{mat = "SmoothPlastic", col = Color3.fromRGB(235, 240, 250), tr = 0},
		{mat = "ForceField", col = Color3.fromRGB(80, 220, 255), tr = 0.15},
	}
	local st = styles[level]
	door.Material = Enum.Material[st.mat] door.Color = st.col door.Transparency = st.tr door:SetAttribute("BaseTransparency", st.tr)
	local function deco(size, offset, col, mat)
		local p = Instance.new("Part") p.Anchored = true p.CanCollide = false p.CanQuery = false p.Size = size p.CFrame = door.CFrame * offset
		p.Color = col p.Material = Enum.Material[mat] p.Parent = f return p
	end
	if level == 2 then for i = -1, 1 do deco(Vector3.new(12.2, 0.6, 1.6), CFrame.new(0, i * 3.5, 0), Color3.fromRGB(90, 95, 105), "Metal") end end
	if level == 3 then
		deco(Vector3.new(13, 12.4, 0.4), CFrame.new(0, 0, -0.9), Color3.fromRGB(60, 65, 75), "DiamondPlate")
		deco(Vector3.new(2.5, 2.5, 0.5), CFrame.new(0, 0, -1.2), Color3.fromRGB(200, 180, 60), "Metal")
	end
	if level == 4 then
		for i = -1, 1, 2 do deco(Vector3.new(0.4, 12, 1.6), CFrame.new(i * 3, 0, 0), Color3.fromRGB(60, 200, 255), "Neon") end
		deco(Vector3.new(2, 1, 0.3), CFrame.new(0, 4, -0.9), Color3.fromRGB(255, 60, 60), "Neon")
	end
	if level == 5 then
		for i = -5, 5, 2 do deco(Vector3.new(0.25, 12, 0.25), CFrame.new(i, 0, 0), Color3.fromRGB(150, 240, 255), "Neon") end
		local l = Instance.new("PointLight") l.Color = Color3.fromRGB(80, 220, 255) l.Range = 18 l.Parent = door
	else
		local l = door:FindFirstChildOfClass("PointLight") if l then l:Destroy() end
	end
	plot.DoorOuter:SetAttribute("BreachTime", SEC.Door.breach[level])
	local bp = plot.DoorOuter:FindFirstChild("Breach")
	if bp then bp.HoldDuration = SEC.Door.breach[level] bp.ObjectText = SEC.Door.names[level] end
end

local function laserVisual(plot, level)
	local beams = (level > 0) and SEC.Laser.beams[level] or 0
	for _, p in ipairs(plot.Lasers:GetChildren()) do
		if p.Name == "Emitter" then p.Transparency = beams > 0 and 0 or 1 end
		local i = p:GetAttribute("LaserIndex")
		if i then p:SetAttribute("Installed", i <= beams) p.Transparency = i <= beams and 0.2 or 1 end
	end
end

local function applyUpgradeDecor(plot, levels)
	local f = plot:FindFirstChild("UpgradeDecor")
	if not f then return end
	for _, p in ipairs(f:GetChildren()) do
		if p:IsA("BasePart") then
			local on = (levels[p:GetAttribute("Cat")] or 0) >= (p:GetAttribute("Lvl") or 99)
			p.Transparency = on and (p:GetAttribute("BaseT") or 0) or 1
		end
	end
end
B.ApplyUpgradeDecor = applyUpgradeDecor

function B.ApplySecurity(player)
	local plot, data = plotOf[player], Data.Get(player)
	if not plot or not data then return end
	doorVisual(plot, data.security.Door)
	laserVisual(plot, data.security.Laser)
	plot:SetAttribute("AlarmLevel", data.security.Alarm)
	plot:SetAttribute("DetectLevel", data.security.Detect)
	plot:SetAttribute("ShieldLevel", data.security.Shield)
	local lv = table.clone(data.security) lv.Rebirth = data.rebirths
	applyUpgradeDecor(plot, lv)
	plot.ConsoleScreen.Color = data.security.Shield > 0 and Color3.fromRGB(80, 255, 160) or Color3.fromRGB(80, 200, 255)
end

-- Displays ---------------------------------------------------------------
local function billboard(model, def, income, golden)
	local r = Config.RarityById[def.rarity]
	local bb = Instance.new("BillboardGui") bb.Name = "Info" bb.Size = UDim2.fromOffset(160, 60) bb.StudsOffsetWorldSpace = Vector3.new(0, model:GetAttribute("Height") + 1.5, 0)
	bb.MaxDistance = 55 bb.Adornee = model.PrimaryPart bb.LightInfluence = 0
	local n = Instance.new("TextLabel") n.BackgroundTransparency = 1 n.Size = UDim2.new(1, 0, 0.4, 0) n.Font = Enum.Font.FredokaOne n.TextScaled = true
	n.Text = (golden and "✨ Golden " or "") .. def.name n.TextColor3 = golden and Color3.fromRGB(255, 215, 60) or Color3.new(1, 1, 1) n.TextStrokeTransparency = 0.2 n.Parent = bb
	local rr = Instance.new("TextLabel") rr.BackgroundTransparency = 1 rr.Size = UDim2.new(1, 0, 0.3, 0) rr.Position = UDim2.fromScale(0, 0.4) rr.Font = Enum.Font.GothamBlack rr.TextScaled = true
	rr.Text = r.label rr.TextColor3 = r.color rr.TextStrokeTransparency = 0.3 rr.Parent = bb
	local inc = Instance.new("TextLabel") inc.Name = "Income" inc.BackgroundTransparency = 1 inc.Size = UDim2.new(1, 0, 0.3, 0) inc.Position = UDim2.fromScale(0, 0.7) inc.Font = Enum.Font.GothamBold inc.TextScaled = true
	inc.Text = "$" .. Config.FormatNumber(income) .. "/s" inc.TextColor3 = Color3.fromRGB(120, 255, 140) inc.TextStrokeTransparency = 0.3 inc.Parent = bb
	bb.Parent = model
	return bb
end
B.Billboard = billboard

function B.RefreshSlots(player)
	local plot, data = plotOf[player], Data.Get(player)
	if not plot or not data then return end
	local cap = S.Economy.Capacity(player, data)
	local col = plot:GetAttribute("Color")
	for _, s in ipairs(plot.Slots:GetChildren()) do
		local i = s:GetAttribute("Slot")
		local top = s.Top
		if i <= cap then top.Color = col top.Material = Enum.Material.Neon top.Transparency = 0.4
		else top.Color = Color3.fromRGB(60, 60, 70) top.Material = Enum.Material.SmoothPlastic top.Transparency = 0.2 end
		s:SetAttribute("Unlocked", i <= cap)
	end
	B.RefreshDisplay(player)
end

function B.RefreshDisplay(player)
	local plot, data = plotOf[player], Data.Get(player)
	if not plot or not data then return end
	displays[player] = displays[player] or {}
	local shown = displays[player]
	local cap = S.Economy.Capacity(player, data)
	local want = {}
	for _, c in ipairs(data.creatures) do
		if c.s and c.s <= cap and not S.Creatures.IsLocked(c.u) then want[c.u] = c end
	end
	for uid, mdl in pairs(shown) do
		if not want[uid] or mdl:GetAttribute("Slot") ~= want[uid].s then mdl:Destroy() shown[uid] = nil end
	end
	local mult = S.Economy.IncomeMultiplier(player, data)
	for uid, c in pairs(want) do
		if not shown[uid] then
			local slot = plot.Slots:FindFirstChild("Slot" .. c.s)
			if slot then
				local mdl = Builder.BuildCreature(c.id, {golden = c.g})
				mdl.Name = "Display_" .. uid
				mdl:SetAttribute("Uid", uid) mdl:SetAttribute("Slot", c.s) mdl:SetAttribute("OwnerUserId", player.UserId)
				local yaw = plot.Floor.CFrame - plot.Floor.Position
				mdl:PivotTo(CFrame.new(slot.Top.Position + Vector3.new(0, 0.2, 0)) * yaw)
				billboard(mdl, Config.CreatureById[c.id], S.Economy.CreatureIncome(c) * mult, c.g)
				local pp = Instance.new("ProximityPrompt") pp.Name = "StealPrompt" pp.ActionText = "Steal" pp.ObjectText = Config.CreatureById[c.id].name
				pp.HoldDuration = Config.Raid.grabTime pp.MaxActivationDistance = 10 pp.RequiresLineOfSight = false
				pp:SetAttribute("NotOwner", player.UserId) pp.Parent = mdl.PrimaryPart
				pp.Triggered:Connect(function(thief) S.Creatures.TryRaidSteal(thief, player, uid) end)
				mdl.Parent = plot
				shown[uid] = mdl
			end
		end
	end
	B.UpdateBoard(player)
end
function B.GetDisplayModel(player, uid) local d = displays[player] return d and d[uid] end

function B.UpdateBoard(player)
	local plot, data = plotOf[player], Data.Get(player)
	if not plot or not data then return end
	local inc = S.Economy.TotalIncome(player, data)
	sign(plot.IncomeBoard, ("💰 $%s/s  •  🐾 %d/%d Oddlings"):format(Config.FormatNumber(inc), #data.creatures, S.Economy.Capacity(player, data)))
end

-- Plot assignment -------------------------------------------------------------
function B.Assign(player)
	if plotOf[player] then return plotOf[player] end
	local plots = workspace.Bases:GetChildren()
	table.sort(plots, function(a, b) return a:GetAttribute("PlotIndex") < b:GetAttribute("PlotIndex") end)
	for _, plot in ipairs(plots) do
		if not ownerOf[plot] then
			ownerOf[plot] = player
			plotOf[player] = plot
			plot:SetAttribute("OwnerUserId", player.UserId)
			plot:SetAttribute("OwnerName", player.DisplayName)
			sign(plot.OwnerSign, player.DisplayName .. "'s Base")
			plot.DoorOuter.OwnerOpen:SetAttribute("OwnerOnly", player.UserId)
			plot.DoorOuter.Breach:SetAttribute("NotOwner", player.UserId)
			for _, pp in ipairs(plot.Console:GetChildren()) do if pp:IsA("ProximityPrompt") then pp:SetAttribute("OwnerOnly", player.UserId) end end
			intruders[plot] = {}
			shield[player] = {untilT = 0, readyAt = 0}
			B.ApplySecurity(player)
			B.RefreshSlots(player)
			return plot
		end
	end
	warn("[Bases] No free plot for", player.Name)
	return nil
end

function B.Release(player)
	local plot = plotOf[player]
	if not plot then return end
	if displays[player] then for _, mdl in pairs(displays[player]) do mdl:Destroy() end end
	displays[player] = nil
	plotOf[player] = nil
	ownerOf[plot] = nil
	shield[player] = nil
	intruders[plot] = nil
	plot:SetAttribute("OwnerUserId", nil) plot:SetAttribute("OwnerName", nil) plot:SetAttribute("ShieldUntil", nil)
	sign(plot.OwnerSign, "AVAILABLE BASE")
	sign(plot.IncomeBoard, "Waiting for an owner...")
	plot.ShieldDome.Transparency = 1
	doorVisual(plot, 1) laserVisual(plot, 0) applyUpgradeDecor(plot, {})
	for _, s in ipairs(plot.Slots:GetChildren()) do s.Top.Color = Color3.fromRGB(60, 60, 70) s.Top.Material = Enum.Material.SmoothPlastic end
end

-- Door ---------------------------------------------------------------------
local function openDoor(plot, seconds)
	local door = plot.Door
	doorOpenUntil[plot] = os.clock() + seconds
	door.CanCollide = false
	door.Transparency = 0.8
	playSound(door, "Door", 0.8)
	task.delay(seconds, function()
		if doorOpenUntil[plot] and os.clock() >= doorOpenUntil[plot] - 0.05 then
			door.CanCollide = true
			door.Transparency = door:GetAttribute("BaseTransparency") or 0
		end
	end)
end

-- Alarm ----------------------------------------------------------------------------
function B.TriggerAlarm(plot, intruder, reason)
	local owner = ownerOf[plot]
	if not owner then return end
	local data = Data.Get(owner) if not data then return end
	local lvl, det = data.security.Alarm, data.security.Detect
	local carrying = S.Creatures.CarryInfo(intruder)
	local name = det >= 3 and intruder.DisplayName or "Someone"
	local extra = (det >= 3 and carrying) and (" carrying " .. carrying.name) or ""
	Remotes.Intruder:FireClient(owner, {kind = "enter", reason = reason, name = name, userId = det >= 3 and intruder.UserId or nil, alarm = lvl, detect = det, extra = extra})
	if alarmUntil[plot] and alarmUntil[plot] > os.clock() then return end
	alarmUntil[plot] = os.clock() + 6
	if lvl >= 2 then playSound(plot.AlarmLights:GetChildren()[1], "Alarm", 1, 1.4) end
	if lvl >= 3 then
		task.spawn(function()
			local sirens = plot.AlarmLights:GetChildren()
			for i = 1, 12 do
				for _, s in ipairs(sirens) do
					s.Color = (i % 2 == 0) and Color3.fromRGB(255, 30, 30) or Color3.fromRGB(90, 30, 30)
					s.Material = (i % 2 == 0) and Enum.Material.Neon or Enum.Material.SmoothPlastic
					local l = s:FindFirstChild("AlarmLight") if l then l.Enabled = i % 2 == 0 l.Brightness = lvl >= 5 and 4 or 2 end
				end
				task.wait(0.5)
			end
		end)
	end
end

-- Shield -----------------------------------------------------------------------
function B.ActivateShield(player)
	local plot, data = plotOf[player], Data.Get(player)
	if not plot or not data then return false end
	local lvl = data.security.Shield
	if lvl <= 0 then return false, "Buy a Base Shield in the Security menu first" end
	local sh = shield[player]
	local t = os.time()
	if sh.untilT > t then return false, "Shield already active" end
	if sh.readyAt > t then return false, ("Shield recharging (%ds)"):format(sh.readyAt - t) end
	if S.Creatures.IsBaseRaided(player) then return false, "Can't activate during a raid!" end
	sh.untilT = t + SEC.Shield.duration[lvl]
	sh.readyAt = sh.untilT + SEC.Shield.cooldown
	plot:SetAttribute("ShieldUntil", sh.untilT)
	plot.ShieldDome.Transparency = 0.55
	playSound(plot.Console, "Shield", 0.8)
	S.Notify(player, ("🛡️ Base Shield active for %ds"):format(SEC.Shield.duration[lvl]), "shield", "Success")
	Data.Sync(player)
	return true
end

-- Handlers ---------------------------------------------------------------------
local H = {}
function H.BuySecurity(player, cat)
	local data = Data.Get(player) local c = SEC[cat]
	if not data or not c then return false, "Invalid" end
	local lvl = data.security[cat]
	if lvl >= c.max then return false, "Already maxed" end
	local cost = c.costs[lvl + 1]
	if not cost then return false, "Invalid" end
	if not S.Economy.Spend(player, "Cash", cost) then return false, "Not enough cash" end
	data.security[cat] = lvl + 1
	B.ApplySecurity(player)
	S.Notify(player, ("%s %s upgraded to level %d!"):format(c.icon, c.name, lvl + 1), "purchase", "Purchase")
	Data.Sync(player)
	return true
end
function H.ActivateShield(player) return B.ActivateShield(player) end
B.Handlers = H

local function wirePrompts()
	for _, plot in ipairs(workspace.Bases:GetChildren()) do
		local outer, inner = plot.DoorOuter, plot.DoorInner
		local function mk(parent, name, text, hold)
			local pp = Instance.new("ProximityPrompt") pp.Name = name pp.ActionText = text pp.HoldDuration = hold pp.MaxActivationDistance = 10 pp.RequiresLineOfSight = false pp.Parent = parent return pp
		end
		local own = mk(outer, "OwnerOpen", "Open Door", 0)
		local br = mk(outer, "Breach", "Break In", SEC.Door.breach[1])
		local ex = mk(inner, "Exit", "Open Door", 0)
		own.Triggered:Connect(function(p) if ownerOf[plot] == p then openDoor(plot, SEC.Door.openTime) end end)
		ex.Triggered:Connect(function(p)
			local root = S.Anti.Root(p)
			if root and B.InPlot(plot, root.Position) then openDoor(plot, 3) end
		end)
		br.Triggered:Connect(function(p)
			local owner = ownerOf[plot]
			if not owner then openDoor(plot, SEC.Door.openTime) return end
			if owner == p then return end
			local root = S.Anti.Root(p)
			if not root or (root.Position - outer.Position).Magnitude > 14 then return end
			if B.IsShielded(owner) then S.Notify(p, "🛡️ This base is shielded!", "warn", "Fail") return end
			local ok, why = S.Creatures.CanRaid(p, owner)
			if not ok then S.Notify(p, why, "warn", "Fail") return end
			openDoor(plot, SEC.Door.openTime)
			B.TriggerAlarm(plot, p, "breach")
		end)
		for _, pp in ipairs(plot.Console:GetChildren()) do
			if pp:IsA("ProximityPrompt") then
				pp.Triggered:Connect(function(p)
					if ownerOf[plot] ~= p then return end
					if pp.Name == "Security" then Remotes.Effect:FireClient(p, "OpenUI", "Security")
					else local ok, why = B.ActivateShield(p) if not ok then S.Notify(p, why, "warn", "Fail") end end
				end)
			end
		end
	end
end

function B.Start()
	wirePrompts()
	-- Intrusion detection, shield enforcement and lasers: one central loop.
	local tick = 0
	task.spawn(function()
		while true do
			task.wait(0.1)
			tick += 1
			local nowC, nowT = os.clock(), os.time()
			for plot, owner in pairs(ownerOf) do
				local data = Data.Get(owner)
				if data then
					local sh = shield[owner]
					if sh and sh.untilT > 0 and sh.untilT <= nowT and plot.ShieldDome.Transparency < 1 then
						plot.ShieldDome.Transparency = 1
						plot:SetAttribute("ShieldUntil", nil)
						S.Notify(owner, "🛡️ Your base shield has expired.", "warn", "Fail")
						Data.Sync(owner)
					end
					local det = data.security.Detect
					local range = SEC.Detect.range[det]
					local lasersOn = data.security.Laser > 0 and ((nowC % 4.5) < 3)
					if tick % 2 == 0 then
						for _, b in ipairs(plot.Lasers:GetChildren()) do
							if b:GetAttribute("Installed") then b.Transparency = lasersOn and 0.15 or 0.85 end
						end
					end
					local list = intruders[plot]
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= owner then
							local root = S.Anti.Root(p)
							local inside = root and B.InPlot(plot, root.Position, range)
							local core = root and B.InPlot(plot, root.Position)
							if inside and not list[p] then
								list[p] = nowC
								B.TriggerAlarm(plot, p, "enter")
							elseif not inside and list[p] then
								list[p] = nil
								Remotes.Intruder:FireClient(owner, {kind = "leave", userId = p.UserId})
							end
							if core and sh and sh.untilT > nowT and not S.Creatures.IsRaidThief(p, owner) then
								S.Anti.Teleport(p, B.OutsideDoorCFrame(plot))
								S.Notify(p, "🛡️ This base is protected by a shield!", "warn", "Fail")
							end
							-- lasers
							if core and lasersOn then
								local lvl = data.security.Laser
								local lp = B.LocalPos(plot, root.Position)
								for _, b in ipairs(plot.Lasers:GetChildren()) do
									if b:GetAttribute("Installed") then
										local bl = B.LocalPos(plot, b.Position)
										if math.abs(lp.Z - bl.Z) < 1.4 and math.abs(lp.X) < 7 then
											laserHit[p] = laserHit[p] or {}
											if (laserHit[p][plot] or 0) + SEC.Laser.cooldown < nowC then
												laserHit[p][plot] = nowC
												p:SetAttribute("SlowAmount", SEC.Laser.slow[lvl])
												p:SetAttribute("SlowUntil", workspace:GetServerTimeNow() + SEC.Laser.duration[lvl])
												playSound(b, "Laser", 0.8)
												S.Notify(p, "🔴 Laser trap! You've been slowed!", "warn")
												Remotes.Intruder:FireClient(owner, {kind = "laser", name = p.DisplayName})
											end
											break
										end
									end
								end
							end
							-- live position tracking for high detection levels
							if inside and det >= 4 and tick % 5 == 0 then
								Remotes.Intruder:FireClient(owner, {kind = "pos", userId = p.UserId, pos = root.Position, detect = det})
							end
						end
					end
				end
			end
		end
	end)
	Players.PlayerRemoving:Connect(function(p) laserHit[p] = nil for _, l in pairs(intruders) do l[p] = nil end end)
end

return B
