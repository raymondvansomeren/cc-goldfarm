local peri = peripheral.getNames()

local selfid = "turtle_xx"
local trashcanid = "turtle_xx"
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
    if turtle.getItemDetail(i).name == not "minecraft:gold_nugget" then
        print(turtle.getItemDetail(i).name)
        self.pushItems(trashcanid, i)
    end
end