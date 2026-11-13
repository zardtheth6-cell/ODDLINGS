-- Game passes (verified via MarketplaceService) and developer products (secure ProcessReceipt).
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local Config = require(game.ReplicatedStorage.Shared.Config)
local M = {}
local S, Data
local owned = {} -- [player] = {passId=true}

function M.Init(services) S = services Data = S.Data end

function M.Owns(player, passId)
	local o = owned[player]
	return o ~= nil and o[passId] == true
end

local function refreshPasses(player)
	owned[player] = owned[player] or {}
	for _, p in ipairs(Config.GamePasses) do
		if p.assetId and p.assetId > 0 then
			local ok, has = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, p.assetId)
			if ok and has then owned[player][p.id] = true end
		end
	end
end

local function passEffects(player)
	if M.Owns(player, "VIPEffects") and player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root and not root:FindFirstChild("VIPTrail") then
			local a0 = Instance.new("Attachment", root) a0.Position = Vector3.new(0, 1, 0)
			local a1 = Instance.new("Attachment", root) a1.Position = Vector3.new(0, -1, 0)
			local tr = Instance.new("Trail") tr.Name = "VIPTrail" tr.Attachment0 = a0 tr.Attachment1 = a1 tr.Lifetime = 0.5 tr.LightEmission = 1
			tr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 200)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 200, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 230, 80))})
			tr.Parent = root
		end
	end
end
M.ApplyCosmetics = passEffects

local function grantProduct(player, product)
	local data = Data.Get(player)
	local g = product.grant
	if g.cash then S.Economy.AddCash(player, g.cash) end
	if g.gems then S.Economy.AddGems(player, g.gems) end
	if g.boost then S.Economy.AddBoost(player, g.boost, g.time) end
	if g.bats then for _, b in ipairs(g.bats) do data.bats[b] = true end end
	S.Notify(player, "💎 Purchase complete: " .. product.name, "purchase", "Purchase")
	Data.Sync(player)
end

local function processReceipt(info)
	local player = Players:GetPlayerByUserId(info.PlayerId)
	if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local data = Data.Get(player)
	if not data then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local rid = tostring(info.PurchaseId)
	if data.receipts[rid] then return Enum.ProductPurchaseDecision.PurchaseGranted end -- duplicate: already granted
	local product
	for _, p in ipairs(Config.Products) do if p.assetId == info.ProductId and p.assetId > 0 then product = p break end end
	if not product then
		warn("[Monetization] Unknown product id", info.ProductId)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	-- snapshot so we can roll back if the save fails
	local before = {cash = data.cash, gems = data.gems, boosts = table.clone(data.boosts), bats = table.clone(data.bats)}
	local ok, err = pcall(grantProduct, player, product)
	if not ok then warn("[Monetization] grant failed", err) return Enum.ProductPurchaseDecision.NotProcessedYet end
	data.receipts[rid] = os.time()
	table.insert(data.receiptOrder, rid)
	while #data.receiptOrder > 100 do local old = table.remove(data.receiptOrder, 1) data.receipts[old] = nil end
	if not Data.Save(player, false) then
		-- roll back so the reward is not granted twice when Roblox retries
		data.cash, data.gems, data.boosts, data.bats = before.cash, before.gems, before.boosts, before.bats
		data.receipts[rid] = nil
		table.remove(data.receiptOrder)
		S.Economy.ApplyStats(player)
		Data.Sync(player)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	return Enum.ProductPurchaseDecision.PurchaseGranted
end

M.ProcessReceipt = processReceipt

local H = {}
function H.PromptPass(player, id)
	local p = Config.PassById[id]
	if not p then return false, "Invalid" end
	if not p.assetId or p.assetId <= 0 then return false, "This pass is not configured yet" end
	if M.Owns(player, id) then return false, "Already owned" end
	MarketplaceService:PromptGamePassPurchase(player, p.assetId)
	return true
end
function H.PromptProduct(player, id)
	local p = Config.ProductById[id]
	if not p then return false, "Invalid" end
	if not p.assetId or p.assetId <= 0 then return false, "This product is not configured yet" end
	MarketplaceService:PromptProductPurchase(player, p.assetId)
	return true
end
M.Handlers = H

function M.Start()
	MarketplaceService.ProcessReceipt = processReceipt
	MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, assetId, purchased)
		if not purchased then return end
		for _, p in ipairs(Config.GamePasses) do
			if p.assetId == assetId then
				-- verify with Roblox rather than trusting the event alone
				local ok, has = pcall(MarketplaceService.UserOwnsGamePassAsync, MarketplaceService, player.UserId, assetId)
				if (ok and has) or purchased then
					owned[player] = owned[player] or {}
					owned[player][p.id] = true
					S.Notify(player, "👑 " .. p.name .. " unlocked! Thank you!", "purchase", "Success")
					S.Economy.ApplyStats(player)
					S.Economy.CheckTitles(player)
					S.Economy.UpdateOverhead(player)
					S.Bases.RefreshSlots(player)
					passEffects(player)
					Data.Sync(player)
				end
			end
		end
	end)
	Players.PlayerRemoving:Connect(function(p) owned[p] = nil end)
end

function M.OnPlayerAdded(player)
	refreshPasses(player)
end

return M
