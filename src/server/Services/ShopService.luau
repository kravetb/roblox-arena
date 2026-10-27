--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurrencyService = require(script.Parent.CurrencyService)
local ItemCatalog = require(ReplicatedStorage.Shared.ItemCatalog)
local BuyResultModule = require(ReplicatedStorage.Shared.Results.BuyResult)
local BuyItem = ReplicatedStorage.Remotes.BuyItem :: RemoteFunction

type BuyResult = BuyResultModule.BuyResult

local ShopService = {}
local RATE_LIMIT = 0.5
local lastPurchase: {[Player]: number} = {}


local function onBuyItem(player: Player, itemName: unknown): BuyResult
    local currentTime = os.clock()
    local last = lastPurchase[player]
    if last and (currentTime - last) < RATE_LIMIT then
        return {ok = false, reason = "TooFast"}
    else
        lastPurchase[player] = currentTime
    end
    if typeof(itemName) ~= "string" then
        return {ok = false, reason = "InvalidItem"}
    end
    local item = ItemCatalog[itemName]
    if not item then
        return {ok = false, reason = "UnknownItem"}
    end
    local spent = CurrencyService.trySpend(player, item.price)
    if not spent then
        return {ok = false, reason = "NotEnoughCoins"}
    end
    local currentBalance = CurrencyService.get(player) 
    return {ok = true, coins = currentBalance}
end

function ShopService.start()
    BuyItem.OnServerInvoke = onBuyItem
    Players.PlayerRemoving:Connect(function(player: Player)
        lastPurchase[player] = nil
    end)
end

return ShopService
