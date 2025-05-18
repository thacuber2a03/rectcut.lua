local Rect = require 'init'

local fail = false

local function testEqualRects(name, a, b)
    if a.minX ~= b.minX or a.minY ~= b.minY
        or a.maxX ~= b.maxX or a.maxY ~= b.maxY then
        io.write(name .. " failed: expected " .. tostring(b) .. ", got " .. tostring(a) .. "\n")
        fail = true
        return false
    else
        io.write(name .. " passed\n")
        return true
    end
end

-- TODO: actually write tests lmfao

if fail then io.write("\nsome tests have failed, please check results\n") end
