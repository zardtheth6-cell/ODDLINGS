-- Global leaderboards via OrderedDataStores, with a live-server fallback.
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local L = {}
local S
local stores = {}
local cache = {}      -- [id] = {{name, value}}, global
local scope = "global"
local nameCache = {}
local lastPush = {}

local getters = {
	TotalEarned = function(d) return math.floor(d.totalEarned) end,
	Rares = function(d) return d.stats.rares end,
	Level = function(d) return d.level end,
	Rebirths = function(d) return d.rebirths end,
	Raids = function(d) return d.stats.raidsWon end,
}

function L.Init(services) S = services
	for _, lb in ipairs(Config.Leaderboards) do
		local ok, st = pcall(function() return DataStoreService:GetOrderedDataStore("LB_" .. lb.id .. "_v1") end)
		if ok then stores[lb.id] = st end
	end
end

local function nameOf(userId)
	if nameCache[userId] then return nameCache[userId] end
	local p = Players:GetPlayerByUserId(userId)
	if p then nameCache[userId] = p.DisplayName return p.DisplayName end
	local ok, n = pcall(Players.GetNameFromUserIdAsync, Players, userId)
	nameCache[userId] = ok and n or ("Player " .. userId)
	return nameCache[userId]
end

function L.Push(p)
	local d = S.Data.Get(p)
	if not d or not S.Data.CanSave(p) then return end
	if lastPush[p] and os.clock() - lastPush[p] < 120 then return end
	lastPush[p] = os.clock()
	for id, fn in pairs(getters) do
		local st = stores[id]
		if st then pcall(st.SetAsync, st, tostring(p.UserId), fn(d)) end
	end
end

local function localBoards()
	local out = {}
	for id, fn in pairs(getters) do
		local list = {}
		for _, p in ipairs(Players:GetPlayers()) do local d = S.Data.Get(p) if d then table.insert(list, {name = p.DisplayName, value = fn(d)}) end end
		table.sort(list, function(a, b) return a.value > b.value end)
		while #list > 10 do table.remove(list) end
		out[id] = list
	end
	return out
end

local function render()
	for _, lb in ipairs(Config.Leaderboards) do
		local board = workspace.Map.Plaza.LeaderboardBoards:FindFirstChild("LB_" .. lb.id)
		if board then
			local sg = board:FindFirstChild("Board") or Instance.new("SurfaceGui")
			sg.Name = "Board" sg.Face = Enum.NormalId.Front sg.PixelsPerStud = 40 sg.LightInfluence = 0 sg.Parent = board
			sg:ClearAllChildren()
			local bg = Instance.new("Frame") bg.Size = UDim2.fromScale(1, 1) bg.BackgroundColor3 = Color3.fromRGB(25, 22, 45) bg.Parent = sg
			local gr = Instance.new("UIGradient") gr.Color = ColorSequence.new(Color3.fromRGB(70, 50, 140), Color3.fromRGB(20, 18, 40)) gr.Rotation = 90 gr.Parent = bg
			local title = Instance.new("TextLabel") title.Size = UDim2.fromScale(1, 0.14) title.BackgroundTransparency = 1 title.Font = Enum.Font.FredokaOne title.TextScaled = true
			title.Text = lb.icon .. " " .. lb.name title.TextColor3 = Color3.fromRGB(255, 225, 100) title.Parent = bg
			local list = cache[lb.id] or {}
			for i = 1, 10 do
				local row = Instance.new("TextLabel") row.BackgroundTransparency = i % 2 == 0 and 1 or 0.85 row.BackgroundColor3 = Color3.new(1, 1, 1)
				row.Size = UDim2.fromScale(0.94, 0.078) row.Position = UDim2.fromScale(0.03, 0.15 + (i - 1) * 0.082) row.Font = Enum.Font.GothamBold row.TextScaled = true
				row.TextXAlignment = Enum.TextXAlignment.Left
				local e = list[i]
				row.Text = e and ("  #%d  %s  —  %s"):format(i, e.name, Config.FormatNumber(e.value)) or ("  #%d  —"):format(i)
				row.TextColor3 = i == 1 and Color3.fromRGB(255, 215, 60) or i == 2 and Color3.fromRGB(220, 220, 235) or i == 3 and Color3.fromRGB(230, 160, 100) or Color3.new(1, 1, 1)
				row.Parent = bg
			end
			local foot = Instance.new("TextLabel") foot.Size = UDim2.fromScale(1, 0.05) foot.Position = UDim2.fromScale(0, 0.95) foot.BackgroundTransparency = 1 foot.Font = Enum.Font.Gotham foot.TextScaled = true
			foot.Text = scope == "global" and "All servers" or "This server (global boards unavailable)" foot.TextColor3 = Color3.fromRGB(170, 170, 200) foot.Parent = bg
		end
	end
end

function L.Refresh()
	local ok = true
	local fresh = {}
	for _, lb in ipairs(Config.Leaderboards) do
		local st = stores[lb.id]
		if not st then ok = false break end
		local success, pages = pcall(st.GetSortedAsync, st, false, 10)
		if not success then ok = false break end
		local list = {}
		for _, e in ipairs(pages:GetCurrentPage()) do table.insert(list, {name = nameOf(tonumber(e.key)), value = e.value}) end
		fresh[lb.id] = list
	end
	if ok then cache = fresh scope = "global" else cache = localBoards() scope = "server" end
	render()
end

L.Handlers = {
	GetLeaderboards = function(player) return {scope = scope, boards = cache} end,
}

function L.Start()
	task.spawn(function()
		task.wait(8)
		while true do
			for _, p in ipairs(Players:GetPlayers()) do task.spawn(L.Push, p) end
			L.Refresh()
			task.wait(90)
		end
	end)
	Players.PlayerRemoving:Connect(function(p) lastPush[p] = nil end)
end

return L
