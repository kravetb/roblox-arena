--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Weapon = require(ReplicatedStorage.Shared.Items.Weapon)

local sword = Weapon.new("Sword", 100, 25, 1.5)
print(sword:describe())
print(sword:attack(os.clock()))
print(sword:attack(os.clock()))
task.wait(2)
print(sword:attack(os.clock()))


print("Hello world, from server! Hi manager!")
