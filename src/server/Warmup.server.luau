-- --!strict
-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local ShopUtil = require(ReplicatedStorage.Shared.ShopUtil)

-- -- First task

-- for i=1, 20 do
--     if i % 15 == 0 then 
--         print("FizzBuzz")
--     elseif i % 3 == 0 then
--         print("Fizz")
--     elseif i % 5 ==0 then
--         print("Buzz")
--     else
--         print(i)
--     end
-- end


-- -- Second task

-- local equipment = {"Sword", "Shield", "Bow", "Arrow", "Potion"}
-- table.insert(equipment, "Helmet")
-- table.remove(equipment, 2) -- Remove "Shield"
-- table.sort(equipment)
-- local joined = table.concat(equipment, ", ")
-- print(joined)


-- -- Third task
-- -- Fourth task

-- local amount = {["Weapon"] = 100, ["Armor"] = 50, ["Potion"] = 25}

-- local getMaxAmount = ShopUtil.maxAmount

-- local item, price = getMaxAmount(amount)
-- print(item, price)


-- -- Fifth task

-- local takeUserMoney = ShopUtil.takeUserMoney
-- local userMoney = 200
-- local itemPrice = 250
-- local ok, result = pcall(takeUserMoney, itemPrice, userMoney)
-- if ok then
--     print("Remaining money:", result)
-- else
--     warn("Error:", result)
-- end


-- -- Sixth task

-- local ticker = task.spawn(function()
--     while true do
--         print("Tick")
--         task.wait(0.5)
--     end
-- end)


-- for i = 5, 1, -1 do
--     print(i)
--     task.wait(1)
-- end

-- task.cancel(ticker)
