-- Main HUD, notifications, carry HUD, raid HUD, event banner and intruder warnings.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Remotes = game.ReplicatedStorage.Remotes
local U = require(script.Parent.UIKit)
local State = require(script.Parent.State)
local player = Players.LocalPlayer
local H = {}
local C = U.Colors

local function gui(name, order)
	local g = Instance.new("ScreenGui") g.Name = name g.ResetOnSpawn = false g.IgnoreGuiInset = false g.DisplayOrder = order or 1
	g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling g.Parent = player:WaitForChild("PlayerGui")
	local sc = Instance.new("UIScale") sc.Name = "AutoScale" sc.Parent = g
	local function fit()
		local vp = workspace.CurrentCamera.ViewportSize
		sc.Scale = math.clamp(math.min(vp.X / 1280, vp.Y / 760), 0.55, 1.25)
	end
	fit() workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit)
	return g
end
H.gui = gui

function H.PlaySound(id, vol)
	local sid = Config.Sounds[id] if not sid then return end
	local s = Instance.new("Sound") s.SoundId = sid s.Volume = (vol or 0.6) * (H.sfxVolume or 0.7) s.Parent = SoundService
	s:Play() s.Ended:Connect(function() s:Destroy() end)
end

function H.Init(openPanel)
	H.openPanel = openPanel
	local main = gui("MainHUD", 2)
	H.main = main
	-- Currency stack ------------------------------------------------------------
	local stack = U.new("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(250, 170), Position = UDim2.fromOffset(14, 10), Parent = main}, {U.list(nil, 8, Enum.HorizontalAlignment.Left)})
	local function pill(icon, color, order)
		local f = U.card(UDim2.fromOffset(240, 46), C.bg, {LayoutOrder = order, Parent = stack})
		U.grad(C.bg2, C.bg).Parent = f
		local ic = U.new("Frame", {Size = UDim2.fromOffset(46, 46), BackgroundColor3 = color, Parent = f}, {U.corner(14)})
		U.label(icon, UDim2.fromScale(0.8, 0.8), C.text, U.Fonts.title, {Position = UDim2.fromScale(0.1, 0.1), Parent = ic})
		local val = U.label("0", UDim2.new(1, -60, 0, 30), C.text, U.Fonts.title, {Position = UDim2.fromOffset(54, 3), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
		local sub = U.label("", UDim2.new(1, -60, 0, 12), color, U.Fonts.body, {Position = UDim2.fromOffset(54, 29), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
		return val, sub, f
	end
	H.cashVal, H.cashSub = pill("💵", C.green, 1)
	H.gemVal, H.gemSub = pill("💎", C.blue, 2)
	H.lvlVal, H.lvlSub, H.lvlFrame = pill("⭐", C.gold, 3)
	local xpBar = U.new("Frame", {Size = UDim2.new(1, -62, 0, 4), Position = UDim2.new(0, 54, 1, -5), BackgroundColor3 = Color3.fromRGB(20, 18, 40), Parent = H.lvlFrame}, {U.corner(3)})
	H.xpFill = U.new("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.gold, Parent = xpBar}, {U.corner(3)})
	-- Territory indicator ------------------------------------------------------------
	H.terr = U.card(UDim2.fromOffset(260, 40), C.bg, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8), Parent = main})
	H.terrLabel = U.label("🏝️ Oddling Island", UDim2.new(1, -16, 1, -8), C.text, U.Fonts.title, {Position = UDim2.fromOffset(8, 4), Parent = H.terr})
	-- Menu buttons (left) ------------------------------------------------------------
	local menu = U.new("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(170, 420), Position = UDim2.new(0, 14, 0, 190), Parent = main})
	U.new("UIGridLayout", {CellSize = UDim2.fromOffset(78, 78), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = menu})
	local items = {
		{"Shop", "🛒", C.green}, {"Upgrades", "⚡", C.blue}, {"Collection", "📖", Color3.fromRGB(40, 190, 180)}, {"Base", "🏠", C.accent},
		{"Security", "🛡️", Color3.fromRGB(90, 110, 255)}, {"Daily", "🎁", Color3.fromRGB(255, 120, 190)}, {"Rebirth", "🔁", C.purple},
		{"Leaderboards", "🏆", C.gold}, {"Profile", "🏷️", Color3.fromRGB(255, 150, 60)}, {"Settings", "⚙️", C.gray},
	}
	H.menuButtons = {}
	for i, it in ipairs(items) do
		local b = U.button("", it[3], UDim2.fromOffset(78, 78), function() openPanel(it[1]) end, {LayoutOrder = i, Parent = menu})
		b.Label.Text = it[2] b.Label.Size = UDim2.new(1, -10, 0.6, 0) b.Label.Position = UDim2.fromOffset(5, 4)
		U.label(it[1], UDim2.new(1, -4, 0.28, 0), C.text, U.Fonts.title, {Position = UDim2.new(0, 2, 0.68, 0), Parent = b}).TextStrokeTransparency = 0.3
		local dot = U.new("Frame", {Name = "Dot", Size = UDim2.fromOffset(18, 18), Position = UDim2.new(1, -14, 0, -4), BackgroundColor3 = C.red, Visible = false, Parent = b}, {U.corner(9), U.stroke(Color3.new(1, 1, 1), 2)})
		H.menuButtons[it[1]] = b
	end
	-- Stamina bar --------------------------------------------------------------------
	local sb = U.card(UDim2.fromOffset(340, 26), C.bg, {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -20), Parent = main})
	H.staminaFill = U.new("Frame", {Size = UDim2.new(1, -8, 1, -8), Position = UDim2.fromOffset(4, 4), BackgroundColor3 = Color3.fromRGB(80, 230, 255), Parent = sb}, {U.corner(10), U.grad(Color3.fromRGB(120, 255, 200), Color3.fromRGB(60, 170, 255), 0)})
	H.staminaText = U.label("⚡ STAMINA", UDim2.new(1, 0, 1, -6), C.text, U.Fonts.title, {Position = UDim2.fromOffset(0, 3), Parent = sb})
	H.staminaText.TextStrokeTransparency = 0.2
	H.staminaFrame = sb
	H.hint = U.label("", UDim2.fromOffset(600, 20), C.sub, U.Fonts.body, {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -50), Parent = main, TextStrokeTransparency = 0.4})
	-- Carry panel --------------------------------------------------------------------
	local cp = U.card(UDim2.fromOffset(300, 120), C.bg, {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 70), Visible = false, Parent = main})
	U.grad(C.bg2, C.bg).Parent = cp
	H.carryPanel = cp
	H.carryTitle = U.label("CARRYING", UDim2.new(1, -20, 0, 18), C.sub, U.Fonts.title, {Position = UDim2.fromOffset(10, 6), TextXAlignment = Enum.TextXAlignment.Left, Parent = cp})
	H.carryName = U.label("", UDim2.new(1, -20, 0, 30), C.text, U.Fonts.title, {Position = UDim2.fromOffset(10, 24), TextXAlignment = Enum.TextXAlignment.Left, Parent = cp})
	H.carryRarity = U.label("", UDim2.new(1, -20, 0, 18), C.text, U.Fonts.title, {Position = UDim2.fromOffset(10, 54), TextXAlignment = Enum.TextXAlignment.Left, Parent = cp})
	H.carryInfo = U.label("", UDim2.new(1, -20, 0, 36), C.sub, U.Fonts.body, {Position = UDim2.fromOffset(10, 76), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Parent = cp})
	-- Raid banner --------------------------------------------------------------------
	local rb = U.card(UDim2.fromOffset(520, 96), C.red, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 56), Visible = false, Parent = main})
	U.grad(Color3.fromRGB(255, 80, 80), Color3.fromRGB(150, 20, 40)).Parent = rb
	H.raidBanner = rb
	H.raidTitle = U.label("", UDim2.new(1, -20, 0, 36), C.text, U.Fonts.title, {Position = UDim2.fromOffset(10, 6), Parent = rb})
	H.raidTitle.TextStrokeTransparency = 0
	H.raidSub = U.label("", UDim2.new(1, -20, 0, 22), C.text, U.Fonts.body, {Position = UDim2.fromOffset(10, 42), Parent = rb})
	H.raidTimer = U.label("", UDim2.new(1, -20, 0, 26), Color3.fromRGB(255, 240, 120), U.Fonts.title, {Position = UDim2.fromOffset(10, 66), Parent = rb})
	-- Event banner -----------------------------------------------------------------------
	local eb = U.card(UDim2.fromOffset(460, 70), C.purple, {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 160), Visible = false, Parent = main})
	U.grad(Color3.fromRGB(180, 100, 255), Color3.fromRGB(90, 40, 200)).Parent = eb
	H.eventBanner = eb
	H.eventTitle = U.label("", UDim2.new(1, -20, 0, 30), C.text, U.Fonts.title, {Position = UDim2.fromOffset(10, 4), Parent = eb})
	H.eventDesc = U.label("", UDim2.new(1, -20, 0, 30), C.text, U.Fonts.body, {Position = UDim2.fromOffset(10, 36), TextWrapped = true, Parent = eb})
	-- Shield / protection chip ---------------------------------------------------------------
	H.shieldChip = U.card(UDim2.fromOffset(240, 34), Color3.fromRGB(60, 140, 255), {AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -14, 1, -240), Visible = false, Parent = main})
	H.shieldText = U.label("", UDim2.new(1, -12, 1, -6), C.text, U.Fonts.title, {Position = UDim2.fromOffset(6, 3), Parent = H.shieldChip})
	-- Notifications -----------------------------------------------------------------------
	local ng = gui("NotificationsUI", 10)
	H.notifHolder = U.new("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Size = UDim2.fromOffset(380, 400), Position = UDim2.new(1, -14, 0, 200), Parent = ng}, {U.list(nil, 6, Enum.HorizontalAlignment.Right)})
	H.flash = U.new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(255, 0, 0), BackgroundTransparency = 1, Parent = ng})
	H.flash.Size = UDim2.new(1, 0, 1, 60) H.flash.Position = UDim2.fromOffset(0, -60)

	State.Changed:Connect(H.Refresh)
	player:GetAttributeChangedSignal("Cash"):Connect(H.RefreshCurrency)
	player:GetAttributeChangedSignal("Gems"):Connect(H.RefreshCurrency)
	player:GetAttributeChangedSignal("Income"):Connect(H.RefreshCurrency)
	player:GetAttributeChangedSignal("Territory"):Connect(H.RefreshTerritory)
	Remotes.Notify.OnClientEvent:Connect(function(n) H.Notify(n.text, n.kind, n.sound) end)
	Remotes.CarryState.OnClientEvent:Connect(H.SetCarry)
	Remotes.Raid.OnClientEvent:Connect(H.SetRaid)
	Remotes.WorldEvent.OnClientEvent:Connect(H.OnEvent)
	Remotes.Intruder.OnClientEvent:Connect(H.OnIntruder)
	RunService.RenderStepped:Connect(H.Tick)
	H.RefreshCurrency()
end

local kindColors = {warn = Color3.fromRGB(255, 170, 40), fail = U.Colors.red, success = U.Colors.green, raid = U.Colors.red, purchase = U.Colors.blue,
	reward = U.Colors.gold, level = U.Colors.gold, carry = U.Colors.accent, shield = Color3.fromRGB(80, 160, 255), title = U.Colors.purple, discover = Color3.fromRGB(40, 190, 180), unlock = U.Colors.green, rebirth = U.Colors.purple}
function H.Notify(text, kind, sound)
	local col = kindColors[kind] or U.Colors.card
	local f = U.card(UDim2.fromOffset(370, 0), U.Colors.bg, {AutomaticSize = Enum.AutomaticSize.Y, Parent = H.notifHolder, ClipsDescendants = false})
	U.new("Frame", {Size = UDim2.new(0, 8, 1, 0), BackgroundColor3 = col, Parent = f}, {U.corner(4)})
	local l = U.new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -26, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.fromOffset(18, 0), Text = text, TextWrapped = true,
		Font = U.Fonts.body, TextSize = 17, TextColor3 = U.Colors.text, TextXAlignment = Enum.TextXAlignment.Left, Parent = f}, {U.new("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})})
	local sc = U.new("UIScale", {Scale = 0.5, Parent = f})
	TweenService:Create(sc, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Scale = 1}):Play()
	if sound then H.PlaySound(sound, 0.6) end
	if #H.notifHolder:GetChildren() > 7 then for _, c in ipairs(H.notifHolder:GetChildren()) do if c:IsA("Frame") then c:Destroy() break end end end
	task.delay(kind == "raid" and 7 or 4.5, function()
		if f.Parent then
			local tw = TweenService:Create(sc, TweenInfo.new(0.2), {Scale = 0}) tw:Play() tw.Completed:Wait() f:Destroy()
		end
	end)
end

function H.Flash(color, alpha, time)
	H.flash.BackgroundColor3 = color H.flash.BackgroundTransparency = alpha or 0.6
	TweenService:Create(H.flash, TweenInfo.new(time or 0.6), {BackgroundTransparency = 1}):Play()
end

local shownCash = 0
function H.RefreshCurrency()
	local cash = player:GetAttribute("Cash") or 0
	local inc = player:GetAttribute("Income") or 0
	if cash > shownCash and cash - shownCash > inc * 1.5 + 5 then
		local sc = H.cashVal
		TweenService:Create(sc, TweenInfo.new(0.1), {TextColor3 = U.Colors.cash}):Play()
		task.delay(0.25, function() TweenService:Create(sc, TweenInfo.new(0.3), {TextColor3 = U.Colors.text}):Play() end)
	end
	shownCash = cash
	H.cashVal.Text = "$" .. Config.FormatNumber(cash)
	H.cashSub.Text = "+$" .. Config.FormatNumber(inc) .. "/s income"
	H.gemVal.Text = Config.FormatNumber(player:GetAttribute("Gems") or 0)
	H.gemSub.Text = "Gems"
end

function H.RefreshTerritory()
	local t = player:GetAttribute("Territory") or "Wilds"
	local def = Config.TerritoryById[t]
	local names = {Plaza = "🏛️ Oddling Plaza • Safe Zone", Wilds = "🏝️ Oddling Island", Visitor = "✨ Rare Visitor"}
	local icons = {Mushroom = "🍄 ", Frostbite = "❄️ ", Molten = "🌋 ", Cosmic = "🌌 "}
	local plot = workspace.Bases:FindFirstChild(State.data and State.data.plot or "")
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	local text = def and (icons[t] .. def.name) or names[t] or "🏝️ Oddling Island"
	if root then
		for _, p in ipairs(workspace.Bases:GetChildren()) do
			local fl = p:FindFirstChild("Floor")
			local lp = fl and fl.CFrame:PointToObjectSpace(root.Position)
			if lp and math.abs(lp.X) < 44 and math.abs(lp.Z) < 44 then
				text = p == plot and "🏠 Your Base" or ("🏠 " .. (p:GetAttribute("OwnerName") or "Empty") .. "'s Base")
			end
		end
	end
	H.terrLabel.Text = text
	H.terr.BackgroundColor3 = def and def.color:Lerp(Color3.new(0, 0, 0), 0.4) or U.Colors.bg
end

function H.Refresh(d)
	H.lvlVal.Text = "Level " .. d.level
	H.lvlSub.Text = ("%s / %s XP"):format(Config.FormatNumber(d.xp), Config.FormatNumber(d.xpNext))
	H.xpFill.Size = UDim2.fromScale(math.clamp(d.xp / d.xpNext, 0, 1), 1)
	-- daily dot
	local dailyReady = State.Now() - (d.daily.last or 0) >= Config.Daily.cooldown
	H.menuButtons.Daily.Dot.Visible = dailyReady
	H.menuButtons.Rebirth.Dot.Visible = d.cash >= Config.RebirthCost(d.rebirths)
	H.RefreshCurrency()
end

H.carry = nil
function H.SetCarry(info)
	H.carry = info
	H.carryPanel.Visible = info ~= nil
	if H.beam then H.beam:Destroy() H.beam = nil end
	if H.beamA0 then H.beamA0:Destroy() H.beamA0 = nil end
	if H.beamPart then H.beamPart:Destroy() H.beamPart = nil end
	if not info then return end
	local r = Config.RarityById[info.rarity]
	H.carryTitle.Text = info.kind == "raid" and "🏴 RAIDED ODDLING" or "🏃 CARRYING"
	H.carryName.Text = (info.golden and "✨ Golden " or "") .. info.name
	H.carryRarity.Text = r.label H.carryRarity.TextColor3 = r.color
	H.carryInfo.Text = ("-%d%% speed • Run to the green DROP ZONE at your base! Bat hits and guardians make you drop it."):format(math.floor((info.penalty or 0) * 100))
	-- guide beam to the drop zone
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root and info.dest then
		local p = Instance.new("Part") p.Anchored = true p.CanCollide = false p.CanQuery = false p.Transparency = 1 p.Size = Vector3.one p.Position = info.dest + Vector3.new(0, 2, 0) p.Parent = workspace.CurrentCamera
		local a1 = Instance.new("Attachment", p)
		local a0 = Instance.new("Attachment", root) a0.Position = Vector3.new(0, -2.5, 0)
		local b = Instance.new("Beam") b.Attachment0 = a0 b.Attachment1 = a1 b.Color = ColorSequence.new(Color3.fromRGB(80, 255, 140)) b.Width0 = 1.2 b.Width1 = 1.2
		b.FaceCamera = true b.LightEmission = 1 b.Transparency = NumberSequence.new(0.4) b.Texture = "rbxasset://textures/particles/sparkles_main.dds" b.TextureSpeed = 2 b.TextureLength = 4 b.Segments = 20 b.Parent = p
		H.beam, H.beamA0, H.beamPart = b, a0, p
	end
end

H.raid = nil
function H.SetRaid(info)
	if info.role == "none" then H.raid = nil H.raidBanner.Visible = false return end
	H.raid = info
	H.raidBanner.Visible = true
	if info.role == "defender" then
		H.raidTitle.Text = "🚨 YOUR BASE IS BEING RAIDED! 🚨"
		H.raidSub.Text = info.thief .. " took your " .. info.creature .. " — hit them with your bat!"
		H.Flash(Color3.fromRGB(255, 0, 0), 0.4, 1)
	else
		H.raidTitle.Text = "🏴 RAIDING " .. string.upper(info.owner) .. "'S BASE"
		H.raidSub.Text = "Carry " .. info.creature .. " to YOUR base drop zone!"
	end
end

function H.OnEvent(ev)
	if ev.id == "End" then H.eventBanner.Visible = false H.event = nil return end
	if ev.id == "Info" then H.Notify(ev.text, "reward", "Event") return end
	H.event = ev
	H.eventBanner.Visible = true
	H.eventTitle.Text = "⚡ " .. ev.name .. " ⚡"
	H.eventDesc.Text = ev.desc
	H.PlaySound("Event", 1)
	H.Notify("🌟 WORLD EVENT: " .. ev.name, "reward")
end

local intruderMarks = {}
function H.OnIntruder(info)
	if info.kind == "enter" then
		local msg
		if info.reason == "raid" then return end
		if info.detect >= 3 then msg = "⚠ " .. info.name .. " entered your base!" .. (info.extra or "") else msg = "⚠ An intruder entered your base!" end
		H.Notify(msg, "warn", info.alarm >= 2 and "Alarm" or nil)
		if info.alarm >= 4 then H.Flash(Color3.fromRGB(255, 40, 40), 0.5, 0.8) end
		if info.alarm >= 5 then H.Flash(Color3.fromRGB(255, 0, 0), 0.25, 2) end
	elseif info.kind == "laser" then
		H.Notify("🔴 Your lasers zapped " .. info.name .. "!", "success")
	elseif info.kind == "leave" then
		local m = intruderMarks[info.userId] if m then m:Destroy() intruderMarks[info.userId] = nil end
	elseif info.kind == "pos" then
		local other = Players:GetPlayerByUserId(info.userId)
		if other and other.Character then
			local m = intruderMarks[info.userId]
			if not m or not m.Parent then
				if info.detect >= 5 then
					m = Instance.new("Highlight") m.FillColor = Color3.fromRGB(255, 50, 50) m.OutlineColor = Color3.new(1, 1, 1) m.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					m.Adornee = other.Character m.Parent = workspace.CurrentCamera
				else
					m = Instance.new("BillboardGui") m.Size = UDim2.fromOffset(60, 60) m.AlwaysOnTop = true m.StudsOffset = Vector3.new(0, 5, 0)
					m.Adornee = other.Character:FindFirstChild("Head") m.Parent = workspace.CurrentCamera
					U.label("❗", UDim2.fromScale(1, 1), U.Colors.red, U.Fonts.title, {Parent = m})
				end
				intruderMarks[info.userId] = m
				task.delay(3, function() if intruderMarks[info.userId] == m then m:Destroy() intruderMarks[info.userId] = nil end end)
			end
		end
	end
end

function H.Tick()
	local now = workspace:GetServerTimeNow()
	if H.raid and H.raid.endT then
		local left = math.max(0, H.raid.endT - now)
		H.raidTimer.Text = ("⏱ %.1fs"):format(left)
		H.raidTimer.TextColor3 = left < 8 and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 240, 120)
	end
	if H.event and H.event.endT then
		local left = math.max(0, H.event.endT - now)
		H.eventTitle.Text = ("⚡ %s  •  %d:%02d"):format(H.event.name, left // 60, left % 60)
	end
	local d = State.data
	if d and d.shieldUntil and d.shieldUntil > State.Now() then
		H.shieldChip.Visible = true
		H.shieldText.Text = ("🛡️ Base Shield: %ds"):format(d.shieldUntil - State.Now())
	else
		H.shieldChip.Visible = false
	end
	if H.carry and H.beamPart and player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			local dist = (root.Position - H.beamPart.Position).Magnitude
			H.carryTitle.Text = (H.carry.kind == "raid" and "🏴 RAIDED ODDLING" or "🏃 CARRYING") .. ("  •  %dm to base"):format(dist)
		end
	end
end

return H
