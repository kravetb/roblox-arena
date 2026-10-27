--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local BuyItem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyItem") :: RemoteFunction

local ShopController = {}

function ShopController.start()
    UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
        if gameProcessed then
            return
        end
        if input.KeyCode ~= Enum.KeyCode.B then return end
        local result = BuyItem:InvokeServer("Sword")
        print(result.ok, result.coins, result.reason)
        
    end)
end

return ShopController
