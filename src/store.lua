local peri = peripheral.getNames()

local selfid = "turtle_194"
local trashcanid = "turtle_195"
local storage = {}

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
    if turtle.getItemCount(i) > 0 then
        local itemName = turtle.getItemDetail(i).name
        print(itemName)
        if itemName ~= nil and itemName ~= "minecraft:gold_nugget" then
            trashcan.pullItems(selfid, i)
        end
    end
end