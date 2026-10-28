--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStateModule = require(ReplicatedStorage.Shared.States.GameState)

type GameState = GameStateModule.GameState

local LOBBY_TIME = 15
local ROUND_TIME = 60
local RESULT_TIME = 5


local RoundService = {}


local function setState(state: GameState, duration: number)
    local phaseEndsAt = duration + workspace:GetServerTimeNow()
    ReplicatedStorage:SetAttribute("GameState", state)
    ReplicatedStorage:SetAttribute("PhaseEndsAt", phaseEndsAt)
    print(`[Round] {state} ({duration}s)`)
end


local function runGameLoop()
    while true do
        setState("Lobby", LOBBY_TIME)
        task.wait(LOBBY_TIME)
        setState("InRound", ROUND_TIME)
        task.wait(ROUND_TIME)
        setState("Results", RESULT_TIME)
        task.wait(RESULT_TIME)
    end
end

function RoundService.start()
    task.spawn(runGameLoop)
end    

return RoundService
