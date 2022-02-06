local ClearSkiesDay = {}
ClearSkiesDay.__index = ClearSkiesDay

function ClearSkiesDay.new()
    local self = {}
    setmetatable(self, ClearSkiesDay)

    return self
end

return ClearSkiesDay