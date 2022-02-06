local DIMM = {}

DIMM.__index = function(table, index)
	if not rawget(table, index) then
		rawset(table, index, setmetatable({}, DIMM))
		--warn("Table now has index ".. index .. " as a new dimensional table.")
		return rawget(table, index)
	end
end

function DIMM.new()
	local self = setmetatable({}, DIMM)
	return self
end

return DIMM