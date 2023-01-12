local files = {
    "sorter.lua",
    "crafter.lua",
    "trashcan.lua",
    "config.lua"
}

local tasks = {}

for i, file in ipairs(files) do
    tasks[i] = function()
        local req, err = http.get("https://raw.githubusercontent.com/raymondvansomeren/cc-goldfarm/HEAD/src/" .. file)
        if not req then error("Failed to download " .. file .. ": " .. err, 0) end
    
        local file = fs.open("goldfarm/src/" .. file, "w")
        file.write(req.readAll())
        file.close()
    
        req.close()
    end
end

parallel.waitForAll(table.unpack(tasks))

