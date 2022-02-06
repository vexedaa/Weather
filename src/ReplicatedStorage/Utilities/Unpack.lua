local Unpack = {}
Unpack.get = function(...)
	if typeof(...) == "table" then
		local ordered = {}
		for i, v in pairs(...) do
			table.insert(ordered, v)
		end
		return table.unpack(ordered)
	else
		return ...
	end
end

Unpack.getRecursive = function(...)
	if typeof(...) == "table" then
		local ordered = {}
		for i, v in pairs(...) do
			table.insert(ordered, Unpack.getRecursive(v))
		end
		return table.unpack(ordered)
	else
		return ...
	end
end


return Unpack
