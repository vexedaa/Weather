local Weather = {}
Weather.__index = Weather

local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utilities = ReplicatedStorage:WaitForChild("Utilities")
local Colors = require(Utilities:WaitForChild("Colors"))
local Event = require(Utilities:WaitForChild("Event"))
local WeatherPresets = ReplicatedStorage:WaitForChild("WeatherPresets")
local GenericWeatherPreset = require(WeatherPresets:WaitForChild("GenericWeatherPreset"))

function Weather.new()
    local self = {
        --Weather preset module
        _CurrentPreset = nil;
        _CurrentPresetName = nil;
        _TweenInfo = TweenInfo.new(10, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0);
        _PresetChanged = Event.new();
    }
    setmetatable(self, Weather)
    return self
end

function Weather:GetCurrentPreset()
    return self._CurrentPreset
end

function Weather:GetCurrentPresetName()
    return self._CurrentPresetName
end

function Weather:SetPreset(preset)
    local oldPreset = self._CurrentPreset
    local getPreset = WeatherPresets:FindFirstChild(preset)
    if getPreset then
        local activePreset = require(getPreset).new()
        self._CurrentPreset = activePreset
        self._CurrentPresetName = preset
        activePreset._Initialize()
        self:FadePresets(oldPreset or GenericWeatherPreset.new(), activePreset, 1)
        self._PresetChanged:Fire({preset})
    end
end

function Weather:SetFadedPreset(presetFromName, presetToName, fadeAmount)
    self:SetPreset(presetFromName)
    local oldPreset = self._CurrentPreset
    local getPreset = WeatherPresets:FindFirstChild(presetToName)
    if getPreset then
        local activePreset = require(getPreset).new()
        self._CurrentPreset = activePreset
        self._CurrentPresetName = presetToName
        activePreset._Initialize()
        self:FadePresets(oldPreset, activePreset, fadeAmount or 0)
        local dominantPreset = presetToName
        if fadeAmount < 0.5 then
            dominantPreset = presetFromName
        end
        self._PresetChanged:Fire({dominantPreset})
    end
end

function Weather:TweenProperty(instance, propertyName, value)
    local tween = TweenService:Create(instance, self._TweenInfo, {[propertyName] = value})
    tween:Play()
end

function Weather:EvaluateProperties(propertyFrom, propertyTo, fadeAmount)
    local getType = typeof(propertyFrom)
    if propertyFrom and propertyTo then
        if getType == "Color3" then
            return Colors.Lerp(propertyFrom, propertyTo, fadeAmount)
        elseif getType == "number" then
            return (propertyFrom + (propertyTo - propertyFrom) * fadeAmount)
        end
    else
        if getType == "number" and propertyTo == nil then
            return (propertyFrom + (0 - propertyFrom) * fadeAmount)
        elseif propertyFrom == nil and typeof(propertyTo) == "number" then
            return (0 + (propertyTo - 0) * fadeAmount)
        end
        return propertyTo
    end
end

function Weather:FadePresets(presetFrom, presetTo, fadeAmount)
    for service, propertySet in pairs(presetFrom._Services) do
        for propertyName, propertyFrom in pairs(propertySet) do
            local propertyTo = presetTo._Services[service][propertyName]
            local result = self:EvaluateProperties(propertyFrom, propertyTo, fadeAmount or 0)
            if result then
                self:TweenProperty(service, propertyName, result)
            else
                self:TweenProperty(service, propertyName, GenericWeatherPreset.new()._Services[service][propertyName])
            end
        end
    end
    for weatherGlobal, propertySet in pairs(presetFrom._WeatherGlobals) do
        local parent = propertySet.Parent
        local className = propertySet.ClassName
        local find = parent:FindFirstChildWhichIsA(className)
        if not find then
            find = Instance.new(className)
            find.Parent = parent
        end
        for propertyName, propertyFrom in pairs(propertySet) do
            if propertyName ~= "Parent" and propertyName ~= "ClassName" then
                local propertyTo = presetTo._WeatherGlobals[weatherGlobal][propertyName]
                local result = self:EvaluateProperties(propertyFrom, propertyTo, fadeAmount)
                if result then
                    self:TweenProperty(find, propertyName, result)
                else
                    self:TweenProperty(find, propertyName, GenericWeatherPreset.new()._WeatherGlobals[weatherGlobal][propertyName])
                end
            end
        end
    end
    local getWeatherSounds = SoundService:FindFirstChild("WeatherSounds")
    if not getWeatherSounds then
        getWeatherSounds = Instance.new("Folder")
        getWeatherSounds.Name = "WeatherSounds"
        getWeatherSounds.Parent = SoundService
    end

    for soundName, propertySet in pairs(presetTo._Sounds) do
        local getSound = getWeatherSounds:FindFirstChild(soundName)
        if not getSound then
            getSound = Instance.new("Sound")
            getSound.Name = soundName
            getSound.Parent = getWeatherSounds
            getSound.SoundId = propertySet.SoundId
            getSound.Volume = 0
            getSound.Looped = propertySet.Looped
            getSound:Play()
        end
        local volumeFrom = nil
        local volumeTo = nil
        local getFrom = presetFrom._Sounds[soundName]
        local getTo = presetTo._Sounds[soundName]
        if getFrom then
            volumeFrom = getFrom.Volume
        end
        if getTo then
            volumeTo = getTo.Volume
        end
        
        local result = self:EvaluateProperties(volumeFrom, volumeTo, fadeAmount)
        self:TweenProperty(getSound, "Volume", result)
    end
    for soundName, _ in pairs(presetFrom._Sounds) do
        local getSound = getWeatherSounds:FindFirstChild(soundName)
        if getSound then
            local checkSound = presetTo._Sounds[soundName]
            if not checkSound then
                local volumeFrom = nil
                local volumeTo = nil
                local getFrom = presetFrom._Sounds[soundName]
                local getTo = presetTo._Sounds[soundName]
                if getFrom then
                    volumeFrom = getFrom.Volume
                end
                if getTo then
                    volumeTo = getTo.Volume
                end

                local result = self:EvaluateProperties(volumeFrom, volumeTo, fadeAmount) or 0
                self:TweenProperty(getSound, "Volume", result)
                if result == 0 then
                    task.spawn(function()
                        local currentPreset = self._CurrentPreset
                        task.wait(self._TweenInfo.Time)
                        if self._CurrentPreset == currentPreset then
                            getSound:Destroy()
                        end
                    end)
                end
            end
        end
    end
    for _, sound in pairs(getWeatherSounds:GetChildren()) do
        if presetFrom._Sounds[sound.Name] == nil and presetTo._Sounds[sound.Name] == nil then
            local result = self:EvaluateProperties(sound.Volume, 0, 1)
            self:TweenProperty(sound, "Volume", result)
            if result == 0 then
                task.spawn(function()
                    local currentPreset = self._CurrentPreset
                    task.wait(self._TweenInfo.Time)
                    if self._CurrentPreset == currentPreset then
                        sound:Destroy()
                    end
                end)
            end
        end
    end

end

local Singleton = Weather.new()
Singleton:SetPreset("ClearSkiesDay")
return Singleton