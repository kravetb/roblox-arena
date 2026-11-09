--!strict
export type PlayerData = {coins: number}
local DEFAULT_DATA = { coins = 100 }

local PlayerDataSchema = {}

function PlayerDataSchema.reconcile(raw: unknown): PlayerData?
    if typeof(raw) ~= "table" then
        return nil
    end
    local data = table.clone(DEFAULT_DATA)
    for key, default in DEFAULT_DATA do
        local value = (raw :: any)[key]
        if typeof(value) == typeof(default) then
            (data :: any)[key] = value
        end
    end
    return data
end

return PlayerDataSchema