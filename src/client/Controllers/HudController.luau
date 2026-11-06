--!strict
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local statusLabel: TextLabel? = nil
local coinsLabel: TextLabel? = nil
local bannerLabel: TextLabel? = nil


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

function HudController.showBanner(text: string)
    if not bannerLabel then
        return
    end
    bannerLabel.Text = text
    task.spawn(function()
        local info = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(
            bannerLabel, info, { TextTransparency = 0, BackgroundTransparency = 0.3 }
        ):Play()
        task.wait(3)
        TweenService:Create(
            bannerLabel, info, { TextTransparency = 1, BackgroundTransparency = 1 }
        ):Play()
    end)
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
    gui.Name = "HudGui"
    gui.ResetOnSpawn = false

    local sLabel = createLabel(
        UDim2.new(0, 300, 0, 50), Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 10)
    )
    sLabel.Parent = gui
    statusLabel = sLabel
    local cLabel = createLabel(
        UDim2.new(0, 150, 0, 40), Vector2.new(1, 0), UDim2.new(1, -10, 0, 10)
    )
    cLabel.Parent = gui
    coinsLabel = cLabel

    local bLabel = createLabel(
        UDim2.new(0, 400, 0, 80), Vector2.new(0.5, 0.5), UDim2.new(0.5, 0, 0.3, 0)
    )
    bLabel.TextTransparency = 1
    bLabel.BackgroundTransparency = 1
    bLabel.Parent = gui
    bannerLabel = bLabel

    gui.Parent = player:WaitForChild("PlayerGui")

    task.spawn(bindCoins)
end

return HudController
