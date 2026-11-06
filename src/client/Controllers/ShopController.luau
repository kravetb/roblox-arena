--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HudController = require(script.Parent.HudController)
local BuyResultModule = require(
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Results"):WaitForChild("BuyResult")
)
local BuyItem = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyItem") :: RemoteFunction

type BuyResult = BuyResultModule.BuyResult

local busy = false

local ShopController = {}

local function buySword()
    if busy then
        return
    end
    busy = true
    local ok, result = pcall(function()
        return BuyItem:InvokeServer("Sword")
    end)
    busy = false

    if not ok then
        HudController.showBanner("Shop error, try again")
        return
    end
    if result.ok then
        HudController.showBanner("Bought Sword!")
    else
        HudController.showBanner(`Can't buy: {result.reason}`)
    end
end

function ShopController.start()
    UserInputService.InputBegan:Connect(function(input: InputObject, gameProcessed: boolean)
        if gameProcessed then
            return
        end
        if input.KeyCode ~= Enum.KeyCode.B then return end
        buySword()
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "ShopGui"
    gui.ResetOnSpawn = false

    local button = Instance.new("TextButton")
    button.AnchorPoint = Vector2.new(0.5, 1)
    button.Position = UDim2.new(0.5, 0, 1, -20)
    button.Size = UDim2.new(0, 200, 0, 50)
    button.TextScaled = true
    button.Text = "Buy Sword (100)"
    button.Parent = gui

    button.Activated:Connect(buySword)

    gui.Parent = player:WaitForChild("PlayerGui")
end

return ShopController
