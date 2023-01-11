local peri = peripheral.getNames()
local inputid = "front"
local selfid = "turtle_437"

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
        print("Connect and define an input inventory. goldfarm/src/crafter.lua inputid")
        return
    end

    for slot, item in pairs(input.list()) do
        input.pushItems(selfid, slot)
    end

    -- UGLY, I KNOW
    if turtle.getItemCount(4) > 0 then
        turtle.select(4)
        turtle.transferTo(5)
    elseif turtle.getItemCount(8) > 0 then
        turtle.select(8)
        turtle.transferTo(9)
    elseif turtle.getItemCount(12) > 0 then
        turtle.select(12)
        turtle.drop()
    elseif turtle.getItemCount(13) > 0 then
        turtle.select(13)
        turtle.drop()
    elseif turtle.getItemCount(14) > 0 then
        turtle.select(14)
        turtle.drop()
    elseif turtle.getItemCount(15) > 0 then
        turtle.select(15)
        turtle.drop()
    elseif turtle.getItemCount(16) > 0 then
        turtle.select(16)
        turtle.drop()
    end
end

pullStorage()
local running = true
while running do
    pullInput()
    turtle.craft()

    for i=1, 16 do
        if turtle.getItemCount(i) > 0 then
            if turtle.getItemDetail().name == "minecraft:gold_ingot" then
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
    sleep(1)
end