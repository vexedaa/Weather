local RunService = game:GetService("RunService")
local Connection = require(script:WaitForChild("Connection"))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Library = require(Modules:WaitForChild("Library"))
local Unpack = require(Modules:WaitForChild("Unpack"))

local Event = {}
Event.__index = Event
	
function Event.new()
	local self = setmetatable({
		Listeners = {};
		Waiting = {};
		Connections = {};
	}, Event)
	return self
end

function Event:Fire(args)
	for i, fnc in pairs(self.Listeners or {}) do
		local fncThread = coroutine.wrap(fnc)
		local success, result = pcall(function()
			fncThread(Unpack.get(args))
		end)
		if success == false then
			warn(result)
		end
	end
	local waitList = self.Waiting
	self.Waiting = {}
	for i, thread in pairs(waitList or {}) do
		coroutine.resume(thread, Unpack.get(args))
	end
end

function Event:Destroy()
	for i, connection in pairs(self.Connections or {}) do
		connection:Disconnect()
	end
	self.Listeners = nil
	self.Waiting = nil
	self = nil
end

function Event:Connect(fn)
	local connection = Connection.new(self.Listeners, self)
	self.Listeners[connection] = fn
	table.insert(self.Connections, connection)
	return connection
end

function Event:Disconnect(connection)
	self.Listeners[connection] = nil
end

function Event:Wait(timeout, default)
	assert(typeof(timeout) == "number", "Timeout (number) required for wait time.")
	local current_thread = coroutine.running()
	self.Waiting[current_thread] = true
	Library.Timer(timeout)
	self.Waiting[current_thread] = nil
	coroutine.resume(current_thread, default)
end

return Event
