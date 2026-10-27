--!strict
local Players = game:GetService("Players")
local CurrencyService = require(script.Services.CurrencyService)
local ShopService = require(script.Services.ShopService)
CurrencyService.start()
ShopService.start()


print("Hello world, from server! Hi manager!")