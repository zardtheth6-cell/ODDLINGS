-- ODDLINGS server bootstrap: explicit dependency order, request dispatch, player lifecycle.
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Remotes = game.ReplicatedStorage.Remotes
local Server = script.Parent.Server

local S = {}
S.Anti = require(Server.AntiExploitService)
S.Data = require(Server.PlayerDataService)
S.Monetization = require(Server.MonetizationService)
S.Economy = require(Server.EconomyService)
S.Bases = require(Server.BaseService)
S.Creatures = require(Server.CreatureService)
S.Combat = require(Server.BatCombatService)
S.Events = require(Server.EventService)
S.Leaderboards = require(Server.LeaderboardService)

function S.Notify(player, text, kind, sound)
	if player and player.Parent then Remotes.Notify:FireClient(player, {text = text, kind = kind or "info", sound = sound}) end
end
function S.Effect(player, name, ...) if player and player.Parent then Remotes.Effect:FireClient(player, name, ...) end end
function S.BuildSnapshot(player, data) return S.Economy.BuildSnapshot(player, data) end

local order = {"Anti", "Data", "Monetization", "Economy", "Bases", "Creatures", "Combat", "Events", "Leaderboards"}
for _, n in ipairs(order) do if S[n].Init then S[n].Init(S) end end
for _, n in ipairs(order) do if S[n].Start then S[n].Start(S) end end

-- Request dispatcher -----------------------------------------------------------------
local handlers = {}
for _, n in ipairs({"Economy", "Bases", "Monetization", "Leaderboards"}) do
	for k, fn in pairs(S[n].Handlers or {}) do handlers[k] = fn end
end
Remotes.Request.OnServerInvoke = function(player, action, a, b)
	if type(action) ~= "string" or not handlers[action] then return {ok = false, msg = "Unknown action"} end
	if not S.Anti.Allow(player, "req", 6, 10) then return {ok = false, msg = "Slow down!"} end
	if action ~= "GetLeaderboards" and not S.Data.IsLoaded(player) then return {ok = false, msg = "Still loading..."} end
	local ok, res, msg = pcall(handlers[action], player, a, b)
	if not ok then warn("[Request]", action, res) return {ok = false, msg = "Something went wrong"} end
	if type(res) == "table" then return {ok = true, data = res} end
	return {ok = res == true, msg = msg}
end

-- Characters --------------------------------------------------------------------------
local function onCharacter(player, char)
	local hum = char:WaitForChild("Humanoid", 10)
	local hrp = char:WaitForChild("HumanoidRootPart", 10)
	if not hum or not hrp then return end
	while player.Parent and not S.Data.IsLoaded(player) do task.wait(0.2) end
	if not player.Parent then return end
	task.wait(0.1)
	S.Anti.Teleport(player, S.Bases.SpawnCFrame(player))
	player:SetAttribute("SpawnShieldUntil", workspace:GetServerTimeNow() + Config.SpawnShieldTime)
	player:SetAttribute("StunUntil", 0)
	S.Combat.GiveBat(player)
	S.Economy.UpdateOverhead(player)
	S.Monetization.ApplyCosmetics(player)
	hum.Died:Connect(function() S.Creatures.OnCharacterRemoving(player) end)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function(c) task.spawn(onCharacter, player, c) end)
	task.spawn(S.Monetization.OnPlayerAdded, player)
	if not S.Data.Load(player) then return end
	S.Bases.Assign(player)
	S.Economy.OnLoaded(player, S.Data.Get(player))
	S.Data.Sync(player)
	if player.Character then task.spawn(onCharacter, player, player.Character) end
end
Players.PlayerAdded:Connect(onPlayerAdded)
for _, p in ipairs(Players:GetPlayers()) do task.spawn(onPlayerAdded, p) end

Players.PlayerRemoving:Connect(function(player)
	S.Creatures.OnPlayerLeaving(player) -- returns carried/raided creatures first
	S.Leaderboards.Push(player)
	S.Data.Save(player, true)
	S.Bases.Release(player)
	S.Data.Unload(player)
end)

-- Stations --------------------------------------------------------------------------
local function hookStation(part)
	local pp = part:FindFirstChildOfClass("ProximityPrompt")
	if pp then pp.Triggered:Connect(function(p) Remotes.Effect:FireClient(p, "OpenUI", part:GetAttribute("Station")) end) end
end
for _, p in ipairs(CollectionService:GetTagged("Station")) do hookStation(p) end

-- Territory barriers + enforcement ------------------------------------------------------
for _, bar in ipairs(CollectionService:GetTagged("TerritoryBarrier")) do
	local pp = bar:FindFirstChildOfClass("ProximityPrompt")
	if pp then pp.Triggered:Connect(function(p)
		local id = bar:GetAttribute("Territory")
		local d = S.Data.Get(p)
		if d and d.territories[id] then return end
		local res, msg = S.Economy.Handlers.UnlockTerritory(p, id)
		if res ~= true then S.Notify(p, "🔒 " .. (msg or "Locked"), "warn", "Fail") end
	end) end
end
task.spawn(function()
	while true do
		task.wait(1)
		for _, p in ipairs(Players:GetPlayers()) do
			local d = S.Data.Get(p)
			local rt = S.Anti.Root(p)
			if d and rt then
				local t = S.Creatures.TerritoryAt(rt.Position)
				p:SetAttribute("Territory", t or "Wilds")
				if t and Config.TerritoryById[t] and not d.territories[t] then
					S.Anti.Teleport(p, CFrame.new(0, 4, 50))
					S.Notify(p, "🔒 " .. Config.TerritoryById[t].name .. " is locked! Unlock it at the gate.", "warn", "Fail")
				end
			end
		end
	end
end)

-- Portals ---------------------------------------------------------------------------
local portalCD = {}
for _, surf in ipairs(CollectionService:GetTagged("Portal")) do
	surf.CanTouch = true
	surf.Touched:Connect(function(hit)
		local p = Players:GetPlayerFromCharacter(hit.Parent)
		if not p or (portalCD[p] or 0) > os.clock() then return end
		local d = S.Data.Get(p)
		if not d then return end
		local dest = surf:GetAttribute("Destination")
		if dest.X < -250 and not d.territories.Cosmic then return end
		portalCD[p] = os.clock() + 3
		S.Anti.Teleport(p, CFrame.new(dest))
		Remotes.Effect:FireClient(p, "Portal")
	end)
end
Players.PlayerRemoving:Connect(function(p) portalCD[p] = nil end)

-- Studio-only automated test hook (never active in live servers)
if game:GetService("RunService"):IsStudio() and game.ServerStorage:FindFirstChild("__TestRunner") then
	local runner = require(game.ServerStorage.__TestRunner)
	local bf = Instance.new("BindableFunction") bf.Name = "__OddlingsTest" bf.Parent = game.ServerStorage
	bf.OnInvoke = function(name, ...) local ok, r = pcall(runner[name], S, ...) return ok and r or ("ERROR: " .. tostring(r)) end
end
print("[ODDLINGS] Server ready")
