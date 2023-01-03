local peri = peripheral.getNames()

local selfid = "front"
local trashcanid = "turtle_195"
local storage = {}

local self = peripheral.wrap(selfid)
if self == nil then
    printError("No such turtle found. Fill in the name of this turtle in src/store.lua")
    return
end

local trashcan = peripheral.wrap(trashcanid)
if trashcan == nil then
    printError("No such trashcan found. Fill in a connected trashcanid in src/store.lua")
    return
end

local function pullStorage()
    storage = {}
    for k,v in pairs(peri) do
        if peripheral.getType(v) == "inventory" then
            storage[#storage+1] = v
        end
    end
end

for i=1, 16 do
    -- turtle.select(i)
    local itemName = turtle.getItemDetail(i).name
    print(itemName)
    if itemName ~= nil and itemName ~= "minecraft:gold_nugget" then
        self.pushItems(trashcanid, i)
    end
end