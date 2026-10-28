--!strict
local CurrencyService = require(script.Services.CurrencyService)
local ShopService = require(script.Services.ShopService)
local RoundService = require(script.Services.RoundService)
CurrencyService.start()
ShopService.start()
RoundService.start()


print("Hello world, from server! Hi manager!")