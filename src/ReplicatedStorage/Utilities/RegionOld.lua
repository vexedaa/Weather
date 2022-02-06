local Package = script.Parent.Parent
local Modules = script.Parent
local DIMM = require(Modules:WaitForChild("DIMM"))

local Region = {}
Region.__index = Region

--[[ Region.new()
INPUTS: Vector3 startCorner, Vector3 endCorner, Integer resolution
OUTPUTS: A resolution^3 3D array with each element representing cubes at position N with size determined by the given resolution.

DESCRIPTION:

]]--

function Region.new(startCorner, endCorner, resolution)
	if typeof(startCorner) == "Vector3" and typeof(endCorner) == "Vector3" and typeof(resolution) == "number" then
		
	else
		warn("Invalid input. Start and end corners must be Vector3s. Resolution must be a number.")
		return false
	end
end

return Region
