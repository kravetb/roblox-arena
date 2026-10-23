--!strict
local Players = game:GetService("Players")
local CurrencyService = require(script.Services.CurrencyService)
CurrencyService.start()
task.wait(2)
for _, player in Players:GetPlayers() do
    print(player.Name, CurrencyService.get(player))
end


print("Hello world, from server! Hi manager!")