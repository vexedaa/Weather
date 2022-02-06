local SetWeatherPreset = {}
SetWeatherPreset.__index = SetWeatherPreset
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Singletons = ReplicatedStorage:WaitForChild("Singletons")
local Weather = require(Singletons:WaitForChild("Weather"))

local Services = ReplicatedStorage:WaitForChild("Services")
local TagService = require(Services:WaitForChild("TagService"))

function SetWeatherPreset.new(element)
    local self = {
        _Element = element;
        _WeatherPreset = nil;
    }
    setmetatable(self, SetWeatherPreset)
    self:_Initialize()
    return self
end

function SetWeatherPreset:_Initialize()
    local preset = self._Element:WaitForChild("Preset")
    local apply = self._Element:WaitForChild("Apply")
    apply.MouseButton1Click:Connect(function()
        Weather:SetPreset(preset.Text)
    end)
end

TagService.HookAddedSignal("SetWeatherPreset", function(element)
    SetWeatherPreset.new(element)
end)

return SetWeatherPreset