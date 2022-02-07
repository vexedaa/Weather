local presetsFolder = script.Parent
local GenericWeatherPreset = require(presetsFolder:WaitForChild("GenericWeatherPreset"))

local SnowstormDay = {}
SnowstormDay.__index = SnowstormDay
setmetatable(SnowstormDay, GenericWeatherPreset)

function SnowstormDay.new()
    local self = GenericWeatherPreset.new()
    setmetatable(self, SnowstormDay)

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
            ClockTime = 14.5;
            GeographicLatitude = 0;
            ExposureCompensation = 0;
        };
    };

    self._WeatherGlobals = {
        _Clouds = {
            Parent = workspace.Terrain;
            ClassName = "Clouds";
            Cover = 1;
            Density = 0.369;
            Color = Color3.fromRGB(221, 221, 221)
        };

        _Atmosphere = {
            Parent = game:GetService("Lighting");
            ClassName = "Atmosphere";
            Density = 0.462;
            Offset = 0;
            Color = Color3.fromRGB(124, 127, 130);
            Decay = Color3.fromRGB(207, 215, 220);
            Glare = 0.31;
            Haze = 10;
        };

        _ColorCorrectionEffect = {
            Parent = game:GetService("Lighting");
            ClassName = "ColorCorrectionEffect";
            Brightness = 0;
            Contrast = 0.3;
            Saturation = 0;
            TintColor = Color3.fromRGB(195, 205, 218)
        }
    };

    self._Sounds = {
        
    };

    --Presets can include other presets
    self._PresetDependencies = {};

    self._ActivePresets = {};

    self._Connections = {};
    return self
end

function SnowstormDay:_Initialize()
    GenericWeatherPreset._Initialize(self)
    local grid = self.AtmosphericParticleGrid.new(9, 15, 1, 50, self.ParticleLayers.DefaultParticleLayers)
    table.insert(self._ActiveParticleGrids, grid)
end

return SnowstormDay
