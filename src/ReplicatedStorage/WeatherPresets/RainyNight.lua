local presetsFolder = script.Parent
local GenericWeatherPreset = require(presetsFolder:WaitForChild("GenericWeatherPreset"))

local RainyNight = {}
RainyNight.__index = RainyNight
setmetatable(RainyNight, GenericWeatherPreset)

function RainyNight.new()
    local self = GenericWeatherPreset.new()
    setmetatable(self, RainyNight)

    self._Services = {
        [game:GetService("Lighting")] = {
            Ambient = Color3.fromRGB(70, 70, 70);
            Brightness = 3;
            ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
            ColorShift_Top = Color3.fromRGB(0, 0, 0);
            EnvironmentDiffuseScale = 1;
            EnvironmentSpecularScale = 1;
            OutdoorAmbient = Color3.fromRGB(70, 70, 70);
            ShadowSoftness = 1;
            ClockTime = 18.5;
            GeographicLatitude = 0;
            ExposureCompensation = 0;
        };
    };

    self._WeatherGlobals = {
        _Clouds = {
            Parent = workspace.Terrain;
            ClassName = "Clouds";
            Cover = 0.75;
            Density = 0.7;
            Color = Color3.fromRGB(25, 25, 25)
        };

        _Atmosphere = {
            Parent = game:GetService("Lighting");
            ClassName = "Atmosphere";
            Density = 0.3;
            Offset = 0.25;
            Color = Color3.fromRGB(199, 199, 199);
            Decay = Color3.fromRGB(106, 112, 125);
            Glare = .15;
            Haze = 3.08;
        };
    };

    self._Sounds = {
        ["Rain"] = {
            Volume = 0.75;
            Looped = true;
            SoundId = "rbxassetid://5808527322";
        }
    };

    --Presets can include other presets
    self._PresetDependencies = {};

    self._ActivePresets = {};

    self._Connections = {};
    return self
end

return RainyNight
