local WeatherPreset = {}
WeatherPreset.__index = WeatherPreset

function WeatherPreset.new()
    local self = {
        _Services = {
            [game:GetService("Lighting")] = {
                Ambient = Color3.fromRGB(70, 70, 70);
                Brightness = 3;
                ColorShift_Bottom = Color3.fromRGB(0, 0, 0);
                Colorshift_Top = Color3.fromRGB(0, 0, 0);
                EnvironmentDiffuseScale = 1;
                EnvironmentSpecularScale = 1;
                GlobalShadows = true;
                OutdoorAmbient = Color3.fromRGB(70, 70, 70);
                ShadowSoftness = 0.2;
                Technology = Enum.Technology.ShadowMap;
                ClockTime = 14.5;
                GeographicLatitude = 0;
                ExposureCompensation = 0;
            };
        };
        _Instances = {
            _Clouds = {
                Parent = workspace.Terrain;
                
                Cover = 0.5;
                Density = 0.7;
                Color = Color3.fromRGB(255, 255, 255)
            };
    
            _Atmosphere = {
                Parent = game:GetService("Lighting");

                Density = 0.3;
                Offset = 0.25;
                Color = Color3.fromRGB(199, 199, 199);
                Decay = Color3.fromRGB(106, 112, 125);
                Glare = 0;
                Haze = 0;
            };
        };
        Dependencies = {
            --Particle system used for the weather preset (e.g. rain, snow, dust storms effects, etc.)
            _ParticleSystem = nil;
        }
    }
    setmetatable(self, WeatherPreset)
    self:_Initialize()
    return self
end

function WeatherPreset:_Initialize()
    --Intentionally left blank for now
    for _, _ in pairs(self._Dependencies) do
        --require(dependency)._Initialize(self)
    end
end

return WeatherPreset