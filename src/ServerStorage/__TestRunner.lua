local Config = require(game.ReplicatedStorage.Shared.Config)
local T = {}
local Players = game:GetService("Players")
local function P() return Players:GetPlayers()[1] end
local function root(p) return p.Character and p.Character:FindFirstChild("HumanoidRootPart") end
function T.Info(S)
	local p = P() local d = S.Data.Get(p)
	return ("cash=%d gems=%d lvl=%d creatures=%d cap=%d income=%.1f carrying=%s terr=%s"):format(d.cash, d.gems, d.level, #d.creatures, S.Economy.Capacity(p, d), S.Economy.TotalIncome(p, d), tostring(p:GetAttribute("Carrying")), tostring(p:GetAttribute("Territory")))
end
-- teleport to the nearest Mushroom wild creature and steal it (calls the same server path as the prompt)
function T.StealNearest(S, territory)
	local p = P()
	territory = territory or "Mushroom"
	for _, m in ipairs(workspace.ActiveCreatures:GetChildren()) do
		if m:GetAttribute("Territory") == territory then
			S.Anti.Teleport(p, m.PrimaryPart.CFrame * CFrame.new(0, 3, 4))
			task.wait(0.5)
			S.Creatures.TryWildSteal(p, m)
			return "stole " .. m.Name .. " carrying=" .. tostring(p:GetAttribute("Carrying")) .. " penalty=" .. tostring(p:GetAttribute("CarryPenalty"))
		end
	end
	return "none found"
end
function T.GoHome(S)
	local p = P() local plot = S.Bases.GetPlot(p)
	S.Anti.Teleport(p, CFrame.new(plot.DropZone.Position + Vector3.new(0, 3, 0)))
	task.wait(1)
	return T.Info(S)
end
function T.GuardianStates(S)
	local out = {}
	for _, g in ipairs(workspace.ActiveGuardians:GetChildren()) do
		local hrp = g:FindFirstChild("HumanoidRootPart")
		local r = root(P())
		table.insert(out, g.Name .. ":" .. tostring(g:GetAttribute("State")) .. (hrp and r and (" d=" .. math.floor((hrp.Position - r.Position).Magnitude)) or ""))
	end
	return table.concat(out, ", ")
end
function T.Call(S, svc, fn, ...) local p = P() return S[svc].Handlers[fn](p, ...) end
function T.Give(S, cash, gems) local p = P() S.Economy.AddCash(p, cash or 0) if gems then S.Economy.AddGems(p, gems) end S.Data.Sync(p) return T.Info(S) end
function T.Save(S) local p = P() return tostring(S.Data.Save(p, false)) end
function T.Economy(S)
	local p = P() local out = {}
	local function call(svc, fn, ...) local ok, msg = S[svc].Handlers[fn](p, ...) return tostring(ok) .. (msg and ("(" .. msg .. ")") or "") end
	local d = S.Data.Get(p)
	table.insert(out, "buy speed w/ low cash: " .. call("Economy", "BuyUpgrade", "Speed"))
	S.Economy.AddCash(p, 100000)
	local before = d.cash
	table.insert(out, "buy speed: " .. call("Economy", "BuyUpgrade", "Speed") .. " deducted=" .. (before - d.cash) .. " expected=" .. Config.UpgradeCost("Speed", 0) .. " walk=" .. tostring(p:GetAttribute("WalkBase")))
	table.insert(out, "invalid upgrade: " .. call("Economy", "BuyUpgrade", "Hax"))
	table.insert(out, "security door: " .. call("Bases", "BuySecurity", "Door") .. " lvl=" .. d.security.Door .. " doorMat=" .. S.Bases.GetPlot(p).Door.Material.Name)
	table.insert(out, "laser: " .. call("Bases", "BuySecurity", "Laser") .. " lvl=" .. d.security.Laser)
	table.insert(out, "shield buy: " .. call("Bases", "BuySecurity", "Shield"))
	table.insert(out, "shield on: " .. call("Bases", "ActivateShield") .. " dome=" .. S.Bases.GetPlot(p).ShieldDome.Transparency)
	table.insert(out, "shield again: " .. call("Bases", "ActivateShield"))
	table.insert(out, "capacity: " .. call("Economy", "BuyCapacity") .. " cap=" .. d.capacity)
	table.insert(out, "daily: " .. call("Economy", "ClaimDaily") .. " streak=" .. d.daily.streak)
	table.insert(out, "daily twice: " .. call("Economy", "ClaimDaily"))
	table.insert(out, "item potion: " .. call("Economy", "BuyItem", "SpeedPotion") .. " boostWalk=" .. tostring(p:GetAttribute("WalkBase")))
	table.insert(out, "bat neon w/ gems=" .. d.gems .. ": " .. call("Economy", "BuyBat", "Neon"))
	table.insert(out, "pass prompt (unconfigured): " .. call("Monetization", "PromptPass", "VIP"))
	table.insert(out, "unlock frost (lvl " .. d.level .. "): " .. call("Economy", "UnlockTerritory", "Frostbite"))
	table.insert(out, "rebirth w/ low cash: " .. call("Economy", "Rebirth"))
	return table.concat(out, "\n")
end
function T.SellFirst(S, confirm)
	local p = P() local d = S.Data.Get(p)
	local c = d.creatures[1] if not c then return "none" end
	local ok, msg = S.Economy.Handlers.SellCreature(p, c.u, confirm)
	return tostring(ok) .. " " .. tostring(msg) .. " count=" .. #d.creatures .. " cash=" .. math.floor(d.cash)
end
function T.Rebirth(S)
	local p = P() local d = S.Data.Get(p)
	S.Economy.AddCash(p, Config.RebirthCost(d.rebirths))
	local n = #d.creatures
	local ok, msg = S.Economy.Handlers.Rebirth(p)
	return ("rebirth=%s %s rebirths=%d cash=%d speedLvl=%d creaturesKept=%s door=%d frost=%s"):format(tostring(ok), tostring(msg), d.rebirths, d.cash, d.upgrades.Speed, tostring(#d.creatures == n), d.security.Door, tostring(d.territories.Frostbite))
end
function T.ProcessReceipt(S)
	local MS = game:GetService("MarketplaceService")
	local p = P() local d = S.Data.Get(p)
	Config.ProductById.GemsS.assetId = 999001
	local g0 = d.gems
	local info = {PlayerId = p.UserId, ProductId = 999001, PurchaseId = "TEST-" .. os.time(), CurrencySpent = 99, PlaceIdWherePurchased = game.PlaceId}
	local r1 = S.Monetization.ProcessReceipt(info)
	local r2 = S.Monetization.ProcessReceipt(info)
	local unknown = S.Monetization.ProcessReceipt({PlayerId = p.UserId, ProductId = 123, PurchaseId = "BAD", CurrencySpent = 1})
	Config.ProductById.GemsS.assetId = 0
	return ("first=%s second=%s gemsGained=%d (expect 120 once) unknownProduct=%s"):format(r1.Name, r2.Name, d.gems - g0, unknown.Name)
end
function T.Swing(S)
	local p = P() local char = p.Character
	local tool = p.Backpack:FindFirstChild("Bat") if tool then char.Humanoid:EquipTool(tool) end
	task.wait(0.3)
	local g = char:FindFirstChild("Bat")
	return "bat equipped=" .. tostring(g ~= nil) .. " batId=" .. tostring(g and g:GetAttribute("BatId"))
end
function T.Events(S)
	local out = {}
	for _, id in ipairs({"Golden", "Stampede", "Meteor", "Blackout", "Visitor"}) do
		local ok = S.Events.Run(id)
		task.wait(5)
		local extra = ""
		if id == "Golden" then for _, m in ipairs(workspace.ActiveCreatures:GetChildren()) do if m:GetAttribute("Golden") then extra = " golden=" .. m.Name end end end
		if id == "Stampede" then extra = " runners=" .. #(workspace.WorldEvents:FindFirstChild("Stampede") and workspace.WorldEvents.Stampede:GetChildren() or {}) end
		if id == "Meteor" then extra = " gems=" .. #(workspace.WorldEvents:FindFirstChild("Meteor") and workspace.WorldEvents.Meteor:GetChildren() or {}) end
		if id == "Blackout" then extra = " clock=" .. string.format("%.1f", game.Lighting.ClockTime) end
		if id == "Visitor" then extra = " guardians=" .. #workspace.ActiveGuardians:GetChildren() end
		-- force end
		local Ev = S.Events
		table.insert(out, id .. " started=" .. tostring(ok) .. extra)
		local def for _, e in ipairs(Config.Events.list) do if e.id == id then def = e end end
		task.wait(def.duration - 5 + 1.5)
		table.insert(out, "  ended cleanly, worldEvents=" .. #workspace.WorldEvents:GetChildren())
	end
	return table.concat(out, "\n")
end
function T.FastEvents(S)
	for _, e in ipairs(Config.Events.list) do e.duration = 8 end
	return T.Events(S)
end
return T
