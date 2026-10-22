--!strict
local Item = require(script.Parent.Item)

local Weapon = setmetatable({}, {__index = Item})
Weapon.__index = Weapon

export type Weapon = typeof(setmetatable({} :: {
    name: string,
    price: number,
    damage: number,
    cooldown: number,
    lastAttack: number
}, Weapon))

function Weapon.new(
    name: string,
    price: number,
    damage: number,
    cooldown: number
): Weapon

    local self = Item.new(name, price) :: any
    self.damage = damage
    self.cooldown = cooldown
    self.lastAttack = -math.huge

    return setmetatable(self, Weapon)
end

function Weapon.canAttack(self: Weapon, now: number): boolean
    return (now - self.lastAttack) >= self.cooldown
end

function Weapon.attack(self: Weapon, now: number): number
    if not self:canAttack(now) then return 0 end
    self.lastAttack = now
    return self.damage
end

function Weapon.describe(self: Weapon): string
    return `{Item.describe(self :: any)} — {self.damage} dmg / {self.cooldown}s`
end

return Weapon
