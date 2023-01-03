local peri = peripheral.getNames()

local trashcanid = "turtle_xx"
local storage = {}

local trashcan = peripheral.wrap(trashcanid)
if trashcan == nil then
    printError("No such trashcan found. Fill in a connected trashcanid in store.lua")
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

