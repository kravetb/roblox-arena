-- src/shared/ShopUtil.luau
local getAmount = {}


function getAmount.maxAmount(amount) : (string, number)
    if amount == nil or next(amount) == nil then
        return "", 0
    end
    local maxItem = nil
    local maxValue = 0
    for item, value in amount do
        if maxItem == nil or value > amount[maxItem] then
            maxItem = item
            maxValue = value
        end
    end
    return maxItem, maxValue
end


function getAmount.takeUserMoney(price: number, money: number) : (number)
    if money < price then
        error("Not enough money to take")
    end
    return money - price
end

return getAmount
