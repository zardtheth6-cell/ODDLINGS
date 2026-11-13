-- Collection index (uses the shared creature definitions + the same model builder) and the Base interface.
local Config = require(game.ReplicatedStorage.Shared.Config)
local Builder = require(game.ReplicatedStorage.Shared.CreatureBuilder)
local U = require(script.Parent.UIKit)
local State = require(script.Parent.State)
local C = U.Colors
local Col = {}
local H
local viewports = {}

local function viewport(parent, id, silhouette)
	local vf = U.new("ViewportFrame", {Size = UDim2.new(1, -16, 0, 120), Position = UDim2.fromOffset(8, 8), BackgroundColor3 = Color3.fromRGB(20, 18, 40), Ambient = Color3.fromRGB(200, 200, 220), LightColor = Color3.new(1, 1, 1), LightDirection = Vector3.new(-1, -1, -1), Parent = parent}, {U.corner(12)})
	local m = Builder.BuildCreature(id)
	if silhouette then Builder.Silhouette(m) end
	m:RemoveTag("Oddling")
	for _, d in ipairs(m:GetDescendants()) do if d:IsA("ParticleEmitter") or d:IsA("Light") then d:Destroy() elseif d:IsA("BasePart") then d.Anchored = true end end
	m:PivotTo(CFrame.new())
	m.Parent = vf
	local h = m:GetAttribute("Height") or 3
	local cam = Instance.new("Camera") cam.FieldOfView = 40 cam.Parent = vf vf.CurrentCamera = cam
	local dist = math.max(h, 3.5) * 2.1
	cam.CFrame = CFrame.lookAt(Vector3.new(dist * 0.55, h * 0.75, -dist), Vector3.new(0, h * 0.45, 0))
	return vf, m
end

function Col.Init(hud)
	H = hud
	local g = H.gui("CollectionUI", 5)
	local w = U.window(g, "ODDLING INDEX", "📖", Color3.fromRGB(40, 190, 180), UDim2.fromOffset(860, 580))
	Col.w = w
	Col.progress = U.label("", UDim2.new(1, 0, 0, 26), C.text, U.Fonts.title, {Parent = w.body, TextXAlignment = Enum.TextXAlignment.Left})
	Col.milestones = U.label("", UDim2.new(1, 0, 0, 20), C.sub, U.Fonts.body, {Position = UDim2.fromOffset(0, 28), Parent = w.body, TextXAlignment = Enum.TextXAlignment.Left})
	local s = U.scroll(w.body, UDim2.new(1, 0, 1, -56), UDim2.fromOffset(0, 54))
	U.new("UIGridLayout", {CellSize = UDim2.fromOffset(190, 228), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = s})
	U.pad(4).Parent = s
	Col.grid = s
	-- Base window
	local bg = H.gui("BaseUI", 5)
	local bw = U.window(bg, "MY BASE", "🏠", C.accent, UDim2.fromOffset(820, 560))
	Col.bw = bw
	Col.baseHeader = U.label("", UDim2.new(1, -260, 0, 30), C.text, U.Fonts.title, {Parent = bw.body, TextXAlignment = Enum.TextXAlignment.Left})
	Col.baseSub = U.label("", UDim2.new(1, -260, 0, 22), C.cash, U.Fonts.body, {Position = UDim2.fromOffset(0, 32), Parent = bw.body, TextXAlignment = Enum.TextXAlignment.Left})
	Col.expandBtn = U.button("Expand", C.green, UDim2.fromOffset(240, 50), function()
		local r = State.Request("BuyCapacity") if not r.ok then H.Notify("❌ " .. (r.msg or ""), "fail", "Fail") end
	end, {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 2), Parent = bw.body})
	local bl = U.scroll(bw.body, UDim2.new(1, 0, 1, -64), UDim2.fromOffset(0, 62))
	U.new("UIGridLayout", {CellSize = UDim2.fromOffset(186, 150), CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = bl})
	U.pad(4).Parent = bl
	Col.baseList = bl
	State.Changed:Connect(function() if w.frame.Visible then Col.Render() end if bw.frame.Visible then Col.RenderBase() end end)
end

function Col.Open() Col.w.open() Col.Render() end
function Col.OpenBase() Col.bw.open() Col.RenderBase() end

function Col.Render()
	local d = State.data if not d then return end
	local nDisc, nCol = 0, 0
	for _ in pairs(d.discovered) do nDisc += 1 end
	for _ in pairs(d.collected) do nCol += 1 end
	Col.progress.Text = ("📚 Collected %d / %d  •  Discovered %d / %d"):format(nCol, #Config.Creatures, nDisc, #Config.Creatures)
	local ms = {}
	for _, m in ipairs(Config.CollectionMilestones) do table.insert(ms, (d.milestones[tostring(m.count)] and "✅ " or "⬜ ") .. m.count .. " → 💎" .. m.gems) end
	Col.milestones.Text = "Milestones:  " .. table.concat(ms, "   ")
	for _, c in ipairs(Config.Creatures) do
		local disc, have = d.discovered[c.id], d.collected[c.id]
		local key = c.id .. (disc and "1" or "0")
		local card = Col.grid:FindFirstChild(c.id)
		if card and card:GetAttribute("Key") ~= key then card:Destroy() card = nil end
		if not card then
			local r = Config.RarityById[c.rarity]
			card = U.card(UDim2.fromOffset(190, 228), C.card, {Name = c.id, LayoutOrder = c.order, Parent = Col.grid})
			card:SetAttribute("Key", key)
			U.grad(disc and r.color:Lerp(C.card, 0.6) or C.card, C.bg).Parent = card
			local vf = viewport(card, c.id, not disc)
			U.label(disc and c.name or "???", UDim2.new(1, -16, 0, 26), C.text, U.Fonts.title, {Position = UDim2.fromOffset(8, 132), Parent = card})
			U.label(r.label, UDim2.new(1, -16, 0, 18), r.color, U.Fonts.title, {Position = UDim2.fromOffset(8, 158), Parent = card})
			local terrNames = {} for _, t in ipairs(c.territories) do table.insert(terrNames, Config.TerritoryById[t].name) end
			U.label(disc and ("📍 " .. table.concat(terrNames, ", ")) or "📍 ???", UDim2.new(1, -16, 0, 16), C.sub, U.Fonts.body, {Position = UDim2.fromOffset(8, 178), Parent = card})
			U.label(disc and ("💰 $" .. Config.FormatNumber(c.income) .. "/s") or "💰 ???", UDim2.new(1, -16, 0, 16), C.cash, U.Fonts.body, {Position = UDim2.fromOffset(8, 194), Parent = card})
			local st = U.label("", UDim2.fromOffset(84, 22), C.text, U.Fonts.title, {Name = "Status", Position = UDim2.fromOffset(100, 12), BackgroundTransparency = 0, BackgroundColor3 = C.green, Parent = card})
			U.corner(8).Parent = st
		end
		local st = card:FindFirstChild("Status")
		st.Text = have and "✅ OWNED" or disc and "👁 SEEN" or "🔒 ???"
		st.BackgroundColor3 = have and C.green or disc and C.blue or C.gray
	end
end

function Col.RenderBase()
	local d = State.data if not d then return end
	Col.baseHeader.Text = ("🐾 %d / %d Oddlings  •  🔁 Rebirths: %d"):format(#d.creatures, d.capacity, d.rebirths)
	Col.baseSub.Text = ("💰 Total income $%s/s  (x%.2f multiplier)"):format(Config.FormatNumber(d.income), d.incomeMult)
	local maxed = d.baseCapacity >= Config.Capacity.max
	local cost = maxed and 0 or Config.CapacityCost(d.baseCapacity)
	U.setButton(Col.expandBtn, maxed and "Fully expanded" or ("🧱 +2 slots: $" .. Config.FormatNumber(cost)), not maxed and d.cash >= cost)
	for _, c in ipairs(Col.baseList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
	local list = table.clone(d.creatures)
	table.sort(list, function(a, b) return a.income > b.income end)
	for i, c in ipairs(list) do
		local def = Config.CreatureById[c.id]
		local r = Config.RarityById[def.rarity]
		local f = U.card(UDim2.fromOffset(186, 150), C.card, {LayoutOrder = i, Parent = Col.baseList})
		U.grad(r.color:Lerp(C.card, 0.55), C.card).Parent = f
		U.label((c.g and "✨ " or "") .. def.name, UDim2.new(1, -16, 0, 26), c.g and C.gold or C.text, U.Fonts.title, {Position = UDim2.fromOffset(8, 8), Parent = f})
		U.label(r.label, UDim2.new(1, -16, 0, 18), r.color, U.Fonts.title, {Position = UDim2.fromOffset(8, 34), Parent = f})
		U.label(("$%s/s • Slot %d"):format(Config.FormatNumber(c.income), c.s or 0), UDim2.new(1, -16, 0, 18), C.cash, U.Fonts.body, {Position = UDim2.fromOffset(8, 54), Parent = f})
		local value = math.floor((def.income * (c.g and Config.GoldenIncomeMult or 1)) * r.sellMult)
		local confirm = false
		local b
		b = U.button(c.locked and "BEING RAIDED" or ("Sell $" .. Config.FormatNumber(value)), Color3.fromRGB(255, 130, 50), UDim2.new(1, -16, 0, 44), function()
			local res = State.Request("SellCreature", c.u, confirm)
			if res.msg == "confirm" then
				confirm = true
				U.setButton(b, "⚠ Tap again to sell " .. r.label, true, C.red)
				task.delay(3, function() if b.Parent then confirm = false U.setButton(b, "Sell $" .. Config.FormatNumber(value), true, Color3.fromRGB(255, 130, 50)) end end)
			elseif not res.ok then H.Notify("❌ " .. (res.msg or ""), "fail", "Fail") end
		end, {Position = UDim2.new(0, 8, 1, -52), Parent = f})
		U.setButton(b, nil, not c.locked)
	end
	if #list == 0 then
		U.label("No Oddlings yet! Head to Mushroom Woods, steal one and bring it to your base's green drop zone.", UDim2.fromOffset(700, 60), C.sub, U.Fonts.body, {Parent = Col.baseList, TextWrapped = true}).Size = UDim2.fromOffset(186, 150)
	end
end

return Col
