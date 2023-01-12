package.path = '*.lua;' .. package.path
require "config"

local peri = peripheral.getNames()
local storage = {}

local trashcan = peripheral.wrap(config.trashcanid)
if trashcan == nil then
    printError("No such trashcan found. Fill in a connected config.trashcanid in goldfarm/src/config.lua")
    return
end

local function pullStorage()
    storage = {}
    for k,v in pairs(peri) do
        if v ~= config.nuggetsid and v ~= config.dropsid and v ~= config.trashcanid and peripheral.hasType(v, "inventory") then
            storage[#storage+1] = peripheral.wrap(v)
        end
    end
end

local input = peripheral.wrap(config.dropsid)
local function pullInput()
    if input == nil then
        print("Connect and define an input inventory. goldfarm/src/config.lua config.dropsid")
        return
    end

    for slot, item in pairs(input.list()) do
        input.pushItems(config.sorter, slot)
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
                trashcan.pullItems(config.sorter, i)
            else
                --Store
                local toSend = turtle.getItemCount(i)
                local sent = 0
                for _,p in pairs(storage) do
                    if sent >= toSend then
                        break
                    end
                    if p ~= nil then
                        sent = sent + p.pullItems(config.sorter, i)
                    end
                end
            end
        end
    end
    sleep(5)
end