local Connection = {}
Connection.__index = Connection
local Connections = {}

--Creates a new Connection object
function Connection.new(listeners, parent)
	assert(typeof(listeners) == "table", "Connection listeners must be passed through a table.")
	local self = setmetatable({
		Connected = true;
		Parent = parent;
		Listeners = listeners or {};
	}, Connection)
	return self
end

function Connection:Disconnect()
	self.Connected = false
	self.Listeners = nil
	self.Parent:Disconnect(self)
end

return Connection
