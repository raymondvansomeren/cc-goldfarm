local files = {
    "src/store.lua",
}

local tasks = {}

for i, file in ipairs(files) do
    -- print("https://raw.githubusercontent.com/raymondvansomeren/cc-goldfarm/blob/vnext/"..file)

    tasks[i] = function()
        local req, err = http.get("https://raw.githubusercontent.com/raymondvansomeren/cc-goldfarm/HEAD/" .. file)
        if not req then error("Failed to download " .. file .. ": " .. err, 0) end
    
        local file = fs.open("goldfarm/" .. file, "w")
        file.write(req.readAll())
        file.close()
    
        req.close()
    end
end

parallel.waitForAll(table.unpack(tasks))

