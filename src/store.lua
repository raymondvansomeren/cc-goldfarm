local peri = peripheral.getNames()

local inputid = "sc-goodies:diamond_chest_581"
local selfid = "turtle_435"
local trashcanid = "minecraft:chest_1753"
local storage = {}

local trashcan = peripheral.wrap(trashcanid)
if trashcan == nil then
    printError("No such trashcan found. Fill in a connected trashcanid in src/store.lua")
    return
end

local function pullStorage()
    storage = {}
    for k,v in pairs(peri) do
        if v ~= inputid and v ~= trashcanid and peripheral.hasType(v, "inventory") then
            storage[#storage+1] = peripheral.wrap(v)
        end
    end
end

local input = peripheral.wrap(inputid)
local function pullInput()
    if input == nil then
        print("Connect and define an input inventory. src/store.lua inputid")
        return
    end

    for slot, item in pairs(input.list()) do
        input.pushItems(selfid, slot)
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
                trashcan.pullItems(selfid, i)
            else
                --Store
                local toSend = turtle.getItemCount(i)
                local sent = 0
                for _,p in pairs(storage) do
                    if sent >= toSend then
                        break
                    end
                    if p ~= nil then
                        sent = sent + p.pullItems(selfid, i)
                    end
                end
            end
        end
    end
    sleep(0.2)
end