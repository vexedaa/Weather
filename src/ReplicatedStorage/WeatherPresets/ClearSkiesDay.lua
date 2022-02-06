local presetsFolder = script.Parent
local GenericWeatherPreset = require(presetsFolder:WaitForChild("GenericWeatherPreset"))

local ClearSkiesDay = {}
ClearSkiesDay.__index = ClearSkiesDay
setmetatable(ClearSkiesDay, GenericWeatherPreset)

function ClearSkiesDay.new()
    local self = GenericWeatherPreset.new()
    setmetatable(self, ClearSkiesDay)

    self._Services = {
        [game:GetService("Lighting")] = {
            Ambient = Color3.fromRGB(70, 70, 70);
            Brightness = 3;
            ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
            ColorShift_Top = Color3.fromRGB(0, 0, 0);
            EnvironmentDiffuseScale = 1;
            EnvironmentSpecularScale = 1;
            OutdoorAmbient = Color3.fromRGB(70, 70, 70);
            ShadowSoftness = 0.2;
            ClockTime = 14.5;
            GeographicLatitude = 0;
            ExposureCompensation = 0;
        };
    };

    self._WeatherGlobals = {
        _Clouds = {
            Parent = workspace.Terrain;
            ClassName = "Clouds";
            Cover = 0.5;
            Density = 0.7;
            Color = Color3.fromRGB(255, 255, 255)
        };

        _Atmosphere = {
            Parent = game:GetService("Lighting");
            ClassName = "Atmosphere";
            Density = 0.3;
            Offset = 0.25;
            Color = Color3.fromRGB(199, 199, 199);
            Decay = Color3.fromRGB(106, 112, 125);
            Glare = 0;
            Haze = 0;
        };
    };

    self._Sounds = {
        
    };

    --Presets can include other presets
    self._PresetDependencies = {};

    self._ActivePresets = {};

    self._Connections = {};
    print("Clear Skies", self)
    return self
end

return ClearSkiesDay
