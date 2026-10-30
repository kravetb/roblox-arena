--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStateModule = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("States"):WaitForChild("GameState"))

type GameState = GameStateModule.GameState

local RoundController = {}


local function onStateChanged()
    local value = ReplicatedStorage:GetAttribute("GameState")
    if typeof(value) ~= "string" then
        print("Waiting for server ...")
        return
    end
    local gameState = value :: GameState
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
        print(`[Client] - {timeLeft}s`)
        task.wait(0.5)
    end
end


function RoundController.start()
    ReplicatedStorage:GetAttributeChangedSignal("GameState"):Connect(onStateChanged)
    onStateChanged()
    task.spawn(countTime)
end


return RoundController
