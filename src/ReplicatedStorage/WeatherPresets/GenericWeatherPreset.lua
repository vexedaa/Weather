local GenericWeatherPreset = {}
GenericWeatherPreset.__index = GenericWeatherPreset

function GenericWeatherPreset.new()
    local self = {}

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

    setmetatable(self, GenericWeatherPreset)
    self:_Initialize()
    return self
end

function GenericWeatherPreset:Clean()
    --Clear all connections
    for _, connection in pairs(self._Connections) do
        connection:Disconnect()
    end
    for _, dependency in pairs(self._PresetDependencies) do
        dependency:Clean()
    end
end

function GenericWeatherPreset:_Initialize()
    --Intentionally left blank for now
    print(self)
    if self and self._PresetDependencies then
        for _, presetDependency in pairs(self._PresetDependencies) do
            local success, result = pcall(function()
                local activePresetDependency = require(presetDependency).new()
                table.insert(self._ActivePresets, activePresetDependency)
            end)
            if success == false then
                warn("Failed to load sub-preset", result)
            end
        end
    end
end

return GenericWeatherPreset