--!strict
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Schema = require(
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Schemas"):WaitForChild("PlayerDataSchema")
)


if not RunService:IsStudio() then
    return
end


local passed, failed = 0, 0
local function test(name: string, fn: () -> ())
    local ok, err = pcall(fn :: any)
    if ok then passed += 1 else failed += 1; warn(`FAIL {name}: {err}`) end
end


test("nil returns nil", function()
    assert(Schema.reconcile(nil) == nil, "expected nil")
end)

test("missing field gets default", function()
    local data = Schema.reconcile({})
    assert(data and data.coins == 100, "expected coins = 100")
end)

test("non-table returns nil", function()
    assert(Schema.reconcile("hello") == nil, "expected nil")
end)

test("wrong type falls back to default", function()
    local data = Schema.reconcile({coins = "lol"})
    assert(data and data.coins == 100, "expected coins = 100")
end)

test("valid value kept, unknown field dropped", function()
    local data = Schema.reconcile({coins = 50, hacker = true})
    assert(data and data.coins == 50, "expected coins = 50")
    assert((data :: any).hacker == nil, "expected hacker to be dropped")
end)

print(`[Tests] {passed} passed, {failed} failed`)
