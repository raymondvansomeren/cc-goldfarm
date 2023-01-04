local peri = peripheral.getNames()

local selfid = "turtle_194"
local trashcanid = "minecraft:chest_873"
local storage = {}

local trashcan = peripheral.wrap(trashcanid)
if trashcan == nil then
    printError("No such trashcan found. Fill in a connected trashcanid in src/store.lua")
    return
end

local function pullStorage()
    storage = {}
    for k,v in pairs(peri) do
        if v ~= trashcanid and peripheral.getType(v) == "inventory" then
            storage[#storage+1] = peripheral.wrap(v)
        else
            print(("v: %s trashcanid: %s"):format(v, trashcanid))
        end
    end
end

pullStorage()
local running = true
while running do
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