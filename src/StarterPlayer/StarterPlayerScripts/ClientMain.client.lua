-- ODDLINGS client bootstrap: builds every interface and connects controllers in order.
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Client = script.Parent:WaitForChild("Client")
local player = Players.LocalPlayer

local U = require(Client.UIKit)
local State = require(Client.State)
local HUD = require(Client.HUDController)
local Shop = require(Client.ShopController)
local Col = require(Client.CollectionController)
local Panels = require(Client.PanelsController)
local Movement = require(Client.MovementController)
local Combat = require(Client.CombatController)
local Effects = require(Client.EffectsController)
local Input = require(Client.InputController)

local openWindows = {}
local function closeAll()
	for _, w in ipairs({Shop.w, Shop.sw, Col.w, Col.bw, Panels.dw, Panels.rw, Panels.lw, Panels.pw, Panels.sw}) do
		if w and w.frame.Visible then w.frame.Visible = false end
	end
end
local function openPanel(name)
	closeAll()
	if name == "Shop" or name == "Premium" then Shop.Open(name == "Premium" and "Gamepasses" or "Items")
	elseif name == "Upgrades" then Shop.Open("Upgrades")
	elseif name == "Security" then Shop.OpenSecurity()
	elseif name == "Collection" then Col.Open()
	elseif name == "Base" or name == "Market" then Col.OpenBase()
	else Panels.Open(name) end
end

pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true) end)
HUD.Init(openPanel)
Shop.Init(HUD)
Col.Init(HUD)
Panels.Init(HUD)
Movement.Init(HUD)
Combat.Init(HUD)
Effects.Init(HUD, Combat, openPanel)
Input.Init(HUD, Movement, Combat)
Panels.onSettings.Event:Connect(function(s)
	Effects.SetLowGfx(s.lowGfx)
	Input.SetAllowed(s.mobile)
end)

-- keep the location label fresh (bases are detected client-side for display only)
task.spawn(function() while true do task.wait(0.5) HUD.RefreshTerritory() end end)

-- Welcome / first 30 seconds guidance
task.spawn(function()
	local snap = State.data or State.Changed:Wait()
	task.wait(1.5)
	if #snap.creatures == 0 then
		HUD.Notify("👋 Welcome to ODDLING ISLAND!", "reward", "Success")
		task.wait(2)
		HUD.Notify("🍄 Go NORTH to Mushroom Woods and STEAL an Oddling (hold E).", "carry")
		task.wait(3)
		HUD.Notify("🏠 Carry it to the GREEN drop zone at your base to earn cash every second!", "success")
		task.wait(3)
		HUD.Notify("⚠ Avoid the Guardians! Sprint with Shift, Dash with Q, Slide with C.", "warn")
	else
		HUD.Notify(("👋 Welcome back! Your Oddlings earn $%s/s"):format(require(game.ReplicatedStorage.Shared.Config).FormatNumber(snap.income)), "reward", "Cash")
	end
	if snap.canSave == false then HUD.Notify("⚠ Saving is unavailable on this server — progress won't be saved.", "warn") end
end)
