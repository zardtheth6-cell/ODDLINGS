-- Daily rewards, Rebirth, Leaderboards, Profile/Titles and Settings interfaces.
local Players = game:GetService("Players")
local Config = require(game.ReplicatedStorage.Shared.Config)
local U = require(script.Parent.UIKit)
local State = require(script.Parent.State)
local C = U.Colors
local P = {}
local H
P.settings = {sfx = 0.7, lowGfx = false, mobile = true}

local function res(r, okText) if r.ok then if okText then H.Notify(okText, "success", "Success") end else H.Notify("❌ " .. (r.msg or "Can't do that"), "fail", "Fail") end end

function P.Init(hud)
	H = hud
	-- DAILY
	do
		local g = H.gui("DailyUI", 5)
		local w = U.window(g, "DAILY REWARDS", "🎁", Color3.fromRGB(255, 120, 190), UDim2.fromOffset(820, 400))
		P.dw = w
		local row = U.new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 200), Parent = w.body}, {U.list(Enum.FillDirection.Horizontal, 8)})
		P.dayCards = {}
		for i, r in ipairs(Config.Daily.rewards) do
			local f = U.card(UDim2.fromOffset(104, 190), C.card, {LayoutOrder = i, Parent = row})
			U.label("Day " .. i, UDim2.new(1, -8, 0, 26), C.text, U.Fonts.title, {Position = UDim2.fromOffset(4, 6), Parent = f})
			local icon = r.bat and "🏏" or r.gems and "💎" or "💵"
			U.label(icon, UDim2.new(1, 0, 0, 60), C.text, U.Fonts.title, {Position = UDim2.fromOffset(0, 40), Parent = f})
			local parts = {}
			if r.cash then table.insert(parts, "$" .. Config.FormatNumber(r.cash)) end
			if r.gems then table.insert(parts, r.gems .. " 💎") end
			if r.bat then table.insert(parts, Config.BatById[r.bat].name) end
			U.label(table.concat(parts, "\n"), UDim2.new(1, -8, 0, 60), C.cash, U.Fonts.body, {Position = UDim2.fromOffset(4, 110), TextWrapped = true, Parent = f})
			P.dayCards[i] = f
		end
		P.dailyInfo = U.label("", UDim2.new(1, 0, 0, 26), C.sub, U.Fonts.body, {Position = UDim2.fromOffset(0, 210), Parent = w.body})
		P.claimBtn = U.button("CLAIM", C.green, UDim2.fromOffset(300, 56), function() res(State.Request("ClaimDaily")) end, {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Parent = w.body})
	end
	-- REBIRTH
	do
		local g = H.gui("RebirthUI", 5)
		local w = U.window(g, "REBIRTH", "🔁", C.purple, UDim2.fromOffset(640, 470))
		P.rw = w
		P.rbInfo = U.new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -80), Text = "", TextWrapped = true, RichText = true, Font = U.Fonts.body, TextSize = 19,
			TextColor3 = C.text, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Parent = w.body})
		local confirm = false
		P.rbBtn = U.button("REBIRTH", C.purple, UDim2.fromOffset(340, 58), function()
			if not confirm then confirm = true U.setButton(P.rbBtn, "⚠ Are you sure? Tap to confirm", true, C.red)
				task.delay(4, function() confirm = false P.RenderRebirth() end) return end
			confirm = false
			res(State.Request("Rebirth"))
			P.RenderRebirth()
		end, {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Parent = w.body})
	end
	-- LEADERBOARDS
	do
		local g = H.gui("LeaderboardUI", 5)
		local w = U.window(g, "LEADERBOARDS", "🏆", C.gold, UDim2.fromOffset(760, 540))
		P.lw = w
		local bar = U.new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 46), Parent = w.body}, {U.list(Enum.FillDirection.Horizontal, 6, Enum.HorizontalAlignment.Left)})
		P.lbTabs = {}
		for i, lb in ipairs(Config.Leaderboards) do
			P.lbTabs[lb.id] = U.button(lb.icon .. " " .. lb.name, C.bg2, UDim2.fromOffset(140, 42), function() P.lbSel = lb.id P.RenderLB() end, {LayoutOrder = i, Parent = bar})
		end
		P.lbList = U.new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -80), Position = UDim2.fromOffset(0, 54), Parent = w.body}, {U.list(nil, 4)})
		P.lbScope = U.label("", UDim2.new(1, 0, 0, 20), C.sub, U.Fonts.body, {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Parent = w.body})
		P.lbSel = "TotalEarned"
	end
	-- PROFILE
	do
		local g = H.gui("ProfileUI", 5)
		local w = U.window(g, "PROFILE & TITLES", "🏷️", Color3.fromRGB(255, 150, 60), UDim2.fromOffset(760, 520))
		P.pw = w
		P.stats = U.label("", UDim2.new(1, 0, 0, 56), C.text, U.Fonts.body, {TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, Parent = w.body})
		local s = U.scroll(w.body, UDim2.new(1, 0, 1, -66), UDim2.fromOffset(0, 64))
		U.new("UIGridLayout", {CellSize = UDim2.fromOffset(230, 120), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = s})
		P.titleGrid = s
	end
	-- SETTINGS
	do
		local g = H.gui("SettingsUI", 5)
		local w = U.window(g, "SETTINGS", "⚙️", C.gray, UDim2.fromOffset(560, 420))
		P.sw = w
		U.list(nil, 12).Parent = w.body
		local function row(text, order)
			local f = U.card(UDim2.new(1, 0, 0, 64), C.card, {LayoutOrder = order, Parent = w.body})
			U.label(text, UDim2.new(0.5, 0, 1, -16), C.text, U.Fonts.title, {Position = UDim2.fromOffset(14, 8), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
			return f
		end
		local f1 = row("🔊 Sound Effects", 1)
		P.sfxLabel = U.label("", UDim2.fromOffset(70, 40), C.text, U.Fonts.title, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -70, 0.5, 0), Parent = f1})
		U.button("−", C.bg2, UDim2.fromOffset(48, 44), function() P.settings.sfx = math.max(0, P.settings.sfx - 0.1) P.ApplySettings(true) end, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -146, 0.5, 0), Parent = f1})
		U.button("+", C.bg2, UDim2.fromOffset(48, 44), function() P.settings.sfx = math.min(1, P.settings.sfx + 0.1) P.ApplySettings(true) end, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Parent = f1})
		local f2 = row("✨ Low Graphics Mode", 2)
		P.gfxBtn = U.button("OFF", C.bg2, UDim2.fromOffset(120, 44), function() P.settings.lowGfx = not P.settings.lowGfx P.ApplySettings(true) end, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Parent = f2})
		local f3 = row("📱 Touch Action Buttons", 3)
		P.mobBtn = U.button("ON", C.bg2, UDim2.fromOffset(120, 44), function() P.settings.mobile = not P.settings.mobile P.ApplySettings(false) end, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0.5, 0), Parent = f3})
		U.label("Controls: Shift = Sprint • Q = Dash • C = Slide • Click = Swing bat • E = Interact", UDim2.new(1, 0, 0, 40), C.sub, U.Fonts.body, {LayoutOrder = 4, TextWrapped = true, Parent = w.body})
	end
	State.Changed:Connect(function(d)
		if P.dw.frame.Visible then P.RenderDaily() end
		if P.rw.frame.Visible then P.RenderRebirth() end
		if P.pw.frame.Visible then P.RenderProfile() end
		if not P.loadedSettings and d.settings then
			P.loadedSettings = true
			P.settings.sfx = d.settings.sfx or 0.7 P.settings.lowGfx = d.settings.lowGfx or false
			P.ApplySettings(false)
		end
	end)
	task.spawn(function() while true do task.wait(1) if P.dw.frame.Visible then P.RenderDaily() end end end)
end

P.onSettings = Instance.new("BindableEvent")
function P.ApplySettings(save)
	P.sfxLabel.Text = math.floor(P.settings.sfx * 100 + 0.5) .. "%"
	P.gfxBtn.Label.Text = P.settings.lowGfx and "ON" or "OFF"
	P.mobBtn.Label.Text = P.settings.mobile and "ON" or "OFF"
	H.sfxVolume = P.settings.sfx
	P.onSettings:Fire(P.settings)
	if save then State.Request("SetSettings", {sfx = P.settings.sfx, lowGfx = P.settings.lowGfx}) end
end

function P.RenderDaily()
	local d = State.data if not d then return end
	local now = State.Now()
	local ready = now - (d.daily.last or 0) >= Config.Daily.cooldown
	local streak = d.daily.streak or 0
	if now - (d.daily.last or 0) > Config.Daily.resetAfter then streak = 0 end
	local nextDay = (streak % #Config.Daily.rewards) + 1
	for i, f in ipairs(P.dayCards) do
		f.BackgroundColor3 = i < nextDay and C.green:Lerp(C.card, 0.5) or i == nextDay and (ready and C.gold or C.blue) or C.card
	end
	if ready then
		P.dailyInfo.Text = ("Streak: %d day(s). Your Day %d reward is ready!"):format(streak, nextDay)
		U.setButton(P.claimBtn, "🎁 CLAIM DAY " .. nextDay, true)
	else
		local left = Config.Daily.cooldown - (now - d.daily.last)
		P.dailyInfo.Text = ("Streak: %d day(s). Come back to keep it going! (Missing 48h resets it)"):format(streak)
		U.setButton(P.claimBtn, ("Next reward in %02d:%02d:%02d"):format(left // 3600, (left % 3600) // 60, left % 60), false)
	end
end

function P.RenderRebirth()
	local d = State.data if not d then return end
	local cost = Config.RebirthCost(d.rebirths)
	P.rbInfo.Text = ("<b>Rebirths:</b> %d   •   <b>Current bonus:</b> +%d%% income\n\n<b>Requirement:</b> $%s cash\n<b>Reward:</b> permanent +%d%% income (total +%d%%) and %d Gems\n\n<font color='#ff8080'><b>Resets:</b></font> cash, movement upgrades, territory unlocks\n<font color='#80ff9a'><b>Keeps:</b></font> all Oddlings, base security, base size, gems, titles, bats and every purchase"):format(
		d.rebirths, d.rebirths * Config.Rebirth.incomeBonus * 100, Config.FormatNumber(cost), Config.Rebirth.incomeBonus * 100, (d.rebirths + 1) * Config.Rebirth.incomeBonus * 100, Config.Rebirth.gems)
	U.setButton(P.rbBtn, d.cash >= cost and "🔁 REBIRTH NOW" or ("Need $" .. Config.FormatNumber(cost)), d.cash >= cost, C.purple)
end

function P.RenderLB()
	for id, b in pairs(P.lbTabs) do b.BackgroundColor3 = id == P.lbSel and C.gold or C.bg2 b:SetAttribute("BaseColor", b.BackgroundColor3) end
	for _, c in ipairs(P.lbList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	local r = State.Request("GetLeaderboards")
	local data = r.ok and r.data
	local list = data and data.boards and data.boards[P.lbSel] or {}
	P.lbScope.Text = data and (data.scope == "global" and "🌍 All servers" or "🖥️ This server (global boards unavailable right now)") or ""
	for i = 1, 10 do
		local e = list[i]
		local f = U.card(UDim2.new(1, -8, 0, 36), i % 2 == 0 and C.bg2 or C.card, {LayoutOrder = i, Parent = P.lbList})
		local col = i == 1 and C.gold or i == 2 and Color3.fromRGB(220, 220, 235) or i == 3 and Color3.fromRGB(230, 160, 100) or C.text
		U.label(("#%d   %s"):format(i, e and e.name or "—"), UDim2.new(0.7, 0, 1, -8), col, U.Fonts.title, {Position = UDim2.fromOffset(12, 4), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
		U.label(e and Config.FormatNumber(e.value) or "", UDim2.new(0.28, 0, 1, -8), C.cash, U.Fonts.title, {Position = UDim2.new(0.7, 0, 0, 4), TextXAlignment = Enum.TextXAlignment.Right, Parent = f})
	end
end

function P.RenderProfile()
	local d = State.data if not d then return end
	P.stats.Text = ("⭐ Level %d   🔁 Rebirths %d   🏴 Raids won %d   🛡️ Raids defended %d   💎 Rare+ collected %d   🏃 Steals %d"):format(d.level, d.rebirths, d.stats.raidsWon, d.stats.raidsDefended, d.stats.rares, d.stats.steals)
	for _, c in ipairs(P.titleGrid:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	for i, t in ipairs(Config.Titles) do
		local have = d.titles[t.id]
		local f = U.card(UDim2.fromOffset(230, 120), C.card, {LayoutOrder = i, Parent = P.titleGrid})
		U.label(t.name, UDim2.new(1, -16, 0, 28), have and t.color or C.gray, U.Fonts.title, {Position = UDim2.fromOffset(8, 8), Parent = f})
		U.label(have and "Unlocked" or ("🔒 " .. t.req), UDim2.new(1, -16, 0, 18), C.sub, U.Fonts.body, {Position = UDim2.fromOffset(8, 38), Parent = f})
		local eq = d.title == t.id
		local b = U.button(eq and "EQUIPPED" or "Equip", C.purple, UDim2.new(1, -16, 0, 40), function() res(State.Request("EquipTitle", t.id)) end, {Position = UDim2.new(0, 8, 1, -48), Parent = f})
		U.setButton(b, nil, have and not eq)
	end
end

function P.Open(name)
	if name == "Daily" then P.dw.open() P.RenderDaily()
	elseif name == "Rebirth" then P.rw.open() P.RenderRebirth()
	elseif name == "Leaderboards" then P.lw.open() P.RenderLB()
	elseif name == "Profile" then P.pw.open() P.RenderProfile()
	elseif name == "Settings" then P.sw.open() P.ApplySettings(false) end
end

return P
