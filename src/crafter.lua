package.path = '*.lua;' .. package.path
require "config"

local peri = peripheral.getNames()
local storage = {}

local function pullStorage()
    storage = {}
    for k,v in pairs(peri) do
        if v ~= config.dropsid and v ~= config.nuggetsid and v ~= config.trashcanid and peripheral.hasType(v, "inventory") then
            storage[#storage+1] = peripheral.wrap(v)
        end
    end
end

local slots = {1,2,3,5,6,7,9,10,11}
local input = peripheral.wrap(config.nuggetsid)
local function pullInput()
    if input == nil then
        print("Connect and define an input inventory. goldfarm/src/config.lua config.nuggetsid")
        return
    end

    for inputSlot, item in pairs(input.list()) do
        for i, turtleSlot in pairs(slots) do
            if turtle.getItemCount(turtleSlot) == 0 then
                input.pushItems(config.crafter, inputSlot, 64, turtleSlot)
                break
            end
        end
    end
end

pullStorage()
local running = true
while running do
    pullInput()
    turtle.craft()

    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            if turtle.getItemDetail(i).name == "minecraft:gold_ingot" then
                --Store
                local toSend = turtle.getItemCount(i)
                local sent = 0
                for _,p in pairs(storage) do
                    if sent >= toSend then
                        break
                    end
                    if p ~= nil then
                        sent = sent + p.pullItems(config.crafter, i)
                    end
                end
            end
        end
    end
    sleep(5)
end