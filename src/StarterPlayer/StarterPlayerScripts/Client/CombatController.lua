-- Bat input (mouse, touch, gamepad), knockback reception and camera feedback. The server validates every hit.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local Remotes = game.ReplicatedStorage.Remotes
local player = Players.LocalPlayer
local K = {}
local H
local last = 0

local function equipBat()
	local c = player.Character
	if not c then return nil end
	local tool = c:FindFirstChild("Bat")
	if tool then return tool end
	local bp = player:FindFirstChildOfClass("Backpack")
	local t = bp and bp:FindFirstChild("Bat")
	local h = c:FindFirstChildOfClass("Humanoid")
	if t and h then h:EquipTool(t) return t end
end

function K.Swing()
	if os.clock() - last < Config.Bat.cooldown then return end
	local tool = equipBat()
	if not tool then return end
	last = os.clock()
	Remotes.Swing:FireServer()
end

local function hookTool(tool)
	if tool:IsA("Tool") and tool.Name == "Bat" and not tool:GetAttribute("Hooked") then
		tool:SetAttribute("Hooked", true)
		tool.Activated:Connect(K.Swing)
	end
end

function K.Shake(intensity, time)
	local cam = workspace.CurrentCamera
	local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	if not h then return end
	task.spawn(function()
		local t0 = os.clock()
		while os.clock() - t0 < time do
			local k = 1 - (os.clock() - t0) / time
			h.CameraOffset = Vector3.new((math.random() - 0.5) * intensity * k, (math.random() - 0.5) * intensity * k, 0)
			task.wait()
		end
		h.CameraOffset = Vector3.zero
	end)
end

function K.Knockback(vel)
	local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if r then r.AssemblyLinearVelocity = vel end
	K.Shake(1.2, 0.4)
	H.Flash(Color3.fromRGB(255, 255, 255), 0.5, 0.3)
end

function K.Init(hud)
	H = hud
	player.CharacterAdded:Connect(function(c)
		c.ChildAdded:Connect(hookTool)
		local bp = player:WaitForChild("Backpack")
		bp.ChildAdded:Connect(hookTool)
		for _, t in ipairs(bp:GetChildren()) do hookTool(t) end
	end)
	if player.Character then for _, t in ipairs(player:WaitForChild("Backpack"):GetChildren()) do hookTool(t) end end
end

return K
