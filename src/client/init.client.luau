--!strict
local ShopController = require(script.Controllers.ShopController)
local RoundController = require(script.Controllers.RoundController)
ShopController.start()
RoundController.start()
print("Hello world, from client!")
