local files = {
    "src/store.lua",
}

local tasks = {}

for i, file in ipairs(files) do
    -- print("https://raw.githubusercontent.com/raymondvansomeren/cc-goldfarm/blob/vnext/"..file)

    tasks[i] = function()
        local req, err = http.get("https://raw.githubusercontent.com/raymondvansomeren/cc-goldfarm/HEAD/src/" .. path)
        if not req then error("Failed to download " .. path .. ": " .. err, 0) end
    
        local file = fs.open(".artist.d/src/" .. path, "w")
        file.write(req.readAll())
        file.close()
    
        req.close()
    end
end

parallel.waitForAll(table.unpack(tasks))

