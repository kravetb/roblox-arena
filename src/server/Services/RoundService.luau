--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStateModule = require(ReplicatedStorage.Shared.States.GameState)
local Players = game:GetService("Players")
local arenaSpawns = workspace:WaitForChild("Arena"):WaitForChild("Spawns")

type GameState = GameStateModule.GameState

local LOBBY_TIME = 15
local ROUND_TIME = 60
local RESULT_TIME = 5
local MIN_PLAYERS = 1

local alivePlayers: {[Player]: boolean} = {}


local RoundService = {}


local function setState(state: GameState, duration: number)
    local phaseEndsAt = duration + workspace:GetServerTimeNow()
    ReplicatedStorage:SetAttribute("GameState", state)
    ReplicatedStorage:SetAttribute("PhaseEndsAt", phaseEndsAt)
    print(`[Round] {state} ({duration}s)`)
end


local function teleportToArena()
    table.clear(alivePlayers)
    local spawns = arenaSpawns:GetChildren()
    for i, player in Players:GetPlayers() do
        local character = player.Character
        if not character then
            continue
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            continue
        end
        local spawn = spawns[(i - 1) % #spawns + 1] :: BasePart
        character:PivotTo(spawn.CFrame + Vector3.new(0, 3, 0))
        alivePlayers[player] = true
        humanoid.Died:Connect(function() alivePlayers[player] = nil end)
    end
end


local function teleportToLobby()
    for _, player in Players:GetPlayers() do
        task.spawn(function() player:LoadCharacterAsync() end)
    end
end


local function countAlive(): number
    local count = 0
    for _ in alivePlayers do
        count += 1
    end
    return count
end


local function waitForRoundEnd()
    local startCount = countAlive()
    local threshold = if startCount >= 2 then 1 else 0
    local endsAt = os.clock() + ROUND_TIME
    while os.clock() < endsAt do
        if countAlive() <= threshold then
            break
        else
            task.wait(0.5)
        end
    end
end


local function runGameLoop()
    while true do
        if #Players:GetPlayers() < MIN_PLAYERS then
            setState("Waiting", 0)
            while #Players:GetPlayers() < MIN_PLAYERS do
                task.wait(1)
            end
        end
        setState("Lobby", LOBBY_TIME)
        task.wait(LOBBY_TIME)
        setState("InRound", ROUND_TIME)
        teleportToArena()
        waitForRoundEnd()
        setState("Results", RESULT_TIME)
        task.wait(RESULT_TIME)
        teleportToLobby()
    end
end


function RoundService.start()
    task.spawn(runGameLoop)
    Players.PlayerRemoving:Connect(function(player: Player)
        alivePlayers[player] = nil
    end)
end    

return RoundService
