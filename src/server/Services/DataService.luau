--!strict
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local store = DataStoreService:GetDataStore("PlayerData_v1")

export type PlayerData = {coins: number}
local profiles: {[Player]: PlayerData} = {}
local DEFAULT_DATA = { coins = 100 }


local function getKey(player: Player): string
    return "Player_" .. player.UserId
end


local function loadData(player: Player):(boolean, PlayerData?)
    local ok, result = pcall(function()
        return store:GetAsync(getKey(player))
    end)
    if not ok then
        warn(`[Data] Failed to load {player.Name}: {result}`)
        return false, nil
    end
    if result == nil then
        return true, table.clone(DEFAULT_DATA)
    end
    return true, result
end


local function saveData(player: Player, playerData: PlayerData): boolean
    local key = getKey(player)
    local ok, result = pcall(function()
        return store:SetAsync(key, playerData)
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

    Players.PlayerAdded:Connect(onPlayerAdded)
    Players.PlayerRemoving:Connect(function(player: Player)
        local data = profiles[player]
        if data then
            saveData(player, data)
        end
        profiles[player] = nil
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
