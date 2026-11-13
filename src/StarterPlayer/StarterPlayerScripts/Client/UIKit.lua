-- Shared UI building blocks: consistent cards, buttons, typography and transitions.
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local U = {}

U.Colors = {
	bg = Color3.fromRGB(28, 24, 52), bg2 = Color3.fromRGB(44, 36, 82), card = Color3.fromRGB(56, 46, 104),
	text = Color3.fromRGB(255, 255, 255), sub = Color3.fromRGB(190, 185, 230),
	cash = Color3.fromRGB(110, 235, 120), gems = Color3.fromRGB(110, 210, 255), robux = Color3.fromRGB(80, 220, 120),
	accent = Color3.fromRGB(255, 90, 170), blue = Color3.fromRGB(70, 150, 255), green = Color3.fromRGB(60, 200, 110),
	gold = Color3.fromRGB(255, 200, 50), red = Color3.fromRGB(255, 70, 80), purple = Color3.fromRGB(160, 90, 255), gray = Color3.fromRGB(110, 110, 130),
}
U.Fonts = {title = Enum.Font.FredokaOne, body = Enum.Font.GothamBold, light = Enum.Font.Gotham}

function U.new(class, props, children)
	local o = Instance.new(class)
	for k, v in pairs(props or {}) do if k ~= "Parent" then o[k] = v end end
	for _, c in ipairs(children or {}) do c.Parent = o end
	if props and props.Parent then o.Parent = props.Parent end
	return o
end
function U.corner(r) return U.new("UICorner", {CornerRadius = UDim.new(0, r or 14)}) end
function U.stroke(col, th, tr) return U.new("UIStroke", {Color = col or Color3.new(0, 0, 0), Thickness = th or 2, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}) end
function U.grad(a, b, rot) return U.new("UIGradient", {Color = ColorSequence.new(a, b), Rotation = rot or 90}) end
function U.pad(p) return U.new("UIPadding", {PaddingTop = UDim.new(0, p), PaddingBottom = UDim.new(0, p), PaddingLeft = UDim.new(0, p), PaddingRight = UDim.new(0, p)}) end
function U.list(dir, gap, align)
	return U.new("UIListLayout", {FillDirection = dir or Enum.FillDirection.Vertical, Padding = UDim.new(0, gap or 8), SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = align or Enum.HorizontalAlignment.Center})
end

function U.label(text, size, color, font, props)
	local l = U.new("TextLabel", {BackgroundTransparency = 1, Text = text, TextColor3 = color or U.Colors.text, Font = font or U.Fonts.body, TextScaled = true, Size = size or UDim2.fromScale(1, 1)})
	U.new("UITextSizeConstraint", {MaxTextSize = 40, Parent = l})
	if props then for k, v in pairs(props) do l[k] = v end end
	return l
end

local clickSound = Instance.new("Sound") clickSound.SoundId = Config.Sounds.Click clickSound.Volume = 0.4 clickSound.Parent = SoundService
local hoverSound = Instance.new("Sound") hoverSound.SoundId = Config.Sounds.Hover hoverSound.Volume = 0.15 hoverSound.Parent = SoundService
function U.playUI(kind) if kind == "hover" then hoverSound:Play() else clickSound:Play() end end

-- Button with hover / press / disabled states.
function U.button(text, color, size, onClick, props)
	local b = U.new("TextButton", {Text = "", AutoButtonColor = false, BackgroundColor3 = color or U.Colors.blue, Size = size or UDim2.fromOffset(160, 48)})
	U.corner(12).Parent = b
	U.new("UIGradient", {Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(200, 200, 200)), Rotation = 90, Parent = b})
	local st = U.stroke(Color3.fromRGB(20, 15, 40), 2.5) st.Parent = b
	local l = U.label(text, UDim2.new(1, -12, 1, -8), U.Colors.text, U.Fonts.title, {Position = UDim2.fromOffset(6, 4), Name = "Label"})
	U.new("UIStroke", {Color = Color3.fromRGB(20, 15, 40), Thickness = 1.5, Parent = l})
	l.Parent = b
	local scale = U.new("UIScale", {Parent = b})
	b:SetAttribute("BaseColor", b.BackgroundColor3)
	b.MouseEnter:Connect(function() if b:GetAttribute("Disabled") then return end U.playUI("hover") TweenService:Create(scale, TweenInfo.new(0.12), {Scale = 1.05}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(scale, TweenInfo.new(0.12), {Scale = 1}):Play() end)
	b.MouseButton1Down:Connect(function() TweenService:Create(scale, TweenInfo.new(0.06), {Scale = 0.94}):Play() end)
	b.MouseButton1Up:Connect(function() TweenService:Create(scale, TweenInfo.new(0.1), {Scale = 1}):Play() end)
	b.Activated:Connect(function()
		if b:GetAttribute("Disabled") then return end
		U.playUI("click")
		if onClick then onClick(b) end
	end)
	if props then for k, v in pairs(props) do b[k] = v end end
	return b
end
function U.setButton(b, text, enabled, color)
	if text then b.Label.Text = text end
	if color then b:SetAttribute("BaseColor", color) end
	b:SetAttribute("Disabled", not enabled)
	b.BackgroundColor3 = enabled and b:GetAttribute("BaseColor") or U.Colors.gray
	b.AutoButtonColor = false
end

function U.card(size, color, props)
	local f = U.new("Frame", {BackgroundColor3 = color or U.Colors.card, Size = size})
	U.corner(14).Parent = f
	U.stroke(Color3.fromRGB(255, 255, 255), 1.5, 0.85).Parent = f
	if props then for k, v in pairs(props) do f[k] = v end end
	return f
end

-- Big modal window with title bar and close button.
function U.window(gui, title, icon, accent, size)
	local holder = U.new("Frame", {Name = "Window", Size = size or UDim2.fromOffset(760, 500), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.52), BackgroundColor3 = U.Colors.bg, Visible = false, Parent = gui})
	U.corner(22).Parent = holder
	U.grad(U.Colors.bg2, U.Colors.bg).Parent = holder
	U.stroke(accent or U.Colors.accent, 4).Parent = holder
	local scale = U.new("UIScale", {Name = "OpenScale", Parent = holder})
	local top = U.new("Frame", {Name = "TitleBar", Size = UDim2.new(1, 0, 0, 64), BackgroundColor3 = accent or U.Colors.accent, Parent = holder})
	U.corner(22).Parent = top
	U.new("Frame", {Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 1, -22), BackgroundColor3 = accent or U.Colors.accent, BorderSizePixel = 0, Parent = top})
	U.grad(Color3.new(1, 1, 1), Color3.fromRGB(190, 190, 190)).Parent = top
	local t = U.label(icon .. "  " .. title, UDim2.new(1, -140, 0, 46), U.Colors.text, U.Fonts.title, {Position = UDim2.fromOffset(20, 9), TextXAlignment = Enum.TextXAlignment.Left, Parent = top})
	U.new("UIStroke", {Thickness = 2.5, Color = Color3.fromRGB(20, 15, 40), Parent = t})
	local close = U.button("X", U.Colors.red, UDim2.fromOffset(48, 48), nil, {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 8), Parent = top})
	local body = U.new("Frame", {Name = "Body", BackgroundTransparency = 1, Size = UDim2.new(1, -28, 1, -84), Position = UDim2.fromOffset(14, 74), Parent = holder})
	local w = {frame = holder, body = body, close = close, scale = scale}
	function w.open()
		holder.Visible = true scale.Scale = 0.6
		TweenService:Create(scale, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	end
	function w.closeW()
		local tw = TweenService:Create(scale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.6})
		tw:Play() tw.Completed:Wait() holder.Visible = false
	end
	close.Activated:Connect(function() w.closeW() end)
	return w
end

function U.scroll(parent, size, pos)
	local s = U.new("ScrollingFrame", {BackgroundTransparency = 1, Size = size, Position = pos or UDim2.new(), ScrollBarThickness = 8, ScrollBarImageColor3 = U.Colors.accent,
		AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), BorderSizePixel = 0, Parent = parent})
	return s
end

function U.priceText(price, currency)
	if currency == "Robux" then return "R$ " .. price end
	if currency == "Gems" then return "💎 " .. Config.FormatNumber(price) end
	if currency == "Free" then return "FREE" end
	return "$" .. Config.FormatNumber(price)
end
function U.currencyColor(currency)
	return currency == "Gems" and U.Colors.gems or currency == "Robux" and U.Colors.robux or U.Colors.cash
end

return U
