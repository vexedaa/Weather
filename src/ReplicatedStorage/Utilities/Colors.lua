local Colors = {}

Colors.Lerp = function(start, finish, position)
	local initial = {R = start.R, G = start.G, B = start.B}
	local final = {R = finish.R, G = finish.G, B = finish.B}
	local product = {R = position, G = position, B = position}
	--Interpolate each value
	for i, element in pairs(product) do
		product[i] = (initial[i] + (final[i] - initial[i]) * product[i])
	end
	return Color3.new(product.R, product.G, product.B)
end

return Colors
