-- Shop (Upgrades / Gamepasses / Items) and Security interfaces. Every button calls the server.
local Players = game:GetService("Players")
local Config = require(game.ReplicatedStorage.Shared.Config)
local U = require(script.Parent.UIKit)
local State = require(script.Parent.State)
local C = U.Colors
local Shop = {}
local H

local function result(res, okText)
	if res.ok then if okText then H.Notify(okText, "purchase", "Purchase") end
	else H.Notify("❌ " .. (res.msg or "Can't do that"), "fail", "Fail") end
end

local function itemCard(parent, order, icon, title, desc, accent)
	local f = U.card(UDim2.fromOffset(236, 210), C.card, {LayoutOrder = order, Parent = parent})
	U.grad(accent:Lerp(C.card, 0.55), C.card).Parent = f
	local ic = U.new("Frame", {Size = UDim2.fromOffset(62, 62), Position = UDim2.fromOffset(12, 12), BackgroundColor3 = accent, Parent = f}, {U.corner(16), U.stroke(Color3.new(1, 1, 1), 2, 0.5)})
	U.label(icon, UDim2.fromScale(0.8, 0.8), C.text, U.Fonts.title, {Position = UDim2.fromScale(0.1, 0.1), Parent = ic})
	local t = U.label(title, UDim2.new(1, -90, 0, 30), C.text, U.Fonts.title, {Position = UDim2.fromOffset(82, 12), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
	local sub = U.label("", UDim2.new(1, -90, 0, 22), C.sub, U.Fonts.body, {Name = "Sub", Position = UDim2.fromOffset(82, 46), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
	U.new("TextLabel", {BackgroundTransparency = 1, Size = UDim2.new(1, -24, 0, 60), Position = UDim2.fromOffset(12, 82), Text = desc, TextWrapped = true, Font = U.Fonts.body, TextSize = 15,
		TextColor3 = C.sub, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, Name = "Desc", Parent = f})
	return f, sub
end

local function grid(parent)
	local s = U.scroll(parent, UDim2.new(1, 0, 1, -64), UDim2.fromOffset(0, 60))
	U.new("UIGridLayout", {CellSize = UDim2.fromOffset(236, 210), CellPadding = UDim2.fromOffset(12, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = s})
	U.pad(6).Parent = s
	return s
end

function Shop.Init(hud)
	H = hud
	local g = H.gui("ShopUI", 5)
	local w = U.window(g, "SHOP", "🛒", C.green, UDim2.fromOffset(800, 560))
	Shop.w = w
	local tabs = {}
	local pages = {}
	local tabBar = U.new("Frame", {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 50), Parent = w.body}, {U.list(Enum.FillDirection.Horizontal, 10, Enum.HorizontalAlignment.Left)})
	local function select(name)
		for n, p in pairs(pages) do p.Visible = n == name end
		for n, b in pairs(tabs) do b.BackgroundColor3 = n == name and C.accent or C.bg2 b:SetAttribute("BaseColor", b.BackgroundColor3) end
		Shop.tab = name
		Shop.Render()
	end
	for i, t in ipairs({{"Upgrades", "⚡ Upgrades"}, {"Gamepasses", "👑 Gamepasses"}, {"Items", "🧪 Items"}}) do
		tabs[t[1]] = U.button(t[2], C.bg2, UDim2.fromOffset(200, 46), function() select(t[1]) end, {LayoutOrder = i, Parent = tabBar})
		pages[t[1]] = grid(w.body)
	end
	Shop.pages = pages
	Shop.select = select
	-- Security window
	local sg = H.gui("SecurityUI", 5)
	local sw = U.window(sg, "BASE SECURITY", "🛡️", Color3.fromRGB(90, 110, 255), UDim2.fromOffset(800, 560))
	Shop.sw = sw
	Shop.secList = U.scroll(sw.body, UDim2.new(1, 0, 1, -70), UDim2.new())
	U.list(nil, 10).Parent = Shop.secList
	U.pad(4).Parent = Shop.secList
	Shop.shieldBtn = U.button("🛡️ Activate Shield", Color3.fromRGB(60, 140, 255), UDim2.new(1, 0, 0, 56), function()
		local res = State.Request("ActivateShield") result(res)
	end, {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Parent = sw.body})
	State.Changed:Connect(function() if w.frame.Visible then Shop.Render() end if sw.frame.Visible then Shop.RenderSecurity() end end)
	task.spawn(function() while true do task.wait(1) if sw.frame.Visible then Shop.RenderSecurity() end end end)
end

function Shop.Open(tab) Shop.w.open() Shop.select(tab or Shop.tab or "Upgrades") end
function Shop.OpenSecurity() Shop.sw.open() Shop.RenderSecurity() end

function Shop.Render()
	local d = State.data
	if not d then return end
	local page = Shop.pages[Shop.tab]
	for _, c in ipairs(page:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	local order = 0
	local function nxt() order += 1 return order end
	if Shop.tab == "Upgrades" then
		for _, u in ipairs(Config.Upgrades) do
			local lvl = d.upgrades[u.id]
			local f, sub = itemCard(page, nxt(), u.icon, u.name, u.desc, C.blue)
			sub.Text = ("Level %d / %d"):format(lvl, u.max)
			local maxed = lvl >= u.max
			local cost = maxed and 0 or Config.UpgradeCost(u.id, lvl)
			local b = U.button(maxed and "MAXED" or ("$" .. Config.FormatNumber(cost)), C.green, UDim2.new(1, -24, 0, 46), function()
				result(State.Request("BuyUpgrade", u.id))
			end, {Position = UDim2.new(0, 12, 1, -56), Parent = f})
			U.setButton(b, nil, not maxed and d.cash >= cost)
			if not maxed and d.cash < cost then b.Label.Text = "$" .. Config.FormatNumber(cost) .. " 🔒" end
		end
		-- capacity
		do
			local f, sub = itemCard(page, nxt(), "🧱", "Base Expansion", "+2 collection & display slots at your base.", C.accent)
			local maxed = d.baseCapacity >= Config.Capacity.max
			sub.Text = ("Capacity %d (max %d)"):format(d.capacity, Config.Capacity.max)
			local cost = maxed and 0 or Config.CapacityCost(d.baseCapacity)
			local b = U.button(maxed and "MAXED" or ("$" .. Config.FormatNumber(cost)), C.green, UDim2.new(1, -24, 0, 46), function() result(State.Request("BuyCapacity")) end, {Position = UDim2.new(0, 12, 1, -56), Parent = f})
			U.setButton(b, nil, not maxed and d.cash >= cost)
		end
		for _, t in ipairs(Config.Territories) do
			if t.cost > 0 then
				local f, sub = itemCard(page, nxt(), ({Frostbite = "❄️", Molten = "🌋", Cosmic = "🌌"})[t.id], t.name, ("Unlock a new territory with rarer Oddlings. Requires level %d."):format(t.level), t.color)
				local owned = d.territories[t.id]
				sub.Text = owned and "✅ Unlocked" or ("🔒 Level " .. t.level)
				local b = U.button(owned and "UNLOCKED" or ("$" .. Config.FormatNumber(t.cost)), C.green, UDim2.new(1, -24, 0, 46), function() result(State.Request("UnlockTerritory", t.id)) end, {Position = UDim2.new(0, 12, 1, -56), Parent = f})
				U.setButton(b, nil, not owned and d.cash >= t.cost and d.level >= t.level)
			end
		end
	elseif Shop.tab == "Gamepasses" then
		for _, p in ipairs(Config.GamePasses) do
			local f, sub = itemCard(page, nxt(), p.icon, p.name, p.desc, C.gold)
			local owned = d.passes[p.id]
			local configured = p.assetId and p.assetId > 0
			sub.Text = "Permanent • Robux"
			local b = U.button(owned and "✅ OWNED" or configured and ("R$ " .. p.robux) or "Coming soon", C.robux, UDim2.new(1, -24, 0, 46), function() result(State.Request("PromptPass", p.id)) end, {Position = UDim2.new(0, 12, 1, -56), Parent = f})
			U.setButton(b, nil, not owned and configured)
		end
		for _, p in ipairs(Config.Products) do
			local f, sub = itemCard(page, nxt(), p.icon, p.name, p.desc, Color3.fromRGB(80, 200, 120))
			local configured = p.assetId and p.assetId > 0
			sub.Text = "Robux purchase"
			local b = U.button(configured and ("R$ " .. p.robux) or "Coming soon", C.robux, UDim2.new(1, -24, 0, 46), function() result(State.Request("PromptProduct", p.id)) end, {Position = UDim2.new(0, 12, 1, -56), Parent = f})
			U.setButton(b, nil, configured)
		end
	elseif Shop.tab == "Items" then
		for _, it in ipairs(Config.Items) do
			if it.id ~= "Capacity" then
				local f, sub = itemCard(page, nxt(), it.icon, it.name, it.desc, U.currencyColor(it.currency))
				sub.Text = it.currency == "Gems" and "Gem item" or "Cash item"
				local have = it.currency == "Gems" and d.gems or d.cash
				local b = U.button(U.priceText(it.price, it.currency), it.currency == "Gems" and C.blue or C.green, UDim2.new(1, -24, 0, 46), function() result(State.Request("BuyItem", it.id)) end, {Position = UDim2.new(0, 12, 1, -56), Parent = f})
				U.setButton(b, nil, have >= it.price)
			end
		end
		for _, bat in ipairs(Config.Bats) do
			local f, sub = itemCard(page, nxt(), "🏏", bat.name, "Cosmetic only — every bat has the same power, range and cooldown.", bat.color)
			local owned = d.bats[bat.id]
			local equipped = d.bat == bat.id
			sub.Text = owned and (equipped and "Equipped" or "Owned") or U.priceText(bat.price, bat.currency)
			local text = equipped and "EQUIPPED" or owned and "Equip" or U.priceText(bat.price, bat.currency)
			local b = U.button(text, owned and C.purple or C.blue, UDim2.new(1, -24, 0, 46), function()
				if owned then result(State.Request("EquipBat", bat.id)) else result(State.Request("BuyBat", bat.id)) end
			end, {Position = UDim2.new(0, 12, 1, -56), Parent = f})
			U.setButton(b, nil, not equipped and (owned or d.gems >= bat.price))
		end
	end
end

function Shop.RenderSecurity()
	local d = State.data
	if not d then return end
	local list = Shop.secList
	for _, c in ipairs(list:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	local function effect(cat, lvl)
		local s = Config.Security[cat]
		if lvl <= 0 then return "Not installed" end
		if cat == "Door" then return ("%s • %.1fs to break in"):format(s.names[lvl], s.breach[lvl]) end
		if cat == "Alarm" then return s.names[lvl] end
		if cat == "Laser" then return ("%d beam(s) • %d%% slow for %.1fs"):format(s.beams[lvl], s.slow[lvl] * 100, s.duration[lvl]) end
		if cat == "Shield" then return ("%ds shield • %ds recharge"):format(s.duration[lvl], s.cooldown) end
		if cat == "Detect" then return s.names[lvl] .. (s.range[lvl] > 0 and (" • +" .. s.range[lvl] .. " studs") or "") end
	end
	for i, cat in ipairs(Config.SecurityOrder) do
		local s = Config.Security[cat]
		local lvl = d.security[cat]
		local f = U.card(UDim2.new(1, -10, 0, 96), C.card, {LayoutOrder = i, Parent = list})
		local ic = U.new("Frame", {Size = UDim2.fromOffset(72, 72), Position = UDim2.fromOffset(12, 12), BackgroundColor3 = Color3.fromRGB(90, 110, 255), Parent = f}, {U.corner(16)})
		U.label(s.icon, UDim2.fromScale(0.8, 0.8), C.text, U.Fonts.title, {Position = UDim2.fromScale(0.1, 0.1), Parent = ic})
		U.label(s.name, UDim2.new(0, 260, 0, 28), C.text, U.Fonts.title, {Position = UDim2.fromOffset(96, 8), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
		local pips = U.new("Frame", {BackgroundTransparency = 1, Size = UDim2.fromOffset(160, 14), Position = UDim2.fromOffset(360, 16), Parent = f}, {U.list(Enum.FillDirection.Horizontal, 4, Enum.HorizontalAlignment.Left)})
		for k = 1, s.max do U.new("Frame", {Size = UDim2.fromOffset(26, 12), BackgroundColor3 = k <= lvl and C.green or Color3.fromRGB(30, 26, 60), LayoutOrder = k, Parent = pips}, {U.corner(6)}) end
		U.label("Now: " .. effect(cat, lvl), UDim2.new(0, 470, 0, 22), C.cash, U.Fonts.body, {Position = UDim2.fromOffset(96, 40), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
		local maxed = lvl >= s.max
		U.label(maxed and "Fully upgraded!" or ("Next: " .. effect(cat, lvl + 1)), UDim2.new(0, 470, 0, 20), C.sub, U.Fonts.body, {Position = UDim2.fromOffset(96, 64), TextXAlignment = Enum.TextXAlignment.Left, Parent = f})
		local cost = maxed and 0 or s.costs[lvl + 1]
		local b = U.button(maxed and "MAXED" or ("$" .. Config.FormatNumber(cost)), C.green, UDim2.fromOffset(170, 52), function()
			local res = State.Request("BuySecurity", cat) result(res)
		end, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0), Parent = f})
		U.setButton(b, nil, not maxed and d.cash >= cost)
	end
	local now = State.Now()
	if d.security.Shield <= 0 then U.setButton(Shop.shieldBtn, "🛡️ Buy a Base Shield to activate", false)
	elseif (d.shieldUntil or 0) > now then U.setButton(Shop.shieldBtn, ("🛡️ Shield active: %ds left"):format(d.shieldUntil - now), false)
	elseif (d.shieldReadyAt or 0) > now then U.setButton(Shop.shieldBtn, ("🛡️ Recharging: %ds"):format(d.shieldReadyAt - now), false)
	else U.setButton(Shop.shieldBtn, "🛡️ ACTIVATE SHIELD (" .. Config.Security.Shield.duration[d.security.Shield] .. "s)", true) end
end

return Shop
