--!strict
local Players = game:GetService("Players")

local CurrencyService = {}

local STARTING_BALANCE = 100
local balances: {[Player]: number} = {}

function CurrencyService.get(player: Player): number
    return balances[player] or 0
end

function CurrencyService.trySpend(player: Player, amount: number): boolean
    if amount <= 0 then
        return false
    end
    local balance = balances[player]
    if not balance or balance < amount then
        return false
    end
    balances[player] = balance - amount
    return true
end

function CurrencyService.start()

    local function onPlayerAdded(player: Player)
        if balances[player] then
            return
        end
        balances[player] = STARTING_BALANCE
    end

    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(function(player: Player)
        balances[player] = nil
    end)

    for _, player in Players:GetPlayers() do
        onPlayerAdded(player)
    end

end

return CurrencyService
