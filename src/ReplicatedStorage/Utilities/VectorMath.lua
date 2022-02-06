local VectorMath = {}

VectorMath.Vertices = {
	{1, 1, -1}, --Right, top, front
	{1, 1, 1}, --Right, top, back
	{-1, 1, -1}, --Left, top, front
	{-1, 1, 1}, --Left, top, back
	
	{1, -1, -1}, --Right, bottom, front
	{1, -1, 1}, --Right, bottom, back
	{-1, -1, -1}, --Left, bottom, front
	{-1, -1, 1}, --Left, bottom, back
}

function VectorMath.Project(pos, unit)
	return (pos:Dot(unit) * unit)
end

function VectorMath.Corners(cframe, size)
	local corners = {}
	for i, vertex in pairs(VectorMath.Vertices) do
		local corner = (cframe * CFrame.new(size.X / 2 * vertex[1], size.Y * vertex[2], size.Z * vertex[3])).Position
		corners[i] = corner
	end
	return corners
end

return VectorMath
