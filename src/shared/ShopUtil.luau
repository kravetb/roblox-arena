-- src/shared/ShopUtil.luau
--!strict
local ShopUtil = {}


function ShopUtil.maxAmount(amount: { [string]: number }): (string, number)
    if amount == nil or next(amount) == nil then
        return "", 0
    end
    local maxItem = ""
    local maxValue = 0
    for item, value in amount do
        if maxItem == "" or value > maxValue then
            maxItem = item
            maxValue = value
        end
    end
    return maxItem, maxValue
end


function ShopUtil.takeUserMoney(price: number, money: number): number
    if money < price then
        error("Not enough money to take")
    end
    return money - price
end

return ShopUtil
