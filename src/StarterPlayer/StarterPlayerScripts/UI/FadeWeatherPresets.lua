local FadeWeatherPresets = {}
FadeWeatherPresets.__index = FadeWeatherPresets
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Singletons = ReplicatedStorage:WaitForChild("Singletons")
local Weather = require(Singletons:WaitForChild("Weather"))

local Services = ReplicatedStorage:WaitForChild("Services")
local TagService = require(Services:WaitForChild("TagService"))

function FadeWeatherPresets.new(element)
    local self = {
        _Element = element;
        _WeatherPreset1 = nil;
        _WeatherPreset2 = nil;
        _FadeWeight = nil;
    }
    setmetatable(self, FadeWeatherPresets)
    self:_Initialize()
    return self
end

function FadeWeatherPresets:_Initialize()
    local preset1 = self._Element:WaitForChild("Preset1")
    local preset2 = self._Element:WaitForChild("Preset2")
    local fadeWeight = self._Element:WaitForChild("FadeWeight")
    local apply = self._Element:WaitForChild("Apply")
    apply.MouseButton1Click:Connect(function()
        Weather:SetFadedPreset(preset1.Text, preset2.Text, tonumber(fadeWeight.Text))
    end)
end

TagService.HookAddedSignal("FadeWeatherPresets", function(element)
    FadeWeatherPresets.new(element)
end)

return FadeWeatherPresets