--!strict
local DataService = require(script.Parent.DataService)

local CurrencyService = {}

function CurrencyService.get(player: Player): number
    local data = DataService.get(player)
    if data then
        return data.coins
    end
    return 0
end

function CurrencyService.trySpend(player: Player, amount: number): boolean
    local playerData = DataService.get(player)
    if amount <= 0 or not playerData or playerData.coins < amount then
        return false
    end
    playerData.coins -= amount
    return true
end

function CurrencyService.add(player: Player, amount: number): boolean
    local playerData = DataService.get(player)
    if not playerData or amount <= 0 then
        return false
    end
    playerData.coins += amount
    return true
end

return CurrencyService
