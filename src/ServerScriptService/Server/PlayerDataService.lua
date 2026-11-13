-- Session-locked, versioned player data with retries, autosave and safe shutdown.
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Config = require(game.ReplicatedStorage.Shared.Config)

local D = {}
local STORE_NAME = "OddlingsPlayerData_v1"
local LOCK_TIMEOUT = 120
local AUTOSAVE = 90
local store
local profiles = {}      -- [player] = data
local meta = {}          -- [player] = {noSave=bool, loaded=bool, lastSave=os.clock()}
local syncQueued = {}
local S

D.Loaded = Instance.new("BindableEvent")

local function deepCopy(t) if type(t) ~= "table" then return t end local o = {} for k,v in pairs(t) do o[k] = deepCopy(v) end return o end

local function defaults()
	return {
		version = Config.Version,
		cash = 150, gems = 10, totalEarned = 0,
		level = 1, xp = 0,
		creatures = {},          -- {u=uid, id=creatureId, g=golden, s=slot}
		capacity = Config.Capacity.start,
		security = {Door=1, Alarm=1, Laser=0, Shield=0, Detect=1},
		upgrades = {Speed=0, Sprint=0, Stamina=0, Recovery=0, Carry=0, Dash=0, Luck=0},
		territories = {Mushroom=true},
		titles = {Newcomer=true}, title = "Newcomer",
		discovered = {}, collected = {}, milestones = {},
		daily = {last=0, streak=0},
		rebirths = 0,
		stats = {raidsWon=0, raidsDefended=0, rares=0, steals=0, captures=0},
		bats = {Classic=true}, bat = "Classic",
		boosts = {},             -- name -> unix expiry
		receipts = {}, receiptOrder = {},
		settings = {music=0.5, sfx=0.7, lowGfx=false},
		firstJoin = os.time(), playTime = 0,
	}
end

-- Fills missing keys and migrates old versions without touching existing values.
local function reconcile(data)
	local def = defaults()
	for k, v in pairs(def) do
		if data[k] == nil then data[k] = deepCopy(v)
		elseif type(v) == "table" and type(data[k]) == "table" and k ~= "creatures" and k ~= "receiptOrder" then
			for k2, v2 in pairs(v) do if data[k][k2] == nil then data[k][k2] = deepCopy(v2) end end
		end
	end
	-- migrations
	if (data.version or 0) < 1 then data.version = 1 end
	-- integrity: drop unknown creature ids, ensure uids + slots
	local used = {}
	local clean = {}
	for _, c in ipairs(data.creatures) do
		if type(c) == "table" and Config.CreatureById[c.id] then
			c.u = c.u or HttpService:GenerateGUID(false)
			table.insert(clean, c)
		end
	end
	data.creatures = clean
	for _, c in ipairs(clean) do if c.s and not used[c.s] and c.s >= 1 and c.s <= Config.MaxDisplaySlots then used[c.s] = true else c.s = nil end end
	for _, c in ipairs(clean) do if not c.s then for i = 1, Config.MaxDisplaySlots do if not used[i] then used[i] = true c.s = i break end end end end
	return data
end

local function retry(fn, tries)
	local lastErr
	for i = 1, tries or 4 do
		local ok, a, b = pcall(fn)
		if ok then return true, a, b end
		lastErr = a
		task.wait(math.min(2 ^ i, 8))
	end
	return false, lastErr
end

function D.Init(services) S = services
	local ok, s = pcall(function() return DataStoreService:GetDataStore(STORE_NAME) end)
	if ok then store = s else warn("[Data] DataStore unavailable: ", s) end
end

function D.Get(player) local m = meta[player] if m and m.loaded then return profiles[player] end return nil end
function D.IsLoaded(player) return meta[player] ~= nil and meta[player].loaded == true end
function D.CanSave(player) return meta[player] and not meta[player].noSave end

function D.Load(player)
	local key = "u_" .. player.UserId
	local data, noSave = nil, false
	if not store then
		noSave = true
	else
		local attempts = 0
		while true do
			attempts += 1
			local lockedOut = false
			local ok, result = retry(function()
				return store:UpdateAsync(key, function(old)
					old = old or nil
					if old and old.lock and old.lock.job ~= game.JobId and os.time() - (old.lock.t or 0) < LOCK_TIMEOUT then
						lockedOut = true
						return nil -- abort, keep stored value
					end
					old = old or {profile = nil}
					old.lock = {job = game.JobId, t = os.time()}
					return old
				end)
			end, 4)
			if not ok then
				warn("[Data] load failed for", player.Name, result)
				noSave = true
				break
			end
			if lockedOut then
				if attempts >= 6 then
					player:Kick("Your data is still being saved by another server. Please rejoin in a minute.")
					return false
				end
				task.wait(6)
			else
				data = result and result.profile
				break
			end
			if not player.Parent then return false end
		end
	end
	if not player.Parent then return false end
	data = reconcile(data or defaults())
	profiles[player] = data
	meta[player] = {noSave = noSave, loaded = true, lastSave = os.clock(), joinedAt = os.time()}
	player:SetAttribute("DataLoaded", true)
	player:SetAttribute("JoinTime", os.time())
	player:SetAttribute("SaveEnabled", not noSave)
	if noSave then
		task.delay(3, function()
			if player.Parent and S.Notify then
				S.Notify(player, "⚠ Saving is unavailable on this server. Progress this session will not be saved.", "warn")
			end
		end)
	end
	D.Loaded:Fire(player, data)
	return true
end

-- Writes the profile. release=true clears the session lock.
function D.Save(player, release)
	local m = meta[player]
	local data = profiles[player]
	if not m or not m.loaded or not data then return false end
	if m.noSave or not store then return true end
	if S.Creatures and S.Creatures.ForSave then data = S.Creatures.ForSave(player, data) end
	local key = "u_" .. player.UserId
	local ok, err = retry(function()
		return store:UpdateAsync(key, function(old)
			old = old or {}
			if old.lock and old.lock.job ~= game.JobId and os.time() - (old.lock.t or 0) < LOCK_TIMEOUT then
				return nil -- another server owns this session; never overwrite
			end
			old.profile = data
			old.lock = (not release) and {job = game.JobId, t = os.time()} or nil
			old.savedAt = os.time()
			return old
		end)
	end, 3)
	if ok then m.lastSave = os.clock() else warn("[Data] save failed", player.Name, err) end
	return ok
end

function D.Unload(player)
	profiles[player] = nil
	meta[player] = nil
	syncQueued[player] = nil
end

-- Sends a compact snapshot to the client (debounced)
function D.Sync(player)
	if syncQueued[player] then return end
	syncQueued[player] = true
	task.delay(0.15, function()
		syncQueued[player] = nil
		local data = D.Get(player)
		if data and player.Parent then
			game.ReplicatedStorage.Remotes.Sync:FireClient(player, S.BuildSnapshot and S.BuildSnapshot(player, data) or data)
		end
	end)
end

function D.Start()
	-- autosave
	task.spawn(function()
		while true do
			task.wait(AUTOSAVE)
			for p, _ in pairs(meta) do
				if p.Parent and D.IsLoaded(p) then task.spawn(D.Save, p, false) end
			end
		end
	end)
	game:BindToClose(function()
		if S.Creatures and S.Creatures.ShutdownAll then pcall(S.Creatures.ShutdownAll) end
		local pending = 0
		for p, _ in pairs(meta) do
			pending += 1
			task.spawn(function() D.Save(p, true) pending -= 1 end)
		end
		local t = os.clock()
		while pending > 0 and os.clock() - t < 25 do task.wait(0.2) end
	end)
end

return D
