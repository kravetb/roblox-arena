--!strict
local DataService = require(script.Services.DataService)
local ShopService = require(script.Services.ShopService)
local RoundService = require(script.Services.RoundService)
DataService.start()
ShopService.start()
RoundService.start()


print("Hello world, from server! Hi manager!")