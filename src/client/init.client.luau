--!strict
local HudController = require(script.Controllers.HudController)
local ShopController = require(script.Controllers.ShopController)
local RoundController = require(script.Controllers.RoundController)
HudController.start()
ShopController.start()
RoundController.start()
print("Hello world, from client!")
