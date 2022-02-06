local Weather = {}
Weather.__index = Weather

local TweenService = game:GetService("TweenService")

function Weather.new()
    local self = {
        --Weather preset module
        _CurrentWeatherPreset = nil;
        _TweenInfo = TweenInfo.new(.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
    }
    setmetatable(self, Weather)
    return self
end

function Weather:SetPreset(preset)
    --
end

function Weather:FadePresets(presetFrom, presetTo, fadeAmount)
    
end

local Singleton = Weather.new()
return Singleton