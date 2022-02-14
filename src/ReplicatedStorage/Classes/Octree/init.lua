local Octree = {}
Octree.__index = Octree

local Point = require(script:WaitForChild("Point"))

local TOP_LEFT_FRONT = 0
local TOP_RIGHT_FRONT = 1
local BOTTOM_RIGHT_FRONT = 2
local BOTTOM_LEFT_FRONT = 3
local TOP_LEFT_BOTTOM = 4
local TOP_RIGHT_BOTTOM = 5
local BOTTOM_RIGHT_BACK = 6
local BOTTOM_LEFT_BACK = 7

function Octree.new(point)
    local self = {
        _Point = Point.new(point);
    }
    setmetatable(self, Octree)

    return self
end

return Octree