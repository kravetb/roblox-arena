--!strict


local Item = {}
Item.__index = Item

export type Item = typeof(setmetatable({} :: {
    name: string,
    price: number,
}, Item))

function Item.new(name: string, price: number): Item
    local self = setmetatable({name=name, price=price}, Item)
    return self
end

function Item.describe(self: Item): string
    return `{self.name} ({self.price} coins)`
end

return Item
