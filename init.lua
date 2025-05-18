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
local Rect = {}
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
    }, Rect)
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
    }, Rect)
end

---Returns all components of this Rect.
---@return number minX, number minY, number maxX, number maxY
function Rect:unpack() return self.minX, self.minY, self.maxX, self.maxY end

---Returns the components of this Rect, in XYWH format.
---@return number x, number y, number width, number height
function Rect:xywh()
    return self.minX, self.minY,
        self.minX + (self.maxX - self.minX),
        self.minY + (self.maxY - self.minY)
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

---Same as `cut_right`, expect it keeps the Rect intact.
---@param a number
---@return Rect
function Rect:get_right(a)
    return Rect.new(
        max(self.minX, self.maxX - a), self.minY,
        self.maxX, self.maxY
    )
end

---Same as `cut_top`, expect it keeps the Rect intact.
---@param a number
---@return Rect
function Rect:get_top(a)
    return Rect.new(
        self.minX, self.minY,
        self.maxX, min(self.maxY, self.minY + a)
    )
end

---Same as `cut_bottom`, expect it keeps the Rect intact.
---@param a number
---@return Rect
function Rect:get_bottom(a)
    return Rect.new(
        self.minX, max(self.minY, self.maxY - a),
        self.maxX, self.maxY
    )
end

---Cuts `a` from the left side of the Rect, and returns the cut part.
---@param a number
---@return Rect
function Rect:cut_left(a)
    local left = self:get_left(a)
    self.minX = left.minX
    return left
end

---Cuts `a` from the right side of the Rect, and returns the cut part.
---@param a number
---@return Rect
function Rect:cut_right(a)
    local right = self:get_right(a)
    self.maxX = right.maxX
    return right
end

---Cuts `a` from the top side of the Rect, and returns the cut part.
---@param a number
---@return Rect
function Rect:cut_top(a)
    local top = self:get_top(a)
    self.minY = top.minY
    return top
end

---Cuts `a` from the bottom side of the Rect, and returns the cut part.
---@param a number
---@return Rect
function Rect:cut_bottom(a)
    local bottom = self:get_bottom(a)
    self.maxY = bottom.maxY
    return bottom
end

---Returns this rect, with `a` added to its left side.
---@param a number
---@return Rect
function Rect:add_left(a) return Rect.new(self.minX - a, self.minY, self.maxX, self.maxY) end

---Returns this rect, with `a` added to its right side.
---@param a number
---@return Rect
function Rect:add_right(a) return Rect.new(self.minX, self.minY, self.maxX + a, self.maxY) end

---Returns this rect, with `a` added to its top side.
---@param a number
---@return Rect
function Rect:add_top(a) return Rect.new(self.minX, self.minY - a, self.maxX, self.maxY) end

---Returns this rect, with `a` added to its bottom side.
---@param a number
---@return Rect
function Rect:add_bottom(a) return Rect.new(self.minX, self.minY, self.maxX, self.maxY + a) end

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
    return string.format("Rect: X(%f-%f), Y(%f-%f)", self:unpack())
end

return setmetatable(Rect, {
    __call = function(cls, ...) return cls.new(...) end,
})
