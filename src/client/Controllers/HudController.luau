--!strict
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local statusLabel: TextLabel? = nil
local coinsLabel: TextLabel? = nil


local function createLabel(size: UDim2, anchor: Vector2, position: UDim2): TextLabel
    local label = Instance.new("TextLabel")
    label.Size = size
    label.AnchorPoint = anchor
    label.Position = position
    label.BackgroundTransparency = 0.3
    label.TextScaled = true
    label.Text = "..."
    return label
end


local HudController = {}

function HudController.setStatus(text: string)
    if statusLabel then
        statusLabel.Text = text
    end
end

function HudController.setCoins(coins: number)
    if coinsLabel then
        coinsLabel.Text = `Coins: {coins}`
    end
end

local function bindCoins()
    local coins = player:WaitForChild("leaderstats"):WaitForChild("Coins")
    if not coins:IsA("IntValue") then
        return
    end
    coins.Changed:Connect(HudController.setCoins)
    HudController.setCoins(coins.Value)
end

function HudController.start()
    local gui = Instance.new("ScreenGui")
    gui.Name = "Hud"
    gui.ResetOnSpawn = false

    local sLabel = createLabel(
        UDim2.new(0, 300, 0, 50), Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 10)
    )
    sLabel.Parent = gui
    statusLabel = sLabel
    local cLabel = createLabel(UDim2.new(0, 150, 0, 40), Vector2.new(1, 0), UDim2.new(1, -10, 0, 10))
    cLabel.Parent = gui
    coinsLabel = cLabel

    gui.Parent = player:WaitForChild("PlayerGui")

    task.spawn(bindCoins)
end

return HudController
