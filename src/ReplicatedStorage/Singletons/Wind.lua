local Wind = {}
Wind.__index = Wind

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utilities = ReplicatedStorage:WaitForChild("Utilities")
local FuncLib = require(Utilities:WaitForChild("FuncLib"))

function Wind.new()
    local self = {}
    setmetatable(self, Wind)
    self._TimeSpeed = 0.00125
    self._TimeSpeed = .01
    return self
end

function Wind:GetGlobalWindAt(pos)
    local currentTime = DateTime.now().UnixTimestampMillis * self._TimeSpeed
    local objectCenterX, objectCenterY, objectCenterZ = pos.X, pos.Y, pos.Z

    local x = (2 * math.sin(1 * (objectCenterX + objectCenterY + objectCenterZ + currentTime))) + 1
    local z = (1 * math.sin(2 * (objectCenterX + objectCenterY + objectCenterZ + currentTime))) + 0.5
    local y = 0
    return x, y, z
end

function Wind:GetViewDisplacement(obj)
    local dotProduct = workspace.CurrentCamera.CFrame.LookVector:Dot(Vector3.new(0, 1, 0))
    local angle = math.acos(dotProduct)
    return angle --(Vector3.new(0, 1, 0) * workspace.CurrentCamera.CFrame.LookVector) * obj.PrimaryPart.Position.Y
end

-- function Wind:GetLocalMotion(object)
    
-- end

local Singleton = Wind.new()
return Singleton