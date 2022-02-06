local Region = {}
Region.__index = Region
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Package = ReplicatedStorage:WaitForChild("Package")
local Modules = Package:WaitForChild("Modules")
local FuncLib = require(Modules:WaitForChild("FuncLib"))

function Region.new()
	local self = setmetatable({
		Points = {};
		LinearFalloffDistance = 50; -- Distance from which the linear falloff begins. (Must be less than or equal to radius)
	}, Region)
	return self
end

-- Given a position, return the influence value relative to the region.
-- @param pos Position to calculate the influence from.
function Region:SampleInfluence(pos)
	local influence = 0;
	local position = pos
	local success, result = pcall(function()
		--If the passed position is a Vector3, convert to a Vector2 for point comparison.
		if typeof(pos) == "Vector3" then
			position = Vector2.new(pos.X, pos.Z)
		end

		for i, vector in pairs(self.Points) do
			local rPos = vector.Position
			local distance = (rPos - position).Magnitude
			influence += (1 - FuncLib.Normalize(self.LinearFalloffDistance, vector.Radius, distance))
		end
	end)
	if not success then
		warn("Position must be a valid Vector2 or Vector3")
	end
	influence = math.clamp(influence, 0, 1)
	return influence
end

-- Adds a Vector2 to a region's table of points.
-- Position takes a Vector2, interpreted as X/Z in world space.
function Region:AddPoint(position, radius)
	local success, result = pcall(function()
		table.insert(self.Points, {Position = position, Radius = radius})
	end)
	if not success then
		warn("Region:AddPoint - Argument must be a Vector2")
	end
end

return Region
