dofile("config.lua")

local peri = peripheral.getNames()
local storage = {}

local trashcan = peripheral.wrap(trashcanid)
if trashcan == nil then
    printError("No such trashcan found. Fill in a connected trashcanid in goldfarm/src/config.lua")
    return
end

local function pullStorage()
    storage = {}
    for k,v in pairs(peri) do
        if v ~= nuggetsid and v ~= dropsid and v ~= trashcanid and peripheral.hasType(v, "inventory") then
            storage[#storage+1] = peripheral.wrap(v)
        end
    end
end

local input = peripheral.wrap(dropsid)
local function pullInput()
    if input == nil then
        print("Connect and define an input inventory. goldfarm/src/config.lua dropsid")
        return
    end

    for slot, item in pairs(input.list()) do
        input.pushItems(sorter, slot)
    end
end


pullStorage()
local running = true
while running do
    pullInput()
    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            local itemName = turtle.getItemDetail(i).name
            if itemName ~= nil and itemName ~= "minecraft:gold_nugget" then
                --Delete
                trashcan.pullItems(sorter, i)
            else
                --Store
                local toSend = turtle.getItemCount(i)
                local sent = 0
                for _,p in pairs(storage) do
                    if sent >= toSend then
                        break
                    end
                    if p ~= nil then
                        sent = sent + p.pullItems(sorter, i)
                    end
                end
            end
        end
    end
    sleep(5)
end