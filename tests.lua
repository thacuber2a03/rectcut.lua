local Rect = require 'init'

local fail = false

local function test(name, a, b)
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

--- tests taken from the Rust implementation, thanks and sorry

local base = Rect(0, 0, 10, 10)
local rect = base:copy()
test("copy call", rect, base)

test("get_left call", rect:get_left(1), Rect(0, rect.minY, 1, rect.maxY))
test("get_right call", rect:get_right(1), Rect(9, rect.minY, 10, rect.maxY))
test("get_bottom call", rect:get_bottom(1), Rect(rect.minX, 9, rect.maxX, 10))
test("get_top call", rect:get_top(1), Rect(rect.minX, 0, rect.maxX, 1))

test("cut_left call", rect:cut_left(1), Rect(0, rect.minY, 1, rect.maxY))
test("cut_left result", rect, Rect(1, 0, 10, 10))
test("add_left call", rect:add_left(1), base)

rect = base:copy()
test("cut_right call", rect:cut_right(1), Rect(9, rect.minY, 10, rect.maxY))
test("cut_right result", rect, Rect(0, 0, 9, 10))
test("add_right result", rect:add_right(1), base)

rect = base:copy()
test("cut_right call", rect:cut_right(1), Rect(9, rect.minY, 10, rect.maxY))
test("cut_right result", rect, Rect(0, 0, 9, 10))
test("add_right result", rect:add_right(1), base)

rect = base:copy()
test("cut_bottom call", rect:cut_bottom(1), Rect(rect.minX, 9, rect.maxX, 10))
test("cut_bottom result", rect, Rect(0, 0, 10, 9))
test("add_bottom result", rect:add_bottom(1), base)

rect = base:copy()
test("cut_top call", rect:cut_top(1), Rect(rect.minX, 0, rect.maxX, 1))
test("cut_top result", rect, Rect(0, 1, 10, 10))
test("add_top result", rect:add_top(1), base)

test("contract call", base:contract(1), Rect(1, 1, 9, 9))
test("extend call", base:extend(1), Rect(-1, -1, 11, 11))

io.write "\n"
if fail then io.write "some tests have failed, please check results\n" else io.write "all tests pass :D\n" end
