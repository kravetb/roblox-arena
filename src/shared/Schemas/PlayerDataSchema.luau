--!strict
export type PlayerData = {coins: number}
local DEFAULT_DATA = table.freeze({ coins = 100 })

local PlayerDataSchema = {}

PlayerDataSchema.DEFAULT_DATA = DEFAULT_DATA

function PlayerDataSchema.reconcile(raw: unknown): PlayerData?
    if typeof(raw) ~= "table" then
        return nil
    end
    local data = table.clone(PlayerDataSchema.DEFAULT_DATA)
    for key, default in PlayerDataSchema.DEFAULT_DATA do
        local value = (raw :: any)[key]
        if typeof(value) == typeof(default) then
            (data :: any)[key] = value
        end
    end
    return data
end

return PlayerDataSchema