local Point = {}
Point.__index = Point

function Point.new(pos)
    pos = pos or Vector3.new(-1, -1, -1)
    local self = {
        X = pos.X;
        Y = pos.Y;
        Z = pos.Z;
    }
    setmetatable(self, Point)
    return self
end

return Point