local min, max = math.min, math.max

---The rectangle class that implements the algorithm.
---Can be called to instantiate a Rect.
---@class Rect
---@field public minX number
---@field public minY number
---@field public maxX number
---@field public maxY number
---@overload fun(minX: number, minY: number, maxX: number, maxY: number): Rect
---@overload fun(r: {minX: number, minY: number, maxX: number, maxY: number}): Rect
local Rect = { _version = "2.0" }
Rect.__index = Rect

---Creates a new Rect. Equivalent to calling the class: `Rect(...)`.
---@param minX number
---@param minY number
---@param maxX number
---@param maxY number
---@return Rect
---@overload fun(r: {minX: number, minY: number, maxX: number, maxY: number}): Rect
function Rect.new(minX, minY, maxX, maxY)
    if type(minX) == "table" then
        minX, minY, maxX, maxY = minX.minX, minX.minY, minX.maxX, minY.maxY
    end

    return setmetatable({
        minX = minX,
        minY = minY,
        maxX = maxX,
        maxY = maxY,
    }, Rect --[[@as table]])
end

---Creates a new Rect from XYWH parameters.
---@param x number
---@param y number
---@param width number
---@param height number
---@return Rect
---@overload fun(r: {x: number, y: number, width: number, height: number}): Rect
function Rect.fromXYWH(x, y, width, height)
    if type(x) == "table" then
        x, y, width, height = x.x, x.y, x.width, x.height
    end

    return setmetatable({
        minX = x,
        minY = y,
        maxX = x + width,
        maxY = y + height,
    }, Rect --[[@as table]])
end

---Returns all components of this Rect.
---@return number minX, number minY, number maxX, number maxY
function Rect:unpack() return self.minX, self.minY, self.maxX, self.maxY end

---Returns a copy of this Rect.
---@return Rect
function Rect:copy() return Rect.new(self:unpack()) end

---Returns the components of this Rect, in XYWH format.
---@return number x, number y, number width, number height
function Rect:xywh()
    return self.minX, self.minY,
        self.minX + (self.maxX - self.minX),
        self.minY + (self.maxY - self.minY)
end

---A variant of the `get_*` methods that takes in the side to get from.
---@param side "left"|"right"|"top"|"bottom"
---@param a number
---@return Rect
function Rect:get(side, a)
    local f = self["get_" .. side]
    assert(f, "rectcut: no such side '" .. side .. "'")
    return f(self, a)
end

---Same as `cut_left`, except it keeps the Rect intact.
---@param a number
---@return Rect
function Rect:get_left(a)
    return Rect.new(
        self.minX, self.minY,
        min(self.maxX, self.minX + a), self.maxY
    )
end

---Alias for `get_left`.
---@param a number
---@return Rect
---@see Rect.get_left
function Rect:getLeft(a) return Rect:get_left(a) end

---Same as `cut_right`, expect it keeps the Rect intact.
---@param a number
---@return Rect
function Rect:get_right(a)
    return Rect.new(
        max(self.minX, self.maxX - a), self.minY,
        self.maxX, self.maxY
    )
end

---Alias for `get_right`.
---@param a number
---@return Rect
---@see Rect.get_right
function Rect:getRight(a) return Rect:get_right(a) end

---Same as `cut_top`, expect it keeps the Rect intact.
---@param a number
---@return Rect
function Rect:get_top(a)
    return Rect.new(
        self.minX, self.minY,
        self.maxX, min(self.maxY, self.minY + a)
    )
end

---Alias for `get_top`.
---@param a number
---@return Rect
---@see Rect.get_top
function Rect:getTop(a) return Rect:get_top(a) end

---Same as `cut_bottom`, expect it keeps the Rect intact.
---@param a number
---@return Rect
function Rect:get_bottom(a)
    return Rect.new(
        self.minX, max(self.minY, self.maxY - a),
        self.maxX, self.maxY
    )
end

---Alias for `get_bottom`.
---@param a number
---@return Rect
---@see Rect.get_bottom
function Rect:getBottom(a) return Rect:get_bottom(a) end

---A variant of the `cut_*` methods that takes in the side to cut from.
---@param side "left"|"right"|"top"|"bottom"
---@param a number
---@return Rect
function Rect:cut(side, a)
    local f = self["cut_" .. side]
    assert(f, "rectcut: no such side '" .. side .. "'")
    return f(self, a)
end

---Cuts `a` from the left side of the Rect, and returns the cut part.
---@param a number
---@return Rect
function Rect:cut_left(a)
    local left = self:get_left(a)
    self.minX = left.maxX
    return left
end

---Alias for `cut_left`.
---@param a number
---@return Rect
---@see Rect.cut_left
function Rect:cutLeft(a) return Rect:cut_left(a) end

---Cuts `a` from the right side of the Rect, and returns the cut part.
---@param a number
---@return Rect
function Rect:cut_right(a)
    local right = self:get_right(a)
    self.maxX = right.minX
    return right
end

---Alias for `cut_right`.
---@param a number
---@return Rect
---@see Rect.cut_right
function Rect:cutRight(a) return Rect:cut_right(a) end

---Cuts `a` from the top side of the Rect, and returns the cut part.
---@param a number
---@return Rect
function Rect:cut_top(a)
    local top = self:get_top(a)
    self.minY = top.maxY
    return top
end

---Alias for `cut_top`.
---@param a number
---@return Rect
---@see Rect.cut_top
function Rect:cutTop(a) return Rect:cut_top(a) end

---Cuts `a` from the bottom side of the Rect, and returns the cut part.
---@param a number
---@return Rect
function Rect:cut_bottom(a)
    local bottom = self:get_bottom(a)
    self.maxY = bottom.minY
    return bottom
end

---Alias for `cut_bottom`.
---@param a number
---@return Rect
---@see Rect.cut_bottom
function Rect:cutBottom(a) return Rect:cut_bottom(a) end

---Returns a copy of this rect, with `a` added to its left side.
---@param a number
---@return Rect
function Rect:add_left(a) return Rect.new(self.minX - a, self.minY, self.maxX, self.maxY) end

---Alias for `add_left`.
---@param a number
---@return Rect
---@see Rect.add_left
function Rect:addLeft(a) return Rect:add_left(a) end

---Returns a copy of this rect, with `a` added to its right side.
---@param a number
---@return Rect
function Rect:add_right(a) return Rect.new(self.minX, self.minY, self.maxX + a, self.maxY) end

---Alias for `add_right`.
---@param a number
---@return Rect
---@see Rect.add_right
function Rect:addRight(a) return Rect:add_right(a) end

---Returns a copy of this rect, with `a` added to its top side.
---@param a number
---@return Rect
function Rect:add_top(a) return Rect.new(self.minX, self.minY - a, self.maxX, self.maxY) end

---Alias for `add_top`.
---@param a number
---@return Rect
---@see Rect.add_top
function Rect:addTop(a) return Rect:add_top(a) end

---Returns a copy of this rect, with `a` added to its bottom side.
---@param a number
---@return Rect
function Rect:add_bottom(a) return Rect.new(self.minX, self.minY, self.maxX, self.maxY + a) end

---Alias for `add_bottom`.
---@param a number
---@return Rect
---@see Rect.add_bottom
function Rect:addBottom(a) return Rect:add_bottom(a) end

---A variant of the `add_*` methods that takes in the side to add from.
---@param side "left"|"right"|"top"|"bottom"
---@param a number
---@return Rect
function Rect:add(side, a)
    local f = self["add_" .. side]
    assert(f, "rectcut: no such side '" .. side .. "'")
    return f(self, a)
end

---Returns an extended version of this Rect.
---@param a number
---@return Rect
function Rect:extend(a) return Rect.new(self.minX - a, self.minY - a, self.maxX + a, self.maxY + a) end

---Returns a contracted version of this Rect.
---@param a number
---@return Rect
function Rect:contract(a) return Rect.new(self.minX + a, self.minY + a, self.maxX - a, self.maxY - a) end

---@return string
function Rect:__tostring()
    return string.format("Rect: min(%g,%g), max(%g,%g)", self:unpack())
end

return setmetatable(Rect --[[@as table]], {
    __call = function(cls, ...) return cls.new(...) end,
}) --[[@as Rect]]
