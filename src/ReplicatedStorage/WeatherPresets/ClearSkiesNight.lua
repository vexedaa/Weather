local presetsFolder = script.Parent
local GenericWeatherPreset = require(presetsFolder:WaitForChild("GenericWeatherPreset"))

local ClearSkiesNight = {}
ClearSkiesNight.__index = ClearSkiesNight
setmetatable(ClearSkiesNight, GenericWeatherPreset)

function ClearSkiesNight.new()
    local self = GenericWeatherPreset.new()
    setmetatable(self, ClearSkiesNight)

    self._Services = {
        [game:GetService("Lighting")] = {
            Ambient = Color3.fromRGB(70, 70, 70);
            Brightness = 3;
            ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
            ColorShift_Top = Color3.fromRGB(0, 0, 0);
            EnvironmentDiffuseScale = 1;
            EnvironmentSpecularScale = 1;
            OutdoorAmbient = Color3.fromRGB(62, 62, 62);
            ShadowSoftness = 0.2;
            ClockTime = 18.5;
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
            Density = 0.523;
            Offset = 0.25;
            Color = Color3.fromRGB(199, 161, 168);
            Decay = Color3.fromRGB(106, 112, 125);
            Glare = 0;
            Haze = 2.46;
        };
    };

    self._Sounds = {
        
    };

    --Presets can include other presets
    self._PresetDependencies = {};

    self._ActivePresets = {};

    self._Connections = {};
    return self
end

return ClearSkiesNight
