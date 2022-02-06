local Weather = {}
Weather.__index = Weather

local TweenService = game:GetService("TweenService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utility = ReplicatedStorage:WaitForChild("Utility")
local Event = require(Utility:WaitForChild("Event"))
local WeatherPresets = ReplicatedStorage:WaitForChild("WeatherPresets")

function Weather.new()
    local self = {
        --Weather preset module
        _CurrentWeatherPreset = nil;
        _TweenInfo = TweenInfo.new(.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
        _PresetChanged = Event.new();
    }
    setmetatable(self, Weather)
    return self
end

function Weather:SetPreset(preset)
    
end

function Weather:FadePresets(presetFrom, presetTo, fadeAmount)
    
end

local Singleton = Weather.new()
Singleton:SetPreset("ClearSkiesDay")
return Singleton