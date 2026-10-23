--!strict
local Item = require(script.Parent.Items.Item)
local Weapon = require(script.Parent.Items.Weapon)


local ItemCatalog: {[string]: Item.Item | Weapon.Weapon} = {
    ["Sword"] = Weapon.new("Sword", 100, 25, 1.5),
    ["Potion"] = Item.new("Potion", 25),
    ["Shield"] = Item.new("Shield", 50)
}
table.freeze(ItemCatalog)

return ItemCatalog
