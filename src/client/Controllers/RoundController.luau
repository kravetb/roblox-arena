--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStateModule = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("States"):WaitForChild("GameState"))
local HudController = require(script.Parent:WaitForChild("HudController"))
local SoundController = require(script.Parent.SoundController)
local RoundEnded = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RoundEnded") :: RemoteEvent
local Players = game:GetService("Players")

type GameState = GameStateModule.GameState

local currentState = "Waiting"

local RoundController = {}


local function onStateChanged()
    local value = ReplicatedStorage:GetAttribute("GameState")
    if typeof(value) ~= "string" then
        print("Waiting for server ...")
        return
    end
    local gameState = value :: GameState
    currentState = gameState
    print(`[Client] State - {gameState}`)
end


local function countTime()
    while true do
        local endsAt = ReplicatedStorage:GetAttribute("PhaseEndsAt")
        if typeof(endsAt) ~= "number" or workspace:GetServerTimeNow() == 0 then
            print("Waiting for server ...")
            task.wait(1)
            continue
        end
        local timeLeft = math.max(0, math.ceil(endsAt - workspace:GetServerTimeNow()))
        HudController.setStatus(`{currentState} - {timeLeft}s`)
        task.wait(0.5)
    end
end


function RoundController.start()
    ReplicatedStorage:GetAttributeChangedSignal("GameState"):Connect(onStateChanged)
    RoundEnded.OnClientEvent:Connect(function(winnerName: unknown)
        if typeof(winnerName) == "string" then
            HudController.showBanner(`Winner: {winnerName}`)
            if winnerName == Players.LocalPlayer.Name then
                SoundController.play("Win")
            end
        else
            HudController.showBanner("No winner")
        end
    end)
    onStateChanged()
    task.spawn(countTime)
end


return RoundController
