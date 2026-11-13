-- On-screen touch controls for mobile/tablet: Sprint toggle, Dash, Slide, Swing, Snatch-friendly layout.
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local U = require(script.Parent.UIKit)
local player = Players.LocalPlayer
local I = {}

function I.Init(hud, movement, combat)
	local g = Instance.new("ScreenGui") g.Name = "MobileControls" g.ResetOnSpawn = false g.DisplayOrder = 3 g.Parent = player:WaitForChild("PlayerGui")
	I.gui = g
	local holder = U.new("Frame", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Size = UDim2.fromOffset(260, 260), Position = UDim2.new(1, -12, 1, -150), Parent = g})
	local function btn(text, color, pos, size, fn)
		local b = U.button(text, color, UDim2.fromOffset(size, size), fn, {Position = pos, Parent = holder})
		b.UICorner.CornerRadius = UDim.new(1, 0)
		b.BackgroundTransparency = 0.15
		return b
	end
	local sprint
	sprint = btn("🏃\nSPRINT", U.Colors.blue, UDim2.fromOffset(150, 0), 96, function()
		local on = not movement.IsSprinting()
		movement.SetSprint(on)
		sprint.BackgroundColor3 = on and U.Colors.green or U.Colors.blue
		sprint:SetAttribute("BaseColor", sprint.BackgroundColor3)
	end)
	btn("💨\nDASH", U.Colors.purple, UDim2.fromOffset(40, 40), 86, function() movement.Dash() end)
	btn("🛝\nSLIDE", Color3.fromRGB(255, 150, 60), UDim2.fromOffset(0, 140), 80, function() movement.Slide() end)
	btn("🏏\nSWING", U.Colors.red, UDim2.fromOffset(150, 110), 96, function() combat.Swing() end)
	local function vis() g.Enabled = UserInputService.TouchEnabled and (I.allowed ~= false) end
	vis()
	UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(vis)
	I.SetAllowed = function(on) I.allowed = on vis() end
end

return I
