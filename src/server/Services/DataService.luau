--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local store = DataStoreService:GetDataStore("PlayerData_v1")
local PlayerDataSchemaModule = require(
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Schemas"):WaitForChild("PlayerDataSchema")
)

type PlayerData = PlayerDataSchemaModule.PlayerData
local profiles: {[Player]: PlayerData} = {}

local MAX_ATTEMPTS = 3
local AUTOSAVE_INTERVAL = 60


local function withRetries<T>(fn: () -> T): (boolean, T | string)
    local lastError = "unknown error"
    for i=1, MAX_ATTEMPTS do
        local ok, result = pcall(fn)
        if ok then
            return true, result
        end
        lastError = tostring(result)
        if i < MAX_ATTEMPTS then
            warn(`[Data] Attempt {i} failed: {result}`)
            task.wait(2 ^ i)
        end
    end
    return false, lastError
end


local function getKey(player: Player): string
    return "Player_" .. player.UserId
end


local function loadData(player: Player):(boolean, PlayerData?)
    local ok, result = withRetries(function()
        return store:GetAsync(getKey(player))
    end)
    if not ok then
        warn(`[Data] Failed to load {player.Name}: {result}`) 
        return false, nil
    end
    if result == nil then
        return true, table.clone(PlayerDataSchemaModule.DEFAULT_DATA)
    end
    local data = PlayerDataSchemaModule.reconcile(result)
    if not data then
        warn(`[Data] Corrupted data for {player.Name}`)
        return false, nil
    end
    return true, data
end


local function saveData(player: Player, playerData: PlayerData): boolean
    local key = getKey(player)
    local ok, result = withRetries(function()
        return store:UpdateAsync(key, function() return playerData end)
    end)

    if not ok then
        warn(`[Data] Failed to save {player.Name}: {result}`)
        return false
    end

    return true
end


local DataService = {}

function DataService.get(player: Player): PlayerData?
    return profiles[player]
end

function DataService.start()

    local function onPlayerAdded(player: Player)
        local ok, playerData = loadData(player)

        if not player.Parent then 
            return 
        end

        if not ok or not playerData then
            player:Kick("Can't load player data, please restart session!")
            return
        end
        profiles[player] = playerData
        local folder = Instance.new("Folder")
        folder.Name = "leaderstats"
        local coins = Instance.new("IntValue")
        coins.Name = "Coins"
        coins.Value = playerData.coins
        coins.Parent = folder
        folder.Parent = player
        print(`[Data] Loaded {player.Name}: {playerData.coins} coins`)
    end

    task.spawn(function()
        while true do
            task.wait(AUTOSAVE_INTERVAL)
            for player, data in profiles do
                task.spawn(function()
                    if saveData(player, data) then
                        print(`[Data] Autosaved {player.Name}: {data.coins} coins`)
                    else
                        warn(`[Data] Failed to autosave {player.Name}`)
                    end
                end)
            end
        end
    end)

    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(function(player: Player)
        local data = profiles[player]
        profiles[player] = nil
        if data then
            saveData(player, data)
        end
    end)
    for _, player in Players:GetPlayers() do
        task.spawn(onPlayerAdded, player)
    end
    game:BindToClose(function()
        for player, data in profiles do
            saveData(player, data)
        end
    end)

end

return DataService
