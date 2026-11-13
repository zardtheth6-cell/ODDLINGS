-- Cash/gems, passive income, upgrades, items, territories, levels, titles, daily rewards, rebirth, selling.
local Players = game:GetService("Players")
local Config = require(game.ReplicatedStorage.Shared.Config)
local E = {}
local S, Data

local function now() return os.time() end

function E.Init(services) S = services Data = S.Data end

-- Boosts ---------------------------------------------------------------
function E.BoostActive(data, name) return (data.boosts[name] or 0) > now() end
function E.AddBoost(player, name, seconds)
	local data = Data.Get(player) if not data then return end
	local base = math.max(data.boosts[name] or 0, now())
	data.boosts[name] = base + seconds
	E.ApplyStats(player)
	Data.Sync(player)
end

-- Income -----------------------------------------------------------------
function E.IncomeMultiplier(player, data)
	local mult = 1 + data.rebirths * Config.Rebirth.incomeBonus
	if S.Monetization.Owns(player, "VIP") then mult += 0.10 end
	if S.Monetization.Owns(player, "DoubleCash") then mult *= 2 end
	return mult
end
function E.CreatureIncome(c)
	local def = Config.CreatureById[c.id]
	return def.income * (c.g and Config.GoldenIncomeMult or 1)
end
function E.TotalIncome(player, data)
	local sum = 0
	for _, c in ipairs(data.creatures) do
		if not (S.Creatures.IsLocked and S.Creatures.IsLocked(c.u)) then sum += E.CreatureIncome(c) end
	end
	return sum * E.IncomeMultiplier(player, data)
end
function E.Capacity(player, data)
	local cap = data.capacity
	if S.Monetization.Owns(player, "ExtraStorage") then cap += 6 end
	if S.Monetization.Owns(player, "ExtraSlots") then cap += 6 end
	return math.min(cap, Config.MaxDisplaySlots)
end

-- Currency -----------------------------------------------------------------
local function refreshCurrency(player, data)
	player:SetAttribute("Cash", data.cash)
	player:SetAttribute("Gems", data.gems)
	local ls = player:FindFirstChild("leaderstats")
	if ls then ls.Cash.Value = math.floor(data.cash) ls.Level.Value = data.level end
end
function E.AddCash(player, amount, earned)
	local data = Data.Get(player) if not data then return false end
	data.cash += amount
	if earned and amount > 0 then data.totalEarned += amount end
	refreshCurrency(player, data)
	return true
end
function E.Spend(player, currency, amount)
	local data = Data.Get(player) if not data then return false end
	amount = math.floor(amount)
	if amount < 0 then return false end
	if currency == "Cash" then
		if data.cash < amount then return false end
		data.cash -= amount
	elseif currency == "Gems" then
		if data.gems < amount then return false end
		data.gems -= amount
	else return false end
	refreshCurrency(player, data)
	return true
end
function E.AddGems(player, amount)
	local data = Data.Get(player) if not data then return end
	data.gems += amount refreshCurrency(player, data)
end

-- Levels / XP ----------------------------------------------------------------
function E.AddXP(player, amount)
	local data = Data.Get(player) if not data then return end
	data.xp += amount
	local leveled = false
	while data.xp >= Config.XPForLevel(data.level) do
		data.xp -= Config.XPForLevel(data.level)
		data.level += 1
		leveled = true
	end
	if leveled then
		player:SetAttribute("Level", data.level)
		S.Notify(player, "⭐ LEVEL UP! You are now level " .. data.level, "level", "LevelUp")
		S.Effect(player, "LevelUp")
		E.CheckTitles(player)
	end
	refreshCurrency(player, data)
	Data.Sync(player)
end

-- Titles -----------------------------------------------------------------------
local titleChecks = {
	Hunter = function(d) local n = 0 for _ in pairs(d.collected) do n += 1 end return #d.creatures >= 5 or n >= 5 end,
	Collector = function(d) local n = 0 for _ in pairs(d.discovered) do n += 1 end return n >= 10 end,
	Thief = function(d) return d.stats.raidsWon >= 5 end,
	Defender = function(d) return d.stats.raidsDefended >= 5 end,
	RareHunter = function(d) return d.stats.rares >= 5 end,
	Legend = function(d) return d.rebirths >= 1 end,
}
function E.CheckTitles(player)
	local data = Data.Get(player) if not data then return end
	for id, fn in pairs(titleChecks) do
		if not data.titles[id] and fn(data) then
			data.titles[id] = true
			S.Notify(player, "🏷️ New title unlocked: " .. Config.TitleById[id].name, "title", "Success")
		end
	end
	if S.Monetization.Owns(player, "VIP") then data.titles.VIP = true end
	Data.Sync(player)
end
function E.UpdateOverhead(player)
	local data = Data.Get(player)
	local char = player.Character
	if not data or not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	local bb = head:FindFirstChild("Overhead") or Instance.new("BillboardGui")
	bb.Name = "Overhead" bb.Size = UDim2.fromOffset(220, 56) bb.StudsOffset = Vector3.new(0, 2.6, 0) bb.MaxDistance = 90 bb.AlwaysOnTop = false bb.Adornee = head bb.Parent = head
	local name = bb:FindFirstChild("PName") or Instance.new("TextLabel", bb)
	name.Name = "PName" name.BackgroundTransparency = 1 name.Size = UDim2.new(1, 0, 0.55, 0) name.Font = Enum.Font.FredokaOne name.TextScaled = true
	name.Text = player.DisplayName name.TextColor3 = Color3.new(1, 1, 1) name.TextStrokeTransparency = 0.3
	local title = bb:FindFirstChild("PTitle") or Instance.new("TextLabel", bb)
	title.Name = "PTitle" title.BackgroundTransparency = 1 title.Size = UDim2.new(1, 0, 0.45, 0) title.Position = UDim2.fromScale(0, 0.55)
	title.Font = Enum.Font.GothamBold title.TextScaled = true title.TextStrokeTransparency = 0.4
	local t = Config.TitleById[data.title]
	title.Text = t and ("« " .. t.name .. " »") or "" title.TextColor3 = t and t.color or Color3.new(1, 1, 1)
	if S.Monetization.Owns(player, "NameTag") then name:SetAttribute("Rainbow", true) end
	if S.Monetization.Owns(player, "VIP") then name.Text = "👑 " .. player.DisplayName name.TextColor3 = Color3.fromRGB(255, 215, 60) end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
end

-- Movement stats --------------------------------------------------------------
function E.ApplyStats(player)
	local data = Data.Get(player) if not data then return end
	local u, M = data.upgrades, Config.Movement
	local function per(id) return Config.UpgradeById[id].per end
	local walk = M.walk + u.Speed * per("Speed")
	if E.BoostActive(data, "speed") then walk *= 1.15 end
	player:SetAttribute("WalkBase", walk)
	player:SetAttribute("SprintMult", M.sprintMult + u.Sprint * per("Sprint"))
	player:SetAttribute("StaminaMax", M.stamina + u.Stamina * per("Stamina"))
	player:SetAttribute("Regen", M.regen + u.Recovery * per("Recovery"))
	player:SetAttribute("CarryRelief", math.min(0.6, u.Carry * per("Carry")))
	player:SetAttribute("DashCD", math.max(1.2, M.dashCooldown - u.Dash * per("Dash")))
	player:SetAttribute("InfStaminaUntil", data.boosts.stamina or 0)
	player:SetAttribute("EscapeUntil", data.boosts.escape or 0)
	player:SetAttribute("MaxLegitSpeed", walk * (M.sprintMult + u.Sprint * per("Sprint")) + 4)
	player:SetAttribute("Level", data.level)
end
function E.Luck(player)
	local data = Data.Get(player) if not data then return 0 end
	local l = data.upgrades.Luck * Config.UpgradeById.Luck.per
	if E.BoostActive(data, "luck") then l += 1 end
	return l
end

-- Snapshot sent to client ---------------------------------------------------------
function E.BuildSnapshot(player, data)
	local creatures = {}
	for _, c in ipairs(data.creatures) do
		table.insert(creatures, {u = c.u, id = c.id, g = c.g, s = c.s, income = E.CreatureIncome(c) * E.IncomeMultiplier(player, data), locked = S.Creatures.IsLocked(c.u)})
	end
	local passes = {}
	for _, p in ipairs(Config.GamePasses) do passes[p.id] = S.Monetization.Owns(player, p.id) end
	local lb = S.Bases.GetPlot(player)
	return {
		cash = data.cash, gems = data.gems, level = data.level, xp = data.xp, xpNext = Config.XPForLevel(data.level),
		creatures = creatures, capacity = E.Capacity(player, data), baseCapacity = data.capacity,
		security = data.security, upgrades = data.upgrades, territories = data.territories,
		titles = data.titles, title = data.title, discovered = data.discovered, collected = data.collected,
		milestones = data.milestones, daily = data.daily, rebirths = data.rebirths, stats = data.stats,
		bats = data.bats, bat = data.bat, boosts = data.boosts, settings = data.settings,
		income = E.TotalIncome(player, data), incomeMult = E.IncomeMultiplier(player, data),
		passes = passes, serverTime = os.time(), plot = lb and lb.Name or nil,
		shieldUntil = S.Bases.ShieldUntil(player), shieldReadyAt = S.Bases.ShieldReadyAt(player),
		canSave = Data.CanSave(player),
	}
end

-- Collection / discovery --------------------------------------------------------------
function E.Discover(player, id)
	local data = Data.Get(player) if not data then return end
	if not data.discovered[id] then
		data.discovered[id] = true
		S.Notify(player, "📖 New Oddling discovered: " .. Config.CreatureById[id].name, "discover", "Pickup")
		E.CheckTitles(player)
	end
end
function E.MarkCollected(player, id)
	local data = Data.Get(player) if not data then return end
	data.discovered[id] = true
	data.collected[id] = true
	local n = 0 for _ in pairs(data.collected) do n += 1 end
	for _, ms in ipairs(Config.CollectionMilestones) do
		if n >= ms.count and not data.milestones[tostring(ms.count)] then
			data.milestones[tostring(ms.count)] = true
			E.AddGems(player, ms.gems)
			S.Notify(player, ("📚 Collection milestone! %d species collected: +%d Gems"):format(ms.count, ms.gems), "reward", "Success")
		end
	end
end

-- Handlers (client requests) -------------------------------------------------------------
local H = {}
function H.BuyUpgrade(player, id)
	local data = Data.Get(player) local u = Config.UpgradeById[id]
	if not data or not u then return false, "Invalid upgrade" end
	local lvl = data.upgrades[id]
	if lvl >= u.max then return false, "Already maxed" end
	local cost = Config.UpgradeCost(id, lvl)
	if not E.Spend(player, "Cash", cost) then return false, "Not enough cash" end
	data.upgrades[id] = lvl + 1
	E.ApplyStats(player)
	S.Notify(player, ("%s %s upgraded to level %d!"):format(u.icon, u.name, lvl + 1), "purchase", "Purchase")
	Data.Sync(player)
	return true
end
function H.BuyCapacity(player)
	local data = Data.Get(player) if not data then return false end
	if data.capacity >= Config.Capacity.max then return false, "Base fully expanded" end
	local cost = Config.CapacityCost(data.capacity)
	if not E.Spend(player, "Cash", cost) then return false, "Not enough cash" end
	data.capacity += Config.Capacity.step
	S.Bases.RefreshSlots(player)
	S.Notify(player, "🧱 Base expanded! Capacity: " .. E.Capacity(player, data), "purchase", "Purchase")
	Data.Sync(player)
	return true
end
function H.BuyItem(player, id)
	local data = Data.Get(player) local item = Config.ItemById[id]
	if not data or not item then return false, "Invalid item" end
	if id == "Capacity" then return H.BuyCapacity(player) end
	if not E.Spend(player, item.currency, item.price) then return false, "Not enough " .. item.currency:lower() end
	if item.boost then E.AddBoost(player, item.boost, item.time) end
	S.Notify(player, item.icon .. " " .. item.name .. " activated!", "purchase", "Purchase")
	Data.Sync(player)
	return true
end
function H.BuyBat(player, id)
	local data = Data.Get(player) local b = Config.BatById[id]
	if not data or not b then return false, "Invalid bat" end
	if data.bats[id] then return false, "Already owned" end
	if b.currency ~= "Gems" or not E.Spend(player, "Gems", b.price) then return false, "Not enough gems" end
	data.bats[id] = true
	data.bat = id
	S.Combat.GiveBat(player)
	S.Notify(player, "🏏 " .. b.name .. " unlocked and equipped!", "purchase", "Purchase")
	Data.Sync(player)
	return true
end
function H.EquipBat(player, id)
	local data = Data.Get(player)
	if not data or not data.bats[id] then return false, "Not owned" end
	data.bat = id S.Combat.GiveBat(player) Data.Sync(player) return true
end
function H.EquipTitle(player, id)
	local data = Data.Get(player)
	if not data or not data.titles[id] then return false, "Title locked" end
	data.title = id E.UpdateOverhead(player) Data.Sync(player) return true
end
function H.UnlockTerritory(player, id)
	local data = Data.Get(player) local t = Config.TerritoryById[id]
	if not data or not t then return false, "Invalid" end
	if data.territories[id] then return false, "Already unlocked" end
	local prev = Config.Territories[t.order - 1]
	if prev and not data.territories[prev.id] then return false, "Unlock " .. prev.name .. " first" end
	if data.level < t.level then return false, "Requires level " .. t.level end
	if not E.Spend(player, "Cash", t.cost) then return false, "Not enough cash" end
	data.territories[id] = true
	S.Notify(player, "🗺️ " .. t.name .. " unlocked!", "unlock", "Success")
	S.Effect(player, "Unlock", id)
	Data.Sync(player)
	return true
end
function H.ClaimDaily(player)
	local data = Data.Get(player) if not data then return false end
	local d, C = data.daily, Config.Daily
	local t = now()
	if t - d.last < C.cooldown then return false, "Come back later!" end
	if t - d.last > C.resetAfter then d.streak = 0 end
	d.streak = (d.streak % #C.rewards) + 1
	d.last = t
	local r = C.rewards[d.streak]
	local parts = {}
	if r.cash then E.AddCash(player, r.cash) table.insert(parts, "$" .. Config.FormatNumber(r.cash)) end
	if r.gems then E.AddGems(player, r.gems) table.insert(parts, r.gems .. " Gems") end
	if r.bat then if not data.bats[r.bat] then data.bats[r.bat] = true table.insert(parts, Config.BatById[r.bat].name) else E.AddGems(player, 50) table.insert(parts, "+50 bonus Gems") end end
	S.Notify(player, ("🎁 Day %d reward: %s"):format(d.streak, table.concat(parts, ", ")), "reward", "Success")
	Data.Sync(player)
	return true
end
function H.Rebirth(player)
	local data = Data.Get(player) if not data then return false end
	local cost = Config.RebirthCost(data.rebirths)
	if data.cash < cost then return false, "Need $" .. Config.FormatNumber(cost) end
	if S.Creatures.IsBusy(player) then return false, "Finish your current steal or raid first" end
	-- Resets cash, movement upgrades, territory unlocks. Keeps creatures, security, gems, titles, purchases, bats.
	data.cash = 0
	for k in pairs(data.upgrades) do data.upgrades[k] = 0 end
	data.territories = {Mushroom = true}
	data.rebirths += 1
	data.gems += Config.Rebirth.gems
	refreshCurrency(player, data)
	E.ApplyStats(player)
	E.CheckTitles(player)
	S.Notify(player, ("🔁 REBIRTH %d! Permanent +%d%% income. +%d Gems"):format(data.rebirths, data.rebirths * Config.Rebirth.incomeBonus * 100, Config.Rebirth.gems), "rebirth", "Rebirth")
	S.Effect(player, "Rebirth")
	S.Bases.RefreshDisplay(player)
	S.Bases.ApplySecurity(player)
	Data.Sync(player)
	task.spawn(Data.Save, player, false)
	return true
end
function H.SellCreature(player, uid, confirmed)
	local data = Data.Get(player) if not data or type(uid) ~= "string" then return false end
	for i, c in ipairs(data.creatures) do
		if c.u == uid then
			if S.Creatures.IsLocked(uid) then return false, "That Oddling is being raided!" end
			local def = Config.CreatureById[c.id]
			local r = Config.RarityById[def.rarity]
			if r.order >= Config.ConfirmSellFrom and confirmed ~= true then return false, "confirm" end
			local value = math.floor(E.CreatureIncome(c) * r.sellMult)
			table.remove(data.creatures, i)
			E.AddCash(player, value, true)
			S.Bases.RefreshDisplay(player)
			S.Notify(player, ("🏷️ Sold %s for $%s"):format(def.name, Config.FormatNumber(value)), "purchase", "Cash")
			Data.Sync(player)
			task.spawn(Data.Save, player, false)
			return true
		end
	end
	return false, "Not found"
end
function H.SetSettings(player, s)
	local data = Data.Get(player) if not data or type(s) ~= "table" then return false end
	if type(s.music) == "number" then data.settings.music = math.clamp(s.music, 0, 1) end
	if type(s.sfx) == "number" then data.settings.sfx = math.clamp(s.sfx, 0, 1) end
	if type(s.lowGfx) == "boolean" then data.settings.lowGfx = s.lowGfx end
	return true
end
function H.GetSnapshot(player) local d = Data.Get(player) return d and E.BuildSnapshot(player, d) end
E.Handlers = H

function E.Start()
	-- One central income loop for all players (no per-creature loops).
	task.spawn(function()
		local t = 0
		while true do
			task.wait(1)
			t += 1
			for _, p in ipairs(Players:GetPlayers()) do
				local data = Data.Get(p)
				if data then
					local inc = E.TotalIncome(p, data)
					if inc > 0 then E.AddCash(p, inc, true) end
					data.playTime += 1
					p:SetAttribute("Income", inc)
					if t % 10 == 0 then
						-- expire boosts
						local changed = false
						for k, v in pairs(data.boosts) do if v <= os.time() then data.boosts[k] = nil changed = true end end
						if changed then E.ApplyStats(p) Data.Sync(p) end
						S.Bases.UpdateBoard(p)
					end
				end
			end
		end
	end)
end

function E.OnLoaded(player, data)
	local ls = Instance.new("Folder") ls.Name = "leaderstats"
	local c = Instance.new("IntValue") c.Name = "Cash" c.Parent = ls
	local l = Instance.new("IntValue") l.Name = "Level" l.Parent = ls
	ls.Parent = player
	refreshCurrency(player, data)
	E.ApplyStats(player)
	E.CheckTitles(player)
end

return E
